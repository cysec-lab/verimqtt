module Main

module B = LowStar.Buffer
module UT = Utils
module U32 = FStar.UInt32
module U8 = FStar.UInt8

open FStar.HyperStack.ST
open LowStar.BufferOps
open LowStar.Printf
open FStar.Int.Cast
open C.String
open C

#reset-options "--z3rlimit 500 --initial_fuel 0 --max_fuel 0 --initial_ifuel 0 --max_ifuel 0"

val max_u32: U32.t
let max_u32 = 4294967295ul

val max_u8: U8.t
let max_u8 = 255uy

val max_request_size: U32.t
let max_request_size = 268435461ul

val min_request_size: U32.t
let min_request_size = 0ul

val max_packet_size: U32.t
let max_packet_size = 268435460ul

val max_payload_size: U32.t
let max_payload_size = 268435455ul

val min_packet_size: U32.t
let min_packet_size = 2ul

type type_packet_size =
  packet_size:
    U32.t{U32.v packet_size >= U32.v min_packet_size && U32.v packet_size <= U32.v max_packet_size}
type type_mqtt_control_packets = U8.t
let define_mqtt_control_packet_CONNECT : type_mqtt_control_packets = 1uy
let define_mqtt_control_packet_CONNACK : type_mqtt_control_packets = 2uy
let define_mqtt_control_packet_PUBLISH : type_mqtt_control_packets = 3uy
let define_mqtt_control_packet_PUBACK : type_mqtt_control_packets = 4uy
let define_mqtt_control_packet_PUBREC : type_mqtt_control_packets = 5uy
let define_mqtt_control_packet_PUBREL : type_mqtt_control_packets = 6uy
let define_mqtt_control_packet_PUBCOMP : type_mqtt_control_packets = 7uy
let define_mqtt_control_packet_SUBSCRIBE : type_mqtt_control_packets = 8uy
let define_mqtt_control_packet_SUBACK : type_mqtt_control_packets = 9uy
let define_mqtt_control_packet_UNSUBSCRIBE : type_mqtt_control_packets = 10uy
let define_mqtt_control_packet_UNSUBACK : type_mqtt_control_packets = 11uy
let define_mqtt_control_packet_PINGREQ : type_mqtt_control_packets = 12uy
let define_mqtt_control_packet_PINGRESP : type_mqtt_control_packets = 13uy
let define_mqtt_control_packet_DISCONNECT : type_mqtt_control_packets = 14uy
let define_mqtt_control_packet_AUTH : type_mqtt_control_packets = 15uy

type type_mqtt_control_packet_label = C.String.t
let define_mqtt_control_packet_CONNECT_label : type_mqtt_control_packet_label = !$"CONNECT"
let define_mqtt_control_packet_CONNACK_label : type_mqtt_control_packet_label = !$"CONNACK"
let define_mqtt_control_packet_PUBLISH_label : type_mqtt_control_packet_label = !$"PUBLISH"
let define_mqtt_control_packet_PUBACK_label : type_mqtt_control_packet_label = !$"PUBACK"
let define_mqtt_control_packet_PUBREC_label : type_mqtt_control_packet_label = !$"PUBREC"
let define_mqtt_control_packet_PUBREL_label : type_mqtt_control_packet_label = !$"PUBREL"
let define_mqtt_control_packet_PUBCOMP_label : type_mqtt_control_packet_label = !$"PUBCOMP"
let define_mqtt_control_packet_SUBSCRIBE_label : type_mqtt_control_packet_label = !$"SUBSCRIBE"
let define_mqtt_control_packet_SUBACK_label : type_mqtt_control_packet_label = !$"SUBACK"
let define_mqtt_control_packet_UNSUBSCRIBE_label : type_mqtt_control_packet_label = !$"UNSUBSCRIBE"
let define_mqtt_control_packet_UNSUBACK_label : type_mqtt_control_packet_label = !$"UNSUBACK"
let define_mqtt_control_packet_PINGREQ_label : type_mqtt_control_packet_label = !$"PINGREQ"
let define_mqtt_control_packet_PINGRESP_label : type_mqtt_control_packet_label = !$"PINGRESP"
let define_mqtt_control_packet_DISCONNECT_label : type_mqtt_control_packet_label = !$"DISCONNECT"
let define_mqtt_control_packet_AUTH_label : type_mqtt_control_packet_label = !$"AUTH"
type type_message_name_restrict =
  v:type_mqtt_control_packet_label{
    v = define_mqtt_control_packet_CONNECT_label ||
    v = define_mqtt_control_packet_CONNACK_label ||
    v = define_mqtt_control_packet_PUBLISH_label ||
    v = define_mqtt_control_packet_PUBACK_label ||
    v = define_mqtt_control_packet_PUBREC_label ||
    v = define_mqtt_control_packet_PUBREL_label ||
    v = define_mqtt_control_packet_PUBCOMP_label ||
    v = define_mqtt_control_packet_SUBSCRIBE_label ||
    v = define_mqtt_control_packet_SUBACK_label ||
    v = define_mqtt_control_packet_UNSUBSCRIBE_label ||
    v = define_mqtt_control_packet_UNSUBACK_label ||
    v = define_mqtt_control_packet_PINGREQ_label ||
    v = define_mqtt_control_packet_PINGRESP_label ||
    v = define_mqtt_control_packet_DISCONNECT_label ||
    v = define_mqtt_control_packet_AUTH_label ||
    v = !$""
  }

type type_mqtt_control_packets_restrict =
  v:type_mqtt_control_packets{U8.v v >= 1 && U8.v v <= 15 || U8.eq v max_u8}
type type_flags = U8.t

let define_flag_CONNECT : type_flags = 0b0000uy
let define_flag_CONNACK : type_flags = 0b0000uy

let define_flag_PUBACK : type_flags = 0b0000uy
let define_flag_PUBREC : type_flags = 0b0000uy
let define_flag_PUBREL : type_flags = 0b0010uy
let define_flag_PUBCOMP : type_flags = 0b0000uy
let define_flag_SUBSCRIBE : type_flags = 0b0010uy
let define_flag_SUBACK : type_flags = 0b0000uy
let define_flag_UNSUBSCRIBE : type_flags = 0b0010uy
let define_flag_UNSUBACK : type_flags = 0b0000uy
let define_flag_PINGREQ : type_flags = 0b0000uy
let define_flag_PINGRESP : type_flags = 0b0000uy
let define_flag_DISCONNECT : type_flags = 0b0000uy
let define_flag_AUTH : type_flags = 0b0000uy
type type_dup_flags = U8.t

let define_dup_flag_first_delivery : type_dup_flags = 0uy
let define_dup_flag_re_delivery : type_dup_flags = 1uy

type type_dup_flags_restrict =
  dup_flag: type_dup_flags{U8.v dup_flag <= 1 || U8.eq dup_flag max_u8}
type type_qos_flags = U8.t

let define_qos_flag_at_most_once_delivery : type_qos_flags = 0b00uy
let define_qos_flag_at_least_once_delivery : type_qos_flags = 0b01uy
let define_qos_flag_exactly_once_delivery : type_qos_flags = 0b10uy

type type_qos_flags_restrict =
  qos_flag: type_qos_flags{U8.v qos_flag <= 2 || U8.eq qos_flag max_u8}
type type_retain_flags = U8.t

let define_retain_flag_must_not_store_application_message : type_retain_flags = 0uy
let define_retain_flag_must_store_application_message : type_retain_flags = 1uy

type type_retain_flags_restrict =
  retain_flag: type_retain_flags{U8.v retain_flag <= 1 || U8.eq retain_flag max_u8}

type type_flag_restrict =
  flag: U8.t{
    U8.eq flag 0b0000uy ||
    U8.eq flag 0b0010uy ||
    U8.eq flag max_u8
}

type type_remaining_length =
  (remaining_length: U32.t{U32.v remaining_length <= U32.v (U32.sub max_packet_size 5ul) || U32.eq remaining_length max_u32})

type type_topic_length_restrict =
  (topic_length_restrict: U32.t{U32.v topic_length_restrict <= 65535 || U32.eq topic_length_restrict max_u32})

type type_topic_name_restrict =
  (
    topic_name: C.String.t{U32.v (strlen topic_name) <= 65535}
  )

type type_property_length = type_remaining_length

type type_payload_offset = payload_offset: U32.t{U32.v payload_offset < U32.v max_packet_size}

type type_payload_restrict =
  (
    payload: C.String.t{U32.v (strlen payload) <= U32.v max_packet_size}
  )

type type_disconnect_reason_code = U8.t
let define_disconnect_reason_code_normal_disconnection: type_disconnect_reason_code = 0uy
let define_disconnect_reason_code_disconnect_with_will_message: type_disconnect_reason_code = 4uy
let define_disconnect_reason_code_unspecified_error: type_disconnect_reason_code = 128uy
let define_disconnect_reason_code_malformed_packet: type_disconnect_reason_code = 129uy
let define_disconnect_reason_code_protocol_error: type_disconnect_reason_code = 130uy
let define_disconnect_reason_code_implementation_specific_error: type_disconnect_reason_code = 131uy
let define_disconnect_reason_code_not_authorized: type_disconnect_reason_code = 135uy
let define_disconnect_reason_code_server_busy: type_disconnect_reason_code = 137uy
let define_disconnect_reason_code_server_shutting_down: type_disconnect_reason_code = 139uy
let define_disconnect_reason_code_keep_alive_timeout: type_disconnect_reason_code = 141uy
let define_disconnect_reason_code_session_taken_over: type_disconnect_reason_code = 142uy
let define_disconnect_reason_code_topic_filter_invalid: type_disconnect_reason_code = 143uy
let define_disconnect_reason_code_topic_name_invalid: type_disconnect_reason_code = 144uy
let define_disconnect_reason_receive_maximum_exceeded: type_disconnect_reason_code = 147uy
let define_disconnect_reason_topic_alias_invalid: type_disconnect_reason_code = 148uy
let define_disconnect_reason_packet_too_large: type_disconnect_reason_code = 149uy
let define_disconnect_reason_message_rate_too_high: type_disconnect_reason_code = 150uy
let define_disconnect_reason_quota_exceeded: type_disconnect_reason_code = 151uy
let define_disconnect_reason_administrative_action: type_disconnect_reason_code = 152uy
let define_disconnect_reason_payload_format_invalid: type_disconnect_reason_code = 153uy
let define_disconnect_reason_retain_not_supported: type_disconnect_reason_code = 154uy
let define_disconnect_reason_qos_not_supported: type_disconnect_reason_code = 155uy
let define_disconnect_reason_use_another_server: type_disconnect_reason_code = 156uy
let define_disconnect_reason_server_moved: type_disconnect_reason_code = 157uy
let define_disconnect_reason_shared_subscriptions_not_supported: type_disconnect_reason_code = 158uy
let define_disconnect_reason_connection_rate_exceeded: type_disconnect_reason_code = 159uy
let define_disconnect_reason_maximum_connect_time: type_disconnect_reason_code = 160uy
let define_disconnect_reason_subscription_identifiers_not_supported: type_disconnect_reason_code = 161uy
let define_disconnect_reason_wildcard_subscriptions_not_supported: type_disconnect_reason_code = 162uy

