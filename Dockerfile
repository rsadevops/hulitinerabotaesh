#build
FROM alpine AS builder
WORKDIR /app
RUN apk add --update npm
COPY . .
RUN npm ci && npm run build

ENV NEW_RELIC_NO_CONFIG_FILE=true
ENV NEW_RELIC_DISTRIBUTED_TRACING_ENABLED=true \
NEW_RELIC_LOG=stdout
# etc.

#Run
FROM nginx:alpine AS runner
EXPOSE 80
EXPOSE 81
COPY --from=builder /app/build /usr/share/nginx/html
CMD ["nginx","-g","daemon off;"]
