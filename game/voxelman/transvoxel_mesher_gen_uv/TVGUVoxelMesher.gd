extends VoxelMesherTransvoxel
class_name TVGUVoxelMesher

# Copyright Péter Magyar relintai@gmail.com
# MIT License, might be merged into the Voxelman engine module

# Copyright (c) 2019-2020 Péter Magyar

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

var count : int = 0

var equivalence_classes_data : Array = [
	0, 1, 1, 2, 1, 2, 3, 4, #7
	1, 3, 2, 4, 2, 4, 4, 5, #15
	1, 2, 3, 4, 3, 4, 6, 7, #23
	3, 8, 8, 9, 8, 10, 11, 12, #31
	1, 3, 2, 4, 3, 8, 8, 10, #39
	3, 6, 4, 7, 8, 11, 9, 12, #47
	2, 4, 4, 5, 8, 9, 11, 12, #55
	8, 11, 10, 12, 13, 14, 14, #62
	2, 1, 3, 3, 8, 2, 4, 8, #70
	9, 3, 6, 8, 11, 4, 7, 10, #78
	12, 2, 4, 8, 10, 4, 5, #85
	11, 12, 8, 11, 13, 14, #91
	9, 12, 14, 2, #95
	0, 0, 0, 0, 0, 0, 0, 0, 0, #104
	15, #105
	0, #106
	16, #107
	0, 0, 0, #110
	17, #111
	0, 0, 0, 0, 0, 0, 0, 0, 0, #120
	0, 0, 0, 0, 0, #125
	3, #126
	1, #127
]

