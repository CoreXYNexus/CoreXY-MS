/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FanDuct_v4.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created 1/5/2020
// last upate 1/15/20
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/5/20	- Created a compact fan duct, using a 5150 blower
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <inc/functions.scad>
use </inc/cubex.scad>
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
clearance=0.10;
WallThickness=1;
TotalOffset=25;
ClearOffset=5;
Long=55;
FrameX=60;
FrameY=63;
SpacerX=FrameX;
SpacerY=screw3hd+2;
FrameThickness=4;
BoltUpperX=33;
BoltUpperY=48;
BoltLowerX=7;
BoltLowerY=19;
BlowerAdjust=25;
BlowerOffset=-FrameX+BlowerAdjust;
BlowerInlet=37;
BlowerCurveAdjust=0;
CoolerPipesAdjust=20;
TubeDiameter=3.5; // diameter size of aluminum tube used
TubeLength=20; // length of AL tube
TubeSep=25; // separation distnce of the tubes
MountSpacing = 47;
FanMountSpacing=55;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//FanFrame();
//FanDuct(3);  // assembled version, arg is spacer thickness
Assembly(3,0); // printable version, 1st arg is spacer thickness;
								//	 2nd is to print spacer?, 3rd is to print Fan Frame? (both default to yes)
//Spacer(3);   // arg is spacer thickness

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuctOnly() {
	Fan_Mount();
	DuctCurve();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanDuct(Thick=3) { // assembled version, arg is spacer thickness
	FanFrame();
	translate([0,-0.3,-2]) {
		Fan_Mount();
		DuctCurve();
	}
	translate([-4,0,0]) rotate([0,0,0]) Spacer(Thick);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Assembly(Thick=3,Spaced=1,Frame=1) {
	if(Frame) rotate([0,90,0]) FanFrame();
	translate([-30,0,21]) FanDuctOnly();
	if(Spaced) translate([-2,0,4]) rotate([0,-90,0]) Spacer(Thick);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Spacer(Thick=3) {
	difference() {
		translate([-FrameThickness,-28,0])
			color("red") cubeX([FrameThickness,SpacerX,SpacerY],1);
		translate([-5,MountSpacing/2+2,3]) rotate([0,90,0]) color("gold") cylinder(h=FrameThickness+5,d=screw3);
		translate([-5,-MountSpacing/2+2,3]) rotate([0,90,0]) color("cyan") cylinder(h=FrameThickness+5,d=screw3);
		//DuctScrewMount();
		translate([9,0,0]) DuctScrewMountCounter();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Fan_Mount() {
	//echo(parent_module(0));
	translate([0,BlowerCurveAdjust,0]) difference() {
		color("plum") cube([15.2+(WallThickness+clearance)*2,20+(WallThickness+clearance)*2,9]);
		translate([WallThickness,WallThickness,-1]) color("blue") cube([15.2+(clearance)*2,20+(clearance)*2,12]);
		translate([0,0.2,2])DuctScrewMount();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DuctScrewMount() {
	translate([-5,MountSpacing/2-6,3]) rotate([0,90,0]) color("lightblue") cylinder(h=FrameThickness+5,d=screw3);
	translate([-5,MountSpacing/2-19,3]) rotate([0,90,0]) color("lightgray") cylinder(h=FrameThickness+5,d=screw3);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DuctScrewMountCounter() {
	translate([0,BlowerCurveAdjust,0]) {
		translate([-10,MountSpacing/2-6,3]) rotate([0,90,0]) color("lightblue") cylinder(h=	FrameThickness+5,d=screw3hd);
		translate([-10,MountSpacing/2-19,3]) rotate([0,90,0]) color("lightgray") cylinder(h=FrameThickness+5,d=screw3hd);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanFrame() {
	difference() {
		translate([-FrameThickness,-28,0])
			color("red") cubeX([FrameThickness,FrameX,FrameY],1);
		translate([-5,MountSpacing/2+2,3]) rotate([0,90,0]) color("gold") cylinder(h=FrameThickness+5,d=screw3);
		translate([-5,-MountSpacing/2+2,3]) rotate([0,90,0]) color("cyan") cylinder(h=FrameThickness+5,d=screw3);
		// 5150 mount holes
		translate([-1,BlowerOffset+22,50]) rotate([-45,0,0]) {
			translate([-FrameThickness-2,0,0]) color("blue") rotate([0,90,0]) cylinder(h=10,d=screw4);
			translate([-FrameThickness-2,FanMountSpacing,0]) color("pink") rotate([0,90,0]) cylinder(h=10,d=screw4);
		}
		// plastic reduction or fan inlet, if needed
		translate([-FrameThickness-2,(-BoltUpperX+BlowerAdjust)/2+11,BoltUpperY/2+4])
			color("gray") rotate([0,90,0]) cylinder(h=10,d=BlowerInlet);
		translate([0,BlowerCurveAdjust,0]) DuctScrewMount();
		DuctScrewMountCounter();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DuctCurve(){
	translate([0,BlowerCurveAdjust+1,0]) difference() {
		// outer
		translate([8+WallThickness+clearance,20+(WallThickness+clearance)*2-clearance/2,0]) color("gray") hull() {
			translate([-9.4,-23,0]) // upper
				cube([16+(WallThickness+clearance)*2-0.5,19+(WallThickness+clearance)*2,1]);
			translate([-9+clearance,-CoolerPipesAdjust,-TotalOffset+ClearOffset]) // rotate([90,0,0]) // lower
				cubeX([15+(WallThickness+clearance)*2,26+(WallThickness+clearance)*2,3],2);
		}
		// top of duct cutoff
		translate([0,-11,0.5]) color("darkgray") cube([20,40,11]);
		// tube holes
		translate([-10,CoolerPipesAdjust-14,-TotalOffset+8]) {
			translate([0,0,0]) rotate([0,90,0]) color("blue") cylinder(h=TubeLength, d=TubeDiameter);
			translate([0,TubeSep-6,0]) rotate([0,90,0]) color("yellow") cylinder(h=TubeLength, d=TubeDiameter);
		}
		//inner
		translate([8+WallThickness+clearance,20+(WallThickness+clearance)*2-clearance/2,0]) color("gold") hull() {
			translate([-7.5,-21,0]) // upper
				cube([13.4+(WallThickness-clearance)*2,16+(WallThickness-clearance)*2,3]);
			translate([-6,-CoolerPipesAdjust+1,-TotalOffset+ClearOffset+1]) // lower
				cubeX([15-(WallThickness+clearance)*2,27-(WallThickness+clearance)*2,2],1);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
