Simple script for restart Substrate-based node systemd unit if peers count less than specified number.
It use prometheus metrics so need to launch node with `--prometheus-external` parameter.

How to use:
```
./zero_peers_handler.sh URL NETWORK PEERS_THRESHOLD
```
where
`URL` is local prometheus metrics URL
`NETWORK` is chain name from metrics, also you need to have the the same systemd service name (if you handle `robonomics` chain from metrics then you need to have `robonomics.service` launched)
`PEERS_THRESHOLD` is peers count, if your node has less peers than this number, it'a service will be restarted
