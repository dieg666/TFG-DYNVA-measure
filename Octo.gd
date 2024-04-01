extends Node2D
signal debug_update
signal start_timer
signal show_score
signal timeout

var initialPosition = Vector2.ZERO 
var initialVelocity = Vector2.ZERO 
var initialSwing = false
var initialMode = false
var initialRotationIteration = 5
var actualRotationIteration = 5
var actualRotation = 0.0
var score = 0.0
var iterations = 1
var rng = RandomNumberGenerator.new()
var projectResolution
var size_dot = 0.0
var unix_time_internal: float = 999999
var userRotationSuccess = 2 # 0 is false, 1 is true, 2 is not defined
var travelledPixels = 0
var fps = 1
var internalVelocity = 0 # display purposes
var increment
var speedOpto = 0.0
var iterationTest = 0.0
var direction = Vector2.ZERO
var listTests = []
var size_dot_in_mm = 0 
var maxErrors
var results = {}
var currentTries = 0.0
var actualTry = []
var testIteration = 0
var numberOfIterations = 0.0
var distanceUser = 0.0
var screenSizeInches = 0.0
var parsedValues = {}
func parseScore():
	parsedValues = {}
	for i in range(0,listTests.size()):
		if (results[i+1]['valid'] == "true"):
			parsedValues[i] = score(results[i+1]['values'])
		else:
			parsedValues[i] = [-1,-1,-1]
func score (values):
	var aLogMar = 0.0
	var aDec = 0.0
	var aSpeed = 0.0
	for item in values:
		var LogMarAux = log(item["sizeOpto"]*60)/log(10)
		aLogMar += LogMarAux 
		aDec += pow(10, -LogMarAux)
		aSpeed += item["speed"]
	aLogMar = aLogMar/values.size()
	aDec = aDec/values.size()
	aSpeed = aSpeed/values.size()
	print("kek")
	print(aLogMar)
	print(aDec)
	print(aSpeed)
	return [aLogMar, aDec, aSpeed]

# Called when the node enters the scene tree for the first time.
func _ready():
	fps = ProjectSettings.get_setting("physics/common/physics_fps")
	set_physics_process(false)
	position = Vector2.ZERO
	hide()
	pass # Replace with function body.
func next_move():
	reset_internal_time()
	stop();
	yield(get_tree().create_timer(2), "timeout")
	set_physics_process(true)
	show()
	reset_internal_time()
