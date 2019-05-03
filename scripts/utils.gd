extends Node

var translates = {
	'blue': 'PP',
	'green': 'VOX',
	'lightGreen': 'PSOE',
	'orange': 'Cs',
	'yellow': 'ERC',
	'pink': 'PODEMOS'
}

func get_translate(label):
	return translates[label]