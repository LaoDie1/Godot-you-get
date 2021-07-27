extends Node


const DataPath = ".godot_you_get_global_data"


var g_data = {
	download_path = "",		# 下载路径
}

var directory = Directory.new()
var file = File.new()



##==================================================
#   Set/Get
##==================================================
##  返回下载路径
func get_download_path():
	if (
		g_data.download_path != "" 
		&& directory.dir_exists(g_data.download_path)
	):
		return g_data.download_path
	else:
		return OS.get_user_data_dir()

##  设置文件下载路径
func set_download_path(value: String) -> void:
	g_data.download_path = value
	print("设置文件路径：", value)



##==================================================
#   内置方法
##==================================================
func _enter_tree() -> void:
	load_data()


func _exit_tree() -> void:
	save_data()



##==================================================
#   自定义方法
##==================================================
func load_data():
	print("[开始加载数据]")
	
	if file.file_exists(DataPath):
		if file.open(DataPath, File.READ) == OK:
			var data = file.get_as_text()
			var j_result = JSON.parse(data)
			if j_result.error == OK:
				g_data = j_result.result
			print("[数据读取成功]")
		else:
			print("[数据读取失败]")
	
	g_data.download_path = get_download_path()
	
	print("[加载数据完成]")


##  保存数据
func save_data():
	print("[开始写入数据]")
	var temp_data = to_json(g_data)
	if file.open(DataPath, File.WRITE) == OK:
		file.store_string(temp_data)
		file.close()
		print("[数据写入完成]")
		print(JSON.print(g_data, "\t"))
		
	else:
		print("[数据写入失败]")
