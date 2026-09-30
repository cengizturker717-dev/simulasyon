"""Close the front hinged guard in the original bridge mesh; leave frame fixed."""
import json, struct, math, sys
from pathlib import Path
import numpy as np
from scipy.sparse import coo_matrix
from scipy.sparse.csgraph import connected_components

src=Path(sys.argv[1]).read_bytes();size=struct.unpack_from('<I',src,12)[0]
g=json.loads(src[20:20+size]);data=src[28+size:]
def acc(i):
 a=g['accessors'][i];v=g['bufferViews'][a['bufferView']]
 return np.frombuffer(data,dtype={5126:'<f4',5125:'<u4',5123:'<u2'}[a['componentType']],offset=v.get('byteOffset',0)+a.get('byteOffset',0),count=a['count']*{'SCALAR':1,'VEC2':2,'VEC3':3}[a['type']]).reshape(a['count'],-1).copy()
out={'asset':{'version':'2.0'},'buffers':[{}],'bufferViews':[],'accessors':[],'materials':g['materials'],'meshes':[{'name':'sim_BRIDGE','primitives':[]}],'nodes':[{'mesh':0,'name':'sim_BRIDGE'}],'scenes':[{'nodes':[0]}],'scene':0}
# Geometry uses only flat material slots; remove texture references from export.
for m in out['materials']:
 m.pop('extensions',None)
 for k in list(m):
  if 'Texture' in k:m.pop(k)
 p=m.get('pbrMetallicRoughness',{})
 for k in list(p):
  if 'Texture' in k:p.pop(k)
buf=bytearray()
def put(v,kind,component):
 while len(buf)%4:buf.append(0)
 raw=v.tobytes();offset=len(buf);buf.extend(raw);view=len(out['bufferViews']);out['bufferViews'].append({'buffer':0,'byteOffset':offset,'byteLength':len(raw)})
 a={'bufferView':view,'componentType':component,'count':len(v),'type':kind}
 if kind=='VEC3':a.update(min=v.min(0).tolist(),max=v.max(0).tolist())
 out['accessors'].append(a);return len(out['accessors'])-1
angle=math.radians(22.5);r=np.array([[math.cos(angle),0,math.sin(angle)],[0,1,0],[-math.sin(angle),0,math.cos(angle)]])
pivot=np.array([-.263,0,1.51]);count=0
mesh=next(m for m in g['meshes'] if m.get('name')=='bridge')
for p in mesh['primitives']:
 pos=acc(p['attributes']['POSITION']);norm=acc(p['attributes']['NORMAL']);idx=acc(p['indices']).reshape(-1,3)
 _,inv=np.unique(np.round(pos,5),axis=0,return_inverse=True);f=inv[idx]
 rows=np.concatenate([f[:,0],f[:,1],f[:,2]]);cols=np.concatenate([f[:,1],f[:,2],f[:,0]])
 _,labels=connected_components(coo_matrix((np.ones(len(rows)),(rows,cols)),shape=(inv.max()+1,inv.max()+1)),directed=False)
 groups=labels[f[:,0]];selected=np.zeros(len(pos),dtype=bool)
 for k in np.unique(groups):
  used=np.unique(idx[groups==k]);lo=pos[used].min(0);hi=pos[used].max(0)
  if lo[2]>1.48 and hi[2]>1.52 and lo[0]>-.31 and hi[0]<.35:
   selected[used]=True;count+=1
 pos[selected]=(pos[selected]-pivot)@r.T+pivot;norm[selected]=norm[selected]@r.T
 used,indices=np.unique(idx.ravel(),return_inverse=True)
 out['meshes'][0]['primitives'].append({'attributes':{'POSITION':put(pos[used].astype('<f4'),'VEC3',5126),'NORMAL':put(norm[used].astype('<f4'),'VEC3',5126)},'indices':put(indices.astype('<u4'),'SCALAR',5125),'material':p['material']})
assert count>=5, count
out['buffers'][0]['byteLength']=len(buf);j=json.dumps(out,separators=(',',':')).encode();j+=b' '*((-len(j))%4);buf+=b'\0'*((-len(buf))%4)
Path(sys.argv[2]).write_bytes(struct.pack('<III',0x46546c67,2,28+len(j)+len(buf))+struct.pack('<II',len(j),0x4e4f534a)+j+struct.pack('<II',len(buf),0x004e4942)+buf)
print('Closed guard components:',count)
