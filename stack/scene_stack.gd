extends RefCounted
## ベース+オーバーレイを表す統一スタック管理。詳細は scene-group-manager#1 を参照。

signal scene_entered(scene_id: String)
signal scene_left(scene_id: String)
signal base_scene_switched(scene_id: String)

class _Entry:
	var id: String
	var node: Node

var _entries: Array[_Entry] = []
var _base_container: Node
var _overlay_container: Node

func set_base_container(node: Node) -> void:
	_base_container = node

func set_overlay_container(node: Node) -> void:
	_overlay_container = node

func enter_scene(id: String, packed_scene: PackedScene) -> void:
	var node := packed_scene.instantiate()
	var container := _base_container if _entries.is_empty() else _overlay_container
	container.add_child(node)
	var entry := _Entry.new()
	entry.id = id
	entry.node = node
	_entries.append(entry)
	scene_entered.emit(id)

func leave_scene() -> bool:
	if _entries.size() <= 1:
		return false
	var entry: _Entry = _entries.pop_back()
	entry.node.queue_free()
	scene_left.emit(entry.id)
	return true

func switch_base_scene(id: String, packed_scene: PackedScene) -> void:
	for entry in _entries:
		entry.node.queue_free()
	_entries.clear()
	var node := packed_scene.instantiate()
	_base_container.add_child(node)
	var entry := _Entry.new()
	entry.id = id
	entry.node = node
	_entries.append(entry)
	base_scene_switched.emit(id)

func get_current_scene_id() -> String:
	return _entries.back().id if not _entries.is_empty() else ""

func get_scene_stack() -> Array[String]:
	var ids: Array[String] = []
	for entry in _entries:
		ids.append(entry.id)
	return ids
