///////////////////////////////////////////////////////////////////////////////////////
// corexy-XY.scad - xy bearing mount on the carriage plates
///////////////////////////////////////////////////////////////////////////////////////
// created 6/27/2016
// last upate 7/22/16
///////////////////////////////////////////////////////////////////////////////////////
// 7/3/16 - added comments and some assembly info
// 7/17/16 - swtiched to inside of carriage plate, added partial()
// 7/22/16 - added belt_adjust for adjusting the bearings on the b_mount
///////////////////////////////////////////////////////////////////////////////////////
// Requires drilling two holes in the makerslide carriage plate
// Use a couple of 3mm screws to space the b_mount above the makerslide, mark the outline
// of the b_mount on the plate, align the drill guide with the marking and drill the 5mm holes
// ------------------------------------------------------------------------------------
// On left side upper bearing set to rear, lower bearing set to front, stepper motor gear to match upper
// On right side lower bearing set to rear, upper bearing set to front, stepper motor gear to match lower
// ------------------------------------------------------------------------------------
// Uses 8 F625Z bearings, 8 5mm washers, 4 5x40mm screws
// Bearing stack is one washer, two bearings flanges out, one washer and one spacer
///////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
$fn = 50;
//////////////////////////////////////////////////////////////////////////////////////
// vars
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
///////////////////////////////////////////////////////////////////////////////////

all(1); // everything
//partial(0);

//////////////////////////////////////////////////////////////////////////////////

module all(Spacers) {	// all the parts as a plate
	b_mount(0,Spacers);	// 1st arg: 0 - left, 1 - right; 2nd arg 0 - no bearing spacers; 1 - bearing spacers
	translate([0,40,0])	b_mount(1,Spacers);
	translate([40,0,0])	drillguide();
}

//////////////////////////////////////////////////////////////////////////////////

module partial(Spacers) { // comment/uncomment parts needed
	b_mount(0,Spacers);
	translate([0,40,0])
		b_mount(1,Spacers);
	//translate([40,0,0])
	//	drillguide();
}

///////////////////////////////////////////////////////////////////////////////////

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
	difference() {
		cubeX([width,one_stack*2+10,5],2);
		translate([width/4-1,22,-1]) cylinder(h=10,r=screw5/2);	// mounting screw holes
		translate([width-width/4+1,12,-1]) cylinder(h=10,r=screw5/2);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////

module drillguide() {	// something to help in locating the holes to drill
	base();
}

/////////////////////////// corexy_XY.scad ///////////////////////////////////
