///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// DrillGuides.scad - helps locate the access holes for extrusions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 4/6/2016
// last update 1/16/22
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 4/7/16 - added aversion to use on makerslide
// 4/13/16 - corrected distance between holes
// 6/24/16 - made so that offset determines length
// 12/17/18	- Added cubeX and colors for preview
// 9/15/20	- Added ability to use brass inserts to make the 2020DrillGuide() last longer
// 10/9/21	- Changed to BOSL2
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// A drill guide for 2020 to be able to eliminate the plastic brackets
// on the base section.  Drill both for 2040 or makerslide ends, use one hole for 2020
// ** The 5mm brass inserts will need to be drilled out to 5mm **
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <bosl2/std.scad>
use <inc/brassinserts.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Use3mmInsert=1;
LargeInsert=0;
Use5mmInsert=0; // 1: use M5 brassinsterts, you'll need to drill them out to 5mm
width = 30;
thickness = 5;
w2020 = 20.1;
bottom = 10;
offset = 20;//80;
length = offset + 25;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

2020DrillGuide();
//translate([0,-30,0])
//	MSDrillGuide();
translate([0,40,0])
BedDrillClips(4);	// used to hold the bed onto the 2020 to drill the adjusting mount holes
					// use #39 drill bit for all three mounting holes, drill through the 2020 and bed,
					// M3 tap the 2020, drill the bed holes 3mm and countersink
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//module cubeX(Size,Round=0) {
//	cuboid(Size,rounding=Round,p1=[0,0]);
//}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BedDrillClips(Quanity=1) { // used to hold bed onto the 2020 to drill the adjusting mount holes
	for(x=[0:Quanity-1]) {
		translate([x*23,0,0]) difference() {
			union() {
				color("cyan") cuboid([20,45,4],rounding=2,p1=[0,0]);
				color("blue") cuboid([20,4,20],rounding=2,p1=[0,0]);
			}
			translate([10,35,-3]) color("red") cylinder(h=10,d=screw5);
			translate([10,8,12]) rotate([90,0,0]) color("gray") cylinder(h=10,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////

module 2020DrillGuide(Screw=Yes5mmInsert(Use5mmInsert)) { //2020 channel
	difference() {
		color("cyan") cuboid([length,width,thickness+2],rounding=1,p1=[0,0]);
		translate([5,5,3]) color("blue") cube([length,w2020,thickness]);
		if(Use5mmInsert) {
			translate([bottom+5,w2020/2+5,-5]) color("black") cylinder(h=20,d=Screw);
			translate([offset+bottom+5,w2020/2+5,-5]) color("gray") cylinder(h=20,d=Screw);
		} else {
			translate([bottom+5,w2020/2+5,-5]) color("black") cylinder(h=20,d=screw5);
			translate([offset+bottom+5,w2020/2+5,-5]) color("gray") cylinder(h=20,d=screw5);
}
	}
}

/////////////////////////////////////////////////////////////////////////////////

module MSDrillGuide(Screw=Yes5mmInsert(Use5mmInsert)) { // to use on makerslide, just has the tab on the end
	difference() {
		color("cyan") cuboid([length,width-10,thickness+2],rounding=2,p1=[0,0]);
		translate([5,-1,3]) color("red") cube([length,width+2,thickness]);
		if(Use5mmInsert) {
			translate([bottom+5,w2020/2,-5]) color("black") cylinder(h=20,d=Screw);
			translate([offset+bottom+5,w2020/2,-5]) color("gray") cylinder(h=20,d=Screw);
		} else {
			translate([bottom+5,w2020/2,-5]) color("black") cylinder(h=20,d=screw5);
			translate([offset+bottom+5,w2020/2,-5]) color("gray") cylinder(h=20,d=screw5);
		}
	}
}

//////////////////// end of drillguide.scad //////////////////////////////////////

