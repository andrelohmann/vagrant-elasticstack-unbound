# Fetch the buster image
FROM golang:1.13.1-buster

# get unbound_exporter and build
RUN go get github.com/kumina/unbound_exporter
RUN go install github.com/kumina/unbound_exporter
