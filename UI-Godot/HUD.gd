extends CanvasLayer
signal start_game
signal show_override
signal exit
var state = 0
var swing = false
var node_selected = ''
var dict = {}
var mode = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	print ($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/ColorBackgroundButton.color)
	$Save.hide()
	pass # Replace with function body.
func get_background_color():
	return $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/ColorBackgroundButton.color.to_html()
func _on_Start_pressed():
	print(_get_mode())
	emit_signal("start_game", _get_mode(), get_values($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children()))
func _on_DirectionOptionButton_item_selected(index):
	state = index
func _on_CheckBox2_pressed():
	if !$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox2.pressed:
		$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox2.pressed = true
	$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox.pressed = false

	pass # Replace with function body.
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
func _on_CheckBox_pressed():
	if !$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox.pressed:
		$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox.pressed = true
	$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox2.pressed = false
func renumerate_values(container):
	var i = 1
	for button in container:
		button.set_text(i)
		i += 1
func _on_VBoxContainer_add():
	for button in $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children():
		if button.is_Pressed() == 2:
			var buttons_pck = preload("res://UI-Godot/VBoxContainer.tscn")
			var new_button = buttons_pck.instance()
			new_button.connect("delete", self, "_on_VBoxContainer_delete" )
			new_button.connect("add", self, "_on_VBoxContainer_add" )
			$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.add_child_below_node(button,new_button)
			button.reset_click()
			renumerate_values($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children())
			return
func _on_VBoxContainer_delete():
	if $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children().size() == 1:
		return 
	for button in $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children():
		if button.is_Pressed() == 1:
			$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.remove_child(button)
			renumerate_values($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children())
			return
func getData():
	return dict
func change_to_mode(encoded_mode):
	$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/Button.pressed = '0' != encoded_mode[0]
	$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox.pressed = '0' == encoded_mode[1]
	$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox2.pressed = '0' != encoded_mode[1]
	$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/DirectionOptionButton.select(int(encoded_mode[2]))
func initialize(d, color):
	delete_children($PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer)
	$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/ColorBackgroundButton.color = color
	dict = d
	for item in d:
		var buttons_pck = preload("res://UI-Godot/ButtonSave.tscn")
		var buttons = buttons_pck.instance()
		buttons.connect("load_is_done", self, "_load_is_done" )
		buttons.text = item.substr(3,-1)
		buttons.mode = item.substr(0,3)
		if buttons.text == node_selected:
			buttons.pressed()
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
				node_selected = item.text
				$Save/VBoxContainer/LineEdit.text = item.text
				break
			$Save/VBoxContainer/LineEdit.text = ""
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
func _get_key_from_dict(value):
	for i in dict.keys():
		if value == i.substr(3,-1):
			return i
func _load_is_done(id):
	for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		if item.get_instance_id() != id:
			item.remove_press()
	for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		if item.is_pressed():
			delete_children($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer)
			var i = 1
			for k in dict[_get_key_from_dict(item.text)]:
				var buttons_pck = preload("res://UI-Godot/VBoxContainer.tscn")
				var buttons = buttons_pck.instance()
				buttons.set_text(i)
				buttons.connect("delete", self, "_on_VBoxContainer_delete" )
				buttons.connect("add", self, "_on_VBoxContainer_add" )
				buttons.set_value(k)
				change_to_mode(_get_key_from_dict(item.text))
				i += 1
				$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.add_child(buttons)
func _on_Control_save_is_done():
	var file_name = $Save/VBoxContainer/LineEdit 
	var value = file_name.text
	node_selected = file_name.text
	if filename_exists(value):
		$Save.text = value
		emit_signal("show_override")
	else:
		save(_get_mode(),value)
func _on_Button4_pressed():
	for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		if item.is_pressed():
			dict.erase(_get_key_from_dict(item.text))
			$PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.remove_child(item)
			delete_children($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer)
			return 
func save(encoded_mode, value):
	$PanelContainer.show()
	$CheckBox.show()
	$Save.hide()
	# to do change access mode to dictionary
	dict.erase(_get_key_from_dict(value))
	dict[encoded_mode+value] = get_values($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children())
	initialize(dict, $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/ColorBackgroundButton.color)

func _on_Save_override(choice):
	if choice:	
		var file_name = $Save/VBoxContainer/LineEdit 
		var value = file_name.text
		save(_get_mode(),value)
	else:
		_save_test_pressed()

func _get_mode():
	var encoded_mode = ''
	encoded_mode += str(int($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/Button.pressed))
	encoded_mode += str(int(!$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CheckBox.pressed))
	encoded_mode += str(state)
	return encoded_mode

