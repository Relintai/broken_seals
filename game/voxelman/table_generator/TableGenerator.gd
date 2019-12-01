extends Control

# Copyright Péter Magyar relintai@gmail.com
# MIT License, might be merged into the Voxelman engine module

# Copyright (c) 2019 Péter Magyar

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

export(NodePath) var text_edit_path : NodePath

const VOXEL_ENTRY_INDEX_000 : int = 0
const VOXEL_ENTRY_INDEX_100 : int = 1
const VOXEL_ENTRY_INDEX_010 : int = 4
const VOXEL_ENTRY_INDEX_110 : int = 5
const VOXEL_ENTRY_INDEX_001 : int = 2
const VOXEL_ENTRY_INDEX_101 : int = 3
const VOXEL_ENTRY_INDEX_011 : int = 6
const VOXEL_ENTRY_INDEX_111 : int = 7
const VOXEL_ENTRIES_SIZE : int = 8

const VOXEL_ENTRY_MASK_000 : int = 1
const VOXEL_ENTRY_MASK_100 : int = 2
const VOXEL_ENTRY_MASK_010 : int = 16
const VOXEL_ENTRY_MASK_110 : int = 32
const VOXEL_ENTRY_MASK_001 : int = 4
const VOXEL_ENTRY_MASK_101 : int = 8
const VOXEL_ENTRY_MASK_011 : int = 64
const VOXEL_ENTRY_MASK_111 : int = 128

var entry_index_x_rotations : Array = [
	VOXEL_ENTRY_INDEX_010, #from VOXEL_ENTRY_INDEX_000
	VOXEL_ENTRY_INDEX_110, #from VOXEL_ENTRY_INDEX_100
	VOXEL_ENTRY_INDEX_000, #from VOXEL_ENTRY_INDEX_001
	VOXEL_ENTRY_INDEX_100, #from VOXEL_ENTRY_INDEX_101
	VOXEL_ENTRY_INDEX_011, #from VOXEL_ENTRY_INDEX_010
	VOXEL_ENTRY_INDEX_111, #from VOXEL_ENTRY_INDEX_110
	VOXEL_ENTRY_INDEX_001, #from VOXEL_ENTRY_INDEX_011
	VOXEL_ENTRY_INDEX_101, #from VOXEL_ENTRY_INDEX_111
]

var entry_index_y_rotations : Array = [
	VOXEL_ENTRY_INDEX_100, #from VOXEL_ENTRY_INDEX_000
	VOXEL_ENTRY_INDEX_101, #from VOXEL_ENTRY_INDEX_100
	VOXEL_ENTRY_INDEX_000, #from VOXEL_ENTRY_INDEX_001
	VOXEL_ENTRY_INDEX_001, #from VOXEL_ENTRY_INDEX_101
	VOXEL_ENTRY_INDEX_110, #from VOXEL_ENTRY_INDEX_010
	VOXEL_ENTRY_INDEX_111, #from VOXEL_ENTRY_INDEX_110
	VOXEL_ENTRY_INDEX_010, #from VOXEL_ENTRY_INDEX_011
	VOXEL_ENTRY_INDEX_011, #from VOXEL_ENTRY_INDEX_111
]

var entry_index_z_rotations : Array = [
	VOXEL_ENTRY_INDEX_100, #from VOXEL_ENTRY_INDEX_000
	VOXEL_ENTRY_INDEX_110, #from VOXEL_ENTRY_INDEX_100
	VOXEL_ENTRY_INDEX_101, #from VOXEL_ENTRY_INDEX_001
	VOXEL_ENTRY_INDEX_111, #from VOXEL_ENTRY_INDEX_101
	VOXEL_ENTRY_INDEX_000, #from VOXEL_ENTRY_INDEX_010
	VOXEL_ENTRY_INDEX_010, #from VOXEL_ENTRY_INDEX_110
	VOXEL_ENTRY_INDEX_001, #from VOXEL_ENTRY_INDEX_011
	VOXEL_ENTRY_INDEX_011, #from VOXEL_ENTRY_INDEX_111
]

