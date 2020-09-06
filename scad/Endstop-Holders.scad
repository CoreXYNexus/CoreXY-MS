////////////////////////////////////////////////////////////////////////////////////
// Endstop-Holders.scad - endstop holder for makerslide
////////////////////////////////////////////////////////////////////////////////////
// created: 5/10/2016
// last update: 8/8/20
////////////////////////////////////////////////////////////////////////////////////
// 6/29/16	- Adjusted mounting holes for use on the double slot side of makerslide
// 7/3/16	- Added arg for amount to move from edge to thing() & base()
//			 Made spacer plate a bit shorter to fit on corexy belt holder
//           Added spacerY(), adjustable stop for the y endstop to hit
// 7/17/17	- Added strikeX(), adjustable stop for the x endstop to hit
// 12/17/18	- Added colors for preview
// 2/26/19	- Added ability to change mounting screw sizes (M5/M4/M3)
// 8/8/20	- Simplified the x endstop
////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
Use3mmInsert=1;
include <brassfunctions.scad>
$fn=75;
////////////////////////////////////////////////////////////////////////////////////
// vars
Switch_ht=20;//15;		// height of holder
Switch_thk = 5;			// thickness of holder
Switch_thk2 = 6;		// thickness of spacer
HolderWidth = 33;	// width of holder
SwitchShift = 6;	// move switch mounting holes along width
StikeMountScrew=screw5; // the part the switch hits
////////////////////////////////////////////////////////////////////////////

//XStopMount(22,10,8,Yes3mmInsert(),screw5,8);	// TEMCo CN0097
XStopMount(10,0,0,screw2,screw5,4); // black microswitch inline mount
//translate([8,-40,0]) clamp(MountScrew);
//translate([-40,-40,0])strikeY(StikeMountScrew);
//translate([-30,-12,0]) strikeX(StikeMountScrew);

///////////////////////////////////////////////////////////////////////////

module XStopMount(Sep,DiagOffset,Offset,ScrewS,ScrewM=screw5,Adjust) {
	base(Sep,DiagOffset,Offset,ScrewS,Adjust);
	mount(ScrewM);
}

////////////////////////////////////////////////////////////////////////////////

module mount(Screw=screw4) {
	difference() {
		color("cyan") cubeX([22,HolderWidth,Switch_thk2],1);
		 color("red") hull() {
			translate([10,6,-1]) cylinder(h=Switch_thk*2,d=Screw);
			translate([10,7,-1]) cylinder(h=Switch_thk*2,d=Screw);
		}
		translate([10,26.5,-1]) color("blue") cylinder(h=Switch_thk*2,d=Screw);
	}
}

///////////////////////////////////////////////////////////////////////////////
module base(Sep,DiagOffset,Offset,ScrewT,Adjust) {
	difference() {
		//difference() {
			translate([-22-Adjust,0,0]) color("yellow") cubeX([Switch_ht+Adjust+5,HolderWidth,Switch_thk],1);
			// screw holes for switch
			translate([-(Switch_ht-Offset), SwitchShift, -1])
				color("purple") cylinder(h = 11, r = ScrewT/2, center = false, $fn=100);
			translate(v = [-(Switch_ht-Offset)+DiagOffset, SwitchShift+Sep, -1])
				color("black") cylinder(h = 11, r = ScrewT/2, center = false, $fn=100);
		//}
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
