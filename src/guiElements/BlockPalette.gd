extends TabContainer

enum Tabs {
	BLOCKS = 0,
}

@onready var block_icon = preload("res://assets/guiTextures/editorTabIcons/blocks.webp")

func _ready() -> void:
	set_tab_button_icon(Tabs.BLOCKS, block_icon)
	set_tab_title(Tabs.BLOCKS, "")
