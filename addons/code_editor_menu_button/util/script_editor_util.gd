## script_util.gd
## 脚本编辑器菜单工具

extends "@util_base.gd"


var menu_button_list = []	# 菜单按钮列表



#========================================
#  初始化数据
#========================================
func init_data():
	.init_data()
	
	_all_menu_button()


## 获取所有 MenuButton
func _all_menu_button():
	# 获取编辑器视图
	var v_editor = interface.get_editor_viewport()
	
	# 获取脚本编辑器菜单列表
	var hbox = v_editor.get_child(2).get_child(0).get_child(0)
	for child in hbox.get_children():
		if child is MenuButton:
			menu_button_list.push_back(child)


#========================================
#  自定义方法
#========================================
## 添加菜单按钮
func add_menu_button(menu_button: MenuButton):
	# 等待编辑器加载
	var script_editor = interface.get_script_editor()
	if !script_editor.visible:
		yield(script_editor, "visibility_changed")
	
	# 添加菜单钮
	var node = menu_button_list.back() as MenuButton
	var parent = node.get_parent()
	parent.add_child(menu_button)
	# 设置按钮位置到最后一个菜单项的后面
	parent.move_child(menu_button, node.get_index() + 1)
	menu_button_list.push_back(menu_button)


## 返回当前代码编辑框
func get_current_code_textedit() -> TextEdit:
	var script_editor = interface.get_script_editor()
	
	# 左侧 Tab 脚本列表
	var tab_container = script_editor.get_child(0).get_child(1).get_child(1) as TabContainer
#	for idx in tab_container.get_tab_count():
#		# 输出左侧已打开的脚本或文档的Tab节点名
#		print(tab_container.get_tab_title(idx))
	
	# 代码文本编辑器在第3级子节点
	var code_editor = tab_container.get_current_tab_control()
	for i in 3:
		code_editor = code_editor.get_child(0)
	
	return code_editor


## 返回当前脚本代码
func get_current_script_code() -> String:
	var code_textedit = get_current_code_textedit()
	return code_textedit.text if code_textedit else ""




#========================================
#  编辑器方法
#========================================
## 返回当前光标处下面的方法数据
static func get_cursor_next_method_data(textedit: TextEdit) -> Dictionary:
	var code_list = []
	for row in textedit.get_line_count():
		code_list.push_back(textedit.get_line(row))
	return get_next_line_method_data(code_list, textedit.cursor_get_line())


## 返回行下面的方法的数据
static func get_next_line_method_data(
	code_list: Array, 
	current_line: int = 0
) -> Dictionary:
	var func_line = 0
	for line in range(current_line, code_list.size()):
		var current_line_code = code_list[line]
		# 当前行不是 func 方法行则跳到下一行
		if _is_func_line(current_line_code):
			func_line = line
			break
	
	# 没有找到方法
	if func_line >= code_list.size():
		return {}
	
	# 获取定义这个方法的代码
	var method_code = _match_def_func_code(code_list, func_line)
	method_code = method_code.replace("\t", "")
	
	## 匹配模式代码 ##
	# 匹配方法名
#	var pattern = "func\\s+(?<method>[\\w\u4e00-\u9fa5]+)"
	var pattern = "func\\s+(?<method>[^\\s:]+)"
	# 匹配参数
	pattern += "\\("
	pattern += "(?<args>[^\\)]*)?"
	pattern += "\\)"
	# 匹配 ) 到 : 之间的字符
	pattern += "(?<return_type>[^:]*):"
	
	# 查找方法参数
	var regex = RegEx.new()
	regex.compile(pattern)
	var r_match = regex.search(method_code)
	if r_match != null:
		var return_type = r_match.get_string("return_type")
		return_type = return_type.replace("->","").lstrip(" ")
		var data = {
			"name": r_match.get_string("method"),
			"args": _args_data(r_match.get_string("args")),
			"return_type": return_type,
		}
		return data
	return {}


## 匹配定义的方法的代码
static func _match_def_func_code(
	code_list: Array, 
	current_line: int
) -> String:
	if not _is_func_line(code_list[current_line]):
		printerr("current_line 起始行没有 func 方法")
		return ""
	
	# 获取这个方法的代码
	var method_code = code_list[current_line]	# 起始行代码
	
	# 开始匹配方法末尾行
	var end_regex = RegEx.new()
	end_regex.compile("\\)[^:]*:")	# 匹配 ): 或 )->w:
	for line in range(current_line+1, code_list.size()):
		var current_line_code = code_list[line]
		method_code += current_line_code	# 追加当前行
		# 当前行是否是结束行
		var r_match = end_regex.search(current_line_code)
		if r_match != null:	# 不为 null 则匹配到了
			break
	return method_code


## 是否是方法行
static func _is_func_line(line_code: String):
	return (line_code.length() >= 7		# 一行最少 7 个字符
			&& (line_code.left(4) == "func" || line_code.left(6) == "static")
		)


## 返回参数数据
static func _args_data(text: String):
	var data_list = []
	var arg_list = text.split(',')
	for i in arg_list:
		var arg = i.split(":")
		var arg_name = arg[0]
		var type = ""
		if arg.size() > 1:
			type = arg[1]
		var default_value = ""
		if type != "":
			var length = type.find("=")
			if length != -1:
				default_value = type.right(length+1)
				type = type.left(length)
		
		data_list.push_back({
			"name": arg_name,
			"type": type,
			"value": default_value
		})
	return data_list


##  返回当前脚本
## @reload 是否对脚本进行加载
func get_current_script(reload = true):
	return interface.get_script_editor().get_current_script()


##  返回当前脚本路径 
func get_current_script_path() -> String:
	var script = interface.get_script_editor().get_current_script()
	return script.resource_path if script else ""