var vertices_data : Array = [
	[],
	#1
	[ Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0, 0.5) ],
	#2
	[ Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0) ],
	#3
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0) ],
	#4
	[ Vector3(0.5, 0, 0), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0) ],
	#5
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0) ],
	#6
	[ Vector3(-0.5, 0, 0), Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), 
		Vector3(0.5, 0, 0), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0) ],
	#7
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), 
		Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, 0.5), Vector3(0.5, 0, 0) ],
	#8
	[ Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#9
	[ Vector3(0, 0, 0.5), Vector3(0.5, 0, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#10
	[ Vector3(-0.5, 0, 0), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0) ],
	#11
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), 
		Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), 
		Vector3(-0.5, 0, 0), Vector3(0, 0, 0.5) ],
	#12
	[ Vector3(0, 0, -0.5), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0) ],
	#13
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), 
		Vector3(0.5, 0, 0), Vector3(0, 0, -0.5), 
		Vector3(0, 0.5, 0), Vector3(0, 0.5, 0) ],
	#14
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), 
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), 
		Vector3(0, 0.5, 0), Vector3(0, 0.5, 0) ],
	#15
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0) ],
	#16
	[ Vector3(0, 0, 0.5), Vector3(0, -0.5, 0), Vector3(0.5, 0, 0) ],
	#17
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0) ],
	#18
	[ Vector3(0.5, 0, 0), Vector3(0, 0, 0.5), Vector3(0, -0.5, 0),
		Vector3(-0.5, 0, 0), Vector3(0, 0, 0.5), Vector3(0, 0.5, 0) ],
	#19
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), 
		Vector3(0.5, 0, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, 0.5), Vector3(0, 0, 0.5) ],
	#20
	[ Vector3(0, 0, 0.5), Vector3(0, -0.5, 0), Vector3(0.5, 0, 0),
		Vector3(0, 0.5, 0), Vector3(0.5, 0, 0), Vector3(0, 0, -0.5) ],
	#21
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), 
		Vector3(0, 0.5, 0), Vector3(0, 0, 0.5),
		Vector3(0.5, 0, 0), Vector3(0.5, 0, 0) ],
	#22
	[ Vector3(0.5, 0, 0), Vector3(0, 0, 0.5), Vector3(0, -0.5, 0), 
		Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0), 
		Vector3(0.5, 0, 0), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0) ],
	#23
	[ Vector3(0.5, 0, 0), Vector3(0, 0, 0.5),  
		Vector3(0, 0.5, 0), Vector3(0, 0, 0.5), 
		Vector3(0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#24
	[ Vector3(0.5, 0, 0), Vector3(0, 0, 0.5), Vector3(0, -0.5, 0),
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#25
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0),
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#26
	[ Vector3(-0.5, 0, 0), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, 0.5), Vector3(0, -0.5, 0), Vector3(0.5, 0, 0) ],
	#27
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0), 
		Vector3(0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#28
	[ Vector3(0, 0, -0.5), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, 0.5), Vector3(0, -0.5, 0), Vector3(0.5, 0, 0) ],
	#29
	[ Vector3(0.5, 0, 0), Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), 
		Vector3(0, 0, 0.5), Vector3(0, 0.5, 0) ],
	#30
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), 
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), 
		Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, 0.5), Vector3(0, -0.5, 0), Vector3(0.5, 0, 0) ],
	#31
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, 0.5),  Vector3(0.5, 0, 0) ],
	#32
	[ Vector3(-0.5, 0, 0), Vector3(0, -0.5, 0), Vector3(0, 0, 0.5) ],
	#33
	[ Vector3(0, 0, 0.5), Vector3(0.5, 0, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, 0.5), Vector3(-0.5, 0, 0), Vector3(0, -0.5, 0) ],
	#34
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(-0.5, 0, 0), Vector3(-0.5, 0, 0) ],
	#35
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), 
		Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0),
		Vector3(0, 0, 0.5), Vector3(0, 0, 0.5) ],
	#36
	[ Vector3(-0.5, 0, 0), Vector3(0, -0.5, 0), Vector3(0, 0, 0.5),
		Vector3(0, 0.5, 0), Vector3(0.5, 0, 0), Vector3(0, 0, -0.5) ],
	#37
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(-0.5, 0, 0), Vector3(0, -0.5, 0), Vector3(0, 0, 0.5) ],
	#38
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(-0.5, 0, 0), Vector3(-0.5, 0, 0),
		Vector3(0.5, 0, 0), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0) ],
	#39
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), 
		Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#40
	[ Vector3(-0.5, 0, 0), Vector3(0, -0.5, 0), Vector3(0, 0, 0.5),
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#41
	[ Vector3(-0.5, 0, 0), Vector3(0, -0.5, 0), Vector3(0, 0, 0.5), 
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0), 
		Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0, 0.5) ],
	#42
	[ Vector3(-0.5, 0, 0), Vector3(-0.5, 0, 0), Vector3(-0.5, 0, 0),
		Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), 
		Vector3(-0.5, 0, 0), Vector3(-0.5, 0, 0) ],
	#43
	[  Vector3(0, 0, 0.5), Vector3(-0.5, 0, 0), 
		Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0), 
		Vector3(0, 0, 0.5), Vector3(0, 0.5, 0) ],
	#44
	[Vector3(0, 0, -0.5), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(-0.5, 0, 0), Vector3(0, -0.5, 0), Vector3(0, 0, 0.5) ],
	#45
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), 
		Vector3(0.5, 0, 0), Vector3(0, 0, -0.5), 
		Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(-0.5, 0, 0), Vector3(0, -0.5, 0), Vector3(0, 0, 0.5) ],
	#46
	[ Vector3(-0.5, 0, 0), Vector3(-0.5, 0, 0),  
		Vector3(0, 0, -0.5), Vector3(0, 0.5, 0), 
		Vector3(0, 0, 0.5), Vector3(0, 0.5, 0) ],
	#47
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(-0.5, 0, 0), Vector3(0, 0, 0.5) ],
	#48
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, -0.5, 0), Vector3(0, -0.5, 0) ],
	#49
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), 
		Vector3(0, -0.5, 0), Vector3(0.5, 0, 0),
		Vector3(0, 0, 0.5), Vector3(0, 0, 0.5) ],
	#50
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), 
		Vector3(-0.5, 0, 0), Vector3(0, -0.5, 0),
		Vector3(0, 0, 0.5), Vector3(0, 0, 0.5) ],
	#51
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5) ],
	#52
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, -0.5, 0), Vector3(0, -0.5, 0),
		Vector3(0.5, 0, 0), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0) ],
	#53
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), Vector3(0.5, 0, 0), 
		Vector3(0, -0.5, 0), Vector3(0.5, 0, 0) ],
	#54
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), 
		Vector3(-0.5, 0, 0), Vector3(0, -0.5, 0),
		Vector3(0, 0, 0.5), Vector3(0, 0, 0.5),
		Vector3(0.5, 0, 0), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0) ],
	#55
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5),
		Vector3(0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#56
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, -0.5, 0), Vector3(0, -0.5, 0),
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#57
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), 
		Vector3(0, -0.5, 0), Vector3(0.5, 0, 0),
		Vector3(0, 0, 0.5), Vector3(0, 0, 0.5),
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#58
	[ Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), Vector3(0, 0, 0.5), Vector3(-0.5, 0, 0), 
		Vector3(0, -0.5, 0), Vector3(-0.5, 0, 0) ],
	#59
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5),
		Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0) ],
	#60
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, -0.5, 0), Vector3(0, -0.5, 0),
		Vector3(0, 0, -0.5), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0) ],
	#61
	[ Vector3(0.5, 0, 0), Vector3(0, -0.5, 0), Vector3(0, 0, 0.5),
		Vector3(0.5, 0, 0), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5),
		Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0, 0.5),
		Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0, -0.5) ],
	#62
	[ Vector3(-0.5, 0, 0), Vector3(0, 0, 0.5), Vector3(0, -0.5, 0),
		Vector3(-0.5, 0, 0), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5),
		Vector3(-0.5, 0, 0), Vector3(0, 0, 0.5), Vector3(0, 0.5, 0),
		Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(-0.5, 0, 0), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0) ],
	#63
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5) ],
	#64
	[ Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0) ],
	#65
	[ Vector3(0, 0, 0.5), Vector3(0.5, 0, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0) ],
	#66
	[ Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0),
		Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0) ],
	#67
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0) ],
	#68
	[ Vector3(0, 0, -0.5), Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0) ],
	#69
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), 
		Vector3(0, 0, -0.5), Vector3(0, 0.5, 0),
		Vector3(0.5, 0, 0), Vector3(0.5, 0, 0) ],
	#70
	[ Vector3(0, 0, -0.5), Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0),
		Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0) ],
	#71
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), 
		Vector3(0, 0, -0.5), Vector3(0, 0.5, 0) ],
	#72
	[ Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0), 
		Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0) ],
	#73
	[ Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0), 
		Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0, 0.5), 
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#74
	[ Vector3(-0.5, 0, 0), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0) ],
	#75
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), 
		Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), 
		Vector3(-0.5, 0, 0), Vector3(0, 0, 0.5),
		Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0) ],
	#76
	[ Vector3(0, 0, -0.5), Vector3(0, 0, -0.5), Vector3(0, 0, -0.5), 
		Vector3(0, 0.5, 0), Vector3(0.5, 0, 0),
		Vector3(0, 0, -0.5), Vector3(0, 0, -0.5) ],
	#77
	[ Vector3(0, 0, -0.5), Vector3(0.5, 0, 0),  
		Vector3(0, 0.5, 0), Vector3(0.5, 0, 0), 
		Vector3(0, 0, -0.5), Vector3(0, 0.5, 0) ],
	#78
	[ Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0), 
		Vector3(0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#79
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0.5, 0, 0), Vector3(0, 0, -0.5) ],
	#80
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0), Vector3(0, -0.5, 0) ],
	#81
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), 
		Vector3(0, 0, 0.5), Vector3(0, 0, 0.5),
		Vector3(0.5, 0, 0), Vector3(0.5, 0, 0) ],
	#82
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0), Vector3(0, -0.5, 0),
		Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0) ],
	#83
	[ Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0.5, 0, 0), Vector3(0, 0, 0.5), 
		Vector3(0, -0.5, 0), Vector3(0, 0, 0.5) ],
	#84
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), 
		Vector3(0, -0.5, 0), Vector3(0, 0, -0.5),
		Vector3(0.5, 0, 0), Vector3(0.5, 0, 0) ],
	#85
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0) ],
	#86
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), 
		Vector3(0, -0.5, 0), Vector3(0, 0, -0.5),
		Vector3(0.5, 0, 0), Vector3(0.5, 0, 0),
		Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0) ],
	#87
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0),
		Vector3(0, 0.5, 0), Vector3(0, 0, 0.5) ],
	#88
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0), Vector3(0, -0.5, 0),
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#89
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), 
		Vector3(0, 0, 0.5), Vector3(0, 0, 0.5),
		Vector3(0.5, 0, 0), Vector3(0.5, 0, 0),
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#90
	[ Vector3(-0.5, 0, 0), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0, -0.5, 0), Vector3(0, -0.5, 0), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0) ],
	#91
	[ Vector3(0, 0, 0.5), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0),
		Vector3(0, 0, 0.5), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0),
		Vector3(0, 0, 0.5), Vector3(0.5, 0, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, 0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#92
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0, -0.5), 
		Vector3(0, -0.5, 0), Vector3(0, 0, -0.5) ],
	#93
	[ Vector3(0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0),
		Vector3(0, 0, -0.5), Vector3(0, 0.5, 0) ],
	#94
	[ Vector3(0, 0, -0.5), Vector3(0, -0.5, 0), Vector3(0.5, 0, 0),
		Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0),
		Vector3(0, 0, -0.5), Vector3(0, 0.5, 0), Vector3(0.5, 0, 0),
		Vector3(0, 0, -0.5), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, -0.5), Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0) ],
	#95
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0) ],
	[], [], [], [], [], [], [], [], [], #104
	#105
	[ Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0, 0.5), 
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0),
		Vector3(-0.5, 0, 0), Vector3(0, -0.5, 0), Vector3(0, 0, 0.5),
		Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0) ],
	[], #106
	#107
	[ Vector3(0, 0, 0.5), Vector3(-0.5, 0, 0), 
		Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0), 
		Vector3(0, 0, 0.5), Vector3(0, 0.5, 0),
		Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0) ],
	[], [], [], #110
	#111
	[ Vector3(0, 0.5, 0), Vector3(0.5, 0, 0), Vector3(0, 0, -0.5),
		Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0), Vector3(0, 0, 0.5),
		Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0.5, 0), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0) ],
	[], [], [], [], [], [], [], [], [], #120
	[], [], [], [], [], #125
	#126
	[ Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0, 0.5),
		Vector3(0, 0, -0.5), Vector3(0, -0.5, 0), Vector3(-0.5, 0, 0) ],
	#127
	[ Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0, 0.5) ],
]

