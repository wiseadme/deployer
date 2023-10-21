FROM golang:alpine AS build
WORKDIR /app
COPY index.go .
RUN go build -a -tags netgo -ldflags '-w -extldflags "-static"' -o start *.go

FROM alpine:3.7
WORKDIR /app
RUN apk update && apk add openssh
COPY ./.ssh root/.ssh
COPY --from=build /app/start /app/start
COPY ./deploy /app/deploy
RUN chmod +x ./deploy && chmod 400 ~/.ssh/id_rsa
CMD [ "/app/start" ]