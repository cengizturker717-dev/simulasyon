import json,struct,copy
from pathlib import Path
import numpy as np
from PIL import Image
src=Path('outputs/SolidSimNative/assets/VigorCatalog.glb').read_bytes()
n=struct.unpack_from('<I',src,12)[0];g=json.loads(src[20:20+n]);data=bytearray(src[28+n:])
def acc(i):
 a=g['accessors'][i];v=g['bufferViews'][a['bufferView']];return np.frombuffer(data,dtype={5126:'<f4',5125:'<u4',5123:'<u2',5121:'u1'}[a['componentType']],offset=v.get('byteOffset',0)+a.get('byteOffset',0),count=a['count']*{'SCALAR':1,'VEC2':2,'VEC3':3,'VEC4':4}[a['type']]).reshape(a['count'],-1).copy()

def replace_indices(primitive,indices):
 global data
 kept=indices.ravel().astype('<u4')
 while len(data)%4:data.append(0)
 off=len(data);data.extend(kept.tobytes());v=len(g['bufferViews']);g['bufferViews'].append({'buffer':0,'byteOffset':off,'byteLength':kept.nbytes,'target':34963})
 a=len(g['accessors']);g['accessors'].append({'bufferView':v,'componentType':5125,'count':len(kept),'type':'SCALAR'});primitive['indices']=a

p=g['meshes'][3]['primitives'][2]
pos=acc(p['attributes']['POSITION']);idx=acc(p['indices']).ravel().reshape(-1,3)
lo=np.array([-.523,.208,-2.296]);hi=np.array([.548,.250,-2.274])
mask=((pos[idx]>=lo)&(pos[idx]<=hi)).all(axis=(1,2))
assert int(mask.sum())==60, int(mask.sum())
lo2=np.array([-.240,.320,1.510]);hi2=np.array([.286,.335,1.743])
mask2=((pos[idx]>=lo2)&(pos[idx]<=hi2)).all(axis=(1,2))
assert int(mask2.sum())==200, int(mask2.sum())
mask |= mask2
replace_indices(p,idx[~mask])

# Remove the disconnected floor-standing control pedestal selected in the UI.
# Components are classified by connectivity so nearby machine geometry remains intact.
from scipy.sparse import coo_matrix
from scipy.sparse.csgraph import connected_components
region_lo=np.array([-1.5,-.2,2.7]);region_hi=np.array([-.9,.8,3.3])
pedestal_triangles=0
kept_primitives=[]
for primitive in g['meshes'][3]['primitives']:
 pos=acc(primitive['attributes']['POSITION']);faces=acc(primitive['indices']).ravel().reshape(-1,3)
 edges=np.concatenate((faces[:,[0,1]],faces[:,[1,2]],faces[:,[2,0]]))
 graph=coo_matrix((np.ones(len(edges)*2,dtype=np.uint8),(np.r_[edges[:,0],edges[:,1]],np.r_[edges[:,1],edges[:,0]])),shape=(len(pos),len(pos))).tocsr()
 _,groups=connected_components(graph,directed=False)
 face_groups=groups[faces[:,0]]
 remove=np.zeros(len(faces),dtype=bool)
 for group in np.unique(face_groups):
  group_faces=faces[face_groups==group];used=np.unique(group_faces)
  lo3=pos[used].min(axis=0);hi3=pos[used].max(axis=0)
  if (lo3>=region_lo).all() and (hi3<=region_hi).all():
   remove|=face_groups==group
 if remove.any():
  pedestal_triangles+=int(remove.sum())
  if remove.all():continue
  replace_indices(primitive,faces[~remove])
 kept_primitives.append(primitive)
g['meshes'][3]['primitives']=kept_primitives
assert pedestal_triangles>1000,pedestal_triangles
g['scenes']=[{'nodes':[18]}];g['scene']=0;g['buffers'][0]['byteLength']=len(data)
out=json.dumps(g,separators=(',',':')).encode();out+=b' '*((-len(out))%4);data+=b'\0'*((-len(data))%4)
b=struct.pack('<III',0x46546c67,2,12+8+len(out)+8+len(data))+struct.pack('<II',len(out),0x4e4f534a)+out+struct.pack('<II',len(data),0x004e4942)+data
Path('work/CleanStatic.glb').write_bytes(b)
print('Removed',int(mask.sum()),'bracket triangles and',pedestal_triangles,'pedestal triangles')

