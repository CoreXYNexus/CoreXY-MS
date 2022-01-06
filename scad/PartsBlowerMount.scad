////////////////////////////////////////////////////////////////////////////
// Parts-Blower.scad - adapter for blower fan to an AL plate
//////////////////////////////////////////////////////////////////////////
// created 5/21/2016
// last update 1/4/22
//////////////////////////////////////////////////////////////////////////
// 6/29/16	- Made fan mount a bit thicker
// 7/19/16	- Added adapter3() for corexy x-carriage extruder plate
// 8/26/16	- Uses fanduct.scad see http://www.thingiverse.com/thing:387301
//			  Have it in the same folder as this file
// 9/30/16	- Added adapter for the titan extruder setup, some vars and modules are from
//			  corexy-x-carriage.scad
// 7/13/18	- Added color to preview
// 8/20/18	- Removed unused code
// 2/13/19	- Changed to current extruder with titan
// 2/14/19	- Removed and renamed variables used.
// 3/1/19	- Fixed Long_Motor_version() for the spacer
// 8/7/19	- Widened the pc blower fan adapter mounting holes, added versions for both e3dv6 positions
// 8/17/19	- changed to fanduct_v2.scad
// 1/4/22	- BOSL2
//////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <bosl2/std.scad>
use <fanduct_v3.scad>
$fn=100;
//////////////////////////////////////////////////////////////////////////
// vars
//////////////////////////////////////////////////////////////////////////
Thickness = 6.5;
MHeight = 6;
MWidth = 60;
FHeight = 10;
MountingHoleHeight = 60; 	// screw holes may need adjusting when changing the front to back size
ExtruderOffset = 18;		// adjusts extruder mounting holes from front edge
FanSpacing = 32;			// hole spacing for a 40mm fan
PCfan_spacing = 47;//FanSpacing+15;
DuctLength=65; // set length of 50150 fan duct
//////////////////////////////////////////////////////////////////////////
// 1st arg: fan duct;	
// 2nd arg is side offset
// 3rd arg: move up/down M4 blower mounting hole
// 4th arg: move front/rear M4 blower mounting hole
// 5th arg: move closer/farther from mount
//Long_Motor_version(0,6,25,6,-13);	// e3dv6
//Long_Motor_version_v2(0,-2,25,6,-5); // e3dv6 at left
Long_Motor_version_v2(0,-2,25,6,-13); // e3dv6 at right
//Short_Motor_version(1,6,25,6); 	// e3dv6 at left front
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Short_Motor_version(Duct=0,Move=0,Raise=0,Back=0,Offset=0) {
	difference() {
		color("cyan") cuboid([FanSpacing+Move/2+4,MHeight,Thickness],rounding=1,p1=[0,0]);
		BracketMount();
	}
	difference() {
		FanBlowerMount(Move,Raise,Back);
		BracketMount();
	}
	if(Duct) translate([0,12,0]) color("red") FanDuct_v3(DuctLength);
}

///////////////////////////////////////////////////////////////////////////

