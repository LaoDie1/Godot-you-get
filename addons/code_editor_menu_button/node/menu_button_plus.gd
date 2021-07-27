# menu_button_plus.gd
extends MenuButton


var popup = get_popup()


func _init(_text:String=""):
	text = _text
	switch_on_hover = true
	popup.connect("id_pressed", self, '_on_PopupMenu_id_pressed')


# 适配 Popup index_pressed 信号
var popup_item_data = {}

## 添加菜单选项
## @return 返回添加的 item 的 id
func add_popup_item(
	label: String, 	# 菜单选项名
	object: Object = null, 	# 菜单调用方法对象
	method := "", 	# 调用的方法名
	binds := []	# 方法参数
) -> int:
	var idx = popup.get_item_count()
	popup.add_item(label, idx)
	
	if object && method != "":
		var data = {}
		data['object'] = object
		data['func'] = funcref(object, method)
		data['binds'] = binds
		popup_item_data[idx] = data
	return idx


## 设置菜单项快捷键
func set_item_shortcut(
	idx: int, 
	shortcut: ShortCut, 
	global: bool = false
):
	popup.set_item_shortcut(idx, shortcut, global)


## 添加分隔符
func add_separator():
	popup.add_separator("", 10000 + popup.get_item_count())


# 点击菜单项时调用对应的方法
func _on_PopupMenu_id_pressed(idx: int):
	if popup_item_data.has(idx):
		var data = popup_item_data[idx]
		var object = data['object'] as Object
		var ref_func = data['func'] as FuncRef
		# 调用方法
		if is_instance_valid(object):
			var binds = data['binds']
			ref_func.call_funcv(binds)
		else:
			print("对象无效！")

