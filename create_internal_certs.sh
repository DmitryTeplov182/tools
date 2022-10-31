mkdir -p internal_certs

          echo -ne \
          "instances:\n"\
          "  - name: elastic\n"\
          "    dns:\n"\
          "      - elastic\n"\
          "      - localhost\n"\
          "    ip:\n"\
          "      - 127.0.0.1\n"\
          "  - name: kibana\n"\
          "    dns:\n"\
          "      - kibana\n"\
          "      - localhost\n"\
          "    ip:\n"\
          "      - 127.0.0.1\n"\
          > internal_certs/config.yml

docker run -it --rm -e "discovery.type=single-node" \
--mount type=bind,source="$(pwd)"/internal_certs,target=/certs \
docker.elastic.co/elasticsearch/elasticsearch:7.14.1 \
/bin/bash -c \
'/usr/share/elasticsearch/bin/elasticsearch-certutil cert --days 1825 -pem -in /certs/config.yml -out /certs/certs.zip -s \
  && unzip /certs/certs.zip -d /certs && rm -f /certs/certs.zip; chown -R 1000:0 /certs;kill -s SIGHUP 1'
