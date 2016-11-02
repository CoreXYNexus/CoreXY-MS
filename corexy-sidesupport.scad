////////////////////////////////////////////////////////////////////////////
// corexy-sidesupport.scad - extracted from MakerSlideMendel.scad
////////////////////////////////////////////////////////////////////////////
// Created: 7/20/2016
////////////////////////////////////////////////////////////////////////////
// Last Update: 7/28/2016
////////////////////////////////////////////////////////////////////////////
// 7/20/16 - adjusted positions for cubeX and added ms_notch for using against
//			 makerslide
// 7/28/16 - changed bottom access hole and slotted the hole for the 2020 end
////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>
$fn=50;
///////////////////////////////////////////////////////////////////////////
// variables
height = 20;
width = 20;
length = 80;
length2 = 54;
screw_dia = screw5;	// mounting screw diameter
screw_hd_dia = screw5hd;	// mounting screw head diameter
ex_thickness = 20;
ms_thickness = 20;
ms_width = 40;
MS_bg_size = 4;	// space needed for the bit that the wheels ride on
////////////////////////////////////////////////////////////////////////////

translate([0,-10,0]) rotate([90,0,0]) // lay down for printing
	MS_corner(1,0);	// 1 for tab, 0 no tab
rotate([-90,0,0]) // lay down for printing
	MS_corner(0,0);	// 1 for tab, 0 no tab
translate([-40,-20,0]) rotate([90,0,0]) // lay down for printing
	MS_corner(3,0);	// 1 for tab, 0 no tab
translate([-40,10,0]) rotate([-90,0,0]) // lay down for printing
	MS_corner(3,0);	// 1 for tab, 0 no tab

////////////////////////////////////////////////////////////////////////////
// support strut bottom
////////////////////////////////////////////////////////////////////////////
module MS_corner(Side,doTab) // currently at 45 degrees ** may need to adjust this
{	// 1 for tab, 0 no tab
	// makerslide support to base corner
	difference() {
		cubeX([length,width,4],radius=2,center=true);	// horizontal
		ms_notch(Side);
		hull() {
			translate([28.5,0,-8]) cylinder(h=20,r=screw_dia/2,$fn=100); // mounting hole
			translate([30,0,-7.5]) rotate([0,-45,0]) cylinder(h=20,r=screw_dia/2,$fn=100); // access hole
		}
		translate([-32,0,-5]) cylinder(h=10,r=screw_dia/2,$fn=100);		// mounting hole
	}
	if(doTab) {		// 1 for tab, 0 no tab
		difference() {
			translate([30,-19.9,0]) cubeX([width,width,4],radius=2,center=true);	// horizontal side mount
			translate([30,-20,-5]) cylinder(h=10,r=screw_dia/2,$fn=100);		// hole
		}
	}
	difference() {
		translate([20.5,0,18]) rotate([0,45,0]) cubeX([length2,width,4],radius=2,center=true);	// long vertical
		translate([5,0,25]) rotate([0,45,0]) cylinder(h=10,r=screw_dia/2,$fn=100);	// mounting hole
		ms_notch(Side);
		translate([26,0,7]) rotate([0,45,0]) cylinder(h=10,r=screw_hd_dia/2+0.5,$fn=100); // top access hole
	}
	difference() {
		translate([13.5,0,8]) rotate([0,-45,0]) cubeX([26.5,width,4],radius=2,center=true); // extrusion base
		hull() {
			translate([15.5,0,4.5]) rotate([0,-45,0]) cylinder(h=10,r=screw_dia/2,$fn=100);	// extrusion end hole
			translate([18.5,0,4.5]) rotate([0,-45,0]) cylinder(h=10,r=screw_dia/2,$fn=100);	// extrusion end hole
		}
		ms_notch(Side);
	}
	inner_support(Side);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
module inner_support(Side) {
	if(Side==1) {
		translate([22,-8,8]) cubeX([4,4,20],radius=2,center=true); // supports inside triangle
		difference() {
			translate([22,8,8]) cubeX([4,4,20],radius=2,center=true);
			ms_notch(Side);
		}
	}
	if(Side==0) {
		translate([22,8,8]) cubeX([4,4,20],radius=2,center=true);
		difference() {
			translate([22,-8,8]) cubeX([4,4,20],radius=2,center=true); // supports inside triangle
			ms_notch(Side);
		}
	}
	if(Side==3) {
		translate([22,8,8]) cubeX([4,4,20],radius=2,center=true);
		translate([22,-8,8]) cubeX([4,4,20],radius=2,center=true); // supports inside triangle
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
module ms_notch(Side) {
	if(Side==1) {
		translate([-50,14,-9]) rotate([45,0,0]) cube([100,10,10]);
	}
	if(Side==0) {
		translate([-50,-14,-9]) rotate([45,0,0]) cube([100,10,10]);
	}
	// if(Side==3) nothing done here
}
 
/////////////// end of corexy-sidesupport.scad ////////////////////////////////////
