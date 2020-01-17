ARG GO_VERSION=1.12

# first stage - prepare environment to build
FROM golang:${GO_VERSION}-alpine AS dev

# disable cgo to build statically
ENV GO111MODULE="on" \
    CGO_ENABLED=0 \
    GOOS=linux

ENV APP_NAME="main" \
    APP_PATH="/gog" \
    APP_PORT=8080

ENV APP_BUILD_NAME="${APP_NAME}"

# install git on alpine image to use go get
RUN apk add --update git

# cache go mod
RUN mkdir ${APP_PATH}
WORKDIR ${APP_PATH}
COPY go.mod .
COPY go.sum .
RUN go mod download

# copy rest of the code
COPY . .

EXPOSE ${APP_PORT}
ENTRYPOINT ["sh"]

# second stage - build application binary
FROM dev AS build

RUN go build -ldflags="-s -w" -o ${APP_BUILD_NAME} gog/cmd/main
RUN chmod +x ${APP_BUILD_NAME}

# third stage - put our binary in docker scratch image
FROM alpine AS prod

ENV APP_BUILD_NAME="main" \
    APP_BUILD_PATH="/gog" \
    APP_LOG="/log"

WORKDIR ${APP_BUILD_PATH}
RUN mkdir -p ./log
COPY --from=build ${APP_BUILD_PATH}/${APP_BUILD_NAME} ${APP_BUILD_NAME}

EXPOSE ${APP_PORT}
ENTRYPOINT ["/gog/main"]
CMD ""
