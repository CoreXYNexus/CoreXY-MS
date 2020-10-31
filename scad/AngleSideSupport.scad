////////////////////////////////////////////////////////////////////////////
// CoreXY-Side-Ssupport.scad - extracted from MakerSlideMendel.scad
////////////////////////////////////////////////////////////////////////////
// Created: 7/20/2016
////////////////////////////////////////////////////////////////////////////
// Last Update: 8/19/2018
////////////////////////////////////////////////////////////////////////////
// 7/20/16	- adjusted positions for cubeX and added ms_notch for using against
//			  makerslide
// 7/28/16	- changed bottom access hole and slotted the hole for the 2020 end
// 7/9/18	- Added corner-tools.scad to round over the large screw access holes
//			  added missing mounting hole, added a 200x200 bed under all() in preview
// 8/19/18	- OpenSCAD 2018.06.01 for $preview
// 10/31/20	- Removed notches for makerslide, you don't need to mount to the y axis
////////////////////////////////////////////////////////////////////////////
// It takes a while to render all
////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>
use <inc/corner-tools.scad>
$fn=50;
///////////////////////////////////////////////////////////////////////////
width = 20;
length = 80;
length2 = 54;
////////////////////////////////////////////////////////////////////////////

all();

//////////////////////////////////////////////////////////////////////////////

module all() {
	if($preview) %translate([-20,0,-15]) cube([200,200,2],center=true);
	translate([0,-10,0]) rotate([90,0,0]) // lay down for printing
		MS_corner(0);
	rotate([-90,0,0]) // lay down for printing
		MS_corner(0);	
	translate([-40,-20,0]) rotate([90,0,0]) // lay down for printing
		MS_corner(0);
	translate([-40,10,0]) rotate([-90,0,0]) // lay down for printing
		MS_corner(0);
}

////////////////////////////////////////////////////////////////////////////

module MS_corner(doTab) // currently at 45 degrees, using 350mm 2020
{
	difference() {
		color("cyan") cubeX([length,width,4],radius=2,center=true);	// horizontal
		color("red") hull() {	// elongated mounting hole
			translate([28.5,0,-8]) cylinder(h=20,r=screw5/2,$fn=100);
			translate([30,0,-7.5]) rotate([0,-45,0]) cylinder(h=20,r=screw5/2,$fn=100);
		}
		translate([-length/3,0,-7.5]) color("blue") cylinder(h=20,r=screw5/2,$fn=100); // bottom mounting hole
	}
	if(doTab) {		// 1 for tab, 0 no tab
		difference() {
			translate([30,-19.9,0]) cubeX([width,width,4],radius=2,center=true);	// horizontal side mount
			translate([30,-20,-5]) cylinder(h=10,r=screw5/2,$fn=100);		// hole
		}
	}
	translate([20.5,0,18]) rotate([0,45,0]) thetoppart();
	translate([10,0,-7]) rotate([0,-45,0]) theinsidepart();
	inner_support();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module theinsidepart() {
	difference() {
		translate([13.5,0,8]) color("pink") cubeX([26.5,width,4],radius=2,center=true);
		translate([15,0,4.5]) cylinder(h=10,r=screw5hd/2+0.5,$fn=100);	// extrusion end hole
		translate([15,0,6]) rotate([180,0,0]) color("cyan") fillet_r(2,screw5hd/2+0.5,-1,$fn);	// mounting hole
		translate([15,0,10]) color("cyan") fillet_r(2,screw5hd/2+0.5,-1,$fn);	// mounting hole
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module thetoppart() {
	difference() {
		cubeX([length2,width,4],radius=2,center=true);	// long vertical
		translate([-18,0,-5]) color("red") cylinder(h=10,r=screw5/2,$fn=100);	// mounting hole
		translate([15,0,-5]) color("blue") cylinder(h=10,r=screw5hd/2+0.5,$fn=100); // top access hole
		translate([15,0,-2]) rotate([180,0,0]) color("cyan") fillet_r(2,screw5hd/2+0.5,-1,$fn);	// mounting hole
		translate([15,0,2.1]) color("cyan") fillet_r(2,screw5hd/2+0.5,-1,$fn);	// mounting hole
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module inner_support() {
	translate([22,8,8]) cubeX([4,4,20],radius=2,center=true);
	translate([22,-8,8]) cubeX([4,4,20],radius=2,center=true); // supports inside triangle
}

/////////////// end of corexy-sidesupport.scad ////////////////////////////////////
