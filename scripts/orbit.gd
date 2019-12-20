extends Node

var scale = 2


onready var Scales = get_node("/root/Scales")

const _PI = TAU/2

var CosSinOmega = Array()

var OP = float()   # orbital period
var RP = float()   # rotation period

export var OrbitParameter = {"eccentricity": 0.67 , "perihelion": 0.983*2, "orbital_period": 15.0,  "radius": 1.0, "axial_tilt": 23.26, "rot_pediod": -0.0027, "long_ascending_node" : 0, "mass": 1.0}

const N = 300
var angleArray = Array()
var surface = 0.0
var k 
var orbitDt 
var time = 10.0

func _physics_process(delta):
 #----------Revisar valores de Delta
#	if (!Scales.pause):
#		Scales.time += delta
#	print(ThetaInt(Scales.time)," - ", Scales.time )
	var thy = ThetaInt(Scales.time )
	$sat.transform.origin = ParametricOrbit( ThetaInt( Scales.time ) )     #    Scales.time * delta * 10)
	
	
func _ready():

	set_physics_process(true)
	angleArray.resize(1)
	var perihelion = OrbitParameter.perihelion * 10

	OP = OrbitParameter.orbital_period # * Scales.y2tmu
	RP = OrbitParameter.rot_pediod   # * Scales.y2tmu
	surface = sqrt (-(1 + OrbitParameter.eccentricity) / pow (-1 + OrbitParameter.eccentricity, 3)) * _PI * perihelion * perihelion
	k = 2 * surface / (pow (1 + OrbitParameter.eccentricity, 2) * OP * perihelion * perihelion)
	orbitDt = OP / (2 * (N - 1))
	ThetaRunge()
	time = 10.0 # Random.Range(0, OP)
	CosSinOmega.insert(0, cos(OrbitParameter.long_ascending_node))
	CosSinOmega.insert(1, sin(OrbitParameter.long_ascending_node))

func ParametricOrbit(th):  #---Plot position on ellipse
	var Cost = cos(th)
	var Sint = sin(th)
	
	var x = (OrbitParameter.perihelion * (1 + OrbitParameter.eccentricity)) / (1 + OrbitParameter.eccentricity * Cost) * Cost
	var z = (OrbitParameter.perihelion * (1 + OrbitParameter.eccentricity)) / (1 + OrbitParameter.eccentricity * Cost) * Sint
	
	var xp = CosSinOmega[0] * x - CosSinOmega[1] * z
	var yp = CosSinOmega[1] * x + CosSinOmega[0] * z
	
#	print( ParametricVelocity() )
	return (Vector3(xp, 0, yp )  * scale)


func Theta():
	return ThetaInt(time)

func ThetaRecurrence():
	var i = 0
	angleArray[0] = 0  #--Initial conditionL theta(0) = 0
	for i in range(i < N - 2):
		angleArray[i + 1] = orbitDt * dthdt(angleArray[i]) + angleArray[i]
		angleArray[N - 1] = _PI


func GetPositionAfterTime(t):
	return ParametricOrbit(ThetaInt(time + t))


func dthdt(th):
	return k * pow ((1 + OrbitParameter.eccentricity * cos(th)), 2)


func ThetaRunge():
#	angleArray.resize(300)
	var w = 0
	var k1
	var k2
	var k3
	var k4
	
	for i in range(N - 2):
		k1 = orbitDt * dthdt(w)
		k2 = orbitDt * dthdt(w + k1 / 2)
		k3 = orbitDt * dthdt(w + k2 / 2)
		k4 = orbitDt * dthdt(w + k3)
		w = w + (k1 + 2 * k2 + 2 * k3 + k4) / 6
		angleArray.insert((i + 1), w)

	angleArray.insert((N - 1), _PI)
	angleArray[0] = 0
#	angleArray.pop_front()




func ThetaInt(c):
	
	var theta0 = 0.0
	var t = float( int(c*1000) % int(OP*1000)  ) / 1000

	if t <= (OP / 2):
		var i = t / orbitDt
		var i0 = clamp(floor(i), 0, N - 1)
		var i1 = clamp(ceil(i), 0, N - 1)

		if i0 == i1:
			theta0 = angleArray[i0]

		else:
			theta0 = (angleArray[i0] - angleArray[i1]) / (i0 - i1) * i + (i0 * angleArray[i1] - angleArray[i0] * i1) / (i0 - i1)
		return theta0

	else:
		t = -t + OP
		var i = t / orbitDt
		var i0 = clamp(floor(i), 0, N - 1)
		var i1 = clamp(ceil(i), 0, N - 1)

		if i0 == i1:
			theta0 = -angleArray[i0] + 2 * _PI
		else :
			theta0 = -((angleArray[i0] - angleArray[i1]) / (i0 - i1) * i + (i0 * angleArray[i1] - angleArray[i0] * i1) / (i0 - i1)) + 2 * _PI
		return theta0


func ParametricVelocity():
	var myfixedDt = 2 * orbitDt
	var pos2 = ParametricOrbit(ThetaInt(time + myfixedDt))
	var pos1 = ParametricOrbit(ThetaInt(time - myfixedDt))

	return Vector3( (pos2.x - pos1.x) / (2 * myfixedDt) , 0.0, (pos2.z - pos1.z) / (2 * myfixedDt) )


func GetVelMagnitude():
	return ParametricVelocity()  * Scales.velmu2kms

	
	
	
	
	
	
	
	
