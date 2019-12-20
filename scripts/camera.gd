extends Position3D

var celestial_bodies = []

const INTERPOLATION_SPEED = 2
const ROT_SPEED = 0.1
var rot_x = -20
var rot_y = 0

var CelestialBodySelection = 0

var zoom = 250
const ZOOM_SPEED = 15
const ZOOM_MAX = 3000
const ZOOM_MIN = 5

var t = Transform()

onready var etiqueta = get_parent().get_parent().get_node("Label")


func _ready():
	set_process(true)
	$camera.translation.z = zoom
	
	
	for i in get_parent().get_children():
		if i.get_child(0) is MeshInstance:
			celestial_bodies.append(i)
			get_parent().get_parent().get_node("HUD/OptionButton").add_item(i.name)





func _unhandled_input(ev):
	if (ev is InputEventMouseButton and ev.button_index == BUTTON_WHEEL_UP):
		if (zoom<ZOOM_MAX):
			zoom+=ZOOM_SPEED
			$camera.translation.z = zoom
#			etiqueta.text = str(zoom-5)
	if (ev is InputEventMouseButton and ev.button_index == BUTTON_WHEEL_DOWN):
		if (zoom>ZOOM_MIN):
			zoom-=ZOOM_SPEED
			$camera.translation.z = zoom

	if ((ev is InputEventMouseMotion) and (ev.button_mask & BUTTON_MASK_MIDDLE or ev.button_mask & BUTTON_MASK_LEFT)):
		rot_y -= ev.relative.x * ROT_SPEED
		rot_x -= ev.relative.y * ROT_SPEED
		rot_y = fmod(rot_y,360)
		rot_x = clamp(rot_x,-90,90)
		t = Transform()
		t = t.rotated(Vector3(1,0,0),rot_x * PI / 180.0)
		t = t.rotated(Vector3(0,1,0),rot_y * PI / 180.0)

		transform.basis = t.basis


func _process(delta):
	print(zoom)
	var xform = celestial_bodies[CelestialBodySelection].global_transform
	var p = xform.origin
#	var r = Quat(xform.basis)
	var from_xform = transform

	var from_p = from_xform.origin
#	var from_r = Quat(from_xform.basis)
	
	p = from_p.linear_interpolate(p,INTERPOLATION_SPEED*delta)
#	r = from_r.slerp(r,INTERPOLATION_SPEED*delta)
	
#	var m = Transform(r)
#	m.origin=p
	
	transform.origin = p

func _on_OptionButton_item_selected(ID):
	CelestialBodySelection = ID
