package.path='Toolkit/?.lua;'..package.path
local saved,drawn
hs={settings={set=function(_,v) saved=v end},host={cpuUsageTicks=function() return {overall={user=1,nice=0,system=1,idle=8}} end,vmStat=function() return {memSize=100,pageSize=1} end},fs={volume={allVolumes=function() return {} end}},network={primaryInterfaces=function() return 'en0' end,interfaceDetails=function() return {IPv4={Addresses={'192.0.2.1'}},IPv6={Addresses={'::1'}}} end}}
local s=require('modules.sys_info');s.draw=function() drawn=true end;s.mac='fixture';s.openSettings=function() end
local cfg=s.defaults();for _,field in ipairs(s.fields) do cfg[field]=false end
assert(s.save(cfg) and drawn and saved.network==false);local menu=s.menuItems();assert(#menu==3 and menu[1].disabled and menu[3].fn)
cfg.cpu=true;cfg.date=true;assert(s.save(cfg));menu=s.menuItems();assert(menu[1].title:match('^CPU:') and menu[2].title:match('^Date:') and #menu==4)
local invalid=s.defaults();invalid.disk='yes';assert(not s.save(invalid));assert(s.config.disk==false)
print('System display selection, all-hidden settings access and validation passed')
