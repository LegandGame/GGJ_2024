extends Area2D

@export_enum("CACHE", "HACKABLE") var type
@export var command : String
@export var hackProgress : float = 100.0
@export var value : int = 100
var interactable : bool = false
@onready var UI := $CanvasLayer/Label
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")

func _on_body_entered(body):
	if body == player:
		get_node("CanvasLayer").show()
		update_ui()
func _on_body_exited(body):
	if body == player:
		get_node("CanvasLayer").hide()


func _process(delta):
	if Input.is_action_pressed("interact") and interactable and type == "HACKABLE":
		player.velocity *= 0.1
		hackProgress -= delta
		if hackProgress <= 0.0:
			hacked()

func hacked():
	self.process_mode = Node.PROCESS_MODE_DISABLED
	player.score += value

func update_ui():
	match type:
		"CACHE":
			interactable = true
			UI.text = "pick up %s" % [command]
		"HACKABLE":
			UI.text = "requires %s" % [command]
			if player.equipped == command:
				interactable = true
			else:
				interactable = false
			

func _input(event):
	if event.is_action_just_pressed("interact") and interactable and type == "CACHE":
		player.equipped = command
		interactable = false
