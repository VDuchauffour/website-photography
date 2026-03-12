FROM ghcr.io/gohugoio/hugo:v0.157.0 AS build
COPY . /project
RUN ["hugo", "--gc", "--minify"]

FROM nginx:alpine
COPY --from=build /project/public /usr/share/nginx/html
EXPOSE 80
