window.runEssentialsRegression=function(data){
 const oldSend=send,originalSection=document.querySelector('[role=tab][aria-selected=true]').getAttribute('aria-controls'),flag=document.getElementById('system-cpu'),draft=flag.checked;
 const check=(v,m)=>{if(!v)throw new Error(m)};
 try{
  let captured;send=body=>captured=body;
  flag.checked=!draft;
  window.receiveSystemValues({ok:true,values:{cpu:'23%',ipv6:'2001:db8::1234'}});
  check(flag.checked===!draft,'Live refresh erased draft');check(document.getElementById('system-value-cpu').textContent==='23%','CPU value missing');
  check(document.getElementById('system-value-ipv6').title==='2001:db8::1234','Full address unavailable');
  window.receiveSystemValues({ok:false,values:{}});check(document.getElementById('system-value-cpu').textContent===t('暂不可用'),'Failure presented as zero');
  check(document.querySelectorAll('.permission-state').length===1&&document.querySelector('#generalSection .permission-state'),'Permission status must appear only in General');
  check(!document.querySelector('#windowSection .open-accessibility,#clipSection .refresh-permissions'),'Repeated permission controls remain');
  for(const state of ['granted','denied','error']){window.receive({...data,action:'refreshPermissions',permissions:{accessibility:state}});check(document.querySelector('.permission-state').dataset.state===state,'Permission states collapsed');check(flag.checked===!draft,'Permission refresh erased draft');check(document.querySelector('.permission-details').hidden===(state==='granted'),'Permission details visibility incorrect')}
  document.querySelector('.refresh-permissions').click();check(captured.action==='refreshPermissions','Recheck action missing');check(document.querySelector('.refresh-permissions').textContent===t('检测中…'),'Recheck lacks busy feedback');window.receive({...data,action:'refreshPermissions',message:'Checked'});check(document.getElementById('status').textContent==='Checked'&&document.querySelector('.refresh-permissions').textContent===t('重新检测'),'Recheck completion not visible');window.receive({...data,action:'refreshPermissionsSilent',message:''});check(document.getElementById('status').textContent==='Checked','Automatic recheck cleared feedback');
  const launch=document.getElementById('autoLaunch'),mainIcon=document.getElementById('showMenu');
  const before={launch:launch.checked,main:mainIcon.checked};captured=null;
  launch.checked=!before.launch;launch.dispatchEvent(new Event('change',{bubbles:true}));
  mainIcon.checked=!before.main;mainIcon.dispatchEvent(new Event('change',{bubbles:true}));
  check(captured===null,'General toggles applied before Save');
  window.receive({...data,action:'refreshPermissions',autoLaunch:before.launch});
  check(launch.checked===!before.launch&&mainIcon.checked===!before.main,'Background refresh erased General drafts');
  window.showSection('generalSection');document.getElementById('saveSettings').click();
  check(captured.action==='saveGeneral'&&captured.autoLaunch===!before.launch&&captured.config.showMenu===!before.main,'General footer Save missing draft values');
  window.receive({...data,ok:false,action:'saveGeneral'});check(launch.checked===!before.launch,'Failed save erased draft');
  launch.checked=before.launch;mainIcon.checked=before.main;
  document.querySelector('.open-accessibility').click();check(captured.action==='openAccessibility','Settings link missing');
  const shortcut=document.getElementById('left-key'),priorKey=shortcut.value;shortcut.value='q';shortcut.dispatchEvent(new Event('input',{bubbles:true}));check(shortcut.value==='Q','Pasted shortcut letter not uppercase');shortcut.value=priorKey;
  window.showSection('aboutSection');check(!document.getElementById('aboutSection').hidden,'About not reachable');
  document.querySelector('#aboutSection a').click();check(captured.action==='openProjectLink'&&captured.link==='project','External link bypasses opener');
  check(document.querySelectorAll('#tab-aboutSection').length===1,'About tab missing or duplicated');
  window.receive({...data,language:'en',action:'refreshPermissions',permissions:{accessibility:'error'},about:{version:'1.2.3',build:'4',license:'<script>unsafe</script>',notices:'Fixture'}});
  check(document.getElementById('tab-aboutSection').textContent==='About','About English missing');
  check(document.querySelector('.privacy-card h3').textContent==='Local and Private','Privacy English missing');
  check(document.getElementById('aboutVersion').textContent.includes('1.2.3'),'Actual version missing');check(document.getElementById('licenseText').textContent==='<script>unsafe</script>'&&!document.querySelector('#licenseText script'),'Notices interpreted as HTML');
  return 'Permissions, About, safe notices, live values and draft isolation passed';
 }finally{send=oldSend;window.receive({...data,action:'refreshPermissions'});flag.checked=draft;window.showSection(originalSection)}
};
