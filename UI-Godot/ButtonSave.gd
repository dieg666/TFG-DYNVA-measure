extends Button
signal load_is_done(id)
var mode = ''
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func pressed():
	pressed = true
func remove_press():
	pressed = false
func is_pressed():
	return pressed
func get_name():
	return text
func _on_Button_pressed():
	emit_signal("load_is_done",get_instance_id())

func set_text(t):
	text = t
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
