# RYSEN IPSC UDP Proxy

Motorola IPSC UDP proxy for the [RYSEN](https://github.com/ShaYmez/RYSEN) stack — single public CPS Master port (**56002**) to many backend IPSC master slots.

Modelled on [RYSEN-SP-SELFCARE](https://github.com/ShaYmez/RYSEN-SP-SELFCARE) (hotspot proxy). Keeps a **separate Docker image** so IPSC deployments do not need the full RYSEN image for the proxy service.

`ipsc_proxy.py` and `ipsc_const.py` are maintained in sync with the main RYSEN repo.

## Quick start (Docker)

1. Copy `ipsc-proxy-SAMPLE.cfg` to your host config path (e.g. `/etc/rysen/ipsc-proxy.cfg`).
2. Set `MASTER` to the RYSEN container IP on your compose network (default `172.16.238.10`).
3. Match `DESTPORTSTART` / `DESTPORTEND` to the IPSC `GENERATOR` port range in `rysen.cfg`.

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
    networks:
        app_net:
          ipv4_address: 172.16.238.30
    read_only: true
```

## Quick start (bare metal)

```bash
pip install -r requirements.txt
cp ipsc-proxy-SAMPLE.cfg ipsc-proxy.cfg
# edit ipsc-proxy.cfg
python ipsc_proxy.py -c ipsc-proxy.cfg
```

## Configuration

| Key | Purpose |
|-----|---------|
| `MASTER` | Backend RYSEN / IPSC master IP |
| `LISTENPORT` | Public UDP port (CPS Master, usually 56002) |
| `LISTENIP` | Blank = IPv4; `::` = dual-stack |
| `DESTPORTSTART` / `DESTPORTEND` | Backend slot port pool |
| `TIMEOUT` | Idle peer timeout (seconds) |
| `BLACKLIST` / `IPBLACKLIST` | JSON radio ID / IP blocks |

Environment overrides: `FDPROXY_IPV6`, `FDPROXY_CLIENTINFO`, `FDPROXY_LISTENPORT`.

## Tests

```bash
python -m unittest discover -s tests -v
```

## Build image locally

```bash
docker build -t shaymez/rysen-sp-ipsc:latest .
```

## Related

- RYSEN IPSC docs: [ipsc-phase1.md](https://github.com/ShaYmez/RYSEN/blob/ipsc/doc/ipsc-phase1.md)
- RYSEN master: [ShaYmez/RYSEN](https://github.com/ShaYmez/RYSEN)
