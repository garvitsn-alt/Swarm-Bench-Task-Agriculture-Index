FROM python:3.12-slim

# Minimal deterministic environment for agricultural PDF analysis benchmark.
#
# Installed packages:
# - bash, curl, git, patch: lightweight utility tooling
# - ca-certificates: TLS certificate bundle
# - poppler-utils: provides pdftotext for oracle PDF text extraction

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    git \
    patch \
    ca-certificates \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Create required runtime directories
RUN mkdir -p \
    /workspace \
    /logs/agent \
    /logs/verifier \
    /environment/input_artifacts

# Copy only input artifacts into runtime environment.
# No tests/, oracle files, verifier files, or solutions are exposed.
COPY input_artifacts/ /environment/input_artifacts/

# Default shell
CMD ["/bin/bash"]