var vertex_corner_data : Array = [
	[],
	#1
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000 ],
	#2
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100 ],
	#3
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_100 ],
	#4
	[ VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001 ],
	#5
	[ VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_000 ],
	#6
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001 ],
	#7
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_100, 
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_001 ],
	#8
	[ VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#9
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#10
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_101 ],
	#11
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_101, 
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_101, 
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_000 ],
	#12
	[ VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_001 ],
	#13
	[ VOXEL_ENTRY_INDEX_001 , VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_000, 
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_101, 
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_000 ],
	#14
	[ VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_001, 
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_100, 
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_001 ],
	#15
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_101 ],
	#16
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010 ],
	#17
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_000 ],
	#18
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100 ],
	#19
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_010, 
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_010 ],
	#20
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001 ],
	#21
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_001, 
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_001 ],
	#22
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001 ],
	#23
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001 ],
	#24
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#25
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#26
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010 ],
	#27
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_100 ],
	#28 
	[ VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_001,
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010 ],
	#29
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_001 ],
	#30
	[ VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_001, 
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_100, 
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_001,
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010 ],
	#31
	[ VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010 ],
	#32
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110 ],
	#33
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110 ],
	#34
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_110 ],
	#35
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_000, 
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_000 ],
	#36
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001 ],
	#37
	[ VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110 ],
	#38
	[  VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001 ],
	#39
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_001,
		VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_000 ],
	#40
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#41
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000 ],
	#42
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_110, 
		VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_110 ],
	#43
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000 ],
	#44
	[ VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_001,
		VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110 ],
	#45
	[ VOXEL_ENTRY_INDEX_001 , VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_000, 
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_101, 
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110 ],
	#46
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001,
		VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_101 ],
	#47
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110 ],
	#48
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_010 ],
	#49
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_110, 
		VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_110 ],
	#50
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_100, 
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_100 ],
	#51
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_100 ],
	#52
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001 ],
	#53
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001,
		VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_000 ],
	#54
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_100, 
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001 ],
	#55
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001 ],
	#56
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#57
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_110, 
		VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#58
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_100 ],
	#59
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#60
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_001 ],
	#61
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_001,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#62
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_001,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001 ],
	#63
	[ VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_110 ],
	#64
	[ VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011 ],
	#65
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011 ],
	#66
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011 ],
	#67
	[  VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011 ],
	#68
	[ VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_011 ],
	#69
	[ VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_011, 
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_011 ],
	#70
	[ VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_011,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100 ],
	#71
	[ VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_000 ],
	#72
	[ VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011 ],
	#73
	[ VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#74
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011 ],
	#75
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_101, 
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_101, 
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011 ],
	#76
	[ VOXEL_ENTRY_INDEX_001,  VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_011,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_101 ],
	#77
	[ VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#78
	[ VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_101 ],
	#79
	[ VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011 ],
	#80
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_011 ],
	#81
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_000, 
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_011,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_000 ],
	#82
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_011,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100 ],
	#83
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_000 ],
	#84
	[ VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_010, 
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_001,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_010 ],
	#85
	[ VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_000 ],
	#86
	[ VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_010, 
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_001,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100 ],
	#87
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_001,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100 ],
	#88
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_011,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#89
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_000, 
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_011,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#90
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_010 ],
	#91
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#92
	[ VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_001 ],
	#93
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_011,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#94
	[ VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_011,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100 ],
	#95
	[ VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_010 ],
	[], [], [], [], [], [], [], [], [], #104
	#105
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011 ],
	[], #106
	#107
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011 ],
	[], [], [], #110
	#111
	[ VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110, 
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_000, 
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_000 ],
	[], [], [], [], [], [], [], [], [], #120
	[], [], [], [], [], #125
	#126
	[ VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_100 ],
	#127
	[ VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_110 ],
]

