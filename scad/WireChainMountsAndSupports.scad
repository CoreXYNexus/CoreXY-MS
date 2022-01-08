///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// WireChainMountsAndSupports.scad - mounts for a wire chain on the CXY-MSv1
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// create 7/5/2016
// last update 1/6/22
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 7/24/16	- added extra support to corner of xy()
// 7/25/16	- added y() for the y axis wireguide
// 2/28/19	- added to have holes or have no holes for the wireguide bracket in y()
// 8/9/20	- Added XMountWC() to mount the wire chain on the carraige
// 9/29/20	- Added use of M4 brass inserts, renamed modules, adjusted length of XYWireChainMount()
//			- removed XAxisWireChainSpacer() since the XCMount() can have its height set, cleaned up code
// 10/15/20	- Added use of a single wirechain to the x carraige
// 11/14/20	- Fixed YAxisWirechainOnly(), add height to XAxisWireChainFrameMount()
// 11/3/21	- Added a ziptie holes
// 1/6/22	- BOSL2
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Wire chain is set to use two 4mm button head screws to attach ends
// Use 5mm to attached to the x carriage
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <bosl2/std.scad>
include <inc/brassinserts.scad>
$fn=100;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
Xheight = 100;
ExtrusionSize=20; // 20 for 2020, 40 for 2040

height=50;
width = 37;	// width of wire chain
thickness = 5;
tab = 25;
tab2 = 52;
LayerThickness=0.3;
//----------------------------------------------------
Use4mmInsert=1;
Use5mmInsert=1;
///////////////////////////////////////////////////////////////////////

//TwoWirechains(); // two wirechains, on from xcarraige to xend, then xend to frame
SingleWirechainX(); // one wirechain to x carraige
translate([0,100,0]) 
	YAxisWireChainOnly(screw4);  // if using the single, then you need this if there is wiring at the xend

////////////////////////////////////////////////////////////////////////////////////////////////////

