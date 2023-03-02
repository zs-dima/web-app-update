#!/bin/sh

/app/bin/prepare-app-to-start app_environment=$APP_ENVIRONMENT app_version=$APP_VERSION

# Exec the CMD from the Dockerfile
exec "$@"