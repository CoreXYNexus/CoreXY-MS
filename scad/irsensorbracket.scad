//////////////////////////////////////////////////////////////////////////////////////////////////////////
// irsensorbracket.scad - bracket for dc42's ir sensor
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 5/1/2016
// last update 8/7/2016
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// 5/2/16 - added mounting holes to use it on a Wilson II
//			added recess for thru hole pin header
// 5/9/16 - recess adjusted
// 8/5/16 - made more parametric
// 8/7/16 - For side mount: slotted one mounting hole to make it easier to get the second screw started
/////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubex.scad>
$fn=50;
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
//---------------------------------------------------------------------------------------
// following are taken from https://miscsolutions.wordpress.com/mini-height-sensor-board
hole1x = 2.70;
hole1y = 14.92;
hole2x = 21.11;
hole2y = 14.92;
holedia = 2.8;
//---------------------------------------------------------------------------------------
offset = 3;		// ir sensor mount hole distance (from bottom of the mount slot to the nozzle)
spacing = 17; 	// extruder mount hole spacing (wilson II is 23)
offset2 = 9;	// shift extruder mount holes
notch_d = 4;	// depth of notch to clear thru hole components
//-----------------------------------------------------------------------------------------
hotend_length = 50; // 50 for E3DV6
board_overlap = 2.5; // amount ir borad overlap sensor bracket
irboard_length = 17 - board_overlap; // length of ir board less the overlap on the bracket
ir_gap = 0;		// adjust edge of board up/down
//-----------------------------------------------------------------------------------------
mount_height = hotend_length - irboard_length - ir_gap;	// height of the mount
mount_width = 31;	// width of the mount
thickness = 6;		// thickness of the mount
mounty = mount_height-3; // position of the ir mount holes from end
shift_reduce = 0;  // move hole up/down

////////////////////////////////////////////////////////////////////////////////////////////////////////////

iradapter(0);  // 0 side mount; 1 top mount

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module iradapter(Top) {
	difference() {
		cubeX([mount_width,mount_height,thickness],2); // mount base
		reduce();
		block_mount();
		ext_mount(Top);
		recess();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module recess() { // make space for the thru hole pin header
	translate([hole1x+4.5,hole1y+2+(mount_height/4),notch_d]) cube([15.5,10,5]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module reduce() { // reduce amount of plastic used
	translate([15,mount_height-18.5+shift_reduce,-1]) cylinder(h=10,r = mount_width/4);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module block_mount() // mounting screw holes for the ir sensor
{
	//mounting screw holes
	translate([hole1x+offset,mounty,-5]) rotate([0,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
	translate([hole2x+offset,mounty,-5]) rotate([0,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ext_mount(Top) // screw holes for mounting to extruder plate
{
	if(Top) {	// AL extruder plate
		translate([27,15,3]) rotate([90,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
		translate([3,15,3]) rotate([90,0,0]) cylinder(h=20,r=screw3t/2,$fn=50);
	} else { // printed extruder plate
		translate([spacing+offset2,5,-3]) rotate([0,0,0]) cylinder(h=20,r=screw3/2,$fn=50);
		hull() { // slot it to make it easier to get the second screw started
			translate([offset2+0.5,5,-3]) rotate([0,0,0]) cylinder(h=20,r=screw3/2,$fn=50);
			translate([offset2-0.5,5,-3]) rotate([0,0,0]) cylinder(h=20,r=screw3/2,$fn=50);
	
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bheight = 17.62; // taken from https://miscsolutions.wordpress.com/mini-height-sensor-board/
bwidth = 24;
cap_d = 6.5;
cap_h = 8.2;
led_d = 3.5;
led_h = 5.7;
bthickness = 1;

//////////////////////////////////////////////////////////////
module ir_mockup() {
	difference() {
		cube([bwidth,bheight,bthickness]); // pc board
		translate([hole1x,hole1y,-1]) cylinder(h=thickness*5,r=holedia/2,$fn=100); // mounting hole
		translate([hole2x,hole2y,-1]) cylinder(h=thickness*5,r=holedia/2,$fn=100); // mounting hole
	}
	translate([width/2,cap_d/2+0.5,thickness]) cylinder(h=cap_h,r=cap_d/2,$fn=100); // C3
	
	translate([width/2+6.2,led_d/2+1,thickness]) cylinder(h=led_h,r=led_d/2,$fn=100); // D1
	translate([width/2+10,led_d/2+1,thickness]) cylinder(h=led_h,r=led_d/2,$fn=100); // D2
	
	translate([width/2-5.5,led_d/2+1,thickness]) cylinder(h=led_h,r=led_d/2,$fn=100); // Q1
	
	translate([width/2-6,height-3.5,thickness]) cube([7.4,2.5,9]); // pin header
}

///////////////////////////// end of irsensorbracket.scad ////////////////////////////////////////////////////