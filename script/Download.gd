extends Node

## 之前下载过
signal pre_donwloaded(url)
## 下载中
signal downloaded(url)
## 下载完成
signal download_finished(exit_code, output)
## 所有都完成
signal all_finished


var _downloaded_url = {}	# 已下载链接
var _regex = RegEx.new()

var count = 0
var _thread_list = []
var _thread : Thread = null



##==================================================
#   Set/Get
##==================================================
## 是否是 URL
func is_url(url: String) -> bool:
	url = url.replace(" ", "")
	# 正则
	var pattern = (
		"^((http|https)*://)*" 
		+ "([A-Za-z]+)\\.([A-Za-z]+)(\\.[A-Za-z]+)?"
		+ "/(\\w+?)"
	)
	_regex.compile(pattern)
	# 匹配 URL
	var match_ = _regex.search(url)
	return (
		match_ 
		&& match_.get_string() != ""
	)

##  返回一个线程实例
func get_thread_instance() -> Thread:
	var thread = Thread.new()
	_thread_list.push_back(thread)
	return thread



##==================================================
#   内置方法
##==================================================
func _exit_tree() -> void:
	for thread in _thread_list:
		thread.wait_to_finish()



##==================================================
#   自定义方法
##==================================================
## 开始执行
func start(url_: String):
	if count > 0:
		yield(self, "all_finished")
	
	var list = url_.split(" ")
	count = list.size()
	print("下载链接：", list)
	yield(get_tree().create_timer(0.1), "timeout")
	
	for url in list:
		# 已下载过，则跳过
		if _downloaded_url.has(url):
			emit_signal("pre_donwloaded", url)
			_unref_count()
			continue
		
		if is_url(url):
			_thread = get_thread_instance()
			var err = _thread.start(self, "_thread_func", url)
			print("线程执行" + ("成功" if err == OK else "失败"))
			yield(self, "download_finished")
			_thread = null
		else:
			_unref_count()


##  释放计数
func _unref_count():
	count -= 1
	if count <= 0:
		emit_signal("all_finished")


## 线程方法
func _thread_func(url):
	emit_signal("downloaded", url)
	
	var output = []
	var exit_code = OS.execute(
		"you-get", 
		[
			"-f",		# 强制覆盖同名文件
			"-o", Global.get_download_path(),	# 设置下载路径
			"--no-caption", 	# 不下载字幕文件
			url
		], 
		true, output
	)
	
	if exit_code == OK:
		_downloaded_url[url] = true
	
	prints("[下载完成]", exit_code, "\n\n")
	emit_signal("download_finished", exit_code, output)
	
	_unref_count()



##==================================================
#   连接方法
##==================================================
## 释放线程
func _release_thread():
	# 每隔一点时间释放一次线程
	var thread : Thread
	for idx in range(_thread_list.size()-1, -1, -1):
		thread = _thread_list[idx]
		if not thread.is_active():
			thread.wait_to_finish()
			_thread_list.remove(idx)
