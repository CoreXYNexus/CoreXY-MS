// belt_holder.scad - hold a belt without screws
////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
use <ybeltclamp.scad>	// modified https://www.thingiverse.com/thing:863408
////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
height = 20;
LoopHoleOffset=28; // same as LoopHoleOffset in Corexy-x-carriage.scad
///////////////////////////////////////////////////////////////////////////////////////////////////
// Not tested!!!!
///////////////////////////////////////////////////////////////////////////////////////////////////

belt_holder();

///////////////////////////////////////////////////////////////////////////////////////////////////

module belt_holder() {
	difference() {
		color("blue") cubeX([23,16,height],1);
		translate([0,3,-4]) beltLoop();
		translate([0,3,12]) beltLoop();
	}
	translate([19,-8,0]) mounting_block();
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module mounting_block() {
	difference() {
		color("pink") cubeX([5,32,height],1);
		translate([-5,LoopHoleOffset,height/2]) rotate([0,90,0]) color("red") cylinder(h=height,d=screw3);
		translate([-19,LoopHoleOffset,height/2]) rotate([0,90,0]) color("plum") cylinder(h=height,d=screw3hd);
		color("blue") translate([-5,4,height/2]) rotate([0,90,0]) cylinder(h=height,d=screw3);
		translate([-19,4,height/2]) rotate([0,90,0]) color("red") cylinder(h=height,d=screw3hd);
	}
}

//////////////////// end of belt_holder.scad //////////////////////////////////////////////////////