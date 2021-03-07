/////////////////////////////////////////////////////////////////////////////////////////////////
// NEOPixelStrip.scad
//////////////////////////////////////////////////////////////////////////////////////////////////
// created 2/13/21
// last update 3/4/21
////////////////////////////////////////////////////////////////////////////////////////////////////
// 3/4/21	- Added a cover fot hte neo strip, needs to be print in a transparent filament
//////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
include <inc/brassinserts.scad>
include <inc/cubex.scad>
////////////////////////////////////////////////////////////////////////////////////////////////
// For https://www.adafruit.com/product/1426
///////////////////////////////////////////////////////////////////////////////////////////////
ScrewHole=2;
Offset=27.7-ScrewHole;
LeftPos=11.7;
Length=51.2;
Width=10.2;
Thickness=5;
LayerThickness=0.3;
Use2mmInsert=1;
/////////////////////////////////////////////////////////////////////////////////////////////////

StripMount(1); // no counter sink on strip mount
//%translate([0,0,Thickness]) cube([10,10,16-Thickness]); // show max heigth for cover
//translate([0,0,11]) // test fit
translate([0,-5,5]) rotate([180,0,0]) // print with Strip
	Cover();
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////

module Cover() { // needs to be printed in a tranperant filament
	difference() {
		translate([0,-4,0]) {
			union() {
				color("plum") cubeX([Length+35,Width+9,Thickness],2);
				translate([0,0,-6]) color("gray") cubeX([13,Width+9,10],2);
				translate([Length+22,0,-6]) color("lightgray") cubeX([13,Width+9,10],2);
			
			}
		}
		2020Mounting();
	}
	translate([0,-4,-11]) color("pink") cubeX([Length+35,4,15],2);
	translate([7,7.5,2.7]) color("black") cylinder(h=LayerThickness,d=screw5hd);
	translate([79.25,7,2.7]) color("white") cylinder(h=LayerThickness,d=screw5hd);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module StripMount(NoCS=0) {
	difference() {
		color("cyan") cubeX([Length+35,Width+5,Thickness],2);
		2020Mounting(NoCS);
		translate([5,0,0])	NEOMount();
		//Gullet();
	}
	Riser();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module Riser() {
	difference() {
		translate([25,0,1]) color("red") cubeX([Length-17,Width+5,6],2);
		translate([5,0,0])	NEOMount();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module Gullet() {
	translate([LeftPos+25/2-11,-3,Thickness-2.5]) color("gray") cubeX([Width+2,Width+10,4],2);
	translate([LeftPos+25/2+Offset+10,-3,Thickness-2.5]) color("lightgray") cubeX([Width+2,Width+10,4],2);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEOMount(Screw=Yes2mmInsert(Use2mmInsert)) {
	translate([LeftPos+25/2,5,-4]) color("pink") cylinder(h=Thickness*3,d=Screw);
	translate([LeftPos+25/2+Offset,5,-4]) color("plum") cylinder(h=Thickness*3,d=Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module 2020Mounting(NoCS=0,Screw=screw5) {
	translate([7,(Width+5)/2,-8]) color("blue") cylinder(h=Thickness*4,d=Screw);
	translate([Length+28,(Width+5)/2,-8]) color("red") cylinder(h=Thickness*4,d=Screw);
	if(Screw==screw5 && !NoCS) {
		translate([7,(Width+5)/2,3]) color("red") cylinder(h=3,d=screw5hd);
		translate([Length+28,(Width+5)/2,3]) color("blue") cylinder(h=3,d=screw5hd);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////