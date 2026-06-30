# RYSEN IPSC UDP Proxy

Docker image for the [RYSEN](https://github.com/ShaYmez/RYSEN) stack: one public CPS Master UDP port (**56002**) to many backend IPSC master slots.

**Image:** `shaymez/rysen-sp-ipsc:latest`

## Docker

Copy `sync/ipsc-proxy-SAMPLE.cfg` to your host (e.g. `/etc/rysen/ipsc-proxy.cfg`) and set `MASTER` to your RYSEN instance on the compose network.

```yaml
ipsc-proxy:
    container_name: ipsc-proxy
    image: shaymez/rysen-sp-ipsc:latest
    volumes:
        - '/etc/rysen/ipsc-proxy.cfg:/opt/rysen-sp-ipsc/ipsc-proxy.cfg'
    ports:
        - '56002:56002/udp'
    restart: unless-stopped
    depends_on:
        - rysen
    read_only: true
```

## Configuration

| Key | Purpose |
|-----|---------|
| `MASTER` | Backend RYSEN / IPSC master IP |
| `LISTENPORT` | Public UDP port (usually 56002) |
| `DESTPORTSTART` / `DESTPORTEND` | Backend slot port range |
| `TIMEOUT` | Idle peer timeout (seconds) |

See [RYSEN IPSC docs](https://github.com/ShaYmez/RYSEN/blob/ipsc/doc/ipsc-phase1.md) for full deployment notes.
