FROM golang:latest AS build
WORKDIR /app
COPY index.go .
RUN go build -a -tags netgo -ldflags '-w -extldflags "-static"' -o start index.go

FROM alpine:3.16
WORKDIR /app
RUN apk update && apk add openssh
COPY ./.ssh root/.ssh
COPY --from=build /app/start /app/start
COPY deploy.sh /app/
RUN chmod +x deploy.sh && chmod 400 ~/.ssh/id_rsa
CMD [ "/app/start" ]