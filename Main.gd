extends Node
signal show_debug_stats
var screen_size
var velocities
var positions
var run_mode

# Called when the node enters the scene tree for the first time.
func _ready():
	$DebugMode.hide()
	screen_size = $Octo.get_viewport_rect().size
	positions = [
		Vector2(0,screen_size.y/2),
		Vector2(0,0),
		Vector2(screen_size.x/2,0),
		Vector2(screen_size.x,0),
		Vector2(screen_size.x,screen_size.y/2),
		Vector2(screen_size.x,screen_size.y),
		Vector2(screen_size.x/2,screen_size.y),
		Vector2(0,screen_size.y)
		]
	velocities = [
		Vector2(screen_size.x,0),
		Vector2(screen_size.x,screen_size.y),
		Vector2(0,screen_size.y),
		Vector2(-screen_size.x,screen_size.y),
		Vector2(-screen_size.x,0),
		Vector2(-screen_size.x,-screen_size.y),
		Vector2(0,-screen_size.y),
		Vector2(screen_size.x,-screen_size.y)
		]
	
func start_game():
	var index = $HUD.state
	var swing = $HUD.swing
	run_mode = $HUD.mode
	$HUD.hide()
	$Octo.start(positions[index], velocities[index],swing,run_mode)
	_on_Octo_debug_update()
	
func _process(_delta):
	if Input.is_action_pressed("escape"):
		$Octo.stop()
		$DebugMode.hide()
		$HUD.show()

func _on_Octo_debug_update():
	if $HUD/CheckBox.pressed:
		$DebugMode.velocity = $Octo.speed
		$DebugMode.size = $Octo.size
		emit_signal("show_debug_stats")
	else:
		$DebugMode.hide()
	pass # Replace with function body.
