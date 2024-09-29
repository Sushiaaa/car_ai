extends Node
class_name NeuralNetwork

var layers:Array;
var rng = RandomNumberGenerator.new();

func generate_network(input_size, hidden_layers, hidden_layer_size, output_size):
	#input layer initialization
	layers.append([]);
	for i in range(input_size):
		var new_node = NeuralNode.new();
		layers[0].append(new_node)

	#hidden layers initialization
	for i in range(hidden_layers):
		var new_layer:Array = [];
		for j in range(hidden_layer_size):
			var new_node = NeuralNode.new();
			new_node.bias = rng.randf_range(-1.0, 1.0);
			for k in range(layers[i].size()):
				new_node.weights.append(randf_range(-1.0, 1.0));
			new_layer.append(new_node);
		layers.append(new_layer);

	#output layer initialization
	layers.append([]);
	for i in range(output_size):
		var new_node = NeuralNode.new();
		new_node.bias = rng.randf_range(-1.0, 1.0);
		for k in range(layers[-2].size()):
			new_node.weights.append(randf_range(-1.0, 1.0));
		layers[-1].append(new_node)

func ReLU(input):
	if input>0:
		return input;
	else:
		return 0;

func mutate():
	for layer in layers.slice(1):
		for node in layer:
			for weight in node.weights:
				if rng.randi_range(0,5) == 5:
					weight+= rng.randf_range(-0.5,0.5);
			if rng.randi_range(0,5) == 5:
				
				node.bias+= rng.randf_range(-1,1);
func forward_prop():
	for i in range(1, layers.size()):
		var current_layer = layers[i]
		var previous_layer = layers[i - 1]  # Reference to the previous layer
		for j in range(current_layer.size()):
			var current_node = current_layer[j]
			current_node.value = 0  # Reset the node's value
			for k in range(current_node.weights.size()):
				current_node.value += previous_layer[k].value * current_node.weights[k]
			current_node.value += current_node.bias  # Add the bias after summing
			current_node.value = ReLU(current_node.value);