type struct_connect_property = {
    connect_property_id: U8.t;
    connect_property_name: C.String.t;
}

let define_connect_property_session_expiry_interval_id: U8.t = 0x11uy
let define_connect_property_receive_maximum_id: U8.t = 0x21uy
let define_connect_property_maximum_packet_size_id: U8.t = 0x27uy
let define_connect_property_topic_alias_maximum_id: U8.t = 0x22uy
let define_connect_property_request_response_information_id: U8.t = 0x19uy
let define_connect_property_request_problem_information_id: U8.t = 0x17uy
let define_connect_property_user_property_id: U8.t = 0x26uy
let define_connect_property_authentication_method_id: U8.t = 0x15uy
let define_connect_property_authentication_data_id: U8.t = 0x16uy

let define_struct_connect_property_session_expiry_interval: struct_connect_property =
  {
    connect_property_id = define_connect_property_session_expiry_interval_id;
    connect_property_name = !$"Session Expiry Interval";
  }

let define_struct_connect_property_receive_maximum: struct_connect_property =
  {
    connect_property_id = define_connect_property_receive_maximum_id;
    connect_property_name = !$"Receive Maximum";
  }

let define_struct_connect_property_maximum_packet_size: struct_connect_property =
  {
    connect_property_id = define_connect_property_maximum_packet_size_id;
    connect_property_name = !$"Maximum Packet Size";
  }

let define_struct_connect_property_topic_alias_maximum: struct_connect_property =
  {
    connect_property_id = define_connect_property_topic_alias_maximum_id;
    connect_property_name = !$"Topic Alias Maximum";
  }

let define_struct_connect_property_request_response_information: struct_connect_property =
  {
    connect_property_id = define_connect_property_request_response_information_id;
    connect_property_name = !$"Request Response Information";
  }

let define_struct_connect_property_request_problem_information: struct_connect_property =
  {
    connect_property_id = define_connect_property_request_problem_information_id;
    connect_property_name = !$"Request Problem Information";
  }

let define_struct_connect_property_user_property: struct_connect_property =
  {
    connect_property_id = define_connect_property_user_property_id;
    connect_property_name = !$"User Property";
  }

let define_struct_connect_property_authentication_method: struct_connect_property =
  {
    connect_property_id = define_connect_property_authentication_method_id;
    connect_property_name = !$"Authentication Method";
  }

let define_struct_connect_property_authentication_data: struct_connect_property =
  {
    connect_property_id = define_connect_property_authentication_data_id;
    connect_property_name = !$"Authentication Data";
  }

type struct_connect_flags = {
      connect_flag: U8.t;
      user_name: U8.t;
      password: U8.t;
      will_retain: U8.t;
      will_qos: U8.t;
      will_flag: U8.t;
      clean_start: U8.t;
  }

// 3.1.2.3 Connect Flags
type struct_connect = {
  protocol_name: C.String.t;
  protocol_version: U8.t;
  flags: struct_connect_flags;
  keep_alive: U32.t;
  connect_topic_length: U32.t;
  connect_property: struct_connect_property;
}  


type type_disconnect_reason_code_name = C.String.t
let define_disconnect_reason_code_normal_disconnection_name: type_disconnect_reason_code_name = !$"Normal disconnection" 
let define_disconnect_reason_code_disconnect_with_will_message_name: type_disconnect_reason_code_name = !$"Disconnect with Will Message"
let define_disconnect_reason_code_unspecified_error_name: type_disconnect_reason_code_name = !$"Unspecified error"
let define_disconnect_reason_code_malformed_packet_name: type_disconnect_reason_code_name = !$"Malformed Packet"
let define_disconnect_reason_code_protocol_error_name: type_disconnect_reason_code_name = !$"Protocol Error"
let define_disconnect_reason_code_implementation_specific_error_name: type_disconnect_reason_code_name = !$"Implementation specific error"
let define_disconnect_reason_code_not_authorized_name: type_disconnect_reason_code_name = !$"Not authorized"
let define_disconnect_reason_code_server_busy_name: type_disconnect_reason_code_name = !$"Server busy"
let define_disconnect_reason_code_server_shutting_down_name: type_disconnect_reason_code_name = !$"Server shutting down"
let define_disconnect_reason_code_keep_alive_timeout_name: type_disconnect_reason_code_name = !$"Keep Alive timeout"
let define_disconnect_reason_code_session_taken_over_name: type_disconnect_reason_code_name = !$"Session taken over"
let define_disconnect_reason_code_topic_filter_invalid_name: type_disconnect_reason_code_name = !$"Topic Filter invalid"
let define_disconnect_reason_code_topic_name_invalid_name: type_disconnect_reason_code_name = !$"Topic Name invalid"
let define_disconnect_reason_receive_maximum_exceeded_name: type_disconnect_reason_code_name = !$"Receive Maximum exceeded"
let define_disconnect_reason_topic_alias_invalid_name: type_disconnect_reason_code_name = !$"Topic Alias invalid"
let define_disconnect_reason_packet_too_large_name: type_disconnect_reason_code_name = !$"Packet too large"
let define_disconnect_reason_message_rate_too_high_name: type_disconnect_reason_code_name = !$"Message rate too high"
let define_disconnect_reason_quota_exceeded_name: type_disconnect_reason_code_name = !$"Quota exceeded"
let define_disconnect_reason_administrative_action_name: type_disconnect_reason_code_name = !$"Administrative action"
let define_disconnect_reason_payload_format_invalid_name: type_disconnect_reason_code_name = !$"Payload format invalid"
let define_disconnect_reason_retain_not_supported_name: type_disconnect_reason_code_name = !$"Retain not supported"
let define_disconnect_reason_qos_not_supported_name: type_disconnect_reason_code_name = !$"QoS not supported"
let define_disconnect_reason_use_another_server_name: type_disconnect_reason_code_name = !$"Use another server"
let define_disconnect_reason_server_moved_name: type_disconnect_reason_code_name = !$"Server moved"
let define_disconnect_reason_shared_subscriptions_not_supported_name: type_disconnect_reason_code_name = !$"Shared Subscriptions not supported"
let define_disconnect_reason_connection_rate_exceeded_name: type_disconnect_reason_code_name = !$"Connection rate exceeded"
let define_disconnect_reason_maximum_connect_time_name: type_disconnect_reason_code_name = !$"Maximum connect time"
let define_disconnect_reason_subscription_identifiers_not_supported_name: type_disconnect_reason_code_name = !$"Subscription Identifiers not supported"
let define_disconnect_reason_wildcard_subscriptions_not_supported_name: type_disconnect_reason_code_name = !$"Wildcard Subscriptions not supported"

type struct_disconnect_reason = {
  disconnect_reason_code: type_disconnect_reason_code;
  disconnect_reason_code_name: type_disconnect_reason_code_name;
}

let define_struct_disconnect_normal_disconnection: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_code_normal_disconnection;
    disconnect_reason_code_name = define_disconnect_reason_code_normal_disconnection_name;
  }

let define_struct_disconnect_disconnect_with_will_message: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_code_disconnect_with_will_message;
    disconnect_reason_code_name = define_disconnect_reason_code_disconnect_with_will_message_name;
  }

let define_struct_disconnect_unspecified_error: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_code_unspecified_error;
    disconnect_reason_code_name = define_disconnect_reason_code_unspecified_error_name;
  }

let define_struct_disconnect_malformed_packet: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_code_malformed_packet;
    disconnect_reason_code_name = define_disconnect_reason_code_malformed_packet_name;
  }

let define_struct_disconnect_protocol_error: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_code_protocol_error;
    disconnect_reason_code_name = define_disconnect_reason_code_protocol_error_name;
  }

let define_struct_disconnect_implementation_specific_error: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_code_implementation_specific_error;
    disconnect_reason_code_name = define_disconnect_reason_code_implementation_specific_error_name;
  }

let define_struct_disconnect_not_authorized: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_code_not_authorized;
    disconnect_reason_code_name = define_disconnect_reason_code_not_authorized_name;
  }

let define_struct_disconnect_server_busy: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_code_server_busy;
    disconnect_reason_code_name = define_disconnect_reason_code_server_busy_name;
  }

let define_struct_disconnect_server_shutting_down: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_code_server_shutting_down;
    disconnect_reason_code_name = define_disconnect_reason_code_server_shutting_down_name;
  }

let define_struct_disconnect_keep_alive_timeout: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_code_keep_alive_timeout;
    disconnect_reason_code_name = define_disconnect_reason_code_keep_alive_timeout_name;
  }  

let define_struct_disconnect_session_taken_over: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_code_session_taken_over;
    disconnect_reason_code_name = define_disconnect_reason_code_session_taken_over_name;
  } 

let define_struct_disconnect_topic_filter_invalid: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_code_topic_filter_invalid;
    disconnect_reason_code_name = define_disconnect_reason_code_topic_filter_invalid_name;
  } 

let define_struct_disconnect_topic_name_invalid: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_code_topic_name_invalid;
    disconnect_reason_code_name = define_disconnect_reason_code_topic_name_invalid_name;
  } 

let define_struct_disconnect_receive_maximum_exceeded: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_receive_maximum_exceeded;
    disconnect_reason_code_name = define_disconnect_reason_receive_maximum_exceeded_name;
  } 

