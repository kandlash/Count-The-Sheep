class_name UpgradeData

static func get_data():
	return {
		"owl_1": {
			"name": "key_owl_1_name_upgrade",
			"max_level": 3,
			"cost": [10, 20, 40],
			"parents": [],
			"next": ["owl_2"],
			"description": "key_owl_1_description_upgrade",

			"effects": [
				[{ "type": "max_tired", "value": 100 }],
				[{ "type": "max_tired", "value": 120 }],
				[{ "type": "max_tired", "value": 150 }]
			]
		},

		"owl_2": {
			"name": "key_owl_2_name_upgrade",
			"max_level": 3,
			"cost": [60, 80, 120],
			"parents": ["owl_1"],
			"next": ["owl_3"],
			"description": "key_owl_2_description_upgrade",

			"effects": [
				[{ "type": "max_tired", "value": 200 }],
				[{ "type": "max_tired", "value": 220 }],
				[{ "type": "max_tired", "value": 250 }]
			]
		},

		"owl_3": {
			"name": "key_owl_3_name_upgrade",
			"max_level": 1,
			"cost": [200],
			"parents": ["owl_2"],
			"next": [],
			"description": "key_owl_3_description_upgrade",
			"effects": [
				[{ "type": "max_tired", "value": 300 }]
			]
		},

		"lucky_1": {
			"name": "key_lucky_1_name_upgrade",
			"max_level": 1,
			"cost": [200],
			"parents": [],
			"next": ["lucky_2", "feed_1"],
			"description": "key_lucky_1_description_upgrade",
			"effects": [
				[{ "type": "lucky", "value": 10.0 }]
			]
		},

		"lucky_2": {
			"name": "key_lucky_2_name_upgrade",
			"max_level": 1,
			"cost": [500],
			"parents": ["lucky_1"],
			"next": ["lucky_3"],
			"description": "key_lucky_2_description_upgrade",
			"effects": [
				[{ "type": "lucky", "value": 20.0 }]
			]
		},

		"lucky_3": {
			"name": "key_lucky_3_name_upgrade",
			"max_level": 1,
			"cost": [1200],
			"parents": ["lucky_2"],
			"next": [],
			"description": "key_lucky_3_description_upgrade",
			"effects": [
				[{ "type": "lucky", "value": 35.0 }]
			]
		},

		"speedy_sheep_1": {
			"name": "key_speedy_sheep_1_name_upgrade",
			"max_level": 3,
			"cost": [50, 100, 150],
			"parents": [],
			"next": ["speedy_sheep_2", "big_brain_1"],
			"description": "key_speedy_sheep_1_description_upgrade",
			"effects": [
				[{ "type": "sheep_speed_percent", "value": 5.0 }],
				[{ "type": "sheep_speed_percent", "value": 5.0 }],
				[{ "type": "sheep_speed_percent", "value": 5.0 }]
			]
		},

		"speedy_sheep_2": {
			"name": "key_speedy_sheep_2_name_upgrade",
			"max_level": 3,
			"cost": [300, 400, 500],
			"parents": ["speedy_sheep_1"],
			"next": ["speedy_sheep_2"],
			"description": "key_speedy_sheep_2_description_upgrade",
			"effects": [
				[{ "type": "sheep_speed_percent", "value": 5.0 }],
				[{ "type": "sheep_speed_percent", "value": 5.0 }],
				[{ "type": "sheep_speed_percent", "value": 5.0 }]
			]
		},

		"speedy_sheep_3": {
			"name": "key_speedy_sheep_3_name_upgrade",
			"max_level": 3,
			"cost": [800, 1200, 1500],
			"parents": ["speedy_sheep_2"],
			"next": [],
			"description": "key_speedy_sheep_3_description_upgrade",
			"effects": [
				[{ "type": "sheep_speed_percent", "value": 5.0 }],
				[{ "type": "sheep_speed_percent", "value": 10.0 }],
				[{ "type": "sheep_speed_percent", "value": 100.0 }]
			]
		},

		"dog_1": {
			"name": "key_dog_1_name_upgrade",
			"max_level": 1,
			"cost": [100],
			"parents": [],
			"next": ["dog_2"],
			"description": "key_dog_1_description_upgrade",
			"effects": [
				[{ "type": "spawn_dog", "value": 1 }]
			]
		},

		"dog_2": {
			"name": "key_dog_2_name_upgrade",
			"max_level": 1,
			"cost": [500],
			"parents": ["dog_1"],
			"next": ["dog_3"],
			"description": "key_dog_2_description_upgrade",
			"effects": [
				[{ "type": "spawn_dog", "value": 1 }]
			]
		},

		"dog_3": {
			"name": "key_dog_3_name_upgrade",
			"max_level": 1,
			"cost": [500],
			"parents": ["dog_2"],
			"next": [],
			"description": "key_dog_3_description_upgrade",
			"effects": [
				[{ "type": "spawn_dog", "value": 1 }]
			]
		},

		"feed_1": {
			"name": "key_feed_1_name_upgrade",
			"max_level": 3,
			"cost": [100, 200, 300],
			"parents": ["lucky_1"],
			"next": ["feed_2"],
			"description": "key_feed_1_description_upgrade",
			"effects": [
				[{ "type": "sheep_max_time", "value": 5 }],
				[{ "type": "sheep_max_time", "value": 6 }],
				[{ "type": "sheep_max_time", "value": 7 }]
			]
		},

		"feed_2": {
			"name": "key_feed_2_name_upgrade",
			"max_level": 3,
			"cost": [400, 500, 600],
			"parents": ["feed_1"],
			"next": ["feed_3"],
			"description": "key_feed_2_description_upgrade",
			"effects": [
				[{ "type": "sheep_max_time", "value": 8 }],
				[{ "type": "sheep_max_time", "value": 9 }],
				[{ "type": "sheep_max_time", "value": 10 }]
			]
		},

		"feed_3": {
			"name": "key_feed_3_name_upgrade",
			"max_level": 3,
			"cost": [700, 800, 900],
			"parents": ["feed_2"],
			"next": [],
			"description": "key_feed_3_description_upgrade",
			"effects": [
				[{ "type": "sheep_max_time", "value": 10 }],
				[{ "type": "sheep_max_time", "value": 10 }],
				[{ "type": "sheep_max_time", "value": 10 }]
			]
		},

		"big_brain_1": {
			"name": "key_big_brain_1_name_upgrade",
			"max_level": 3,
			"cost": [100, 200, 300],
			"parents": ["speedy_sheep_1"],
			"next": ["big_brain_2"],
			"description": "key_big_brain_1_description_upgrade",
			"effects": [
				[{ "type": "sheep_confusion_time", "value": 5 }],
				[{ "type": "sheep_confusion_time", "value": 5 }],
				[{ "type": "sheep_confusion_time", "value": 5 }]
			]
		},

		"big_brain_2": {
			"name": "key_big_brain_2_name_upgrade",
			"max_level": 3,
			"cost": [400, 500, 600],
			"parents": ["big_brain_1"],
			"next": ["big_brain_3"],
			"description": "key_big_brain_2_description_upgrade",
			"effects": [
				[{ "type": "sheep_confusion_time", "value": 5 }],
				[{ "type": "sheep_confusion_time", "value": 5 }],
				[{ "type": "sheep_confusion_time", "value": 5 }]
			]
		},

		"big_brain_3": {
			"name": "key_big_brain_3_name_upgrade",
			"max_level": 3,
			"cost": [700, 800, 900],
			"parents": ["big_brain_2"],
			"next": [],
			"description": "key_big_brain_3_description_upgrade",
			"effects": [
				[{ "type": "sheep_confusion_time", "value": 5 }],
				[{ "type": "sheep_confusion_time", "value": 5 }],
				[{ "type": "sheep_confusion_time", "value": 5 }]
			]
		},

		"raririty_bonuses_1": {
			"name": "key_rarity_bonuses_1_name_upgrade",
			"max_level": 3,
			"cost": [100, 200, 300],
			"parents": ["lucky_2"],
			"next": ["raririty_bonuses_2"],
			"description": "key_rarity_bonuses_1_description_upgrade",
			"effects": [
				[{ "type": "uncomon_bonuses", "value": 10 }],
				[{ "type": "uncomon_bonuses", "value": 10 }],
				[{ "type": "uncomon_bonuses", "value": 10 }]
			]
		},

		"raririty_bonuses_2": {
			"name": "key_rarity_bonuses_2_name_upgrade",
			"max_level": 3,
			"cost": [400, 500, 600],
			"parents": ["raririty_bonuses_1"],
			"next": ["raririty_bonuses_3"],
			"description": "key_rarity_bonuses_2_description_upgrade",
			"effects": [
				[{ "type": "rare_bonuses", "value": 10 }],
				[{ "type": "rare_bonuses", "value": 10 }],
				[{ "type": "rare_bonuses", "value": 10 }]
			]
		},

		"raririty_bonuses_3": {
			"name": "key_rarity_bonuses_3_name_upgrade",
			"max_level": 3,
			"cost": [400, 500, 600],
			"parents": ["raririty_bonuses_2"],
			"next": ["raririty_bonuses_4"],
			"description": "key_rarity_bonuses_3_description_upgrade",
			"effects": [
				[{ "type": "epic_bonuses", "value": 10 }],
				[{ "type": "epic_bonuses", "value": 10 }],
				[{ "type": "epic_bonuses", "value": 10 }]
			]
		},

		"raririty_bonuses_4": {
			"name": "key_rarity_bonuses_4_name_upgrade",
			"max_level": 3,
			"cost": [400, 500, 600],
			"parents": ["raririty_bonuses_3"],
			"next": [],
			"description": "key_rarity_bonuses_4_description_upgrade",
			"effects": [
				[{ "type": "legend_bonuses", "value": 10 }],
				[{ "type": "legend_bonuses", "value": 10 }],
				[{ "type": "legend_bonuses", "value": 10 }]
			]
		},

		"speedy_dogs_1": {
			"name": "key_speedy_dogs_1_name_upgrade",
			"max_level": 3,
			"cost": [100, 200, 300],
			"parents": ["dog_1"],
			"next": ["speedy_dogs_2"],
			"description": "key_speedy_dogs_1_description_upgrade",
			"effects": [
				[{ "type": "dogs_speed_percent", "value": 5 }],
				[{ "type": "dogs_speed_percent", "value": 5 }],
				[{ "type": "dogs_speed_percent", "value": 5 }]
			]
		},

		"speedy_dogs_2": {
			"name": "key_speedy_dogs_2_name_upgrade",
			"max_level": 3,
			"cost": [100, 200, 300],
			"parents": ["dog_1"],
			"next": ["speedy_dogs_3"],
			"description": "key_speedy_dogs_2_description_upgrade",
			"effects": [
				[{ "type": "dogs_speed_percent", "value": 5 }],
				[{ "type": "dogs_speed_percent", "value": 5 }],
				[{ "type": "dogs_speed_percent", "value": 5 }]
			]
		},

		"speedy_dogs_3": {
			"name": "key_speedy_dogs_3_name_upgrade",
			"max_level": 3,
			"cost": [100, 200, 300],
			"parents": ["dog_2"],
			"next": [],
			"description": "key_speedy_dogs_3_description_upgrade",
			"effects": [
				[{ "type": "dogs_speed_percent", "value": 5 }],
				[{ "type": "dogs_speed_percent", "value": 5 }],
				[{ "type": "dogs_speed_percent", "value": 5 }]
			]
		},
	}
