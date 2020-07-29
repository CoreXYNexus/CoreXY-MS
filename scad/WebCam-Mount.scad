///////////////////////////////////////////////////////////////////////
// WebCam-Mount.scad - lifecam holder and a PI Zero & Cam holder
///////////////////////////////////////////////////////////////////////
// created 1/31/16
// last update 7/26/20
////////////////////////////////////////////////////////////////////////
// ABS or something that can handle the heatbed temperature
/////////////////////////////////////////////////////////////////////////
// 3/23/16	- added clamping screw for cam
// 12/23/18	- Added preview colors and a PI3 with camera in a plastic case holder
//			  Added cubeX.scad
// 4/10/19	- Changed to a PI Zero W all in one holder, currently set for a Raspberry PI Camera Rev1.3
// 6/11/20	- Change PI cam opening to one that can also use wide angle cam, added ability to use 2mm brass inserts
// 7/23/20	- Fixed camera mounting holes
// 7/25/20	- Fixed PIShield() holes
// 7/25/20	- Changed pi camera mounting
/////////////////////////////////////////////////////////////////////////
// https://www.raspberrypi-spy.co.uk/2013/05/pi-camera-module-mechanical-dimensions
// For the PI Zero, I use https://elinux.org/RPi-Cam-Web-Interface
// for the pi zero cover: https://www.thingiverse.com/thing:2165844, the RPI_Zero_W_Case_-_Top_-_Heatsink.stl
// Uses 4 M2 or 2-56 to mount the PI Zero and four M2 or 2-56 to mount the PI Camera
/////////////////////////////////////////////////////////////////////////
// ** NOTE: needs a raft for the built in support
/////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>
Use2mmInsert=0;  // don't have any M2 screws yet
include <brassfunctions.scad>
// vars
///////////////////////////////////////////////////////////////////////
$fn=100;
camdia = 29;	// outside diameter of usb camera
length = 100;	// distance needed from bed to see the entire bed
outer = 12;		// thickness of ring to hold camera
width = camdia + outer;	// width of the ring to hold camera
thickness = 6;	// thickness of extension and mount
camshift = -4.5;	// amount to move camera ring to end of extension
mlength = 20;	// length of the mount
extruder = 0.4;	// extruder size for print support for mount end
stall = 6;	// height of print support for mount end
//----
PIhw=22.86;
PIhl=57.81;
PIChw=21;
PIChh=12.5;
PICameraHole=24;
Layer=0.3; // layer thickness
// note: support for one side needs adjusting if web cam size changes
////////////////////////////////////////////////////////////////////////

Bracket(1);
translate([0,40,0]) FrontCamHolder();
translate([30,40,0])RearCamHolder();
//WCBracket(1);

///////////////////////////////////////////////////////////////////////

module Bracket(PI=0) {
		Cam(PI);
		Clamp(PI);
		Extension(PI);
		Reinforce(PI);
		Mount(PI);
}

/////////////////////////////////////////////////////////////////////////////////////////

module RearCamHolder() {
	difference() {
		color("gray") cubeX([PICameraHole,PICameraHole+5,2],1);
		translate([14,14,-4]) PICamMountingHoles(Yes2mmInsert());
	}
}

//////////////////////////////////////////////////////////////////////////////////////////

