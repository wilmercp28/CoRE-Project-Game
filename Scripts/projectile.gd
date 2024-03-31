extends RigidBody2D
class_name Projectile



func move(direction):
	apply_central_impulse(direction)
