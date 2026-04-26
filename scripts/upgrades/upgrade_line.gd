extends Line2D
class_name UpgradeLine

func setup(a: Vector2, b: Vector2):
	clear_points()
	add_point(a)
	add_point(b)
