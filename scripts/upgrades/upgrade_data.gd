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
		"name": "Везунчик I",
		"max_level": 1,
		"cost": [200],
		"parents": [],
		"next": ["lucky_2", "feed_1"],

		"effects": [
			[{ "type": "lucky", "value": 0.10 }]
		]
	},

	"lucky_2": {
		"name": "Везунчик II",
		"max_level": 1,
		"cost": [500],
		"parents": ["lucky_1"],
		"next": ["lucky_3"],

		"effects": [
			[{ "type": "lucky", "value": 0.20 }]
		]
	},

	"lucky_3": {
		"name": "Везунчик III",
		"max_level": 1,
		"cost": [1200],
		"parents": ["lucky_2"],
		"next": [],

		"effects": [
			[{ "type": "lucky", "value": 0.35 }]
		]
	},
	
	"speedy_sheep_1": {
		"name": "Скорость I",
		"max_level": 3,
		"cost": [50, 100, 150],
		"parents": [],
		"next": ["speedy_sheep_2", "big_brain_1"],

		"effects": [
			[{ "type": "sheep_speed_percent", "value": 5.0 }],
			[{ "type": "sheep_speed_percent", "value": 5.0 }],
			[{ "type": "sheep_speed_percent", "value": 5.0 }]
		]
	},
	"speedy_sheep_2": {
		"name": "Скорость II",
		"max_level": 3,
		"cost": [300, 400, 500],
		"parents": ["speedy_sheep_1"],
		"next": ["speedy_sheep_2"],

		"effects": [
			[{ "type": "sheep_speed_percent", "value": 5.0 }],
			[{ "type": "sheep_speed_percent", "value": 5.0 }],
			[{ "type": "sheep_speed_percent", "value": 5.0 }]
		]
	},
	"speedy_sheep_3": {
		"name": "Скорость III",
		"max_level": 3,
		"cost": [800, 1200, 1500],
		"parents": ["speedy_sheep_2"],
		"next": [],

		"effects": [
			[{ "type": "sheep_speed_percent", "value": 5.0 }],
			[{ "type": "sheep_speed_percent", "value": 10.0 }],
			[{ "type": "sheep_speed_percent", "value": 100.0 }]
		]
	},
	"dog_1": {
		"name": "Собачник I",
		"max_level": 1,
		"cost": [100],
		"parents": [],
		"next": ["dog_2"],

		"effects": [
			[{ "type": "spawn_dog", "value": 1 }]
		]
	},

	"dog_2": {
		"name": "Собачник II",
		"max_level": 1,
		"cost": [500],
		"parents": ["dog_1"],
		"next": ["dog_3"],

		"effects": [
			[{ "type": "spawn_dog", "value": 1 }]
		]
	},

	"dog_3": {
		"name": "Собачник III",
		"max_level": 1,
		"cost": [500],
		"parents": ["dog_2"],
		"next": [],

		"effects": [
			[{ "type": "spawn_dog", "value": 1 }]
		]
	},
	"feed_1": {
		"name": "Прикормка I",
		"max_level": 3,
		"cost": [100, 200, 300],
		"parents": ["lucky_1"],
		"next": ["feed_2"],

		"effects": [
			[{ "type": "sheep_max_time", "value": 10 }],
			[{ "type": "sheep_max_time", "value": 10 }],
			[{ "type": "sheep_max_time", "value": 10 }]
		]
	},
	"feed_2": {
		"name": "Прикормка II",
		"max_level": 3,
		"cost": [400, 500, 600],
		"parents": ["feed_1"],
		"next": ["feed_3"],

		"effects": [
			[{ "type": "sheep_max_time", "value": 10 }],
			[{ "type": "sheep_max_time", "value": 10 }],
			[{ "type": "sheep_max_time", "value": 10 }]
		]
	},
	"feed_3": {
		"name": "Прикормка III",
		"max_level": 3,
		"cost": [700, 800, 900],
		"parents": ["feed_2"],
		"next": [],

		"effects": [
			[{ "type": "sheep_max_time", "value": 20 }],
			[{ "type": "sheep_max_time", "value": 30 }],
			[{ "type": "sheep_max_time", "value": 50 }]
		]
	},

	"big_brain_1": {
		"name": "Ум I",
		"max_level": 3,
		"cost": [100, 200, 300],
		"parents": ["speedy_sheep_1"],
		"next": ["big_brain_2"],

		"effects": [
			[{ "type": "sheep_confusion_time", "value": 5 }],
			[{ "type": "sheep_confusion_time", "value": 5 }],
			[{ "type": "sheep_confusion_time", "value": 5 }]
		]
	},

	"big_brain_2": {
		"name": "Ум II",
		"max_level": 3,
		"cost": [400, 500, 600],
		"parents": ["big_brain_1"],
		"next": ["big_brain_3"],

		"effects": [
			[{ "type": "sheep_confusion_time", "value": 5 }],
			[{ "type": "sheep_confusion_time", "value": 5 }],
			[{ "type": "sheep_confusion_time", "value": 5 }]
		]
	},

	"big_brain_3": {
		"name": "Ум III",
		"max_level": 3,
		"cost": [700, 800, 900],
		"parents": ["big_brain_2"],
		"next": [],

		"effects": [
			[{ "type": "sheep_confusion_time", "value": 5 }],
			[{ "type": "sheep_confusion_time", "value": 5 }],
			[{ "type": "sheep_confusion_time", "value": 5 }]
		]
	},
	
	"raririty_bonuses_1": {
		"name": "Бонусы I",
		"max_level": 3,
		"cost": [100, 200, 300],
		"parents": ["lucky_2"],
		"next": ["raririty_bonuses_2"],

		"effects": [
			[{ "type": "uncomon_bonuses", "value": 10 }],
			[{ "type": "uncomon_bonuses", "value": 10 }],
			[{ "type": "uncomon_bonuses", "value": 10 }]
		]
	},
	
	"raririty_bonuses_2": {
		"name": "Бонусы II",
		"max_level": 3,
		"cost": [400, 500, 600],
		"parents": ["raririty_bonuses_1"],
		"next": ["raririty_bonuses_3"],

		"effects": [
			[{ "type": "rare_bonuses", "value": 10 }],
			[{ "type": "rare_bonuses", "value": 10 }],
			[{ "type": "rare_bonuses", "value": 10 }]
		]
	},

	"raririty_bonuses_3": {
		"name": "Бонусы III",
		"max_level": 3,
		"cost": [400, 500, 600],
		"parents": ["raririty_bonuses_2"],
		"next": ["raririty_bonuses_4"],

		"effects": [
			[{ "type": "epic_bonuses", "value": 10 }],
			[{ "type": "epic_bonuses", "value": 10 }],
			[{ "type": "epic_bonuses", "value": 10 }]
		]
	},

	"raririty_bonuses_4": {
		"name": "Бонусы IIII",
		"max_level": 3,
		"cost": [400, 500, 600],
		"parents": ["raririty_bonuses_3"],
		"next": [],

		"effects": [
			[{ "type": "legend_bonuses", "value": 10 }],
			[{ "type": "legend_bonuses", "value": 10 }],
			[{ "type": "legend_bonuses", "value": 10 }]
		]
	},

	"speedy_dogs_1": {
		"name": "Скорость I",
		"max_level": 3,
		"cost": [100, 200, 300],
		"parents": ["dog_1"],
		"next": ["speedy_dogs_2"],

		"effects": [
			[{ "type": "dogs_speed_percent", "value": 5 }],
			[{ "type": "dogs_speed_percent", "value": 5 }],
			[{ "type": "dogs_speed_percent", "value": 5 }]
		]
	},

	"speedy_dogs_2": {
		"name": "Скорость II",
		"max_level": 3,
		"cost": [100, 200, 300],
		"parents": ["dog_1"],
		"next": ["speedy_dogs_3"],

		"effects": [
			[{ "type": "dogs_speed_percent", "value": 5 }],
			[{ "type": "dogs_speed_percent", "value": 5 }],
			[{ "type": "dogs_speed_percent", "value": 5 }]
		]
	},
	
	"speedy_dogs_3": {
		"name": "Скорость III",
		"max_level": 3,
		"cost": [100, 200, 300],
		"parents": ["dog_2"],
		"next": [],

		"effects": [
			[{ "type": "dogs_speed_percent", "value": 5 }],
			[{ "type": "dogs_speed_percent", "value": 5 }],
			[{ "type": "dogs_speed_percent", "value": 5 }]
		]
	},
		
	}
