extends CanvasLayer
signal start_game
signal show_override
signal exit
var state = 0
var swing = false
var mode = true
var dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Save.hide()
	pass # Replace with function body.
func _on_Start_pressed():
	emit_signal("start_game")
func _on_DirectionOptionButton_item_selected(index):
	state = index
func _on_CheckBox2_pressed():
	if !$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox2.pressed:
		$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox2.pressed = true
	$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox.pressed = false
	mode = false
	pass # Replace with function body.
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
func _on_CheckBox_pressed():
	if !$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox.pressed:
		$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox.pressed = true
	$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox2.pressed = false
	mode = true
func _on_VBoxContainer_add():
	for button in $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children():
		if button.is_Pressed() == 2:
			var buttons_pck = preload("res://UI-Godot/VBoxContainer.tscn")
			var new_button = buttons_pck.instance()
			new_button.connect("delete", self, "_on_VBoxContainer_delete" )
			new_button.connect("add", self, "_on_VBoxContainer_add" )
			$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.add_child_below_node(button,new_button)
			button.reset_click()
			return
func _on_VBoxContainer_delete():
	if $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children().size() == 1:
		return 
	for button in $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children():
		if button.is_Pressed() == 1:
			$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.remove_child(button)
			return
func getData():
	return dict
func initialize(d):
	delete_children($PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer)
	dict = d
	for item in d:
		var buttons_pck = preload("res://UI-Godot/ButtonSave.tscn")
		var buttons = buttons_pck.instance()
		buttons.connect("load_is_done", self, "_load_is_done" )
		buttons.text = item
		$PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.add_child(buttons)
func _on_Button_pressed():
	emit_signal("exit")
func _on_Button2_pressed():
	for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		item.pressed = false
	var buttons_pck = preload("res://UI-Godot/VBoxContainer.tscn")
	var buttons = buttons_pck.instance()
	buttons.connect("delete", self, "_on_VBoxContainer_delete" )
	buttons.connect("add", self, "_on_VBoxContainer_add" )
	delete_children($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer)
	$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.add_child(buttons)	
func _on_Button_toggled(button_pressed):
	swing = button_pressed # Replace with function body.	
func _save_test_pressed():
	if $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_child_count() != 0:
		for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
			if item.is_pressed():
				$Save/VBoxContainer/LineEdit.text = item.text
		$PanelContainer.hide()
		$CheckBox.hide()
		$Save.show()
func filename_exists(file_name):
	for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		if item.text == file_name:
			return true
	return false
func get_values(list):
	var l = []
	for item in list:
		l.append(item.value())
	return l
func _load_is_done(id):
	print(id)
	for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		if item.get_instance_id() != id:
			item.remove_press()
	for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		if item.is_pressed():
			delete_children($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer)
			for k in dict[item.text]:
				var buttons_pck = preload("res://UI-Godot/VBoxContainer.tscn")
				var buttons = buttons_pck.instance()
				buttons.connect("delete", self, "_on_VBoxContainer_delete" )
				buttons.connect("add", self, "_on_VBoxContainer_add" )
				buttons.set_value(k)
				$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.add_child(buttons)
func _on_Control_save_is_done():
	var file_name = $Save/VBoxContainer/LineEdit 
	var value = file_name.text
	if filename_exists(file_name.text):
		$Save.text = value
		emit_signal("show_override")
		
	else:
		save(value)
func _on_Button4_pressed():
	for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		if item.is_pressed():
			dict.erase(item.text)
			$PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.remove_child(item)
			delete_children($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer)
			return 
func save(value):
	$PanelContainer.show()
	$CheckBox.show()
	$Save.hide()
	var buttons_pck = preload("res://UI-Godot/ButtonSave.tscn")
	dict[value] = get_values($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children())
	initialize(dict)

func _on_Save_override(choice):
	if choice:	
		var file_name = $Save/VBoxContainer/LineEdit 
		var value = file_name.text
		save(value)
	else:
		_save_test_pressed()
