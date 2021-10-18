extends AudioStreamPlayer

export (AudioStream) var level_music
export (AudioStream) var menu_music

var next_stream

func _ready():
	print(menu_music)
	print(stream)

func queue_song(song_name):
	print("queue_song()" + song_name)
	stream = null
	if song_name == 'level_music':
		stream = level_music
	elif song_name == 'menu_music':
		stream = menu_music
	else:
		push_error("unknown song name")
	if !stream:
		push_error("null stream")
	queue_stream(stream)

func start_song():
	print("start_song()")
	print(next_stream)
	if next_stream:
		play_stream(next_stream)
	next_stream = null


func queue_stream(new_stream):
	print("queue_stream()" + str(new_stream))
	next_stream = new_stream

func play_stream(new_stream):
	print("play_stream()")
	if !playing or (stream != new_stream):
		if new_stream == level_music:
			volume_db = -3.8
		elif new_stream == menu_music:
			volume_db = -1
		stream = new_stream
		play()


