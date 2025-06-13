local LUCI_SYS = require("luci.sys")

local t = Map("wolplus", translate("Wake on LAN +"), translate("Wake on LAN + is a mechanism to remotely boot computers in the local network.") .. [[<br/><br/><a href="https://github.com/sundaqiang/openwrt-packages" target="_blank">Powered by sundaqiang</a>]])
t.template = "wolplus/index"

local e = t:section(TypedSection, "macclient", translate("Host Clients"))
e.template = "cbi/tblsection"
e.anonymous = true
e.addremove = true

-- Add device section
local a = e:option(Value, "name", translate("Name"))
a.optional = false

-- MAC address
local nolimit_mac = e:option(Value, "macaddr", translate("MAC Address"))
nolimit_mac.rmempty = false
LUCI_SYS.net.mac_hints(function(mac, name)
	nolimit_mac:value(mac, "%s (%s)" % {mac, name})
end)

-- Network interface
local nolimit_eth = e:option(Value, "maceth", translate("Network Interface"))
nolimit_eth.rmempty = false
nolimit_eth.default = "br-lan"
for _, device in ipairs(LUCI_SYS.net.devices()) do
	if device ~= "lo" then
		nolimit_eth:value(device)
	end
end

-- Wake device
local btn = e:option(Button, "_awake", translate("Wake Up Host"))
btn.inputtitle = translate("Awake")
btn.inputstyle = "apply"
btn.disabled = false
btn.template = "wolplus/awake"

-- Generate UUID
local function gen_uuid()
	local uuid = LUCI_SYS.exec("echo -n $(cat /proc/sys/kernel/random/uuid)")
	return uuid:gsub("-", "")
end

-- Create function
function e.create(_, uuid)
	uuid = gen_uuid()
	TypedSection.create(e, uuid)
end

return t