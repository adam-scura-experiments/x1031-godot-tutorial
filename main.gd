extends Node
class_name MainScene


@export var mob_scene: PackedScene
@onready var score_timer: Timer = $ScoreTimer
@onready var mob_timer: Timer = $MobTimer
@onready var start_timer: Timer = $StartTimer
@onready var start_position: Marker2D = $StartPosition
@onready var hud: HUD = $HUD
@onready var player: Player = $Player
@onready var music: AudioStreamPlayer = $Music
@onready var death_sound: AudioStreamPlayer = $DeathSound
var score: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_player_hit() -> void:
	game_over()


func game_over() -> void:
	score_timer.stop()
	mob_timer.stop()
	hud.show_game_over()
	music.stop()
	death_sound.play()


func new_game() -> void:
	score = 0
	hud.update_score(score)
	hud.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	player.start(start_position.position)
	start_timer.start()
	music.play()


func _on_score_timer_timeout() -> void:
	score += 1
	hud.update_score(score)


func _on_start_timer_timeout() -> void:
	mob_timer.start()
	score_timer.start()


func _on_mob_timer_timeout() -> void:
	var mob: Mob = mob_scene.instantiate()
	
	var mob_spawn_location: PathFollow2D = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	var direction := mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity := Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
