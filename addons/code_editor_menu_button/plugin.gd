##==================================================
#	Plugin
##==================================================
# 代码编辑器菜单按钮插件
##==================================================
# @path: res://addons/code_editor_menu_button/plugin.gd
# @datetime: 2021-6-23 22:26:11
##==================================================
tool
extends EditorPlugin


const ClassManager = preload("class_manager.gd")


# 插件类
const AddComments = preload("plugin/comments/plugin.gd")
const OverrideFunc = preload("plugin/override/plugin.gd")


var class_manager = ClassManager.new(get_editor_interface())
var menu_button = ClassManager.NodeMenuButtonPlus.new("Source")

# 插件
var add_comments = AddComments.new(get_editor_interface())
var override_func = OverrideFunc.new(get_editor_interface())



##==================================================
#   内置方法
##==================================================
func _enter_tree():
	init_menu_button()


func _exit_tree():
	if menu_button:
		menu_button.queue_free()



##==================================================
#   自定义方法
##==================================================
## 初始化菜单按钮
func init_menu_button():
	# 添加菜单按钮到编辑器当中
	class_manager.util_script_editor.add_menu_button(menu_button)
	
	# 初始化 MenuButton 按钮
	add_comments.init_menu_button(menu_button)
	
	menu_button.add_separator()
	override_func.init_menu_button(menu_button)
	
	# 添加关闭插件菜单项
	menu_button.add_separator()
	menu_button.add_popup_item("关闭插件", self, "close_plugin")


##  关闭插件
func close_plugin():
	# 返回当前脚本所在文件夹，这个文件夹名就是插件名
	var plugin_name = get_current_plugin_name()
	# 插件名与目录名相同
	get_editor_interface().set_plugin_enabled(plugin_name, false)


##  重新加载插件
func reload_plugin():
	# 返回当前脚本所在文件夹，这个文件夹名就是插件名
	var plugin_name = get_current_plugin_name()
	get_editor_interface().set_plugin_enabled(plugin_name, false)

##  返回插件名
func get_current_plugin_name():
	return class_manager.util_script.get_script_dir_name(self.get_script())

