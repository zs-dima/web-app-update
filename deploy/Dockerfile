FROM dart:stable AS build_dart

WORKDIR /app

COPY ./tool/ ./tool/
RUN dart compile exe tool/prepare_app_to_start.dart -o tool/prepare-app-to-start


FROM plugfox/flutter:stable-web AS build_web

WORKDIR /home

COPY . .

# Ensure packages are still up-to-date if anything has changed
RUN flutter pub get
RUN flutter pub run build_runner build --delete-conflicting-outputs --release
RUN flutter build web --release --no-source-maps \
    --no-tree-shake-icons --pwa-strategy offline-first \
    --web-renderer canvaskit --base-href /


#FROM nginx:alpine as production
FROM arm64v8/nginx:latest as production

COPY --from=build_dart /runtime/ /
COPY --from=build_dart /app/tool/prepare-app-to-start /app/bin/
COPY --from=build_dart /app/tool/entrypoint.sh /app/bin/

COPY --from=build_web /home/build/web /usr/share/nginx/html
COPY deploy/nginx/mime.types /etc/nginx/mime.types
COPY deploy/nginx/nginx.conf /etc/nginx/nginx.conf

RUN chmod +x /app/bin/entrypoint.sh

# Add lables
LABEL name="WebAppUpdate" \
    vcs-url="https://github.com/zs-dima/web-app-update.git" \
    github="https://github.com/zs-dima/web-app-update" \
    maintainer="@zs-dima" \
    authors="@zs-dima"

# Start server
EXPOSE 80/tcp

ENTRYPOINT ["/app/bin/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]