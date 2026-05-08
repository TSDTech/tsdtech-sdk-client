# Stage 1: Build Flutter web app
FROM instrumentisto/flutter:3.32.3 AS build

ARG CAMINHO=""

ENV TZ=America/Sao_Paulo

ARG STAGE="dev"
ARG VERSION="0001"  # Passed from Cloud Build as $SHORT_SHA
ARG BACKEND_URL="https://spa-backend-spa-desenv.apps.ocpnoprod.detran.df"
ARG FRONTEND_URL="https://spa-portal-cidadao-spa-desenv.apps.ocpnoprod.detran.df"

# ARG STAGE="hml"
# ARG VERSION="0001"  # Passed from Cloud Build as $SHORT_SHA
# ARG BACKEND_URL="https://spa-backend-spa-desenv.apps.ocpnoprod.detran.df"
# ARG FRONTEND_URL="https://spa-portal-cidadao-spa-desenv.apps.ocpnoprod.detran.df"

# ARG STAGE="prod"
# ARG VERSION="0001"  # Passed from Cloud Build as $SHORT_SHA
# ARG BACKEND_URL="https://spa-backend-spa-desenv.apps.ocpnoprod.detran.df"
# ARG FRONTEND_URL="https://spa-portal-cidadao-spa-desenv.apps.ocpnoprod.detran.df"

WORKDIR /usr/src/app

RUN mkdir /usr/src/app/temp
COPY . /usr/src/app/temp

RUN cp /usr/src/app/temp/${CAMINHO}/pubspec.yaml /usr/src/app/

RUN cp -Rf /usr/src/app/temp/${CAMINHO}/* /usr/src/app/

RUN flutter pub get
# Build with base-href set to /$VERSION/ (replaces $FLUTTER_BASE_HREF in index.html automatically)
# Forward BACKEND_URL and FRONTEND_URL into the build via --dart-define so the app
# can access them at compile time.
RUN flutter build web --base-href="/$VERSION/" \
	--dart-define=STAGE=$STAGE \
	--dart-define=BACKEND_URL=$BACKEND_URL \
	--dart-define=FRONTEND_URL=$FRONTEND_URL \
	--release --pwa-strategy=none

# Restructure for versioned deployment: copy all (including dotfiles) to /$VERSION/, then elevate index.html to root
RUN mkdir -p /usr/src/output/$VERSION \
 && cp -a build/web/. /usr/src/output/$VERSION/ \
 && mv /usr/src/output/$VERSION/index.html /usr/src/output/index.html \
 && cp /usr/src/output/$VERSION/version.json /usr/src/output/version.json  # Opcional: para checks client-side de versão (no-cache via location /)

# Stage 2: Runtime with Nginx for proper caching headers
FROM nginxinc/nginx-unprivileged:alpine

WORKDIR /usr/share/nginx/html
ENV TZ=America/Sao_Paulo

# Copy restructured build output
COPY --from=build /usr/src/output/. /usr/share/nginx/html/

# Copy custom Nginx config (add this file to your repo)
COPY --from=build /usr/src/app/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]