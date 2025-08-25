class_name RDN_EffectsManager extends CanvasLayer

## Default value ##
const DEFAULT_MIN_VALUE: float = 0.0
const DEFAULT_MAX_VALUE: float = 1.0
const DEFAULT_DURATION: float = 0.5

## Local Variables ##
var effects: Dictionary = {}
var active_tweens: Dictionary = {}

func _ready() -> void:
	get_tree().set_group("effects", "visible", false)
	
	for child in $Effects.get_children():
		effects[child.name] = child

func apply_effect(effect_name: String, opacity_amount: float = DEFAULT_MAX_VALUE) -> void:
	var effect_node: TextureRect = get_effect_node(effect_name)
	if not effect_node:
		return
	
	effect_node.material.set_shader_parameter("opacity_amount", opacity_amount)
	effect_node.visible = true

## Applico un semplice effetto di fade-in basato sull'opacitá della shader e la rendo visibile. ##
func apply_effect_with_animation(effect_name: String, duration: float = DEFAULT_DURATION, start_amount: float = DEFAULT_MIN_VALUE, end_amount: float = DEFAULT_MAX_VALUE) -> void:
	var effect_node: TextureRect = get_effect_node(effect_name)
	if not effect_node:
		return
		
	if active_tweens.has(effect_name):
		active_tweens[effect_name].kill()
	
	var tween = get_tree().create_tween()
	active_tweens[effect_name] = tween
	
	effect_node.visible = true;
	tween.tween_property(effect_node, "material:shader_parameter/opacity_amount", end_amount, duration).from(start_amount)
	tween.finished.connect(func(): active_tweens.erase(effect_name))


func remove_effect(effect_name: String) -> void:
	var effect_node: TextureRect = get_effect_node(effect_name)
	if not effect_node:
		return 
	
	effect_node.visible = false

## Applico un semplice effetto di fade-out basato sull'opacitá della shader e la rendo invisibile. ##
func remove_effect_with_animation(effect_name: String, duration: float = DEFAULT_DURATION):
	var effect_node: TextureRect = get_effect_node(effect_name)
	if not effect_node:
		return 
	
	if active_tweens.has(effect_name):
		active_tweens[effect_name].kill()
	
	var tween = get_tree().create_tween()
	active_tweens[effect_name] = tween
	
	tween.tween_property(effect_node, "material:shader_parameter/opacity_amount", DEFAULT_MIN_VALUE, duration)
	tween.tween_callback(func(): effect_node.visible = false)
	tween.finished.connect(func(): active_tweens.erase(effect_name))


func get_effect_node(effect_name: String) -> TextureRect:
	if effects.has(effect_name):
		return effects[effect_name] as TextureRect

	push_error("Invalid effect name.")
	return null
