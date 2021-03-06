extends Spatial

# class member variables go here, for example:
var player
var player_script
var time
var count
#start/finish
var finish = false
var start

export var target = Vector3()

# race
var racer
var car

func _ready():
	player_script = load("res://car/vehicle_player.gd")
	count = false
	
	racer = preload("res://car/car_AI_racer.tscn")
	
	set_process(true)
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_finish(val):
	finish = val

func _on_Area_body_enter( body ):
	if body is VehicleBody:
		if body is player_script:
			print("Area entered by the player")
			player = body
			
			if finish:
				print("Reached finish marker")
				start.count = false
				
				var msg = body.get_node("Messages")
				#msg.set_initial(false)
				msg.set_text("FINISH TEST RACE!")
				#msg.get_node("OK_button").connect("pressed", self, "_on_ok_click")
				msg.enable_ok(false)
				msg.show()
				
				#remove finish
				queue_free()
			else:
				var msg = body.get_node("Messages")
				#msg.set_initial(false)
				msg.set_text("TEST RACE! " + "\n" + "Race one guy to the finish marker")
				msg.get_node("OK_button").connect("pressed", self, "_on_ok_click")
				msg.enable_ok(true)
				msg.show()
		#else:
		#	print("Area entered by a car " + body.get_parent().get_name())
	#else:
	#	print("Area entered by something else")


func _on_ok_click():
	count = true
	time = 0.0
	spawn_finish(self)
	spawn_racer(Vector3(0,0,4))
	print("Clicked ok!")
	
	
func _process(delta):
	if count:
		time += delta
		#print("Timer is " + str(time))
		player.get_node("root").get_node("Label timer").show()
		player.get_node("root").update_timer(str(time))
	#else:
	#	print("Count is off")

func _on_Area_body_exit( body ):
	if body is VehicleBody:
		if body is player_script:
			print("Area exited by the player")
			player = body
			if not finish:
				var msg = body.get_node("Messages")
				msg.hide()
				
func spawn_finish(start):
	print("Should be spawning finish")
	var loc = target
	var our = preload("res://objects/race_marker.tscn")
	var finish = our.instance()
	finish.set_name("Finish")
	finish.set_translation(loc)
	finish.finish = true
	finish.start = start
	#finish.set_val(true)
	
	get_parent().add_child(finish)

# differences to normal marker start here
func spawn_racer(loc):
	car = racer.instance()
	car.set_name("Racer")
	
	# find the root of the scene
	var cars = player.get_parent().get_parent()
	
	car.set_translation(get_translation()+loc)
	car.target = target

	#car.race = self

	car.left = false
	
	cars.add_child(car)
	print("Added the car")