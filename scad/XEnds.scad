///////////////////////////////////////////////////////////////////////////////////////
// CoreXY-X-Ends.scad - xy bearing mount on the carriage plates
///////////////////////////////////////////////////////////////////////////////////////
// created 6/27/2016
// last upate 8/19/2018
///////////////////////////////////////////////////////////////////////////////////////
// 7/3/16 - added comments and some assembly info
// 7/17/16 - swtiched to inside of carriage plate, added partial()
// 7/22/16 - added belt_adjust for adjusting the bearings on the b_mount
// 1/10/17 - added labels and colors to preview for easier editing
// 8/19/18	- OpenSCAD 2018.06.01 for $preview
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
// U - bearings on upper, D - bearings on lower
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
	if($preview) %translate([0,0,-5]) cube([200,200,2],center=true); // show the 200x200 bed
	b_mount(0,Spacers);	// 1st arg: 0 - left, 1 - right; 2nd arg 0 - no bearing spacers; 1 - bearing spacers
	translate([0,-40,0])	b_mount(1,Spacers);
	translate([40,-40,0])	drillguide();
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
	if(!upper) {
		translate([10,10,4.5]) printchar("Left");
		translate([8,35,12]) rotate([90,0,0]) printchar("D");
		translate([30,35,30]) rotate([90,180,0]) printchar("U");
	} else {
		translate([10,10,4.5]) printchar("Right");
		translate([12,35,30]) rotate([90,180,0]) printchar("U");
		translate([25,35,12]) rotate([90,0,0]) printchar("D");
	}
}

//////////////////////////////////////////////////////////////////////////////////////

module walls(upper,lower) {	// the walls that hold the bearings
	if(lower) {
		difference() {	// lower bearing support wall
			color("red") cubeX([width,5,belt_height+f625z_d],2);
			bearscrews(upper);
		}
	} else {
		difference() {	// upper bearing support wall
			translate([0,one_stack*2+5,0]) color("blue") cubeX([width,5,belt_height+f625z_d],2);
			bearscrews(upper);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////

module bearscrews(upper) {	// bearing screw holes
	if(upper) { // upper farther, lower closer
		translate([width-f625z_d/2-belt_offset,50,Ibelt_height+f625z_d/2+Ibelt_adjust]) rotate([90,0,0]) color("red") cylinder(h=60,r=screw5/2);
		translate([f625z_d/2+belt_offset,50,Obelt_height+f625z_d/2+Obelt_adjust]) rotate([90,0,0]) color("white") cylinder(h=60,r=screw5/2);
	} else {	// upper closer, lower farther
		translate([width-f625z_d/2-belt_offset,50,Obelt_height+f625z_d/2+Obelt_adjust]) rotate([90,0,0])  color("yellow")cylinder(h=60,r=screw5/2);
		translate([f625z_d/2+belt_offset,50,Ibelt_height+f625z_d/2+Ibelt_adjust]) rotate([90,0,0])  color("gray")cylinder(h=60,r=screw5/2);
	}
}

//////////////////////////////////////////////////////////////////////////////////////

module bearspacer(length=one_stack) {	// fill in the non-bearing space
	difference() {
		rotate([90,0,0]) color("pinK") cylinder(h=length,r=screw5);
		translate([0,1,0]) rotate([90,0,0]) color("cyan") cylinder(h=length+5,r=screw5/2);
	}

}

///////////////////////////////////////////////////////////////////////////////////////////

module base() { // base mount
	difference() {
		color("cyan") cubeX([width,one_stack*2+10,5],2);
		translate([width/4-1,22,-1]) color("salmon") cylinder(h=10,r=screw5/2);	// mounting screw holes
		translate([width-width/4+1,12,-1]) color("green") cylinder(h=10,r=screw5/2);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////

module drillguide() {	// something to help in locating the holes to drill
	base();
	translate([3,3,4.5]) printchar("Drill Guide");
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=1.5,Size=4) { // print something
	color("coral") linear_extrude(height = Height) text(String, font = "Liberation Sans",size=Size);
}

/////////////////////////// corexy_XY.scad ///////////////////////////////////