let define_struct_disconnect_topic_alias_invalid: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_topic_alias_invalid;
    disconnect_reason_code_name = define_disconnect_reason_topic_alias_invalid_name;
  } 

let define_struct_disconnect_packet_too_large: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_packet_too_large;
    disconnect_reason_code_name = define_disconnect_reason_packet_too_large_name;
  }   

let define_struct_disconnect_message_rate_too_high: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_message_rate_too_high;
    disconnect_reason_code_name = define_disconnect_reason_message_rate_too_high_name;
  }   

let define_struct_disconnect_quota_exceeded: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_quota_exceeded;
    disconnect_reason_code_name = define_disconnect_reason_quota_exceeded_name;
  }   

let define_struct_disconnect_administrative_action: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_administrative_action;
    disconnect_reason_code_name = define_disconnect_reason_administrative_action_name;
  }   

let define_struct_disconnect_payload_format_invalid: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_payload_format_invalid;
    disconnect_reason_code_name = define_disconnect_reason_payload_format_invalid_name;
  }   

let define_struct_disconnect_retain_not_supported: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_retain_not_supported;
    disconnect_reason_code_name = define_disconnect_reason_retain_not_supported_name;
  }   

let define_struct_disconnect_qos_not_supported: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_qos_not_supported;
    disconnect_reason_code_name = define_disconnect_reason_qos_not_supported_name;
  }   

let define_struct_disconnect_use_another_server: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_use_another_server;
    disconnect_reason_code_name = define_disconnect_reason_use_another_server_name;
  }   

let define_struct_disconnect_server_moved: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_server_moved;
    disconnect_reason_code_name = define_disconnect_reason_server_moved_name;
  }   

let define_struct_disconnect_shared_subscriptions_not_supported: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_shared_subscriptions_not_supported;
    disconnect_reason_code_name = define_disconnect_reason_shared_subscriptions_not_supported_name;
  }   

let define_struct_disconnect_connection_rate_exceeded: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_connection_rate_exceeded;
    disconnect_reason_code_name = define_disconnect_reason_connection_rate_exceeded_name;
  } 

let define_struct_disconnect_maximum_connect_time: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_maximum_connect_time;
    disconnect_reason_code_name = define_disconnect_reason_maximum_connect_time_name;
  } 

let define_struct_disconnect_subscription_identifiers_not_supported: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_subscription_identifiers_not_supported;
    disconnect_reason_code_name = define_disconnect_reason_subscription_identifiers_not_supported_name;
  } 

let define_struct_disconnect_wildcard_subscriptions_not_supported: struct_disconnect_reason =
  {
    disconnect_reason_code = define_disconnect_reason_wildcard_subscriptions_not_supported;
    disconnect_reason_code_name = define_disconnect_reason_wildcard_subscriptions_not_supported_name;
  } 

let define_struct_disconnect_error: struct_disconnect_reason =
  {
    disconnect_reason_code = max_u8;
    disconnect_reason_code_name = !$"";
  }

type type_error_message = C.String.t
let define_error_remaining_length_invalid: type_error_message = !$"remaining_length is invalid."
let define_error_message_type_invalid: type_error_message = !$"message_type is invalid."
let define_error_flag_invalid: type_error_message = !$"flag is invalid."
let define_error_dup_flag_invalid: type_error_message = !$"dup_flag is invalid."
let define_error_qos_flag_invalid: type_error_message = !$"qos_flag is invalid."
let define_error_retain_flag_invalid: type_error_message = !$"retain_flag is invalid."
let define_error_topic_length_invalid: type_error_message = !$"topic_length is invalid."
let define_error_topic_name_dont_zero_terminated: type_error_message = !$"topic_name is not zero-terminated."
let define_error_topic_name_have_inavlid_character: type_error_message = !$"topic_name have invalid character."
let define_error_property_length_invalid: type_error_message = !$"property_length is invalid."
let define_error_payload_invalid: type_error_message = !$"payload is invalid."
let define_error_protocol_name_invalid: type_error_message = !$"protocol name is invalid."
let define_error_protocol_version_invalid: type_error_message = !$"protocol version is invalid."
let define_error_connect_flag_invalid: type_error_message = !$"connect flag is invalid."
let define_no_error: type_error_message = !$""

type type_error_message_restrict =
  (v:
    type_error_message{
      v = define_no_error ||
      v = define_error_remaining_length_invalid ||
      v = define_error_message_type_invalid ||
      v = define_error_flag_invalid ||
      v = define_error_dup_flag_invalid ||
      v = define_error_qos_flag_invalid ||
      v = define_error_retain_flag_invalid ||
      v = define_error_topic_length_invalid ||
      v = define_error_topic_name_dont_zero_terminated ||
      v = define_error_topic_name_have_inavlid_character ||
      v = define_error_property_length_invalid ||
      v = define_error_payload_invalid ||
      v = define_error_protocol_name_invalid ||
      v = define_error_protocol_version_invalid ||
      v = define_error_connect_flag_invalid
    }
  )

type type_error_code = U8.t
let define_no_error_code: type_error_code = 0uy
let define_error_remaining_length_invalid_code: type_error_code = 1uy
let define_error_message_type_invalid_code: type_error_code = 2uy
let define_error_flag_invalid_code: type_error_code = 3uy
let define_error_dup_flag_invalid_code: type_error_code = 4uy
let define_error_qos_flag_invalid_code: type_error_code = 5uy
let define_error_retain_flag_invalid_code: type_error_code = 6uy
let define_error_topic_length_invalid_code: type_error_code = 7uy
let define_error_topic_name_dont_zero_terminated_code: type_error_code = 8uy
let define_error_property_length_invalid_code: type_error_code = 9uy
let define_error_payload_invalid_code: type_error_code = 10uy
let define_error_topic_name_have_inavlid_character_code: type_error_code = 11uy
let define_error_protocol_name_invalid_code: type_error_code = 12uy
let define_error_protocol_version_invalid_code: type_error_code = 13uy
let define_error_connect_flag_invalid_code: type_error_code = 14uy

type type_error_code_restrict =
  (v:
    type_error_code{
      v = define_no_error_code ||
      v = define_error_remaining_length_invalid_code ||
      v = define_error_message_type_invalid_code ||
      v = define_error_flag_invalid_code ||
      v = define_error_dup_flag_invalid_code ||
      v = define_error_qos_flag_invalid_code ||
      v = define_error_retain_flag_invalid_code ||
      v = define_error_topic_length_invalid_code ||
      v = define_error_topic_name_dont_zero_terminated_code ||
      v = define_error_topic_name_have_inavlid_character_code ||
      v = define_error_property_length_invalid_code ||
      v = define_error_payload_invalid_code ||
      v = define_error_protocol_name_invalid_code ||
      v = define_error_protocol_version_invalid_code ||
      v = define_error_connect_flag_invalid_code
    }
  )

val new_line : unit -> StTrivial unit
let new_line () = print_string "\n"

// let print_not_implemented str = print_string "Not Implemented: "; 
//                           print_string str;
//                           new_line ()

val slice_byte:
  byte:U8.t
  -> a:U8.t{U8.v a <= 7}
  -> b:U8.t {U8.v b <= 8 && U8.v a < U8.v b} -> U8.t
let slice_byte byte a b =
  let for_mask_temp1: U8.t =
    (
      if (U32.eq 0ul (uint8_to_uint32 a)) then
        0b11111111uy
      else if (U32.eq 1ul (uint8_to_uint32 a)) then
        0b01111111uy
      else if (U32.eq 2ul (uint8_to_uint32 a)) then
        0b00111111uy
      else if (U32.eq 3ul (uint8_to_uint32 a)) then
        0b00011111uy
      else if (U32.eq 4ul (uint8_to_uint32 a)) then
        0b00001111uy
      else if (U32.eq 5ul (uint8_to_uint32 a)) then
        0b00000111uy
      else if (U32.eq 6ul (uint8_to_uint32 a)) then
        0b00000011uy
      else
        0b00000001uy
    ) in
  let for_mask_temp2: U8.t =
    (
      if (U32.eq 1ul (uint8_to_uint32 b)) then
        0b10000000uy
      else if (U32.eq 2ul (uint8_to_uint32 b)) then
        0b11000000uy
      else if (U32.eq 3ul (uint8_to_uint32 b)) then
        0b11100000uy
      else if (U32.eq 4ul (uint8_to_uint32 b)) then
        0b11110000uy
      else if (U32.eq 5ul (uint8_to_uint32 b)) then
        0b11111000uy
      else if (U32.eq 6ul (uint8_to_uint32 b)) then
        0b11111100uy
      else if (U32.eq 7ul (uint8_to_uint32 b)) then
        0b11111110uy
      else
        0b11111111uy
    ) in
    let mask: U8.t = U8.logand for_mask_temp1 for_mask_temp2 in
    let r: U8.t = U8.shift_right (U8.logand byte mask) (U32.sub 8ul (uint8_to_uint32 b)) in
  r

val is_valid_decoding_packet_check: ptr_for_decoding_packets: B.buffer U8.t
  -> bytes_length: (v:U8.t{U8.v v >= 1 && U8.v v <= 4})
  -> Stack (v:U8.t{U8.v v <= 3})
    (requires fun h0 -> B.live h0 ptr_for_decoding_packets /\ B.length ptr_for_decoding_packets = 4)
    (ensures fun h0 r h1 -> true)
