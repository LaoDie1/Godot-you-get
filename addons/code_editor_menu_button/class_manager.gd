##==================================================
#	Class Manager
##==================================================
# 自定义类管理器
##==================================================
# @path: res://addons/code_editor_menu_button/class_manager.gd
# @datetime: 2021-6-23 22:20:15
##==================================================
extends Reference

# 工具类
const UtilCode = preload("util/code_util.gd")
const UtilScriptEditor = preload("util/script_editor_util.gd")
const UtilScript = preload("util/script_util.gd")
const UtilParseShortcut = preload("util/parse_shortcut.gd")


# 自定义节点类
const NodeMenuButtonPlus = preload("node/menu_button_plus.gd")


# 工具类变量
var util_code := UtilCode.new()
var util_script_editor := UtilScriptEditor.new()
var util_script := UtilScript.new()
var util_parse_shortcut := UtilParseShortcut.new()


func _init(infc: EditorInterface):
	util_code.set_interface(infc)
	util_script_editor.set_interface(infc)
	util_script.set_interface(infc)
	util_parse_shortcut.set_interface(infc)