func _input(event):
	if event is InputEventKey and event.pressed and self.is_visible():
		if OS.get_scancode_string(event.physical_scancode) == "Kp 8":
			iterations += 1
			userRotationSuccess = int(actualRotation == -90)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif OS.get_scancode_string(event.physical_scancode) == "Kp 7":
			iterations += 1
			userRotationSuccess = int(actualRotation == -135)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif OS.get_scancode_string(event.physical_scancode) == "Kp 4":
			iterations += 1
			userRotationSuccess = int(actualRotation == -180)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif OS.get_scancode_string(event.physical_scancode) == "Kp 1":
			iterations += 1
			userRotationSuccess = int(actualRotation == -225)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif OS.get_scancode_string(event.physical_scancode) == "Kp 2":
			iterations += 1
			userRotationSuccess = int(actualRotation == -270)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif OS.get_scancode_string(event.physical_scancode) == "Kp 3":
			iterations += 1
			userRotationSuccess = int(actualRotation == -315)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif OS.get_scancode_string(event.physical_scancode) == "Kp 6":
			iterations += 1
			userRotationSuccess = int(actualRotation == -0)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif OS.get_scancode_string(event.physical_scancode) == "Kp 9":
			iterations += 1
			userRotationSuccess = int(actualRotation == -45)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		
		if userRotationSuccess == 1:
			testIteration += 1
			var currentResult = {
				"sizeOpto": mmToAngle(PixelToMm2(scale.x)),
				"speed": mmToVangular()
			}
			actualTry.append(currentResult)
			if testIteration >= numberOfIterations:
				iterationTest += 1
				testIteration = 0
				var result = {
					"score" : iterations,
					"errors": currentTries,
					"values": actualTry,
					"valid" : "true"
				}
				iterations = 0
				results[iterationTest] = result
				actualTry = []
				userRotationSuccess = 2

				if iterationTest >= listTests.size():
					parseScore()
					emit_signal("show_score")
					stop()
					return 0
				else:
					next_move()
					currentTries = 0
					if initialMode == 0:
						scale = MmToPixel(1)
						initialVelocity = direction*PixelToMm2(vangularToMM(listTests[iterationTest]))
					elif initialMode == 1:
						scale = MmToPixel(angleToMm((listTests[iterationTest])))
						initialVelocity = direction*PixelToMm2(vangularToMM(175.05))
						position = initialPosition
			else:
				next_move()
				if initialMode == 0:
					scale = MmToPixel(1)
					initialVelocity = direction*PixelToMm2(vangularToMM(listTests[iterationTest]))
				elif initialMode == 1:
					scale = MmToPixel(angleToMm((listTests[iterationTest])))
					initialVelocity = direction*PixelToMm2(vangularToMM(175.05))
				position = initialPosition
		elif userRotationSuccess == 0:
			currentTries += 1
			
			if currentTries >= maxErrors:
				iterationTest += 1
				var result = {
					"score" : iterations,
					"errors": currentTries,
					"values": [],
					"valid" : "false"
				}
				iterations = 0
				actualTry = []
				results[iterationTest] = result
				if iterationTest >= listTests.size():
					parseScore()
					emit_signal("show_score")
					stop()
					return 0
				else:
					currentTries = 0
					next_move()
					if initialMode == 0:
						scale = MmToPixel(1)
						initialVelocity = direction*PixelToMm2(vangularToMM(listTests[iterationTest]))
					elif initialMode == 1:
						scale = MmToPixel(angleToMm((listTests[iterationTest])))
						initialVelocity = direction*PixelToMm2(vangularToMM(175.05))
					position = initialPosition
			else:
				next_move()
				if initialMode == 0:
					scale = MmToPixel(1)
					initialVelocity = direction*PixelToMm2(vangularToMM(listTests[iterationTest]))
				elif initialMode == 1:
					scale = MmToPixel(angleToMm((listTests[iterationTest])))
					initialVelocity = direction*PixelToMm2(vangularToMM(175.05))
				position = initialPosition
			
		emit_signal("debug_update")
func _physics_process(delta):
	var velocity = initialVelocity
	#var pixelPorSegundo = projectResolution.x+scale.x*100
	velocity = velocity*delta*60 #* pixelPorSegundo * delta
	travelledPixels += velocity.length()*delta #delta
	position += velocity*delta
	if Time.get_unix_time_from_system() - unix_time_internal > 2:
		emit_signal("debug_update")
		rotation = deg2rad(get_random_rotation())
		internalVelocity = (velocity)
		emit_signal("timeout")
		reset_internal_time()
func get_random_rotation():
	var rotations = [0,-45,-90,-135,-180,-225,-270,-315]
	actualRotation = rotations[rng.randi() % rotations.size()]
	return actualRotation
func MmToPixel(mm):
	return Vector2(1,1)*(float(mm)*size_dot_in_mm)
func PixelToMm(pixel):
	return float(pixel*(size_dot_in_mm))
func PixelToMm2(pixel):
	return float(pixel/(size_dot_in_mm))
func mmToAngle(mm):
	return 2*rad2deg(atan((mm*0.5)/(distanceUser)))
func angleToMm(angle):
	var x = float(angle/2.0)
	var y = float(tan(deg2rad(x)))
	var z = float(2.0*y*distanceUser)
	return z
	
func vangularToMM(vangular):
	var recorrido = 0
	if direction.y == 0:
		recorrido = projectResolution.x * size_dot_in_mm * 0.001
	elif direction.x == 0:
		recorrido = projectResolution.y * size_dot_in_mm * 0.001
	else:
		recorrido = screenSizeInches * 25.4 * 0.001
	var distanciaObservadorm = distanceUser * 0.001
	var anglevisualgraus = (2*(atan((recorrido/2)/distanciaObservadorm))*180)/PI
	var r = ((vangular*recorrido)/anglevisualgraus)*1000
	return r