let is_valid_decoding_packet_check ptr_for_decoding_packets bytes_length =
  push_frame ();
  let ptr_status: B.buffer (status:U8.t{U8.v status <= 3}) = B.alloca 0uy 1ul in
  let inv h (i: nat) =
    B.live h ptr_status /\
    B.live h ptr_for_decoding_packets
     in
  let body (i: U32.t{ 0 <= U32.v i && U32.v i < 4 }): Stack unit
    (requires (fun h -> inv h (U32.v i)))
    (ensures (fun _ _ _ -> true))
  =
    let ptr_status_v: (status:U8.t{U8.v status <= 3}) = ptr_status.(0ul) in
    let bytes_length_u32: U32.t = uint8_to_uint32(bytes_length) in
      if (U8.eq ptr_status_v 0uy) then
        (
          if (U32.lt i bytes_length_u32) then
            (
              let decoding_packet: U8.t = ptr_for_decoding_packets.(i) in
                if (U8.eq bytes_length 1uy) then
                  (
                    if (U8.lt decoding_packet 0uy || U8.gt decoding_packet 127uy) then
                      (
                        ptr_status.(0ul) <- 1uy
                      )
                  )
                else
                  (
                    let data_length_minus_one: U32.t = uint8_to_uint32 (U8.sub bytes_length 1uy) in
                    if (U32.eq i data_length_minus_one) then
                      (
                        if (U8.lt decoding_packet 1uy || U8.gt decoding_packet 127uy) then
                          (
                            ptr_status.(0ul) <- 2uy
                          )
                      ) else
                        (
                          if (U8.lt decoding_packet 128uy || U8.gt decoding_packet max_u8) then
                            (
                              ptr_status.(0ul) <- 3uy
                            )
                        )
                  )
            )
        )
  in
  C.Loops.for 0ul 4ul inv body;
  let r: (status:U8.t{U8.v status <= 3}) = ptr_status.(0ul) in
  pop_frame ();
  r

val most_significant_four_bit_to_zero: i:U8.t -> y:U8.t{U8.v y >= 0 && U8.v y <= 127}
let most_significant_four_bit_to_zero i =
    if (U8.(i >=^ 128uy)) then
      U8.(i -^ 128uy)
    else
      i

val except_most_significant_four_bit_to_zero: i:U8.t -> y:U8.t{U8.v y = 0 || U8.v y = 128}
let except_most_significant_four_bit_to_zero i =
    if (U8.(i <=^ 127uy)) then
      0uy
    else
      128uy

val decodeing_variable_bytes: ptr_for_decoding_packets: B.buffer U8.t
  -> bytes_length:U8.t{U8.v bytes_length >= 1 && U8.v bytes_length <= 4}
  -> Stack (remaining_length:type_remaining_length)
    (requires fun h0 -> B.live h0 ptr_for_decoding_packets  /\ B.length ptr_for_decoding_packets = 4)
    (ensures fun h0 r h1 -> true)
let decodeing_variable_bytes ptr_for_decoding_packets bytes_length =
  push_frame ();
  let ptr_for_decoding_packet: B.buffer U8.t = B.alloca 0uy 1ul in
  let ptr_for_remaining_length: B.buffer type_remaining_length = B.alloca 0ul 1ul in
  let ptr_status: B.buffer (status:U8.t{U8.v status <= 1}) = B.alloca 1uy 1ul in
  let ptr_temp1 : B.buffer (temp: U32.t{U32.v temp <= 127}) = B.alloca 0ul 1ul in
  let ptr_temp2 : B.buffer (temp: U32.t{U32.v temp <= 16383}) = B.alloca 0ul 1ul in
  let ptr_temp3 : B.buffer (temp: U32.t{U32.v temp <= 2097151}) = B.alloca 0ul 1ul in
  let ptr_temp4 : B.buffer type_remaining_length = B.alloca 0ul 1ul in
  let inv h (i: nat) = B.live h ptr_for_decoding_packets /\
    B.live h ptr_for_decoding_packet /\
    B.live h ptr_for_remaining_length /\
    B.live h ptr_status /\
    B.live h ptr_temp1 /\
    B.live h ptr_temp2 /\
    B.live h ptr_temp3 /\
    B.live h ptr_temp4
     in
  let is_valid_decoding_packet: (v:U8.t{U8.v v <= 3}) = is_valid_decoding_packet_check ptr_for_decoding_packets bytes_length in
  if (is_valid_decoding_packet <> 0uy) then
    (
      pop_frame ();
      max_u32
    )
  else
    (
      let body (i: U32.t{ 0 <= U32.v i && U32.v i <= 3 }): Stack unit
        (requires (fun h -> inv h (U32.v i)))
        (ensures (fun _ _ _ -> true))
      =
        let ptr_status_v: (status:U8.t{U8.v status <= 1}) = ptr_status.(0ul) in
          if (ptr_status_v = 1uy) then
            (
              let decoding_packet: U8.t = ptr_for_decoding_packets.(i) in

              let b_u8: (x:U8.t{U8.v x >= 0 && U8.v x <= 127}) =
                most_significant_four_bit_to_zero decoding_packet in

              let b_u32: (x:U32.t{U32.v x >= 0 && U32.v x <= 127}) = uint8_to_uint32 b_u8 in
              let b2_u8: (x:U8.t{U8.v x = 0 || U8.v x = 128}) =
                except_most_significant_four_bit_to_zero decoding_packet in

              if (i = 0ul) then
                (
                  ptr_temp1.(0ul) <- U32.(b_u32 *^ 1ul);
                  ptr_for_remaining_length.(0ul) <- ptr_temp1.(0ul)
                )
              else if (i = 1ul) then
                (
                    ptr_temp2.(0ul) <- U32.(ptr_temp1.(0ul) +^ b_u32 *^ 128ul);
                    ptr_for_remaining_length.(0ul) <- ptr_temp2.(0ul)
                )
              else if (i = 2ul) then
                (
                    ptr_temp3.(0ul) <- U32.(ptr_temp2.(0ul) +^ (b_u32 *^ 128ul *^ 128ul));
                    ptr_for_remaining_length.(0ul) <- ptr_temp3.(0ul)
                )
              else
                (
                    ptr_temp4.(0ul) <- U32.(ptr_temp3.(0ul) +^ (b_u32 *^ 128ul *^ 128ul *^ 128ul));
                    ptr_for_remaining_length.(0ul) <- ptr_temp4.(0ul)
                );

              if (b2_u8 = 0uy) then
                ptr_status.(0ul) <- 0uy
            )
      in
      C.Loops.for 0ul 4ul inv body;
      let remaining_length: type_remaining_length =
        ptr_for_remaining_length.(0ul) in
      pop_frame ();
      remaining_length
  )

val get_remaining_length: bytes_length:U8.t{U8.v bytes_length >= 1 && U8.v bytes_length <= 4} -> ptr_for_decoding_packets: B.buffer U8.t -> packet_size: type_packet_size
  -> Stack (remaining_length:type_remaining_length)
  (requires fun h0 -> B.live h0 ptr_for_decoding_packets /\ B.length ptr_for_decoding_packets = 4)
  (ensures fun _ _ _ -> true)
let get_remaining_length bytes_length ptr_for_decoding_packets packet_size =
  let fixed_value: U32.t = U32.(packet_size -^ 1ul) in
  let bytes_length_u32: U32.t = uint8_to_uint32(bytes_length) in
  let r: type_remaining_length =
    let untrust_r: type_remaining_length =
      decodeing_variable_bytes ptr_for_decoding_packets bytes_length in
    (
      if (untrust_r <> max_u32) then
        (
          if (U32.(bytes_length_u32 +^ untrust_r) = fixed_value) then
            untrust_r
          else
            max_u32
        )
      else
        max_u32
    ) in r

val get_message_type: message_type_bits: U8.t -> type_mqtt_control_packets_restrict
let get_message_type message_type_bits =
  if (U8.lt message_type_bits 1uy || U8.gt message_type_bits 15uy) then
    max_u8
  else
    message_type_bits

type struct_flags = {
  flag: type_flag_restrict;
  dup_flag: type_dup_flags_restrict;
  qos_flag: type_qos_flags_restrict;
  retain_flag: type_retain_flags_restrict;
}

type struct_fixed_header_constant = {
  message_type_constant: type_mqtt_control_packets_restrict;
  message_name_constant: type_message_name_restrict;
  flags_constant: struct_flags;
}

type struct_variable_header_publish = {
  topic_length: type_topic_length_restrict;
  topic_name: type_topic_name_restrict;
  property_length: type_property_length;
  payload: type_payload_restrict;
}

type struct_error_struct = {
  code: type_error_code_restrict;
  message: type_error_message_restrict;
}

type struct_fixed_header = {
  message_type: type_mqtt_control_packets_restrict;
  message_name: type_message_name_restrict;
  flags: struct_flags;
  remaining_length: type_remaining_length;
  connect: struct_connect;
  publish: struct_variable_header_publish;
  disconnect: struct_disconnect_reason;
  error: struct_error_struct;
}

type struct_fixed_header_parts = {
  _fixed_header_first_one_byte: U8.t;
  is_searching_remaining_length: bool;
  is_searching_property_length: bool;
  _message_type: type_mqtt_control_packets_restrict;
  _remaining_length: type_remaining_length;
  _topic_length: type_topic_length_restrict;
  _topic_name: type_topic_name_restrict;
  _topic_name_error_status: U8.t;
  _property_length: type_property_length;
  _payload: type_payload_restrict;
  _payload_error_status: U8.t;
  _protocol_name_error_status: U8.t;
  _protocol_version_error_status: U8.t;
  _connect_flag: U8.t;
  _keep_alive: U32.t;
  _connect_topic_length: U32.t;
  _connect_property_id: U8.t;
}

type struct_publish_parts = {
  publish_remaining_length: type_remaining_length;
  publish_fixed_header_first_one_byte: U8.t;
  publish_topic_name: type_topic_name_restrict;
  publish_topic_length: type_topic_length_restrict;
  publish_property_length: type_property_length;
  publish_payload: type_payload_restrict;
}

type struct_connect_parts = {
  connect_remaining_length: type_remaining_length;
  connect_connect_constant: struct_fixed_header_constant;
  connect_connect_flag: U8.t;
  connect_keep_alive: U32.t;
  connect_connect_topic_length: U32.t;
  connect_connect_property_id: U8.t;
}

type struct_disconnect_parts = {
  disconnect_remaining_length: type_remaining_length;
  disconnect_disconnect_constant: struct_fixed_header_constant;
}

val is_valid_flag: s:struct_fixed_header_constant -> flag: type_flag_restrict -> bool
let is_valid_flag s flag = U8.eq s.flags_constant.flag flag

val struct_fixed_publish:
  (dup_flag:type_dup_flags_restrict)
  -> (qos_flag:type_qos_flags_restrict)
  -> (retain_flag:type_retain_flags_restrict)
  -> struct_fixed_header_constant
