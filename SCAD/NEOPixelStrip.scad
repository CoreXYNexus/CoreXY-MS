////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NEOPixelStrip.scad
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 2/13/21
// last update 1/9/22
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
include <inc/brassinserts.scad>
include <BOSL2/std.scad> //inc/cubex.scad>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// For https://www.adafruit.com/product/1426
// Uses two M2x10 flat head countersunk screws
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
//FontSet="Comic Sans MS:style=Bold";
//FontSet="Babylon5:style=Regular";
FontSet="Babylon Industrial:style=Normal";  // doesnt't need support
/////////////////////////////////////////////////////////////////////////////////////////////////

//rotate([0,0,180]) // use for test fir
	NEOPixelStripMount(1,1); // no counter sink on strip mount
//translate([0,-2,9]) // test fit mount and cover together
translate([0,25,0]) rotate([180,0,0]) // print with NEOPixelStripMount()
	NEOPixelCover(0); // through hole letters;  must be printed with letter side down

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEOPixelCover(ClearFilament=0,NoCS=0) { // needs to be printed in a tranperant filament
	difference() {								 // infill will be noticable
		translate([0,0,0]) {
			union() {
				color("plum") cuboid([Length+35,Width+4,Thickness],rounding=2);
				translate([-36.6,0,-2]) color("gray") cuboid([13,Width+4,9],rounding=2);
				translate([Length-14.6,0,-2]) color("lightgray") cuboid([13,Width+4,9],rounding=2);
				translate([0,-Width/2,-5]) color("pink") cuboid([Length+35,4,13],rounding=2); // front
			}
		}
		translate([-43,-Width/2-2,-2.5]) 2020Mounting(NoCS);
		//if(!ClearFilament) translate([0,-1,0]) rotate([45,0,0]) color("black") cuboid([Length,Width-3,20],rounding=2);
		//if(!ClearFilament) {
			//translate([-19,6.5,-9]) rotate([90,0,0]) PrintString("B     H",19,8); // label
			translate([-19,-3,-10]) rotate([0,0,0]) PrintString("B     H",19,8); // label
		//} else {
			//translate([-19,6.5,-7]) rotate([90,0,0]) PrintString("B     H",19,8); // label
			//translate([-19,-3,-10]) rotate([0,0,0]) PrintString("B     H",19,8); // label
		//}
		translate([-37.2,-8.2,-14]) {
			translate([LeftPos+25/2,5,0]) color("pink") cylinder(h=Thickness*3,d=screw2);
			translate([LeftPos+25/2+Offset,5,0]) color("plum") cylinder(h=Thickness*3,d=screw2);
		}
	}
	translate([36,Width/2-9.5,1]) color("green") cyl(h=LayerThickness,d=screw5hd);
	translate([-35.5,Width/2-9.5,LayerThickness+0.05]) color("gray") cyl(h=LayerThickness,d=screw5hd);
	//if(!ClearFilament) {
	//	translate([-15.75,-Width/2+1.5,-3.5]) color("white") cuboid([0.25,1,8],rounding=0); // support for B
	//	translate([-15.75,-Width/2+1.5,0]) color("white") cuboid([0.25,1,8],rounding=0); // support for B
	//}
	//else translate([-18.1,-6.1,-5]) color("white") cuboid([NozzleThickness,1,9],rounding=0); // support for B
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEOPixelStripMount(NoCS=0,Hole=0) {
	echo("Mount Hole: ",Hole);
	difference() {
		color("cyan") cuboid([Length+35,Width,BaseThickness],rounding=2);
		translate([-43,-Width/2-1,-1.5]) 2020Mounting(NoCS);
		translate([-37,0,-4]) NEOMount(Hole);
		translate([-37,2,0]) Gullet();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module Gullet() {
	translate([LeftPos+25/2-14,-3,BaseThickness-0.5]) color("gray") cuboid([Width-10,Width+9,8],rounding=2);
	translate([LeftPos+25/2+Offset+14,-3,BaseThickness-0.5]) color("lightgray") cuboid([Width-10,Width+9,8],rounding=2);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module NEOMount(Hole,Screw=Yes2mmInsert(Use2mmInsert)) {
	echo("Hole: ",Hole);
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
	echo(NoCS);
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
	//"Liberation Sans"
	//"Comic Sans MS:style=Bold"
}

/////////////////////////////////////////////////////////////////////////////////////////////////////