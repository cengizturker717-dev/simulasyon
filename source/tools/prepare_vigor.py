import json,struct,copy
from pathlib import Path
import numpy as np
from PIL import Image
src=Path('outputs/SolidSimNative/assets/vigor-2136.glb').read_bytes()
n=struct.unpack_from('<I',src,12)[0];g=json.loads(src[20:20+n]);data=bytearray(src[28+n:])
def acc(i):
 a=g['accessors'][i];v=g['bufferViews'][a['bufferView']];return np.frombuffer(data,dtype={5126:'<f4',5125:'<u4',5123:'<u2',5121:'u1'}[a['componentType']],offset=v.get('byteOffset',0)+a.get('byteOffset',0),count=a['count']*{'SCALAR':1,'VEC2':2,'VEC3':3,'VEC4':4}[a['type']]).reshape(a['count'],-1).copy()
im=Image.open('outputs/SolidSimNative/assets/vigor-2136-qt/maps/textureData9.png')
colors={}
for mesh in g['meshes']:
 for p in mesh['primitives']:
  color=(185,188,191,255)
  if 'material' in p and 'TEXCOORD_0' in p['attributes'] and p['material']!=0:
   uv=acc(p['attributes']['TEXCOORD_0']);color=im.getpixel((min(63,max(0,int(float(np.median(uv[:,0]))*64))),0))
  if color not in colors:
   colors[color]=len(g['materials']);g['materials'].append({'name':'paint_'+str(color),'pbrMetallicRoughness':{'baseColorFactor':[color[0]/255,color[1]/255,color[2]/255,1], 'metallicFactor':0.0,'roughnessFactor':0.75},'doubleSided':True})
  p['material']=colors[color]
# Preserve original meshes; split only the fused machine and lift geometry.
def add_indices(idx):
 while len(data)%4:data.append(0)
 off=len(data);raw=np.asarray(idx,dtype='<u4').tobytes();data.extend(raw)
 v=len(g['bufferViews']);g['bufferViews'].append({'buffer':0,'byteOffset':off,'byteLength':len(raw),'target':34963})
 a=len(g['accessors']);g['accessors'].append({'bufferView':v,'componentType':5125,'count':len(idx),'type':'SCALAR'});return a
from scipy.sparse import coo_matrix
from scipy.sparse.csgraph import connected_components
movements={}
for mesh_id,node_id,kind in [(3,13,'bridge'),(4,19,'lift')]:
 groups={'static':[],kind:[]}
 if kind=='bridge':groups['carriage']=[]
 for p in g['meshes'][mesh_id]['primitives']:
  pos=acc(p['attributes']['POSITION']);idx=acc(p['indices']).ravel().reshape(-1,3)
  _,inv=np.unique(np.round(pos,5),axis=0,return_inverse=True);f=inv[idx]
  r=np.concatenate([f[:,0],f[:,1],f[:,2]]);c=np.concatenate([f[:,1],f[:,2],f[:,0]])
  _,labels=connected_components(coo_matrix((np.ones(len(r)),(r,c)),shape=(inv.max()+1,inv.max()+1)),directed=False)
  facegroups=labels[f[:,0]];assign=np.zeros(len(idx),dtype=int)
  for k in np.unique(facegroups):
   selected=facegroups==k;xyz=pos[idx[selected].ravel()];lo=xyz.min(0);hi=xyz.max(0)
   if kind=='bridge':
    moving=lo[0]>-.8 and hi[0]<.8 and hi[1]>.30 and not (hi[1]<.45 and hi[1]-lo[1]<.08)
    carriage=moving and lo[1]>.55 and lo[2]>-.75 and hi[2]<.85
    assign[selected]=2 if carriage else 1 if moving else 0
   else:
    moving=lo[0]>-7.21 and hi[0]<-2.94 and lo[1]>-.40 and hi[1]<-.12 and lo[2]>-1.21 and hi[2]<.82
    assign[selected]=1 if moving else 0
  for code,key in enumerate(groups):
   selected=assign==code
   if selected.any():
    q=copy.deepcopy(p);q['indices']=add_indices(idx[selected].ravel());groups[key].append(q)
 g['meshes'][mesh_id]['primitives']=groups.pop('static')
 for key,primitives in groups.items():
  mi=len(g['meshes']);g['meshes'].append({'name':key,'primitives':primitives})
  ni=len(g['nodes']);g['nodes'].append({'name':'SIM_'+key.upper(),'mesh':mi,'translation':[0,.7045512795,0]});g['scenes'][0]['nodes'].append(ni);movements[key]=ni
# Full stroke bridge starts at the supplied model pose, toward the output conveyor.
g['buffers'][0]['byteLength']=len(data)
out=json.dumps(g,separators=(',',':'),ensure_ascii=True).encode();out+=b' '*((-len(out))%4);data+=b'\0'*((-len(data))%4)
b=struct.pack('<III',0x46546c67,2,12+8+len(out)+8+len(data))+struct.pack('<II',len(out),0x4e4f534a)+out+struct.pack('<II',len(data),0x004e4942)+data
Path('outputs/SolidSimNative/assets/VigorCatalog.glb').write_bytes(b)
print('Prepared',len(b),'bytes',movements)
