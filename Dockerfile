FROM ntrrg/hugo:0.62.2 as hugo
COPY . .
RUN hugo --baseUrl / -d /public

FROM ntrrg/nginx:http
COPY --from=hugo /public /usr/share/nginx/html

