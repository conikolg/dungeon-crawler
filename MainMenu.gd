extends Control


# Instance variables
onready var select_connection_tree = $MarginContainer/CenterContainer/SelectConnection
onready var local_server_btn = $MarginContainer/CenterContainer/SelectConnection/Local
onready var remote_server_btn = $MarginContainer/CenterContainer/SelectConnection/Remote

onready var enter_server_tree = $MarginContainer/CenterContainer/EnterServer
onready var server_ip_text = $MarginContainer/CenterContainer/EnterServer/ServerIP
onready var connect_server_btn = $MarginContainer/CenterContainer/EnterServer/ConnectServer
onready var back_btn = $MarginContainer/BackButton


# Called when the node enters the scene tree for the first time.
func _ready():
	self.select_connection_tree.visible = true
	self.enter_server_tree.visible = false
	self.back_btn.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Local_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_Connect_pressed():
	self.select_connection_tree.visible = false
	self.enter_server_tree.visible = true
	self.back_btn.visible = true


func _on_ConnectServer_pressed():
	print("Trying to connect to '%s' " % self.server_ip_text.text)


func _on_BackButton_pressed():
	self.select_connection_tree.visible = true
	self.enter_server_tree.visible = false
	self.back_btn.visible = false
