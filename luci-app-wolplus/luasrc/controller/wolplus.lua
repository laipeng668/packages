module("luci.controller.wolplus", package.seeall)
local nixio_fs = require("nixio.fs")
local luci_http = require("luci.http")
local luci_uci = require("luci.model.uci").cursor()

function index()
	if not nixio_fs.access("/etc/config/wolplus") then return end
	entry({"admin", "services", "wolplus"}, cbi("wolplus"), _("Wake on LAN +"), 95).dependent = true
	entry({"admin", "services", "wolplus", "awake"}, post("awake")).leaf = true
end

function awake(sections)
	local lan = luci_uci:get("wolplus", sections, "maceth")
	local mac = luci_uci:get("wolplus", sections, "macaddr")
	local cmd = string.format("/usr/bin/etherwake -b -D -i %s %s 2>&1", lan, mac)
	local result = {}
	local pipe = io.popen(cmd)
	local msg = ""

	if pipe then
		for line in pipe:lines() do
			msg = msg .. (line:len() > 100 and line:sub(1, 100) .. "..." or line)
		end
		pipe:close()
	end

	result["data"] = msg
	luci_http.prepare_content("application/json")
	luci_http.write_json(result)
end