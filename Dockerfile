FROM python:alpine3.20

COPY entrypoint /entrypoint
RUN chmod +x /entrypoint

RUN adduser -D -u 54000 radio && \
    pip install --no-cache-dir --upgrade pip

WORKDIR /opt/rysen-sp-ipsc
COPY --chown=radio:radio . .

RUN pip install --no-cache-dir -r requirements.txt

USER radio

ENTRYPOINT [ "/entrypoint" ]