module FrontCamHolder() {
	difference() {
		color("gray") cubeX([PICameraHole,PICameraHole+5,2],1);
		translate([14,14,-4]) PICamMountingHoles(screw2);
		color("white") hull() {
			translate([9,14.5,-3]) cylinder(h=10,d=16);
			translate([15,14.5,-3]) cylinder(h=10,d=16);
		}
		color("green") hull() {
			translate([10,6,-3]) cylinder(h=10,d=8);
			translate([10,23,-3]) cylinder(h=10,d=8);
		}
	}
	difference() {
		translate([3.6,25,6]) rotate([180,0,0]) CamSpacers(screw2);
		translate([14,14,-4]) PICamMountingHoles(screw2);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////

module CamSpacers(Screw=screw2) {
	color("red") hull() {
		translate([0,0,-0.5]) cylinder(h=1,d=Screw+1);
		translate([0,0,4]) cylinder(h=1,d=Screw+3);
	}
	color("plum") hull() {
		translate([0,PIChw,-0.5]) cylinder(h=1,d=Screw+1);
		translate([0,PIChw,4]) cylinder(h=1,d=Screw+3);
	}
	color("white") hull() {
		translate([PIChh,0,-0.5]) cylinder(h=1,d=Screw+1);
		translate([PIChh,0,4]) cylinder(h=1,d=Screw+3);
	}
	 color("gray") hull() {
		translate([PIChh,PIChw,-0.5]) cylinder(h=1,d=Screw+1);
		translate([PIChh,PIChw,4]) cylinder(h=1,d=Screw+3);
	}
}

////////////////////////////////////////////////////////////////////////

module WCBracket(PI=0) {
	WCam(PI);
	Clamp(0);
	Extension(PI);
	Reinforce(PI);
	Mount(PI);
}

////////////////////////////////////////////////////////////////////////////////

module PIShield(PI=0) {
	if(PI) {
		difference() {
			color("cyan") cubeX([25,16.5,3.5],1);
			translate([13,12.7,0]) rotate([0,0,90]) PICamMountingHoles(screw2);
		}
		difference() {
			translate([23,2.4,0]) PICamSpacers2(screw2);
			//translate([2,1.6,6]) cube([21,13.5,8]); // pi camera 1.3 needs clearance for the stuff on the back
			translate([13,12.7,0])rotate([0,0,90]) PICamMountingHoles(screw2);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module PIZeroBase(Screw=Yes2mmInsert()) {
	translate([17,0.5,0]) {
		translate([0,0,0]) color("red") cylinder(h=10,d=Screw);
		translate([0,PIhw,0]) color("plum") cylinder(h=10,d=Screw);
		translate([PIhl,0,0]) color("white") cylinder(h=10,d=Screw);
		translate([PIhl,PIhw,0]) color("gray") cylinder(h=10,d=Screw);
	}
}

////////////////////////////////////////////////////////////////////////////////////////

module PICamMountingHoles(Screw=Yes2mmInsert()) {
	translate([-10.5,-10,-2]) {
		translate([0,0,-1]) color("gray") cylinder(h=15,d=Screw);
		translate([0,PIChw,-1]) color("red") cylinder(h=15,d=Screw);
		translate([PIChh,0,-1]) color("plum") cylinder(h=15,d=Screw);
		translate([PIChh,PIChw,-1]) color("white") cylinder(h=15,d=Screw);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PICamSpacers(Screw=screw2) {
	translate([-10.5,-10,-2]) {
		color("red") hull() {
			translate([0,0,-0.5]) cylinder(h=1,d=Screw+1);
			translate([0,0,2]) cylinder(h=1,d=Screw+3);
		}
		color("plum") hull() {
			translate([0,PIChw,-0.5]) cylinder(h=1,d=Screw+1);
			translate([0,PIChw,2]) cylinder(h=1,d=Screw+3);
		}
		color("white") hull() {
			translate([PIChh,0,-0.5]) cylinder(h=1,d=Screw+1);
			translate([PIChh,0,2]) cylinder(h=1,d=Screw+3);
		}
		 color("gray") hull() {
			translate([PIChh,PIChw,-0.5]) cylinder(h=1,d=Screw+1);
			translate([PIChh,PIChw,2]) cylinder(h=1,d=Screw+3);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PICamSpacers2(Screw=screw2) {
	rotate([0,0,90]) {
		color("red") translate([0,0,0]) cylinder(h=7,d=Screw+3);
		color("plum") translate([0,PIChw,0]) cylinder(h=7,d=Screw+3);
		color("white") translate([PIChh,0,0]) cylinder(h=7,d=Screw+3);
		color("gray") translate([PIChh,PIChw,0]) cylinder(h=7,d=Screw+3);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Cam(PI=0) {
	if(!PI) {
		translate([camshift,camdia/2-2.4,camdia/2+outer]) rotate([0,75,0]) difference() {
			color("cyan") cylinder(h=thickness,r=camdia/2+outer);	// outer
			translate([-25,0,-4]) color("red") cubeX([thickness+6,1.5,outer+5],1); // expansion slot
			translate([0,0,-1]) color("gray") cylinder(h=thickness+2,r=camdia/2); // hole
		}
	} else {
		translate([camshift,camdia/2-2.4,camdia/2+outer]) rotate([0,75,0]) {
			difference() {
				color("cyan") cylinder(h=thickness,r=camdia/2+outer);	// outer
				PICameraHole();
				//PICamMountingHoles(screw2);
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PICameraHole() {
	translate([-14,-14,-2]) color("gray") cube([PICameraHole-2,PICameraHole+4,10]); // hole
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WCam(PI=0) {
	translate([camshift,camdia/2-2.4,camdia/2+outer]) rotate([0,75,0]) difference() {
		color("cyan") cylinder(h=thickness,r=camdia/2+outer);	// outer
		translate([-25,0,-4]) color("red") cubeX([thickness+6,1.5,outer+5],1); // expansion slot
		translate([0,0,-1]) color("gray") cylinder(h=thickness+2,r=camdia/2); // hole
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Extension(PI=0) {
	difference() {
		translate([0,-width/6,0]) color("black") cubeX([length,width,thickness],1);
		translate([8.2,5,-2]) color("white") cubeX([3,15,15],1);
		if(PI) {
			PIZeroBase();
			translate([20,19,-thickness-3]) color("white") cubeX([52,8,2*thickness],2);
			translate([66,14,-thickness-3]) color("white") cubeX([6,9,2*thickness],2);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Mount(PI=0) {
	difference() {
		color("blue") rotate([0,-15,0]) translate([length-5,-width/6,-25.8]) cubeX([mlength+2,width,thickness],1);
		// next is not all the way thru to make support of the bottom of the hole
		color("lightgray") rotate([0,-15,0]) translate([length+7,width/3,-(25.8-Layer)]) cylinder(h=thickness*2,d=screw5,$fn=100);
	}
	Support(PI);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Support(PI=0) {
	color("plum") translate([length+mlength-0.85,-width/6,0]) cube([extruder,width,stall]);
	color("gold") rotate([0,0,90]) translate([-width/6+0.1,-(length+mlength-0.85),0]) cube([extruder,width-18,stall]);
	color("white") rotate([0,0,90]) translate([width-6.5,-(length+mlength-0.85),0]) cube([extruder,width-18,stall]);
	color("green") rotate([0,0,90]) translate([width-20,-(length+mlength-0.85),0]) cube([extruder,width-16,stall]);
	color("khaki") rotate([0,0,90]) translate([width-35,-(length+mlength-0.85),0]) cube([extruder,width-16,stall]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Reinforce(PI=0) {
	difference() {
		translate([0,-5,0]) rotate([6,0,0]) color("yellow") cubeX([20,4,20],1);
		translate([5,-7,20]) rotate([6,50,0]) color("pink") cube([25,6,25]);
	}
	difference() {
		translate([0,25,1]) rotate([-6,0,0]) color("red") cubeX([20,4,20],1);
		translate([5,25,21]) rotate([-6,50,0]) color("blue") cube([25,6,25]);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Clamp(PI=0) {
	if(!PI) {
		difference() {
			translate([camshift-4,camdia/2-12,camdia/2+outer+16]) rotate([0,-15,0]) color("black") cubeX([6,20,15],1);
			translate([camshift-5,camdia/2-2.5,camdia/2+outer+15]) rotate([0,-15,0]) color("plum")
				cube([8,1.5,35]); // expansion slot
			translate([camshift-3.5,camdia/2+12,camdia/2+outer+25]) rotate([90,0,0]) color("white")
				cylinder(h=30,d=screw3,$fn=100);
		}
	}
}

///////////// end of lifecam.scad //////////////////////////////////////