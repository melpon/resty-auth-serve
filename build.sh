#!/bin/bash

source VERSION

set -e

rm -rf tmp
mkdir tmp
pushd tmp

git clone --depth=1 -b v$LUA_RESTY_OPENIDC  https://github.com/zmartzone/lua-resty-openidc.git
git clone --depth=1 -b v$LUA_RESTY_HTTP     https://github.com/ledgetech/lua-resty-http.git
git clone --depth=1 -b v$LUA_RESTY_SESSION  https://github.com/bungle/lua-resty-session.git
git clone --depth=1 -b v$LUA_RESTY_JWT      https://github.com/cdbattags/lua-resty-jwt.git

git clone                                   https://github.com/jkeys089/lua-resty-hmac.git
pushd lua-resty-hmac
git reset --hard $LUA_RESTY_HMAC
popd

popd

rm -rf docker/lua
mkdir -p docker/lua/resty
cp -r resty/*                           docker/lua/resty/
cp -r tmp/lua-resty-openidc/lib/resty/* docker/lua/resty/
cp -r tmp/lua-resty-http/lib/resty/*    docker/lua/resty/
cp -r tmp/lua-resty-session/lib/resty/* docker/lua/resty/
cp -r tmp/lua-resty-jwt/lib/resty/*     docker/lua/resty/
cp -r tmp/lua-resty-hmac/lib/resty/*    docker/lua/resty/
cp secret.lua                           docker/lua/secret.lua

docker build -t $RESTY_AUTH_SERVE_IMAGE --build-arg OPENRESTY_IMAGE=$OPENRESTY_IMAGE docker

rm -rf tmp
rm -rf docker/lua
