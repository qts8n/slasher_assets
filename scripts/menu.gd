extends Control

# PLAY button_up event changes scene
func _on_play_btn_button_up():
    get_tree().change_scene("res://scenes/main.tscn")
