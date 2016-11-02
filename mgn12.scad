///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// mgn12 - corexy with mgn12 rails
// created: 10/31/2016
// last modified: 10/31/2016
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Based on CXY-MSv1 printer
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
use <inc/Nema17.scad>	// https://github.com/mtu-most/most-scad-libraries
$fn=50;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// variables
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
puck_l = 45.4;	// length of mgn12h
puck_w = 27;	// width of mgn12h
hole_sep = 20;	// distance between mouning holes on mgn12h
thickness = 7;	// thickness of base that mounts on the mgn12h
width = 38;			// width of the bracket
f625z_d = 16;		// diameter of bearing where the belt rides
Obelt_height = 26;	// how far out from the carriage plate the inner belt is on the sides
Ibelt_height = 17;	// how far out from the carriage plate the outer belt is on the sides
belt_height = Obelt_height+2; // height of walls
belt_offset = 2.5;	// adjust distance between inner & outer belts bearings
belt = 10;			// belt width (used in base() to make the large center hole)
Ibelt_adjust = -2;	// adjust inner belt bearing postion (- closer to plate, + farther away)
Obelt_adjust = 2;	// adjust outer belt bearing postion (- closer to plate, + farther away)
one_stack = 11.78;	// just the length of two washers & two F625Z bearings

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

thing1(0);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module thing1(Left=0) { // needs a support piece for the bearing section and be centered to the x axis puck
	main_base();
	if(!Left) translate([(puck_l-width)/2,puck_w,0]) b_mount(0,0); // may need to be swapped
	if(Left) translate([(puck_l-width)/2,puck_w,0]) b_mount(1,0);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module main_base() {
	difference() {
		cubeX([puck_l,puck_w+5,thickness],2);
		// mounting holes
		translate([(puck_l/2)+(hole_sep/2),3.5,-1]) cylinder(h=thickness*2,d=screw3);
		translate([(puck_l/2)-(hole_sep/2),3.5,-1]) cylinder(h=thickness*2,d=screw3);
		translate([(puck_l/2)+(hole_sep/2),hole_sep+3.5,-1]) cylinder(h=thickness*2,d=screw3);
		translate([(puck_l/2)-(hole_sep/2),hole_sep+3.5,-1]) cylinder(h=thickness*2,d=screw3);
		// countersinks
		translate([(puck_l/2)+(hole_sep/2),3.5,thickness-1]) cylinder(h=thickness*2,d=screw3hd);
		translate([(puck_l/2)-(hole_sep/2),3.5,thickness-1]) cylinder(h=thickness*2,d=screw3hd);
		translate([(puck_l/2)+(hole_sep/2),hole_sep+3.5,thickness-1]) cylinder(h=thickness*2,d=screw3hd);
		translate([(puck_l/2)-(hole_sep/2),hole_sep+3.5,thickness-1]) cylinder(h=thickness*2,d=screw3hd);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module b_mount(upper,spacers) {	// bearing mount bracket
	base();
	walls(upper,0);
	walls(upper,1);
	if(spacers) {	// don't need them for the test prints after the first print
		translate([-10,one_stack-2,0]) rotate([-90,0,-0]) bearspacer(one_stack);
		translate([-10,one_stack*2,0]) rotate([-90,0,-0]) bearspacer(one_stack);
	}
}

//////////////////////////////////////////////////////////////////////////////////////

module walls(upper,lower) {	// the walls that hold the bearings
	if(lower) {
		difference() {	// lower bearing support wall
			cubeX([width,5,belt_height+f625z_d],2);
			bearscrews(upper);
		}
	} else {
		difference() {	// upper bearing support wall
			translate([0,one_stack*2+5,0]) cubeX([width,5,belt_height+f625z_d],2);
			bearscrews(upper);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////

module bearscrews(upper) {	// bearing screw holes
	if(upper) { // upper farther, lower closer
		translate([width-f625z_d/2-belt_offset,50,Ibelt_height+f625z_d/2+Ibelt_adjust]) rotate([90,0,0]) cylinder(h=60,r=screw5/2);
		translate([f625z_d/2+belt_offset,50,Obelt_height+f625z_d/2+Obelt_adjust]) rotate([90,0,0]) cylinder(h=60,r=screw5/2);
	} else {	// upper closer, lower farther
		translate([width-f625z_d/2-belt_offset,50,Obelt_height+f625z_d/2+Obelt_adjust]) rotate([90,0,0]) cylinder(h=60,r=screw5/2);
		translate([f625z_d/2+belt_offset,50,Ibelt_height+f625z_d/2+Ibelt_adjust]) rotate([90,0,0]) cylinder(h=60,r=screw5/2);
	}
}

//////////////////////////////////////////////////////////////////////////////////////

module bearspacer(length=one_stack) {	// fill in the non-bearing space
	difference() {
		rotate([90,0,0]) cylinder(h=length,r=screw5);
		translate([0,1,0]) rotate([90,0,0]) cylinder(h=length+5,r=screw5/2);
	}

}

///////////////////////////////////////////////////////////////////////////////////////////

module base() { // base mount
	//difference() {
		cubeX([width,one_stack*2+10,5],2);
	//	translate([width/4-1,22,-1]) cylinder(h=10,r=screw5/2);	// mounting screw holes
	//	translate([width-width/4+1,12,-1]) cylinder(h=10,r=screw5/2);
	//}
}

//////////////////////////////////////////////////////////////////////////////////////////

module drillguide() {	// something to help in locating the holes to drill
	base();
}

///////////////// end of mgn12.scad //////////////////////////////////////////////////////////////////////////////////