var indices_data : Array = [
	[],
	[ 0, 2, 1 ], #1
	[ 0, 2, 1, 1, 2, 3 ], #2
	[ 0, 2, 1,  3, 5, 4 ], #3
	[ 0, 2, 1,  5, 3, 4,  6, 3, 5 ], #4
	[ 0, 1, 2, 2, 1, 3 ], #5
	[ 0, 2, 1,  3, 5, 4,  6, 8, 7 ], #6
	[ 0, 2, 1,  1, 2, 3,  1, 3, 4,  1, 4, 5 ], #7
	[ 0, 2, 1, 1, 2, 3,  4, 6, 5 ], #8
	[ 0, 1, 2,  2, 1, 3,  1, 4, 3,  3, 4, 5 ], #9
	[ 0, 1, 2,  2, 1, 3,  4, 2, 3,  4, 3, 5 ], #10
	[ 0, 2, 1,  5, 3, 4,  6, 3, 5,  7, 9, 8 ], #00
	[ 0, 3, 1,  1, 3, 4,  1, 4, 2 ], #12
	[ 0, 2, 1, 1, 2, 3,  4, 6, 5, 5, 6, 7 ], #13
	[ 0, 2, 1,  3, 4, 5,  6, 7, 8,  9, 10, 11,  12, 14, 13 ], #14
	[ 0, 2, 1,  3, 5, 4,  6, 8, 7,  9, 11, 10 ], #15
	[ 0, 2, 1,  1, 2, 3,  1, 3, 4,  1, 4, 5,  6, 8, 7 ], #16
	[ 0, 1, 2,  3, 4, 5,  6, 8, 7, 9, 10, 11 ], #17
]

