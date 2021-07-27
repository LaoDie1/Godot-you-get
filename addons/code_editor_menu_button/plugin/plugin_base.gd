##==================================================
#	Plugin Base
##==================================================
# 基类插件
##==================================================
# @path: res://addons/code_editor_menu_button/plugin/plugin_base.gd
# @datetime: 2021-7-4 22:22:17
##==================================================
extends Reference

const ClassManager_ = preload("../class_manager.gd")

const NodeMenuButtonPlus = ClassManager_.NodeMenuButtonPlus



##==================================================
#   自定义方法
##==================================================
##  初始化菜单按钮 
## @menu_button 
func init_menu_button(menu_button: NodeMenuButtonPlus):
	pass
	
	# 例：

#	# 添加菜单选项
#	var idx = 0	# 添加菜单后返回添加的菜单的 idx 值
#
#	# 菜单调用的方法
#	idx = menu_button.add_popup_item("菜单名", self, "调用的方法")
#
#	# 设置菜单快捷键
#	menu_button.set_item_shortcut(idx, parse_shortcut.parse_shortcut("Ctrl + /"))
