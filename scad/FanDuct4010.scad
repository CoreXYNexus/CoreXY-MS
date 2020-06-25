/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FanDuct4010.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created 8/10/2019
// last upate 6/19/20
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/10/19	- Created fan duct of my own design
// 8/12/19	- Added ability to set length
// 8/27/19	- Created v3 with a taper next to the fan to clear the mount better
// 6/18/20	- Vreated a blower nozzle for 4010 blower, began circular version
// 6/19/20	- Added mockup of 4010 from https://www.thingiverse.com/thing:2943994
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
use </inc/cubex.scad>
include <inc/screwsizes.scad>
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
//clearance=0.10;
//WallThickness=1;
Fan4010Offset=34.8;
Thickness = 6.5;
MHeight = 6;
MWidth = 60;
FHeight = 10;
MountingHoleHeight = 60; 	// screw holes may need adjusting when changing the front to back size
ExtruderOffset = 18;		// adjusts extruder mounting holes from front edge
FanSpacing = 32;			// hole spacing for a 40mm fan
PCfan_spacing = 47;//FanSpacing+15;
DuctLength=65; // set length of fan duct
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//FanDuct_v2(65);
//FanDuct_v3(65);
//FanDuct4010();
rotate([5,0,0]) CircularDuct(); // roate need to place duct flat on the bed

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct4010() {
	difference() {
		FanBase();
		translate([0,0,12]) rotate([90,0,0]) BracketMount_v2();
	}
	difference() {
		translate([3.5,-13,0]) color("cyan") cube([27.9,15,8.7]);
		FanDuctOne();
		FanDuctTwoI();
		translate([0,0,12]) rotate([90,0,0]) BracketMount_v2();
	}
	difference() {
		FanDuctTwoO();
		FanDuctTwoI();
		translate([0,5,27]) rotate([90,0,0]) FanDuctTwoU();
		translate([0,0,12]) rotate([90,0,0]) BracketMount_v2();
	}
	translate([-1.4,5,23]) rotate([90,0,0])  Nozzle();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanBase(Height=55,ScrewZ=0) {
	difference() {
		translate([-5,-15,10]) color("purple")cubeX([45,Height,5],2);
		translate([0,0,10]) FanMountHoles(ScrewZ);
	}
	difference() {
		translate([36,-15,10]) color("lightgray") cubeX([19,Height,5],2);
		translate([0,0,12]) rotate([90,0,0]) BracketMount_v2();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CircularFanBase(Height=55,ScrewZ=0) {
	difference() {
		translate([-5,-15,10]) color("purple") cubeX([45,Height,5],2);
		translate([0.7,0.85,9]) FanMountHoles(ScrewZ);
		translate([0,0,12]) rotate([90,0,0]) BracketMount_v3(-6);
	}
	difference() {
		translate([36,-15,10]) color("lightgray") cubeX([20,Height,5],2);
		translate([0,0,12]) rotate([90,0,0]) BracketMount_v3(-6);
		translate([0.7,0.85,9]) FanMountHoles(ScrewZ);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BracketMount_v2(Move=0) {
	translate([3,10,FHeight/4+Move]) rotate([90,0,0]) color("red") cylinder(h = 18,d = screw3);
	translate([3,1,FHeight/4+Move]) rotate([90,0,0]) color("gray") cylinder(h = 18,d = screw3hd);
	translate([3+PCfan_spacing,10,FHeight/4+Move]) rotate([90,0,0]) color("blue") cylinder(h = 18,d = screw3);
	translate([3+PCfan_spacing,1,FHeight/4+Move]) rotate([90,0,0]) color("plum") cylinder(h = 18,r = screw3hd/2);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BracketMount_v3(Move=0) {
	translate([3,10,FHeight/4+Move]) rotate([90,0,0]) color("red") cylinder(h = 18,d = screw3);
	translate([3,18,FHeight/4+Move]) rotate([90,0,0]) color("gray") cylinder(h = 18,d = screw3hd);
	translate([3+PCfan_spacing,10,FHeight/4+Move]) rotate([90,0,0]) color("blue") cylinder(h = 18,d = screw3);
	translate([3+PCfan_spacing,18,FHeight/4+Move]) rotate([90,0,0]) color("plum") cylinder(h = 18,d = screw3hd);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuctOne() {
	translate([4,-14.5,0.5]) color("red") cubeX([27-1,20,8-1],2);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module FanDuctTwoO() {
	difference() {
		color("plum") hull() {
			translate([2.5,-15,0]) cubeX([30,10,9],1);
			translate([10,-15,18]) cubeX([14,5,1],1);
		}
		FanDuctOne();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuctTwoI() {
	FanDuctOne();
	translate([0,0.5,-0.5]) color("yellow") hull() {
		translate([4,-15,1]) cubeX([27,9,7],2);
		translate([11,-15,17]) cubeX([13,4,1],2);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuctTwoU() {
	translate([10.5,-8,15.5]) color("lightgray") cubeX([13,1,4],2);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Nozzle() {
	difference() {
		color("gray") hull() {
			translate([11.5,-6,15]) cubeX([14,1,5],2);
			translate([14,30,15]) cubeX([5,1,5],2);
		}
		color("lightgray") hull() {
			translate([12,-8,15.5]) cubeX([13,1,4],2);
			translate([15,37,16.5]) cubeX([2,1,2],1);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanMountHoles(ScrewZ=0,Screw=screw2) {
	translate([0,0,ScrewZ]) {
		color("red") cylinder(h=10,d=Screw);
		translate([Fan4010Offset,0,0]) color("blue") cylinder(h=10,d=Screw);
		translate([Fan4010Offset,Fan4010Offset,0]) color("white") cylinder(h=10,d=Screw);
		translate([0,Fan4010Offset,0]) color("black") cylinder(h=10,d=Screw);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_v2(Length=50) {
	difference() {
		color("cyan") hull() {
			FanDuct_Base();
			FanDuct_Outlet(Length);
		}
		FanDuct_Interior(Length);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_v3(Length=50) {
	difference() {
		union() {
			FanDuct_Base_v3();
			FanDuct_Outlet_v3(Length);
		}
		FanDuct_Interior_v3(Length);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_Base_v3() {
	color("plum") hull() {
		cube([15.2+(WallThickness+clearance)*2,20+(WallThickness+clearance)*2,3]);
		translate([0,0,5]) cube([15.2+(WallThickness+clearance)*2,10+(WallThickness+clearance)*2,3]);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_Outlet_v3(Length) {
	color("cyan") hull() {
		translate([5,5,Length-5]) rotate([60,0,0]) cubeX([5.2+(WallThickness+clearance)*2,5+(WallThickness+clearance)*2,3,2]);
		translate([0,0,5]) cube([15.2+(WallThickness+clearance)*2,10+(WallThickness+clearance)*2,3]);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_Base() {
	cube([15.2+(WallThickness+clearance)*2,20+(WallThickness+clearance)*2,3]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_Outlet(Length) {
	translate([5,5,Length-5]) rotate([30,0,0]) cubeX([5.2+(WallThickness+clearance)*2,3+(WallThickness+clearance)*2,3,2]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_Interior(Length) {
	//echo(parent_module(0));
	color("blue") hull() {
		translate([WallThickness+5,WallThickness+6.2,Length-4]) rotate([30,0,0]) color("blue")
			cube([5.2+(clearance)*2,2+(clearance)*2,5]);
		translate([WallThickness,WallThickness,-2]) color("blue") cube([15.2+(clearance)*2,20+(clearance)*2,5]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct_Interior_v3(Length) {
	color("blue") hull() {
		translate([WallThickness+5,WallThickness+3.4,Length]) rotate([60,0,0]) color("blue")
			cube([5.2+(clearance)*2,4+(clearance)*2,1]);
		translate([WallThickness,WallThickness,-2]) color("blue") cube([15.2+(clearance)*2,10+(clearance)*2,5]);
	}
	translate([0,0,-1]) color("red") hull() {
		translate([WallThickness+0.8,WallThickness+6,9]) rotate([-30,0,0])
			cube([14-(clearance),14.5+(clearance)*2,1]);
		translate([WallThickness,WallThickness+10,-2]) cube([15+(clearance)*4,10+(clearance)*2,5]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CircularDuct() {
	%translate([0,-15,7]) cube([5,35,5]);
	difference() {
		translate([-18,-5,16.5]) rotate([90,0,0]) CircularFanBase(25,0);
		translate([-17,-30,1]) cube([34,15,8]);
	}
	translate([-14,-0.75,0]) rotate([-5,0,0]) difference() {
		translate([0,-21,0]) color("cyan") rotate([90,0,0]) cube([27,15,8]);
		translate([-8,-20.8,10]) rotate([5,0,0]) color("black") cube([40,1,10]);
		translate([-3.5,-21,15]) rotate([90,0,0]) FanDuctOne();
		translate([1.5,-25,1]) color("white") cube([25,15,8]);
	}
	rotate([-5,0,0]) {
		CircularDuctOuter();
		CircularDuctInner();
	}
	translate([-14,-24.5,2.1]) color("blue") rotate([-5,0,0]) cube([27,5,0.5]);
	translate([-14,-21,11]) color("khaki") cube([28,2,1]);
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
		translate([-17.5,0,11.5]) rotate([0,45,0]) color("lightgray") cube([15,30,10]); //bevel
		translate([0,0,8]) rotate([0,45,0]) color("lightblue") cube([10,30,15]); //bevel
		translate([0,0,1]) difference() {
			color("cyan") cylinder(h=8,d=53);
			translate([0,0,-3]) color("blue") cylinder(h=15,d=33); // inner
			translate([-7.5,5,-3]) color("plum") cube([15,30,15]);
		}
	}
	difference() {
		difference() {
			translate([11,0,4]) rotate([-3,-45,5]) color("gray") cube([10,30,1]); // bevel
			translate([0,0,-3]) color("blue") cylinder(h=15,d=30); // inner
			translate([-20,-2,10]) cube([40,45,5]);
		}
		difference() {
			translate([0,0,-2]) color("black") cylinder(h=20,d=70);
			translate([0,0,-3]) color("white") cylinder(h=25,d=55);
		}
	}
	translate([0,-23,33]) rotate([95,0,0]) Show4040();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CircularDuctInner() {
	difference() {
		difference() {
			translate([-18,0,11]) rotate([-3,45,-5]) color("red") cube([10,30,1]); // bevel
			translate([0,0,-3]) color("blue") cylinder(h=15,d=30); // inner
			translate([-20,-2,10]) cube([40,45,5]);
		}
		difference() {
			translate([0,0,-2]) color("black") cylinder(h=20,d=70);
			translate([0,0,-3]) color("white") cylinder(h=25,d=55);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Show4040() {
	%import("4010_Blower_Fan_v2.stl");
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
