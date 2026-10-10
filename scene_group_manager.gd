extends Node
## SceneGroupManager Facade/Autoload。詳細は scene-group-manager#1 を参照。

signal scene_entered(scene_id: String)
signal scene_left(scene_id: String)
signal base_scene_switched(scene_id: String)

const SceneStack = preload("stack/scene_stack.gd")

var _stack: SceneStack

func _ready() -> void:
	_stack = SceneStack.new()
	_stack.scene_entered.connect(func(id: String): scene_entered.emit(id))
	_stack.scene_left.connect(func(id: String): scene_left.emit(id))
	_stack.base_scene_switched.connect(func(id: String): base_scene_switched.emit(id))

func set_base_container(node: Node) -> void:
	_stack.set_base_container(node)

func set_overlay_container(node: Node) -> void:
	_stack.set_overlay_container(node)

func enter_scene(scene_path: String) -> void:
	_stack.enter_scene(scene_path, load(scene_path))

func leave_scene() -> bool:
	return _stack.leave_scene()

func switch_base_scene(scene_path: String) -> void:
	_stack.switch_base_scene(scene_path, load(scene_path))

func get_current_scene_id() -> String:
	return _stack.get_current_scene_id()

func get_scene_stack() -> Array[String]:
	return _stack.get_scene_stack()
