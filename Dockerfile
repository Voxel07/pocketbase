FROM alpine:3.19

RUN apk --no-cache add ca-certificates

WORKDIR /pb

ARG PB_VERSION=0.36.1
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/ && \
    chmod +x /pb/pocketbase && \
    rm /tmp/pb.zip

RUN mkdir -p /pb/pb_data

EXPOSE 8090

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8090/api/health || exit 1

RUN addgroup -g 1001 -S pocketbase && \
    adduser -u 1001 -S pocketbase -G pocketbase

RUN chown -R pocketbase:pocketbase /pb

USER pocketbase

CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8090", "--dir=/pb/pb_data", "--publicDir=/pb/pb_public"]
