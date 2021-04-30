# honeygain-socks

Run honeygain through a socks proxy

## Usage

```sh
docker run --rm --cap-add=NET_ADMIN --device /dev/net/tun \
-e HG_USER=<your_honeygain_email> \
-e HG_PASS=<your_honeygain_password> \
-e HG_NAME=<device_name> \
-e SOCKS_HOST=<host>:<port> \
-d failedshack/honeygain-socks
```

You can also use `SOCKS_PORT` to specify the port instead.
If `SOCKS_HOST` is omitted, it will connect to the network gateway, usually the host machine.
By default, the DNS server used will be 1.1.1.1, this can be changed with `DNS_SERVER`.

## Examples

### Forward honeygain traffic over SSH

```sh
nohup ssh -TND '*:1080' <your_user>@<SSH_server> &

docker run --rm --cap-add=NET_ADMIN --device /dev/net/tun \
-e HG_USER=<your_honeygain_email> \
-e HG_PASS=<your_honeygain_password> \
-e HG_NAME=<device_name> \
-d failedshack/honeygain-socks
```

First we create a SSH dynamic socks proxy, then we run the container.
As `SOCKS_HOST` is omitted, it will connect to port 1080 on the host by default.
You can change just the port by setting `SOCKS_PORT`.

Note that the socks server in this example is publicly accessible as the container is on a different network.
You may want to restrict this so other computers on your network cannot connect to it.
One such way is to listen on the `docker0` interface directly.
