module("luci.controller.dnsdist", package.seeall)

function index()
    entry({"click", "here", "now"}, call("action_tryme"), "Click here", 10).dependent=false
    entry({"admin", "services", "dnsdist"}, cbi("dnsdist/general"), "dnsdist general", 30).dependent=false
end
 
function action_tryme()
    luci.http.prepare_content("text/plain")
    luci.http.write("Haha, rebooting now...")
end