let struct_fixed_publish dup_flag qos_flag retain_flag = {
  message_type_constant = define_mqtt_control_packet_PUBLISH;
  message_name_constant = define_mqtt_control_packet_PUBLISH_label;
  flags_constant = {
    flag = max_u8;
    dup_flag = dup_flag;
    qos_flag = qos_flag;
    retain_flag = retain_flag;
  };
}

val get_struct_fixed_header_constant_except_publish :
  (message_type: type_mqtt_control_packets_restrict)
  -> struct_fixed_header_constant
let get_struct_fixed_header_constant_except_publish message_type =
  if (U8.eq message_type define_mqtt_control_packet_CONNECT) then
    {
      message_type_constant = define_mqtt_control_packet_CONNECT;
      message_name_constant = define_mqtt_control_packet_CONNECT_label;
      flags_constant = {
        flag = define_flag_CONNECT;
        dup_flag = max_u8;
        qos_flag = max_u8;
        retain_flag = max_u8;
      };
    }
  else if (U8.eq message_type define_mqtt_control_packet_CONNACK) then
      {
        message_type_constant = define_mqtt_control_packet_CONNACK;
        message_name_constant = define_mqtt_control_packet_CONNACK_label;
        flags_constant = {
          flag = define_flag_CONNACK;
          dup_flag = max_u8;
          qos_flag = max_u8;
          retain_flag = max_u8;
        };
      }
  else if (U8.eq message_type define_mqtt_control_packet_PUBACK) then
    {
      message_type_constant = define_mqtt_control_packet_PUBACK;
      message_name_constant = define_mqtt_control_packet_PUBACK_label;
      flags_constant = {
        flag = define_flag_PUBACK;
        dup_flag = max_u8;
        qos_flag = max_u8;
        retain_flag = max_u8;
      };
    }
  else if (U8.eq message_type define_mqtt_control_packet_PUBREC) then
    {
      message_type_constant = define_mqtt_control_packet_PUBREC;
      message_name_constant = define_mqtt_control_packet_PUBREC_label;
      flags_constant = {
        flag = define_flag_PUBREC;
        dup_flag = max_u8;
        qos_flag = max_u8;
        retain_flag = max_u8;
      };
    }
  else if (U8.eq message_type define_mqtt_control_packet_PUBREL) then
    {
      message_type_constant = define_mqtt_control_packet_PUBREL;
      message_name_constant = define_mqtt_control_packet_PUBREL_label;
      flags_constant = {
        flag = define_flag_PUBREL;
        dup_flag = max_u8;
        qos_flag = max_u8;
        retain_flag = max_u8;
      };
    }
  else if (U8.eq message_type define_mqtt_control_packet_PUBCOMP) then
    {
      message_type_constant = define_mqtt_control_packet_PUBCOMP;
      message_name_constant = define_mqtt_control_packet_PUBCOMP_label;
      flags_constant = {
        flag = define_flag_PUBCOMP;
        dup_flag = max_u8;
        qos_flag = max_u8;
        retain_flag = max_u8;
      };
    }
  else if (U8.eq message_type define_mqtt_control_packet_SUBSCRIBE) then
    {
      message_type_constant = define_mqtt_control_packet_SUBSCRIBE;
      message_name_constant = define_mqtt_control_packet_SUBSCRIBE_label;
      flags_constant = {
        flag = define_flag_SUBSCRIBE;
        dup_flag = max_u8;
        qos_flag = max_u8;
        retain_flag = max_u8;
      };
    }
  else if (U8.eq message_type define_mqtt_control_packet_SUBACK) then
    {
      message_type_constant = define_mqtt_control_packet_SUBACK;
      message_name_constant = define_mqtt_control_packet_SUBACK_label;
      flags_constant = {
        flag = define_flag_SUBACK;
        dup_flag = max_u8;
        qos_flag = max_u8;
        retain_flag = max_u8;
      };
    }
  else if (U8.eq message_type define_mqtt_control_packet_UNSUBSCRIBE) then
    {
      message_type_constant = define_mqtt_control_packet_UNSUBSCRIBE;
      message_name_constant = define_mqtt_control_packet_UNSUBSCRIBE_label;
      flags_constant = {
        flag = define_flag_UNSUBSCRIBE;
        dup_flag = max_u8;
        qos_flag = max_u8;
        retain_flag = max_u8;
      };
    }
  else if (U8.eq message_type define_mqtt_control_packet_UNSUBACK) then
    {
      message_type_constant = define_mqtt_control_packet_UNSUBACK;
      message_name_constant = define_mqtt_control_packet_UNSUBACK_label;
      flags_constant = {
        flag = define_flag_UNSUBACK;
        dup_flag = max_u8;
        qos_flag = max_u8;
        retain_flag = max_u8;
      };
    }
  else if (U8.eq message_type define_mqtt_control_packet_PINGREQ) then
    {
      message_type_constant = define_mqtt_control_packet_PINGREQ;
      message_name_constant = define_mqtt_control_packet_PINGREQ_label;
      flags_constant = {
        flag = define_flag_PINGREQ;
        dup_flag = max_u8;
        qos_flag = max_u8;
        retain_flag = max_u8;
      };
    }
  else if (U8.eq message_type define_mqtt_control_packet_PINGRESP) then
    {
      message_type_constant = define_mqtt_control_packet_PINGRESP;
      message_name_constant = define_mqtt_control_packet_PINGRESP_label;
      flags_constant = {
        flag = define_flag_PINGRESP;
        dup_flag = max_u8;
        qos_flag = max_u8;
        retain_flag = max_u8;
      };
    }
  else if (U8.eq message_type define_mqtt_control_packet_DISCONNECT) then
    {
      message_type_constant = define_mqtt_control_packet_DISCONNECT;
      message_name_constant = define_mqtt_control_packet_DISCONNECT_label;
      flags_constant = {
        flag = define_flag_DISCONNECT;
        dup_flag = max_u8;
        qos_flag = max_u8;
        retain_flag = max_u8;
      };
    }
  else
    {
      message_type_constant = define_mqtt_control_packet_AUTH;
      message_name_constant = define_mqtt_control_packet_AUTH_label;
      flags_constant = {
        flag = define_flag_AUTH;
        dup_flag = max_u8;
        qos_flag = max_u8;
        retain_flag = max_u8;
      };
    }

val error_struct_fixed_header:
  (error_struct: struct_error_struct)
  -> struct_fixed_header
let error_struct_fixed_header error_struct = {
    message_type = max_u8;
    message_name = !$"";
    flags = {
      flag = max_u8;
      dup_flag = max_u8;
      qos_flag = max_u8;
      retain_flag = max_u8;
    };
    remaining_length = max_u32;
    connect = {
      protocol_name = !$"";
      protocol_version = max_u8;
      flags = {
        connect_flag = max_u8;
        user_name = max_u8;
        password = max_u8;
        will_retain = max_u8;
        will_qos = max_u8;
        will_flag = max_u8;
        clean_start = max_u8;
      };
      keep_alive = max_u32;
      connect_topic_length = max_u32;
      connect_property = {
        connect_property_id = max_u8;
        connect_property_name = !$"";
      }
    };
    publish = {
      topic_length = max_u32;
      topic_name = !$"";
      property_length = max_u32;
      payload = !$"";
    };
    disconnect = {
      disconnect_reason_code = max_u8;
      disconnect_reason_code_name = !$"";
    };
    error = error_struct;
  }

val get_dup_flag: fixed_header_first_one_byte: U8.t -> type_dup_flags_restrict
let get_dup_flag fixed_header_first_one_byte =
  let dup_flag_bits: U8.t = slice_byte fixed_header_first_one_byte 4uy 5uy in
  if (U8.gt dup_flag_bits 1uy) then
    max_u8
  else
    dup_flag_bits
val get_qos_flag: fixed_header_first_one_byte: U8.t -> type_qos_flags_restrict
let get_qos_flag fixed_header_first_one_byte =
    let qos_flag_bits: U8.t = slice_byte fixed_header_first_one_byte 5uy 7uy in
    if (U8.gt qos_flag_bits 2uy) then
      max_u8
    else
      qos_flag_bits

val get_retain_flag: fixed_header_first_one_byte: U8.t -> type_retain_flags_restrict
let get_retain_flag fixed_header_first_one_byte =
    let retain_flag_bits: U8.t = slice_byte fixed_header_first_one_byte 7uy 8uy in
    if (U8.gt retain_flag_bits 1uy) then
      max_u8
    else
      retain_flag_bits

val get_flag: (message_type: type_mqtt_control_packets_restrict)
  -> (fixed_header_first_one_byte: U8.t)
  -> type_flag_restrict
let get_flag message_type fixed_header_first_one_byte =
  let v: U8.t = slice_byte fixed_header_first_one_byte 4uy 8uy in
      if (U8.eq message_type define_mqtt_control_packet_PUBREL ||
        U8.eq message_type define_mqtt_control_packet_SUBSCRIBE ||
        U8.eq message_type define_mqtt_control_packet_UNSUBSCRIBE) then
        (
          if (v <> 0b0010uy) then
            max_u8
          else
            v
        )
      else
        (
          if (v <> 0b0000uy) then
            max_u8
          else
            v
        )

val assemble_publish_struct: s: struct_publish_parts
  -> Pure struct_fixed_header
    (requires true)
    (ensures (fun r -> true))
let assemble_publish_struct s =
      let dup_flag: type_dup_flags_restrict = get_dup_flag s.publish_fixed_header_first_one_byte in
      let qos_flag: type_qos_flags_restrict = get_qos_flag s.publish_fixed_header_first_one_byte in
      let retain_flag: type_retain_flags_restrict = get_retain_flag s.publish_fixed_header_first_one_byte in
      let data: struct_fixed_header_constant =
        struct_fixed_publish dup_flag qos_flag retain_flag in
        {
          message_type = data.message_type_constant;
          message_name = data.message_name_constant;
          flags = {
            flag = data.flags_constant.flag;
            dup_flag = data.flags_constant.dup_flag;
            qos_flag = data.flags_constant.qos_flag;
            retain_flag = data.flags_constant.retain_flag;
          };
          remaining_length = s.publish_remaining_length;
          connect = {
            protocol_name = !$"";
            protocol_version = max_u8;
            flags = {
              connect_flag = max_u8;
              user_name = max_u8;
              password = max_u8;
              will_retain = max_u8;
              will_qos = max_u8;
              will_flag = max_u8;
              clean_start = max_u8;
            };
            keep_alive = max_u32;
            connect_topic_length = max_u32;
            connect_property = {
              connect_property_id = max_u8;
              connect_property_name = !$""
            }
          };
          publish = {
            topic_length = s.publish_topic_length;
            topic_name = s.publish_topic_name;
            property_length = s.publish_property_length;
            payload = s.publish_payload;
          };
          disconnect = {
            disconnect_reason_code = max_u8;
            disconnect_reason_code_name = !$"";
          };
          error = {
            code = define_no_error_code;
            message = define_no_error;
          };
        }


