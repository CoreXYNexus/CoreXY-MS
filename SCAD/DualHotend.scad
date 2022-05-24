//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// DualHotend.scad
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created: 4/10/2020
// last update: 5/15/22
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 4/13/22	- Added 5150 fan mount adapter and BerdAir mount
// 4/16/22	- Added countersinks to BAClamp(), adjusted berd aid mount
// 4/21/22	- Added drive mount for bowden extruder assembly
// 4/28/22	- Added Chimera mount
// 5/14/22	- Removed BigTree dual hotend
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ChimeraMount() for an E3D Chimera
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/brassinserts.scad>
include <bosl2/std.scad>
use <inc/nema17.scad>
use <SensorMounts.scad>
use <FanAdapters.scad>
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Use4mmInsert=1;
Use3mmInsert=1;
Use2p5mmInsert=1;
MountOffset=24;
HotendMountWidth=30;
HotendMountHeight=14;
EXOSlideMountOffset=20;
HEMountThickness=10;
BLTouchMountHeight=45.7;
HotendHeight=52.5; // Chimera: 52.5 (not actual)
BLTouchOffset=HotendHeight-BLTouchMountHeight;
40mmFanDiameter=40;
30mmFanDiameter=30;
LayerThickness=0.3;
BAClampLength=16;
DriveMountSize=55;
StepperSize=42;
StepperMountThickness=2;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ChimeraMount(0,0);
//translate([0,70,DriveMountSize/2-4.4])
//	BowdenDriveMount(2);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ChimeraMount(BerdAirClamp=1,DoFan=1,PipeSize=2,DoTab=1) {
	rotate([-90,0,0]) EXOChimeraMounting(PipeSize);
	if(DoTab) {
		translate([37,45,-6.75]) color("red") cyl(h=LayerThickness,d=10);
		translate([-37,45,-6.75]) color("blue") cyl(h=LayerThickness,d=10);
	}
	if(BerdAirClamp) {
		translate([30,-22,-6.9]) BAClamp(PipeSize,DoTab);
		translate([60,-22,-6.9]) BAClamp(PipeSize,DoTab);
	}
	translate([0,22.5,12.1])
		rotate([-90,0,0]) ChimeraMountingPlate();
	if(DoFan) translate([0,45,-1.9]) Fan5150Mount(30mmFanDiameter); // in FanAdapters.scad
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ChimeraMountingPlate() {
	difference() {
		color("cyan") cuboid([30,38,5],rounding=2);
		translate([-4.5,-5,1]) ChimeraMountingHoles();
		translate([EXOSlideMountOffset*2.5,12,-20]) rotate([0,0,90]) EXOMount(0);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ChimeraMountingHoles(Screw=screw3,ScrewHD=screw3hd) {
	color("purple") cyl(h=20,d=Screw);
	translate([9,0,0]) color("red") cyl(h=20,d=Screw);
	translate([4.5,-10,0]) color("blue") cyl(h=20,d=Screw);
	translate([0,0,-5]) {
		color("blue") cyl(h=5,d=ScrewHD);
		translate([9,0,0]) color("purple") cyl(h=5,d=ScrewHD);
		translate([4.5,-10,0]) color("red") cyl(h=5,d=ScrewHD);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PlateMountingHoles(Screw=screw3,ScrewHD=screw3hd) {
	translate([0,0,0]) color("gray") cyl(h=50,d=Screw);
	translate([20,0,0]) color("lightgray") cyl(h=50,d=Screw);
	translate([0,0,-10]) color("gray") cyl(h=5,d=ScrewHD);
	translate([20,0,-10]) color("lightgray") cyl(h=5,d=ScrewHD);
	translate([10,0,3]) rotate([90,0,0]) color("gray") cyl(h=50,d=Screw);
	translate([10,-12,3]) rotate([90,0,0]) color("gold") cyl(h=5,d=ScrewHD);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EXOChimeraMounting(PipeSize=2) {
	difference() {
		union() {
			translate([-(EXOSlideMountOffset+56)/2,0,0]) color("pink") hull() {
				cyl(h=15,d=screw4*3,rounding=2);
				translate([EXOSlideMountOffset+56,0,0]) cyl(h=15,d=screw4*3,rounding=2);
			}
			difference() {
				translate([-12.5,0,(15+10)/2]) color("khaki") hull() {
					cyl(h=15+10,d=screw4*3,rounding=2);
					translate([25,0,0]) cyl(h=15+10,d=screw4*3,rounding=2);
				}
			}
		}
		translate([0,-5,-12]) rotate([90,0,0])  BLTouch_Holes(2,Yes2p5mmInsert(Use2p5mmInsert));
		translate([EXOSlideMountOffset*2.5,0,-7]) rotate([0,0,90]) EXOMount(0);
	}
	%translate([5.5,-BLTouchOffset-5.9,5]) cube([5,BLTouchOffset,15]); // Needs adjustment if HotendHeight is changed
	translate([0,-7.7,4]) ChimeraBLT();
	translate([-37,0,-3]) ChimeraBerdAirMount(PipeSize);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ChimeraBerdAirMount(PipeSize=2) {
	difference() {
		union() {
			translate([0,0,50/2]) color("lightgray") cuboid([6,screw4*3,50],rounding=2);
			translate([74,0,50/2]) color("gray") cuboid([6,screw4*3,50],rounding=2);
		}
		translate([-10,0,40]) rotate([90,0,0]) BAClampScrews();
		translate([40,0,40]) rotate([90,0,0]) BAClampScrews();
		translate([EXOSlideMountOffset*4+7,0,0]) rotate([0,0,90]) EXOMount(0);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ChimeraBLT() {
	difference() {
		color("green") cuboid([28,10,15],rounding=2);
		translate([0,5,-16]) rotate([90,0,0]) BLTouch_Holes(2,Yes2p5mmInsert(Use2p5mmInsert));
		translate([EXOSlideMountOffset*2.5,8.6,-10]) rotate([0,0,90]) EXOMount(0);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BowdenDriveMount(Qty=1,ShowStepper=0) {
	for(x=[0:Qty-1]) {
		translate([0,x*30,0]) difference() {
			union() {
				ShowStepper(ShowStepper);
				translate([0,0,0]) color("cyan") cuboid([DriveMountSize,StepperMountThickness,DriveMountSize],rounding=1);
				translate([0,9,-DriveMountSize/2]) color("red") cuboid([DriveMountSize+35,20,5],rounding=2);
				BowdenSupports();
			}
			translate([0,4,0]) rotate([90,45,0]) color("gray") NEMA17_x_holes(8,1);
			translate([-DriveMountSize/2-9,9,-DriveMountSize/2]) color("blue") cyl(h=10,d=screw5);
			translate([-DriveMountSize/2-9,9,-DriveMountSize/2+6]) color("pink") cyl(h=10,d=screw5hd);
			translate([DriveMountSize/2+9,9,-DriveMountSize/2]) color("pink") cyl(h=10,d=screw5);
			translate([DriveMountSize/2+9,9,-DriveMountSize/2+6]) color("blue") cyl(h=10,d=screw5hd);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ShowStepper(Show=0) {
	if(Show) %translate([-StepperSize/2,0,-StepperSize/2]) cube([StepperSize,StepperSize,StepperSize]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BowdenSupports() {
	translate([-DriveMountSize/2+2,1,0]) color("green") hull() {
		translate([0,8,-DriveMountSize/2]) cuboid([5,20,5],rounding=2);
		translate([0,-1,DriveMountSize/2-2.5]) cuboid([5,StepperMountThickness,5],rounding=1);
	}
	translate([DriveMountSize/2-2,1,0]) color("purple") hull() {
		translate([0,8,-DriveMountSize/2]) cuboid([5,20,5],rounding=2);
		translate([0,-1,DriveMountSize/2-2.5]) cuboid([5,StepperMountThickness,5],rounding=1);
	}
	translate([0,0,DriveMountSize/2-2]) rotate([0,90,0]) color("pink") cyl(h=DriveMountSize,d=4,rounding=2);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BAClamp(PipeSize=2,DoTab=1) {
	translate([-39,0,32]) rotate([0,-90,0]) { // remove to test fit
		difference() { // clamp
			union() {
				translate([-32,-BAClampLength/2,0]) color("green") cuboid([5,BAClampLength,8],rounding=1,p1=[0,0]);
				if(DoTab) translate([-32,0,4]) color("red")  rotate([0,90,0]) cylinder(h=LayerThickness,d=25);
			}
			translate([-43,0,4.25]) BAClampScrews(screw3);
			translate([-27,0,-5]) color("gray") cylinder(h=20,d=PipeSize);
			translate([-32,4,4]) color("white") rotate([0,90,0]) cyl(h=5,d1=9,d2=2);
			translate([-32,-4,4]) color("red") rotate([0,90,0]) cyl(h=5,d1=9,d2=2);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BAClampScrews(Screw=Yes3mmInsert(Use3mmInsert)) {
	translate([0,-4,0]) color("blue") rotate([0,90,0]) cylinder(h=40,d=Screw);
	translate([0,4,0]) color("khaki") rotate([0,90,0]) cylinder(h=40,d=Screw);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTMount(MountHeight=15) {
	%translate([6.5,-2.5,5]) cube([BLTouchOffset,5,10]); // show top position of BLT mount
	difference() {
		translate([10,0,MountHeight/4]) color("gold") cuboid([HotendMountHeight-2,HotendMountWidth,MountHeight],rounding=2);
		translate([10,0,-9]) rotate([0,90,0]) rotate([0,0,90]) BLTouch_Holes(2,Yes2p5mmInsert(Use2p5mmInsert));
		translate([0,-30,0]) EXOMount();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Base(MountScrew=Yes3mmInsert(Use3mmInsert)) {
	difference() {
		color("cyan") cuboid([HotendMountHeight,HotendMountWidth*2.5,HEMountThickness],rounding=2);
		translate([0,-HotendMountWidth/2+3,0]) HotendMountHoles(MountScrew);
		translate([0,-30,0]) EXOMount();
		translate([0,0,-9]) rotate([0,90,0]) rotate([0,0,90]) BLTouch_Holes(2,Yes2p5mmInsert(Use2p5mmInsert));
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EXOMount(NoCenterTwo=1) {
	color("purple") hull() {
		translate([0,1*EXOSlideMountOffset+1,0]) cyl(h=20,d=screw4); // screw 5 for some wiggle room
		translate([0,1*EXOSlideMountOffset-1,0]) cyl(h=20,d=screw4); // screw 5 for some wiggle room
	}
	if(!NoCenterTwo) {
		color("blue") hull() {
			translate([0,2*EXOSlideMountOffset-1,0]) cyl(h=20,d=screw4,rounding2=2);
			translate([0,2*EXOSlideMountOffset+1,0]) cyl(h=20,d=screw4,rounding2=2);
		}
		translate([0,3*EXOSlideMountOffset,0]) color("lightgray") cyl(h=20,d=screw4,rounding2=2);
	}
	color("green") hull() {
		translate([0,4*EXOSlideMountOffset+1,0]) cyl(h=20,d=screw4,rounding2=2);
		translate([0,4*EXOSlideMountOffset-1,0]) cyl(h=20,d=screw4,rounding2=2);
	}
	color("khaki") hull() {
		translate([0,1*EXOSlideMountOffset+1,HEMountThickness+15]) cyl(h=45,d=screw4hd,rounding2=2);
		translate([0,1*EXOSlideMountOffset-1,HEMountThickness+15]) cyl(h=45,d=screw4hd,rounding2=2);
	}
	if(!NoCenterTwo) {
		color("red") hull() {
			translate([0,2*EXOSlideMountOffset+1,HEMountThickness+15]) cyl(h=45,d=screw4hd,rounding2=2);
			translate([0,2*EXOSlideMountOffset-1,HEMountThickness+15]) cyl(h=45,d=screw4hd,rounding2=2);
		}
		translate([0,3*EXOSlideMountOffset,HEMountThickness+15]) color("pink") cyl(h=45,d=screw4hd,rounding2=2);
	}
	color("plum") hull() {
		translate([0,4*EXOSlideMountOffset+1,HEMountThickness+15]) cyl(h=45,d=screw4hd,rounding2=2);
		translate([0,4*EXOSlideMountOffset-1,HEMountThickness+15]) cyl(h=45,d=screw4hd,rounding2=2);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HotendMountHoles(Screw=Yes3mmInsert(Use3mmInsert)) {
	color("purple") cyl(h=25,d=Screw);
	translate([0,MountOffset,0]) color("gray") cyl(h=25,d=Screw);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
