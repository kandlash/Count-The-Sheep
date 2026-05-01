class_name UpgradeData

static func get_data():
	return {
		"owl_1": {
			"name": "key_owl_1_name_upgrade",
			"max_level": 3,
			"cost": [7, 28, 49],
			"parents": [],
			"next": ["owl_2"],
			"description": "key_owl_1_description_upgrade",
			"effects": [
				[{ "type": "max_tired", "value": 45 }],
				[{ "type": "max_tired", "value": 60 }],
				[{ "type": "max_tired", "value": 75 }]
			]
		},

		"owl_2": {
			"name": "key_owl_2_name_upgrade",
			"max_level": 3,
			"cost": [84, 112, 140],
			"parents": ["owl_1"],
			"next": ["owl_3"],
			"description": "key_owl_2_description_upgrade",
			"effects": [
				[{ "type": "max_tired", "value": 100 }],
				[{ "type": "max_tired", "value": 115 }],
				[{ "type": "max_tired", "value": 130 }]
			]
		},

		"owl_3": {
			"name": "key_owl_3_name_upgrade",
			"max_level": 1,
			"cost": [350],
			"parents": ["owl_2"],
			"next": [],
			"description": "key_owl_3_description_upgrade",
			"effects": [
				[{ "type": "max_tired", "value": 230 }]
			]
		},

		"lucky_1": {
			"name": "key_lucky_1_name_upgrade",
			"max_level": 1,
			"cost": [105],
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
			"cost": [210],
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
			"cost": [350],
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
			"cost": [21, 24, 28],
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
			"cost": [84, 140, 210],
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
			"cost": [280, 350, 560],
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
			"cost": [70],
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
			"cost": [210],
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
			"cost": [315],
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
			"cost": [35, 49, 70],
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
			"cost": [77, 105, 140],
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
			"cost": [154, 175, 210],
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
			"cost": [35, 49, 56],
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
			"cost": [70, 84, 91],
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
			"cost": [105, 112, 140],
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
			"cost": [24, 35, 70],
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
			"cost": [77, 91, 105],
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
			"cost": [140, 175, 189],
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
			"cost": [210, 217, 224],
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
			"cost": [35, 49, 56],
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
			"cost": [70, 84, 105],
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
			"cost": [112, 140, 245],
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
			"cost": [21, 35, 49],
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
			"cost": [70, 105, 140],
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
			"cost": [147, 154, 350],
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
