///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// WireChain.scad
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// create 7/5/2016
// last update 5/21/22
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
// 2/17/22	- Default only makes the one for the X axis
// 3/15/22	- Added enstop mount to XMountWCSingle(); from endstops.scad
// 5/21/22	- Adjusted X endstop position and widened mounting a bit
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Wire chain is set to uses M3 screws to attach ends
// X uses one https://www.amazon.com/gp/product/B07QYM88MQ
// 15mm x 15mm(Inner H x Inner W) Black Plastic Cable Wire Carrier Drag Chain 1M Length
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <bosl2/std.scad>
include <inc/brassinserts.scad>
$fn=100;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Use2mmInsert=1;
Use4mmInsert=1;
Use5mmInsert=1;
XHeight = 100;
ExtrusionSize=20; // 20 for 2020, 40 for 2040
Height=50;
Width = 37;	// width of wire chain
Thickness = 5;
TabSupport = 25;
TabSupport2 = 52;
Switch_ht=20;//15;		// height of holder
SwitchShift = 0;	// move switch mounting holes along width
LayerThickness=0.3;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

SingleWirechainX(); // one wirechain to x carraige

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SingleWirechainX(Screw=Yes4mmInsert(Use4mmInsert)) {
	XMountWCSingle(Screw);
	translate([0,55,0]) XAxisWireChainFrameMount(Screw);
	translate([65,10,0]) YAxisWireChain(0);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XMountWCSingle(Screw=Yes4mmInsert(Use4mmInsert),DoTabSupport=1) {
	difference() {
		union() {
			color("red") hull() {
				translate([40,42,25/2]) cuboid([20,Thickness+2,25],rounding=3); // wirechain mount
				translate([2.5,42,35/2]) cuboid([6,Thickness+2,35],rounding=3); // wirechain mount
			}
			color("cyan") cuboid([Thickness+1,45,35],rounding=3,p1=[0,0]); // mount to xcarriage
			translate([4,22.5,8/2]) color("gray") cuboid([6,44,8],rounding=2.5); // endstop switch mounting
		}
		translate([43,50,8]) rotate([90,0,0]) WCSingleHoles(Screw);
		translate([2,11,27]) rotate([0,90,0]) XMountHoles(screw5,1);
		translate([20,55,25]) color("blue") rotate([90,0,0]) cylinder(h=20,d=screw5); // ziptie hole
		translate([-1,13,-8.5]) rotate([0,90,0]) EndstopMounting();
	}
	if(DoTabSupport) {
		translate([3,3,0]) color("green") cylinder(h=LayerThickness,d=20); // print support TabSupport
		translate([47,42,0]) color("gray") cylinder(h=LayerThickness,d=20); // print support TabSupport
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EndstopMounting(Sep=10,DiagOffset=0,Offset=0,Screw=Yes2mmInsert(Use2mmInsert),Adjust=0) {
	if(DiagOffset) {
			translate([Adjust-22,0,0]) {
				translate([-(Switch_ht-Offset)+14,SwitchShift,-1]) color("purple") cylinder(h = 11, d = Screw);
				translate(v = [-(Switch_ht-Offset)+14+DiagOffset,SwitchShift+Sep,-1]) color("gray")
					cylinder(h = 11, d=Screw);
			}
	} else {
		translate([Adjust-6,0,0]) {
			translate([-(Switch_ht-Offset)+14,SwitchShift,-1]) color("purple") cylinder(h = 11, d = Screw);
			translate(v = [-(Switch_ht-Offset)+14+DiagOffset,SwitchShift+Sep,-1]) color("gray")
				cylinder(h = 11, d=Screw);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XMountHoles(Screw=screw5,DoCS=0) {
	color("gold") cyl(h=20, d=Screw);
	if(DoCS) translate([0,0,5]) color("red") cyl(h=5, d=screw5hd);
	translate([0,17,0]) {
		color("red") hull() {
			cyl(h=20, d=Screw);
			translate([0,3,0]) cyl(h=20, d=Screw);
		}
		if(DoCS) {
			translate([0,0,5]) color("gold") hull() {
				cyl(h=5, d=screw5hd);
				translate([0,3,0]) cyl(h=5, d=screw5hd);
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WCSingleHoles(Screw=Yes4mmInsert(Use4mmInsert)) {
	color("black") cylinder(h=15,d=Screw); // second wire chain mount screw hole
	translate([0,10,0]) color("gray") cylinder(h=15,d=Screw); // second wire chain mount screw hole
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XAxisWireChainFrameMount(Screw=Yes4mmInsert(Use4mmInsert),XHeightS=92) {
	difference() {
		color("cyan") cuboid([XHeightS+ExtrusionSize,Width,Thickness+2],rounding=3,p1=[0,0]);
		if(ExtrusionSize==20)
			translate([XHeightS+ExtrusionSize-10,28,-1]) ExtrusionMountHoles();
		if(ExtrusionSize==40) {
			translate([XHeightS+ExtrusionSize-10,28,-1]) ExtrusionMountHoles();
			translate([XHeightS+ExtrusionSize-30,28,-1]) ExtrusionMountHoles();
		}
		translate([10,13,0]) WCSingleHoles(Screw);
		translate([35,5,-5]) color("blue") cylinder(h=20,d=screw5); // ziptie hole
		translate([35,30,-5]) color("green") cylinder(h=20,d=screw5); // ziptie hole
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TwoWirechains() {
	if($preview) %translate([-55,-75,-5]) cuboid([200,200,5],rounding=2,p1=[0,0]);
	YAxisWireChain(1);	// on frame for y axis to hold wireguide end
	translate([60,0,0]) YAxisWireChain(0);	// on frame for y axis to support wireguide
	translate([30,0,0]) YAxisWireChain(0);	// on frame for y axis to support wireguide
	translate([0,40,0]) YAxisWireChainMount();	// on x axis carriage plate for X&Y wireguide ends
	translate([-40,0,0])
		XMountWC(8,Yes4mmInsert(Use4mmInsert),screw4);  // get xcarraige end of wire chain off the endstop
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XMountWC(Tall=0,Screw=screw4,ScrewMount=Yes4mmInsert(Use4mmInsert)) {
	difference() {
		union() {
			color("red") cuboid([35,80,4],rounding=2,p1=[0,0]); // extension
			color("cyan") cuboid([35,13,10+Tall],rounding=2,p1=[0,0]); // spacer
			translate([21,10,0]) color("blue")
				cuboid([12,12,8],rounding=2,p1=[0,0]);  // make tall enough for the M4 insert
		}
		translate([27,17,-2]) color("black") cylinder(h=15,d=Screw); // second wire chain mount screw hole
		translate([40,-30,0]) rotate([0,0,90]) ESWCHoles(ScrewMount,Tall);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
			if(Holes) color("black") cuboid([Thickness+2,Width,TabSupport],rounding=3,p1=[0,0]);
			SupportBrace();
			color("cyan") cuboid([Height/2+4,Width,Thickness+1],rounding=3,p1=[0,0]);
		}
		translate([Height/2-10,Width-8,-2]) ExtrusionMountHoles();
		if(Holes) {
			translate([-2,Width/2-5,TabSupport/2+Thickness/2]) rotate([0,90,0]) color("yellow")
				cylinder(h=Thickness*4,d=Yes4mmInsert(Use4mmInsert));
			translate([-2,Width/2+5,TabSupport/2+Thickness/2]) rotate([0,90,0]) color("purple")
				cylinder(h=Thickness*4,d=Yes4mmInsert(Use4mmInsert));
		}
	}
	if(!Holes) color("lightgray") cuboid([Thickness+1,Width,TabSupport],rounding=3,p1=[0,0]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtrusionMountHoles(Screw=screw5) {
	color("red") cylinder(h=Thickness*4,d=Screw);
	translate([0,-20,0]) color("blue") cylinder(h=Thickness*4,d=Screw);
	if(Screw==screw5) { // countersink if screw5
		translate([0,0,6]) color("blue") cylinder(h=Thickness,d=screw5hd);
		translate([0,-20,6]) color("red") cylinder(h=Thickness,d=screw5hd);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SupportBrace() {
	difference() {
		translate([-15,Width/2-2.25,7.5]) rotate([0,40,0])
			color("pink") cuboid([Width,Thickness,TabSupport],rounding=2.5,p1=[0,0]);
		translate([-20,Width/2-4,-22]) rotate([0,0,0]) color("red") cube([Width*2,Thickness+4,TabSupport]);
		translate([-22,Width/2-4,-2]) rotate([0,0,0]) color("blue") cube([TabSupport,Thickness+4,Width]);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module YAxisWireChainOnly(Screw=Yes4mmInsert(Use4mmInsert)) {
	YAxisWireChainMount(Screw,20+ExtrusionSize);	// on x axis carriage plate for Y wireguide
	translate([45,0,0]) YAxisWireChain(0);
	translate([78,0,0]) YAxisWireChain(0);
	translate([110,0,0]) YAxisWireChain(1);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module YAxisWireChainMount(Screw=Yes4mmInsert(Use4mmInsert),XHeightS=52+ExtrusionSize,
			ScrewMount=Yes5mmInsert(Use5mmInsert)) {
	difference() {
		union() {
			color("cyan") cuboid([XHeightS,Width,Thickness],rounding=2,p1=[0,0]);
			color("purple") cuboid([Thickness+2,Width,TabSupport2],rounding=2,p1=[0,0]);
			translate([3,0,0]) SupportBrace();
		}
		translate([XHeightS-10,28,-2]) ExtrusionMountHoles(ScrewMount);
		translate([-2,Width/2+2,TabSupport2-10]) rotate([0,90,0]) color("black") cylinder(h=Thickness*4,d=Screw);
		translate([-2,Width/2+12,TabSupport2-10]) rotate([0,90,0]) color("green") cylinder(h=Thickness*4,d=Screw);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////