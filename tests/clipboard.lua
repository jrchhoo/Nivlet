package.path="Toolkit/?.lua;"..package.path
local now,count,text,types,bundle,saved=1000,0,"before",{},"org.test.editor",nil
local reads,starts,stops=0,0,0
hs={settings={clear=function() end,get=function() return saved end,set=function(_,v) saved=v end},
 timer={secondsSinceEpoch=function() return now end,doEvery=function(_,fn) starts=starts+1;return {stop=function() stops=stops+1 end} end},
 application={frontmostApplication=function() return {bundleID=function() return bundle end} end},
 pasteboard={readImage=function() return nil end,changeCount=function() return count end,contentTypes=function() return types end,
 getContents=function() reads=reads+1;return text end,setContents=function(v) text=v;count=count+1;return true end}}
local m=require('modules.clipboard');m.start();assert(starts==0 and reads==0)
local config=m.defaults();config.enabled=true;config.limit=10;config.minutes=1;config.excluded={'org.test.passwords'}
assert(m.save(config));m.poll();assert(#m.entries==0 and reads==0)
local function copy(v,t) text=v;types=t or {};count=count+1;m.poll() end
copy('one');copy('two');copy('one');assert(#m.entries==2 and m.entries[1].text=='one')
local id=m.entries[1].id;assert(m.copy(id));m.poll();assert(#m.entries==2)
assert(m.pause());copy('paused');assert(#m.entries==2);assert(m.pause());m.poll();assert(#m.entries==2)
bundle='org.test.passwords';local prior=reads;copy('secret');assert(reads==prior)
bundle='org.test.editor';copy('concealed',{'org.nspasteboard.ConcealedType'});copy('transient',{'org.nspasteboard.TransientType'});copy('file',{'public.file-url'});assert(reads==prior)
copy('');copy(string.rep('x',65537));assert(#m.entries==2)
for i=1,12 do copy('item'..i) end;assert(#m.entries==10 and m.entries[1].text=='item12')
now=now+60;assert(#m.snapshot().entries==0 and not m.copy(id))
copy('<script>test</script>');assert(#m.entries==1)
local bad=m.defaults();bad.limit=101;assert(not m.save(bad) and m.config.enabled)
config.enabled=false;assert(m.save(config));assert(#m.entries==0 and not m.timer and stops>0);assert(not m.pause())
m.start();assert(not m.config.enabled and #m.entries==0)
assert(saved.entries==nil)
print('Clipboard bounds, deduplication, expiry, exclusion, privacy markers, pause, copy and memory-only lifecycle passed')

config.enabled=true;assert(m.save(config));copy(string.rep('测试',30));local menu=m.menuItems();assert(utf8.len(menu[5].title)==41);menu[5].fn();assert(text==string.rep('测试',30));config.enabled=false;assert(m.save(config))
print('Menu Unicode labels and selection callback passed')

local clears=0
hs.dialog={blockAlert=function() return "取消" end}
config.enabled=true;assert(m.save(config));copy('clear-menu-fixture')
menu=m.menuItems();menu[#menu].fn();assert(#m.entries==1)
hs.dialog.blockAlert=function() return "清空" end
menu[#menu].fn();assert(#m.entries==0)
print('Menu clear cancellation and confirmed history removal passed')

m.entries={{id=999,kind='image',time=now+0.25}}
menu=m.menuItems();assert(menu[5].title:match('^图片 %d%d:%d%d:%d%d$'))
m.entries={}
print('Fractional image timestamps render in the clipboard menu')
