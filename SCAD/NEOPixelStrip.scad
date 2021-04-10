/////////////////////////////////////////////////////////////////////////////////////////////////
// NEOPixelStrip.scad
//////////////////////////////////////////////////////////////////////////////////////////////////
// created 2/13/21
// last update 4/3/21
////////////////////////////////////////////////////////////////////////////////////////////////////
// 3/4/21	- Added a cover fot hte neo strip, needs to be print in a transparent filament
// 3/5/21	- Added a strip holder for a plain strip of leds 100mm long to mount on the bottom
// 3/6/21	- PlainLEDStripHolder() can now use two strips
// 4/3/21	- Added hole for NEOPixelCover() if a non-transparent filametnt is used.  Added labels.
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
LEDStripWidth=8.5;
LayerThickness=0.3;
Use2mmInsert=1;
/////////////////////////////////////////////////////////////////////////////////////////////////

NEOPixelStripMount(1); // no counter sink on strip mount
//%translate([0,0,Thickness]) cube([10,10,16-Thickness]); // show clearance height for cover
//translate([0,0,11]) // test fit
translate([0,-7,5]) rotate([180,0,0]) // print with Strip
	NEOPixelCover(1);
//PlainLEDStripHolder(1);

///////////////////////////////////////////////////////////////////////////////////////////////////////

module PlainLEDStripHolder(TwoStrips=0) {
	difference() {
		if(TwoStrips) translate([0,-10,0]) color("cyan") cubeX([110,35,4],2);
		else color("cyan") cubeX([110,25,4],2);
		translate([23,20,0]) {
			translate([0,0,-3])color("red") cylinder(h=10,d=screw4);
			translate([60,0,-3]) color("blue") cylinder(h=10,d=screw4);
			translate([0,0,2])color("blue") cylinder(h=5,d=screw4hd);
			translate([60,0,2]) color("red") cylinder(h=5,d=screw4hd);
		}
		ZipTieHoleSlot(TwoStrips);
		translate([-50,0,0]) ZipTieHoleSlot(TwoStrips);
		translate([-100,0,0]) ZipTieHoleSlot(TwoStrips);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZipTieHoleSlot(TwoStrips=0) { // the sticky back on the led strip doesn't hold very good
	if(TwoStrips) {
		translate([105,11,-3]) color("black") cylinder(h=10,d=3.5);
		translate([105,2-LEDStripWidth,-3]) color("gray") cylinder(h=10,d=3.5);
		translate([102.5,-10,-1.5]) color("lightgray") cubeX([5,24,4],2);
	} else {
		translate([105,11,-3]) color("black") cylinder(h=10,d=3.5);
		translate([105,11-LEDStripWidth,-3]) color("gray") cylinder(h=10,d=3.5);
		translate([102.5,0,-1.5]) color("lightgray") cubeX([5,14,4],2);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEOPixelCover(ClearFilament=0) { // needs to be printed in a tranperant filament
	difference() {
		translate([0,-4,0]) {
			union() {
				color("plum") cubeX([Length+35,Width+9,Thickness],2);
				translate([0,0,-6]) color("gray") cubeX([13,Width+9,10],2);
				translate([Length+22,0,-6]) color("lightgray") cubeX([13,Width+9,10],2);
			
			}
		}
		2020Mounting();
	if(!ClearFilament) translate([17,10,-7]) rotate([45,0,0]) color("black") cubeX([Length,Width-3,20],2);
	}
	translate([0,-4,-11]) color("pink") cubeX([Length+35,4,15],2);
	translate([7,7.5,2.7]) color("black") cylinder(h=LayerThickness,d=screw5hd);
	translate([79.25,7,2.7]) color("white") cylinder(h=LayerThickness,d=screw5hd);
	translate([20,-3.5,-4]) rotate([80,0,0]) PrintString("BED-HOTEND",2,6);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEOPixelStripMount(NoCS=0) {
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

//////////////////////////////////////////////////////////////////////////////////////////////////

module PrintString(String,Height=1.5,Size=4,Font="Comic Sans MS:style=Bold",Color="coral") { // print something
	color(Color) linear_extrude(height = Height) text(String, font = Font,size=Size);
	//"Liberation Sans"
	//"Comic Sans MS:style=Bold"
}

/////////////////////////////////////////////////////////////////////////////////////////////////////