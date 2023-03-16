extends Node
signal show_score
signal show_debug_stats
var screen_size
var velocities
var positions
var run_mode
var position_delay
var resolution 
var size_dot_in_mm
var incrementType
var score = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Score.hide()
	resolution = OS.get_screen_size()
	#resolution = Vector2(1280,720)
	$Octo.projectResolution = resolution
	print("resolution:")
	print(resolution)
	$ColorRect.set_size(Vector2(3000,3000))

	get_tree().set_screen_stretch(
		SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, resolution
	)
	OS.set_window_size(resolution)
	var node_data = {}
	var color_data_background = Color.white
	var color_data_optotype = Color.black
	var save_game = File.new()
	if  save_game.file_exists("user://runs.save"):
		save_game.open("user://runs.save", File.READ)
		node_data = parse_json(save_game.get_line())
		save_game.close()
	
	save_game = File.new()
	if  save_game.file_exists("user://colorBackground.save"):
		save_game.open("user://colorBackground.save", File.READ)
		color_data_background = save_game.get_line()
		color_data_background = Color(color_data_background)
		save_game.close()
	else: 
		color_data_background = Color.white
		
	save_game = File.new()
	if  save_game.file_exists("user://colorOptotype.save"):
		save_game.open("user://colorOptotype.save", File.READ)
		color_data_optotype = save_game.get_line()
		color_data_optotype = Color(color_data_optotype)
		save_game.close()
	else: 
		color_data_optotype = Color.black
	$HUD.initialize(node_data as Dictionary, color_data_background as Color, color_data_optotype as Color)
	$DebugMode.hide()
	screen_size = $Octo.get_viewport_rect().size
	print("screen size values:")
	print(screen_size)
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
	position_delay = [
		Vector2(-1,0),
		Vector2(0,0),#Vector2(-1,-1),
		Vector2(0,-1),
		Vector2(0,0),#Vector2(1,-1),
		Vector2(1,0),
		Vector2(0,0),#Vector2(1,1),
		Vector2(0,1),
		Vector2(0,0),#Vector2(-1,1)
	]
func correct_scale(scale):
	var screenSizeInches = $HUD/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer4/SpinBox.value
	
	
func start_game(mode, _list):
	$ColorRect.color = Color($HUD.get_background_color())
	var optotype_color = Color($HUD.get_optotype_color())
	var screenSizeInches = $HUD/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer4/SpinBox.value
	var index = int(mode[2])
	var swing = int(mode[0])
	run_mode = int(mode[1])
	incrementType = int(mode[3])
	var speed = int(mode.substr(4,3))
	print("speed:")
	print(speed)
	var rotationIteration = 5
	$HUD.hide()
	var s = resolution * 1.0
	var d = sqrt(s.x*s.x+s.y*s.y)
	var x = (int(screenSizeInches)*1.0)/(d)
	size_dot_in_mm = x * 0.0254*1000

	var gap = 1 #cm
	var scale = 0.01*(10/size_dot_in_mm)*gap*5
	$Octo.start(positions[index], velocities[index],swing,run_mode,rotationIteration, optotype_color, scale,position_delay[index], incrementType, speed, _list,resolution,screenSizeInches)
	#_on_Octo_debug_update()
	if $HUD/CheckBox.pressed:
		$DebugMode.show()
		
	
func _process(_delta):
	if Input.is_action_pressed("escape"):
		$Octo.hide()
		$Octo.stop()
		$DebugMode.hide()
		$HUD.show()
		$Score.hide()		
func exit():
	var dict = $HUD.getData()
	var save_game = File.new()
	
	save_game.open("user://runs.save", File.WRITE)
	save_game.store_line(to_json(dict))
	save_game.close()
	
	save_game = File.new()
	save_game.open("user://colorBackground.save", File.WRITE)
	save_game.store_line($HUD.get_background_color())
	save_game.close()
	
	save_game = File.new()
	save_game.open("user://colorOptotype.save", File.WRITE)
	save_game.store_line($HUD.get_optotype_color())
	save_game.close()
	
	get_tree().quit()
func _on_Octo_debug_update():
	if $HUD/CheckBox.pressed:
		$DebugMode.velocity = $Octo.internalVelocity
		$DebugMode.size = 100*$Octo.scale
		$DebugMode.rotationDegree = $Octo.actualRotation
		$DebugMode.userRotationSuccess = $Octo.userRotationSuccess
		$DebugMode.score = $Octo.score
		$DebugMode.iterations = $Octo.iterations
		$DebugMode.travelledPixels = $Octo.travelledPixels

		emit_signal("show_debug_stats")
		
	else:
		$DebugMode.hide()
	pass # Replace with function body.



func _on_Octo_show_score():
	$Score.show()
	$Octo.hide()
	$Octo.stop()
	$DebugMode.hide()
	$Score.score = $Octo.score
	$Score.iterations = $Octo.iterations
	emit_signal("show_score")
	
