local sys = require "luci.sys"

local m = Map("dnsdist", "dnsdist")

local general = m:section(NamedSection, "general", "General")

local enabled = general:option(Flag, "enabled", "Enabled", "Whether dnsdist is enabled")
enabled.rmempty=false

local port = general:option(Value, "listen_port", "Listen port", "Port that dnsdist listens on for queries from clients")
port.datatype = 'port'
port.rmempty = false

local pools = m:section(TypedSection, "pool", "Pools", "Manage dnsdist backend pools")
pools.addremove = true

local penabled = pools:option(Flag, "enabled", "Enabled", "Whether this pool is enabled")
penabled.rmempty = false
local ptls = pools:option(Flag, "tls", "DoT", "Whether DoT is used to this pool")
ptls.rmempty = false
local pservers = pools:option(DynamicList, "server", "servers")
pservers.rmempty = false

function enabled.cfgvalue(self, section)
  return sys.init.enabled('dnsdist') and self.enabled or self.disabled
end

function enabled.write(self, section, value)
  if value == '1' then
    sys.init.enable('dnsdist')
    sys.init.start('dnsdist')
  else
    sys.init.stop('dnsdist')
    sys.init.disable('dnsdist')
  end

  return Flag.write(self, section,value)
end

function m.on_commit(self)
  if sys.init.enabled('dnsdist') then
    sys.init.restart('dnsdist')
  else
    sys.init.stop('dnsdist')
  end
end

return m
