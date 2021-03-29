FROM golang:1.16 AS build

# Build the app
WORKDIR /app
COPY . /app
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o /go/bin/app .

# Generate licence information
RUN go get github.com/google/go-licenses && go-licenses save ./... --save_path=/notices

FROM gcr.io/distroless/static:nonroot
COPY --from=build /go/bin/app /wiki
COPY --from=build /notices /notices
CMD ["/wiki"]