FROM --platform=$BUILDPLATFORM node:17.7-alpine3.14 AS client-builder
WORKDIR /app/client
# cache packages in layer
COPY client/package.json /app/client/package.json
COPY client/package-lock.json /app/client/package-lock.json
RUN --mount=type=cache,target=/usr/src/app/.npm \
    npm set cache /usr/src/app/.npm && \
    npm ci
# install
COPY client /app/client
RUN npm run build

FROM golang:1.17-alpine AS builder
ENV CGO_ENABLED=0
WORKDIR /backend
COPY vm/go.* .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go mod download
COPY vm/. .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go build -trimpath -ldflags="-s -w" -o bin/service

FROM alpine:3.15

LABEL org.opencontainers.image.title="VS Code for the Web"
LABEL org.opencontainers.image.description="Docker Extension for using an embedded VS Code for the Web."
LABEL org.opencontainers.image.vendor="Marcelo Ochoa"
LABEL com.docker.desktop.extension.api.version=">= 0.2.3"
LABEL com.docker.extension.categories="utility-tools,cloud-development"
LABEL com.docker.extension.screenshots="[{\"alt\":\"Welcome Page\", \"url\":\"https://raw.githubusercontent.com/marcelo-ochoa/coder-docker-extension/main/docs/images/screenshot1.png\"},\
    {\"alt\":\"Change Project Folder\", \"url\":\"https://raw.githubusercontent.com/marcelo-ochoa/coder-docker-extension/main/docs/images/screenshot2.png\"},\
    {\"alt\":\"Clone a New Project\", \"url\":\"https://raw.githubusercontent.com/marcelo-ochoa/coder-docker-extension/main/docs/images/screenshot3.png\"},\
    {\"alt\":\"VS Code Web in Action\", \"url\":\"https://raw.githubusercontent.com/marcelo-ochoa/coder-docker-extension/main/docs/images/screenshot4.png\"},\
    {\"alt\":\"Dark Mode\", \"url\":\"https://raw.githubusercontent.com/marcelo-ochoa/coder-docker-extension/main/docs/images/screenshot5.png\"}]"
LABEL com.docker.extension.publisher-url="https://github.com/marcelo-ochoa/coder-docker-extension"
LABEL com.docker.extension.additional-urls="[{\"title\":\"Documentation\",\"url\":\"https://github.com/marcelo-ochoa/coder-docker-extension/blob/main/README.md\"},\
    {\"title\":\"License\",\"url\":\"https://github.com/marcelo-ochoa/coder-docker-extension/blob/main/LICENSE\"}]"
LABEL com.docker.extension.detailed-description="Docker Extension for using VS Code for the Web"
LABEL com.docker.extension.changelog="See full <a href=\"https://github.com/marcelo-ochoa/coder-docker-extension/blob/main/CHANGELOG.md\">change log</a>"
LABEL com.docker.desktop.extension.icon="https://raw.githubusercontent.com/marcelo-ochoa/coder-docker-extension/main/client/public/favicon.ico"
LABEL com.docker.extension.detailed-description="VS Code for the Web enables organizations to set up development environments in the cloud. Environments are defined with \
    Terraform, connected through a secure high-speed Wireguard® tunnel, and are automatically shut down when not in \
    use to save on costs. Coder gives engineering teams the flexibility to use the cloud for workloads that are most \
    beneficial to them."
COPY coder.svg metadata.json docker-compose.yml ./

COPY --from=client-builder /app/client/dist ui
COPY --from=builder /backend/bin/service /

CMD /service -socket /run/guest-services/coder-docker-extension.sock
