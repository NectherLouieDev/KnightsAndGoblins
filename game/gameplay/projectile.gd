extends CharacterBody2D

class_name Projectile

enum PROJECTILE_TYPE {ARROW, DYNAMITE}

@export var projectile_type: PROJECTILE_TYPE = PROJECTILE_TYPE.ARROW

const GRAVITY = 300

var original_rotation = 0.0

@onready var screen_size = get_viewport_rect().size
@onready var sprite_2d = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	if projectile_type == PROJECTILE_TYPE.ARROW:
		sprite_2d.rotation = original_rotation + velocity.angle()
	
	if projectile_type == PROJECTILE_TYPE.DYNAMITE:
		sprite_2d.rotation += 10 * delta
	
	move_and_slide()
	
func calculate_arc_velocity(source_position, target_position, arc_height, gravity):
	var velocity = Vector2()
	var displacement = target_position - source_position
	
	if displacement.y > arc_height:
		var time_up = sqrt(-2 * arc_height / float(gravity))
		var time_down = sqrt(2 * (displacement.y - arc_height) / float(gravity))
		
		velocity.y = -sqrt(-2 * gravity * arc_height)
		velocity.x = ((displacement.x) / float(time_up + time_down))
	
	return velocity
	
func launch(target):
	var target_position = target.global_position
	var direction = (target_position - position).normalized()
	#if direction.x < 0: # left
		#$Sprite.rotation_degrees = -135
	#original_rotation = $Sprite.rotation
	sprite_2d.rotation = randf_range(0, 360)
	
	# calculate arc_height based on distance
	var distance = abs(target_position.x - global_position.x)
	var max_height = (distance / screen_size.x) * screen_size.y * 0.4
	
	var height_multiplier = 8
	var arc_height = target_position.y - global_position.y - max_height
	arc_height = min(arc_height, -max_height) * height_multiplier
	
	var _v = calculate_arc_velocity(global_position, target_position, arc_height, GRAVITY)
	_v.x += 10
	velocity = _v
