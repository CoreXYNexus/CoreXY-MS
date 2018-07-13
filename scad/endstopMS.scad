////////////////////////////////////////////////////////////////////////////////////
// endstopMS.scad - endstop holder for makerslide
////////////////////////////////////////////////////////////////////////////////////
// created: 5/10/2016
// last update: 7/17/16
////////////////////////////////////////////////////////////////////////////////////
// 6/29/16 - Adjusted mounting holes for use on the double slot side of makerslide
// 7/3/16  - Added arg for amount to move from edge to thing() & base()
//			 Made spacer plate a bit shorter to fit on corexy belt holder
//           Added spacerY(), adjustable stop for the y endstop to hit
// 7/17/17 - Added strikeX(), adjustable stop for the x endstop to hit
////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
$fn=50;
////////////////////////////////////////////////////////////////////////////////////
// vars
Screw_dia=3.2;			// clamp screw diameter
Screw_Thread_dia=2.6;	// screw hole diameter to make a 3mm threaded hole
Switch_ht=20;//15;			// height of holder
Switch_thk = 5;			// thickness of holder
Switch_thk2 = 7;		// thickness of spacer
width = 33;	// width of holder
shift = 6;	// move switch mounting holes along width
////////////////////////////////////////////////////////////////////////////

//thing(hole distance,hole diagonal offset,amount to move from edge,screw hole size);

thing(22,10,3,screw3t);	// TEMCo CN0097: 22,10,screw3t ; Little green/black: 9,0,screw2
translate([0,40,0]) thing(10,0,7,screw2); // black microswitch inline mount
translate([0,-40,0]) clamp();
translate([-40,-35,0])strikeY();
translate([-55,0,0]) strikeX();

///////////////////////////////////////////////////////////////////////////

module thing(Sep,DiagOffset,Offset,ScrewT) {
	base(Sep,DiagOffset,Offset,ScrewT);
	mount();
}

////////////////////////////////////////////////////////////////////////////////

module mount() {
	difference() {
		color("cyan") cubeX([22,width,Switch_thk],2);
		translate([10,6.5,-1]) color("red") cylinder(h=Switch_thk*2,r=screw5/2);
		translate([10,26.5,-1]) color("blue") cylinder(h=Switch_thk*2,r=screw5/2);
	}
	difference() {
		translate([2,0,Switch_thk-4]) cubeX([20,width,Switch_thk2],2);
		translate([10,6.5,1]) cylinder(h=Switch_thk*3,r=screw5/2);
		translate([10,26.5,1]) cylinder(h=Switch_thk*3,r=screw5/2);
	}
}

///////////////////////////////////////////////////////////////////////////////
module base(Sep,DiagOffset,Offset,ScrewT) {
	rotate([0,-90,0]) difference() {
		difference() {
			translate([0,0,-4]) color("yellow") cubeX([Switch_thk,width,Switch_ht+4],2);
			// screw holes for switch
			rotate([0,90,0]) {		
				translate([-(Switch_ht-Offset), shift, -1]) {
					color("purple") cylinder(h = 11, r = ScrewT/2, center = false, $fn=100);
				}
			}
			rotate([0,90,0]) {
				translate(v = [-(Switch_ht-Offset)+DiagOffset, shift+Sep, -1]) {
					color("black") cylinder(h = 11, r = ScrewT/2, center = false, $fn=100);
				}
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////

module clamp() {	// something to clamp the wires on the corexy belt holder
	difference() {
		cubeX([15,width,4],2);
		translate([7.5,6.5,-1]) cylinder(h=Switch_thk*2,r=screw5/2);
		translate([7.5,26.5,-1]) cylinder(h=Switch_thk*2,r=screw5/2);
	}
}

/////////////////////////////////////////////////////////////////////////////

module strikeY() {	// used on y a-xis
	difference() {
		color("cyan") cubeX([35,25,12],2);
		translate([9,28,6]) rotate([90,0,0]) color("red") cylinder(h=30,r=screw5/2);
		translate([9,5,6]) rotate([90,0,0]) color("blue") cylinder(h=30,r=screw5hd/2);
	}
}

/////////////////////////////////////////////////////////////////////////////

module strikeX() {	// used on y a-xis
	difference() {	
		color("cyan") cubeX([9,80,9],radius=2,center=true);
		translate([-10,-35,0]) rotate([0,90,0]) color("red") cylinder(h=20,d=screw5);
		translate([-10,-15,0]) rotate([0,90,0]) color("blue") cylinder(h=20,d=screw5);
	}
	translate([14,35,0]) color("black") cubeX([35,10,9],radius=2,center=true);
}

////////////////////////////////////////////////////////////////////////////
