FROM elixir:1.10-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm yarn git python

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get
# this line was included to fix out of memory issue when compiling idna
RUN cd deps/idna && /root/.mix/rebar3 compile
RUN mix deps.compile

# build assets
COPY assets/package.json assets/yarn.lock ./assets/
RUN cd assets && yarn install --frozen-lockfile

COPY priv priv
COPY assets assets
RUN cd assets && yarn deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache bash openssl ncurses-libs

EXPOSE 4000
ENV MIX_ENV=prod

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/review_app ./
COPY docker/docker-entrypoint.sh .

ENV HOME=/app

CMD ["bash", "/app/docker-entrypoint.sh"]
