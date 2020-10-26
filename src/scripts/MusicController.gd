extends Node

func _ready():
	var music_file = "res://assets/audio/music.ogg"
	var music_player = AudioStreamPlayer.new()
	if File.new().file_exists(music_file):
		var music = load(music_file)
		music_player.stream = music
		music_player.play()

	var music_bus_id = AudioServer.get_bus_count()
	AudioServer.add_bus()
	AudioServer.set_bus_name(music_bus_id,"background_music")
	# connects music to master bus
	AudioServer.set_bus_send(music_bus_id,"Master")

	add_child(music_player)
	music_player.bus = "background_music"
