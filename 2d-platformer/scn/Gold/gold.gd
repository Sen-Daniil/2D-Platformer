extends CanvasLayer

@onready var gold_text = $GoldText

func _process(_delta):
	gold_text.text = str(Global.gold)
