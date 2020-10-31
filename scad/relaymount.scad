///////////////////////////////////////////////////////////////////////////////
// relaymount.scad - something to mount a relay/buckconvertor board to 2020
///////////////////////////////////////////////////////////////////////////////
// created 2/13/16
// last update 10/20/20
///////////////////////////////////////////////////////////////////////////////
// 2/24/16	- added zip tie option
// 5/17/16	- changed to use CubeX and the corrected the math for the mount holes
//			  added zip tie thickness and the option to have screw & zip mount
// 8/18/16	- Added x,y vars for pc board holes
// 5/10/19	- made the mount() parametric via the passed variables
// 10/20/20	- Added use of brass inserts
///////////////////////////////////////////////////////////////////////////////
use <inc/cubex.scad>
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
$fn=50;
///////////////////////////////////////////////////////////////////////////////
// vars
///////////////////////////////////////////////////////////////////////////////
Bossh = 2;		// spacing needed to clear stuff on bottom of board
ZipTiewidth = 4;		// zip tie width
ZipTieThickness = 2;	// zip tie thickness
Use3mmInsert=1;
LargeInsert=1;
Use5mmInsert=1;
///////////////////////////////////////////////////////////////////////////////

// 1st arg is type: 0 - zip tie mount;1 - screw mount;2 - both;3 - neither
//RelayMount(2,Width,Length,Thickness,Side_dx,Side_dy);
RelayMount(2,21.2,43.1,5,6.3,3); // ebay buck convertor
//translate([0,30,0]) RelayMountBrassM5(21.2,43.1,5,6.3,3); // uses a M5 brass insert to mount

///////////////////////////////////////////////////////////////////////////////

module RelayMount(type,width,length,thickness,side_dx,side_dy) {
	difference() {
		cubeX([length,width+2,thickness],2);
		translate([0,1,0]) BoardHoles(Yes3mmInsert(Use3mmInsert,LargeInsert),thickness,side_dx,side_dy,length,width);
		if(type==0)	ZipTieSlot(width,length,thickness);
		if(type==1) translate([0,1,0]) MountHole(screw5,width,length,thickness);
		if(type==2) {
			translate([0,1,0]) MountHole(screw5,width,length,thickness);
			ZipTieSlot(width,length,thickness);
		}
	}
	difference() {
		translate([0,1,0]) Boss(Yes3mmInsert(Use3mmInsert,LargeInsert),thickness,side_dx,side_dy,length,width);
		translate([-1,-1,-3]) color("gray") cube([length+2,width+4,thickness]);
	}
}

///////////////////////////////////////////////////////////////////////////////

module RelayMountBrassM5(width,length,thickness,side_dx,side_dy) {
	difference() {
		cubeX([length,width+2,thickness],2);
		translate([0,1,0]) BoardHoles(Yes3mmInsert(Use3mmInsert,LargeInsert),thickness,side_dx,side_dy,length,width);
		translate([0,1,0]) BrassInsertMount(Yes5mmInsert(Use5mmInsert),width,length,thickness);
	}
	difference() {
		translate([0,1,0]) Boss(Yes3mmInsert(Use3mmInsert,LargeInsert),thickness+2,side_dx,side_dy,length,width);
		translate([-1,-1,-3]) color("gray") cube([length+2,width+4,thickness]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////

module BrassInsertMount(Screw=Yes5mmInsert(Use5mmInsert),width,length,thickness) {
	translate([length/2,width/2,-2]) cylinder(h=thickness+5,d=Screw);
}

///////////////////////////////////////////////////////////////////////////////

module BoardHoles(Screw,thickness,side_dx,side_dy,length,width) { // holes for mounting the relay board
		translate([side_dx,side_dy,-2]) cylinder(h=thickness+8,d=Screw);
		translate([length-side_dx,side_dy,-2]) cylinder(h=thickness+8,d=Screw);
		translate([side_dx,width-side_dy,-2]) cylinder(h=thickness+8,d=Screw);
		translate([length-side_dx,width-side_dy,-2]) cylinder(h=thickness+8,d=Screw);
}
///////////////////////////////////////////////////////////////////////////////

module MountHole(Screw,width,length,thickness) { // hole to mount it to 2020
	translate([length/2,width/2,-2]) cylinder(h=thickness+5,r=screw5/2);
	// countersink the screw
	translate([length/2,width/2,thickness-1]) cylinder(h=thickness+5,r=screw5hd/2);
	
}

///////////////////////////////////////////////////////////////////////////////

module Boss(Screw,thickness,side_dx,side_dy,length,width) {
	difference() {
		translate([side_dx,side_dy,0]) color("red") cylinder(h=thickness+Bossh,d=Screw*1.6);
		translate([side_dx,side_dy,-1]) cylinder(h=thickness+8,d=Screw);
	}
	difference() {
		translate([length-side_dx,side_dy,]) color("blue") cylinder(h=thickness+Bossh,d=Screw*1.6);
		translate([length-side_dx,side_dy,-1]) cylinder(h=thickness+8,d=Screw);
	}
	difference() {
		translate([side_dx,width-side_dy,0]) color("plum") cylinder(h=thickness+Bossh,d=Screw*1.6);
		translate([side_dx,width-side_dy,-1]) cylinder(h=thickness+8,d=Screw);
	}
	difference() {
		translate([length-side_dx,width-side_dy,0]) color("black") cylinder(h=thickness+Bossh,d=Screw*1.6);
		translate([length-side_dx,width-side_dy,-1]) cylinder(h=thickness+8, d=Screw);
	}
}

/////////////////////////////////////////////////////////////////////////////////

module ZipTieSlot(width,length,thickness) {
	translate([length/2-ZipTiewidth/2,-1,thickness-ZipTieThickness/2]) cube([ZipTiewidth,60,3]);
}

//////////////////// end of relaymount.scad ///////////////////////////////////