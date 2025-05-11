FROM golang:1.24 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -ldflags "-w -s -extldflags '-static'" -o build/fizzbuzz

FROM scratch

COPY --from=builder /app/build/fizzbuzz /fizzbuzz
COPY --from=builder /app/templates/index.html /templates/index.html

EXPOSE 8080

CMD ["./fizzbuzz", "serve"]
