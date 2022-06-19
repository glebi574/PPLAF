	
	--[[
		PewPew Live:
			fmath.
				sqrt(x) -> r
				to_int(x) -> r
				to_fixedpoint(x) -> r
				abs_fixedpoint(x) -> r
				sincos(x) -> a, b
				atan2(y, x) -> r
				tau() -> r
			
			pewpew.
				print(s) -< s [print(s)]
				print_debug_info() -< s / number of entities
				set_level_size(x, y)
				add_wall(x1, y1, x2, y2)
				remove_wall(wall_id)
				add_update_callback(function(...)) / adds update callback in main thread
				get_number_of_players()
				increase_score_of_player(index, x)
				get_score_of_player(index)
				stop_game()
				get_player_inputs(index) -> move_angle, move_distance, shhot_angle, shoot_distance
				configure_player_hud(index, {top_left_line})
				configure_player(index,
					{has_lost, shield, camera_x_override, camera_y_override, camera_distance, camera_rotation_x_axis, move_joystick_color, shoot_joystick_color})
				get_player_configuration(index) -> has_lost, shield
				add_damage_to_player_ship(id, x)
				add_arrow_to_player_ship(ship_id, target_id, color) -> id
				remove_arrow_from_player_ship(ship_id, arrow_id)
				make_player_ship_transparent(id, time)
				get_entity_count(type) -> r
				get_entity_type(id) -> type
				play_ambient_sound(path, index)
				paly_sound(path, index, x, y)
				create_explosion(x, y, color, scale, particles_amount)
				new_player_ship(x, y, index) -> id
				new_player_bullet(x, y, angle, index) -> id
				entity_get_position(id) -> x, y
				entity_set_position(id, x, y)
				entity_get_is_alive(id) -> r
				entity_get_is_started_to_be_destroyed(id) -> r
				entity_set_radius(id, x)
				entity_set_update_callback(id, function()) / does something, while entity is alive
				entity_destroy(id)
				customizable_entity_set_position_interpolation(id, bool)
				customizable_entity_set_mesh(id, path, index)
				customizable_entity_set_flipping_meshes(id, path, index1, index2)
				customizable_entity_set_mesh_color(id, color)
				customizable_entity_set_string(id, text) / changes entitie's mesh to text
				customizable_entity_set_mesh_z(id, x)
				customizable_entity_set_mesh_scale(id, scale)
				customizable_entity_set_mesh_xyz_scale(id, xs, ys, zs)
				customizable_entity_set_mesh_angle(id, angle, xv, yv, zv)
				customizable_entity_add_rotation_to_mesh(id, angle, xv, yv, zv)
				customizable_entity_configure_music_response(id, {color1, color2, xs1, xs2, ys1, ys2, zs1, zs2})
				customizable_entity_set_visibility_radius(id, x) / changes the radius where entity is drawn
				customizable_entity_configure_wall_collision(entity_id, collide_with_walls, collision_callback) / calls collision_callback when entity collides with walls
				customizable_entity_start_spawning(id, time)
				customizable_entity_start_exploding(id, time)
				
			PewPew Live Additional Framework:
				functions:
					chance(c) -> r / return true or false with chance `c`
					create_text_line(x, y, string) -> id
				
				math.
					abs(a) -> b
					floor(a) -> b
					random(a, b) -> r
				
				fxmath.
					abs(a) -> b
					floor(a) -> b
					random(a, b) -> r
					lenght(v1, v2[, v3, v4]) -> l / returns lenght of vector, where input is: dx, dy / x1, y1, x2, y2
				
				timer. / used to create timers containing 2 values. When the first value is equal to maximum, it is reset to zero and second value is increased
					create(max) -> index / creates timer and returns its index
					get(index) -> v1, v2 / return current values of timer's variables
					remove(index)
				
				trigger. / used to create triggers, which can be activated by player ships
					create(v1, v2, v3[, v4]) -> id / creates trigger with shape of circle(x, y, radius) or rectangle(x1, y1, x2, y2) and returns its id
					get_state(id) -> r / checks if player is in trigger's area
					remove(id)
				
				switch. / used to create switches
					create({a1, a2, a3[, a4]}, {b1, b2, b3[, b4]}) creates 2 triggers, switched by each other, imput is similar to trigger.create() and return switch's index
					get(index) -> mode, state / returns current switch's mode(which of triggers is active) and state
					remove(index)
				
				player. / used to create player ships and control camera
					create(x, y, type, method) -> id / creates player with type and method, defined in player.lua
					types.
						player
						ai / not controlled by player
					methods.
						main
						custom / custom ship's mesh and control
					camera.
						properties.
							x
							y / camera coordinates
							speed / camera speed
							x_offset / fx value
							y_offset / fx value
							x_static / if not false, x axis is blocked to it's fx value
							y_static / if not false, y axis is blocked to it's fx value
							shooting_offset / if not false, adds offset, when player uses shooting joystick
							do_count_ai / are ai ships counted in average position of all ships
							do_count_custom / are custom ships counted in average position of all ships
				
				wall. / used to create walls
					create(x1, y1, x2, y2) -> id / creates wall with mesh and returnes mesh's id
					remove(id)
				
	]]--
	