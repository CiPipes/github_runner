FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-noble

ARG USERNAME=github_runner
ARG USER_UID=1001
ARG USER_GID=1001
ARG TARGETARCH
ARG RUNNER_VERSION=2.328.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl jq && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN groupadd -g ${USER_GID} ${USERNAME} || true && \
    useradd -u ${USER_UID} -g ${USERNAME} -m -s /bin/bash ${USERNAME}

WORKDIR /home/${USERNAME}

RUN case "${TARGETARCH}" in \
        amd64) RUNNER_ARCH=x64 ;; \
        arm64) RUNNER_ARCH=arm64 ;; \
        arm) RUNNER_ARCH=arm ;; \
        *) echo "Unsupported TARGETARCH: ${TARGETARCH}" >&2; exit 1 ;; \
    esac \
    && curl -f -L -o runner.tar.gz https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./runner.tar.gz \
    && rm runner.tar.gz

COPY runner_entrypoint.sh /usr/local/bin/runner_entrypoint.sh
RUN chmod +x /usr/local/bin/runner_entrypoint.sh

USER ${USERNAME}
ENTRYPOINT ["/usr/local/bin/runner_entrypoint.sh"]
