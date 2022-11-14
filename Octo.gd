extends Sprite
signal debug_update
export var speed = 1000 # How fast the player will move (pixels/sec).
export var size = 1
var initialPosition = Vector2.ZERO 
var initialVelocity = Vector2.ZERO 
var initialSwing = false
var initialMode = false
var initialRotationIteration = 5
var actualRotationIteration = 5
var actualRotation = 0
var score = 0
var iterations = 0
var rng = RandomNumberGenerator.new()
var userRotationSuccess = 2 # 0 is false, 1 is true, 2 is not defined
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
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
func _process(delta):
	var velocity = initialVelocity.normalized()
	velocity = velocity.normalized() * speed
	position += velocity * delta
func get_random_rotation():
	iterations += 1
	var rotations = [0,-45,-90,-135,-180,-225,-270,-315]
	actualRotation = rotations[rng.randi() % rotations.size()]
	return actualRotation
func start(pos,vel,swing,mode,rotationIteration, optotype_color : Color):
	$OctoSprite.material.set_shader_param("color", Vector3(optotype_color.r, optotype_color.g, optotype_color.b))
	$OctoSprite.material.set_shader_param("alpha", optotype_color.a)
	position = pos
	initialSwing = swing
	initialVelocity = vel
	initialPosition = pos
	initialRotationIteration = rotationIteration
	actualRotationIteration = rotationIteration
	iterations = 0
	rotation = deg2rad(get_random_rotation())
	speed = 1000
	size = 1
	score = 0
	scale = Vector2(1,1)
	initialMode = mode
	userRotationSuccess = 2
	show()
func stop():
	hide()
	initialPosition = Vector2.ZERO 
	initialVelocity = Vector2.ZERO 
func _on_VisibilityNotifier2D_screen_exited():
	if initialSwing:
		initialVelocity *= -1
	else:
		position = initialPosition
	if initialMode:
		speed *= rand_range(0.8, 1.7)
		if speed > 2000:
			speed = 2000
	else:
		var rn = rand_range(0.2, 1.6)
		scale *= rn
		size *= rn
		if size > 2:
			size = 2
			scale = Vector2(2,2)
		if size < 0.2:
			size = 0.2
			scale = Vector2(0.2,0.2)
	actualRotationIteration -= 1
	if actualRotationIteration == 0:
		rotation = deg2rad(get_random_rotation())
		userRotationSuccess = 2
		actualRotationIteration = initialRotationIteration
	emit_signal("debug_update")
