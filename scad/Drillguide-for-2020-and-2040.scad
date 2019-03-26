//////////////////////////////////////////////////////////////////////////////
// Drill-Guide-for-2020-and-2040 - helps locate the access holes for extrusions
//////////////////////////////////////////////////////////////////////////////
// created 4/6/2016
// last update 12/17/2018
//////////////////////////////////////////////////////////////////////////////
// 4/7/16 - added aversion to use on makerslide
// 4/13/16 - corrected distance between holes
// 6/24/16 - made so that offset determines length
// 12/17/18	- Added cubeX and colors for preview
//////////////////////////////////////////////////////////////////////////////
// A drill guide for 2020 to be able to eliminate the plastic brackets
// on the base section.  Drill both for 2040 or makerslide ends, use one hole for 2020
//////////////////////////////////////////////////////////////////////////////
include <inc/cubeX.scad>
//////////////////////////////////////////////////////////////////////////////
// vars
/////////////////////////////////////////////////////////////////////////////
$fn=100;
screw5 = 5.6;
width = 30;
thickness = 5;
w2020 = 20.1;
bottom = 10;
offset = 20;//80;
length = offset + 25;
////////////////////////////////////////////////////////////////////////////////

drillguide();
//drillguide2();
//test(); // test print for fitting 2020

/////////////////////////////////////////////////////////////////////////////////

module drillguide() { //2020 channel
	difference() {
		color("cyan") cubeX([length,width,thickness+2],1);
		translate([5,5,3]) color("blue") cube([length,w2020,thickness]);
		translate([bottom+5,w2020/2+5,-5]) color("black") cylinder(h=20,r=screw5/2,$fn=100);
		translate([offset+bottom+5,w2020/2+5,-5]) color("gray") cylinder(h=20,r=screw5/2,$fn=100);
	}
}

/////////////////////////////////////////////////////////////////////////////////

module drillguide2() { // to use on makerslide
	difference() {
		color("cyan") cube([length,width-10,thickness+2]);
		translate([5,-1,3]) color("red") cube([length,width+2,thickness]);
		translate([bottom+5,w2020/2,-5]) color("black") cylinder(h=20,r=screw5/2,$fn=100);
		translate([offset+bottom+5,w2020/2,-5]) color("gray") cylinder(h=20,r=screw5/2,$fn=100);
	}
}

//////////////////////////////////////////////////////////////////////////////////

module test() { // test print for checking fit on 2020
	difference() {
		drillguide();
		translate([20,-2,-2]) color("gold") cube([length+5,width+5,thickness*2]);
	}
}

//////////////////// end of drillguide.scad //////////////////////////////////////

