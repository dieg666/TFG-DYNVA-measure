extends LineEdit

var value : float  # export as needed
var suffix = ""
var preffix = ""
func _ready() -> void:
  connect("text_changed", self, "_on_LineEdit_text_changed")

func _on_LineEdit_text_changed(new_text: String) -> void: # "text_changed" signal handler
	if new_text.is_valid_float():
		print(value)
		print("float is")
		value = float(new_text)
		print(value)
	else: # optional rollback to last good one
		self.text = str(value)
