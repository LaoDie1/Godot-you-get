extends "../plugin_base.gd"


const AddComments = preload('add_comments_.gd')


var class_manager : ClassManager_
var add_comments : AddComments
var popup: PopupMenu
var current_menu_button: NodeMenuButtonPlus
var parse_shortcut : ClassManager_.UtilParseShortcut



##==================================================
#   内置方法
##==================================================
func _init(infc: EditorInterface):
	class_manager = ClassManager_.new(infc)
	parse_shortcut = class_manager.util_parse_shortcut
	add_comments = AddComments.new(infc)


##==================================================
#   自定义方法
##==================================================
func init_menu_button(menu_button: NodeMenuButtonPlus):
	current_menu_button = menu_button
	
	# 添加菜单选项
	var idx = 0
	
	# 脚本信息
	idx = menu_button.add_popup_item("脚本文件注释", self, "add_script_file_comment")
	
	# 分隔符
	idx = menu_button.add_popup_item("分隔注释", self, "add_separator_comments")
	menu_button.set_item_shortcut(idx, parse_shortcut.parse_shortcut("Ctrl + /"))
	
	# 方法注释
	idx = menu_button.add_popup_item("方法注释", self, "add_method_comments")
	menu_button.set_item_shortcut(idx, parse_shortcut.parse_shortcut("Ctrl + Shift + /"))
	
	# 代码块分类
	idx = menu_button.add_popup_item("代码块分类注释", self, "add_classify_comments")
	menu_button.set_item_shortcut(idx, parse_shortcut.parse_shortcut("Ctrl + Shift + C"))


##==================================================
#   功能方法
##==================================================
## 添加分隔注释
func add_separator_comments():
	var text_edit = class_manager.util_script_editor.get_current_code_textedit()
	if text_edit:
		var comments = add_comments.get_separator_comments()
		text_edit.insert_text_at_cursor(comments)


## 添加代码块分类注释
func add_classify_comments():
	var text_edit = class_manager.util_script_editor.get_current_code_textedit()
	if text_edit:
		var comments = add_comments.get_classify_comments()
		text_edit.insert_text_at_cursor(comments)
		text_edit.cursor_set_line(text_edit.cursor_get_line() - 1)


## 添加方法注释
## @comments_method 调用的注释方法
func add_method_comments():
	var text_edit = class_manager.util_script_editor.get_current_code_textedit()
	if text_edit:
		var comments = add_comments.get_cursor_next_method_comments()
		text_edit.insert_text_at_cursor(comments)


## 脚本文件信息注释
func add_script_file_comment():
	var comments = add_comments.get_script_info_comments()
	var text_edit = class_manager.util_script_editor.get_current_code_textedit()
	if text_edit:
		text_edit.select(0, 0, 0, 0)
		text_edit.cursor_set_column(0)
		text_edit.cursor_set_line(0)
		text_edit.insert_text_at_cursor(comments)
		text_edit.cursor_set_line(3)
		text_edit.cursor_set_column(1000)

