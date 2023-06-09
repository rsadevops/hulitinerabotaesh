#build
FROM alpine AS builder
WORKDIR /app
RUN apk add --update npm
COPY . .
RUN npm ci && npm run build

#Run
FROM nginx:alpine AS runner
EXPOSE 80
EXPOSE 81
COPY --from=builder /app/build /usr/share/nginx/html
CMD ["nginx","-g","daemon off;"]
