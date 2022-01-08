////////////////////////////////////////////////////////////////////////////
// AngleSideSsupport.scad - to use 2020 as angle support on frame
////////////////////////////////////////////////////////////////////////////
// Created: 7/20/2016
// Last Update: 1/4/22
////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 7/20/16	- adjusted positions for cubeX and added ms_notch for using against
//			  makerslide
// 7/28/16	- changed bottom access hole and slotted the hole for the 2020 end
// 7/9/18	- Added corner-tools.scad to round over the large screw access holes
//			  added missing mounting hole, added a 200x200 bed under all() in preview
// 8/19/18	- OpenSCAD 2018.06.01 for $preview
// 10/31/20	- Removed notches for makerslide, you don't need to mount to the y axis
// 1/4/22	- converted to BOSL2 and renamed modules, removed unecessary code
////////////////////////////////////////////////////////////////////////////
// It takes a while to render all
////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <BOSL2/std.scad>
$fn=100;
///////////////////////////////////////////////////////////////////////////
width = 20;
length = 80;
length2 = 54;
////////////////////////////////////////////////////////////////////////////

All();

//////////////////////////////////////////////////////////////////////////////

module All() {
	//if($preview) %translate([-20,0,-15]) cube([200,200,2],center=true);
	rotate([90,0,0]) {
		BraceEnd2020();
		translate([-40,0,10]) BraceEnd2020();
	}
	rotate([-90,0,0]) {
		translate([0,0,6]) BraceEnd2020();	
		translate([-40,0,16]) BraceEnd2020();
	}
}

////////////////////////////////////////////////////////////////////////////

module BraceEnd2020() // currently at 45 degrees, using 350mm 2020
{
	difference() {
		color("cyan") cuboid([length,width,4],rounding=2);	// horizontal
		color("red") hull() {	// elongated mounting hole, includes access to tighten 2020 end
			translate([28.5,0,-8]) cylinder(h=20,d=screw5);
			translate([30,0,-7.5]) rotate([0,-45,0]) cylinder(h=20,d=screw5);
		}
		translate([-length/3,0,0]) color("blue") cyl(h=20,d=screw5); // bottom mounting hole
	}
	translate([20.5,0,18]) rotate([0,45,0]) OutsideHoles();
	translate([10,0,-7]) rotate([0,-45,0]) InsideHoles();
	InnerSupport();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module InsideHoles() {
	difference() {
		translate([13.5,0,8]) color("pink") cuboid([26.5,width,4],rounding=2);
		translate([15,0,8]) color("blue") cyl(h=10,d=screw5);	// extrusion end hole
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module OutsideHoles() {
	difference() {
		cuboid([length2,width,4],rounding=2);	// long vertical
		translate([-18,0,0]) color("red") cyl(h=10,d=screw5);	// mounting hole
		translate([15,0,0]) color("blue") cyl(h=4.1,d=screw5hd+1,rounding=-1); // top access hole
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module InnerSupport() {
	translate([22,8,8]) cuboid([4,4,20],rounding=2);
	translate([22,-8,8]) cuboid([4,4,20],rounding=2); // supports inside triangle
}

/////////////// end of corexy-sidesupport.scad ////////////////////////////////////