val assemble_connect_struct: s: struct_connect_parts
  -> Pure struct_fixed_header
    (requires true)
    (ensures (fun r -> true))
let assemble_connect_struct s =
  // let data: struct_fixed_header_constant =
  //   get_struct_fixed_header_constant_except_publish s.connect_message_type in
  let connect_constant: struct_fixed_header_constant = s.connect_connect_constant in
  let connect_flag: U8.t = s.connect_connect_flag in
  let user_name_flag: U8.t = slice_byte connect_flag 0uy 1uy in
  let password_flag: U8.t = slice_byte connect_flag 1uy 2uy in
  let will_retain_flag: U8.t = slice_byte connect_flag 2uy 3uy in
  let will_qos_flag: U8.t = slice_byte connect_flag 3uy 5uy in
  let will_flag: U8.t = slice_byte connect_flag 5uy 6uy in
  let clean_start_flag: U8.t = slice_byte connect_flag 6uy 7uy in
  let resreved_flag: U8.t = slice_byte connect_flag 7uy 8uy in
  let connect_property_id: U8.t = s.connect_connect_property_id in
  {
    message_type = connect_constant.message_type_constant;
    message_name = connect_constant.message_name_constant;
    flags = {
      flag = connect_constant.flags_constant.flag;
      dup_flag = connect_constant.flags_constant.dup_flag;
      qos_flag = connect_constant.flags_constant.qos_flag;
      retain_flag = connect_constant.flags_constant.retain_flag;
    };
    remaining_length = s.connect_remaining_length;
    connect = 
        {
          protocol_name = !$"MQTT";
          protocol_version = 5uy;
          flags = {
            connect_flag = connect_flag;
            user_name = user_name_flag;
            password = password_flag;
            will_retain = will_retain_flag;
            will_qos = will_qos_flag;
            will_flag = will_flag;
            clean_start = clean_start_flag;
          };
          keep_alive = s.connect_keep_alive;
          connect_topic_length = s.connect_connect_topic_length;
          connect_property =
          if (U8.eq connect_property_id define_connect_property_session_expiry_interval_id) then 
            define_struct_connect_property_session_expiry_interval
          else if (U8.eq connect_property_id define_connect_property_receive_maximum_id) then 
            define_struct_connect_property_receive_maximum
          else if (U8.eq connect_property_id define_connect_property_maximum_packet_size_id) then 
            define_struct_connect_property_maximum_packet_size
          else if (U8.eq connect_property_id define_connect_property_topic_alias_maximum_id) then 
            define_struct_connect_property_topic_alias_maximum
          else if (U8.eq connect_property_id define_connect_property_request_response_information_id) then 
            define_struct_connect_property_request_response_information
          else if (U8.eq connect_property_id define_connect_property_request_problem_information_id) then 
            define_struct_connect_property_request_problem_information    
          else if (U8.eq connect_property_id define_connect_property_user_property_id) then 
            define_struct_connect_property_user_property
          else if (U8.eq connect_property_id define_connect_property_authentication_method_id) then 
            define_struct_connect_property_authentication_method
          else
            define_struct_connect_property_authentication_data
        };
    publish = {
      topic_length = max_u32;
      topic_name = !$"";
      property_length = max_u32;
      payload = !$"";
    };
    disconnect = define_struct_disconnect_error;
    error = {
      code = define_no_error_code;
      message = define_no_error;
    };
  }

val assemble_disconnect_struct: s: struct_disconnect_parts
  -> Pure struct_fixed_header
    (requires true)
    (ensures (fun r -> true))
let assemble_disconnect_struct s =
    let disconnect_constant: struct_fixed_header_constant = s.disconnect_disconnect_constant in
    {
      message_type = disconnect_constant.message_type_constant;
      message_name = disconnect_constant.message_name_constant;
      flags = {
        flag = disconnect_constant.flags_constant.flag;
        dup_flag = disconnect_constant.flags_constant.dup_flag;
        qos_flag = disconnect_constant.flags_constant.qos_flag;
        retain_flag = disconnect_constant.flags_constant.retain_flag;
      };
      remaining_length = s.disconnect_remaining_length;
      connect = {
        protocol_name = !$"";
        protocol_version = max_u8;
        flags = {
          connect_flag = max_u8;
          user_name = max_u8;
          password = max_u8;
          will_retain = max_u8;
          will_qos = max_u8;
          will_flag = max_u8;
          clean_start = max_u8;
        };
        keep_alive = max_u32;
        connect_topic_length = max_u32;
        connect_property = {
          connect_property_id = max_u8;
          connect_property_name = !$"";
        }
      };
      publish = {
        topic_length = max_u32;
        topic_name = !$"";
        property_length = max_u32;
        payload = !$"";
      };
      disconnect = (
        if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_code_normal_disconnection) then
          define_struct_disconnect_normal_disconnection

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_code_disconnect_with_will_message) then
          define_struct_disconnect_disconnect_with_will_message

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_code_unspecified_error) then
          define_struct_disconnect_unspecified_error

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_code_malformed_packet) then
          define_struct_disconnect_malformed_packet

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_code_protocol_error) then
          define_struct_disconnect_protocol_error

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_code_implementation_specific_error) then
          define_struct_disconnect_implementation_specific_error

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_code_not_authorized) then
          define_struct_disconnect_not_authorized

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_code_server_busy) then
          define_struct_disconnect_server_busy

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_code_server_shutting_down) then
          define_struct_disconnect_server_shutting_down

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_code_keep_alive_timeout) then
            define_struct_disconnect_keep_alive_timeout

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_code_session_taken_over) then
            define_struct_disconnect_session_taken_over
            
        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_code_topic_filter_invalid) then
            define_struct_disconnect_topic_filter_invalid
        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_code_topic_name_invalid) then
            define_struct_disconnect_topic_name_invalid

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_receive_maximum_exceeded) then
            define_struct_disconnect_receive_maximum_exceeded

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_topic_alias_invalid) then
            define_struct_disconnect_topic_alias_invalid

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_packet_too_large) then
            define_struct_disconnect_packet_too_large

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_message_rate_too_high) then
            define_struct_disconnect_message_rate_too_high

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_quota_exceeded) then
            define_struct_disconnect_quota_exceeded

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_administrative_action) then
            define_struct_disconnect_administrative_action

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_payload_format_invalid) then
            define_struct_disconnect_payload_format_invalid

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_retain_not_supported) then
            define_struct_disconnect_retain_not_supported

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_qos_not_supported) then
            define_struct_disconnect_qos_not_supported

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_use_another_server) then
            define_struct_disconnect_use_another_server

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_server_moved) then
            define_struct_disconnect_server_moved

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_shared_subscriptions_not_supported) then
            define_struct_disconnect_shared_subscriptions_not_supported

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_connection_rate_exceeded) then
            define_struct_disconnect_connection_rate_exceeded

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_maximum_connect_time) then
            define_struct_disconnect_maximum_connect_time

        else if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_subscription_identifiers_not_supported) then
            define_struct_disconnect_subscription_identifiers_not_supported

        else // if (U8.eq disconnect_constant.flags_constant.flag define_disconnect_reason_wildcard_subscriptions_not_supported) then
            define_struct_disconnect_wildcard_subscriptions_not_supported
      );

      error = {
        code = define_no_error_code;
        message = define_no_error;
      };
    }

val mqtt_packet_parse (request: B.buffer U8.t) (packet_size: type_packet_size):
  Stack struct_fixed_header
    (requires (fun h ->
      B.live h request /\
      B.length request <= U32.v max_request_size /\
      UT.zero_terminated_buffer_u8 h request /\
      (B.length request - 1) = U32.v packet_size))
    (ensures (fun h0 _ h1 -> B.live h0 request /\ B.live h1 request))
