# RYSEN IPSC UDP Proxy (Docker image)

Motorola IPSC UDP proxy for the [RYSEN](https://github.com/ShaYmez/RYSEN) stack — single public CPS Master port (**56002**) to many backend IPSC master slots.

Published as **`shaymez/rysen-sp-ipsc:latest`**, modelled on [RYSEN-SP-SELFCARE](https://github.com/ShaYmez/RYSEN-SP-SELFCARE) (hotspot proxy). Keeps a **separate slim Docker image** so IPSC deployments do not need the full RYSEN image for the proxy service.

## Develop in RYSEN; publish here

**Source of truth:** [ShaYmez/RYSEN](https://github.com/ShaYmez/RYSEN) (`ipsc` branch). Edit proxy logic, constants, sample config, and tests **only in RYSEN**.

This repo **syncs** those files into [`sync/`](sync/) and [`tests/`](tests/), then builds and pushes the Docker image. Do not hand-edit synced copies — they are overwritten by [`.github/workflows/sync-from-rysen.yml`](.github/workflows/sync-from-rysen.yml).

| Synced from RYSEN | Local path |
|-------------------|------------|
| `ipsc_proxy.py` | `sync/ipsc_proxy.py` |
| `ipsc_const.py` | `sync/ipsc_const.py` |
| `ipsc-proxy-SAMPLE.cfg` | `sync/ipsc-proxy-SAMPLE.cfg` |
| `tests/test_ipsc_proxy.py` | `tests/test_ipsc_proxy.py` |

Refresh: **Actions → Sync from RYSEN** (manual), `repository_dispatch` event `rysen-ipsc-updated`, or daily scheduled sync. A sync commit triggers **Build-RYSEN-SP-IPSC** (tests, then image push).

## Quick start (Docker)

1. Copy `sync/ipsc-proxy-SAMPLE.cfg` to your host config path (e.g. `/etc/rysen/ipsc-proxy.cfg`).
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
cp sync/ipsc-proxy-SAMPLE.cfg ipsc-proxy.cfg
# edit ipsc-proxy.cfg
PYTHONPATH=sync python sync/ipsc_proxy.py -c ipsc-proxy.cfg
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
pip install -r requirements.txt
PYTHONPATH=sync python -m unittest discover -s tests -v
```

## Build image locally

```bash
docker build -t shaymez/rysen-sp-ipsc:latest .
```

## CI secrets

Docker Hub push requires repository secrets: `DOCKER_USERNAME`, `DOCKER_PASSWORD`.

## Related

- RYSEN IPSC docs: [ipsc-phase1.md](https://github.com/ShaYmez/RYSEN/blob/ipsc/doc/ipsc-phase1.md)
- RYSEN master: [ShaYmez/RYSEN](https://github.com/ShaYmez/RYSEN)
