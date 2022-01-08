/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CircluarFanDuct5015.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created 8/10/2019
// last upate 9/5/20
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/10/19	- Created fan duct of my own design
// 8/12/19	- Added ability to set length
// 8/27/19	- Created v3 with a taper next to the fan to clear the mount better
// 6/18/20	- Vreated a blower nozzle for 4010 blower, began circular version
// 6/19/20	- Added mockup of 4010 from https://www.thingiverse.com/thing:2943994
// 7/4/20	- Made circular fan duct long enought for an titan aero
// 8/1/20	- Made angle adjustable on CircularDuct() and cleaned up unused code
// 8/7/20	- Removed more partial blockages inside and adjust the inside of the duct extensions
// 9/5/20	- Change the FanDuct4040.scad to use a 5015 blower - CircularFanDuct5015.scad
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
include <inc/screwsizes.scad>
use <inc/brassinserts.scad>
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Use4mmInsert=1;
Thickness = 6.5;
MHeight = 6;
MWidth = 60;
FHeight = 10;
MountingHoleHeight = 60; 	// screw holes may need adjusting when changing the front to back size
ExtruderOffset = 18;		// adjusts extruder mounting holes from front edge
FanSpacing = 32;			// hole spacing for a 40mm fan
PCfan_spacing = 47;			// mount spacing to extruder platform
BlowerWidth=15;
BlowerLength=20;
BlowerScrewUpper=45;
BlowerScrewUpperOffset=3.5;
LayerHeight=0.3;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Blower5015Output();
//CircularDuct(1,0.9,-0.3,50,0); // Titan with an E3Dv6, with the extruder mount set up for a Titan Aero
	// ShiftLR=0,Angle=0,ShiftBracketUD=0,ScrewHZ=0,Show=0
