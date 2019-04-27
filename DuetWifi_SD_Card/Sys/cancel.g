M104 S0	; turn off extruder
M140 S0 	; turn off bed
M106 S0 	; turn off part fan
G1 X10 F3000 	; move x to left
G1 Y300 F3000	; move y to front
G91		; relative moves
G1 Z10		; raise z by 10
G90		; absolute moves
M84		; disable motors
;M117 Cancel.g called
