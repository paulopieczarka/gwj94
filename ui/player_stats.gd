extends Control

@onready var player_weapon_label: Label = $VBoxContainer/PlayerWeapon/Label

var player: EntityPlayer

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	assert(player != null, "[PlayerStats] Missing player")

	assert(player_weapon_label != null, "[PlayerStats] Missing player_weapon_label")

func _process(delta: float) -> void:
	player_weapon_label.text = "Weapon: " + player.combat.weapon.title
