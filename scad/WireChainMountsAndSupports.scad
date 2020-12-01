///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// WireChainMountsAndSupports.scad - mounts for a wire chain on the CXY-MSv1
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Wire chain is set to use two 4mm button head screws to attach ends
// Use 5mm to attached to the x carriage
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// create 7/5/2016
// last update 11/14/20
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 7/24/16	- added extra support to corner of xy()
// 7/25/16	- added y() for the y axis wireguide
// 2/28/19	- added to have holes or have no holes for the wireguide bracket in y()
// 8/9/20	- Added XMountWC() to mount the wire chain on the carraige
// 9/29/20	- Added use of M4 brass inserts, renamed modules, adjusted length of XYWireChainMount()
//			- removed XAxisWireChainSpacer() since the XCMount() can have its height set, cleaned up code
// 10/15/20	- Added use of a single wirechain to the x carraige
// 11/14/20	- Fixed YAxisWirechainOnly(), add height to XAxisWireChainFrameMount()
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
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
//YAxisWireChainOnly();  // if using the single, then you need this if there is wiring at the xend

////////////////////////////////////////////////////////////////////////////////////////////////////

module YAxisWireChainOnly() {
	XYAxisWireChainMount2(Yes4mmInsert(Use4mmInsert),20+ExtrusionSize);	// on x axis carriage plate for Y wireguide
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

module XMountWCSingle(Screw=Yes4mmInsert(Use4mmInsert)) {
	difference() {
		union() {
			translate([0,40,0]) color("red") cubeX([55,thickness+2,35],2); // wirechain mount
			color("cyan") cubeX([8,45,20],2); // mount to xcarriage
		}
		translate([43,50,15]) rotate([90,0,0]) WCSingleHoles(Screw);
		translate([0,-5,47]) rotate([0,90,0]) XMountHoles(screw5);
	}
	translate([4,3,0]) color("black") cylinder(h=LayerThickness,d=20); // print support tab
	translate([52,43,0]) color("gray") cylinder(h=LayerThickness,d=20); // print support tab
}

////////////////////////////////////////////////////////////////

module XMountHoles(Screw=screw5) {
	color("gold") hull() {
		translate([35,13,-5]) cylinder(h=20, d=Screw);
		translate([39,13,-5]) cylinder(h=20, d=Screw);
	}
	color("red") hull() {
		translate([35,13,7]) cylinder(h=5, d=screw5hd);
		translate([39,13,7]) cylinder(h=5, d=screw5hd);
	}
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
		color("cyan") cubeX([XheightS+ExtrusionSize,width,thickness+2],2);
		if(ExtrusionSize==20)
			translate([XheightS+ExtrusionSize-10,28,-1]) ExtrusionMountHoles();
		if(ExtrusionSize==40) {
			translate([XheightS+ExtrusionSize-10,28,-1]) ExtrusionMountHoles();
			translate([XheightS+ExtrusionSize-30,28,-1]) ExtrusionMountHoles();
		}
		translate([10,13,0]) WCSingleHoles(Screw);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TwoWirechains() {
	if($preview) %translate([-55,-75,-5]) cubeX([200,200,5],2);
	YAxisWireChain(1);	// on frame for y axis to hold wireguide end
	translate([60,0,0]) YAxisWireChain(0);	// on frame for y axis to support wireguide
	translate([30,0,0]) YAxisWireChain(0);	// on frame for y axis to support wireguide
	translate([0,40,0]) XYAxisWireChainMount();	// on x axis carriage plate for X&Y wireguide ends
	//translate([122,0,0]) rotate([0,0,90]) ZipTieMount();
	translate([-40,0,0]) XMountWC(8,Yes4mmInsert(Use4mmInsert),screw4);  // get xcarraige end of wire chain off the endstop
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XMountWC(Tall=0,Screw=screw4,ScrewMount=Yes4mmInsert(Use4mmInsert)) {
	difference() {
		union() {
			color("red") cubeX([35,80,4],2); // extension
			color("cyan") cubeX([35,13,10+Tall],2); // spacer
			translate([21,10,0]) color("blue") cubeX([12,12,8],2);  // make tall enough for the M4 insert
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
			if(Holes) color("black") cubeX([thickness+2,width,tab],2);
			support();
			color("cyan") cubeX([height/2+4,width,thickness],2);
		}
		translate([height/2-10,width-8,-2]) ExtrusionMountHoles();
		if(Holes) {
			translate([-2,width/2-5,tab/2+thickness/2]) rotate([0,90,0]) color("yellow")
				cylinder(h=thickness*4,d=Yes4mmInsert(Use4mmInsert));
			translate([-2,width/2+5,tab/2+thickness/2]) rotate([0,90,0]) color("purple")
				cylinder(h=thickness*4,d=Yes4mmInsert(Use4mmInsert));
		}
	}
	if(!Holes) color("lightgray") cubeX([thickness,width,tab],2);
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

module support() {
	difference() {
		translate([-15,width/2-2.25,7.5]) rotate([0,40,0]) color("pink") cubeX([width,thickness,tab],2);
		translate([-20,width/2-4,-22]) rotate([0,0,0]) color("red") cube([width*2,thickness+4,tab],2);
		translate([-22,width/2-4,-2]) rotate([0,0,0]) color("blue") cube([tab,thickness+4,width],2);
	}
}

/////////////////////////////////////////////////////////////////

module XYAxisWireChainMount(Screw=Yes4mmInsert(Use4mmInsert),XheightS = 52+ExtrusionSize) {
	// on x axis carriage plate for both wireguides
	difference() {
		union() {
			color("cyan") cubeX([XheightS,width,thickness],2);
			color("purple") cubeX([thickness+2,width,tab2],2);
			translate([3,0,0]) support();
		}
		translate([XheightS-10,28,-2]) ExtrusionMountHoles(Yes5mmInsert(Use5mmInsert));
		// wireguide mount
		translate([-2,12,tab/2-2]) rotate([0,90,0]) color("gray") cylinder(h=thickness*4,d=Screw);
		translate([-2,12,tab/2+8]) rotate([0,90,0]) color("white") cylinder(h=thickness*4,d=Screw);
		translate([-2,width/2+2,tab2-10]) rotate([0,90,0]) color("black") cylinder(h=thickness*4,d=Screw);
		translate([-2,width/2+12,tab2-10]) rotate([0,90,0]) color("green") cylinder(h=thickness*4,d=Screw);
	}
}

/////////////////////////////////////////////////////////////////

module XYAxisWireChainMount2(Screw=Yes4mmInsert(Use4mmInsert),XheightS = 52+ExtrusionSize) {
	// on x axis carriage plate for y endstop and led wirechain
	difference() {
		union() {
			color("cyan") cubeX([XheightS,width,thickness],2);
			color("purple") cubeX([thickness+2,width,tab2],2);
			translate([3,0,0]) support();
		}
		translate([XheightS-10,28,-2]) ExtrusionMountHoles(Yes5mmInsert(Use5mmInsert));
		// wireguide mount
		//translate([-2,12,tab/2-2]) rotate([0,90,0]) color("gray") cylinder(h=thickness*4,d=Screw);
		//translate([-2,12,tab/2+8]) rotate([0,90,0]) color("white") cylinder(h=thickness*4,d=Screw);
		translate([-2,width/2+2,tab2-10]) rotate([0,90,0]) color("black") cylinder(h=thickness*4,d=Screw);
		translate([-2,width/2+12,tab2-10]) rotate([0,90,0]) color("green") cylinder(h=thickness*4,d=Screw);
	}
}
///////////////////////////////////////////////////////////////////////////////////

module ZipTieMount() {
	difference() {
		union() {
			color("cyan") cubeX([4,20,20],2);
			color("blue") cubeX([70,20,4],2);
		}
		translate([-3,10,10]) rotate([0,90,0]) color("red") cylinder(h=10,d=screw5);
		translate([3,10,10]) rotate([0,90,0]) color("red") cylinder(h=5,d=screw5hd);
		color("green") hull() {
			translate([20,10,-3]) cylinder(h=10,r=screw5/2);
			translate([60,10,-3]) cylinder(h=10,r=screw5/2);
		}
	}
}

//////////////////// end of wireguide.scad //////////////////////////////////////////////////////////////////////////////