var entry_index_names : Array = [
	"VOXEL_ENTRY_INDEX_000", #VOXEL_ENTRY_INDEX_000
	"VOXEL_ENTRY_INDEX_100", #VOXEL_ENTRY_INDEX_100
	"VOXEL_ENTRY_INDEX_001", #VOXEL_ENTRY_INDEX_001
	"VOXEL_ENTRY_INDEX_101", #VOXEL_ENTRY_INDEX_101
	"VOXEL_ENTRY_INDEX_010", #VOXEL_ENTRY_INDEX_010
	"VOXEL_ENTRY_INDEX_110", #VOXEL_ENTRY_INDEX_110
	"VOXEL_ENTRY_INDEX_011", #VOXEL_ENTRY_INDEX_011
	"VOXEL_ENTRY_INDEX_111", #VOXEL_ENTRY_INDEX_111
]

var class_match_table : Array = [
	0, #0
	VOXEL_ENTRY_MASK_000, #1
	VOXEL_ENTRY_MASK_000 | VOXEL_ENTRY_MASK_100, #2
	VOXEL_ENTRY_MASK_100 | VOXEL_ENTRY_MASK_001, #3
	VOXEL_ENTRY_MASK_000 | VOXEL_ENTRY_MASK_100 | VOXEL_ENTRY_MASK_001, #4
	VOXEL_ENTRY_MASK_000 | VOXEL_ENTRY_MASK_100 | VOXEL_ENTRY_MASK_001 | VOXEL_ENTRY_MASK_101, #5
	VOXEL_ENTRY_MASK_100 | VOXEL_ENTRY_MASK_010 | VOXEL_ENTRY_MASK_001, #6
	VOXEL_ENTRY_MASK_100 | VOXEL_ENTRY_MASK_010 | VOXEL_ENTRY_MASK_001 | VOXEL_ENTRY_MASK_000, #7
	VOXEL_ENTRY_MASK_000 | VOXEL_ENTRY_MASK_010 | VOXEL_ENTRY_MASK_101, #8
	VOXEL_ENTRY_MASK_010 | VOXEL_ENTRY_MASK_000 | VOXEL_ENTRY_MASK_100 | VOXEL_ENTRY_MASK_101, #9
	VOXEL_ENTRY_MASK_110 | VOXEL_ENTRY_MASK_100 | VOXEL_ENTRY_MASK_000 | VOXEL_ENTRY_MASK_001, #10
	VOXEL_ENTRY_MASK_110 | VOXEL_ENTRY_MASK_000 | VOXEL_ENTRY_MASK_001 | VOXEL_ENTRY_MASK_101, #11
	VOXEL_ENTRY_MASK_000 | VOXEL_ENTRY_MASK_100 | VOXEL_ENTRY_MASK_001 | VOXEL_ENTRY_MASK_101 | VOXEL_ENTRY_MASK_110, #12
	VOXEL_ENTRY_MASK_101 | VOXEL_ENTRY_MASK_001 | VOXEL_ENTRY_MASK_010 | VOXEL_ENTRY_MASK_110, #13
	VOXEL_ENTRY_MASK_110 | VOXEL_ENTRY_MASK_010 | VOXEL_ENTRY_MASK_000 | VOXEL_ENTRY_MASK_001 | VOXEL_ENTRY_MASK_101, #14
	VOXEL_ENTRY_MASK_000 | VOXEL_ENTRY_MASK_101 | VOXEL_ENTRY_MASK_011 | VOXEL_ENTRY_MASK_110, #15
	VOXEL_ENTRY_MASK_100 | VOXEL_ENTRY_MASK_101 | VOXEL_ENTRY_MASK_110 | VOXEL_ENTRY_MASK_000 | VOXEL_ENTRY_MASK_011, #16
	VOXEL_ENTRY_MASK_000 | VOXEL_ENTRY_MASK_100 | VOXEL_ENTRY_MASK_001 | VOXEL_ENTRY_MASK_101 | VOXEL_ENTRY_MASK_110 | VOXEL_ENTRY_MASK_011, #17
	
	VOXEL_ENTRY_MASK_110 | VOXEL_ENTRY_MASK_001, #18 eqv to 3  (36)
	VOXEL_ENTRY_MASK_100 | VOXEL_ENTRY_MASK_110 | VOXEL_ENTRY_MASK_101 | VOXEL_ENTRY_MASK_010 | VOXEL_ENTRY_MASK_011 | VOXEL_ENTRY_MASK_001, #19 eqv to 3 (126)
	VOXEL_ENTRY_MASK_001 | VOXEL_ENTRY_MASK_000 | VOXEL_ENTRY_MASK_010 | VOXEL_ENTRY_MASK_101 | VOXEL_ENTRY_MASK_100 | VOXEL_ENTRY_MASK_110, #20 eqv to 2  (63)
	
	VOXEL_ENTRY_MASK_000 | VOXEL_ENTRY_MASK_100 | VOXEL_ENTRY_MASK_001 | VOXEL_ENTRY_MASK_101 | VOXEL_ENTRY_MASK_010 | VOXEL_ENTRY_MASK_110 | VOXEL_ENTRY_MASK_011, #21 eqv to 1 (127)
	VOXEL_ENTRY_MASK_000 | VOXEL_ENTRY_MASK_100 | VOXEL_ENTRY_MASK_001 | VOXEL_ENTRY_MASK_101 | VOXEL_ENTRY_MASK_010 | VOXEL_ENTRY_MASK_110 | VOXEL_ENTRY_MASK_011 | VOXEL_ENTRY_MASK_111, #22 eqv to 0
]

