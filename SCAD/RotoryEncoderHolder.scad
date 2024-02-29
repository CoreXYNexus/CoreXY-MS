////////////////////////////////////////////////////////////////////////////////////////////////////////
// RotoryEncoderHolder.scad
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 5/14/2023
// Last Update: 5/14/23
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <BOSL2/std.scad>
//include <inc/brassinserts.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
LayerThickness=0.3;
RiserHeight=45;
BoltCircleDiameter=30;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

RotoryEncoderHolder();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RotoryEncoderHolder() {
	difference() {
		color("cyan") hull() { // base
			cyl(h=5,d=10,rounding=2);
			translate([45,0,0]) cyl(h=5,d=50,rounding=2);
			translate([90,0,0]) cyl(h=5,d=10,rounding=2);
		}
		translate([45,0,-0.01]) color("gold") cyl(h=5,d=41,rounding1=-2); // round bottom rotary hole
		translate([45,-45/2,0]) color("pink") cuboid([10,10,10]); // side slot
		BaseSlotRounding();
		BaseHoles();
	}
	Riser();
	RotaryMountFlange();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BaseHoles() {
	translate([2,0,0]) color("red") hull() { // screw slot
		translate([0,0,0]) cyl(h=10,d=screw5);
		translate([10,0,0]) cyl(h=10,d=screw5);
	}
	translate([78,0,0]) color("blue") hull() { // screw slot
		translate([0,0,0]) cyl(h=10,d=screw5);
		translate([10,0,0]) cyl(h=10,d=screw5);
	}
	translate([45,0,0]) color("white") cyl(h=20,d=41); // base hole
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BaseSlotRounding() {
	translate([45-6,-45/2-4,0]) color("lightgray") rotate([0,90,0]) cuboid([5,5,2],rounding=-2,edges=[TOP]); // slot
	translate([45-6,-45/2,-5]) color("lightgray") rotate([0,90,0]) cuboid([5,5,2],rounding=-2,edges=[TOP]);
	translate([45+6,-45/2-4,0]) color("lightgray") rotate([0,-90,0]) cuboid([5,5,2],rounding=-2,edges=[TOP]);
	translate([45+6,-45/2,-5]) color("lightgray") rotate([0,-90,0]) cuboid([5,5,2],rounding=-2,edges=[TOP]);
	translate([45-6,-45/2+6,0]) color("lightgray") rotate([0,90,0]) cuboid([5,5,2],rounding=-2,edges=[TOP]); // slot
	translate([45+6,-45/2+6,0]) color("lightgray") rotate([0,-90,0]) cuboid([5,5,2],rounding=-2,edges=[TOP]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Riser() {
	difference() { // riser
		translate([RiserHeight,0,RiserHeight/2]) color("purple") cyl(h=RiserHeight,d=49); // outer
		translate([RiserHeight,0,RiserHeight/2]) color("white") cyl(h=RiserHeight+5,d=41); // inner
		translate([RiserHeight,-RiserHeight/2,RiserHeight/2]) color("pink") rotate([0,90,0]) cuboid([50,10,10]); // side slot
		translate([RiserHeight,-RiserHeight/2+2,RiserHeight/2]) color("gray") rotate([0,90,90])
			cuboid([50,10,2],rounding=-2,edges=[TOP]); // side slot
		translate([RiserHeight,-RiserHeight/2-0.5,RiserHeight/2]) color("gray") rotate([0,90,-90])
			cuboid([50,10,2],rounding=-2,edges=[TOP]); // side slot
		translate([RiserHeight,0,0]) color("gold") cyl(h=5,d=41,rounding1=-2); // round base rotary hole
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RotaryMountFlange() {
	difference() { // rotary mount
		translate([RiserHeight,0,RiserHeight]) color("khaki") cyl(h=5,d=49,rounding=2);
		translate([RiserHeight,0,RiserHeight]) color("blue") cyl(h=10,d=20.5);
		translate([45,0,40]) color("red") BoltCircle(BoltCircleDiameter);
	}
	translate([RiserHeight,0,RiserHeight-2.5]) color("gray") cyl(h=LayerThickness*2,d=45); // support
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BoltCircle(Dia=30,h=20) {
linear_extrude(h)
	for(i = [-1 : 1])
		rotate(i * 120) translate([0, Dia / 2]) circle(d = screw3);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
