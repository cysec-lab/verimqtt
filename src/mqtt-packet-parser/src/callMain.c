#include <stdio.h>
#include <stdlib.h>

#include "Main.h"

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "%s [file_path]\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    FILE *fp;
    char *file_name = argv[1];
    uint8_t *request;
    uint32_t  i;
    fpos_t fsize = 0;
    uint32_t packet_size;

    fp = fopen(file_name, "rb");

    if (fp == NULL) {
        fprintf(stderr, "%s open error.\n", file_name);
        exit(EXIT_FAILURE);
    }

    fseek(fp, 0, SEEK_END);
    if (fgetpos(fp, &fsize) != 0) {
        fprintf(stderr, "fgetpos error.\n");
        exit(EXIT_FAILURE);
    }
    fseek(fp, 0L, SEEK_SET);

    packet_size = fsize;

    request = (uint8_t*)malloc(sizeof(uint8_t) * (packet_size + 1));
    if(request == NULL) {
        fprintf(stderr, "malloc error.\n");
        exit(EXIT_FAILURE);
    }

    fread(request, sizeof(uint8_t), packet_size, fp);
    if (fclose(fp) == EOF) {
        fprintf(stderr, "fclose error.\n");
        exit(EXIT_FAILURE);
    }

    kremlinit_globals();
    struct_fixed_header data = mqtt_packet_parse(request, packet_size);
    free(request);

    printf("data.message_type = 0x%02x\n", data.message_type);
    printf("data.message_name = %s\n", data.message_name);
    printf("data.flags.flag = 0x%02x\n", data.flags.flag);
    printf("data.flags.dup_flag = 0x%02x\n", data.flags.dup_flag);
    printf("data.flags.qos_flag = 0x%02x\n", data.flags.qos_flag);
    printf("data.flags.retain_flag = 0x%02x\n", data.flags.retain_flag);
    printf("data.remaining_length = %u\n", data.remaining_length);

    puts("");

    printf("data.connect.protocol_name = %s\n", data.connect.protocol_name);
    printf("data.connect.protocol_version = %u\n", data.connect.protocol_version);
    printf("data.connect.flags.connect_flag = 0x%02x\n", data.connect.flags.connect_flag);
    printf("data.connect.flags.user_name = 0x%02x\n", data.connect.flags.user_name);
    printf("data.connect.flags.password = 0x%02x\n", data.connect.flags.password);
    printf("data.connect.flags.will_retain = 0x%02x\n", data.connect.flags.will_retain);
    printf("data.connect.flags.will_qos = 0x%02x\n", data.connect.flags.will_qos);
    printf("data.connect.flags.will_flag = 0x%02x\n", data.connect.flags.will_flag);
    printf("data.connect.flags.clean_start = 0x%02x\n", data.connect.flags.clean_start);
    printf("data.connect.keep_alive = 0x%02x\n", data.connect.keep_alive);
    printf("data.connect.connect_topic_length = 0x%02x\n", data.connect.connect_topic_length);
    printf("data.connect.connect_property.connect_property_id = 0x%02x\n", data.connect.connect_property.connect_property_id);
    printf("data.connect.connect_property.connect_property_name = %s\n", data.connect.connect_property.connect_property_name);

    puts("");

    printf("data.publish.topic_length = %u\n", data.publish.topic_length);
    printf("data.publish.topic_name = %s\n", data.publish.topic_name);
    printf("data.publish.property_length = %u\n", data.publish.property_length);
    printf("data.publish.payload = %s\n", data.publish.payload);


    printf("data.disconnect.disconnect_reason_code = 0x%02x\n", data.disconnect.disconnect_reason_code);
    printf("data.disconnect.disconnect_reason_code_name = %s\n", data.disconnect.disconnect_reason_code_name);

    puts("");

    printf("data.error.code=%u\n", data.error.code);
    printf("data.error.message=%s\n", data.error.message);
    exit(EXIT_SUCCESS);
}