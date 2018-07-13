//////////////////////////////////////////////////////////////////////////
// blower.scad - adapter for blower fan to an AL plate
//////////////////////////////////////////////////////////////////////////
// created 5/21/2016
// last update 9/30/16
//////////////////////////////////////////////////////////////////////////
// 6/29/16 Made fan mount a bit thicker
// 7/19/16 Added adapter3() for corexy x-carriage extruder plate
// 8/26/16 Uses fanduct.scad see http://www.thingiverse.com/thing:387301
//		   Have it in the same folder as this file
// 9/30/16 Added adapter for the titan extruder setup, some vars and modules are from
//		   corexy-x-carriage.scad
// 7/13/18 Added color to preview
//////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>
use <fanduct.scad> // http://www.thingiverse.com/thing:387301
$fn=50;
//////////////////////////////////////////////////////////////////////////
// vars
//////////////////////////////////////////////////////////////////////////
thickness = 6.5;
Mheight = 6;
Mwidth = 40;
Fspace = 15;
Fwidth = Fspace + 6;
Fheight = 15;
thickness3 = 6.5;
Mheight3 = 6;
Mwidth3 = 60;
Fheight3 = 10;
// from corexy-x-carriage.scad ------------------------------------------------
wall = 8;		// thickness of the plates
width = 75;		// width of back/front/extruder plates
depthE = wall;	// thickness of the extruder plate
heightE = 60; 	// screw holes may need adjusting when changing the front to back size
extruder = 50;	// mounting hole distance
extruder_back = 18; // adjusts extruder mounting holes from front edge
fan_spacing = 32;	// hole spaceing for a 40mm fan
fan_offset = -6;  // adjust to align fan with extruder
servo_spacing = fan_spacing;
servo_offset = 20; // adjust to move servo mount
screw_depth = 25;
//////////////////////////////////////////////////////////////////////////

titan_version();

///////////////////////////////////////////////////////////////////////////
module titan_version() {
translate([0,-20,0])
	adaptertitan();
translate([0,45,0])
	adaptertitan2();
translate([-15,0,0]) color("cyan") FanDuct();
translate([-45,0,0]) color("red") FanDuct();
}

//////////////////////////////////////////////////////////////////////////

module adapter() {
	difference() {
		color("cyan") cube([Mwidth,Mheight,thickness]); 
		ext_mount();
	}
	fanmount();
}

module adapter2() {
	difference() {
		color("cyan") cube([Mwidth,Mheight,thickness]);
		ext_mount();
	}
	fanmount2();
}

module fanmount() { // mount the blower
	difference() {
		translate([Mwidth/2-3,0,thickness]) color("cyan") cube([Fwidth,thickness,Fheight]);
		translate([Mwidth/2,-1,Fheight-Fspace/2+1]) color("red") cube([Fspace,thickness+2,Fspace]);
		translate([Mwidth/2-5,thickness/2,Fheight]) rotate([0,90,0]) color("black") cylinder(h=Fwidth*2,r=screw4/2,$fn=50);
	}
}

module fanmount2() { // mount the blower
	difference() {
		translate([Mwidth/2-2.5,0,thickness]) color("cyan") cube([Fwidth,thickness,Fheight*2]);
		translate([Mwidth/2,-1,Fheight+Fspace/2]) color("red") cube([Fspace,thickness+2,Fspace]);
		translate([Mwidth/2-5,thickness/2,Fheight*2]) rotate([0,90,0]) color("blue") cylinder(h=Fwidth*2,r=screw4/2,$fn=50);
		translate([Mwidth/2-5,thickness-1,Mheight-0.9]) rotate([-20,0,0]) color("black") cube([Fwidth+5,thickness,Fheight]);
	}
}

