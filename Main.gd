extends Control


onready var download = $Download
onready var url_box = find_node("UrlBox")
onready var log_box = find_node("Log")


var _thread_list = []
var _regex = RegEx.new()



##==================================================
#   自定义方法
##==================================================
## 下载
func _download() -> void:
	var url = url_box.text
	
	# url 为空，则 return
	if url.replace(" ", "") == "":
		print_log("提示", "没有网址，输入网址后进行下载", Color.red)
		return
	
	if not download.is_url(url):
		print_log("ERROR", "不是 URL 网址", Color.red)
		return
	
	download.start(url)
	
#	# 测试
#	_on_Download_downloaded(url)
#	_on_Download_download_finished(0, url)


##  输出日志
func print_log(
	type: String, 
	text, 
	color:= Color.white
) -> void:
	var color_ = "[color=#" + color.to_html(false) + "]"
	log_box.bbcode_text += "{color}{type}[/color]: {text}\n".format({
		color = color_,
		type = type,
		text = str(text),
	})


##  输出分隔线
func print_separator():
	log_box.bbcode_text +="\n"
	log_box.bbcode_text += "-".repeat(50)
	log_box.bbcode_text +="\n\n"



##==================================================
#   连接信号
##==================================================
# 文本框获得焦点
func _on_UrlBox_focus_entered() -> void:
	# 剪切板
	var cb = OS.clipboard
	if download.is_url(cb):
		url_box.text = cb
		yield(get_tree().create_timer(0.1), "timeout")
		url_box.select(cb.length())

# 下载完成
func _on_Download_download_finished(exit_code, output) -> void:
	print_separator()
	print_log("code", exit_code)
	print_log("output", output)
	print_separator()
	if exit_code == OK:
		print_log("[下载状态]", "下载成功", Color.green)
	else:
		print_log("[下载状态]", "下载失败: %d" % exit_code, Color.red)
	log_box.bbcode_text += "\n\n"


# 开始下载链接
func _on_Download_downloaded(url) -> void:
	print("[开始下载]")
	print_log("[开始下载]", url, Color.darkturquoise)
	print_log("[下载到]", Global.get_download_path())

# 清空日志
func _on_Clear_pressed() -> void:
	log_box.bbcode_text = ""

# 下载过
func _on_Download_pre_donwloaded(url) -> void:
	print_log("[已下载过]", url, Color.yellow)


