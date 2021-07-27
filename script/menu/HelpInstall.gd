extends AcceptDialog


func _ready() -> void:
	var button = get_ok()
	var s = ShortCut.new()
	var i = InputEventKey.new()
	i.scancode = KEY_ESCAPE
	s.shortcut = i
	button.shortcut = s
	button.connect("pressed", self, "hide")
