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
review_removed={'reducers':0,'ripple_panel':0}
for mesh_id,node_id,kind in [(3,13,'bridge'),(4,19,'lift')]:
 groups={'static':[],kind:[]}
 group_codes={'static':0,kind:1}
 if kind=='bridge':
  groups['carriage']=[]
  groups['guard']=[]
  groups['fam_yellow']=[]
  group_codes.update({'carriage':2,'guard':3,'fam_yellow':5})
 for primitive_index,p in enumerate(g['meshes'][mesh_id]['primitives']):
  pos=acc(p['attributes']['POSITION']);idx=acc(p['indices']).ravel().reshape(-1,3)
  _,inv=np.unique(np.round(pos,5),axis=0,return_inverse=True);f=inv[idx]
  r=np.concatenate([f[:,0],f[:,1],f[:,2]]);c=np.concatenate([f[:,1],f[:,2],f[:,0]])
  _,labels=connected_components(coo_matrix((np.ones(len(r)),(r,c)),shape=(inv.max()+1,inv.max()+1)),directed=False)
  facegroups=labels[f[:,0]];assign=np.zeros(len(idx),dtype=int)
  for k in np.unique(facegroups):
   selected=facegroups==k;xyz=pos[idx[selected].ravel()];lo=xyz.min(0);hi=xyz.max(0)
   if kind=='bridge':
    # The front cable carrier and its drive sit below the main bridge body.
    # Treat that connected low assembly as part of the bridge as well; leaving
    # it in the static mesh makes the drive visibly detach during X travel.
    # Include the complete U-shaped carrier, motor and lower brackets. Some
    # links extend behind/below the bridge, outside the first narrow bounds.
    low_bridge_accessory=(lo[0]>-1.10 and hi[0]<.65 and lo[1]>-.55 and
                          hi[1]<.45 and lo[2]>-1.50 and hi[2]<-.95 and
                          hi[0]-lo[0]<.80)
    far_side_accessory=(lo[0]>-1.10 and hi[0]<.65 and lo[1]>-.55 and
                        hi[1]<.45 and lo[2]>.65 and hi[2]<1.50 and
                        hi[0]-lo[0]<.80)
    moving=(lo[0]>-.8 and hi[0]<.8 and hi[1]>.30 and
            not (hi[1]<.45 and hi[1]-lo[1]<.08)) or low_bridge_accessory or far_side_accessory
    carriage=moving and lo[1]>.55 and lo[2]>-.75 and hi[2]<.85
    # The front protective cage shares the fused source mesh with the Y
    # carriage, but it belongs to the bridge.  Split its connected frame and
    # panel pieces so they follow X only and remain fixed during Y travel.
    # Only the eight long profiles forming the front cage are fixed to the
    # bridge.  Milling/drilling heads, their plates and bases stay in the Y
    # carriage group so the assemblies cannot separate during travel.
    front_guard_profiles=(carriage and primitive_index==2 and
                          lo[0]>.49 and hi[0]<.56 and
                          lo[1]>.63 and hi[1]<1.04 and
                          lo[2]>-.76 and hi[2]<.45)
    front_guard=front_guard_profiles
    # Long, narrow elements in the FAM drilling aggregate correspond to the
    # pneumatic/guide rods shown in the product reference. Split them into a
    # lightweight companion mesh so they can receive the yellow finish while
    # keeping exactly the same X/Y/Z motion as the rest of the carriage.
    extent=hi-lo
    fam_yellow_rod=(carriage and primitive_index==3 and
                    extent[1]>.30 and extent[0]<.08 and extent[2]<.08 and
                    lo[0]>-.17 and hi[0]<-.04 and
                    lo[1]>.80 and hi[1]<1.40)
    # Remove the table-crossing black chain only. Keep the enclosed motor,
    # white protective covers and their mounting brackets with the bridge.
    lower_crossing_chain=(low_bridge_accessory or far_side_accessory) and primitive_index in (1,6)
    # The source assembly contains two almost coincident upper cable carriers.
    # Keep the upper carrier connected to the drive box and discard the lower
    # duplicate, otherwise two black chains are visible in the same channel.
    duplicate_upper_chain=(primitive_index==6 and
                           lo[0]>-.27 and hi[0]<-.10 and
                           lo[1]>1.15 and hi[1]<1.63 and
                           lo[2]>-.23 and hi[2]<-.10)
    # A second, short horizontal U-shaped carrier is nested beside the main
    # long carrier.  It is a separate connected component in the source CAD.
    # The reviewed machine has one carrier here, so keep the long run and drop
    # this short duplicate.
    duplicate_short_carrier=(primitive_index==6 and
                             lo[0]>-.67 and hi[0]<-.53 and
                             lo[1]>.98 and hi[1]<1.25 and
                             lo[2]>.41 and hi[2]<.72)
    # Controller model: discard every remaining X/Y/Z cable carrier. These
    # four high-density black chains account for tens of thousands of faces
    # but are not involved in axis positioning or collision calculations.
    # Remove the old open black cabinet together with the carrier runs and all
    # of their small rollers, fasteners and brackets. VigorLite supplies a
    # closed white cabinet with the same outer bounds and bridge motion.
    all_cable_carrier=(primitive_index==6 and
                       lo[0]>-.70 and hi[0]<-.10 and
                       lo[1]>.95 and hi[1]<1.85 and
                       lo[2]>-.40 and hi[2]<.75)
    # High-density corrugated auxiliary hose called out for removal.  Match the
    # isolated connected component tightly so nearby bridge plates stay intact.
    corrugated_hose=(primitive_index==2 and
                     lo[0]>-.67 and hi[0]<-.53 and
                     lo[1]>.96 and hi[1]<1.06 and
                     lo[2]>-.11 and hi[2]<.68)
    # After removing the carrier's black links, its pale side plates, pins,
    # tubes and mounting slivers remained around the cabinet and appeared as
    # floating CAD fragments.  The servo/head assembly is the dark primitive
    # 3 at x >= -0.16, and the cabinet body is preserved separately above, so
    # this tightly bounded light-coloured accessory zone can be discarded.
    cable_carrier_light_residue=(primitive_index==2 and
                                 lo[0]>-.70 and hi[0]<-.10 and
                                 lo[1]>.75 and hi[1]<1.45 and
                                 lo[2]>-.82 and hi[2]<.95)
    # Small white stop posts, loose rings and thin mounting plates shown on the
    # table in the review images.  They sit at table height on the two outer
    # accessory zones and were being swept into the bridge group.  Restrict the
    # rule to the two light-coloured primitives so rails, black table inserts,
    # enclosure parts and the lower motor assembly are untouched.
    reviewed_table_fixture=(primitive_index in (0,2) and
                            (low_bridge_accessory or far_side_accessory) and
                            lo[1]>.18 and hi[1]<.50)
    # Cage-cover lower strip identified by a View3D ray pick at local position
    # (0.000237, 0.315046, 1.61139).  Removing it here keeps both the full and
    # simplified catalog views consistent.
    picked_cage_strip=(primitive_index==2 and len(idx[selected])==196 and
                       lo[0]>-.25 and hi[0]<.30 and
                       lo[1]>.27 and hi[1]<.33 and
                       lo[2]>1.50 and hi[2]<1.76)
    # The vacuum table was exported with hundreds of shallow black squares,
    # strips and outlines as real geometry.  They are cosmetic details but
    # account for most of this primitive's connected components.  Remove only
    # the thin geometry sitting on the table surface; the black drive parts,
    # cable carriers and machine feet are outside these tight height/area
    # bounds and remain untouched.
    table_black_detail=(primitive_index==6 and
                        lo[0]>-1.10 and hi[0]<3.36 and
                        lo[1]>.34 and hi[1]<.38 and
                        lo[2]>-1.30 and hi[2]<.91)
    # The yellow safety door was exported in its swung-open pose.  Remove only
    # that door leaf, its own frame and handle; the fixed black end posts and
    # bridge structure remain.  VigorLite supplies a cheap closed replacement.
    open_cage_door=((primitive_index==7 and
                     lo[0]>-.25 and hi[0]<.29 and lo[2]>1.52) or
                    (primitive_index==0 and
                     lo[0]>-.35 and hi[0]<.35 and
                     lo[2]>1.49 and hi[2]>1.70) or
                    (primitive_index==2 and
                     lo[0]>-.35 and hi[0]<.35 and
                     lo[2]>1.49 and hi[2]>1.529) or
                    (primitive_index==6 and
                     lo[0]>.24 and hi[0]<.34 and lo[2]>1.70))
    # Two hinge halves from the source door remain after its open door leaf is
    # removed. With the replacement door closed, these four small components
    # float outside the cage during X travel, so remove the orphaned hinge set.
    cage_door_hinge=(primitive_index==2 and
                     lo[0]>-.30 and hi[0]<-.26 and
                     lo[1]>.35 and hi[1]<.91 and
                     lo[2]>1.49 and hi[2]<1.52)
    cage_door_lock_hinge=(primitive_index==2 and
                          lo[0]>.34 and hi[0]<.47 and
                          lo[1]>.53 and hi[1]<.68 and
                          lo[2]>1.44 and hi[2]<1.50)
    # These floor profiles belong to the fixed machine frame. Their bounds
    # overlap the broad low-bridge accessory zones, which previously made them
    # travel with the bridge and emerge near the rear X limit.
    fixed_floor_profile=(primitive_index==2 and
                         lo[1]>-.52 and hi[1]<0 and
                         lo[2]>-1.16 and hi[2]<-.96 and
                         .18<hi[0]-lo[0]<.22 and
                         .48<hi[1]-lo[1]<.51 and
                         .18<hi[2]-lo[2]<.21)
    # A separate 8 mm light-coloured CAD remnant sits below the table near the
    # front side. It becomes visible as a floating speck in close orbit views.
    detached_tiny_marker=(primitive_index==8 and
                          lo[0]>.075 and hi[0]<.09 and
                          lo[1]>.12 and hi[1]<.14 and
                          lo[2]>.86 and hi[2]<.88)
    # Three circular vacuum inlet collars on the output-end lower frame.  A
    # cheap flat cover is added in VigorLite.qml after these detailed rings are
    # removed from the CAD mesh.
    vacuum_inlet_ring=(primitive_index==0 and len(idx[selected])==96 and
                       lo[0]>3.30 and hi[0]<3.37 and
                       lo[1]>-.29 and hi[1]<-.20 and
                       lo[2]>-.38 and hi[2]<.07)
    # Remove only the two mirrored Yaskawa motor bodies at the machine's front
    # and rear.  Match their exact connected dark-body topology and bounds;
    # the surrounding Z-axis bases, mounting plates and fasteners must remain.
    yaskawa_servo=(primitive_index==3 and len(idx[selected])==4742 and
                   lo[0]>-.31 and hi[0]<-.13 and
                   lo[1]>-.08 and hi[1]<.10 and
                   ((lo[2]>-1.50 and hi[2]<-1.16) or
                    (lo[2]>.95 and hi[2]<1.18)))
    # The two remaining gearboxes and their own face plates, shafts and screws
    # sit directly behind the removed Yaskawa bodies. Keep all higher Z-axis
    # bases and adjacent bridge/frame plates outside this tight component box.
    reviewed_reducer=(primitive_index in (0,2,3) and
                      lo[0]>-.31 and hi[0]<-.13 and
                      lo[1]>-.08 and hi[1]<.10 and
                      ((lo[2]>-1.334 and hi[2]<-1.165) or
                       (lo[2]>.855 and hi[2]<1.025)))
    # This isolated thin panel has curved-looking exported normals. Replace
    # only its skin with a flat lightweight cover; retain the surrounding frame.
    ripple_panel=(primitive_index==2 and len(idx[selected])==312 and
                  lo[0]>.504 and hi[0]<.507 and
                  lo[1]>.650 and hi[1]<1.029 and
                  lo[2]>-1.221 and hi[2]<-.724)
    if reviewed_reducer:review_removed['reducers']+=int(selected.sum())
    if ripple_panel:review_removed['ripple_panel']+=int(selected.sum())
    # Reviewed Z base: rear black plate, its vertical guides and the two
    # lower blocks pictured by the user. These cosmetic base components were
    # incorrectly travelling with the Z head. Keep the FAM aggregate and HSD
    # motor outside this tightly bounded rear-plate region.
    reviewed_z_base=(primitive_index in (0,2,6) and
                     lo[0]>-.31 and hi[0]<-.18 and
                     lo[1]>.62 and hi[1]<1.24 and
                     lo[2]>-.32 and hi[2]<.11)
    fixed_frame_part=fixed_floor_profile
    discard=(lower_crossing_chain or duplicate_upper_chain or
             duplicate_short_carrier or all_cable_carrier or corrugated_hose or
             cable_carrier_light_residue or
             reviewed_table_fixture or picked_cage_strip or
             table_black_detail or open_cage_door or cage_door_hinge or
              cage_door_lock_hinge or detached_tiny_marker or vacuum_inlet_ring or
              yaskawa_servo or reviewed_reducer or ripple_panel or reviewed_z_base)
    assign[selected]=0 if fixed_frame_part else 4 if discard else 3 if front_guard else 5 if fam_yellow_rod else 2 if carriage else 1 if moving else 0
   else:
    moving=lo[0]>-7.21 and hi[0]<-2.94 and lo[1]>-.40 and hi[1]<-.12 and lo[2]>-1.21 and hi[2]<.82
    assign[selected]=1 if moving else 0
  for key,code in group_codes.items():
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
assert review_removed['reducers']>2000,review_removed
assert review_removed['ripple_panel']==312,review_removed
print('Review cleanup',review_removed)
