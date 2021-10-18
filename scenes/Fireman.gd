extends Area2D
signal hit
signal bump_multiplier
signal sfx_finished

export (AudioStreamOGGVorbis) var trophy_sound
export (AudioStreamOGGVorbis) var death_sound
export (AudioStreamOGGVorbis) var start_sound

export var speed = 400

var screen_size


func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity:Vector2 = Vector2.ZERO
	velocity.y -= Input.get_action_strength("player_up")
	velocity.y += Input.get_action_strength("player_down")
	velocity.x -= Input.get_action_strength("player_left")
	velocity.x += Input.get_action_strength("player_right")
	
	if velocity.length() > 1:
		velocity = velocity.normalized()
	velocity *= speed

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	play_sfx(start_sound)

func play_sfx(stream):
	var player:AudioStreamPlayer2D = $SfxPlayer2D
	if (player.stream != stream):
		player.stream = stream
	player.play()

func _on_Fireman_body_entered(_body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	play_sfx(death_sound)

func _on_Fireman_area_shape_entered(_area_id, area, _area_shape, _local_shape):
	if area.is_in_group("trophy"):
		emit_signal("bump_multiplier")
		area.queue_free()
		play_sfx(trophy_sound)


func _on_SfxPlayer2D_finished():
	if $SfxPlayer2D.stream != trophy_sound:
		emit_signal("sfx_finished")
