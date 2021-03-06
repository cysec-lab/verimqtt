module Main

module B = LowStar.Buffer
module U8 = FStar.UInt8
module U32 = FStar.UInt32

open FStar.HyperStack.ST
open LowStar.BufferOps
open LowStar.Printf
open FStar.Int.Cast
open C.String
open FFI
open C

open Const
open Common
open Publish
open Connect
open Disconnect
open Debug

#set-options "--z3rlimit 1000 --max_fuel 0 --max_ifuel 0 --detail_errors"

val mqtt_packet_parse (packet_data: B.buffer U8.t) (packet_size: type_packet_size):
  Stack parse_result
    (requires (fun h -> logic_packet_data h packet_data packet_size))
    (ensures (fun h0 _ h1 -> B.live h0 packet_data /\ B.live h1 packet_data))
let mqtt_packet_parse packet_data packet_size =
  let share_common_data_check: struct_share_common_data_check =
     share_common_data_check packet_data packet_size in
  if (share_common_data_check.share_common_data_have_error) then
    (
      share_common_data_check.share_common_data_error
    )
  else
    (
      let share_common_data: struct_share_common_data = share_common_data_check.share_common_data in
      if (U8.eq share_common_data.common_message_type define_mqtt_control_packet_PUBLISH &&
          U32.gte share_common_data.common_packet_size 3ul &&
          U32.lt share_common_data.common_next_start_index (U32.sub share_common_data.common_packet_size 3ul)) then
        (
          publish_packet_parse_result share_common_data
        )
      else if (U8.eq share_common_data.common_message_type define_mqtt_control_packet_CONNECT &&
          U32.gte share_common_data.common_packet_size 6ul &&
          U32.lt share_common_data.common_next_start_index (U32.sub share_common_data.common_packet_size 6ul)) then
        (
          connect_packet_parse_result share_common_data
        )
      else if (U8.eq share_common_data.common_message_type define_mqtt_control_packet_DISCONNECT &&
          U32.lt share_common_data.common_next_start_index share_common_data.common_packet_size) then
        (
          disconnect_packet_parse_result share_common_data
        )
      else
        (
          let error_struct: struct_error_struct =
            {
                code = define_error_message_type_invalid_code;
                message = define_error_message_type_invalid;
            } in
          unimplemented "Unknown Packet type.\n";
          error_parse_result error_struct
        )
    )
#reset-options
