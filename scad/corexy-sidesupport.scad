////////////////////////////////////////////////////////////////////////////
// corexy-sidesupport.scad - extracted from MakerSlideMendel.scad
////////////////////////////////////////////////////////////////////////////
// Created: 7/20/2016
////////////////////////////////////////////////////////////////////////////
// Last Update: 7/9/2018
////////////////////////////////////////////////////////////////////////////
// 7/20/16	- adjusted positions for cubeX and added ms_notch for using against
//			  makerslide
// 7/28/16	- changed bottom access hole and slotted the hole for the 2020 end
// 7/9/18	- Added corner-tools.scad to round over the large screw access holes
//			  added missing mounting hole
////////////////////////////////////////////////////////////////////////////
// It takes a while to render all
////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>
use <inc/corner-tools.scad>
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

//all();
partial();

//////////////////////////////////////////////////////////////////////////////

module all() {
	translate([0,-10,0]) rotate([90,0,0]) // lay down for printing
		MS_corner(1,0);
	rotate([-90,0,0]) // lay down for printing
		MS_corner(0,0);	
	translate([-40,-20,0]) rotate([90,0,0]) // lay down for printing
		MS_corner(3,0);
	translate([-40,10,0]) rotate([-90,0,0]) // lay down for printing
		MS_corner(3,0);
}

/////////////////////////////////////////////////////////////////////////////
module partial() {
	MS_corner(0,0);	// 1st arg is ms notch: 0,1 for adding a notch, 3 for no notch; 1 for tab, 0 no tab
//	MS_corner(1,0);	
//	MS_corner(3,0);
}

////////////////////////////////////////////////////////////////////////////
// support strut bottom
////////////////////////////////////////////////////////////////////////////
module MS_corner(SideN,doTab) // currently at 45 degrees ** may need to adjust this
{	// 1st arg is ms notch: 0,1 for adding a notch, 3 for no notch; 1 tab, 0 no tab
	difference() {
		color("cyan") cubeX([length,width,4],radius=2,center=true);	// horizontal
		ms_notch(SideN);
		color("red") hull() {	// elongated mounting hole
			translate([28.5,0,-8]) cylinder(h=20,r=screw_dia/2,$fn=100);
			translate([30,0,-7.5]) rotate([0,-45,0]) cylinder(h=20,r=screw_dia/2,$fn=100);
		}
		translate([-length/3,0,-7.5]) color("blue") cylinder(h=20,r=screw_dia/2,$fn=100); // bottom mounting hole
	}
	if(doTab) {		// 1 for tab, 0 no tab
		difference() {
			translate([30,-19.9,0]) cubeX([width,width,4],radius=2,center=true);	// horizontal side mount
			translate([30,-20,-5]) cylinder(h=10,r=screw_dia/2,$fn=100);		// hole
		}
	}
	difference() {
		translate([20.5,0,18]) rotate([0,45,0]) thetoppart();
		ms_notch(SideN);
	}
	 difference() {
		translate([10,0,-7]) rotate([0,-45,0]) theinsidepart();
		ms_notch(SideN);
	}
	inner_support(SideN);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module theinsidepart() {
	difference() {
		translate([13.5,0,8]) color("pink") cubeX([26.5,width,4],radius=2,center=true);
		translate([15,0,4.5]) cylinder(h=10,r=screw_hd_dia/2+0.5,$fn=100);	// extrusion end hole
		translate([15,0,6]) rotate([180,0,0]) color("cyan") fillet_r(2,screw_hd_dia/2+0.5,-1,$fn);	// mounting hole
		translate([15,0,10]) color("cyan") fillet_r(2,screw_hd_dia/2+0.5,-1,$fn);	// mounting hole
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module thetoppart() {
	difference() {
		cubeX([length2,width,4],radius=2,center=true);	// long vertical
		translate([-18,0,-5]) color("red") cylinder(h=10,r=screw_dia/2,$fn=100);	// mounting hole
		translate([15,0,-5]) color("blue") cylinder(h=10,r=screw_hd_dia/2+0.5,$fn=100); // top access hole
		translate([15,0,-2]) rotate([180,0,0]) color("cyan") fillet_r(2,screw_hd_dia/2+0.5,-1,$fn);	// mounting hole
		translate([15,0,2.1]) color("cyan") fillet_r(2,screw_hd_dia/2+0.5,-1,$fn);	// mounting hole
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
		translate([-50,14,-9]) rotate([45,0,0]) color("black") cube([100,10,10]);
	}
	if(Side==0) {
		translate([-50,-14,-9]) rotate([45,0,0]) color("gray") cube([100,10,10]);
	}
	// if(Side==3) nothing done here
}
 
/////////////// end of corexy-sidesupport.scad ////////////////////////////////////
