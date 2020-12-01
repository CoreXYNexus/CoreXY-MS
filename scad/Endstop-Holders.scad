////////////////////////////////////////////////////////////////////////////////////
// Endstop-Holders.scad - endstop holder for makerslide
////////////////////////////////////////////////////////////////////////////////////
// created: 5/10/2016
// last update: 10/31/20
////////////////////////////////////////////////////////////////////////////////////
// 6/29/16	- Adjusted mounting holes for use on the double slot side of makerslide
// 7/3/16	- Added arg for amount to move from edge to thing() & base()
//			 Made spacer plate a bit shorter to fit on corexy belt holder
//           Added spacerY(), adjustable stop for the y endstop to hit
// 7/17/17	- Added strikeX(), adjustable stop for the x endstop to hit
// 12/17/18	- Added colors for preview
// 2/26/19	- Added ability to change mounting screw sizes (M5/M4/M3)
// 8/8/20	- Simplified the x endstop
// 9/27/20	- Change mounts onto belt attachment to M4 or M5, and slotted, so you don't have to be perfect with the inserts
// 10/31/20	- Added missing y endstop holder
////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
include <inc/brassinserts.scad>
$fn=75;
////////////////////////////////////////////////////////////////////////////////////
// vars
Use2mmInsert=1;
Use2p5Insert=1;
Use3mmInsert=1;
Use4mmInsert=1;
Use5mmInsert=1;
LargeInsert=1;
Switch_ht=20;//15;		// height of holder
Switch_thk = 5;			// thickness of holder
Switch_thk2 = 6;		// thickness of spacer
HolderWidth = 33;	// width of holder
SwitchShift = 6;	// move switch mounting holes along width
LayerThickness=0.3;
////////////////////////////////////////////////////////////////////////////

//XStopMount(22,10,8,Yes3mmInsert(Use3mmInsert,LargeInsert),screw5,8);	// TEMCo CN0097
//XStopMount(10,0,0,Yes2mmInsert(Use2mmInsert),screw5,4); // black microswitch
//translate([0,40,0]) YStopMount(22,10,8,Yes3mmInsert(Use3mmInsert,LargeInsert),screw4,8);	// TEMCo CN0097
//translate([0,40,0]) YStopMount(10,0,0,Yes2mmInsert(Use2mmInsert),screw5,4); // black microswitch
//translate([-40,-40,0])strikeY(screw5);
translate([-40,-12,0]) strikeX(screw5);

///////////////////////////////////////////////////////////////////////////

module XStopMount(Sep,DiagOffset,Offset,ScrewSwitch,ScrewMount=screw5,Adjust) {
	base(Sep,DiagOffset,Offset,ScrewSwitch,Adjust);
	mount(ScrewMount);
}

///////////////////////////////////////////////////////////////////////////

module YStopMount(Sep,DiagOffset,Offset,ScrewSwitch,ScrewMount=screw5,Adjust) {
	base(Sep,DiagOffset,Offset,ScrewSwitch,Adjust);
	mountY(ScrewMount);
}

////////////////////////////////////////////////////////////////////////////////

module mountY(Screw=screw5) {
	difference() {
		color("cyan") cubeX([22,HolderWidth,Switch_thk2],1);
		translate([10,6,-1]) cylinder(h=Switch_thk*2,d=Screw);
		translate([10,26,-1]) color("blue") cylinder(h=Switch_thk*2,d=Screw);
	}
}
////////////////////////////////////////////////////////////////////////////////

module mount(Screw=screw4) {
	difference() {
		color("cyan") cubeX([22,HolderWidth,Switch_thk2],1);
		 color("red") hull() {
			translate([10,5,-1]) cylinder(h=Switch_thk*2,d=Screw);
			translate([10,8,-1]) cylinder(h=Switch_thk*2,d=Screw);
		}
		color("blue") hull() {
			translate([12,26.5,-1]) color("blue") cylinder(h=Switch_thk*2,d=Screw);
			translate([8,26.5,-1]) color("blue") cylinder(h=Switch_thk*2,d=Screw);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
module base(Sep,DiagOffset,Offset,Screw,Adjust) {
	difference() {
		translate([-22-Adjust,0,0]) color("yellow") cubeX([Switch_ht+Adjust+5,HolderWidth,Switch_thk],1);
		// screw holes for switch
		translate([-(Switch_ht-Offset),SwitchShift,-1]) color("purple") cylinder(h = 11, d = Screw, $fn=100);
		translate(v = [-(Switch_ht-Offset)+DiagOffset,SwitchShift+Sep,-1]) color("black") cylinder(h = 11, d = Screw, $fn=100);
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

module strikeX(Screw=screw5,DoTab=1) {	// used on y a-xis
	difference() {	
		color("cyan") cubeX([9,84,9],2);
		translate([-5,58,4.5]) mount2040(Screw);
	}
	translate([0,0,0]) color("black") cubeX([35,10,9],2);
	if(DoTab) {
		translate([33,5,0]) color("green") cylinder(h=LayerThickness,d=20);
		translate([4,5,0]) color("red") cylinder(h=LayerThickness,d=20);
		translate([4,80,0]) color("plum") cylinder(h=LayerThickness,d=20);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////

module mount2040(Screw=screw5) {
	translate([0,0,0]) rotate([0,90,0]) color("red") cylinder(h=20,d=Screw);
	translate([0,20,0]) rotate([0,90,0]) color("blue") cylinder(h=20,d=Screw);
	if(Screw==screw5) {
		translate([1,0,0]) rotate([0,90,0]) color("blue") cylinder(h=5,d=screw5hd);
		translate([1,20,0]) rotate([0,90,0]) color("red") cylinder(h=5,d=screw5hd);
	}
}

////////////////////////////////////////////////////////////////////////////
