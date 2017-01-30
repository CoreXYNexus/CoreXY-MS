/////////////////////////////////////////////////////////////////////////////////////////////////////////
// bed_pivots.scad --  z-axis bed rotatable bed mounts for independent z motor bed leveling
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 1/29/2017
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Last Update: 1/29/2017
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/15/17 - Added bearing pivot style carriage & 2040 mounts for multi-motor leveling
// 1/29/17 - Added pivot version using just a M5 screw
//			 Made separate scad file for this and removed them from corexy-z-axis.scad
//			 Added roounded version of the center pivot
// 1/30/17 - Fixed M5 round version
////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/nema17.scad>	// https://github.com/mtu-most/most-scad-libraries
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
$fn=50;
///////////////////////////////////////////////////////////////////////////////////////////////////////
dia_625z = 16;	// diameter of a 625z (no flange)
layer = 0.2;	// printed layer thickness
///////////////////////////////////////////////////////////////////////////////////////////////////////////

z_pivots(1,0,1);	// arg1: Quanity ; Arg2: 0 for M5 pivots, 1 for 625z bearing pivots ; Arg3: 1 for round, 0 - square

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_pivots(Qty,Bearing,Round) {
	for(i=[0:Qty-1]){
		translate([0,i*45,15]) z_pivot_2040(Bearing,Round);
		if(Round)
			translate([45,i*45+20,29]) rotate([180,0,0]) center_pivot2(Bearing);
		else
			translate([45,i*45,0]) center_pivot(Bearing); // non-rounded version
		if(Bearing) translate([70,i*45,0]) z_pivot_carriage();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_pivot_carriage() { // 3 625 bearing pivot mounts on the makerslide carriage
	difference() {
		color("cyan") cubeX([60,24,8],2);
		bearing_hole2(30,12,3,1);
		translate([9,12,-2]) color("blue") cylinder(h=20,d=screw5,$fn=100);
		translate([51.5,12,-2]) color("white") cylinder(h=20,d=screw5,$fn=100);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module z_pivot_2040(Bearing=1,RoundPivot=1) { // 3 625 bearing pivot mounts on the 2040 holding the bed
	difference() {
		translate([0,0,-15]) color("cyan") cubeX([35,40,20],2);
		translate([5.75,-2,-23]) color("cyan") cube([20.5,45,25]);
		if(RoundPivot) 
			side_screws_2040(16.5);
		else
			side_screws_2040(20);
	}
	difference() {
		translate([-5,0,-15]) color("blue") cubeX([10,40,40],2);
		if(RoundPivot) 
			side_screws_2040(16.5);
		else
			side_screws_2040(20);
	}
	difference() {
		translate([28,0,-15]) color("red") cubeX([10,40,40],2);
		if(RoundPivot) 
			side_screws_2040(16.5);
		else
			side_screws_2040(20);
	}
	if(!RoundPivot) // test center_pivot, should never need to tilt this far
		%translate([6,19.7,5.5]) rotate([45,0,0]) center_pivot(Bearing);
	else
		%translate([6,9.7,6.5]) center_pivot2(Bearing);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module center_pivot(Bearing=0) {
	if(Bearing) {
		difference() {
			color("cyan") cubeX([dia_625z+5,dia_625z+5,dia_625z+15],2);
			translate([-10,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,90,0]) bearing_hole2(0,0,0,1);
			translate([30,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,-90,0]) bearing_hole2(0,0,0,1);
			translate([dia_625z/2+2.5,dia_625z/2+2.5,dia_625z-3]) color("yellow") cylinder(h=40,d=screw5,$fn=100);
			translate([-5,dia_625z/2-2,dia_625z/2+13]) color("green") cube([40,8.6,4]);
		}
	} else {
		difference() {
			color("cyan") cubeX([dia_625z+5,dia_625z+5,dia_625z+15],2);
			translate([-10,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,90,0]) bearing_hole2();
			translate([30,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,-90,0]) bearing_hole2();
			translate([dia_625z/2+2.5,dia_625z/2+2.5,dia_625z-3]) color("yellow") cylinder(h=40,d=screw5,$fn=100);
			translate([-5,dia_625z/2-2,dia_625z/2+13]) color("green") cube([40,8.6,4]);
		}
	}
	screw_hole_spport(dia_625z/2+2.5,dia_625z/2+2.5,dia_625z/2+17);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module center_pivot2(Bearing) {
	difference() {
		translate([0,0,dia_625z/2]) color("cyan") cubeX([dia_625z+5,dia_625z+5,dia_625z+5],2);
		double_bearing_mount_hole(Bearing);
		translate([dia_625z/2+2.5,dia_625z/2+2.5,dia_625z-3]) color("yellow") cylinder(h=40,d=screw5,$fn=100);
		translate([-5,dia_625z/2-2,dia_625z/2+13]) color("green") cube([40,8.6,4]);
	}
	double_bearing_mount(Bearing);
	screw_hole_spport(dia_625z/2+2.5,dia_625z/2+2.5,dia_625z/2+13-layer);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module screw_hole_spport(X,Y,Z) { // support the bottom of the carriage side M5 hole on the center pivot
	translate([X,Y,Z]) color("pink") cylinder(h=layer,d=screw5hd);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module double_bearing_mount(Bearing) {
	difference() {
		translate([0,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,90,0])
			color("pink") cylinder(h=dia_625z+5,d=dia_625z+5,$fn=100);
		translate([-10,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,90,0]) bearing_hole2(0,0,0,Bearing);
		translate([30,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,-90,0]) bearing_hole2(0,0,0,Bearing);
		translate([dia_625z/2+2.5,dia_625z/2+2.5,dia_625z-3]) color("yellow") cylinder(h=40,d=screw5,$fn=100);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module double_bearing_mount_hole() {
	translate([-10,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,90,0]) bearing_hole2(0,0,0,1);
	translate([30,dia_625z/2+2.5,dia_625z/2+2]) rotate([0,-90,0]) bearing_hole2(0,0,0,1);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module side_screws_2040(PivotZpos=20) {
	translate([-7,10,-8]) rotate([0,90,0]) color("white") cylinder(h=50,d=screw5,$fn=100);
	translate([-7,30,-8]) rotate([0,90,0]) color("gray") cylinder(h=50,d=screw5,$fn=100);
	translate([-7,20,PivotZpos]) rotate([0,90,0]) color("salmon") cylinder(h=50,d=screw5,$fn=100); // pivot
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bearing_hole2(Xpos=0,Ypos=0,Zpos=0,Bearing=0) {
	if(Bearing) {
		translate([Xpos,Ypos,Zpos]) color("white") cylinder(h=15,d=dia_625z,$fn=100);
		translate([Xpos,Ypos,-2]) color("black") cylinder(h=30,d=screw5hd,$fn=100);
	} else {
		translate([Xpos,Ypos,-2]) color("black") cylinder(h=30,d=screw5,$fn=100);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////