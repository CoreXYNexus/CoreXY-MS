/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FanDuct4010.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created 8/10/2019
// last upate 8/7/20
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/10/19	- Created fan duct of my own design
// 8/12/19	- Added ability to set length
// 8/27/19	- Created v3 with a taper next to the fan to clear the mount better
// 6/18/20	- Vreated a blower nozzle for 4010 blower, began circular version
// 6/19/20	- Added mockup of 4010 from https://www.thingiverse.com/thing:2943994
// 7/4/20	- Made circular fan duct long enought for an titan aero
// 8/1/20	- Made angle adjustable on CircularDuct() and cleaned up unused code
// 8/7/20	- Removed more partial blockages inside and adjust the inside of the duct extensions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
use </inc/cubex.scad>
include <inc/screwsizes.scad>
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Fan4010Offset=34.8;
Thickness = 6.5;
MHeight = 6;
MWidth = 60;
FHeight = 10;
MountingHoleHeight = 60; 	// screw holes may need adjusting when changing the front to back size
ExtruderOffset = 18;		// adjusts extruder mounting holes from front edge
FanSpacing = 32;			// hole spacing for a 40mm fan
PCfan_spacing = 47;			// mount spacing to extruder platform
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

CircularDuct(3.5,0,-0.3,5,0); 	// 1st arg: shift left-righ
								// 2nd arg: angle the duct
								// 3rd arg: Shift the whole bracket up/down (needed when the angle changes)
								// 4th arg: move mounting holes up/down
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CircularDuct(ShiftLR=0,Angle=0,ShiftBracketUD=0,ScrewHZ=0,Show=0) {
	if(Show) translate([5.5,-21,30]) rotate([90,0,0]) Show4040();
	difference() {  // mounting bracket
		translate([-14+ShiftLR,-5,16.5+ShiftBracketUD]) rotate([90,0,0]) CircularFanBase(25,ScrewHZ,ShiftLR,Angle);
		translate([-17,-28,1]) color("red") cube([35,15,8]);
		translate([17,-21,1]) rotate([0,0,48]) color("brown") cube([10,10,8]);
		translate([-17,-21,1]) rotate([0,0,48]) color("black") cube([10,10,8]);
	}
	translate([-8,-0.75,0]) Blower4010Output();
	difference() {
		union() {
			MainDuct();
			translate([-14,-24,0]) color("green") cube([6,2,10]); // ****** will need adjusting if duct angle is changed
			translate([13,-23,0]) color("blue") cube([6,4,10]);
			translate([10,-22,0]) color("red") rotate([0,0,0]) cube([9,3,1]); // top filler
		}
		translate([12,-25,1]) color("black") cube([6,6,9]);
		translate([12,-28,5]) color("gray") cube([6,6,8]);
	}
			translate([10,-22,9]) color("white") rotate([0,0,0]) cube([9,3,1]); // top filler
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
		translate([0,23,0]) { // at nozzle
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
				color("red") cube([12.5,26,10]);
				translate([1.5,-2,1]) color("pink") cube([10,30,8]);
			}
		}
		translate([-27.5,-1.5,0]) { // extension
			difference() {
				color("blue") cube([12.5,26,10]);
				translate([1,-2,1]) color("pink") cube([10,30,8]);
			}
		}
		translate([-14,-24.5,0]) color("blue") rotate([0,0,0]) cube([27,5,1]); // bottom filler
		translate([-14,-22,9]) color("khaki") rotate([0,0,0]) cube([27,3,1]); // top filler
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Blower4010Output() { // the output conector for the blower
	difference() {
		translate([0,-21,0]) color("cyan") rotate([90,0,0]) cube([27,15,8]);
		translate([0.5,-28.5,1]) color("red") cubeX([26,7,20],2);
		translate([1.5,-25,1]) color("white") cube([25,15,8]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CircularFanBase(Height=55,ScrewHZ=0,ShiftLR,Angle=0) {
	difference() {
		rotate([Angle,0,0])  difference() {
			union() {
				translate([-5,-16.15,10]) color("purple") cubeX([61,Height,5],2);
				translate([33-ShiftLR,-16.15,10]) color("red") cubeX([7,53,5],2);
			}
			translate([2-ShiftLR,0.5,9]) FanMountHoles(-4,screw2t);
			translate([2-ShiftLR,0.5,9]) FanMountHoles(-4,screw2t);
		}
		translate([-2,0,12]) rotate([90,0,0]) BracketMount(ScrewHZ-7);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CircularDuctOuter() {
	difference() {
		difference() {
			color("cyan") cylinder(h=10,d=55);
			translate([0,0,-3]) color("blue") cylinder(h=15,d=30); // inner
			translate([-10,5,-3]) color("plum") cube([20,30,15]);
			translate([-14,-40,-5]) color("black") cube([27,20,20]);
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
	hull() {
		translate([3,10,FHeight/4+Move-3]) rotate([90,0,0]) color("red") cylinder(h = 18,d = screw3);
		translate([3,10,FHeight/4+Move+2]) rotate([90,0,0]) color("red") cylinder(h = 18,d = screw3);
	}
	hull() {
		translate([3,18,FHeight/4+Move-3]) rotate([90,0,0]) color("gray") cylinder(h = 18,d = screw3hd);
		translate([3,18,FHeight/4+Move+2]) rotate([90,0,0]) color("gray") cylinder(h = 18,d = screw3hd);
	}
	hull() {
		translate([3+PCfan_spacing,10,FHeight/4+Move-3]) rotate([90,0,0]) color("blue") cylinder(h = 18,d = screw3);
		translate([3+PCfan_spacing,10,FHeight/4+Move+2]) rotate([90,0,0]) color("blue") cylinder(h = 18,d = screw3);
	}
	hull() {
		translate([3+PCfan_spacing,18,FHeight/4+Move-3]) rotate([90,0,0]) color("plum") cylinder(h = 18,d = screw3hd);
		translate([3+PCfan_spacing,18,FHeight/4+Move+2]) rotate([90,0,0]) color("plum") cylinder(h = 18,d = screw3hd);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanMountHoles(ScrewZ=0,Screw=screw2) {
	translate([0,ScrewZ,0]) {
		//color("red") cylinder(h=10,d=Screw); // bottom holes
		color("blue") translate([Fan4010Offset,0,0]) cylinder(h=10,d=Screw);
		translate([Fan4010Offset,Fan4010Offset,0]) color("white") cylinder(h=10,d=Screw); // top holes
		translate([0,Fan4010Offset,0]) color("black") cylinder(h=10,d=Screw);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Show4040() {
	%import("4010_Blower_Fan_v2.stl");
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
