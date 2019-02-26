////////////////////////////////////////////////////////////////////////////////////
// Endstop-Holders.scad - endstop holder for makerslide
////////////////////////////////////////////////////////////////////////////////////
// created: 5/10/2016
// last update: 2/26/19
////////////////////////////////////////////////////////////////////////////////////
// 6/29/16	- Adjusted mounting holes for use on the double slot side of makerslide
// 7/3/16	- Added arg for amount to move from edge to thing() & base()
//			 Made spacer plate a bit shorter to fit on corexy belt holder
//           Added spacerY(), adjustable stop for the y endstop to hit
// 7/17/17	- Added strikeX(), adjustable stop for the x endstop to hit
// 12/17/18	- Added colors for preview
// 2/26/19	- Added ability to change mounting screw sizes (M5/M4/M3)
////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
$fn=75;
////////////////////////////////////////////////////////////////////////////////////
// vars
Switch_ht=20;//15;		// height of holder
Switch_thk = 5;			// thickness of holder
Switch_thk2 = 7;		// thickness of spacer
HolderWidth = 33;	// width of holder
SwitchShift = 6;	// move switch mounting holes along width
MountScrew=screw5;
StikeMountScrew=screw5;
////////////////////////////////////////////////////////////////////////////

//thing(hole distance,hole diagonal offset,amount to move from edge,screw hole size);

thing(22,10,3,screw3t,MountScrew);	// TEMCo CN0097: 22,10,screw3t ; Little green/black: 9,0,screw2
translate([0,40,0]) thing(10,0,7,screw2,MountScrew); // black microswitch inline mount
translate([0,-40,0]) clamp(MountScrew);
translate([-40,-40,0])strikeY(StikeMountScrew);
translate([-40,-12,0]) strikeX(StikeMountScrew);

///////////////////////////////////////////////////////////////////////////

module thing(Sep,DiagOffset,Offset,ScrewT,ScrewM=screw5) {
	base(Sep,DiagOffset,Offset,ScrewT);
	mount(ScrewM);
}

////////////////////////////////////////////////////////////////////////////////

module mount(Screw=screw5) {
	difference() {
		color("cyan") cubeX([22,HolderWidth,Switch_thk],1);
		translate([10,6.5,-1]) color("red") cylinder(h=Switch_thk*2,d=Screw);
		translate([10,26.5,-1]) color("blue") cylinder(h=Switch_thk*2,d=Screw);
	}
	difference() {
		translate([2,0,Switch_thk-4]) color("gray") cubeX([20,HolderWidth,Switch_thk2],1);
		translate([10,6.5,1]) color("black") cylinder(h=Switch_thk*3,d=Screw);
		translate([10,26.5,1]) color("red") cylinder(h=Switch_thk*3,d=Screw);
	}
}

///////////////////////////////////////////////////////////////////////////////
module base(Sep,DiagOffset,Offset,ScrewT) {
	rotate([0,-90,0]) difference() {
		difference() {
			translate([0,0,-4]) color("yellow") cubeX([Switch_thk,HolderWidth,Switch_ht+4],1);
			// screw holes for switch
			rotate([0,90,0]) {		
				translate([-(Switch_ht-Offset), SwitchShift, -1]) {
					color("purple") cylinder(h = 11, r = ScrewT/2, center = false, $fn=100);
				}
			}
			rotate([0,90,0]) {
				translate(v = [-(Switch_ht-Offset)+DiagOffset, SwitchShift+Sep, -1]) {
					color("black") cylinder(h = 11, r = ScrewT/2, center = false, $fn=100);
				}
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////

module clamp(Screw=screw5) {	// something to clamp the wires on the corexy belt holder
	difference() {
		color("plum") cubeX([15,HolderWidth,4],1);
		translate([7.5,6.5,-1]) color("white") cylinder(h=Switch_thk*2,d=Screw);
		translate([7.5,26.5,-1]) color("pink") cylinder(h=Switch_thk*2,d=Screw);
	}
}

/////////////////////////////////////////////////////////////////////////////

module strikeY(Screw=screw5) {	// used on y a-xis
	difference() {
		color("cyan") cubeX([35,25,12],1);
		translate([9,28,6]) rotate([90,0,0]) color("red") cylinder(h=30,r=Screw/2);
		if(Screw==screw3) translate([9,5,6]) rotate([90,0,0]) color("blue") cylinder(h=30,d=screw3hd);
		if(Screw==screw4) translate([9,5,6]) rotate([90,0,0]) color("blue") cylinder(h=30,d=screw4hd);
		if(Screw==screw5) translate([9,5,6]) rotate([90,0,0]) color("blue") cylinder(h=30,d=screw5hd);
	}
}

/////////////////////////////////////////////////////////////////////////////

module strikeX(Screw=screw5) {	// used on y a-xis
	difference() {	
		color("cyan") cubeX([9,80,9],1);
		translate([-5,54,4.5]) mount2040(Screw);
	}
	translate([0,0,0]) color("black") cubeX([35,10,9],radius=2);
}

///////////////////////////////////////////////////////////////////////////////////////////

module mount2040(Screw=screw5) {
	translate([0,0,0]) rotate([0,90,0]) color("red") cylinder(h=20,d=Screw);
	translate([0,20,0]) rotate([0,90,0]) color("blue") cylinder(h=20,d=Screw);
}

////////////////////////////////////////////////////////////////////////////
