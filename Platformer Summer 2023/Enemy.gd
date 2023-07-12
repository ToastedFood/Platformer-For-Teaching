extends KinematicBody2D

const SPEED = 100
const FLOOR = Vector2(0, -1)
const GRAVITY = 10

export var on_ground : bool =  true
var direction = -1
var velocity = Vector2()
var is_dead = false
var collision_disabled = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func dead():
	is_dead = true
	velocity.x = 0
	$Timer.start()
	$AnimatedSprite.play("dead")
	if(is_on_floor() == true):
		velocity = Vector2(0, 0)
		$CollisionShape2D.set_deferred("disabled", true)
		collision_disabled = true
	
func _physics_process(delta):
	if(is_dead == false):
		velocity.x = SPEED * direction
		if(direction == 1):
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("walk")
		
		move_and_slide(velocity, FLOOR)
		
		if(is_on_wall()):
			direction = direction * -1
			$RayCast2D.position.x *= -1
			
		if($RayCast2D.is_colliding() == false && on_ground == true):
			direction = direction * -1
			$RayCast2D.position.x *= -1
		if get_slide_count() > 0:
			for l in range(get_slide_count()):
				if "Player" in get_slide_collision(l).collider.name:
					get_slide_collision(l).collider.dead()
	else:
		if(collision_disabled == false):
			velocity.y += GRAVITY
			dead()
		move_and_slide(velocity, FLOOR)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	queue_free()
