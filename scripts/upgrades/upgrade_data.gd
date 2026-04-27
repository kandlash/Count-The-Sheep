class_name UpgradeData

static func get_data():
	return {
		"owl_1": {
			"name": "key_upgrade_owl_1",
			"max_level": 3,
			"cost": [10, 20, 40],
			"parents": [],
			"next": ["owl_2"],

			"effects": [
				[{ "type": "max_tired", "value": 100 }],
				[{ "type": "max_tired", "value": 120 }],
				[{ "type": "max_tired", "value": 150 }]
			]
		},

		"owl_2": {
			"name": "Сова II",
			"max_level": 3,
			"cost": [60, 80, 120],
			"parents": ["owl_1"],
			"next": ["owl_3"],

			"effects": [
				[{ "type": "max_tired", "value": 200 }],
				[{ "type": "max_tired", "value": 220 }],
				[{ "type": "max_tired", "value": 250 }]
			]
		},

		"owl_3": {
			"name": "Сова III",
			"max_level": 1,
			"cost": [200],
			"parents": ["owl_2"],
			"next": [],

			"effects": [
				[{ "type": "max_tired", "value": 300 }]
			]
		},
		"lucky_1": {
		"name": "Счастливчик I",
		"max_level": 1,
		"cost": [200],
		"parents": [],
		"next": ["lucky_2"],

		"effects": [
			[{ "type": "lucky", "value": 0.10 }]
		]
	},

	"lucky_2": {
		"name": "Счастливчик II",
		"max_level": 1,
		"cost": [500],
		"parents": ["lucky_1"],
		"next": ["lucky_3"],

		"effects": [
			[{ "type": "lucky", "value": 0.20 }]
		]
	},

	"lucky_3": {
		"name": "Счастливчик III",
		"max_level": 1,
		"cost": [1200],
		"parents": ["lucky_2"],
		"next": [],

		"effects": [
			[{ "type": "lucky", "value": 0.35 }]
		]
	},
		
	}
