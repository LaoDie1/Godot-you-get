extends HBoxContainer


onready var directory = $Directory
onready var help_install = $HelpInstall



##==================================================
#   连接信号
##==================================================
func _on_Setting_click_item(item_name: String) -> void:
	match item_name:
		"设置文件下载路径":
			directory.popup_centered_ratio()
			directory.window_title = "文件下载路径"
		"打开下载文件目录":
			OS.shell_open(Global.get_download_path())
		"安装环境":
			help_install.popup_centered_ratio()


func _on_Directory_dir_selected(dir: String) -> void:
	Global.set_download_path(dir)


# 点击Label 内容
func _on_RichTextLabel_meta_clicked(meta) -> void:
	OS.shell_open(meta)
