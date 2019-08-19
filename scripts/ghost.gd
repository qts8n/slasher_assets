extends Sprite

func _ready() -> void:
    var tween := $alpha as Tween
    var _interpolated = tween.interpolate_property(self, "modulate",
            Color(1, 1, 1, 0.5),  # translucent white
            Color(1, 1, 1, 0),  # transparent
            0.6, Tween.TRANS_SINE, Tween.EASE_OUT)
    var _started = tween.start()


func _on_alpha_tween_completed(_object: Object, _key: NodePath) -> void:
    queue_free()
