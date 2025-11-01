extends Node2D

var amsynth: Lv2Instance


func _ready():
	Lv2Server.lv2_ready.connect(_on_lv2_ready)


func _update_volume(value):
	amsynth.send_input_control_channel(14, value)


func _update_lfo_freq(value):
	amsynth.send_input_control_channel(15, value)


func _update_freq_mod_amount(value):
	amsynth.send_input_control_channel(19, value)


func _on_lv2_ready(_name):
	amsynth = Lv2Server.get_instance(_name)

	_update_volume(1)
	_update_freq_mod_amount(1)

	amsynth.note_on(0, 0, 64, 64)

	var tween = get_tree().create_tween()
	tween.parallel().tween_method(_update_volume, 1.0, 0.0, 4.0)
	tween.parallel().tween_method(_update_lfo_freq, 0.0, 7.0, 4.0)

	await get_tree().create_timer(4.0).timeout

	amsynth.note_off(0, 0, 64)

	await get_tree().create_timer(1.0).timeout
	_update_volume(1)
	_update_lfo_freq(0)

	amsynth.note_on(0, 0, 60, 64)

	await get_tree().create_timer(0.2).timeout

	amsynth.note_on(0, 0, 64, 64)

	await get_tree().create_timer(0.2).timeout

	amsynth.note_on(0, 0, 67, 64)

	await get_tree().create_timer(2.0).timeout

	amsynth.note_off(0, 0, 60)
	amsynth.note_off(0, 0, 64)
	amsynth.note_off(0, 0, 67)