func mmToVangular():
	var recorrido = 0
	if direction.y == 0:
		recorrido = projectResolution.x * size_dot_in_mm * 0.01
	elif direction.x == 0:
		recorrido = projectResolution.y * size_dot_in_mm * 0.01
	else:
		recorrido = screenSizeInches * 25.4 * 0.01
	var distanciaObservadorm = distanceUser * 0.01
	var velocidadestimulom = PixelToMm(sqrt(initialVelocity.x*initialVelocity.x+initialVelocity.y*initialVelocity.y))*0.01
	var tempsEstimulPantalla = recorrido/velocidadestimulom
	var anglevisualgraus = (2*(atan((recorrido/2)/distanciaObservadorm))*180)/PI
	var r = anglevisualgraus/tempsEstimulPantalla
	return r
func start(pos,vel,swing,mode,rotationIteration, optotype_color : Color, scaleInitial,posDelay,incrementType, speed, list,resolution,screenI, maxE, nIterations, dUser):
	parsedValues = {}
	results = {}
	maxErrors = maxE
	listTests = list
	iterationTest = 0
	$OctoSprite.material.set_shader_param("color", Vector3(optotype_color.r, optotype_color.g, optotype_color.b))
	increment = incrementType
	# speed opto what we are mesuring
	speedOpto = speed
	$OctoSprite.material.set_shader_param("alpha", optotype_color.a)
	scale = Vector2(1,1)
	scale = scaleInitial*scale
	pos.x = pos.x + posDelay.x*100*scale.x
	pos.y = pos.y + posDelay.y*100*scale.y
	position = pos
	initialSwing = swing
	screenSizeInches = screenI
	var s = resolution * 1.0
	var d = sqrt(s.x*s.x+s.y*s.y)
	var x = (int(screenSizeInches)*1.0)/(d)
	size_dot_in_mm = x * 0.0254*1000
	numberOfIterations = nIterations
	distanceUser = dUser
	# speed6
	if mode == 0:
		direction = vel.normalized()
		scale = MmToPixel(1)
		initialVelocity = direction*PixelToMm2(vangularToMM(listTests[iterationTest]))
	elif mode == 1:
		direction = vel.normalized()
		scale = MmToPixel(angleToMm((listTests[iterationTest])))
		# 5000 px/s
		initialVelocity = direction*PixelToMm2(vangularToMM(175.05))
	initialPosition = pos
	initialRotationIteration = rotationIteration
	actualRotationIteration = rotationIteration
	iterations = 0
	rotation = deg2rad(get_random_rotation())
	score = 0
	initialMode = mode
	userRotationSuccess = 2
	travelledPixels = 0
	reset_internal_time()
	set_physics_process(true)
	show()
	emit_signal("start_timer")	
func stop():
	set_physics_process(false)
	hide()
func _on_VisibilityNotifier2D_screen_exited():
	travelledPixels = 0
	if initialSwing:
		initialVelocity *= -1
	else:
		position = initialPosition
	if initialMode:
		pass
	else:
		pass
	actualRotationIteration -= 1
	if actualRotationIteration == 0:
		rotation = deg2rad(get_random_rotation())
		userRotationSuccess = 2
		actualRotationIteration = initialRotationIteration
	var k = 1.0/fps
	
	emit_signal("debug_update")
	emit_signal("start_timer")
func reset_internal_time():
	unix_time_internal = Time.get_unix_time_from_system()
func _on_Octo_timeout():
	if increment == 0:
		 #non percentage
		if initialMode:
			var negativeValue = initialVelocity.x < 0
			if initialVelocity.x !=0:
				initialVelocity.x -= PixelToMm2(vangularToMM(speedOpto))
			if initialVelocity.y !=0:
				initialVelocity.y -= PixelToMm2(vangularToMM(speedOpto))
			if negativeValue != (initialVelocity.x < 0):
				initialVelocity = Vector2(0,0)
		else: 
			scale += MmToPixel(angleToMm(speedOpto))

	else:
		 # percentage
		if initialMode:
			initialVelocity /= 1+speedOpto/100.0*1.0
		else: 
			scale.x *= 1+speedOpto/100.0
			scale.y *= 1+speedOpto/100.0

