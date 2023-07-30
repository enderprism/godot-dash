extends TabContainer

enum Tabs {
	BLOCKS = 0,
	HAZARDS = 1,
}

@onready var blocks_icon = preload("res://assets/guiTextures/editorTabIcons/blocks.webp")
@onready var hazards_icon = preload("res://assets/guiTextures/editorTabIcons/hazards.webp")

func _ready() -> void:
	set_tab_icon(Tabs.BLOCKS, blocks_icon)
	set_tab_title(Tabs.BLOCKS, "")
	set_tab_icon(Tabs.HAZARDS, hazards_icon)
	set_tab_title(Tabs.HAZARDS, "")
