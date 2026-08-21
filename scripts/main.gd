extends Node2D

const TILE_SIZE := Vector2i(64, 32)
const MAP_SIZE := Vector2i(15, 11)
const STARTING_GOLD := 150
const STARTING_LIVES := 10
const TOWER_COST := 50
const TOWER_RANGE := 140.0
const TOWER_DAMAGE := 20
const TOWER_COOLDOWN := 0.8
const ENEMY_HP := 60
const ENEMY_SPEED := 45.0
const ENEMY_REWARD := 10
const WAVES := [3, 5, 7]
const PATH_CELLS: Array[Vector2i] = [
	Vector2i(0, 5), Vector2i(1, 5), Vector2i(2, 5), Vector2i(3, 5),
	Vector2i(4, 5), Vector2i(5, 5), Vector2i(6, 5), Vector2i(7, 5),
	Vector2i(8, 5), Vector2i(9, 5), Vector2i(10, 5), Vector2i(11, 5),
	Vector2i(12, 5), Vector2i(13, 5), Vector2i(14, 5)
]

@onready var ground: TileMapLayer = $Ground
@onready var roads: TileMapLayer = $Roads
@onready var hover: Line2D = $Hover
@onready var route: Path2D = $EnemyPath
@onready var actors: Node2D = $Actors
@onready var projectiles_root: Node2D = $Projectiles
@onready var gold_label: Label = $HUD/Panel/Margin/Row/Gold
@onready var lives_label: Label = $HUD/Panel/Margin/Row/Lives
@onready var wave_label: Label = $HUD/Panel/Margin/Row/Wave
@onready var start_button: Button = $HUD/Panel/Margin/Row/StartWave
@onready var result_panel: PanelContainer = $HUD/Result
@onready var result_label: Label = $HUD/Result/Margin/Column/Result

var gold := STARTING_GOLD
var lives := STARTING_LIVES
var wave := 0
var hover_cell := Vector2i(-99, -99)
var occupied: Dictionary = {}
var enemies: Array[Dictionary] = []
var towers: Array[Dictionary] = []
var projectiles: Array[Dictionary] = []
var spawn_left := 0
var spawn_clock := 0.0
var wave_active := false
var game_over := false
var guardian_frames: SpriteFrames
var slime_frames: SpriteFrames


func _ready() -> void:
	_run_self_check()
	_build_grid()
	_build_route()
	guardian_frames = _make_frames(load("res://art/characters/guardian/guardian.png"), true)
	slime_frames = _make_frames(load("res://art/characters/slime/slime.png"), false)
	start_button.pressed.connect(_start_wave)
	$HUD/Result/Margin/Column/Restart.pressed.connect(_restart)
	_update_hud()
	print("AEGIS_MVP_READY")


func _run_self_check() -> void:
	assert(WAVES.size() == 3)
	assert(PATH_CELLS.front() == Vector2i(0, 5))
	assert(PATH_CELLS.back() == Vector2i(14, 5))
	assert(TOWER_DAMAGE * 3 == ENEMY_HP)


func _build_grid() -> void:
	var tile_set := TileSet.new()
	tile_set.tile_shape = TileSet.TILE_SHAPE_ISOMETRIC
	tile_set.tile_layout = TileSet.TILE_LAYOUT_DIAMOND_RIGHT
	tile_set.tile_offset_axis = TileSet.TILE_OFFSET_AXIS_HORIZONTAL
	tile_set.tile_size = TILE_SIZE
	ground.tile_set = tile_set
	roads.tile_set = tile_set
	var texture: Texture2D = load("res://art/tiles/grass.png")
	for y in MAP_SIZE.y:
		for x in MAP_SIZE.x:
			var cell := Vector2i(x, y)
			var sprite := Sprite2D.new()
			sprite.texture = texture
			sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			sprite.position = ground.map_to_local(cell) + Vector2(0, -8)
			sprite.modulate = Color("d8f0a4") if (x + y) % 2 == 0 else Color.WHITE
			ground.add_child(sprite)
	for cell in PATH_CELLS:
		var road := Polygon2D.new()
		road.position = roads.map_to_local(cell)
		road.polygon = PackedVector2Array([Vector2(0, -12), Vector2(30, 3), Vector2(0, 18), Vector2(-30, 3)])
		road.color = Color("c99a5b")
		roads.add_child(road)


