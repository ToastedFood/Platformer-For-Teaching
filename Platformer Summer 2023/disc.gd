extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SPEED = 500
var velocity = Vector2()
var direction = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func set_disc_direction(c_direction):
	direction = c_direction
	if(c_direction == -1):
		$AnimatedSprite.flip_h = true	
		
func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("disc")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # Replace with function body.


func _on_disc_body_entered(body):
	if "Enemy" in body.name:
		body.dead()
	queue_free() # Replace with function body.