var equivalence_classes_data : Array = [
	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 
	3, 3, 2, 1, 0
]

var vertices_data : Array = [
	[],
	#1  1
	[ Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0, 0.5) ],
	#3  2
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0) ],
	#6  3
	[ Vector3(-0.5, 0, 0), Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), 
		Vector3(0.5, 0, 0), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0) ],
	#7  4
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), 
		Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, 0.5), Vector3(0.5, 0, 0) ],
	#15  5
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0) ],
	#22  6
	[ Vector3(0.5, 0, 0), Vector3(0, 0, 0.5), Vector3(0, -0.5, 0), 
		Vector3(0, 0, 0.5), Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0), 
		Vector3(0.5, 0, 0), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0) ],
	#23  7
	[ Vector3(0.5, 0, 0), Vector3(0, 0, 0.5),  
		Vector3(0, 0.5, 0), Vector3(0, 0, 0.5), 
		Vector3(0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#25  8
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0.5, 0, 0), Vector3(0.5, 0, 0),
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#27  9
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0), 
		Vector3(0.5, 0, 0), Vector3(0, 0.5, 0) ],
	#29  10
	[ Vector3(0.5, 0, 0), Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), 
		Vector3(0, 0, 0.5), Vector3(0, 0.5, 0) ],
	#30  11
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), 
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), 
		Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, 0.5), Vector3(0, -0.5, 0), Vector3(0.5, 0, 0) ],
	#31  12
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0, 0.5),  Vector3(0.5, 0, 0) ],
	#60  13
	[ Vector3(0, 0, 0.5), Vector3(0, 0, 0.5), Vector3(0, -0.5, 0), Vector3(0, -0.5, 0),
		Vector3(0, 0, -0.5), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0) ],
	#61  14
	[ Vector3(0.5, 0, 0), Vector3(0, -0.5, 0), Vector3(0, 0, 0.5),
		Vector3(0.5, 0, 0), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5),
		Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0, 0.5),
		Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0.5, 0),
		Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0, -0.5) ],
	#105  15
	[ Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0, 0.5), 
		Vector3(0, 0, -0.5), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0),
		Vector3(-0.5, 0, 0), Vector3(0, -0.5, 0), Vector3(0, 0, 0.5),
		Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0) ],
	#107  16
	[ Vector3(0, 0, 0.5), Vector3(-0.5, 0, 0), 
		Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0), 
		Vector3(0, 0, 0.5), Vector3(0, 0.5, 0),
		Vector3(0, 0, -0.5), Vector3(0.5, 0, 0), Vector3(0, -0.5, 0) ],
	#111  17
	[ Vector3(0, 0.5, 0), Vector3(0.5, 0, 0), Vector3(0, 0, -0.5),
		Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0), Vector3(0, 0, 0.5),
		Vector3(0, 0.5, 0), Vector3(-0.5, 0, 0), Vector3(0, 0.5, 0),
		Vector3(0, 0.5, 0), Vector3(0, 0, -0.5), Vector3(0, 0.5, 0) ],
	#36  18
	[ Vector3(-0.5, 0, 0), Vector3(0, -0.5, 0), Vector3(0, 0, 0.5),
		Vector3(0, 0.5, 0), Vector3(0.5, 0, 0), Vector3(0, 0, -0.5) ],
		
	#126  19
	[ Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0, 0.5),
		Vector3(0, 0, -0.5), Vector3(0, -0.5, 0), Vector3(-0.5, 0, 0) ],
	#63
	[ Vector3(0, 0.5, 0), Vector3(0, 0.5, 0), Vector3(0, 0, 0.5), Vector3(0, 0, 0.5) ],
	
	#127  20
	[ Vector3(0.5, 0, 0), Vector3(0, 0.5, 0), Vector3(0, 0, 0.5) ],
	[]
]

