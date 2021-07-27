extends Reference


var interface : EditorInterface


## 初始化
## @infc 编辑器接口
func set_interface(infc: EditorInterface):
	interface = infc
	
	# 脚本编辑器没有显示时，等待脚本编辑器显示出来
	var script_editor = interface.get_script_editor()
	if !script_editor.visible:
		yield(script_editor, "visibility_changed")
	init_data()



## 初始化数据
func init_data():
	pass
