# Use the official PocketBase image as base
FROM alpine:3.19

# Install ca-certificates for HTTPS requests
RUN apk --no-cache add ca-certificates

# Set the working directory
WORKDIR /pb

# Download PocketBase
ARG PB_VERSION=0.30.4
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/ && \
    chmod +x /pb/pocketbase && \
    rm /tmp/pb.zip

# Create directory for the database and other data
RUN mkdir -p /pb/pb_data

# Expose the default PocketBase port
EXPOSE 8090

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8090/api/health || exit 1

# Add non-root user
RUN addgroup -g 1001 -S pocketbase && \
    adduser -u 1001 -S pocketbase -G pocketbase

# Change ownership of the pb directory
RUN chown -R pocketbase:pocketbase /pb

# Switch to non-root user
USER pocketbase

# Command to run PocketBase
CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8090", "--dir=/pb/pb_data", "--publicDir=/pb/pb_public"]
