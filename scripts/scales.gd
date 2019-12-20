extends Node

const _PI = TAU/2

#enum GravityLevel { normal, medium, high }

var time = 0.0
export(float, 100, 3000,25) var OrbitScale = 400

var Time = {"timeScale":5.0, "fixedDeltaTime":1.0}

export var CurrentTimeScale = 10.0
export var TimaScaleFactor = 2.0
var minTimeScale = 0.125
var maxTimeScale = 64.0
var minCurrentTimeScale = 0.125
var maxCurrentTimeScale = 64.0

var day2hour = 24
var hour2day = 1 / day2hour

var SizeEarth2SizeSun = 109
var SizeSun2SizeEarth = 1 / SizeEarth2SizeSun
var planetRotation = 24
var planetRotation2unity = 1 / planetRotation
var earthEcuador = 12756.2
var ecuador2PlanetRadios = 1 / earthEcuador
var sonRadio2Earthradios = 109
var day2sec = 360
var sec2day = 1 / day2sec
var gravityColliderMult = 30.0
var messageDuration = 8.0
var maxSpaceShipSpeed = 16.28
var sunMass2EarthMass = 3.00347-06
var earthMass2SunMass = 1 / sunMass2EarthMass
var massScale = 16
var au2mu = 1000.0
var mu2au = 1 / au2mu
var solarSystemEdge = 31 * au2mu
var y2tmu = 720.0
var tmu2y = 1 / y2tmu
var y2sec = 31556926
var au2km = 149600000
var km2au = 1 / au2km
var velmu2kms = (mu2au*au2km)/(tmu2y*y2sec)
var kms2velmu = 1 / velmu2kms
var GM = (pow(2*_PI/y2tmu,2)*pow(au2mu,3))



func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if (!get_parent().pause):
		time += delta


func MaxTimeScale(value):
	return maxCurrentTimeScale



func MinTimeScale():
	return minCurrentTimeScale


func Pause():
	return get_parent().pause


func ResetTimeScale():
	CurrentTimeScale = 1.0


func IncreaseTimeScale():       #       //In order the change to take effect I use ClampTimeScale() in GUI update
	CurrentTimeScale *= TimaScaleFactor
	CurrentTimeScale = clamp (CurrentTimeScale, minCurrentTimeScale, maxCurrentTimeScale)

	
func DecreaseTimeScale():
	CurrentTimeScale /= TimaScaleFactor
	CurrentTimeScale = clamp (CurrentTimeScale, minCurrentTimeScale, maxCurrentTimeScale)


func ClampTimeScale():
	CurrentTimeScale = clamp (CurrentTimeScale, minCurrentTimeScale, maxCurrentTimeScale)
	Time.timeScale = CurrentTimeScale
	Time.fixedDeltaTime = 0.02 * Time.timeScale


func ResetMaximumTimeScale():
	maxCurrentTimeScale = maxTimeScale



