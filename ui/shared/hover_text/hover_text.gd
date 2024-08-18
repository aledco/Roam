class_name HoverText extends PanelContainer

const TEXT_LABEL = preload("res://ui/shared/text_label/text_label_small/text_label_small.tscn")

@onready var container: Container  = $MarginContainer/VBoxContainer

func set_hover_target(button: Button):
	button.mouse_entered.connect(show)
	button.mouse_exited.connect(hide)
	
func add_hover_text(text: String, color: Color = Color.WHITE) -> RichTextLabel:
	if not text:
		return null
	
	var label = TEXT_LABEL.instantiate() as RichTextLabel
	container.add_child(label)
	label.clear()
	label.push_color(color)
	label.add_text(text)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label
