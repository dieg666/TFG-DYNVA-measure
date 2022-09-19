extends RigidBody2D
signal debug_update
export var speed = 1000 # How fast the player will move (pixels/sec).
export var size = 1
var initialPosition = Vector2.ZERO 
var initialVelocity = Vector2.ZERO 
var initialSwing = false
var initialMode = false
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

	
func start(pos,vel,swing,mode):
	position = pos
	initialSwing = swing
	initialVelocity = vel
	initialPosition = pos
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
		if speed > 5000:
			speed = 5000
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
	emit_signal("debug_update")