module YAxisWireChainOnly(Screw=Yes4mmInsert(Use4mmInsert)) {
	YAxisWireChainMount(Screw,20+ExtrusionSize);	// on x axis carriage plate for Y wireguide
	translate([45,0,0]) YAxisWireChain(0);
	translate([78,0,0]) YAxisWireChain(0);
	translate([110,0,0]) YAxisWireChain(1);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module SingleWirechainX(Screw=Yes4mmInsert(Use4mmInsert)) {
	XMountWCSingle(Screw);
	translate([0,55,0]) XAxisWireChainFrameMount(Screw);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XMountWCSingle(Screw=Yes4mmInsert(Use4mmInsert),DoTab=1) {
	difference() {
		union() {
			translate([0,40,0]) color("red") cuboid([55,thickness+2,35],rounding=2,p1=[0,0]); // wirechain mount
			color("cyan") cuboid([8,45,20],rounding=2,p1=[0,0]); // mount to xcarriage
		}
		translate([43,50,15]) rotate([90,0,0]) WCSingleHoles(Screw);
		translate([0,-5,47]) rotate([0,90,0]) XMountHoles(screw5);
		translate([5,52,29]) color("blue") rotate([90,0,0]) cylinder(h=20,d=screw5); // ziptie hole
	}
	if(DoTab) {
		translate([4,3,0]) color("green") cylinder(h=LayerThickness,d=20); // print support tab
		translate([52,43,0]) color("gray") cylinder(h=LayerThickness,d=20); // print support tab
	}
}

////////////////////////////////////////////////////////////////

module XMountHoles(Screw=screw5) {
	color("gold") translate([37,13,-5]) cylinder(h=20, d=Screw);
	color("red") translate([37,13,7]) cylinder(h=5, d=screw5hd);
	color("red") hull() {
		translate([37,31,-5]) cylinder(h=20, d=Screw);
		translate([37,35,-5]) cylinder(h=20, d=Screw);
	}
	color("gold") hull() {
		translate([37,31,7]) cylinder(h=5, d=screw5hd);
		translate([37,35,7]) cylinder(h=5, d=screw5hd);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module WCSingleHoles(Screw=Yes4mmInsert(Use4mmInsert)) {
	color("black") cylinder(h=15,d=Screw); // second wire chain mount screw hole
	translate([0,10,0]) color("gray") cylinder(h=15,d=Screw); // second wire chain mount screw hole
}

/////////////////////////////////////////////////////////////////

module XAxisWireChainFrameMount(Screw=Yes4mmInsert(Use4mmInsert),XheightS=92) {	// on x axis carriage plate for both wireguides
	difference() {
		color("cyan") cuboid([XheightS+ExtrusionSize,width,thickness+2],rounding=2,p1=[0,0]);
		if(ExtrusionSize==20)
			translate([XheightS+ExtrusionSize-10,28,-1]) ExtrusionMountHoles();
		if(ExtrusionSize==40) {
			translate([XheightS+ExtrusionSize-10,28,-1]) ExtrusionMountHoles();
			translate([XheightS+ExtrusionSize-30,28,-1]) ExtrusionMountHoles();
		}
		translate([10,13,0]) WCSingleHoles(Screw);
		translate([35,5,-5]) color("blue") cylinder(h=20,d=screw5); // ziptie hole
		translate([35,30,-5]) color("green") cylinder(h=20,d=screw5); // ziptie hole
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TwoWirechains() {
	if($preview) %translate([-55,-75,-5]) cuboid([200,200,5],rounding=2,p1=[0,0]);
	YAxisWireChain(1);	// on frame for y axis to hold wireguide end
	translate([60,0,0]) YAxisWireChain(0);	// on frame for y axis to support wireguide
	translate([30,0,0]) YAxisWireChain(0);	// on frame for y axis to support wireguide
	translate([0,40,0]) YAxisWireChainMount();	// on x axis carriage plate for X&Y wireguide ends
	translate([-40,0,0]) XMountWC(8,Yes4mmInsert(Use4mmInsert),screw4);  // get xcarraige end of wire chain off the endstop
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XMountWC(Tall=0,Screw=screw4,ScrewMount=Yes4mmInsert(Use4mmInsert)) {
	difference() {
		union() {
			color("red") cuboid([35,80,4],rounding=2,p1=[0,0]); // extension
			color("cyan") cuboid([35,13,10+Tall],rounding=2,p1=[0,0]); // spacer
			translate([21,10,0]) color("blue") cuboid([12,12,8],rounding=2,p1=[0,0]);  // make tall enough for the M4 insert
		}
		translate([27,17,-2]) color("black") cylinder(h=15,d=Screw); // second wire chain mount screw hole
		translate([40,-30,0]) rotate([0,0,90]) ESWCHoles(ScrewMount,Tall);
	}
}

////////////////////////////////////////////////////////////////

module ESWCHoles(Screw=screw5,Tall=0) {
	color("gold") hull() {
		translate([35,13,-5]) cylinder(h=20+Tall, d=Screw);
		translate([39,13,-5]) cylinder(h=20+Tall, d=Screw);
	}
	color("red") hull() {
		translate([37,31,-5]) cylinder(h=20+Tall, d=Screw);
		translate([37,35,-5]) cylinder(h=20+Tall, d=Screw);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module YAxisWireChain(Holes=1) {	// 	// on frame for y axis
	difference() { // wireguide mount
		union() {
			if(Holes) color("black") cuboid([thickness+2,width,tab],rounding=2,p1=[0,0]);
			SupportBrace();
			color("cyan") cuboid([height/2+4,width,thickness],rounding=2,p1=[0,0]);
		}
		translate([height/2-10,width-8,-2]) ExtrusionMountHoles();
		if(Holes) {
			translate([-2,width/2-5,tab/2+thickness/2]) rotate([0,90,0]) color("yellow")
				cylinder(h=thickness*4,d=Yes4mmInsert(Use4mmInsert));
			translate([-2,width/2+5,tab/2+thickness/2]) rotate([0,90,0]) color("purple")
				cylinder(h=thickness*4,d=Yes4mmInsert(Use4mmInsert));
		}
	}
	if(!Holes) color("lightgray") cuboid([thickness,width,tab],rounding=2,p1=[0,0]);
}

///////////////////////////////////////////////////////////////////////////////////////////

module ExtrusionMountHoles(Screw=screw5) {
	color("red") cylinder(h=thickness*4,d=Screw);
	translate([0,-20,0]) color("blue") cylinder(h=thickness*4,d=Screw);
	if(Screw==screw5) { // countersink if screw5
		translate([0,0,6]) color("blue") cylinder(h=thickness,d=screw5hd);
		translate([0,-20,6]) color("red") cylinder(h=thickness,d=screw5hd);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SupportBrace() {
	difference() {
		translate([-15,width/2-2.25,7.5]) rotate([0,40,0]) color("pink") cuboid([width,thickness,tab],rounding=2,p1=[0,0]);
		translate([-20,width/2-4,-22]) rotate([0,0,0]) color("red") cube([width*2,thickness+4,tab]);
		translate([-22,width/2-4,-2]) rotate([0,0,0]) color("blue") cube([tab,thickness+4,width]);
	}
}

/////////////////////////////////////////////////////////////////

module YAxisWireChainMount(Screw=Yes4mmInsert(Use4mmInsert),XheightS=52+ExtrusionSize,ScrewMount=Yes5mmInsert(Use5mmInsert)) {
	// on x axis carriage plate for y endstop and led wirechain
	difference() {
		union() {
			color("cyan") cuboid([XheightS,width,thickness],rounding=2,p1=[0,0]);
			color("purple") cuboid([thickness+2,width,tab2],rounding=2,p1=[0,0]);
			translate([3,0,0]) SupportBrace();
		}
		translate([XheightS-10,28,-2]) ExtrusionMountHoles(ScrewMount);
		translate([-2,width/2+2,tab2-10]) rotate([0,90,0]) color("black") cylinder(h=thickness*4,d=Screw);
		translate([-2,width/2+12,tab2-10]) rotate([0,90,0]) color("green") cylinder(h=thickness*4,d=Screw);
	}
}

//////////////////// end of wireguide.scad //////////////////////////////////////////////////////////////////////////////