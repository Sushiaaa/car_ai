extends Node2D

var raycasts:Array;
var raycast_parent;
var network:NeuralNetwork;
var car;
var checkpoint_parent;
var current_checkpoint = 0;
var is_dead = false;

func _ready():
	initialize_car()
	global_position = Vector2(0,0);
	is_dead = false;
	raycast_parent = $CharacterBody2D/Raycasts;
	car = $CharacterBody2D;
	car.velocity = Vector2(0,0);
	checkpoint_parent = $"../../Sprite2D/Node2";
	raycasts = raycast_parent.get_children();
	
func initialize_car():
	network = NeuralNetwork.new();
	network.generate_network(9, 1, 9, 4);
	
func _process(delta):
	if !is_dead:
		for i in raycasts.size():
			if(raycasts[i].get_collider()):
				network.layers[0][i].value = raycasts[i].global_position.distance_to(raycasts[i].get_collision_point())/500;
			else:
				network.layers[0][i].value = 1;
		network.layers[0][-1].value = car.velocity.length()/500;
		network.forward_prop();
			
		var output_values = [0.0, 0.0, 0.0, 0.0];
		for i in range(output_values.size()):
			output_values[i] = network.layers[-1][i].value
		car.input=output_values;
	else:
		get_child(0).velocity = Vector2(0,0);
		car.input=[0.0, 0.0, 0.0, 0.0];


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body == checkpoint_parent.get_child(current_checkpoint):
		current_checkpoint+=1;

func _on_area_2d_2_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	is_dead = true;
	
