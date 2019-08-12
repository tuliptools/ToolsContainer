FROM tuliptools/tezos:mainnet
RUN mkdir tezbin
RUN cp /usr/local/bin/tezos* tezbin
RUN pwd

FROM ligolang/ligo:next

FROM ubuntu:19.10
WORKDIR /root/
COPY --from=0 /root/tezbin /usr/local/bin/
COPY --from=1 /home/opam/.opam/4.06/bin/ligo /usr/local/bin/ligo
COPY --from=1 /home/opam/.opam/4.06/bin/tez* /usr/local/bin/
RUN apt update && apt-get install -y libgmp-dev libev-dev libusb-dev libhidapi-dev curl bash htop wget net-tools \
    nano vim iputils-ping jq ranger screen python3 git zsh locate busybox-static cpp net-tools
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN echo -e "http\t80/tcp\twww\t# WorldWideWeb HTTP" > /etc/services