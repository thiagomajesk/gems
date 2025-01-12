FROM "elixir:1.18-otp-27-alpine" AS builder

ENV MIX_ENV="prod"

RUN apk add --no-cache build-base git nodejs npm

WORKDIR /app

COPY lib lib
COPY rel rel
COPY priv priv
COPY assets assets
COPY mix.exs mix.lock .
COPY config/config.exs config/runtime.exs config/${MIX_ENV}.exs config/

RUN mix deps.get --only $MIX_ENV
RUN mix assets.setup && mix assets.deploy
RUN mix compile && mix release

FROM "alpine:latest" AS runner

ENV MIX_ENV="prod"

RUN apk add --no-cache libstdc++ openssl ncurses-libs ca-certificates
    
WORKDIR "/app"

RUN chown nobody /app

COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/gems ./

USER nobody

CMD ["/app/bin/server"]
