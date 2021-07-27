extends "res://script/menu/Base.gd"



#(override)
func init_item():
	.init_item()
	add_item("安装环境", get_new_shortcut(KEY_F1, false, false, false))