var uv_data : Array = [
	[],
	#1
	[ Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#2
	[ Vector2(0, 0), Vector2(-0.5, 0), Vector2(0, 0.5), Vector2(-0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#3
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#4
	[ Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
		Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
		Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#5
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ], #top
	#6
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#7
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ], #left
	#8
	[ Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#9
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#10
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#11
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#12
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#13
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ], #left
	#14
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ], #left
	#15
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#16
	[ Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#17
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#18
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#19
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5), ], #left
	#20
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#21
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5), ], #left
	#22
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#23
	[ Vector2(0, 0), Vector2(0, 0),
		Vector2(0, 0), Vector2(0, 0),
		Vector2(0, 0), Vector2(0, 0), ],
	#24
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#25
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#26
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#27
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#28
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#29
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#30
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#31
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#32
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#33
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#34
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
]

var vector_start_position_data : Array = [
	Vector3(0, 0, 0),
	Vector3(1, 0, 0),
	Vector3(0, 0, 1),
	Vector3(1, 0, 1),
	
	Vector3(0, 1, 0),
	Vector3(1, 1, 0),
	Vector3(0, 1, 1),
	Vector3(1, 1, 1),
]

var uv_scale_direction_data_old : Array = [
	[],
	#1
	[ Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#2
	[ Vector2(0, 0), Vector2(-0.5, 0), Vector2(0, 0.5), Vector2(-0.5, 0.5) ],
	#3
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ],
	#4
	[ Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
		Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
		Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#5
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0) ], #top
	#6
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0) ],
	#7
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5), ], #left
	#8
	[ Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5) ],
	#9
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#10
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0) ],
	#11
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0) ],
	#12
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ],
	#13
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5), ], #left
	#14
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5), ], #left
	#15
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ],
	#16
	[ Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
		Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
		Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
		Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5) ],
	#17
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ],
	#18
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#19
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5), ], #left
	#20
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#21
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5), ], #left
	#22
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#23
	[ Vector2(0, 0), Vector2(0, 0),
		Vector2(0, 0), Vector2(0, 0),
		Vector2(0, 0), Vector2(0, 0) ],
	#24
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#25
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#26
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#27
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#28
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#29
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#30
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#31
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#32
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#33
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#34
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
]

