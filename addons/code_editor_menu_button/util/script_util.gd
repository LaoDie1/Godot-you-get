##==================================================
#	Script Util
##==================================================
# 获取脚本中的方法、属性名
##==================================================
# @path: res://addons/code_editor_menu_button/util/script_util.gd
# @datetime: 2021-6-23 22:20:06
##==================================================
extends "@util_base.gd"


## 返回节点的方法名列表
## @object 节点
static func get_object_method_list(object: Object):
	return get_list_name_list(object.get_method_list())


## 返回节点的脚本的方法名列表
## @object 对象
## @inherit_group 对继承进行分组
static func get_object_script_method_list(
	object: Object, 
	inherit_group: bool = false
) -> Array:
	if not is_instance_valid(object):
		return []
	if inherit_group:
		return get_script_inherit_method_list(object.get_script())
	else:
		var list = object.get_script().get_script_method_list()
		return get_list_name_list(list)


## 返回脚本继承方法列表
## @return 第一组为当前脚本的所有方法
##   按序号分组，包含当前脚本的方法
static func get_script_inherit_method_list(script: Script) -> Array:
	if not is_instance_valid(script):
		return []
	var list = []
	var temp = []
	for data in script.get_script_method_list():
		var method = data['name']
		# 方法是 _init 就代表接下来的都是继承的脚本的方法了
		if method == "_init":
			temp = []
			list.push_back(temp)
		else:
			temp.push_back(method)
	return list


## 返回列表名称列表
static func get_list_name_list(data_list: Array):
	if data_list.size() == 0:
		print("列表数量为 0")
		return []
	if not (data_list[0] is Dictionary
		&& data_list[0].has("name")
	):
		print("key 值没有 'name' ")
		return
	
	var list = []
	for data in data_list:
		list.push_back(data['name'])
	return list


## 格式化输出数据
static func print_data(data):
	print(JSON.print(data, '\t'))


## 返回对象继承的脚本类
static func get_object_inhert_class(object: Object):
	var script = object.get_script()
	if script == null:
		push_error(object.to_string() + " The script for the object is null")
		return null
	return get_inherit_script_class(object.get_script())


## 返回脚本继承的类
## (通过解析脚本代码获取继承的 class)
static func get_inherit_script_class(script: GDScript):
	if script == null:
		# 脚本为 null
		push_error("script is null")
		return
	
	# 正则表达式
	var regex = RegEx.new()
	regex.compile("extends\\s+(?<class>\\w+)")
	
	# 匹配结果
	var match_result = regex.search(script.source_code) as RegExMatch
	if match_result:
		var result = match_result.get_string("class")
		return result
	else:
		# 此对象脚本可能是内部类
		push_warning("Script object may be an inner class.")
		return null

## 返回 extends 关键字在脚本中的行数
static func get_extends_keyword_line(script: Script) -> int:
	return get_script_match_line(script, "extends")


## 返回脚本匹配行
## （通过正则表达式去匹配符合条件的行）
## @return 返回匹配的行，如果没有则返回 -1
static func get_script_match_line(
	script: Script, 
	regex_text: String
) -> int:
	if script == null:
		return -1
	
	var code = script.source_code
	var line_list = code.split("\n")
	if line_list.size() == 0:
		return 0
	
	# 搜索在哪一行
	var regex = RegEx.new()
	regex.compile(regex_text)
	for line in range(line_list.size()):
		var line_code = line_list[line]
		var match_result = regex.search(line_code)
		if match_result:
			if match_result.strings.size() > 0:
				return line
	return -1


## 行代码添加 setget 方法，根据属性名添加
static func line_code_add_setget_by_property(
	line_code: String,
	set_property: String = "", 
	get_property: String = ""
) -> String:
	# 去除空格和左右下划线
	get_property = get_property.replace(" ", "").lstrip("_").rstrip("_")
	set_property = set_property.replace(" ", "").lstrip("_").rstrip("_")
	
	if set_property:
		set_property = "set_" + set_property
	if get_property:
		get_property = "get_" + get_property
	return line_code_add_setget(line_code, set_property, get_property)


