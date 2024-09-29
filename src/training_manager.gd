extends Node
var agents;
@export var agent_count:int;
@export var simulation_time:float;
var current_simulation_time:float;
var agent_scene;
func _ready():
	current_simulation_time = simulation_time;
	Engine.time_scale = 1.0;
	
	Engine.max_fps = 60;
	agent_scene = load("res://agent.tscn");
	first_generation();

func _process(delta):
	current_simulation_time-=delta;
	if current_simulation_time<0:
		current_simulation_time = simulation_time;
		print("new generation");
		new_generation();

func first_generation():
	for i in range(agent_count):
		var new_agent = agent_scene.instantiate();
		new_agent.initialize_car();
		add_child(new_agent);
		
func new_generation():
	var cars= get_children();
	cars.sort_custom(sort_by_checkpoint);
	var surviving_networks = [];
	for i in cars.slice(int(cars.size()/2)):
		surviving_networks.append(i.network);
		i.queue_free();
	var eliminated = cars.slice(0, cars.size()/2);
	
	for i in surviving_networks:
		for j in range(2):
			var new_agent = agent_scene.instantiate();
			new_agent.network = i;
			if j == 0:
				new_agent.network.mutate();
			add_child(new_agent);
			
		
	for i in eliminated:
		i.queue_free();

	# Helper function to sort cars by `current_checkpoint`
func sort_by_checkpoint(a, b):
	return a.current_checkpoint < b.current_checkpoint
