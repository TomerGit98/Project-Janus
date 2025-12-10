FROM golang:1.25-alpine AS builder
WORKDIR /app
COPY go.mod ./
COPY main.go ./
RUN go mod download
RUN go build -o server

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/server /app
EXPOSE 8080
CMD ["./server"]