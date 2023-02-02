FROM crystallang/crystal:0.36.0-alpine

RUN apk update
RUN apk add ruby
RUN apk add build-base

