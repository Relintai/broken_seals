extends Control

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export(PackedScene) var bag_scene : PackedScene
export(NodePath) var container_path : NodePath = "BagContainerFrame"

var container : Control

func _ready() -> void:
	container = get_node(container_path) as Control
