extends Node2D

var interval = 2
var trials = 20
var nbackSize = 2
var percentage = 20
var leeway = 2

var ms2 = 0
var s2 = 0
var m2 = 0
var rng = RandomNumberGenerator.new()
var rng2 = RandomNumberGenerator.new()
var rng3 = RandomNumberGenerator.new()
var rng4 = RandomNumberGenerator.new()
var rng5 = RandomNumberGenerator.new()
var white = Color(1, 1, 1)
var black = Color(0, 0, 0)
var red = Color(1, 0, 0)
var num = 2
var prev = 1
var time_elapsed = 0
var loop_time_elapsed = 0
var array = [3, 4, 5, 6, 7, 8]
var condition = "none"
var score = 0
var reenterInterval = interval - 0.1
var nbackCount = 0
var noneCount = 0
var totalCount = 0
var spaceKeyCount = 0
var correctPresses = 0
var incorrectPreses = 0
var hitInterval = int(100/percentage)
var hitIntervalBy2 = int(hitInterval/2)
var arr1 = []
var hitIndexArr = []
var hitIndexArrStr = ""
var hitNum
var hitPerc
var gameEnd = false

func generateArray():
	var k1 = 0
	var tempOffset
	while k1 < trials:
		rng3.randomize()
		arr1.append(rng3.randi_range(1, 8))
		k1 = k1 + 1
	k1 = 0
	while k1 < trials-nbackSize:
		if k1%hitInterval == 0:
			rng4.randomize()
			tempOffset = rng4.randi_range(-leeway, leeway)
			if (k1+tempOffset+hitIntervalBy2+nbackSize > trials-1 or k1+tempOffset+hitIntervalBy2 < 0):
				arr1[k1-tempOffset+hitIntervalBy2+nbackSize] = arr1[k1-tempOffset+hitIntervalBy2]
				hitIndexArr.append(k1-tempOffset+hitIntervalBy2)
			else:
				arr1[k1+tempOffset+hitIntervalBy2+nbackSize] = arr1[k1+tempOffset+hitIntervalBy2]
				hitIndexArr.append(k1+tempOffset+hitIntervalBy2)
		k1 = k1 + 1
	k1 = 0
	while k1 < trials-nbackSize:
		if !(k1 in hitIndexArr):
			while (arr1[k1+nbackSize] == arr1[k1]):
				rng5.randomize()
				arr1[k1+nbackSize] = rng5.randi_range(1, 8)
		k1 = k1 + 1
		
func calcHit():
	var k2=0
	while (k2<hitIndexArr.size()):
		hitIndexArrStr = hitIndexArrStr + str(hitIndexArr[k2]+nbackSize) + " "
		k2 = k2 + 1
	hitNum = hitIndexArr.size()
	hitPerc = int(100*hitNum/trials)
	
func _enter_tree():
	var arguments = {}
	for argument in OS.get_cmdline_args():
		# Parse valid command-line arguments into a dictionary
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
	if "interval" in arguments:
		interval=int(arguments["interval"])
	if "trials" in arguments:
		trials=int(arguments["trials"])
	if "nbackSize" in arguments:
		nbackSize=int(arguments["nbackSize"])
	if "percentage" in arguments:
		percentage=int(arguments["percentage"])
	if "leeway" in arguments:
		leeway=int(arguments["leeway"])
	reenterInterval = interval - 0.1
	hitInterval = int(100/percentage)
	hitIntervalBy2 = int(hitInterval/2)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	$"Sprite1".modulate = white
	$"Sprite2".modulate = white
	$"Sprite3".modulate = white
	$"Sprite4".modulate = white
	$"Sprite5".modulate = white
	$"Sprite6".modulate = white
	$"Sprite7".modulate = white
	$"Sprite8".modulate = white
	generateArray()
	
func _process(delta):
	$"RichTextLabel".set_text(str(score))
	time_elapsed += delta
	if ms2 > 9:
		s2 += 1
		ms2 = 0
	if s2 > 59:
		m2 += 1
		s2 = 0
	if s2 % interval == 0 and time_elapsed-loop_time_elapsed>reenterInterval and totalCount<trials:
		loop_time_elapsed = time_elapsed
		if (totalCount>0):
			get_node("Sprite"+str(arr1[totalCount-1])).modulate = white
		#var temp_num = array[rng.randi_range(0, 5)]
		#50% probability of getting previous number, change following 2 lines to change this probability
		#var temp_arr = [temp_num, prev]
		#temp_num = temp_arr[rng2.randi_range(0, 1)]
		#if temp_num in array:
		#	array.erase(temp_num)
		#	array.append(prev)
		#if temp_num == prev:
		#	condition = "nback"
		#	nbackCount = nbackCount + 1
		#else:
		#	condition = "none"
		#	noneCount = noneCount + 1
		if arr1[totalCount] == arr1[totalCount-nbackSize] and totalCount>=nbackSize:
			condition = "nback"
			nbackCount = nbackCount + 1
		else:
			condition = "none"
			noneCount = noneCount + 1
		get_node("Sprite"+str(arr1[totalCount])).modulate = red
		totalCount = totalCount + 1
		#prev = num
		#num = temp_num
		anim1()
		
	if totalCount == trials and gameEnd == false and time_elapsed>=(trials+2)*interval:
		$"Sprite1".visible = false
		$"Sprite2".visible = false
		$"Sprite3".visible = false
		$"Sprite4".visible = false
		$"Sprite5".visible = false
		$"Sprite6".visible = false
		$"Sprite7".visible = false
		$"Sprite8".visible = false
		calcHit()
		$"RichTextLabel".rect_position.x=10
		$"RichTextLabel".rect_position.y=10
		$"RichTextLabel".rect_size.x=500
		$"RichTextLabel".rect_size.y=500
		gameEnd = true
		
	if gameEnd == true:
		$"RichTextLabel".set_text("Your score was : "+str(score)+"["+str(correctPresses)+"-"+str(incorrectPreses)+"]"+"\nInput params : \nIntervals : "+str(interval)+"\nTrials : "+str(trials)+"\nnBack size : "+str(nbackSize)+"\nPercentage : "+str(percentage)+"\nLeeway : "+str(leeway)+"\nHit trials starting from 0 : "+hitIndexArrStr+"\nHit Count Possible : "+str(hitNum)+"\nActual Hit Percentage Possible : "+str(hitPerc))
		

func anim1():
	for i in 4:
		get_node("Sprite"+str(arr1[totalCount-1])).modulate = black
		yield(get_tree(), "idle_frame")
		get_node("Sprite"+str(arr1[totalCount-1])).modulate = red
		yield(get_tree(), "idle_frame")


func _input(event):
	if event.is_action_pressed("space") and time_elapsed>=(nbackSize+1)*interval and spaceKeyCount!=totalCount:
		spaceKeyCount = totalCount
		if condition == "nback":
			score = score + 1
			correctPresses = correctPresses + 1
		else:
			score = score - 1
			incorrectPreses = incorrectPreses + 1

func _on_Timer_timeout():
	ms2 += 1
