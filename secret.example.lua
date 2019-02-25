local _M = { }

local openidc_opts = {
  discovery = "https://accounts.google.com/.well-known/openid-configuration",
  redirect_uri = "https://<your-domain>/redirect_uri",
  client_id = "<client-id>",
  client_secret = "<client-secret>",
}

local function validate_user(user)
  local m, err = ngx.re.match(user.email, "^(?<name>.*)@(?<domain>.*)$")

  if m == nil then
    return false
  end

  if m["domain"] == nil then
    return false
  end

  domain = m['domain']

  -- 許可するドメインをここに並べる
  if domain == '<allow-domain>' then
    return true
  end

  if domain == '<allow-domain2>' then
    return true
  end

  return false
end

_M.openidc_opts = openidc_opts
_M.validate_user = validate_user

return _M
