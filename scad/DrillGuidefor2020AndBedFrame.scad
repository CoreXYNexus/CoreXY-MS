//////////////////////////////////////////////////////////////////////////////
// DrillGuidefor2020AndBedFrame - helps locate the access holes for extrusions
//////////////////////////////////////////////////////////////////////////////
// created 4/6/2016
// last update 9/15/20
//////////////////////////////////////////////////////////////////////////////
// 4/7/16 - added aversion to use on makerslide
// 4/13/16 - corrected distance between holes
// 6/24/16 - made so that offset determines length
// 12/17/18	- Added cubeX and colors for preview
// 9/15/20	- Added use of brass inserts to make the 2020DrillGuide() last longer
//////////////////////////////////////////////////////////////////////////////
// A drill guide for 2020 to be able to eliminate the plastic brackets
// on the base section.  Drill both for 2040 or makerslide ends, use one hole for 2020
// ** The 5mm brass inserts will need to be drilled out to 5mm **
//////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <inc/cubeX.scad>
use <brassfunctions.scad>
//////////////////////////////////////////////////////////////////////////////
// vars
/////////////////////////////////////////////////////////////////////////////
$fn=100;
UseLarge3mmInsert=1;
width = 30;
thickness = 5;
w2020 = 20.1;
bottom = 10;
offset = 20;//80;
length = offset + 25;
////////////////////////////////////////////////////////////////////////////////

2020DrillGuide();
//MSDrillGuide();
//DrillClips(4); // used to hold the bed onto the 2020 to drill the adjusting mount holes
				 // use #39 drill bit for all three mounting holes, drill through the 2020 and bed,
				 // M3 tap the 2020, drill the bed holes 3mm and countersink
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DrillClips(Quanity=1) { // used to hold bed onto the 2020 to drill the adjusting mount holes
	for(x=[0:Quanity-1]) {
		translate([x*23,0,0]) difference() {
			union() {
				color("cyan") cubeX([20,35,4],2);
				color("blue") cubeX([20,4,20],2);
			}
			translate([10,25,-3]) color("red") cylinder(h=10,d=screw5);
			translate([10,8,12]) rotate([90,0,0]) color("gray") cylinder(h=10,d=Yes3mmInsert(UseLarge3mmInsert));
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////

module 2020DrillGuide(Screw=Yes5mmInsert()) { //2020 channel
	difference() {
		color("cyan") cubeX([length,width,thickness+2],1);
		translate([5,5,3]) color("blue") cube([length,w2020,thickness]);
		translate([bottom+5,w2020/2+5,-5]) color("black") cylinder(h=20,d=Screw);
		translate([offset+bottom+5,w2020/2+5,-5]) color("gray") cylinder(h=20,d=Screw);
	}
}

/////////////////////////////////////////////////////////////////////////////////

module MSDrillGuide(Screw=Yes5mmInsert()) { // to use on makerslide, just has the tab on the end
	difference() {
		color("cyan") cube([length,width-10,thickness+2]);
		translate([5,-1,3]) color("red") cube([length,width+2,thickness]);
		translate([bottom+5,w2020/2,-5]) color("black") cylinder(h=20,d=Screw);
		translate([offset+bottom+5,w2020/2,-5]) color("gray") cylinder(h=20,d=Screw);
	}
}

//////////////////// end of drillguide.scad //////////////////////////////////////

