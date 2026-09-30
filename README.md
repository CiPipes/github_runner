# GitHub Actions Self-Hosted Runner (Docker)

A minimal Docker image that runs a GitHub Actions self-hosted runner and registers it with your **GitHub organization** automatically at startup.

| File | Role |
|------|------|
| [Dockerfile](Dockerfile) | Builds the image: installs `curl`/`jq`, creates a non-root user, downloads the runner for the target architecture (`amd64`, `arm64`, `arm`) |
| [runner_entrypoint.sh](runner_entrypoint.sh) | Fetches a registration token from the GitHub API, registers the runner, starts it |
| [docker-compose.yaml](docker-compose.yaml) | Builds and runs the service with `restart: always` |

## Requirements

- Docker with Docker Compose
- A GitHub organization you administer
- A Personal Access Token that can manage organization runners:
  - classic PAT: `admin:org` scope
  - fine-grained PAT: organization permission **Self-hosted runners: Read and write**

## Quick start

```bash
cp .env-template .env      # then set GITHUB_PAT and GITHUB_ORG
docker compose up --build -d
docker compose logs -f github-runner
```

The runner then appears under **Organization settings → Actions → Runners**.

## Configuration

| Variable | Where | Description |
|----------|-------|-------------|
| `GITHUB_PAT` | `.env` | Token used to request a short-lived registration token |
| `GITHUB_ORG` | `.env` | Organization name, e.g. `my-company` |
| `RUNNER_NAME` | `docker-compose.yaml` | Name displayed in GitHub |
| `RUNNER_LABELS` | `docker-compose.yaml` | Comma-separated labels used by `runs-on` |
| `RUNNER_VERSION` | build arg | [actions/runner](https://github.com/actions/runner/releases) version (default `2.328.0`) |

> Values under `environment:` in `docker-compose.yaml` take precedence over `.env`. To set the name and labels from `.env`, remove them from the Compose file.

Target the runner from a workflow:

```yaml
jobs:
  build:
    runs-on: [self-hosted, mylabel]
```

## Without Compose

```bash
docker build -t github-runner .
docker run -d --name github-runner --env-file .env \
  -e RUNNER_NAME=my-runner -e RUNNER_LABELS=mylabel \
  github-runner
```

## Troubleshooting

- **Container exits immediately / runner never registers**: check `docker compose logs github-runner`. Usually an expired PAT, missing permissions, or a wrong `GITHUB_ORG`.
- **Runner shows as offline in GitHub**: the container stopped without deregistering. Remove it from the runners list, or restart the container: `--replace` re-registers a runner with the same name.

## Notes

- The runner runs as the non-root user `github_runner`.
- `.env` holds your PAT and is git-ignored. Never commit it.
