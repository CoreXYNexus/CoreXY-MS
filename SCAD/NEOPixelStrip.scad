////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NEOPixelStrip.scad
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 2/13/21
// last update 5/26/22
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 3/4/21	- Added a cover fot hte neo strip, needs to be print in a transparent filament
// 3/5/21	- Added a strip holder for a plain strip of leds 100mm long to mount on the bottom
// 3/6/21	- PlainLEDStripHolder() can now use two strips
// 4/3/21	- Added hole for NEOPixelCover() if a non-transparent filametnt is used.  Added labels.
// 4/4/21	- Widden the plain led strip holder to get the leds closer to the hotend and can install two strips
//			  Converted to use BOSL2
// 11/18/21	- Added version of cover with the lettering as through holes
// 1/2/22	- Added Babylon 5 font (b5___.ttf)
// 1/9/22	- Adjusted gullets in gullet(), added pin mounting
// 5/26/22	- Change to be able to use dual extrusion
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
include <inc/brassinserts.scad>
include <BOSL2/std.scad> //inc/cubex.scad>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// For https://www.adafruit.com/product/1426
// use clear for base on NEOPixelCover()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ScrewHole=2;
Offset=27.7-ScrewHole;
LeftPos=11.7;
Length=51.2;
Width=20;
Thickness=5;
BaseThickness=5;
LEDStripWidth=8.5;
LayerThickness=0.3;
NozzleThickness=0.4;
Use2mmInsert=1;
FontSet="Babylon5:style=Regular";
/////////////////////////////////////////////////////////////////////////////////////////////////

//rotate([0,0,0]) // use for test fir
	NEOPixelStripMount(1,1); // no counter sink on strip mount
//translate([0,1,-9])  rotate([180,0,180]) // test fit mount and cover together
translate([0,23,0]) rotate([180,0,0]) // print with NEOPixelStripMount()
	NEOPixelCover(0); // through hole letters;  must be printed with letter side down

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEOPixelCover(ClearFilament=0,NoCS=0) { // needs to be printed in a tranperant filament
	difference() {								 // infill will be noticable
		translate([0,0,0]) color("plum") cuboid([Length+35,Width,Thickness],rounding=2);
		translate([-43,-Width/2-3,-2.5]) 2020Mounting(NoCS);
		translate([-37,0,-9]) NEOMount(0);
	}
	translate([-19,-3,-2]) rotate([0,0,0]) PrintString("B     0 1",6,8); // label: Bed T0 T1
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEOPixelStripMount(NoCS=0,Hole=0) {
	difference() {
		union() {
			color("cyan") cuboid([Length+35,Width+4,BaseThickness],rounding=2);
			translate([-36.6,0,-2]) color("gray") cuboid([13,Width+4,9],rounding=2);
			translate([Length-14.6,0,-2]) color("lightgray") cuboid([13,Width+4,9],rounding=2);
		}
		translate([-43,-Width/2-1,-1.5]) 2020Mounting(NoCS);
		translate([-37,2,-8]) Gullet();
	}
	translate([37,1,2]) rotate([0,180,0]) NEOMount(Hole);
	translate([0,-Width/2,-4.5]) color("pink") cuboid([Length+35,4,14],rounding=2); // front
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module Gullet() {
	translate([LeftPos+25/2-14,-3,BaseThickness-0.5]) color("gray") cuboid([Width-10,Width+9,8],rounding=2);
	translate([LeftPos+25/2+Offset+14,-3,BaseThickness-0.5]) color("lightgray") cuboid([Width-10,Width+9,8],rounding=2);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEOMount(Hole,Screw=Yes2mmInsert(Use2mmInsert)) {
	if(Hole) {
		translate([LeftPos+25/2,5,0]) color("pink") cylinder(h=Thickness+5.4,d1=screw2hd,d2=screw2t/3);
		translate([LeftPos+25/2+Offset,5,0]) color("plum") cylinder(h=Thickness+5.4,d1=screw2hd,d2=screw2t/3);
	} else {
		translate([LeftPos+25/2,5,-4]) color("pink") cylinder(h=Thickness*3,d=Screw);
		translate([LeftPos+25/2+Offset,5,-4]) color("plum") cylinder(h=Thickness*3,d=Screw);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module 2020Mounting(NoCS=0,Screw=screw5) {
	translate([7,(Width+5)/2,-20]) color("blue") cylinder(h=Thickness*6,d=Screw);
	translate([Length+28,(Width+5)/2,-20]) color("red") cylinder(h=Thickness*6,d=Screw);
	if(!NoCS) {
		translate([7,(Width+5)/2,3]) color("red") cylinder(h=3,d=screw5hd);
		translate([Length+28,(Width+5)/2,3]) color("blue") cylinder(h=3,d=screw5hd);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module PrintString(String,Height=1.5,Size=4,Font=FontSet,Color="coral") { // print something
	color(Color) linear_extrude(height = Height) text(String, font = Font,size=Size);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////