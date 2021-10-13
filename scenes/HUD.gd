extends CanvasLayer

signal start_game

export var title_message = "\nSuper Hero Guys\nOne"
export var game_over_message = "\nFailed!"
export var ready_message = "Lets Go!!"

func _ready():
	pass

func show_ready_message():
	show_message(ready_message)

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message(game_over_message)
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")

	$Message.text = title_message
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func update_multiplier(multiplier):
	$MultiplierLabel.text = "x" + str(multiplier)

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()
