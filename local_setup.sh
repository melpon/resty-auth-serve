#!/bin/bash

source VERSION

set -e

cd local

if [ ! -e lua-resty-openidc ]; then
  git clone --depth=1 -b v$LUA_RESTY_OPENIDC  https://github.com/zmartzone/lua-resty-openidc.git
fi

if [ ! -e lua-resty-http ]; then
  git clone --depth=1 -b v$LUA_RESTY_HTTP     https://github.com/ledgetech/lua-resty-http.git
fi

if [ ! -e lua-resty-session ]; then
  git clone --depth=1 -b v$LUA_RESTY_SESSION  https://github.com/bungle/lua-resty-session.git
fi

if [ ! -e lua-resty-jwt ]; then
  git clone --depth=1 -b v$LUA_RESTY_JWT      https://github.com/cdbattags/lua-resty-jwt.git
fi

if [ ! -e lua-resty-hmac ]; then
  git clone                                   https://github.com/jkeys089/lua-resty-hmac.git
  pushd lua-resty-hmac
  git reset --hard $LUA_RESTY_HMAC
  popd
fi
