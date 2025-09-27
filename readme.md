# PocketBase Docker

A production-ready Docker container for [PocketBase](https://pocketbase.io/), automatically built and deployed to GitHub Container Registry.

## Features

- 🐳 Multi-platform support (AMD64 & ARM64)
- 🔒 Security-first approach (non-root user, minimal base image)
- 🚀 Automated CI/CD with GitHub Actions
- 📊 Built-in health checks
- 🏷️ Semantic versioning support
- ⚡ Optimized builds with caching

## Quick Start

### Pull and Run

```bash
# Pull the latest image
docker pull ghcr.io/your-username/your-repo/pocketbase:latest

# Run PocketBase
docker run -d \
  --name pocketbase \
  -p 8090:8090 \
  -v pocketbase_data:/pb/pb_data \
  ghcr.io/your-username/your-repo/pocketbase:latest
```

### Using Docker Compose

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  pocketbase:
    image: ghcr.io/your-username/your-repo/pocketbase:latest
    container_name: pocketbase
    restart: unless-stopped
    ports:
      - "8090:8090"
    volumes:
      - pocketbase_data:/pb/pb_data
      - pocketbase_public:/pb/pb_public
    environment:
      - POCKETBASE_ENCRYPTION_KEY=${POCKETBASE_ENCRYPTION_KEY:-}
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:8090/api/health"]
      interval: 30s
      timeout: 3s
      retries: 3

volumes:
  pocketbase_data:
  pocketbase_public:
```

Then run:

```bash
docker compose up -d
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `POCKETBASE_ENCRYPTION_KEY` | Encryption key for the database | Auto-generated |

### Volumes

- `/pb/pb_data` - Database and configuration files
- `/pb/pb_public` - Static files served by PocketBase

### Ports

- `8090` - PocketBase HTTP server

## Available Tags

| Tag | Description |
|-----|-------------|
| `latest` | Latest stable build from main branch |

## Development

### Project Structure

```
.
├── .github/
│   └── workflows/
│       └── pocketbase.yml    # CI/CD pipeline
├── Dockerfile                # Multi-stage Docker build
├── docker-compose.yml        # Local development setup
└── README.md                 # This file
```

### CI/CD Pipeline

The GitHub Actions workflow automatically:

1. Builds multi-platform Docker images
2. Runs security scans
3. Publishes to GitHub Container Registry
4. Creates build attestations for supply chain security

### Triggering Builds

- **Push to `main`**: Creates `latest` tag
- **Push to `develop`**: Creates `develop` tag
- **Create tag `v*`**: Creates versioned tags
- **Pull requests**: Builds but doesn't publish

## Security

- Container runs as non-root user (UID 1001)
- Uses minimal Alpine Linux base image
- Regular security updates via automated builds
- Build provenance attestations included

## Links

- [PocketBase Documentation](https://pocketbase.io/docs/)
- [GitHub Container Registry](https://ghcr.io)
- [Docker Hub](https://hub.docker.com)
- [GitHub Actions](https://github.com/features/actions)

## Support

- 🐛 [Report bugs](https://github.com/your-username/your-repo/issues)
- 💡 [Request features](https://github.com/your-username/your-repo/issues)
- 📚 [Documentation](https://pocketbase.io/docs/)
- 💬 [Community Discord](https://discord.gg/pocketbase)