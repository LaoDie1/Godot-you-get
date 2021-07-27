##==================================================
#	Plugin
##==================================================
# 重写方法插件
##==================================================
# @path: res://addons/code_editor_menu_button/plugin/override/plugin.gd
# @datetime: 2021-7-4 22:24:14
##==================================================
extends "../plugin_base.gd"


const OverrideFunc = preload("OverrideFunc.tscn")


var interface : EditorInterface
var class_manager : ClassManager_
var override_func = OverrideFunc.instance()
var parse_shortcut : ClassManager_.UtilParseShortcut



##==================================================
#   内置方法
##==================================================
func _init(infc: EditorInterface):
	interface = infc
	
	class_manager = ClassManager_.new(infc)
	
	# 解析快捷键
	parse_shortcut = ClassManager_.UtilParseShortcut.new()
	
	# OverrideFunc 节点
	override_func.connect("ok", self, "_on_OverrideFunc_ok")
	interface.get_editor_viewport().add_child(override_func)



##==================================================
#   自定义方法
##==================================================
#(override)
func init_menu_button(menu_button: NodeMenuButtonPlus):
	var idx = 0
	# 菜单调用的方法
	idx = menu_button.add_popup_item("重写方法", self, "init_method_data")
	# 设置菜单快捷键
	menu_button.set_item_shortcut(idx, parse_shortcut.parse_shortcut("Alt + Shift + S"))


##  初始化方法数据
func init_method_data():
	var script = class_manager.util_script_editor.get_current_script()
	# 显示方法列表
	override_func.show_method_list(script.get_script_method_list())
	# 显示弹窗
	override_func.popup_centered()



##==================================================
#   连接信号
##==================================================
func _on_OverrideFunc_ok(data_list: Array):
	var code = ""
	var method = ""
	var args = ""
	var return_type = 0
	for data in data_list:
		method = data['name']
		args = ""
		for idx in data['args'].size():
			args = "arg" + str(idx) + ", "
		args = args.trim_suffix(", ")
		return_type = data["return"]["type"]
	
	# 返回类型为 void
	if return_type == 0:
		code += """
#(override)
func {method}({args}):
	.{method}({args})
	pass
""".format({
			"method": method,
			"args": args,
		})
	
	# 返回类型不是 void
	else:
		code += """
#(override)
func {method}({args}) -> {return_type}:
	return .{method}({args})
""".format({
			"method": method,
			"args": args,
			"return_type" : override_func.get_type_string(return_type),
		})
	
	# 插入代码
	var text_edit = class_manager.util_script_editor.get_current_code_textedit()
	if text_edit:
		text_edit.insert_text_at_cursor(code)
