extends RigidBody2D

var arrow_angle: float = 0.0
var dragging: bool = false
var drag_initial: Vector2 = Vector2.ZERO
var force_vector: Vector2 = Vector2.ZERO

var force_line_offset: Vector2 = Vector2(0, -20)

export (float) var force_factor: float = 2
export (float) var max_force: float = 100

func _physics_process(delta):
	if !dragging and Input.is_action_just_pressed("click"):
		show_force()
		begin_drag()
	
	if dragging:
		calculate_force_vector()
		draw_force()
		if Input.is_action_just_released("click"):
			hide_force()
			end_drag()


func show_force():
	$ForceLabel.visible = true
	$Line2D.visible = true


func hide_force():
	$ForceLabel.visible = false
	$Line2D.visible = false


func draw_force():
	$Line2D.points[0] = drag_initial - position
	$Line2D.points[1] = force_vector + force_line_offset + $Line2D.points[0]
	$ForceLabel.text = '%s' % force_vector.length()


func calculate_force_vector():
	var mouse_pos = get_global_mouse_position()
	var result = (drag_initial - mouse_pos)
	force_vector = result.clamped(max_force)


func begin_drag():
	drag_initial = get_global_mouse_position()
	dragging = true


func end_drag():
	apply_central_impulse(force_vector * force_factor)
	dragging = false
	force_vector = Vector2.ZERO
	drag_initial = Vector2.ZERO
	
	
