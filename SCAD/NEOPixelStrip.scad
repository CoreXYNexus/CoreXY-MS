////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NEOPixelStrip.scad
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 2/13/21
// last update 11/18/21
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 3/4/21	- Added a cover fot hte neo strip, needs to be print in a transparent filament
// 3/5/21	- Added a strip holder for a plain strip of leds 100mm long to mount on the bottom
// 3/6/21	- PlainLEDStripHolder() can now use two strips
// 4/3/21	- Added hole for NEOPixelCover() if a non-transparent filametnt is used.  Added labels.
// 4/4/21	- Widden the plain led strip holder to get the leds closer to the hotend and can install two strips
//			  Converted to use BOSL2
// 11/18/21	- Added version of cover with the lettering as through holes
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
include <inc/brassinserts.scad>
include <BOSL2/std.scad> //inc/cubex.scad>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// For https://www.adafruit.com/product/1426
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ScrewHole=2;
Offset=27.7-ScrewHole;
LeftPos=11.7;
Length=51.2;
Width=10.2;
Thickness=5;
BaseThickness=7;
LEDStripWidth=8.5;
LayerThickness=0.3;
NozzleThickness=0.4;
Use2mmInsert=1;
/////////////////////////////////////////////////////////////////////////////////////////////////

NEOPixelStripMount(1); // no counter sink on strip mount
//%translate([0,0,Thickness]) cube([10,10,16-Thickness]); // show clearance height for cover
//translate([0,-1,10]) // test fit
//translate([0,20,-1]) rotate([180,0,0]) // print with NEOPixelStripMount()
//	NEOPixelCover(1,0); // raised letters
translate([0,12,6.1]) rotate([90,0,0]) // print with NEOPixelStripMount()
	NEOPixelCoverV2(0,0); // through hole letters;  must be printed with letter side down

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEOPixelCover(ClearFilament=0,NoCS=0) { // needs to be printed in a tranperant filament
	difference() {							   // infill will be noticable
		translate([0,0,0]) {
			union() {
				color("plum") cuboid([Length+35,Width+9,Thickness],rounding=2);
				translate([-36.6,0,-2]) color("gray") cuboid([13,Width+9,9],rounding=2);
				translate([Length-14.6,0,-2]) color("lightgray") cuboid([13,Width+9,9],rounding=2);
				translate([0,-7.6,-6]) color("pink") cuboid([Length+35,4,15],rounding=2);
			}
		}
		translate([-43,-7,-2.5]) 2020Mounting(NoCS);
		if(!ClearFilament) translate([0,-1,0]) rotate([45,0,0]) color("black") cuboid([Length,Width-3,20],rounding=2);
	}
	translate([-36,0.5,LayerThickness-0.1]) color("lightgray") cylinder(h=LayerThickness,d=screw5hd); // support
	translate([36.1,0.5,LayerThickness-0.1]) color("white") cylinder(h=LayerThickness,d=screw5hd); // support
	translate([-20,-9.5,-7]) rotate([80,0,0]) PrintString("B        H",2,6); // label
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEOPixelCoverV2(ClearFilament=0,NoCS=0) { // needs to be printed in a tranperant filament
	difference() {								 // infill will be noticable
		translate([0,0,0]) {
			union() {
				color("plum") cuboid([Length+35,Width+9,Thickness],rounding=2);
				translate([-36.6,0,-2]) color("gray") cuboid([13,Width+9,9],rounding=2);
				translate([Length-14.6,0,-2]) color("lightgray") cuboid([13,Width+9,9],rounding=2);
				translate([0,-7.6,-6]) color("pink") cuboid([Length+35,4,15],rounding=2);
			}
		}
		translate([-43,-7,-2.5]) 2020Mounting(NoCS);
		if(!ClearFilament) translate([0,-1,0]) rotate([45,0,0]) color("black") cuboid([Length,Width-3,20],rounding=2);
		translate([-20,-2,-7]) rotate([90,0,0]) PrintString("B        H",10,6); // label
	}
	if(ClearFilament) translate([-18.1,-6.1,-7]) color("white") cuboid([0.25,1,3],rounding=0); // support for B
	else translate([-18.1,-6.1,-5]) color("white") cuboid([NozzleThickness,1,9],rounding=0); // support for B
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEOPixelStripMount(NoCS=0) {
	difference() {
		color("cyan") cuboid([Length+35,Width+5,BaseThickness],rounding=2);
		translate([-43,-7,-1.5]) 2020Mounting(NoCS);
		translate([-37,0,0]) NEOMount();
		translate([-37,2,0]) Gullet();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module Gullet() {
	translate([LeftPos+25/2-11,-3,BaseThickness-2.5]) color("gray") cuboid([Width+2,Width+10,8],rounding=2);
	translate([LeftPos+25/2+Offset+10,-3,BaseThickness-2.5]) color("lightgray") cuboid([Width+2,Width+10,8],rounding=2);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEOMount(Screw=Yes2mmInsert(Use2mmInsert)) {
	translate([LeftPos+25/2,5,-4]) color("pink") cylinder(h=Thickness*3,d=Screw);
	translate([LeftPos+25/2+Offset,5,-4]) color("plum") cylinder(h=Thickness*3,d=Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module 2020Mounting(NoCS=0,Screw=screw5) {
	echo(NoCS);
	translate([7,(Width+5)/2,-20]) color("blue") cylinder(h=Thickness*6,d=Screw);
	translate([Length+28,(Width+5)/2,-20]) color("red") cylinder(h=Thickness*6,d=Screw);
	if(!NoCS) {
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