module ext_mount() {
	//mounting screw holes
	translate([8,thickness+2,thickness/2]) rotate([90,0,0]) color("cyan") cylinder(h=20,r=screw3t/2,$fn=50);
	translate([32,thickness+2,thickness/2]) rotate([90,0,0]) color("blue") cylinder(h=20,r=screw3t/2,$fn=50);
}

module adapter3() {
	difference() {
		color("cyan") cube([Mwidth3,Mheight3,thickness3]);
		ext_mount3();
	}
	translate([6,7,0]) rotate([90,0,0]) fanmount3();
}

module ext_mount3() {	//mounting screw holes
	translate([5,thickness3+2,thickness3/2]) rotate([90,0,0]) color("blue") cylinder(h=20,r=screw3/2,$fn=50);
	translate([21,thickness3+2,thickness3/2]) rotate([90,0,0]) color("red") cylinder(h=20,r=screw3/2,$fn=50);
}

module fanmount3() { // mount the blower
	difference() {
		translate([Mwidth3/2+2,0,thickness3]) color("cyan") cube([Fwidth,thickness3*3.5,Fheight3*2.5]);
		translate([Mwidth3/2+5,-1,Fheight3+1]) color("red") cube([Fspace,thickness3*3.5+2,Fspace*2]);
		translate([Mwidth3/2-5,thickness3/2+14,Fheight3*2+6]) rotate([0,90,0]) color("black") cylinder(h=Fwidth*2,r=screw4/2,$fn=50);
	}
}

module adaptertitan() { // stepper motor side
	translate([0,Mheight3,0]) rotate([0,0,180]) difference() {
		color("cyan") cubeX([Mwidth3,Mheight3,thickness3],2);
		translate([0,-25,48]) rotate([90,0,90]) mountingholes();
	}
	translate([-42,-Fwidth+9,0]) color("cyan") cubeX([Fwidth,Fwidth-6,thickness3]);
	translate([-74,-4.55,0]) rotate([90,0,0]) fanmounttitan();
}

module adaptertitan2() { // extruder cooling fan side
	translate([0,Mheight3,0]) rotate([0,0,180]) difference() {
		color("cyan") cubeX([Mwidth3,Mheight3+4,thickness3],2);
		translate([0,-25,48]) rotate([90,0,90]) mountingholes();
		translate([9,-9,-2]) color("red") cubeX([35,Fwidth-6,thickness3+4],2);
	}
	difference() {
		translate([-68,6,0]) rotate([90,0,0]) fanmounttitan(14);
		translate([-45,0,-2]) color("blue") cubeX([35,Fwidth-6,thickness3+4],2);
		translate([-45,5,0.5]) rotate([40,0,0]) color("black") cubeX([35,Fwidth-6,thickness3+2],2);
	}
}

module fanmounttitan(Add=0) { // mount the blower
	difference() {
		translate([Mwidth3/2+2,0,thickness3-1]) color("gray") cubeX([Fwidth,thickness3*2.7,Fheight3*1.7+Add]);
		translate([Mwidth3/2+5,-1,Fheight3]) color("yellow") cubeX([Fspace,thickness3*3.5+2,Fspace*2]);
		translate([Mwidth3/2,13,Fheight3*2-3+Add]) rotate([0,90,0]) color("purple") cylinder(h=Fwidth*2,r=screw4/2,$fn=50);
	}
}

module mountingholes(Inner=0) {	// mounting holes (copied from fan() & servo() modules in corexy-x-carriage.scad)
	// outer holes
	translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
		rotate([0,90,0]) color("red") cylinder(h = depthE+screw_depth,r = screw3/2,$fn=50);
	translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
		rotate([0,90,0]) color("blue") cylinder(h = depthE+screw_depth,r = screw3/2,$fn=50);
	// inner holes
	if(Inner) {
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
			rotate([0,90,0]) color("black") cylinder(h = depthE+screw_depth,r = screw3/2,$fn=50);
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("green") cylinder(h = depthE+screw_depth,r = screw3/2,$fn=50);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////