let mqtt_packet_parse request packet_size =
  push_frame ();
  let message_type_bits: U8.t = slice_byte request.(0ul) 0uy 4uy in
  let message_type: type_mqtt_control_packets_restrict = get_message_type message_type_bits in
  let ptr_is_break: B.buffer bool = B.alloca false 1ul in
  let ptr_fixed_header_first_one_byte: B.buffer U8.t = B.alloca 0uy 1ul in
  let ptr_message_type: B.buffer type_mqtt_control_packets_restrict
    = B.alloca max_u8 1ul in
  let ptris_searching_remaining_length: B.buffer bool = B.alloca true 1ul in
  let ptr_for_decoding_packets: B.buffer U8.t = B.alloca 0uy 4ul in
  let ptr_remaining_length: B.buffer type_remaining_length =
   B.alloca 0ul 1ul in
  let ptr_variable_header_index: B.buffer U32.t = B.alloca 0ul 1ul in
  let ptr_for_topic_length: B.buffer U8.t = B.alloca 0uy 1ul in
  let ptr_topic_length: B.buffer type_topic_length_restrict = B.alloca max_u32 1ul in
  let ptr_topic_name_u8: B.buffer U8.t = B.alloca 0uy 65536ul in
  let ptr_topic_name: B.buffer type_topic_name_restrict = B.alloca !$"" 1ul in
  let ptr_topic_name_error_status: B.buffer U8.t = B.alloca 0uy 1ul in
  let ptr_topic_name_order_mark_check: B.buffer U8.t = B.alloca 0uy 1ul in
  let ptr_property_length: B.buffer type_property_length = B.alloca 0ul 1ul in
  let ptris_searching_property_length: B.buffer bool = B.alloca true 1ul in
  let ptr_payload: B.buffer type_payload_restrict = B.alloca !$"" 1ul in
  let ptr_payload_error_status: B.buffer U8.t = B.alloca 0uy 1ul in
  let ptr_protocol_name_error_status: B.buffer U8.t = B.alloca 0uy 1ul in
  let ptr_protocol_version_error_status: B.buffer U8.t = B.alloca 0uy 1ul in
  let ptr_connect_flag: B.buffer U8.t = B.alloca 0uy 1ul in
  let ptr_keep_alive: B.buffer U8.t = B.alloca 0uy 2ul in
  let ptr_connect_topic_length: B.buffer U32.t = B.alloca 0ul 1ul in
  let ptr_connect_property_id: B.buffer U8.t = B.alloca 0uy 1ul in
  let inv h (i: nat) =
    B.live h ptr_is_break /\
    B.live h ptr_fixed_header_first_one_byte /\
    B.live h ptr_message_type /\
    B.live h request /\
    B.live h ptr_for_decoding_packets /\
    B.live h ptris_searching_remaining_length /\
    B.live h ptr_remaining_length /\
    B.live h ptr_variable_header_index /\
    B.live h ptr_for_topic_length /\
    B.live h ptr_topic_length /\
    B.live h ptr_topic_name_u8 /\
    B.live h ptr_topic_name /\
    B.live h ptr_topic_name_error_status /\
    B.live h ptr_topic_name_order_mark_check /\
    B.live h ptr_property_length /\
    B.live h ptris_searching_property_length /\
    B.live h ptr_payload /\
    B.live h ptr_payload_error_status /\
    B.live h ptr_protocol_name_error_status /\
    B.live h ptr_protocol_version_error_status /\
    B.live h ptr_connect_flag /\
    B.live h ptr_keep_alive /\
    B.live h ptr_connect_topic_length /\
    B.live h ptr_connect_property_id
    in
  let body (i: U32.t{ 0 <= U32.v i && U32.v i < U32.v packet_size  }): Stack unit
    (requires (fun h -> inv h (U32.v i)))
    (ensures (fun _ _ _ -> true))
  =
    let one_byte : U8.t = request.(i) in
        let is_searching_remaining_length: bool =
         ptris_searching_remaining_length.(0ul) in
        let is_break: bool = ptr_is_break.(0ul) in
      if (is_break) then
        ()
      else if (i = 0ul) then
        (
          let message_type_bits: U8.t = slice_byte one_byte 0uy 4uy in
          let message_type: type_mqtt_control_packets_restrict = get_message_type message_type_bits in
            ptr_message_type.(0ul) <- message_type;
            ptr_fixed_header_first_one_byte.(0ul) <- one_byte;
            if (U8.eq message_type max_u8) then
              (
                ptr_is_break.(0ul) <- true;
                ptris_searching_remaining_length.(0ul) <- false
              )
        )
      else if (U32.gte i 1ul && U32.lte i 4ul && is_searching_remaining_length) then
        (
          let i_u8: U8.t = uint32_to_uint8(i) in
          let i_minus_one: U32.t = U32.sub i 1ul in
          ptr_for_decoding_packets.(i_minus_one) <- one_byte;
          let r: (remaining_length:type_remaining_length) =
            get_remaining_length i_u8 ptr_for_decoding_packets packet_size in
          if (r <> max_u32) then (
            ptris_searching_remaining_length.(0ul) <- false;
            ptr_remaining_length.(0ul) <- r
          )
        )
      else if (not is_searching_remaining_length) then
        (
          let variable_header_index: U32.t = ptr_variable_header_index.(0ul) in
          let message_type: type_mqtt_control_packets_restrict =
            ptr_message_type.(0ul) in
            if (U8.eq message_type define_mqtt_control_packet_PUBLISH) then
              (
                let topic_length: type_topic_length_restrict = ptr_topic_length.(0ul) in
                if (variable_header_index = 0ul) then
                  ptr_for_topic_length.(0ul) <- one_byte
                else if (variable_header_index = 1ul) then
                  (
                    let msb_u8: U8.t = ptr_for_topic_length.(0ul) in
                    let lsb_u8: U8.t = one_byte in
                    let msb_u32: U32.t = uint8_to_uint32 msb_u8  in
                    let lsb_u32: U32.t = uint8_to_uint32 lsb_u8 in
                    let _topic_length: U32.t =
                      U32.logor (U32.shift_left msb_u32 8ul) lsb_u32 in
                    if (U32.gt _topic_length 65535ul) then
                      (
                        ptr_topic_length.(0ul) <- max_u32;
                        ptr_is_break.(0ul) <- true;
                        ptris_searching_remaining_length.(0ul) <- false
                      )
                    else
                      (
                        ptr_topic_length.(0ul) <- _topic_length
                      )
                  )
                else if (U32.gte variable_header_index 2ul) then
                  (
                    let is_searching_property_length: bool =
                     ptris_searching_property_length.(0ul) in
                    if (topic_length = max_u32) then
                      (
                        ptr_topic_length.(0ul) <- max_u32;
                        ptr_is_break.(0ul) <- true;
                        ptris_searching_remaining_length.(0ul) <- false
                      )
                    else
                      (
                      if (U32.lte variable_header_index (U32.(topic_length +^ 1ul))) then
                        (
                          if (U8.eq one_byte 0x00uy || U8.eq one_byte 0x23uy || U8.eq one_byte 0x2buy) then
                            (
                              ptr_topic_name_error_status.(0ul) <- 2uy;
                              ptr_is_break.(0ul) <- true
                            )
                          else
                            (
                              ptr_topic_name_u8.(U32.sub variable_header_index 2ul) <- one_byte;
                              let topic_name_order_mark_check: U8.t = ptr_topic_name_order_mark_check.(0ul) in
                              if (U8.eq topic_name_order_mark_check 0uy && U8.eq one_byte 0xefuy) then
                                (
                                  ptr_topic_name_order_mark_check.(0ul) <- 1uy
                                )
                              else if (U8.eq topic_name_order_mark_check 1uy && U8.eq one_byte 0xbbuy) then
                                (
                                  ptr_topic_name_order_mark_check.(0ul) <- 2uy
                                )
                              else if (U8.eq topic_name_order_mark_check 2uy && U8.eq one_byte 0xbfuy && U32.gte variable_header_index 4ul) then
                                (
                                  ptr_topic_name_order_mark_check.(0ul) <- 3uy;
                                  ptr_topic_name_u8.(U32.sub variable_header_index 4ul) <- 0xfeuy;
                                  ptr_topic_name_u8.(U32.sub variable_header_index 3ul) <- 0xffuy;
                                  ptr_variable_header_index.(0ul) <- U32.sub variable_header_index 1ul
                                )
                              else
                                (
                                  ptr_topic_name_order_mark_check.(0ul) <- 0uy;
                                  if (variable_header_index = (U32.(topic_length +^ 1ul))) then
                                    (
                                      let topic_name: type_topic_name_restrict =
                                        (
                                          if (ptr_topic_name_u8.(65535ul) = 0uy) then
                                            UT.topic_name_uint8_to_c_string ptr_topic_name_u8
                                          else
                                            (
                                              ptr_topic_name_error_status.(0ul) <- 1uy;
                                              !$""
                                            )
                                        ) in ptr_topic_name.(0ul) <- topic_name
                                    )
                                )
                             )

                        )
                      else if (U32.gt variable_header_index (U32.(topic_length +^ 1ul))
                        && U32.lte variable_header_index (U32.(topic_length +^ 5ul))
                        && is_searching_property_length
                        ) then
                        (

                          if (one_byte = 0uy) then
                            (
                              ptr_property_length.(0ul) <- uint8_to_uint32 one_byte;
                              ptris_searching_property_length.(0ul) <- false
                            )
                            // else (
                            //   // TODO: 3.3.2.3 PUBLISH Properties 
                            //   // https://docs.oasis-open.org/mqtt/mqtt/v5.0/os/mqtt-v5.0-os.html#_Toc3901109
                            //   // print_not_implemented "PUBLISH Properties Parsing"
                            // )
                        )
                      else if (not is_searching_property_length) then
                        (
                          let payload_offset: type_payload_offset = i in
                          let ptr_payload_u8: B.buffer U8.t = B.offset request payload_offset in
                          let payload: type_payload_restrict =
                            (
                              let last_payload_index: U32.t =
                                U32.(packet_size -^ payload_offset) in
                              let last_payload_element: U8.t = ptr_payload_u8.(last_payload_index) in
                                if (last_payload_element <> 0uy) then
                                  (
                                    ptr_payload_error_status.(0ul) <- 1uy;
                                    !$""
                                  )
                                else
                                  UT.payload_uint8_to_c_string ptr_payload_u8 min_packet_size max_packet_size packet_size
                            ) in
                          ptr_payload.(0ul) <- payload;
                          ptr_is_break.(0ul) <- true
                        )
                      else
                        (
                          ()
                        )
                      )
                  )
                else
                  (
                    ()
                  )
              )
            else if (U8.eq message_type define_mqtt_control_packet_CONNECT) then (
              (
                if (U32.lte variable_header_index 5ul) then
                  (
                    if (
                      (U32.eq variable_header_index 0ul && not (U8.eq one_byte 0x00uy)) ||
                      (U32.eq variable_header_index 1ul && not (U8.eq one_byte 0x04uy)) ||
                      (U32.eq variable_header_index 2ul && not (U8.eq one_byte 0x4Duy)) ||
                      (U32.eq variable_header_index 3ul && not (U8.eq one_byte 0x51uy)) ||
                      (U32.eq variable_header_index 4ul && not (U8.eq one_byte 0x54uy)) ||
                      (U32.eq variable_header_index 5ul && not (U8.eq one_byte 0x54uy))
                      ) then
                      (
                        ptr_protocol_name_error_status.(0ul) <- 1uy;
                        ptr_is_break.(0ul) <- true
                      )
                  )
                  else if (U32.eq variable_header_index 6ul && not (U8.eq one_byte 0x05uy)) then
                    (
                      ptr_protocol_version_error_status.(0ul) <- 1uy;
                      ptr_is_break.(0ul) <- true
                    )
                  else if (U32.eq variable_header_index 7ul) then
                    (
                      ptr_connect_flag.(0ul) <- one_byte
                    )
                  else if (U32.eq variable_header_index 8ul) then
                    (
                      ptr_keep_alive.(0ul) <- one_byte
                    )
                  else if (U32.eq variable_header_index 9ul) then
                    (
                      if (U8.lte one_byte 0x7Fuy) then
                        (
                          ptr_keep_alive.(1ul) <- one_byte
                        )
                      // else 
                      //   (
                      //     // TODO: keep aliveが127以上の場合は未実装.
                      //   )
                    )
                  else if (U32.eq variable_header_index 10ul) then
                    (
                      // TODO: topic length が一桁かつ, keep aliveが127以下の場合
                      ptr_connect_topic_length.(0ul) <- uint8_to_uint32 one_byte
                    )
                  else if (U32.eq variable_header_index 11ul) then
                    (
                      // TODO: topic length が一桁かつ, keep aliveが127以下の場合
                      ptr_connect_property_id.(0ul) <- one_byte
                    )
                  else
                    (
                      print_string "x: ";
                      print_u8 one_byte;
                      print_string ", index: ";
                      print_u32 variable_header_index;
                      print_string "\n"
                    )
              )
            );
            if (U32.lte variable_header_index (U32.sub max_u32 1ul)) then
              ptr_variable_header_index.(0ul) <-
                U32.(variable_header_index +^ 1ul)

        )
      else
        (
          ()
        )
  in
  C.Loops.for 0ul packet_size inv body;

  let is_searching_remaining_length: bool = ptris_searching_remaining_length.(0ul) in
  let fixed_header_first_one_byte: U8.t = ptr_fixed_header_first_one_byte.(0ul) in
  let message_type: type_mqtt_control_packets_restrict = ptr_message_type.(0ul) in
  let remaining_length: type_remaining_length
    = ptr_remaining_length.(0ul) in

  let topic_length: type_topic_length_restrict = ptr_topic_length.(0ul) in
  let topic_name: type_topic_name_restrict = ptr_topic_name.(0ul) in
  let topic_name_error_status: U8.t = ptr_topic_name_error_status.(0ul) in
  let is_searching_property_length: bool = ptris_searching_property_length.(0ul) in
  let property_length: type_property_length = ptr_property_length.(0ul) in
  let payload: type_payload_restrict = ptr_payload.(0ul) in
  let payload_error_status: U8.t = ptr_payload_error_status.(0ul) in
  let protocol_name_error_status: U8.t = ptr_protocol_name_error_status.(0ul) in
  let protocol_version_error_status: U8.t = ptr_protocol_version_error_status.(0ul) in
  let connect_flag: U8.t = ptr_connect_flag.(0ul) in
  let keep_alive_msb_u8: U8.t = ptr_keep_alive.(0ul) in
  let keep_alive_lsb_u8: U8.t = ptr_keep_alive.(1ul) in
  let connect_topic_length: U32.t = ptr_connect_topic_length.(0ul) in
  let connect_property_id: U8.t = ptr_connect_property_id.(0ul) in
  pop_frame ();
  
  if (U8.eq message_type define_mqtt_control_packet_PUBLISH) then
    (
      let dup_flag: type_dup_flags_restrict = get_dup_flag fixed_header_first_one_byte in
      let qos_flag: type_qos_flags_restrict = get_qos_flag fixed_header_first_one_byte in
      let retain_flag: type_retain_flags_restrict = get_retain_flag fixed_header_first_one_byte in
      let have_error: bool =
        (is_searching_remaining_length) ||
        (U8.eq message_type max_u8) ||
        (U8.eq dup_flag max_u8) ||
        (U8.eq qos_flag max_u8) ||
        (U8.eq retain_flag max_u8) ||
        (U8.eq topic_name_error_status 1uy) ||
        (U8.eq topic_name_error_status 2uy) ||
        (U32.eq topic_length max_u32) ||
        (is_searching_property_length) ||
        (U8.gt payload_error_status 0uy) in
      if (have_error) then
        (
          let error_struct: struct_error_struct =
            (
              if (is_searching_remaining_length) then
                {
                  code = define_error_remaining_length_invalid_code;
                  message = define_error_remaining_length_invalid;
                }
              else if (U8.eq message_type max_u8) then
                {
                  code = define_error_message_type_invalid_code;
                  message = define_error_message_type_invalid;
                }
              else if (U8.eq dup_flag max_u8) then
                {
                  code = define_error_dup_flag_invalid_code;
                  message = define_error_dup_flag_invalid;
                }
              else if (U8.eq qos_flag max_u8) then
                {
                  code = define_error_qos_flag_invalid_code;
                  message = define_error_qos_flag_invalid;
                }
              else if (U8.eq retain_flag max_u8) then
                {
                  code = define_error_retain_flag_invalid_code;
                  message = define_error_retain_flag_invalid;
                }
              else if (U32.eq topic_length max_u32) then
                {
                  code = define_error_topic_length_invalid_code;
                  message = define_error_topic_length_invalid;
                }
              else if (U8.eq topic_name_error_status 1uy) then
                {
                  code = define_error_topic_name_dont_zero_terminated_code;
                  message = define_error_topic_name_dont_zero_terminated;
                }
              else if (U8.eq topic_name_error_status 2uy) then
                {
                  code = define_error_topic_name_have_inavlid_character_code;
                  message = define_error_topic_name_have_inavlid_character;
                }
              // else if (is_searching_property_length) then
              //   {
              //     code = define_error_property_length_invalid_code;
              //     message = define_error_property_length_invalid;
              //   }
              else
                {
                  code = define_error_property_length_invalid_code;
                  message = define_error_property_length_invalid;
                }
            ) in error_struct_fixed_header error_struct
        )
      else
        (
          let ed_fixed_header_parts:
            struct_publish_parts = {
              publish_fixed_header_first_one_byte = fixed_header_first_one_byte;
              publish_remaining_length = remaining_length;
              publish_topic_length = topic_length;
              publish_topic_name = topic_name;
              publish_property_length = property_length;
              publish_payload = payload;
          } in
          assemble_publish_struct ed_fixed_header_parts
        )
    )
  else if (U8.eq message_type define_mqtt_control_packet_CONNECT) then
    (
        let connect_constant: struct_fixed_header_constant =
          get_struct_fixed_header_constant_except_publish message_type in
        let connect_flag: U8.t = connect_flag in
        let user_name_flag: U8.t = slice_byte connect_flag 0uy 1uy in
        let password_flag: U8.t = slice_byte connect_flag 1uy 2uy in
        let will_retain_flag: U8.t = slice_byte connect_flag 2uy 3uy in
        let will_qos_flag: U8.t = slice_byte connect_flag 3uy 5uy in
        let will_flag: U8.t = slice_byte connect_flag 5uy 6uy in
        let clean_start_flag: U8.t = slice_byte connect_flag 6uy 7uy in
        let resreved_flag: U8.t = slice_byte connect_flag 7uy 8uy in
        let connect_property_id: U8.t = connect_property_id in
        let keep_alive_msb_u32: U32.t = uint8_to_uint32 keep_alive_msb_u8  in
        let keep_alive_lsb_u32: U32.t = uint8_to_uint32 keep_alive_lsb_u8 in 
        let keep_alive: U32.t = U32.logor (U32.shift_left keep_alive_msb_u32 8ul)keep_alive_lsb_u32 in

        let have_error: bool =
          (protocol_name_error_status = 1uy) ||
          (protocol_version_error_status = 1uy) ||
          (not (U8.eq resreved_flag 0uy) ) in
        if (have_error) then
          (
            let error_struct: struct_error_struct =
              (
                if (protocol_name_error_status = 1uy) then
                  {
                    code = define_error_protocol_name_invalid_code;
                    message = define_error_protocol_name_invalid;
                  }
                else if (protocol_version_error_status = 1uy) then
                  {
                    code = define_error_protocol_version_invalid_code;
                    message = define_error_protocol_version_invalid;
                  }
                // else if (not (U8.eq resreved_flag 0uy) ) then
                //   {
                //     code = define_error_connect_flag_invalid_code;
                //     message = define_error_connect_flag_invalid;
                //   }
                else 
                  {
                    code = define_error_connect_flag_invalid_code;
                    message = define_error_connect_flag_invalid;
                  }
              ) in error_struct_fixed_header error_struct
          )
        else
          (
            let ed_fixed_header_parts:
              struct_connect_parts = {
                connect_remaining_length = remaining_length;
                connect_connect_constant = connect_constant;
                connect_connect_flag = connect_flag;
                connect_keep_alive = keep_alive;
                connect_connect_topic_length = connect_topic_length;
                connect_connect_property_id = connect_property_id;
            } in
            assemble_connect_struct ed_fixed_header_parts            
          )
    )
    else if (U8.eq message_type define_mqtt_control_packet_DISCONNECT) then
      (
        let flag: type_flag_restrict = get_flag message_type fixed_header_first_one_byte in
        let disconnect_constant: struct_fixed_header_constant =
          get_struct_fixed_header_constant_except_publish message_type in
        let have_error: bool =
          (is_searching_remaining_length) ||
          (U8.eq message_type max_u8) ||
          (is_valid_flag disconnect_constant flag = false) in
          if (have_error) then
            (
              let error_struct: struct_error_struct =
                (
                  if (is_searching_remaining_length) then
                    {
                        code = define_error_remaining_length_invalid_code;
                        message = define_error_remaining_length_invalid;
                    }
                  else if (U8.eq message_type max_u8) then
                    {
                        code = define_error_message_type_invalid_code;
                        message = define_error_message_type_invalid;
                    }
                  else
                    {
                        code = define_error_flag_invalid_code;
                        message = define_error_flag_invalid;
                    }
                ) in error_struct_fixed_header error_struct
            )
          else
            (
              let ed_fixed_header_parts:
              struct_disconnect_parts = {
                disconnect_disconnect_constant = disconnect_constant;
                disconnect_remaining_length = remaining_length;
              } in
              assemble_disconnect_struct ed_fixed_header_parts
            )
      )
    else
      (
        let error_struct: struct_error_struct =
          {
              code = define_error_message_type_invalid_code;
              message = define_error_message_type_invalid;
          }
        in error_struct_fixed_header error_struct
      )
