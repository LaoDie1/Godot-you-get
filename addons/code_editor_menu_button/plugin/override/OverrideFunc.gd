##==================================================
#	Override Func
##==================================================
# 重写方法
##==================================================
# @path: res://addons/code_editor_menu_button/plugin/override/OverrideFunc.gd
# @datetime: 2021-7-4 22:21:13
##==================================================
tool
extends WindowDialog


const KEY_DATA = "method_data"


signal ok(data_list)
signal cancel()


onready var custom_method = find_node("Custom")


##==================================================
#   自定义方法
##==================================================
##  展示方法列表
## @method_list  方法数据列表
func show_method_list(method_list: Array) -> void:
	# 清除所有子节点
	for child in custom_method.get_children():
		child.queue_free()
	
	# 添加 CheckBox 节点
	var _temp_data = {}
	for data in method_list:
		# 防止添加重复的方法
		if _temp_data.has(data["name"]):
			continue
		_temp_data[data['name']] = true
		# 添加 CheckBox 节点
		var checkbox := CheckBox.new()
		checkbox.text = _format_data(data)
		checkbox.set_meta(KEY_DATA, data)
		custom_method.call_deferred("add_child", checkbox)


##  格式化数据
func _format_data(data) -> String:
	# 方法名
	var method = data['name']
	# 参数
	var args = ""
	for i in data['args'].size():
		args += "arg" + str(i) + ", "
	args = args.trim_suffix(", ")
	# 返回类型
	var return_type = get_type_string(data['return']['type'])
	
	return "func %s (%s): %s" % [method, args, return_type]


##  返回类型名称
func get_type_string(type):
	type = int(type)
	match type:
		TYPE_NIL:
			return "void"
		TYPE_BOOL:
			return "bool"
		TYPE_INT:
			return "int"
		TYPE_REAL:
			return "float"
		TYPE_STRING:
			return "String"
		TYPE_VECTOR2:
			return "Vector2"
		TYPE_RECT2:
			return "Rect2"
		TYPE_VECTOR3:
			return "Vector3"
		TYPE_TRANSFORM2D:
			return "Transform2D"
		TYPE_PLANE:
			return "Plane"
		TYPE_QUAT:
			return "Quat"
		TYPE_AABB:
			return "AABB"
		TYPE_BASIS:
			return "Basis"
		TYPE_TRANSFORM:
			return "Transform"
		TYPE_COLOR:
			return "Color"
		TYPE_NODE_PATH:
			return "NodePath"
		TYPE_RID:
			return "RID"
		TYPE_OBJECT:
			return "Object"
		TYPE_DICTIONARY,TYPE_ARRAY,TYPE_RAW_ARRAY,TYPE_INT_ARRAY,TYPE_REAL_ARRAY,TYPE_STRING_ARRAY,TYPE_VECTOR2_ARRAY,TYPE_VECTOR3_ARRAY,TYPE_COLOR_ARRAY:
			return "Array"



##==================================================
#   连接信号
##==================================================
func _on_OK_pressed():
	# 获取勾选的 CheckBox 的数据
	var data_list = []
	for child in custom_method.get_children():
		if child.pressed:
			data_list.push_back(child.get_meta(KEY_DATA))
	emit_signal("ok", data_list)
	self.hide()


func _on_Cancel_pressed():
	self.hide()
	emit_signal("cancel")
