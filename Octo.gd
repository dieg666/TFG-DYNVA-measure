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
var actualRotation = 0
var score = 0
var iterations = 1
var rng = RandomNumberGenerator.new()
var projectResolution
var size_dot = 0
var unix_time_internal: float = 999999
var userRotationSuccess = 2 # 0 is false, 1 is true, 2 is not defined
var travelledPixels = 0
var fps = 1
var internalVelocity = 0 # display purposes
var increment
var speedOpto
var iterationTest = 0
var direction = Vector2.ZERO
var listTests = []
var size_dot_in_mm = 0 
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
	if event is InputEventKey:
		if Input.is_action_just_pressed("N"):
			iterations += 1
			userRotationSuccess = int(actualRotation == -90)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif Input.is_action_just_pressed("NO"):
			iterations += 1
			userRotationSuccess = int(actualRotation == -135)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif Input.is_action_just_pressed("O"):
			iterations += 1
			userRotationSuccess = int(actualRotation == -180)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif Input.is_action_just_pressed("SO"):
			iterations += 1
			userRotationSuccess = int(actualRotation == -225)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif Input.is_action_just_pressed("S"):
			iterations += 1
			userRotationSuccess = int(actualRotation == -270)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif Input.is_action_just_pressed("SE"):
			iterations += 1
			userRotationSuccess = int(actualRotation == -315)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif Input.is_action_just_pressed("E"):
			iterations += 1
			userRotationSuccess = int(actualRotation == -0)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif Input.is_action_just_pressed("NE"):
			iterations += 1
			userRotationSuccess = int(actualRotation == -45)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		
		if userRotationSuccess == 1:
			iterationTest += 1
			userRotationSuccess = 2
			if iterationTest >= listTests.size():
				emit_signal("show_score")
				stop()
				return 0
			else:
				next_move()
				
				if initialMode == 0:
					initialVelocity = direction*listTests[iterationTest]
					scale = Vector2(1,1)*0.01*(10/size_dot_in_mm)*0.1*5
				elif initialMode == 1:
					initialVelocity = direction*5000
					scale = Vector2(1,1)*0.01*(10/size_dot_in_mm)*listTests[iterationTest]
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
		internalVelocity = (velocity)
		emit_signal("timeout")
		reset_internal_time()
	
func get_random_rotation():

	var rotations = [0,-45,-90,-135,-180,-225,-270,-315]
	actualRotation = rotations[rng.randi() % rotations.size()]
	return actualRotation
	
func start(pos,vel,swing,mode,rotationIteration, optotype_color : Color, scaleInitial,posDelay,incrementType, speed, list,resolution,screenSizeInches):

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
	var s = resolution * 1.0
	var d = sqrt(s.x*s.x+s.y*s.y)
	var x = (int(screenSizeInches)*1.0)/(d)
	size_dot_in_mm = x * 0.0254*1000



	# speed6
	if mode == 0:
		direction = vel.normalized()
		scale = Vector2(1,1)*0.01*(10/size_dot_in_mm)*0.1*5
		initialVelocity = direction*listTests[iterationTest]
	elif mode == 1:
		direction = vel.normalized()
		scale = Vector2(1,1)*0.01*(10/size_dot_in_mm)*listTests[iterationTest]
		initialVelocity = direction*5000
	
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
			if initialVelocity.x !=0:
				initialVelocity.x -= speedOpto
			if initialVelocity.y !=0:
				initialVelocity.y -= speedOpto
		else: 
			scale.x += speedOpto/100.0
			scale.y += speedOpto/100.0
	else:
		 # percentage
		if initialMode:
			initialVelocity /= 1+speedOpto/100.0*1.0
		else: 
			scale.x *= 1+speedOpto/100.0
			scale.y *= 1+speedOpto/100.0

	#scale *=1.05
	pass # Replace with function body.
