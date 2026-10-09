package.path='Toolkit/?.lua;'..package.path
local stored,bindings,blocked,fail,launched,alert={}, {},false,false,nil,nil
local function signature(mods,key) return table.concat(mods,'+')..'+'..key end
hs={settings={get=function(k) return stored[k] end,set=function(k,v) stored[k]=v end},alert={show=function(message) alert=message end},
application={pathForBundleID=function(id) return id~='com.example.missing' and '/Applications/Probe.app' or nil end,launchOrFocusByBundleID=function(id) launched=id;return id~='com.example.failed' end},
hotkey={systemAssigned=function(_,key) return blocked and key=='9' end,assignable=function(mods,key) return not bindings[signature(mods,key)] end,
bind=function(mods,key,callback) if fail and key=='8' then return nil end;local sig=signature(mods,key);bindings[sig]=callback;return {delete=function() bindings[sig]=nil end} end}}
local m=require('modules.launcher')
local external=false
m.start(function(shortcut) return external and shortcut and shortcut.key=='K' end)
assert(not m.config.enabled and next(bindings)==nil)
local function config(key,id,enabled) return {enabled=enabled~=false,rules={{bundleID=id or 'com.example.probe',name='Probe',shortcut={key=key,mods={'cmd','ctrl'}}}}} end
assert(m.save(config('k')));assert(bindings['ctrl+cmd+K'])
bindings['ctrl+cmd+K']();assert(launched=='com.example.probe')
assert(m.conflicts({key='K',mods={'ctrl','cmd'}}))
assert(not m.conflicts({key='J',mods={'ctrl','cmd'}}))
assert(m.save(config('K')),'Saving existing binding should succeed')
external=true;assert(not m.save(config('K')));assert(bindings['ctrl+cmd+K']);external=false
blocked=true;assert(not m.save(config('9')));assert(bindings['ctrl+cmd+K']);blocked=false
fail=true;assert(not m.save(config('8')));assert(bindings['ctrl+cmd+K']);fail=false
assert(stored['desktoptoolkit.launcher.v1'].rules[1].shortcut.key=='K')
local duplicate=config('J');duplicate.rules[2]={bundleID='com.example.other',shortcut={key='j',mods={'ctrl','cmd'}}};assert(not m.save(duplicate))
duplicate.rules[2].shortcut.key='L';duplicate.rules[2].bundleID='com.example.probe';assert(not m.save(duplicate))
assert(not m.save({enabled=true,rules={{bundleID='invalid',shortcut={key='K',mods={'ctrl'}}}}}))
assert(m.save(config('','com.example.probe')) and next(bindings)==nil)
assert(m.save(config('J','com.example.probe',false)) and next(bindings)==nil)
assert(m.save(config('K','com.example.probe')))
-- Simulate a fresh process with persisted config.
bindings={};m.bindings={};m.start(function() return false end);assert(bindings['ctrl+cmd+K'])
assert(m.save(config('K','com.example.missing')));bindings['ctrl+cmd+K']();assert(alert:find('应用不可用',1,true))
assert(not m.open('com.example.failed'))
assert(m.save({enabled=false,rules={}}) and next(bindings)==nil)
print('App launch dispatch, validation, conflicts, registration rollback, unbind, disable and restart restoration passed')
