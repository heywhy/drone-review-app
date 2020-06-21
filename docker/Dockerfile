FROM alpine:3.6 as alpine
RUN apk add -U --no-cache ca-certificates

FROM alpine:3.6
EXPOSE 3000

COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ADD bin/deployer /bin/
ENTRYPOINT ["/bin/deployer"]