CircularDuct(1,0.9,-0.3,25,0); // titan aero *** needs testing for fit ***
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CircularDuct(ShiftLR=0,Angle=0,ShiftBracketUD=0,ScrewHZ=0,Show=0) {
	difference() {  // mounting bracket
		union() {
			translate([-14+ShiftLR,-5,16.5+ShiftBracketUD]) rotate([90,0,0]) CircularFanBase(ScrewHZ,ScrewHZ,ShiftLR,Angle);
			translate([42,-17.5,0]) color("black") cylinder(h=LayerHeight,d=15);  // CircularFanBase support tab
		}
		translate([-17,-28,1]) color("red") cube([35,15,8]);
		translate([17,-21,1]) rotate([0,0,48]) color("brown") cube([10,10,8]);
		translate([-17,-21,1]) rotate([0,0,48]) color("black") cube([10,10,8]);
//		translate([-20,-28,5]) color("white") cube([50,50,50]);
	}
	difference() {
		translate([10,-19.5,0]) rotate([0,0,180]) Blower5015Output();
//		translate([-20,-28,5]) color("white") cube([50,50,50]);
		translate([-9,-27,1]) rotate([0,0,50]) color("gray") cube([5,10,9]);
		translate([6,-21.3,1]) color("black") rotate([0,0,-60]) cube([5,10,9]);
	}
	difference() {
		MainDuct();
		translate([-11,-26.2,3]) color("green") cube([21,6,11]);
//		translate([-20,-28,5]) color("white") cube([50,50,50]);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MainDuct() {
	union() {
		difference() { // at fan
			union() {
				CircularDuctOuter();
				CircularDuctInner();
			}
			translate([-30,0,-5]) color("gray") cube([60,50,30]);
		}
		translate([0,26,0]) { // at nozzle
			difference() {
				union() {
					CircularDuctOuter();
					CircularDuctInner();
				}
				translate([-30,-50,-5]) color("gray") cube([60,50,30]);
				translate([-12,8,-2]) color("black") cube([24,20,10]);
			}
		}
		translate([15,-1.5,0]) { // extension
			difference() {
				color("red") cube([12.5,29,10]);
				translate([1.5,-2,1]) color("pink") cube([10,30,8]);
			}
		}
		translate([-27.5,-1.5,0]) { // extension
			difference() {
				color("blue") cube([12.5,29,10]);
				translate([1,-2,1]) color("pink") cube([10,30,8]);
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Blower5015Output() { // the output conector for the blower
	difference() {
		translate([-1,0,0]) color("cyan") cuboid([BlowerLength+3,BlowerWidth+2,15],rounding=1,p1=[0,0]);
		translate([0.7,0.7,1]) color("red") cube([BlowerLength,BlowerWidth,15]);
		translate([-1.5,-6,1]) color("white") cube([25,10,8]);
	}
	difference() {
		translate([-2,0,0]) color("green") cuboid([27,6.5,11],rounding=1,p1=[0,0]);
		translate([0,-6,8]) color("khaki") cube([BlowerLength+1,BlowerWidth,4]);
		translate([-1.5,-6,1]) color("white") cube([25,10,8]);
		translate([0,-6,1]) color("blue") cube([BlowerLength+1,BlowerWidth,8]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CircularFanBase(Height=55,ScrewHZ=0,ShiftLR,Angle=0) {
	difference() {
		rotate([Angle,0,0])  difference() {
			union() {
				color("plum") translate([-3,-16,10]) cuboid([60,Height,5],rounding=2,p1=[0,0]);
				translate([ShiftLR-BlowerScrewUpperOffset+4,-15.15,10]) color("red") cuboid([11,64,5],rounding=2,p1=[0,0]);
			}
			translate([ShiftLR-BlowerScrewUpperOffset+6,0.5,9]) FanMount5015Holes(-4,Yes4mmInsert(Use4mmInsert));
		}
		translate([0,0,12]) rotate([90,0,0]) BracketMount(-ScrewHZ);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CircularDuctOuter() {
	difference() {
		difference() {
			color("cyan") cylinder(h=10,d=55);
			translate([0,0,-3]) color("blue") cylinder(h=15,d=30); // inner
			translate([-10,5,-3]) color("plum") cube([20,30,15]);
	/**/		translate([-14,-41,-5]) color("black") cube([25,20,20]);
		}
		translate([-17.5,0,11.5]) rotate([0,45,0]) color("black") cube([15,30,10]); //bevel
		translate([0,0,8]) rotate([0,45,0]) color("white") cube([10,30,15]); //bevel
		translate([0,0,1]) difference() {
			color("cyan") cylinder(h=8,d=53);
			translate([0,0,-3]) color("blue") cylinder(h=15,d=33); // inner
			translate([-7.5,5,-3]) color("plum") cube([15,30,15]);
		}
	}
	difference() { // left nozzle
		difference() {
			translate([10,0,3]) rotate([0,-45,0]) color("gray") cube([10,30,1]); // bevel
			translate([0,0,-3]) color("blue") cylinder(h=15,d=30); // inner
			translate([-20,-2,10]) cube([40,45,5]);
		}
		difference() {
			translate([0,0,-2]) color("black") cylinder(h=20,d=70);
			translate([0,0,-3]) color("white") cylinder(h=25,d=55);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CircularDuctInner() {
	difference() {
		difference() {
			translate([-17,0,10]) rotate([0,45,0]) color("red") cube([10,30,1]); // right nozzle
			translate([0,0,-3]) color("blue") cylinder(h=15,d=30); // inner cut
			translate([-20,-2,10]) color("pink") cube([40,45,5]);
		}
		difference() {
			translate([0,0,-2]) color("black") cylinder(h=20,d=70);
			translate([0,0,-3]) color("white") cylinder(h=25,d=55);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BracketMount(Move=0) {
	translate([0,0,Move+25]) {
		color("red") hull() {
			translate([3,10,-3]) rotate([90,0,0]) cylinder(h = 18,d = screw3);
			translate([3,10,2]) rotate([90,0,0]) cylinder(h = 18,d = screw3);
		}
		color("blue") hull() {
			translate([3,18,-3]) rotate([90,0,0]) cylinder(h = 18,d = screw3hd);
			translate([3,18,2]) rotate([90,0,0]) cylinder(h = 18,d = screw3hd);
		}
		color("blue") hull() {
			translate([3+PCfan_spacing,10,-3]) rotate([90,0,0]) cylinder(h = 18,d = screw3);
			translate([3+PCfan_spacing,10,+2]) rotate([90,0,0]) cylinder(h = 18,d = screw3);
		}
		color("red") hull() {
			translate([3+PCfan_spacing,18,-3]) rotate([90,0,0]) cylinder(h = 18,d = screw3hd);
			translate([3+PCfan_spacing,18,2]) rotate([90,0,0]) cylinder(h = 18,d = screw3hd);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//BlowerScrewUpper=45;
//BlowerScrewUpperOffset=3.5;

module FanMount5015Holes(ScrewZ=0,Screw=screw4) {
	translate([0,ScrewZ,0]) {
		//color("blue") translate([BlowerScrewUpperOffset,0,0]) cylinder(h=10,d=Screw);
		translate([BlowerScrewUpperOffset,BlowerScrewUpper,0]) color("white") cylinder(h=10,d=Screw); // top holes
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
