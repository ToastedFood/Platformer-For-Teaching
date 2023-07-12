extends KinematicBody2D;
const SPEED = 150
const GRAVITY = 10
const JUMP_POWER = -200
const FLOOR = Vector2(0, -1)

const DISC = preload("res://disc.tscn")

var velocity = Vector2( )
var on_ground = false
var locked_controls = false
var rebound = false;
var is_dead = false;
func dead():
	is_dead = true
	velocity = Vector2(0, 0)
	$AnimatedSprite.play("dead")
	$Timer.start()
	
func _physics_process(delta):
	if(is_dead == false):
		if Input.is_action_pressed("ui_right") && locked_controls == false:
			if(rebound == true):
				velocity.x = SPEED * 2
			else:
				velocity.x = SPEED
			$AnimatedSprite.play("run")
			$AnimatedSprite.flip_h = false
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1
		elif Input.is_action_pressed("ui_left") && locked_controls == false:
			if(rebound == true):
				velocity.x = -SPEED * 2
			else:	
				velocity.x = -SPEED
			$AnimatedSprite.play("run")
			$AnimatedSprite.flip_h = true
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x *= -1
		else:
			if(locked_controls == false):
				velocity.x = 0
				$AnimatedSprite.play("idle")
		
		if Input.is_action_pressed("ui_up") && locked_controls == false && on_ground == true:
			if on_ground == true:
				velocity.y = JUMP_POWER
				on_ground = false
		elif Input.is_action_just_pressed("ui_up") && on_ground == false && locked_controls == false && (Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left")):
			locked_controls = true
			$AnimatedSprite.play("kick")
			velocity.y += GRAVITY * 20
			if(rebound == false):
				velocity.x = velocity.x * 2
			else: 
				rebound = false;
		if(rebound == false):	
			velocity.y += GRAVITY	
		else:
			velocity.y += GRAVITY/1.5
			
		if Input.is_action_just_pressed("ui_select") && locked_controls == false:
			var disc = DISC.instance()
			disc.set_disc_direction(sign($Position2D.position.x))
			get_parent().add_child(disc);
			disc.position = $Position2D.global_position
			
		if is_on_floor():
			on_ground = true
			if(locked_controls == true):
					rebound = true
					velocity.y = JUMP_POWER
					velocity.x = velocity.x * -1
					$AnimatedSprite.play("jump")
			else:
				rebound = false;
			locked_controls = false
		else:
			on_ground = false
			if(locked_controls == false):
				$AnimatedSprite.play("jump")
		
		if is_on_wall():
			if(locked_controls == true):
					rebound = true
					velocity.y = JUMP_POWER * 2
					velocity.x = velocity.x * -1
					locked_controls = false
					$AnimatedSprite.play("jump")
			else:
				rebound = false;
		
		velocity = move_and_slide(velocity, FLOOR);
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if("Enemy") in get_slide_collision(i).collider.name:
					if(locked_controls == false):
						dead()
					else:
						get_slide_collision(i).collider.dead()
				#if("TileMap") in get_slide_collision(i).collider.name:
					#dead()
	


func _on_Timer_timeout():
	get_tree().change_scene("res://StageOne.tscn") # Replace with function body.