## 行代码添加 setget 方法
static func line_code_add_setget(
	line_code: String,
	set_method: String = "", 
	get_method: String = ""
) -> String:
	if line_code.length() == 0:
		return line_code
	# 如果 set 和 get 方法都为 "" 或 null，则返回原来的代码
	if set_method == "" && get_method == "":
		return line_code
	# 开头为 Tab 字符，则表示不是当前脚本的变量
	if line_code.left(1) == '\t':
		return line_code
	
	var regex = RegEx.new()
	var pattern = "(?<var>var\\s+\\w+)"	# 匹配模式代码
	# 匹配“=赋值”
	pattern += "\\s*(?<assig>=\\s*[\\w\"\'\\.]+)?"
	# 匹配setget
	pattern += "(\\s+setget\\s+" \
					+ "(?<set>\\w+)?(\\s*,\\s*)?(?<get>\\w+)?" \
				+ ")?"
	# 末尾注释
	pattern += "(?<end>[\\s\\S]*)"
	
	# 编译正则表达式
	regex.compile(pattern)
	
	# 匹配代码行
	var match_result = regex.search(line_code) as RegExMatch
	var _export = regex.sub(line_code, "")	# export 和 导出提示
	if _export.strip_escapes() == "":
		_export = ""
	var _var = match_result.get_string("var")	# var 和 变量名
	var assig = match_result.get_string("assig")	# 等号 和 赋值
	
	# set 方法
	var _set = match_result.get_string("set")
	if set_method != "":
		_set = set_method
	
	# get 方法
	var _get = match_result.get_string("get").strip_escapes()
	if get_method != "":
		_get = get_method
	if _get != "":
		_get = ", " + _get
	
	var end = match_result.get_string("end")	# 末尾注释
	
	var data = {
			"export": _export,
			"var": _var,
			"assig": assig,
			"set": _set,
			"get": _get,
			"end": end,
		}
	return "{export}{var} {assig} setget {set}{get} {end}".format(data)


## 返回变量行的数据，按 property 排列
static func get_var_code_by_property(code: String) -> Dictionary:
	return get_line_var_code_data(code, "property")

## 返回变量行的数据，按 line 排列
static func get_var_code_by_line(code: String) -> Dictionary:
	return get_line_var_code_data(code, "line")


## 返回变量行代码数据，按 by_key 值排列
## @code 返回对应的定义变量行的代码数据
static func get_line_var_code_data(
	code: String, 
	by_key: String = "line"
) -> Dictionary:
	var key_list = ["line", "line_code", "property"]
	if not by_key in key_list:
		printerr("不是 ", key_list, " 中的一个！")
		breakpoint
		return {}
	
	var regex = RegEx.new()
	regex.compile("var\\s+(\\w+)")
	
	var line_code_list = code.split("\n")
	var data_list = {}
	for idx in range(line_code_list.size()):
		var line_code = line_code_list[idx]
		if is_var_line(line_code):
			var match_ = regex.search(line_code)
			if match_ && match_.strings.size() > 0:
				var data = {
					"line": idx,
					"property": match_.get_string(1),
					"line_code": line_code,
				}
				data_list[data[by_key]] = data
	return data_list


## 返回变量行的数据，分组排列
static func get_var_code_by_group(code: String) -> Dictionary:
	var regex = RegEx.new()
	regex.compile("var\\s+(\\w+)")
	
	var line_code_list = code.split("\n")
	var line_group = []
	var code_group = []
	var property_group = []
	
	for idx in range(line_code_list.size()):
		var line_code = line_code_list[idx]
		if is_var_line(line_code):
			var match_ = regex.search(line_code)
			if match_ && match_.strings.size() > 0:
				line_group.push_back(idx)
				code_group.push_back(line_code)
				property_group.push_back(match_.get_string(1))
				
	var data_list = {
		"line_group": line_group,
		"code_group": code_group,
		"property_group": property_group,
	}
	return data_list


## 是否是个变量行
static func is_var_line(line_code: String):
	# 每行第一个字符需要是 e 或者 v 
	var first_char = line_code.left(1)
	if (line_code.length() > 0 
		&& (first_char == 'e'	# export
			|| first_char == 'v'	# var
			)
	):
		return line_code.find("var ") != -1
	return false


static func get_cursor_method_data(textedit: TextEdit, script: Script):
	var current_line = textedit.cursor_get_line()
	for line in range(current_line, textedit.get_line_count()):
		var line_code = textedit.get_line(line)
		# 判断是否是方法
		if (line_code.length() > 4
			&& line_code.left(4) == "func"
		):
			# 获取方法名
			var regex = RegEx.new()
			regex.compile("func\\s+(\\w+)")
			var _match = regex.search(line_code)
			if _match == null:
				continue
			# 获取方法数据
			var method = _match.get_string(1)	# 获取
			for m_data in script.get_method_list():
				if m_data == method:
					pass

## 返回脚本所在文件夹名称
static func get_script_dir_name(script: Script):
	if script == null:
		return ""
	
	var path = script.resource_path.get_base_dir()
	var p = path.find_last("/")
	if p != -1:
		return path.right(p+1)
	else:
		return ""

