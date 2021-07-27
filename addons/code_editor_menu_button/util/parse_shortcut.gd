## parse_shortcut.gd
## 解析快捷键
extends "@util_base.gd"


## 三个按键
const Key = {
	Ctrl = "ctrl",
	Alt = "alt",
	Shift = "shift",
}


## 解析快捷键
static func parse_shortcut(key: String) -> ShortCut:
	key = key.to_lower()
	
	var shortcut = ShortCut.new()
	
	# 是否需要按 Ctrl/Alt/Shift
	var input = InputEventKey.new()
	if key.find("ctrl") != -1:
		key = key.replace("ctrl", "")
		input.control = true
	if key.find("alt") != -1:
		key = key.replace("alt", "")
		input.alt = true
	if key.find("shift") != -1:
		key = key.replace("shift", "")
		input.shift = true
	if key.find("super"):
		key = key.replace('super', "")
		input.command = true
	elif key.find("win"):
		key = key.replace('win', "")
		input.command = true
	elif key.find("command"):
		key = key.replace('command', "")
		input.command = true
	
	# 去掉其他字符
	key = key.replace(" ", "")
	key = key.replace("+", "")
	
	# 设置检测码
	match key:
		"enter":
			input.scancode = KEY_ENTER
		"esc", "escape":
			input.scancode = KEY_ESCAPE
		"tab":
			input.scancode = KEY_TAB
		"' '":
			input.scancode = KEY_SPACE
		',':
			input.scancode = KEY_COMMA
		"backspace":
			input.scancode = KEY_BACKSPACE
		"del", "delete":
			input.scancode = KEY_DELETE
		"ins", "insert":
			input.scancode = KEY_INSERT
		"home":
			input.scancode = KEY_HOME
		"end":
			input.scancode = KEY_END
		_:
			if key.length() > 1:
				print_debug(key, "取首字母 [", key.left(1), "] 作为快捷键")
			key = key.to_upper()
			var asc = key.to_ascii()[0]
			input.scancode = asc
	
	shortcut.shortcut = input
	return shortcut


## 返回一个快捷键
static func get_shortcut(
	key_scancode: int,
	ctrl = false,
	alt = false,
	shift = false,
	command = false
) -> ShortCut:
	var shortcut = ShortCut.new()
	var input = InputEventKey.new()
	shortcut.shortcut = input
	input.scancode = key_scancode
	input.control = ctrl
	input.alt = alt
	input.shift = shift
	input.command = command
	return shortcut

