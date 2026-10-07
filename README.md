# github_runner

Ready-to-use setups for running **GitHub Actions self-hosted runners**.

Each branch holds one runner architecture, so it stays self-contained. Pick the branch that fits your needs, check it out, and follow its own README. The `main` branch has no runner code. It only lists what is available.

## Available runners

| Branch | Description | Status |
|--------|-------------|--------|
| [`runner_simple`](../../tree/runner_simple) | A single Docker container that registers itself with a GitHub **organization** at startup (Docker Compose, non-root user, `amd64` / `arm64` / `arm`) | Available |

## Getting started

```bash
git clone git@github.com:CiPipes/github_runner.git
cd github_runner
git checkout runner_simple   # or any branch from the table above
```

Then follow the `README.md` of that branch.

To list every available runner branch:

```bash
git branch -r
```

## Adding a new runner architecture

1. Create a new branch from `main`: `git checkout -b runner_<name> main`
2. Add the runner files and a `README.md` that covers requirements, configuration and usage.
3. Never commit secrets. Ship a `.env-template` and git-ignore `.env`.
4. Add a row for the new branch to the table above, on `main`.