module Long_Motor_version(Duct=0,Move=0,Raise=0,Back=0,Offset=0) { // stepper side
	difference() {
		color("cyan") cuboid([FanSpacing+Move/2+7,MHeight,Thickness],rounding=1,p1=[0,0]);
		translate([0,0,0.5]) BracketMount_v2();
	}
	difference() {
		translate([Move+6,-13.5,0]) color("lightgray") cuboid([21,-Offset+4,Thickness],rounding=2,p1=[0,0]);
		translate([0,0,0.5]) BracketMount_v2();
	}
	difference() {
		translate([0,Offset+10,0]) FanBlowerMount(Move,Raise,6,0,0,4,1,Offset);
		translate([0,0,0.5]) BracketMount_v2();
	}
	if(Duct) translate([0,15,0]) color("red") FanDuct_v3(DuctLength);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module Long_Motor_version_v2(Duct=0,Move=0,Raise=0,Back=0,Offset=0) { // stepper side
	difference() {
		color("cyan") cuboid([PCfan_spacing+7,MHeight,Thickness],rounding=1,p1=[0,0]);
		translate([0,0,0.5]) BracketMount_v2();
	}
	difference() {
		translate([Move+6,Offset-1,0]) color("lightgray") cuboid([21,Offset*-1+5,Thickness],rounding=1,p1=[0,0]); // spacer
		translate([0,0,0.5]) BracketMount_v2();
		translate([Move+2,-30+Back+Offset,10]) rotate([-45,0,0]) color("pink") cube([30,30,10]);
	}
	difference() {
		translate([0,Offset+10,0]) FanBlowerMount(Move,Raise,6,0,0,4,1,Offset);
		translate([0,0,0.5]) BracketMount_v2();
	}
	if(Duct) translate([0,15,0]) color("red") FanDuct_v3(DuctLength);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module FanBlowerMount(Move=0,Raise=0,Back=0,X=0,Y=0,Z=0,Spacer=0,Offset=0) {
	if(Spacer) {
		difference() {
			translate([Move+6,-30+Back,0]) color("gray") cuboid([21,21-Back,Raise+Z+5],rounding=1,p1=[0,0]);
			RemoveForBlower(Move+6,Raise,Spacer);
			translate([Move+X,-14-Back+Y,Raise+Z]) rotate([0,90,0]) color("purple") cylinder(h=42,r=screw4/2,$fn=50);
			translate([Move+2,-40+Back,10]) rotate([-45,0,0]) color("black") cube([30,30,10]);
		}
		//difference() {
		//	translate([Move+6,Offset+2,0]) color("lightgray") cuboid([21,Offset,Thickness],rounding=1,p1=[0,0]);
		//	translate([0,0,0.5]) BracketMount(Move);
		//	translate([5,-5-Offset,0]) color("plum") cube([30,20,20]);
		//}
	} else {
		difference() {
			translate([Move,-16+Back,0]) color("gray") cuboid([21,21-Back,Raise+4],rounding=1,p1=[0,0]);
			RemoveForBlower(Move,Raise);
			translate([Move+X,-Back+Y,Raise+Z]) rotate([0,90,0]) color("purple") cylinder(h=42,r=screw4/2,$fn=50);
			translate([Move-5,-29+Back,9]) rotate([-45,0,0]) color("black") cube([30,30,10]);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BracketMount() {
	translate([3,10,FHeight/4+0.5]) rotate([90,0,0]) color("red") cylinder(h = 18,r = screw3/2,$fn=50);
	translate([3,1,FHeight/4+0.5]) rotate([90,0,0]) color("gray") cylinder(h = 18,r = screw3hd/2,$fn=50);
	translate([3+FanSpacing,10,FHeight/4+0.5]) rotate([90,0,0]) color("blue") cylinder(h = 18,r = screw3/2,$fn=50);
	translate([3+FanSpacing,1,FHeight/4+0.5]) rotate([90,0,0]) color("plum") cylinder(h = 18,r = screw3hd/2,$fn=50);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BracketMount_v2(Move=0) {
	translate([3,10,FHeight/4+0.3]) rotate([90,0,0]) color("red") cylinder(h = 18,r = screw3/2,$fn=50);
	translate([3,1,FHeight/4+0.3]) rotate([90,0,0]) color("gray") cylinder(h = 18,r = screw3hd/2,$fn=50);
	translate([3+PCfan_spacing,10,FHeight/4+0.3]) rotate([90,0,0]) color("blue") cylinder(h = 18,r = screw3/2,$fn=50);
	translate([3+PCfan_spacing,1,FHeight/4+0.3]) rotate([90,0,0]) color("plum") cylinder(h = 18,r = screw3hd/2,$fn=50);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RemoveForBlower(Move=0,Raise=0,Spacer=0) {
	if(Spacer) {
		translate([Move+3,-57,-10]) color("yellow") cuboid([15,45,Raise*2],rounding=1,p1=[0,0]);
		//translate([Move+3,-15.5,-17]) rotate([35,0,0]) color("lightgreen") cuboid([15,15,15],rounding=1,p1=[0,0]);
	} else {
		translate([Move+3,-45,-10]) color("yellow") cuboid([15,45,Raise*2],rounding=1,p1=[0,0]);
	}
}


//////////////////////////////end of parts-blower.scad///////////////////////////////////////////////////////////////////////