extends CharacterBody2D

# variables
var health : int = 100
@export var walkSpeed = 400
@export var sprintSpeed = 800
var speed = walkSpeed
var isSprinting := false
var score := 0
var time := 300.0	# 5 minutes
var equipped := "NONE"


# node references
@onready var sus = $SusBox
@onready var susBar : ProgressBar = get_node("%SuspicionBar")
@onready var equipIcon : TextureRect = get_node("%Equipment Icon")
@onready var scoreLabel : Label= get_node("%Score")
@onready var countdown : Label = get_node("%Countdown")
@onready var sprite : AnimatedSprite2D = $PlayerSprite

# dictionary containing references to all the sprites used for swapping current equipment
var equipDict = {"NONE": null,
				"WOOPIE": "res://Assets/EquipIcons/WoopieCushion.png"}

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	# play anim
	if input_direction.length() > 0:
		if input_direction.x < 0:
			sprite.play("walkLeft")
		elif input_direction.x > 0:
			sprite.play("walkRight")
		elif input_direction.y < 0:
			sprite.play("walkUp")
		elif input_direction.y > 0:
			sprite.play("walkDown")
	else:
		sprite.stop()

func _physics_process(delta):
	get_input()
	move_and_slide()
	update_timer(delta)

func update_timer(delta):
	time -= delta
	countdown.text = "%01d : %02d" % [int(time / 60.0), int(time) % 60]

func update_score(newScore : int, setting : bool = false):
	if setting:
		score = newScore
	else:
		score += newScore
	scoreLabel.text = "Score: %10d" % [score]

func update_health(newHealth : int, setting : bool = false):
	if setting:
		health = newHealth
	else:
		health += newHealth
	susBar.value = health

func change_equip(newEquip : String):
	newEquip = newEquip.capitalize()
	assert(newEquip in equipDict.keys())
	equipped = newEquip
	if equipDict[equipped] == null:
		equipIcon.texture = null
	else:
		equipIcon.texture = equipDict[equipped]
