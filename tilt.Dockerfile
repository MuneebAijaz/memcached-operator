
FROM alpine:3.17.3
WORKDIR /
COPY ./bin/manager /manager
# USER 65532:65532

ENTRYPOINT ["/manager"]
