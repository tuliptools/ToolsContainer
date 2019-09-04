FROM tuliptools/tezos:mainnet
RUN mkdir tezbin
RUN cp /usr/local/bin/tezos* tezbin

FROM ligolang/ligo:next

FROM ubuntu:19.10
WORKDIR /root/

COPY --from=0 /root/tezbin /usr/local/bin/
COPY --from=1 /home/opam/.opam/4.06/bin/ligo /usr/local/bin/ligo
COPY --from=1 /home/opam/.opam/4.06/bin/tez* /usr/local/bin/

RUN apt update && apt-get install -y libgmp-dev libev-dev libusb-dev libhidapi-dev curl bash htop wget net-tools \
    nano vim iputils-ping jq ranger screen python3 git zsh locate busybox-static cpp net-tools haproxy

RUN apt-get install -y htop aria2 wget curl git pydf mtr ack-grep nano unzip

RUN aria2c https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip && \
 unzip exa-linux-x86_64-0.9.0.zip && \
 cp exa-linux-x86_64 /usr/local/bin/exa && rm * && \
 echo "alias ls=\"exa\"" >> ~/.bashrc

RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN echo -e "http\t80/tcp\twww\t# WorldWideWeb HTTP" > /etc/services
ADD haproxy /etc/haproxy/haproxy.cfg
CMD ["haproxy","-f","/etc/haproxy/haproxy.cfg"]