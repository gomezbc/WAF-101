FROM docker.elastic.co/beats/filebeat:8.17.0
COPY --chown=root:filebeat filebeat.yml /usr/share/filebeat/filebeat.yml