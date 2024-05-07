extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var sprite : Sprite2D = $Sprite2D
var playback : AnimationNodeStateMachinePlayback
#@export var animation_tree : AnimationTree

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

#player input
var movement_input = Vector2.ZERO
var jump_input = false
var jump_input_actuation = false
var climb_input = false 
var dash_input = false

#player_movement
const SPEED = 150.0
const JUMP_VELOCITY = -400.0
var last_direction = Vector2.RIGHT

#mechanics
var can_dash = true

#states
var current_state = null
var prev_state = null

#nodes
@onready var STATES = $STATES
@onready var Raycasts = $Raycasts

func _ready():
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self
		playback = animation_tree["parameters/playback"]
	prev_state = STATES.IDLE
	current_state = STATES.IDLE
	animation_tree.active = true
func _physics_process(delta):
	player_input()
	change_state(current_state.update(delta))
	$Label.text = str(current_state.get_name())
	move_and_slide()
	
func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_value * delta
		

func change_state(input_state):
	if input_state != null:
		prev_state = current_state 
		current_state = input_state
		
		prev_state.exit_state()
		current_state.enter_state()
func get_next_to_wall():
	for raycast in Raycasts.get_children():
		raycast.force_raycast_update() 
		if raycast.is_colliding():
			if raycast.target_position.x > 0:
				return Vector2.RIGHT
			else:
				return Vector2.LEFT
	return null
	

func player_input():
	movement_input = Vector2.ZERO
	animation_tree.set("parameters/Move/blend_position",movement_input.x)
	playback.travel("Move")
	if current_state == STATES.FALL:
			playback.travel("jump")
	# if prev_state == STATES.FALL && current_state == STATES.IDLE && prev_state != null:
	# 	if is_on_floor():
	# 		playback.travel("jump_end")
	if Input.is_action_pressed("MoveRight"):
		movement_input.x += 1
		sprite.flip_h = false
		if is_on_floor() != false:
			animation_tree.set("parameters/Move/blend_position",movement_input.x)
	if Input.is_action_pressed("MoveLeft"):
		movement_input.x -= 1
		sprite.flip_h = true
		if is_on_floor() != false:
			animation_tree.set("parameters/Move/blend_position",movement_input.x)
	if Input.is_action_pressed("MoveUp"):
		movement_input.y -= 1
	if Input.is_action_pressed("MoveDown"):
		movement_input.y += 1
	
	# jumps
	if Input.is_action_pressed("Jump"):
		jump_input = true
		playback.travel("jump_start")
		if current_state == STATES.FALL:
			playback.travel("jump")
	else: 
		jump_input = false
	if Input.is_action_just_pressed("Jump"):
		jump_input_actuation = true
		playback.travel("jump_start")
		if current_state == STATES.FALL:
			playback.travel("jump")
	else: 
		jump_input_actuation = false
	
	#climb
	if Input.is_action_pressed("Climb"):
		climb_input = true
	else: 
		climb_input = false
	
	#dash
	if Input.is_action_just_pressed("Dash"):
		dash_input = true
	else: 
		dash_input = false
	











