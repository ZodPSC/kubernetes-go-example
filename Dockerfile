FROM golang:1.23.4 AS build-stage

WORKDIR /app
COPY go.mod ./
#COPY go.sum ./
RUN go mod download

COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /kubernetes-go-example

# deploy
FROM gcr.io/distroless/static-debian12 AS build-release-stage

WORKDIR /

COPY --from=build-stage /kubernetes-go-example /kubernetes-go-example

EXPOSE 8088

USER nonroot:nonroot

ENTRYPOINT ["/kubernetes-go-example"]