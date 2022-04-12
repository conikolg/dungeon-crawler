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
func _ready() -> void:
	self.select_connection_tree.visible = true
	self.enter_server_tree.visible = false
	self.back_btn.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Local_pressed() -> void:
	# Create local server and connect to it as a peer
	Server.startServer()
	Server.connectToServer()
	# Transition to actual game
	self.get_tree().change_scene("res://scenes/Main.tscn")


func _on_Connect_pressed() -> void:
	self.select_connection_tree.visible = false
	self.enter_server_tree.visible = true
	self.back_btn.visible = true


func _on_ConnectServer_pressed() -> void:
	# Do nothing if no server is defined
	if not self.server_ip_text.text:
		print("No server defined.")
		return
	
	# Connect to server as a peer
	print("Trying to connect to '%s' " % self.server_ip_text.text)
	Server.ip = self.server_ip_text.text
	Server.connectToServer()
	# Transition to actual game
	self.get_tree().change_scene("res://scenes/Main.tscn")


func _on_BackButton_pressed() -> void:
	self.select_connection_tree.visible = true
	self.enter_server_tree.visible = false
	self.back_btn.visible = false
