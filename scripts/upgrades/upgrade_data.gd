class_name UpgradeData

static func get_data():
	return {
		"owl_1": {
			"name": "key_owl_1_name_upgrade",
			"max_level": 3,
			"cost": [10, 40, 70],
			"parents": [],
			"next": ["owl_2"],
			"description": "key_owl_1_description_upgrade",

			"effects": [
				[{ "type": "max_tired", "value": 45 }],
				[{ "type": "max_tired", "value": 60 }],
				[{ "type": "max_tired", "value": 100 }]
			]
		},

		"owl_2": {
			"name": "key_owl_2_name_upgrade",
			"max_level": 3,
			"cost": [120, 160, 200],
			"parents": ["owl_1"],
			"next": ["owl_3"],
			"description": "key_owl_2_description_upgrade",

			"effects": [
				[{ "type": "max_tired", "value": 120 }],
				[{ "type": "max_tired", "value": 155 }],
				[{ "type": "max_tired", "value": 180 }]
			]
		},

		"owl_3": {
			"name": "key_owl_3_name_upgrade",
			"max_level": 1,
			"cost": [1000],
			"parents": ["owl_2"],
			"next": [],
			"description": "key_owl_3_description_upgrade",
			"effects": [
				[{ "type": "max_tired", "value": 330 }]
			]
		},

		"lucky_1": {
			"name": "key_lucky_1_name_upgrade",
			"max_level": 1,
			"cost": [150],
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
			"cost": [300],
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
			"cost": [500],
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
			"cost": [30, 35, 40],
			"parents": [],
			"next": ["speedy_sheep_2", "big_brain_1"],
			"description": "key_speedy_sheep_1_description_upgrade",
			"effects": [
				[{ "type": "sheep_speed_percent", "value": 5.0 }],
				[{ "type": "sheep_speed_percent", "value": 7.0 }],
				[{ "type": "sheep_speed_percent", "value": 10.0 }]
			]
		},

		"speedy_sheep_2": {
			"name": "key_speedy_sheep_2_name_upgrade",
			"max_level": 3,
			"cost": [120, 200, 300],
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
			"cost": [400, 500, 800],
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
			"cost": [300],
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
			"cost": [450],
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
			"cost": [50, 70, 100],
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
			"cost": [110, 150, 200],
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
			"cost": [220, 250, 300],
			"parents": ["feed_2"],
			"next": [],
			"description": "key_feed_3_description_upgrade",
			"effects": [
				[{ "type": "sheep_max_time", "value": 15 }],
				[{ "type": "sheep_max_time", "value": 15 }],
				[{ "type": "sheep_max_time", "value": 15 }]
			]
		},

		"big_brain_1": {
			"name": "key_big_brain_1_name_upgrade",
			"max_level": 3,
			"cost": [50, 70, 80],
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
			"cost": [100, 120, 130],
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
			"cost": [150, 160, 200],
			"parents": ["big_brain_2"],
			"next": [],
			"description": "key_big_brain_3_description_upgrade",
			"effects": [
				[{ "type": "sheep_confusion_time", "value": 5 }],
				[{ "type": "sheep_confusion_time", "value": 5 }],
				[{ "type": "sheep_confusion_time", "value": 15 }]
			]
		},

		"raririty_bonuses_1": {
			"name": "key_rarity_bonuses_1_name_upgrade",
			"max_level": 3,
			"cost": [35, 50, 100],
			"parents": ["jump_bonus_1"],
			"next": ["raririty_bonuses_2"],
			"description": "key_rarity_bonuses_1_description_upgrade",
			"effects": [
				[{ "type": "uncomon_bonuses", "value": 30 }],
				[{ "type": "uncomon_bonuses", "value": 35 }],
				[{ "type": "uncomon_bonuses", "value": 40 }]
			]
		},

		"raririty_bonuses_2": {
			"name": "key_rarity_bonuses_2_name_upgrade",
			"max_level": 3,
			"cost": [110, 130, 150],
			"parents": ["raririty_bonuses_1"],
			"next": ["raririty_bonuses_3"],
			"description": "key_rarity_bonuses_2_description_upgrade",
			"effects": [
				[{ "type": "rare_bonuses", "value": 40 }],
				[{ "type": "rare_bonuses", "value": 45 }],
				[{ "type": "rare_bonuses", "value": 50 }]
			]
		},

		"raririty_bonuses_3": {
			"name": "key_rarity_bonuses_3_name_upgrade",
			"max_level": 3,
			"cost": [200, 250, 270],
			"parents": ["raririty_bonuses_2"],
			"next": ["raririty_bonuses_4"],
			"description": "key_rarity_bonuses_3_description_upgrade",
			"effects": [
				[{ "type": "epic_bonuses", "value": 40 }],
				[{ "type": "epic_bonuses", "value": 45 }],
				[{ "type": "epic_bonuses", "value": 50 }]
			]
		},

		"raririty_bonuses_4": {
			"name": "key_rarity_bonuses_4_name_upgrade",
			"max_level": 3,
			"cost": [300, 310, 320],
			"parents": ["raririty_bonuses_3"],
			"next": [],
			"description": "key_rarity_bonuses_4_description_upgrade",
			"effects": [
				[{ "type": "legend_bonuses", "value": 40 }],
				[{ "type": "legend_bonuses", "value": 45 }],
				[{ "type": "legend_bonuses", "value": 50 }]
			]
		},

		"speedy_dogs_1": {
			"name": "key_speedy_dogs_1_name_upgrade",
			"max_level": 3,
			"cost": [50, 70, 80],
			"parents": ["dog_1"],
			"next": ["speedy_dogs_2"],
			"description": "key_speedy_dogs_1_description_upgrade",
			"effects": [
				[{ "type": "dogs_speed_percent", "value": 5 }],
				[{ "type": "dogs_speed_percent", "value": 6 }],
				[{ "type": "dogs_speed_percent", "value": 7 }]
			]
		},

		"speedy_dogs_2": {
			"name": "key_speedy_dogs_2_name_upgrade",
			"max_level": 3,
			"cost": [100, 120, 150],
			"parents": ["speedy_dogs_1"],
			"next": ["speedy_dogs_3"],
			"description": "key_speedy_dogs_2_description_upgrade",
			"effects": [
				[{ "type": "dogs_speed_percent", "value": 5 }],
				[{ "type": "dogs_speed_percent", "value": 6 }],
				[{ "type": "dogs_speed_percent", "value": 7 }]
			]
		},

		"speedy_dogs_3": {
			"name": "key_speedy_dogs_3_name_upgrade",
			"max_level": 3,
			"cost": [160, 200, 350],
			"parents": ["speedy_dogs_2"],
			"next": [],
			"description": "key_speedy_dogs_3_description_upgrade",
			"effects": [
				[{ "type": "dogs_speed_percent", "value": 5 }],
				[{ "type": "dogs_speed_percent", "value": 6 }],
				[{ "type": "dogs_speed_percent", "value": 100 }]
			]
		},
		
		"jump_bonus_1": {
			"name": "key_jump_bonus_1",
			"max_level": 3,
			"cost": [30, 50, 70],
			"parents": [],
			"next": ["raririty_bonuses_1", "jump_bonus_2"],
			"description": "key_jump_bonus_description_1",
			"effects": [
				[{ "type": "jump_bonus", "value": 15 }],
				[{ "type": "jump_bonus", "value": 25 }],
				[{ "type": "jump_bonus", "value": 35 }]
			]
		},
		
		"jump_bonus_2": {
			"name": "key_jump_bonus_2",
			"max_level": 3,
			"cost": [100, 150, 200],
			"parents": ["jump_bonus_1"],
			"next": ["jump_bonus_3"],
			"description": "key_jump_bonus_description_2",
			"effects": [
				[{ "type": "jump_bonus", "value": 15 }],
				[{ "type": "jump_bonus", "value": 25 }],
				[{ "type": "jump_bonus", "value": 35 }]
			]
		},
		
		"jump_bonus_3": {
			"name": "key_jump_bonus_3",
			"max_level": 3,
			"cost": [210, 220, 500],
			"parents": ["jump_bonus_2"],
			"next": ["jump_bonus_3"],
			"description": "key_jump_bonus_description_3",
			"effects": [
				[{ "type": "jump_bonus", "value": 25 }],
				[{ "type": "jump_bonus", "value": 35 }],
				[{ "type": "jump_bonus", "value": 100 }]
			]
		},
	}
