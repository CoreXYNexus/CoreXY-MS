///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// BeltAttachment.scad
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 8/2/2020
// Last Update: 8/2/20
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/2/20	- Added X endstop that mounts on the rail side of makerslide
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//=====================================================================================================
// 2020x460mm with the 400mm MGN12 are to be connected to the middle and upper 2020 on the M-Max
//=====================================================================================================
include <CoreXY-MSv1-h.scad>
Use3mmInsert=1;
Use5mmInsert=1;
include <brassfunctions.scad>
include <inc/screwsizes.scad>
use <Z-Motor_Leadscrew-Coupler.scad> // coupler(motorShaftDiameter = 5,threadedRodDiameter = 5)
include <inc/NEMA17.scad>
include <inc/cubeX.scad>
use <yBeltClamp.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Thickness=8;
LayerThickness=0.3;
Nozzle=0.4;
//---------------------------------------------
Switch_ht=20;	// height of holder
Switch_thk=5;	// thickness of holder
Switch_thk2=7;	// thickness of spacer
HolderWidth=33;	// width of holder
SwitchShift=6;	// move switch mounting holes along width
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

BeltAttachment();
//XEndStopOnly(1,1);	// 1st arg: 0=CN0097, 1=Black microswicth, 2=no endstop; 2nd arg: mounting slot on makerslide
					//																  0-bottom, 1-top, 2-none