var vertex_corner_data : Array = [
	[],
	#1  1
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000 ],
	#3  2
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_100 ],
	#6  3
	[ VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001 ],
	#7  4
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_100, 
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_001 ],
	#15  5
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_101 ],
	#22  6
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001 ],
	#23  7
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001 ],	
	#25  8
	[ VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#27  9
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_100 ],
	#29  10
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_001 ],
	#30  11
	[ VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_001, 
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_100, 
		VOXEL_ENTRY_INDEX_100, VOXEL_ENTRY_INDEX_001,
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010 ],
	#31  12
	[ VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_100,
		VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_010 ],
	#60  13
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_001 ],
	#61  14
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_010,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_001,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101 ],
	#105 15
	[ VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011 ],
	#107  16
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_101,
		VOXEL_ENTRY_INDEX_000, VOXEL_ENTRY_INDEX_000,
		VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011 ],
	#111  17
	[ VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_011,
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110, 
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_000, 
		VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_000 ],
	#36  18
	[ VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_001 ],
		
		
	#126  18 (3)
	[ VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_110,
		VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_100 ],
	#63
	[ VOXEL_ENTRY_INDEX_001, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_010, VOXEL_ENTRY_INDEX_110 ],
		
	#127  19 (1)
	[ VOXEL_ENTRY_INDEX_011, VOXEL_ENTRY_INDEX_101, VOXEL_ENTRY_INDEX_110 ],
	[],
]

func index_entry_to_mask_entry(entry : int) -> int:
	if entry == VOXEL_ENTRY_INDEX_000:
		return VOXEL_ENTRY_MASK_000
		
	if entry == VOXEL_ENTRY_INDEX_100:
		return VOXEL_ENTRY_MASK_100
		
	if entry == VOXEL_ENTRY_INDEX_010:
		return VOXEL_ENTRY_MASK_010
		
	if entry == VOXEL_ENTRY_INDEX_110:
		return VOXEL_ENTRY_MASK_110
		
	if entry == VOXEL_ENTRY_INDEX_001:
		return VOXEL_ENTRY_MASK_001
		
	if entry == VOXEL_ENTRY_INDEX_101:
		return VOXEL_ENTRY_MASK_101
		
	if entry == VOXEL_ENTRY_INDEX_011:
		return VOXEL_ENTRY_MASK_011
		
	if entry == VOXEL_ENTRY_INDEX_111:
		return VOXEL_ENTRY_MASK_111
	
	return 0

func mask_entry_to_index_entry(entry : int) -> int:
	if entry == VOXEL_ENTRY_MASK_000:
		return VOXEL_ENTRY_INDEX_000
		
	if entry == VOXEL_ENTRY_MASK_100:
		return VOXEL_ENTRY_INDEX_100
		
	if entry == VOXEL_ENTRY_MASK_010:
		return VOXEL_ENTRY_INDEX_010
		
	if entry == VOXEL_ENTRY_MASK_110:
		return VOXEL_ENTRY_INDEX_110
		
	if entry == VOXEL_ENTRY_MASK_001:
		return VOXEL_ENTRY_INDEX_001
		
	if entry == VOXEL_ENTRY_MASK_101:
		return VOXEL_ENTRY_INDEX_101
		
	if entry == VOXEL_ENTRY_MASK_011:
		return VOXEL_ENTRY_INDEX_011
		
	if entry == VOXEL_ENTRY_MASK_111:
		return VOXEL_ENTRY_INDEX_111
	
	return 0