func _build_route() -> void:
	var curve := Curve2D.new()
	for cell in PATH_CELLS:
		curve.add_point(ground.to_global(ground.map_to_local(cell)))
	route.curve = curve


func _make_frames(texture: Texture2D, guardian: bool) -> SpriteFrames:
	var frames := SpriteFrames.new()
	frames.remove_animation("default")
	var names := ["idle_dl", "idle_dr", "idle_ul", "idle_ur"]
	if guardian:
		names.append_array(["attack_dl", "attack_dr", "attack_ul", "attack_ur"])
	else:
		names.append_array(["walk_dl", "walk_dr", "walk_ul", "walk_ur", "death"])
	for name in names:
		frames.add_animation(name)
		frames.set_animation_speed(name, 6.0)
		frames.set_animation_loop(name, name != "death")
		var direction := 0
		if name.ends_with("dr"): direction = 3
		elif name.ends_with("ul"): direction = 1
		elif name.ends_with("ur"): direction = 2
		for step in (2 if guardian else 4):
			var atlas := AtlasTexture.new()
			atlas.atlas = texture
			atlas.region = Rect2(direction * 48 if guardian else step * 48, 0, 48, 48)
			frames.add_frame(name, atlas)
	return frames


func _unhandled_input(event: InputEvent) -> void:
	if game_over:
		return
	if event is InputEventMouseMotion:
		hover_cell = ground.local_to_map(ground.to_local(get_global_mouse_position()))
		_update_hover()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_place_tower(ground.local_to_map(ground.to_local(get_global_mouse_position())))


func _place_tower(cell: Vector2i) -> void:
	if not _is_buildable(cell) or gold < TOWER_COST:
		return
	gold -= TOWER_COST
	var root := Node2D.new()
	root.position = ground.to_global(ground.map_to_local(cell)) + Vector2(0, -22)
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = guardian_frames
	sprite.animation = "idle_dl"
	sprite.play()
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	root.add_child(sprite)
	actors.add_child(root)
	occupied[cell] = root
	towers.append({"node": root, "sprite": sprite, "cooldown": 0.0})
	_update_hud()
	_update_hover()


