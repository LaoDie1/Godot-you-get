extends RichTextLabel


func _ready() -> void:
	bbcode_text = """
1. 先去 [color=#ff6394ed][url=https://www.python.org/]Python[/url][/color] 官网下载对应操作系统的 Python3 版本
2. 安装方式，点击以下链接进行搜索：
	* [color=#ff6394ed][url=https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&tn=baidu&wd=Windows%20%E5%AE%89%E8%A3%85%20Python3]Windows 安装 Python3[/url][/color]
	* [color=#ff6394ed][url=https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&tn=baidu&wd=Linux%20%E5%AE%89%E8%A3%85%20Python3]Linux 安装 Python3[/url][/color]
	* [color=#ff6394ed][url=https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&tn=baidu&wd=MacOS%20%E5%AE%89%E8%A3%85%20Python3]MacOS 安装 Python3[/url][/color]
	* [b]Windows 安装时需要勾选“Adding to PATH”，否则 pip 不可用[/b]。需手动配置，可参考：
		- [color=#ff6394ed][url=https://www.lstazl.com/windows%e7%8e%af%e5%a2%83%e4%b8%8b%e4%bd%bf%e7%94%a8python3%e5%91%bd%e4%bb%a4/]windows环境下使用python3命令[/url][/color]
3. 安装完 Python3 后，安装 pip3
	* Linux 上例如 Ubuntu 的安装命令：[code]sudo apt install python3-pip[/code]
	* 如果不是 Linux 系统，可自行百度搜索对应系统安装方法
4. 最后安装 you-get 库
	* 安装命令：[code]pip3 install you-get[/code]
5. 安装完成，即可使用。
"""
	print(Color.cornflower.to_html())
