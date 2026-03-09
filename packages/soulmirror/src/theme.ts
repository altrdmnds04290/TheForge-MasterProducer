export function resolveTheme(persona:string, vibe:string){
  if(persona==='ALT3R3D-PHO3NIX') return vibe==='creator'?'ember-dark':'ember';
  if(persona==='Altered-Minds') return vibe==='consumer'?'neon-green':'psychedelic';
  return 'default';
}