var uv_scale_direction_data : Array = [
	[],
	#1
	[ Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ],
	#2
	[ Vector2(0, 0), Vector2(-0.5, 0), Vector2(0, 0.5), Vector2(-0.5, 0.5),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ],
	#3
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ],
	#4
	[ Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
		Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
		Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ],
	#5
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ], #top
	#6
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ],
	#7
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ], #left
	#8
	[ Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ],
	#9
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ],
	#10
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ],
	#11
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ],
	#12
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ],
	#13
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ], #left
	#14
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ], #left
	#15
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ],
	#16
	[ Vector2(0, 0), Vector2(0.5, 0), Vector2(0, 0.5), Vector2(0.5, 0.5),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ],
	#17
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), 
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ],
	#18
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),],
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
	#19
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ], #left
	#20
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), ],
	#21
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0), Vector2(0.5, 0), #back
		Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5), ], #left
	#22
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#23
	[ Vector2(0, 0), Vector2(0, 0),
		Vector2(0, 0), Vector2(0, 0),
		Vector2(0, 0), Vector2(0, 0) ],
	#24
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#25
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#26
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#27
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#28
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#29
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#30
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#31
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#32
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#33
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5) ,
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
	#34
	[ Vector2(0, 0), Vector2(0, 0), Vector2(0, 0.5), Vector2(0, 0.5),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0),
		Vector2(0, 0), Vector2(0, 0), Vector2(0.5, 0) ],
]


