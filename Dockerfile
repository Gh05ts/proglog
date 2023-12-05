FROM golang:1.20-alpine AS build
WORKDIR /home/gh05t/proglog
COPY . .

RUN CGO_ENABLED=0 go build -o /home/gh05t/go/bin/proglog ./cmd/proglog

RUN GRPC_HEALTH_PROBE_VERSION=v0.3.2 \
    && wget -qO /home/gh05t/go/bin/grpc_health_probe \
    https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /home/gh05t/go/bin/grpc_health_probe

FROM scratch
COPY --from=build /home/gh05t/go/bin/proglog /bin/proglog
COPY --from=build /home/gh05t/go/bin/grpc_health_probe /bin/grpc_health_probe
# COPY --from=build /home/gh05t/proglog/.proglog /usr/local/.proglog
ENTRYPOINT [ "/bin/proglog" ]
