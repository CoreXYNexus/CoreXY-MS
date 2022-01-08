/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FanDuct4010.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created 8/10/2019
// last upate 10/3/20
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
// 10/1/20	- Added a tab to the CircularFanBase() to help prevent the braket end from lifting
// 10/3/20	- Added an horiszontla 4040 the mount underneath the extruder
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
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
LayerHeight=0.3;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//CircularDuct(1,0,-0.3,50,0); // Titan with an E3Dv6, with the extruder mount set up for a Titan Aero
	// ShiftLR=0,Angle=0,ShiftBracketUD=0,ScrewHZ=0,Show=0
CircularDuct(0,0,-0.3,25,0); // titan aero
//HorizontalFanDuct();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HorizontalFanDuct() {
	translate([0,10,4.5]) Blower4010Output2();
	translate([0,33,4.5]) Blower();
	translate([-8,0,0]) HorizontalFanDuctBase();	
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Blower() {
	difference() {
		color("lightgray") hull() {
			translate([0,-9,0]) cuboid([27,1,8],rounding=1,p1=[0,0]);
			translate([7,5,0]) cuboid([14,1,8],rounding=1,p1=[0,0]);
		}
		color("white") hull() {
			translate([1,-11,1]) cuboid([25,1,6],rounding=1,p1=[0,0]);
			translate([7,4,1]) cuboid([12,1,6],rounding=1,p1=[0,0]);
		}
		translate([8.5,0,3]) color("plum") cuboid([10,10,4],rounding=1,p1=[0,0]);
		//translate([0.5,-28.5,1]) color("red") cuboid([26,7,20],rounding=2,p1=[0,0]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Blower4010Output2() { // the output conector for the blower with no outlet
	difference() {
		translate([0,0,0]) color("cyan") cuboid([27,15,8],rounding=1,p1=[0,0]);
		translate([0.7,-2,1.2]) color("red") cuboid([25,20,6],rounding=2,p1=[0,0]);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HorizontalFanDuctBase(ScrewZ=0,Screw=screw2) {
	difference() {
		color("blue") hull() {
			cubeX([45,10,4]);
			translate([15,38,0]) cuboid([14,1,4],rounding=1,p1=[0,0]);
		}
		translate([5,-23,-2]) FanMountHoles(ScrewZ,Screw);
		translate([23,5,-2]) color("red") cylinder(h=10,d=screw5);
	}
	translate([15,15,1.5]) color("red") cube([14,23,4]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CircularDuct(ShiftLR=0,Angle=0,ShiftBracketUD=0,ScrewHZ=0,Show=0) {
	if(Show) translate([5.5,-21,30]) rotate([90,0,0]) Show4040();
	difference() {  // mounting bracket
		union() {
			translate([-14+ShiftLR,-5,16.5+ShiftBracketUD]) rotate([90,0,0]) CircularFanBase(ScrewHZ,ScrewHZ,ShiftLR,Angle);
			translate([42,-17.5,0]) color("black") cylinder(h=LayerHeight,d=15);  // CircularFanBase support tab
		}
		translate([-17,-28,1]) color("red") cube([35,15,8]);
		translate([17,-21,1]) rotate([0,0,48]) color("brown") cube([10,10,8]);
		translate([-17,-21,1]) rotate([0,0,48]) color("black") cube([10,10,8]);
	}
	translate([-8,-0.75,0]) Blower4010Output();
	MainDuct();
	translate([16,-23,0]) color("green") cuboid([3,2,10],rounding=0.5,p1=[0,0]); // ****** will need adjusting if duct angle is changed
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
				translate([-13.5,7,-1]) color("black") cube([26,20,10]); // nozzle seperation
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

module Blower4010Output() { // the output conector for the blower
	difference() {
		translate([0,-21,0]) color("cyan") rotate([90,0,0]) cuboid([27,15,8],rounding=1,p1=[0,0]);
		translate([1,-28,1]) color("red") cuboid([25,6,20],rounding=2,p1=[0,0]);
		translate([1.5,-25,1]) color("white") cube([25,15,8]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CircularFanBase(Height=0,ScrewHZ=0,ShiftLR=0,Angle=0) {
	echo("Height:",Height);
	echo("ScrewHZ:",ScrewHZ);
	difference() {
		rotate([Angle,0,0])  difference() {
			union() {
				translate([-5,-16.15,10]) color("purple") cuboid([61,Height,5],rounding=2,p1=[0,0]);
				translate([33-ShiftLR,-16.15,10]) color("red") cuboid([7,53,5],rounding=2,p1=[0,0]);
			}
			translate([2-ShiftLR,0.5,9]) FanMountHoles(-4,screw2t);
			translate([2-ShiftLR,0.5,9]) FanMountHoles(-4,screw2t);
		}
		translate([0,0,12]) rotate([90,0,0]) BracketMount(-ScrewHZ);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CircularFanBaseV2(Height=55,ScrewHZ=0,ShiftLR,Angle=0) {
	echo("Height:",Height);
	echo("ScrewHZ:",ScrewHZ);
	difference() {
		rotate([Angle,0,0])  difference() {
			union() {
				color("plum") hull() {
					translate([-3,-16,10]) /*color("cyan")*/ cubeX([40,Height,5],2);
					translate([52,9,10]) /*color("red")*/ cubeX([1,Height/2,5],2);
				}
				translate([33-ShiftLR,-16.15,10]) color("red") cubeX([7,53,5],2);
			}
			translate([2-ShiftLR,0.5,9]) FanMountHoles(-4,screw2t);
			translate([2-ShiftLR,0.5,9]) FanMountHoles(-4,screw2t);
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
			translate([-8,-42,-5]) color("black") cube([27,20,20]);
		}
		translate([-17.5,0,12]) rotate([0,55,0]) color("black") cube([15,30,10]); //bevel
		translate([0,0,7]) rotate([0,35,0]) color("white") cube([10,30,15]); //bevel
		translate([0,0,1]) difference() {
			color("cyan") cylinder(h=8,d=53);
			translate([0,0,-3]) color("blue") cylinder(h=15,d=33); // inner
			translate([-7.5,5,-3]) color("plum") cube([15,30,15]);
		}
	}
	difference() { // left nozzle
		difference() {
			translate([10,0,3]) rotate([0,-55,0]) color("green") cube([10,30,1]); // bevel
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
			translate([-17,0,11]) rotate([0,55,0]) color("red") cube([10,30,1]); // right nozzle
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

module FanMountHoles(ScrewZ=0,Screw=screw2) {
	translate([0,ScrewZ,0]) {
		color("red") cylinder(h=10,d=Screw); // bottom holes
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