#
#var uv_entries_data : Array = [
#	[ 0, 0 ], #0
#	[ 1, 0 ], #1
#	[ 0, 1 ], #2
#	[ 1, 1 ], #3
#]

func get_case_code(buffer : VoxelChunk, x : int, y : int, z : int, size : int = 1) -> int:
	var case_code : int = 0
	
	if (buffer.get_voxel(x, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_000
		
	if (buffer.get_voxel(x, y + size, z, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_010
		
	if (buffer.get_voxel(x, y, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_001
		
	if (buffer.get_voxel(x, y + size, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_011
		
	if (buffer.get_voxel(x + size, y, z, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_100
		
	if (buffer.get_voxel(x + size, y + size, z, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_110
		
	if (buffer.get_voxel(x + size, y, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_101
		
	if (buffer.get_voxel(x + size, y + size, z + size, VoxelChunk.DEFAULT_CHANNEL_TYPE) != 0):
		case_code = case_code | VOXEL_ENTRY_MASK_111
		
	return case_code
		
func _add_chunk(buffer : VoxelChunk) -> void:
	var x_size : int = buffer.get_size_x() - 1
	var y_size : int = buffer.get_size_y() - 1
	var z_size : int = buffer.get_size_z() - 1
	
	var uv_rect : float = 1 / 8.0
	
	for y in range(0, y_size, lod_size):
		for z in range(0, z_size, lod_size):
			for x in range(0, x_size, lod_size):
				var case_code : int = get_case_code(buffer, x, y, z, lod_size)
				
				if case_code == 0 or case_code == 255:
					continue
				
				#todo remove, after the tables are done.
				if case_code >= vertices_data.size():
					continue
				
				var equivalence_class : int = equivalence_classes_data[case_code]
				
				var vertices : Array = vertices_data[case_code]
				var indices : Array = indices_data[equivalence_class]
				var uvs : Array = uv_data[equivalence_class]
				var vertex_corner_owners : Array = vertex_corner_data[case_code]
				var uv_scale_directions : Array = uv_scale_direction_data[equivalence_class]
				
				
				var index_count : int = len(indices)
				var vertex_count : int = len(vertices)
				#var uv_count : int = len(uvs)
				#var vertex_corner_owners_count : int = len(vertex_corner_owners)
				
				var fill_values : Array = [
					buffer.get_voxel(x, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL), 
					buffer.get_voxel(x + lod_size, y, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL), 
					buffer.get_voxel(x, y, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL), 
					buffer.get_voxel(x + lod_size, y, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL), 
					buffer.get_voxel(x, y + lod_size, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL), 
					buffer.get_voxel(x + lod_size, y + lod_size, z, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL), 
					buffer.get_voxel(x, y + lod_size, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL), 
					buffer.get_voxel(x + lod_size, y + lod_size, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_ISOLEVEL), 
				]
				
				var ao_strength_arr : Array = [
					buffer.get_voxel(x, y, z, VoxelChunk.DEFAULT_CHANNEL_AO), 
					buffer.get_voxel(x + lod_size, y, z, VoxelChunk.DEFAULT_CHANNEL_AO), 
					buffer.get_voxel(x, y, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_AO), 
					buffer.get_voxel(x + lod_size, y, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_AO), 
					buffer.get_voxel(x, y + lod_size, z, VoxelChunk.DEFAULT_CHANNEL_AO), 
					buffer.get_voxel(x + lod_size, y + lod_size, z, VoxelChunk.DEFAULT_CHANNEL_AO), 
					buffer.get_voxel(x, y + lod_size, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_AO), 
					buffer.get_voxel(x + lod_size, y + lod_size, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_AO), 
				]
				
				var colors : Array = [
					Color(buffer.get_voxel(x, y, z, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_R), buffer.get_voxel(x, y, z, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_G), buffer.get_voxel(x, y, z, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_B)), 
					Color(buffer.get_voxel(x + lod_size, y, z, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_R), buffer.get_voxel(x + lod_size, y, z, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_G), buffer.get_voxel(x + lod_size, y, z, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_B)), 
					Color(buffer.get_voxel(x, y, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_R), buffer.get_voxel(x, y, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_G),buffer.get_voxel(x, y, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_B)), 
					Color(buffer.get_voxel(x + lod_size, y, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_R), buffer.get_voxel(x + lod_size, y, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_G), buffer.get_voxel(x + lod_size, y, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_B)),
					Color(buffer.get_voxel(x, y + lod_size, z, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_R), buffer.get_voxel(x, y + lod_size, z, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_G), buffer.get_voxel(x, y + lod_size, z, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_B)),
					Color(buffer.get_voxel(x + lod_size, y + lod_size, z, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_R), buffer.get_voxel(x + lod_size, y + lod_size, z, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_G), buffer.get_voxel(x + lod_size, y + lod_size, z, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_B)),
					Color(buffer.get_voxel(x, y + lod_size, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_R), buffer.get_voxel(x, y + lod_size, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_G), buffer.get_voxel(x, y + lod_size, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_B)),
					Color(buffer.get_voxel(x + lod_size, y + lod_size, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_R), buffer.get_voxel(x + lod_size, y + lod_size, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_G), buffer.get_voxel(x + lod_size, y + lod_size, z + lod_size, VoxelChunk.DEFAULT_CHANNEL_LIGHT_COLOR_B))
				]
				
				for i in range(index_count):
					var ind : int = get_vertex_count() + indices[i]
					add_indices(ind)
			
				for i in range(vertex_count):
					
					var owner_corner : int = vertex_corner_owners[i]
					
					var start_position : Vector3 = vector_start_position_data[owner_corner]
					var fill_byte : int = fill_values[owner_corner]
					var fill : float = fill_byte / 255.0
					
#					var color : Color = colors[owner_corner]
#					var ao_val : float = ao_strength_arr[owner_corner] * ao_strength
#					var ao : Color = Color(ao_val, ao_val, ao_val) 
#
#					color = color - ao
#
#					color.r = clamp(color.r, 0, 1.0)
#					color.g = clamp(color.g, 0, 1.0)
#					color.b = clamp(color.b, 0, 1.0)

					var color : Color = Color(1, 1, 1)

					add_color(color)
					
					var uv_scale_direction : Vector2 = uv_scale_directions[i] as Vector2
					
					var uv : Vector2 = uvs[i] as Vector2
					#uv *= fill
					
					uv += uv_scale_direction * fill
					
					uv *= uv_rect
					
					add_uv(uv)

					var vert_pos : Vector3 = vertices[i] as Vector3
					vert_pos *= fill
					
					vert_pos += start_position
					
					vert_pos += Vector3(x, y, z)
					vert_pos *= float(voxel_scale)
					
					add_vertex(vert_pos)

	
func create_Debug_triangle(position : Vector3):
	add_indices(get_indices_count())
	add_vertex(position)
	add_indices(get_indices_count())
	add_vertex(position + Vector3(2, 0, 0))
	add_indices(get_indices_count())
	add_vertex(position + Vector3(0, 0, 2))
	
	print(get_vertex_count())
	
	
