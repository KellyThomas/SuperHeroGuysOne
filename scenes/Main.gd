extends Node

export (AudioStreamOGGVorbis) var level_music
export (AudioStreamMP3) var menu_music
export (PackedScene) var Mob
export (PackedScene) var Trophy

var score
var multiplier
var screen_size
var next_song

func _ready():
	randomize()
	screen_size = get_tree().get_root().get_visible_rect().size
	play_music(menu_music)


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$TrophyTimer.stop()
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("trophy", "queue_free")
	$HUD.show_game_over()
	queue_next_song(menu_music)

func new_game():
	score = 0
	multiplier = 1
	$Fireman.start($StartPosition.position)
	$StartTimer.start()
	$ScoreTimer.wait_time = 1
	$TrophyTimer.wait_time = 1
	$HUD.update_score(score)
	$HUD.update_multiplier(multiplier)
	$HUD.show_ready_message()
	queue_next_song(level_music)

func queue_next_song(stream):
	next_song = stream

func play_music(stream):
	var player:AudioStreamPlayer = $MusicPlayer
	if (player.stream != stream) or !player.playing:
		if stream == level_music:
			player.volume_db = -3.8
		elif stream == menu_music:
			player.volume_db = -1
		player.stream = stream
		player.play()

func start_song():
	if next_song:
		play_music(next_song)
	next_song = null

func is_player_close(candidate_position, threshold):
	var distance_squared = (candidate_position - $Fireman.position).length_squared()
	return distance_squared < threshold

func _on_MobTimer_timeout():
	var mobSpawn:PathFollow2D = $MobPath/MobSpawnLocation
	# Choose a random location on Path2D.
	mobSpawn.offset = randi()
	while is_player_close(mobSpawn.position, 90000):
		mobSpawn.offset = randi()

	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = mobSpawn.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = mobSpawn.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)

func bump_multiplier():
	multiplier += 1
	$HUD.update_multiplier(multiplier)
	$TrophyTimer.wait_time = multiplier
	$TrophyTimer.start()
	$ScoreTimer.wait_time = 1 / float(multiplier)

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$TrophyTimer.start()

func _on_TrophyTimer_timeout():
	var trophy = Trophy.instance()
	var pos = Vector2(50 +(randf() * (screen_size.x-100)),50+(randf() * (screen_size.y-100)))
	while is_player_close(pos, 40000):
		pos = Vector2(50 +(randf() * (screen_size.x-100)),50+(randf() * (screen_size.y-100)))
	trophy.position = pos
	add_child(trophy)

func _on_Fireman_sfx_finished():
	start_song()
