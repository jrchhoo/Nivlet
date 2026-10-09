window.runTabsRegression=function(data){
 const nav=document.querySelector('nav'),original=[...nav.children],oldSend=send,key=document.getElementById('left-key'),draft=key.value;
 const check=(value,message)=>{if(!value)throw new Error(message)};
 try{
  applyTabOrder(['windowSection','inputSection','clipSection','systemSection','browserSection','launcherSection']);
  key.value='Z';let captured;send=body=>captured=body;
  const launcher=document.getElementById('tab-launcherSection'),target=document.getElementById('tab-windowSection');
  check(!document.getElementById('tab-generalSection').onpointerdown,'General must be fixed');
  check(!document.getElementById('tab-aboutSection').onpointerdown,'About must be fixed');
  const selected=nav.querySelector('[aria-selected=true]');
  launcher.dispatchEvent(new PointerEvent('pointerdown',{button:0,clientX:launcher.getBoundingClientRect().left,bubbles:true}));
  document.dispatchEvent(new PointerEvent('pointermove',{clientX:target.getBoundingClientRect().left+1,bubbles:true}));
  document.dispatchEvent(new PointerEvent('pointerup',{bubbles:true}));
  launcher.click();check(nav.querySelector('[aria-selected=true]')===selected,'Drag click switched page');
  check(nav.children[0].id==='tab-generalSection'&&nav.children[1]===launcher,'Drag order incorrect');
  check(captured.action==='saveTabOrder'&&captured.order[0]==='launcherSection','Order not sent');
  window.receive({...data,action:'saveTabOrder',general:{...data.general,tabOrder:captured.order}});
  check(key.value==='Z','Sorting erased draft');
  window.receive({...data,action:'load',general:{...data.general,tabOrder:captured.order}});
  check(nav.children[1]===launcher,'Reload lost order');
  applyTabOrder(['aboutSection','missingSection','launcherSection','launcherSection']);
  check(nav.lastElementChild.id==='tab-aboutSection','Legacy About position must normalize to last');
  launcher.dispatchEvent(new PointerEvent('pointerdown',{button:0,clientX:launcher.getBoundingClientRect().left,bubbles:true}));
  document.dispatchEvent(new PointerEvent('pointermove',{clientX:nav.getBoundingClientRect().right+100,bubbles:true}));
  document.dispatchEvent(new PointerEvent('pointerup',{bubbles:true}));
  check(nav.lastElementChild.id==='tab-aboutSection'&&nav.lastElementChild.previousElementSibling===launcher,'Drag crossed fixed About');
  check(nav.children.length===original.length&&nav.children[0].id==='tab-generalSection','Future or duplicate IDs corrupted tabs');
  return 'Tab drag, fixed General/About, bounded drag, persistence reload and draft preservation passed';
 }finally{send=oldSend;for(const tab of original)nav.append(tab);key.value=draft;window.receive({...data,action:'load'});key.value=draft}
};
