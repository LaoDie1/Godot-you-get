extends MenuButton


signal click_item(item_name)


onready var popup = get_popup()


var _count = 0
var _item_list = []
var _shortcut_list = []



##==================================================
#   Set/Get
##==================================================
func get_new_shortcut(key: int, control: bool, alt: bool, shift: bool) -> ShortCut:
	var s = ShortCut.new()
	var i = InputEventKey.new()
	i.control = control
	i.alt = alt
	i.shift = shift
	i.scancode = key
	s.shortcut = i
	return s



##==================================================
#   内置方法
##==================================================
func _ready() -> void:
	init_item()
	__init_item()
	popup.connect("index_pressed", self, "_on_item_pressed")



##==================================================
#   自定义方法
##==================================================
##  初始化 Item
func init_item():
	pass

##  添加 Item
## @item_name  item名称
func add_item(
	item_name: String, 
	shortcut_: ShortCut = null
):
	_count += 1
	_item_list.push_back(item_name)
	_shortcut_list.push_back(shortcut_)


##  添加分隔符
func add_separator():
	_item_list.push_back("---")


func __init_item():
	var item := ""
	for idx in _count:
		item = _item_list[idx]
		if item != "---":
			popup.add_item(item)
			if _shortcut_list[idx]:
				popup.set_item_shortcut(idx, _shortcut_list[idx])
		else:
			popup.add_separator("")
	



##==================================================
#   连接信号
##==================================================
##  点击 Item
func _on_item_pressed(index: int) -> void:
	emit_signal("click_item", popup.get_item_text(index))

