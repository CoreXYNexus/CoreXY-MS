////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// BeraAirMount.scad
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// C:4/8/21
// U:4/8/21
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 4/8/21	- BerdAirMount on the extruder
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <CoreXY-MSv1-h.scad>
include <BOSL2/std.scad>
include <inc/brassinserts.scad>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// for EXOSlide use the one from M-Max
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
uSE3MMiNSERT=1;
LargeInsert=0;
LayerThickness=0.3;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//BerdAirMountLeft(35,2,0); // side with heater block
BerdAirMountRight(13,2,0); // side without heater block

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BerdAirMountLeft(Offset=35,PipeSize=2,Fit) { // side with heater block
	difference() {
		union() {
			color("cyan") cuboid([spacing+10,wall,wall],rounding=2,p1=[0,0],except_edges=BOTTOM);
			translate([8,0,0]) color("red") cuboid([wall+4,wall,Offset],rounding=2,p1=[0,0],except_edges=BOTTOM+TOP);
			translate([0,0,Offset-wall]) color("white")
				cuboid([spacing+10,wall*2,wall],rounding=2,p1=[0,0],except_edges=TOP);
		}
		translate([5,wall,Offset+5]) rotate([90,0,0]) IRMountHoles();
		translate([5,wall/2,10]) rotate([90,0,0]) IRMountHoles(screw3);
		translate([5,wall/2,17]) rotate([90,0,0]) IRMountHoles(screw3hd,10);
	}
	if(Fit) Cap(PipeSize,Offset);
	else translate([0,40,Offset+2]) rotate([90,0,0]) Cap(PipeSize,Offset);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BerdAirMountRight(Offset=13,PipeSize=2,Fit) { // side without heater block
	difference() {
		union() {
			color("cyan") cuboid([spacing+10,wall,wall+1],rounding=2,p1=[0,0],except_edges=BOTTOM);
			translate([8,0,0]) color("red") cuboid([wall+4,wall,Offset],rounding=2,p1=[0,0],except_edges=BOTTOM+TOP);
			translate([0,0,Offset-wall]) color("white")
				cuboid([spacing+10,wall*2,wall],rounding=2,p1=[0,0],except_edges=TOP);
		}
		translate([5,wall,Offset+5]) rotate([90,0,0]) IRMountHoles();
		translate([5,wall/2-2,10]) rotate([90,0,0]) IRMountHoles(screw3);
		translate([5,wall/2-2,17]) rotate([90,0,0]) IRMountHoles(screw3hd,10);
		translate([(spacing+10)/2,-3,9]) rotate([-45,0,0]) cylinder(h=10,d=PipeSize+5);
	}
	if(Fit) Cap(PipeSize,Offset);
	else translate([0,18,Offset+2]) rotate([90,0,0]) Cap(PipeSize,Offset);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Cap(PipeSize,Offset,Test=0) {
	difference() {
		translate([0,0,Offset]) color("plum") cuboid([spacing+10,wall*2,5],rounding=2,p1=[0,0],except_edges=BOTTOM);
		translate([(spacing+10)/2,wall*3-5,Offset+0.75]) color("green") hull() {
			rotate([90,0,0]) cylinder(h=wall*3,d=PipeSize);
			translate([0,0,-3]) rotate([90,0,0]) cylinder(h=wall*3,d=PipeSize);
		}
		translate([5,wall,Offset+15]) rotate([90,0,0]) IRMountHoles(screw3);
		translate([5,wall,Offset+24]) rotate([90,0,0]) IRMountHoles(screw3hd);
	}
	translate([5,wall,Offset+3.7]) color("black") cylinder(h=LayerThickness,d=screw3hd);
	translate([5+spacing,wall,Offset+3.7]) color("white") cylinder(h=LayerThickness,d=screw3hd);
	if(Test) translate([(spacing+10)/2,wall*3-5,Offset+0.75]) rotate([90,0,0]) color("purple") cylinder(h=wall*3,d=PipeSize);

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRMountHoles(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert),Length=20) // ir screw holes for mounting to extruder plate
{
	translate([spacing,0,0]) rotate([90,0,0]) color("blue") cylinder(h=Length,d=Screw);
	translate([0,0,0]) rotate([90,0,0]) color("red") cylinder(h=Length,d=Screw);
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////