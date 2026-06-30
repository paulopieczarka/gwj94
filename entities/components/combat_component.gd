extends Area2D

class_name CombatComponent

@export var weapon: ItemWeapon

@onready var entity: Entity = owner

signal hit(target: Entity, damage: int)

func attack() -> void:
	for body in get_overlapping_bodies():
		if body == entity:
			continue

		if body is Entity:
			var health := body.get_node_or_null("HealthComponent") as HealthComponent
			print(entity, health)
			if health != null:
				health.damage(entity, weapon.damage)
			
			hit.emit(body, weapon.damage)
