FROM restreamio/gstreamer:latest-prod

RUN apt update && apt install -y net-tools iproute2 supervisor && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d && \
    mkdir -p /root/hls

WORKDIR /root/hls

ADD service_script.conf /etc/supervisor/conf.d/service_script.conf

EXPOSE 8080

CMD ["supervisord","-c","/etc/supervisor/conf.d/service_script.conf"]