module XEndsAndEndstop(Type=0,EndStopType=0) {
	XEnd(Type); // 1st arg: TR8=0, MTSS=1
	translate([100,0,0]) mirror([1,0,0]) XEnd(Type);
	XEndStopOnly(EndStopType);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XEndStopOnly(EndStopType=0,Side=0) {
	if(EndStopType==0) XEndStop(22,10,8,Yes3mmInsert(),8,Side);
	else if(EndStopType==1) XEndStop(10,0,8,screw2,8,Side); // black microswitch inline mount
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module XEndStop(Sep,DiagOffset,Offset,ScrewS,Adjust,Side) {
	EndStopBase(Sep,DiagOffset,Offset,ScrewS,Adjust);
	EndStopMount(screw5,Side);
}

////////////////////////////////////////////////////////////////////////////////

module EndStopMount(Screw=screw5,Side=0) {
	difference() {
		union() {
			color("cyan") cubeX([22,HolderWidth,Switch_thk2],1);
			if(Side==0) translate([Screw/2-3,23,Switch_thk2-1]) color("red") cubeX([22,6,2],1); // slot align
			if(Side==1) translate([Screw/2-3,3,Switch_thk2-1]) color("blue") cubeX([22,6,2],1); // slot align
		}
		translate([10,6,-1])  color("red") cylinder(h=Switch_thk2*2,d=Screw);
		translate([10,26,-1])  color("green") cylinder(h=Switch_thk2*2,d=Screw);
	}
}

///////////////////////////////////////////////////////////////////////////////
module EndStopBase(Sep,DiagOffset,Offset,ScrewT,Adjust) {
	rotate([0,-90,0]) difference() {
		difference() {
			translate([0,0,-4]) color("yellow") cubeX([Switch_thk,HolderWidth,Switch_ht+Offset-Adjust],1);
			// screw holes for switch
			rotate([0,90,0]) {		
				translate([-(Switch_ht-Offset)-0.5, SwitchShift, -1]) {
					color("purple") cylinder(h = 11, r = ScrewT/2, center = false, $fn=100);
				}
			}
			rotate([0,90,0]) {
				translate(v = [-(Switch_ht-Offset)-0.5+DiagOffset, SwitchShift+Sep, -1]) {
					color("black") cylinder(h = 11, r = ScrewT/2, center = false, $fn=100);
				}
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltAttachment() { // must print on side with supports from bed only
	//%translate([-50,-70,-23]) cube([200,200,3]);
	CarriageMount();
	BeltMount();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module CarriageMount() {
	rotate([180,0,0]) {
		difference() {
			color("cyan") cubeX([55,49.3,20],2);
			translate([8,-2,-1]) color("plum") cubeX([40,53,11],1);
			translate([14,3.5,0]) TopMountBeltHoles(screw3);
			translate([14,45.5,0]) TopMountBeltHoles(screw3);
			translate([14,3.5,14]) TopMountBeltHoles(screw3hd);
			translate([14,45.5,14]) TopMountBeltHoles(screw3hd);
			translate([-35,26,14.5]) color("red") rotate([0,90,0]) cylinder(h=130,d=Yes5mmInsert());
			color("red") hull() { // plastic reduction
				translate([23,24.75,-2]) cylinder(h=25,d=28);
				translate([33,24.75,-2]) cylinder(h=25,d=28);
			}
		}
		translate([8,1,13.7]) color("black") cube([40,10,LayerThickness]);
		translate([8,39,13.7]) color("white") cube([40,10,LayerThickness]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltMount() {
	translate([0,20,14]) rotate([-90,0,0]) {
		difference() {
			translate([0,17,0]) {
				translate([-3,0,0]) Loop1();
				translate([3,0,0]) Loop2();
			}
			translate([-35,26,14.5]) color("red") rotate([0,90,0]) cylinder(h=130,d=screw5);//Yes5mmInsert);
		}
		translate([-22.25,17,20]) color("gray") cubeX([100.25,17,8],2);
		difference() {
			translate([-22.25,17,16]) color("green") cubeX([22,17,8],2);
			translate([-35,26,14.5]) color("red") rotate([0,90,0]) cylinder(h=130,d=screw5);//Yes5mmInsert);
		}
		difference() {
			translate([55,17,16]) color("khaki") cubeX([23,17,8],2);
			translate([-35,26,14.5]) color("red") rotate([0,90,0]) cylinder(h=130,d=screw5);//Yes5mmInsert);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module BeltAttachmentV1() { // must print on side with supports from bed only
	translate([0,0,49.3]) rotate([-90,0,0]) {
		difference() {
			color("cyan") cubeX([55,49.3,20],2);
			translate([8,-2,-1]) color("plum") cubeX([40,53,11],1);
			translate([14,3.5,0]) TopMountBeltHoles(screw3);
			translate([14,45.5,0]) TopMountBeltHoles(screw3);
			translate([14,3.5,14]) TopMountBeltHoles(screw3hd);
			translate([14,45.5,14]) TopMountBeltHoles(screw3hd);
			color("red") hull() { // plastic reduction
				translate([23,24.75,-2]) cylinder(h=25,d=28);
				translate([33,24.75,-2]) cylinder(h=25,d=28);
			}
		}
		translate([0,17,0]) {
			Loop1();
			Loop2();
		}
	}
	// Loop1 side support
	translate([-17.5,-7,0]) color("black") cube([Nozzle,25.5,19]); // end support
	translate([-17-Nozzle,-7,0]) color("lightgray") cube([19,Nozzle,19]); // bottom support
	translate([-17.5-Nozzle,5,0]) color("green") cube([19,Nozzle,19]); // bottom support
	translate([-17.5,18.5-Nozzle,0]) color("purple") cube([19,Nozzle,19]); // top support
	translate([1,-7,0]) color("plum") cube([Nozzle,8,19]); // end support
	// Loop2 side support
	translate([73,-4,0]) color("black") cube([Nozzle,23,19]); // end support
	translate([53.5,-4,0]) color("lightgray") cube([20,Nozzle,19]); // bottom support
	translate([53.5,7,0]) color("red") cube([19,Nozzle,19]); // bottom support
	translate([53.5,18+Nozzle,0]) color("purple") cube([20,Nozzle,19]); // top support
	translate([53.5,-4,0]) color("plum") cube([Nozzle,9,19]); // end support
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Loop1() {
	translate([0,0,35]) rotate([-90,0,0]) {
		difference() {
			translate([-19.25,15,0]) color("plum") cubeX([22,28,17],2);
			translate([-20,31,0]) beltLoop();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module Loop2() {
	translate([0,0,35]) rotate([90,0,0]) {
		difference() {
			translate([52,-41,-17]) color("white") cubeX([23,28,17],2);
			translate([75,-27,-12]) rotate([0,0,180]) beltLoop();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TopMountBeltHoles(Screw=Yes3mmInsert()) {
	color("red") cylinder(h = GetHoleLen3mm(Screw), d = Screw);
	color("blue") hull() {
		translate([26,0,0]) cylinder(h = GetHoleLen3mm(Screw), d = Screw);
		translate([28,0,0]) cylinder(h = GetHoleLen3mm(Screw), d = Screw);
	}
}

///////////////////// end of mgn.scad ////////////////////////////////////////////////////////////////////////////