func _is_buildable(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < MAP_SIZE.x and cell.y < MAP_SIZE.y and cell not in PATH_CELLS and not occupied.has(cell)


func _start_wave() -> void:
	if wave_active or wave >= WAVES.size() or game_over:
		return
	spawn_left = WAVES[wave]
	spawn_clock = 0.0
	wave_active = true
	start_button.disabled = true
	_update_hud()


func _process(delta: float) -> void:
	if game_over:
		return
	_spawn_wave(delta)
	_move_enemies(delta)
	_update_towers(delta)
	_update_projectiles(delta)
	_check_wave_complete()


func _spawn_wave(delta: float) -> void:
	if not wave_active or spawn_left <= 0:
		return
	spawn_clock -= delta
	if spawn_clock <= 0.0:
		_spawn_enemy()
		spawn_left -= 1
		spawn_clock = 0.85


func _spawn_enemy() -> void:
	var follow := PathFollow2D.new()
	follow.loop = false
	follow.rotates = false
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = slime_frames
	sprite.animation = "walk_dr"
	sprite.play()
	sprite.position.y = -20
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	follow.add_child(sprite)
	route.add_child(follow)
	enemies.append({"node": follow, "sprite": sprite, "hp": ENEMY_HP, "progress": 0.0, "alive": true})


func _move_enemies(delta: float) -> void:
	for enemy in enemies.duplicate():
		if not enemy.alive:
			continue
		enemy.progress += ENEMY_SPEED * delta
		enemy.node.progress = enemy.progress
		if enemy.progress >= route.curve.get_baked_length() - 1.0:
			enemy.alive = false
			enemy.node.queue_free()
			enemies.erase(enemy)
			lives -= 1
			_update_hud()
			if lives <= 0:
				_finish(false)


func _update_towers(delta: float) -> void:
	for tower in towers:
		tower.cooldown = maxf(0.0, tower.cooldown - delta)
		var target := _first_target(tower.node.global_position)
		if target.is_empty():
			tower.sprite.animation = "idle_dl"
			continue
		var right: bool = target.node.global_position.x > tower.node.global_position.x
		tower.sprite.animation = "attack_dr" if right else "attack_dl"
		if tower.cooldown <= 0.0:
			tower.cooldown = TOWER_COOLDOWN
			_fire(tower.node.global_position + Vector2(0, -12), target)


func _first_target(origin: Vector2) -> Dictionary:
	var best: Dictionary = {}
	for enemy in enemies:
		if enemy.alive and origin.distance_to(enemy.node.global_position) <= TOWER_RANGE:
			if best.is_empty() or enemy.progress > best.progress:
				best = enemy
	return best


func _fire(origin: Vector2, target: Dictionary) -> void:
	var shot := Polygon2D.new()
	shot.polygon = PackedVector2Array([Vector2(-5, 0), Vector2(0, -4), Vector2(7, 0), Vector2(0, 4)])
	shot.color = Color("78e8ff")
	shot.global_position = origin
	projectiles_root.add_child(shot)
	projectiles.append({"node": shot, "target": target})


func _update_projectiles(delta: float) -> void:
	for shot in projectiles.duplicate():
		var target: Dictionary = shot.target
		if not target.alive or not is_instance_valid(target.node):
			shot.node.queue_free()
			projectiles.erase(shot)
			continue
		var destination: Vector2 = target.node.global_position + Vector2(0, -18)
		shot.node.global_position = shot.node.global_position.move_toward(destination, 420.0 * delta)
		if shot.node.global_position.distance_to(destination) < 5.0:
			_damage(target, TOWER_DAMAGE)
			shot.node.queue_free()
			projectiles.erase(shot)


func _damage(enemy: Dictionary, amount: int) -> void:
	if not enemy.alive:
		return
	enemy.hp -= amount
	if enemy.hp <= 0:
		enemy.alive = false
		enemy.node.queue_free()
		enemies.erase(enemy)
		gold += ENEMY_REWARD
		_update_hud()


func _check_wave_complete() -> void:
	if wave_active and spawn_left == 0 and enemies.is_empty():
		wave_active = false
		wave += 1
		if wave >= WAVES.size():
			_finish(true)
		else:
			start_button.disabled = false
		_update_hud()


func _finish(victory: bool) -> void:
	game_over = true
	start_button.disabled = true
	result_label.text = "SHRINE DEFENDED" if victory else "THE SHRINE HAS FALLEN"
	result_panel.visible = true


func _restart() -> void:
	get_tree().reload_current_scene()


func _update_hud() -> void:
	gold_label.text = "Gold  %d" % gold
	lives_label.text = "Shrine  %d" % lives
	wave_label.text = "Wave  %d / %d" % [min(wave + 1, WAVES.size()), WAVES.size()]
	start_button.text = "Start Wave %d" % min(wave + 1, WAVES.size())


func _update_hover() -> void:
	if hover_cell.x >= 0 and hover_cell.y >= 0 and hover_cell.x < MAP_SIZE.x and hover_cell.y < MAP_SIZE.y:
		var center := ground.to_global(ground.map_to_local(hover_cell))
		hover.points = PackedVector2Array([center + Vector2(0, -16), center + Vector2(32, 0), center + Vector2(0, 16), center + Vector2(-32, 0), center + Vector2(0, -16)])
		hover.default_color = Color("7cf29a", 0.8) if _is_buildable(hover_cell) and gold >= TOWER_COST else Color("ff637d", 0.8)
		hover.visible = true
	else:
		hover.visible = false
