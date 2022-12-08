extends Node2D
signal debug_update
signal start_timer

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
# Called when the node enters the scene tree for the first time.
func _ready():
	fps = ProjectSettings.get_setting("physics/common/physics_fps")
	set_physics_process(false)
	position = Vector2.ZERO
	hide()
	pass # Replace with function body.
func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("N"):
			userRotationSuccess = int(actualRotation == -90)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif Input.is_action_just_pressed("NO"):
			userRotationSuccess = int(actualRotation == -135)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif Input.is_action_just_pressed("O"):
			userRotationSuccess = int(actualRotation == -180)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif Input.is_action_just_pressed("SO"):
			userRotationSuccess = int(actualRotation == -225)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif Input.is_action_just_pressed("S"):
			userRotationSuccess = int(actualRotation == -270)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif Input.is_action_just_pressed("SE"):
			userRotationSuccess = int(actualRotation == -315)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif Input.is_action_just_pressed("E"):
			userRotationSuccess = int(actualRotation == -0)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		elif Input.is_action_just_pressed("NE"):
			userRotationSuccess = int(actualRotation == -45)
			if userRotationSuccess:
				score += 1
			rotation = deg2rad(get_random_rotation())
		emit_signal("debug_update")

func _physics_process(delta):
	emit_signal("debug_update")
	var velocity = initialVelocity.normalized()
	var pixelPorSegundo = 1280+scale.x*100
	velocity = velocity * pixelPorSegundo * delta
	travelledPixels += pixelPorSegundo * delta
	position += velocity 
	if Time.get_unix_time_from_system() - unix_time_internal > 2:
		var k = 1.0/fps
		internalVelocity = (k*pixelPorSegundo*1.0)/k
		emit_signal("timeout")
		reset_internal_time()
	
func get_random_rotation():
	iterations += 1
	var rotations = [0,-45,-90,-135,-180,-225,-270,-315]
	actualRotation = rotations[rng.randi() % rotations.size()]
	return actualRotation
	
func start(pos,vel,swing,mode,rotationIteration, optotype_color : Color, scaleInitial,posDelay):
	$OctoSprite.material.set_shader_param("color", Vector3(optotype_color.r, optotype_color.g, optotype_color.b))
	$OctoSprite.material.set_shader_param("alpha", optotype_color.a)
	scale = Vector2(1,1)
	scale = scaleInitial*scale
	pos.x = pos.x + posDelay.x*100*scale.x
	pos.y = pos.y + posDelay.y*100*scale.y
	position = pos
	initialSwing = swing
	initialVelocity = vel
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
	print("travelledPixels")
	print(travelledPixels)
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
	var pixelPorSegundo = 1280+scale.x*100
	internalVelocity = (k*pixelPorSegundo*1.0)/k
	emit_signal("debug_update")
	emit_signal("start_timer")
	

	

func reset_internal_time():
	unix_time_internal = Time.get_unix_time_from_system()



func _on_Octo_timeout():
	
	scale *=1.05
	pass # Replace with function body.
