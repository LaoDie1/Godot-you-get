##==================================================
#	Add Comments
##==================================================
# 
##==================================================
# @path: res://addons/code_editor_menu_button/plugin/comments/add_comments_.gd
# @datetime: 2021-6-23 22:18:18
##==================================================


extends Reference


const ClassManager_ = preload("../../class_manager.gd")


var class_manager : ClassManager_
var interface : EditorInterface


func _init(infc: EditorInterface):
	interface = infc
	class_manager = ClassManager_.new(interface)


## 方法注释
func get_cursor_next_method_comments() -> String:
	var editor = class_manager.util_script_editor.get_current_code_textedit()
	var data = class_manager.util_script_editor.get_cursor_next_method_data(editor)
	if data.empty():	# 没有获取到方法,返回空
		push_warning("no function")
		print("没有获取到方法")
		return ""
	
	# 方法名
	var comments = "##  %s " % data['name'].capitalize()
	# 参数列表
	for arg in data['args']:
		var arg_name = arg['name'].replace(" ", "")
		if arg_name != "":
			comments += "\n## @%s  " % arg_name
	# 返回
	data['return_type'] = data['return_type'].strip_escapes()
	
	if data['return_type'] != "" && data['return_type'] != "void":
		comments += "\n## @return " #+ data['return_type']
	return comments


## 分类注释
static func get_classify_comments(group_name: String=""):
	return """#{separator}
#   {group_name}
#{separator}""".format(
	{
		"separator": get_separator_comments(),
		"group_name": group_name,
	})


## 脚本信息注释
func get_script_info_comments(author:String=""):
	return """#{separator}
#\t{name}
#{separator}
# 
#{separator}
# @path: {path}{author}
# @datetime: {datetime}
#{separator}
""".format(
	{
		"separator": get_separator_comments(),
		"datetime": get_datatime(),
		"path": _get_current_script_path(),
		"name": _get_current_script_name(false).capitalize(),
		"author": "\n# @author: "+author if author!="" else "",
	})


## 当前脚本的路径
func _get_current_script_path() -> String:
	var script = interface.get_script_editor().get_current_script()
	return script.resource_path if script else ""


## 当前脚本名
## @has_extension 是否带扩展名
func _get_current_script_name(has_extension: bool=true) -> String:
	var path = _get_current_script_path()
	if has_extension:
		return path.get_file()
	else:
		var ext = path.get_extension().length()
		if ext > 0:
			ext += 1	# 带上小数点
		var name_length = path.get_file().length()
		return path.get_file().left(name_length-ext)


## 分隔注释
static func get_separator_comments() -> String:
	return "#=================================================="


## 时间日期
static func get_datatime() -> String:
	return get_data() + " " + get_time()

static func get_data() -> String:
	return "{year}-{month}-{day}".format(OS.get_datetime())

static func get_time() -> String:
	var data = OS.get_datetime()
	data['hour'] = "%02d" % int(data['hour'])
	data['minute'] = "%02d" % int(data['minute'])
	data['second'] = "%02d" % int(data['second'])
	return "{hour}:{minute}:{second}".format(data)


