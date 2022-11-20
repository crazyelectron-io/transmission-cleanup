FROM debian:stable

RUN apt-get update && apt-get -y install transmission-cli gawk

COPY transmission-cleanup.sh /usr/bin/.
RUN chmod +x /usr/bin/transmission-cleanup.sh

CMD ["bash", "-c", "/usr/bin/transmission-cleanup.sh"]