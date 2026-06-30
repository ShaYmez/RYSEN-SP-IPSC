FROM python:alpine3.20

COPY entrypoint /entrypoint
RUN chmod +x /entrypoint

RUN adduser -D -u 54000 radio && \
    apk add --no-cache gcc musl-dev && \
    pip install --no-cache-dir --upgrade pip

WORKDIR /opt/rysen-sp-ipsc

COPY requirements.txt version.txt ./
COPY sync/ipsc_proxy.py sync/ipsc_const.py sync/ipsc-proxy-SAMPLE.cfg ./

RUN pip install --no-cache-dir -r requirements.txt && \
    apk del gcc musl-dev

USER radio

ENTRYPOINT [ "/entrypoint" ]