func generate() -> String:
	
	var i : int = 0
	var a : String = ""
	
	for y in range(4):
		for z in range(8):
			for x in range(8):
				var data : Array = get_equiv_data(i)
				
				var index : int = data[0]
				var rx : int = data[1]
				var ry : int = data[2]
				var rz : int = data[3]
				
				var owners : Array  = get_rotate_owners(index, rx, ry, rz)
				
#				a += str(i) + " -> " + str(equivalence_classes_data[index]) + " ("  + str(data) + ")\n"
				a += str(i) + " -> " + str(equivalence_classes_data[index]) + " ("  + str(data) + ")" + " ("  +  str(debug_index_to_str(vertex_corner_data[index])) + " "  + str(debug_index_to_str(owners)) + ")\n"
				
				
				i += 1
				
	return a
	
func get_rotate_owners(index : int, x : int, y : int, z : int) -> Array:
	var owners : Array = vertex_corner_data[index]
	var nowners : Array = []
	
	for index in owners:
		var i : int = index
		
		for rx in range(x):
			i = entry_index_x_rotations[i]
			
		for ry in range(y):
			i = entry_index_y_rotations[i]
			
		for rz in range(z):
			i = entry_index_z_rotations[i]
		
		nowners.append(i)
	
	return nowners
	

func find_equiv_index(cls : int) -> int:
	for x in range(4):
		for y in range(4):
			for z in range(4):
				var cl : int = rotate_index(cls, x, y, z)
				
				for i in range(len(class_match_table)):
					if class_match_table[i] == cl:
						return i
	
	return -1
	
func get_equiv_data(cls : int) -> Array:
	var res : Array = []
	
	for x in range(4):
		for y in range(4):
			for z in range(4):
				var cl : int = rotate_index(cls, x, y, z)
				
				for i in range(len(class_match_table)):
					if class_match_table[i] == cl:
						
						res.append(i)
						res.append(x)
						res.append(y)
						res.append(z)
						
						return res
	
	return res
	
func rotate_index(cls : int, x : int, y : int, z : int) -> int:
	var corners : Array = [
		cls & 1 << 0,
		cls & 1 << 1,
		cls & 1 << 2,
		cls & 1 << 3,
		cls & 1 << 4,
		cls & 1 << 5,
		cls & 1 << 6,
		cls & 1 << 7,
	]
	
	for i in range(len(corners)):
		if corners[i] == 0:
			continue
		
		var index : int = mask_entry_to_index_entry(corners[i])
		
		for rx in range(x):
			index = entry_index_x_rotations[index]
			
		for ry in range(y):
			index = entry_index_y_rotations[index]
			
		for rz in range(z):
			index = entry_index_z_rotations[index]
		
		corners[i] = index_entry_to_mask_entry((index))
	
	var res : int = 0
	
	for e in corners:
		res = res | e
		
	return res
	
func debug_index_to_str(array : Array) -> Array:
	var o : Array = []
	
	for e in array:
		if e == VOXEL_ENTRY_INDEX_000:
			o.append("000")
		elif e == VOXEL_ENTRY_INDEX_100:
			o.append("100")
		elif e == VOXEL_ENTRY_INDEX_010:
			o.append("010")
		elif e == VOXEL_ENTRY_INDEX_110:
			o.append("110")
		elif e == VOXEL_ENTRY_INDEX_001:
			o.append("001")
		elif e == VOXEL_ENTRY_INDEX_101:
			o.append("101")
		elif e == VOXEL_ENTRY_INDEX_011:
			o.append("011")
		elif e == VOXEL_ENTRY_INDEX_111:
			o.append("111")
		else:
			o.append("!")
	
	return o


func _on_Button_pressed():
	var text_edit : TextEdit = get_node(text_edit_path) as TextEdit
	
	text_edit.text = generate()
