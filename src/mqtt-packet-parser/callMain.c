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

    struct_fixed_header data = mqtt_packet_parse(request, packet_size);
    free(request);

    printf("message_type=0x%02x\n", data.message_type);
    printf("message_name=%s\n", data.message_name);
    printf("flag=0x%02x\n", data.flags.flag);
    printf("dup_flag=0x%02x\n", data.flags.dup_flag);
    printf("qos_flag=0x%02x\n", data.flags.qos_flag);
    printf("retain_flag=0x%02x\n", data.flags.retain_flag);
    printf("remaining_length=%u\n", data.remaining_length);
    printf("topic_length=%u\n", data.publish.topic_length);
    printf("topic_name=%s\n", data.publish.topic_name);
    printf("property_length=%u\n", data.publish.property_length);
    printf("payload=%s\n", data.publish.payload);
    printf("error_code=%u\n", data.error.code);
    printf("error_message=%s\n", data.error.message);
    exit(EXIT_SUCCESS);
}