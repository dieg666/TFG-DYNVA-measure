extends RigidBody2D
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
var rng = RandomNumberGenerator.new()

var userRotationSuccess = 2 # 0 is false, 1 is true, 2 is not defined
# Called when the node enters the scene tree for the first time.
func _ready(): 
	randomize()
	hide()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = initialVelocity.normalized()
	velocity = velocity.normalized() * speed
	position += velocity * delta
	if Input.is_action_pressed("N"):
		userRotationSuccess = int(actualRotation == -90)
		#rotation = deg2rad(get_random_rotation())
	elif Input.is_action_pressed("NO"):
		userRotationSuccess = int(actualRotation == -135)	
		#rotation = deg2rad(get_random_rotation())
	elif Input.is_action_pressed("O"):
		userRotationSuccess = int(actualRotation == -180)	
		#rotation = deg2rad(get_random_rotation())
	elif Input.is_action_pressed("SO"):
		userRotationSuccess = int(actualRotation == -225)	
		#rotation = deg2rad(get_random_rotation())
	elif Input.is_action_pressed("S"):
		userRotationSuccess = int(actualRotation == -270)	
		#rotation = deg2rad(get_random_rotation())
	elif Input.is_action_pressed("SE"):
		userRotationSuccess = int(actualRotation == -315)	
		#rotation = deg2rad(get_random_rotation())
	elif Input.is_action_pressed("E"):
		userRotationSuccess = int(actualRotation == -0)
		#rotation = deg2rad(get_random_rotation())
	elif Input.is_action_pressed("NE"):
		userRotationSuccess = int(actualRotation == -45)	
		#rotation = deg2rad(get_random_rotation())
func get_random_rotation():
	var rotations = [0,-45,-90,-135,-180,-225,-270,-315]
	actualRotation = rotations[rng.randi() % rotations.size()]
	return actualRotation
	
	
func start(pos,vel,swing,mode,rotationIteration):
	position = pos
	initialSwing = swing
	initialVelocity = vel
	initialPosition = pos
	initialRotationIteration = rotationIteration
	actualRotationIteration = rotationIteration
	rotation = deg2rad(get_random_rotation())
	speed = 1000
	size = 1
	scale = Vector2(1,1)
	initialMode = mode
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

