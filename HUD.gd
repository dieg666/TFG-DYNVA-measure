extends CanvasLayer
signal start_game
signal exit
var state = 0
var swing = false
var mode = true
var dict = {}
var actualButton = ''
# Called when the node enters the scene tree for the first time.
func _ready():
	$Control.hide()
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
			var buttons_pck = preload("res://VBoxContainer.tscn")
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
	dict = d
	for item in d:
		var buttons_pck = preload("res://ButtonSave.tscn")
		var buttons = buttons_pck.instance()
		buttons.connect("load_is_done", self, "_load_is_done" )
		buttons.text = item
		$PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.add_child(buttons)
	
func _on_Button_pressed():
	emit_signal("exit")

func _on_Button2_pressed():
	var buttons_pck = preload("res://VBoxContainer.tscn")
	var buttons = buttons_pck.instance()
	buttons.connect("delete", self, "_on_VBoxContainer_delete" )
	buttons.connect("add", self, "_on_VBoxContainer_add" )
	delete_children($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer)
	$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.add_child(buttons)
	
func _on_Button_toggled(button_pressed):
	swing = button_pressed # Replace with function body.
	
func _on_Button5_pressed():
	if $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_child_count() != 0:
		$PanelContainer.hide()
		$CheckBox.hide()
		$Control.show()
	
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
	
func _load_is_done():
	for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		if item.is_pressed():
			delete_children($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer)
			for k in dict[item.text]:
				var buttons_pck = preload("res://VBoxContainer.tscn")
				var buttons = buttons_pck.instance()
				buttons.connect("delete", self, "_on_VBoxContainer_delete" )
				buttons.connect("add", self, "_on_VBoxContainer_add" )
				buttons.set_value(k)
				actualButton = item.text	
				$PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.add_child(buttons)
				
func _on_Control_save_is_done():
	var file_name = $Control/VBoxContainer/LineEdit 
	var value = file_name.text
	if filename_exists(file_name.text):
		$Control/VBoxContainer/Label2.text = "ya existe"
	else:
		$PanelContainer.show()
		$CheckBox.show()
		$Control.hide()
		var buttons_pck = preload("res://ButtonSave.tscn")
		var buttons = buttons_pck.instance()
		buttons.connect("load_is_done", self, "_load_is_done" )
		buttons.text = file_name.text
		$PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.add_child(buttons)
		$Control/VBoxContainer/LineEdit.text = ""

		dict[value] = get_values($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer.get_children())
		actualButton = value

func _on_Button4_pressed():
	if actualButton != '':
		for item in $PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
			if item.get_name() == actualButton:
				dict.erase(actualButton)
				$PanelContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.remove_child(item)
				delete_children($PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer)
				return 
