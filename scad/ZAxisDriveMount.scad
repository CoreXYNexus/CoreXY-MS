/////////////////////////////////////////////////////////////////////////////////////////////////////////
// CoreXY-Z-Axis-Drive.scad --  z-axis motor mount for corexy makerslide
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 3/2/2013
// Last Update: 12/30/21
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 6/28/16	- modified z-axis_motor_mount.scad from Makerslide Mendel printer for corexy z
// 7/3/16	- added assembly info
// 7/4/16	- added flange nut style and testnut() to print only znut section for testing
// 7/27/16	- cleaned up code and added test prints
//			  changed znut to inside mount, added notches for makerslide
//			  spruced up the side supports
// 8/21/16	- Added belt drive version
// 8/23/16	- GT2 40t pulleys arrived, adjusted spacer Thickness and motor mount height
// 11/5/16	- Added idler bearing to the z axis bearing mounts, so that the belt would wrap around more
//			  Didn't bother to make left/right versions
// 1/29/17	- Removed bed pivots from here and made a new file: bearing_pivots.scad
// 1/31/17	- Added plates to mount makerslide instead of drilling access holes & threading the makerslide
//			  Made z leadscrew bearing mount outside larger for better strength
// 2/4/17	- Added AddOffset to OneZNutBracket() for z-axis rail, changed to a single idler mount on
//			  BearingMount()
// 2/5/17	- Added a spacer block for the 3rd z-axis makerslide bearing/motor mount
// 7/9/18	- Added use of coreer-tools.scad to round over bearing holder
//			  added bearing_ider() to all()
// 7/13/18	- Made plates to fit a 200x200 bed
// 8/19/18	- OpenSCAD 2018.06.01 for $preview
// 12/20/18	- Removed redundant modules and added for loops for quanities
// 2/2/19	- Adjusted notches on motor mount. Fixed colors in SideSupport().
// 2/3/19	- Changed NEMA17 holes to a set motor position, ShaftOffset is now taken into account with z_shift
//			  Now using OPENSCAD version 2019.01.24.ci1256 (git 7fa2c8f1)
//			  Added M3 version to ZAxisMountPlates()
// 4/27/19	- Added a belt drive version of the direct drive mount in direct_BeltDrivenZAxis()
// 12/8/19	- Added ReductionMotorMount() for using a belt to drive each z axis leadscrew
// 10/19/20	- Added use of M5 & M3 brass inserts
// 10/22/20	- Changed modules names and cleaned up the main modules
// 11/5/20	- Added ZMotorThrustSpacer() to use M5 thrust brearings under the coupler
// 12/15/20	- Redid the braces on the motor_mount() and added countersinks for M5 screws
// 4/8/21	- BeltdriveMotorMount() is a separate printable item
// 4/14/21	- Added DirectBeltDrive() where the motor drive the leadscrew via a belt and it mounts with the leadscrew
// 12/26/21	- Direct belt drive for 20:40 with 2GT-200 belt; renamed modules and vars
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
use <inc/nema17.scad>	// https://github.com/mtu-most/most-scad-libraries
include <bosl2/std.scad>
use <ZMotorLeadscrewCoupler.scad>
$fn=100;
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Multi-motor z for bed leveling.  Makerslide carriage mount: two 525z bearings, M5 screw & nut,
// washer in between, four m5 screws.  The center pivot uses two 625z bearings, three M5 screws & nuts.
// 2040 mount uses four M5 screws & nuts to mount on the 2040. Uses two 2040 connected together in a
// T shape. Use either direct or belt drive mounts for each leadscrew.  The two makerslides opposite
// each other must be more to the side, not centered, and the third in the center.  The bed is to be
// solidly mounted, but allow heat expansion.
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Most modules have parameters, see them for info
//-----------------------------------------------------------------------------------------------------
// Uses M3x6 screws & washers for the stepper motor
// Uses M5x6 screws & t-nuts for mounting to makerslide & extrusion and uses a #### belt
//-----------------------------------------------------------------------------------------------------
// For the belt version, you move the stepper motor mount to tension belt
// Uses one 40 tooth GT2 belt pulley, 1 608 bearing, 2 washers, one LockRing
// on each z axis leadscrew.  Each bearing mount uses two F625Z, M5x30, M5 nut on the side
// that makes the belt wrap around the most on the pulley (it'll be the side the stepper motor is on)
// Idler uses a total of 4 F625Z bearings, 2 M5 washers, 2 M5 screws & nuts, 2 printed spacers
// Each idler stack from bottom: printed spacer,washer,f625z,f625z,washer,idler plate,nut
// Each leadscrew 608 has a washer on each side
// Washers used are 1/32" (~0.75mm) thick precision washers
// Motor uses a 20 tooth GT2 pulley (2:1 ratio to the leadscrews)
// After printing belt version, clean out the support in the screw & bearing holes
// If the motor gets hot, then the mount needs to printed with PETG or better
///////////////////////////////////////////////////////////////////////////////////////////////////////
Use3mmInsert=1;
Use5mmInsert=1;
//-----------------------------------------------------------------------------------------------------------
ShaftOffset = 11;		// adjust center of stepper motor or bearing mount
CheckMotorPosition = false; // something to help set the motor postion
BaseOffset = 5.5;		// shift base
BWidth = 55;			// base width
BLength = 48.5 + ShaftOffset;	// base length
Thickness = 5; 			// thickness of everything
MHeight = 40;			// mount wall height
MSNotchDepth = 2.5;	// depth of the notch for makerslide
MSNotchOffset = 21;	// where to put the notch
//-----------------------------------------------------------------------
//HoleOffset = 140;			// mounting holes on makerslide carriage plate
OutsideD = 155;		// overall length
ThicknessZ = 15;		// actually the width
Shift1 = 4;				// amount to shift mounting columns up/down
Raise = 30 + Shift1;	// zrod distance from the carriage plate
Clearance = 0.7;		// allow threaded rod to slide without problem
ZRodTDiamater = 5 + Clearance;	// z rod thread size
ZNutDiameter = 9.5;			// diameter of z rod nut (point to point + a little)
ZHeight = ZRodTDiamater +5 - Clearance;	// height is for zrod nut
ZShift = ShaftOffset+7;			// move the zrod hole
ZAdjust = 9.5;			// move inner cylinder hull to make connection to bar
ZNutDepth = 3.5; 		// how deep to make the nut hole
// Sizes below are for a TR8 flanged nut
//FlangeScrew = 4;		// screw hole
FlangeNutDiameter = 10.7;		// threaded section outside diameter
FlangeNutOutsideDiameter = 22.5;	// flange outside diameter
FlangeNutScrewOffset	= 16.5;		// flange nut distance of opposite screw holes
TR8Diameter = 8+Clearance;	// diameter of TR8
//-----------------------------------------------------------------------
Diameter608 = 22+Clearance;		// outside diameter of a 608
Height608 = 7; 					// thickness of a 608
NutClearance = 17;			// Clearance for a 8mm nut
DiameterF625Z = 18;				// f625z flange diameter
ShiftBeltMotor = 0; 				// move belt motor mount up/down (- shifts it up)
GT2ClampThickness = 6.1;			// thickness of the clamping part on the 40 tooth GT2 pulley
idler_spacer_Thickness = GT2ClampThickness + 0.9;	// thickness of idler bearing spacer
ThrustWasherThickness=4;
LayerThickness=0.3;
BearingHoleClearance=19;
StepperBossDiameter=23; // 22 plus some clearance
BrassInsertLength=6; // for M3 insert
////////////////////////////////////////////////////////////////////////////

//DirectDriveZAxis(3,1,1,1,5,8); 	// Z axis for bed leveling
			// 1st: Quantiy; 2nd: plates; 3rd: printable couplers; 4th ZNut ;5th: motor shaft diameter; 6th: leadscrew diameter
//ReductionMotorMount(1);
//BeltDrivenZAxis(3); // arg is quanity, includes drive motor mount
//BeltDrivenZAxisMotorMount(1,0);
// also need the following with BeltDrivenZAxis(), since a 200x200 build plate isn't big enough
//ZNutBracket(3,2.1,1); // arg is quanity, arg 2 is offset adjust; arg 3 to add tabs for printing
//translate([50,20,0]) ZAxisMountPlates(3); // arg is quanity*2
//ZMotorThrustSpacer(3,7.5-ThrustWasherThickness); // to use M5 thrust brearings under the coupler
ZDirectBeltDrive(1);
//Collet(2);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Collet(Qty=1) {
	%translate([0,7.5,-5]) rotate([90,0,0]) cyl(h=BrassInsertLength,d=3); // show length of brass insert
	for(x=[0:Qty-1]) {
		translate([0,x*28,0]) {
			difference() {
				union() {
					translate([0,0,7]) color("cyan") cyl(h=Height608+2,d=screw8*2,rounding=2); // spacer
					color("blue") cyl(h=Yes3mmInsert(Use3mmInsert)*2,d=screw8*2.7,rounding=2); // holder
				}
				color("red") cyl(h=30,d=screw8+0.3); // center hole
				ColletScrews();
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ColletScrews(Screw=Yes3mmInsert(Use3mmInsert)) {
	translate([0,-7,0]) rotate([90,0,0]) color("white") cyl(h=20,d=Screw);
	translate([7,0,0]) rotate([90,0,90]) color("green") cyl(h=20,d=Screw);
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module ZDirectBeltDrive(Qty=1) {
	for(i = [0:Qty-1]) translate([0,65*i,0]) {
		difference() {
			union() {
				BeltDrivenZAxis(1,0); // arg is quanity, includes drive motor mount
				translate([23,27,-2.5]) color("red") cuboid([BWidth+30,BWidth+3,Thickness],rounding=2,p1=[0,0]);
				translate([23,26,-2.5]) color("green") cuboid([85,Thickness,40.5],rounding=2,p1=[0,0]);
			}	
			translate([76,60.5,-5]) color("white") NEMA17_parallel_holes(10,9,StepperBossDiameter);
			translate([45,33.5-Thickness,19]) rotate([90,0,0]) color("red")
				cyl(l=Thickness+0.5, r=13, rounding1=-2, rounding2=-2);
			translate([85,33.5-Thickness,19]) rotate([90,0,0]) color("red")
				cyl(l=Thickness+0.5, r=13, rounding1=-2, rounding2=-2);
			translate([40,61,0]) color("blue")
				cyl(h=Thickness+0.5, r=10, rounding1=-2, rounding2=-2);
		}
		difference() {
			translate([-BWidth+33-Thickness,-(BLength-85),32]) rotate([-30,0,0]) color("gray") // support
				cuboid([Thickness,BWidth+10,7],rounding=2,p1=[0,0]);
			translate([0,-7,40]) NotchForMakerSlide();
		}
		difference() {
			translate([-BWidth+80-Thickness,-(BLength-85),32]) rotate([-30,0,0]) color("lightgray") // support
				cuboid([Thickness,BWidth+12,7],rounding=2,p1=[0,0]);
			translate([0,-7,40]) NotchForMakerSlide();
		}
		translate([-BWidth+163-Thickness,-(BLength-85),32]) rotate([-30,0,0]) color("white") // support
			cuboid([Thickness,BWidth+12,7],rounding=2,p1=[0,0]);
		translate([-27.5,81.5,-2.5]) color("khaki") cuboid([135.4,Thickness,10],rounding=2,p1=[0,0]); // short wall
		translate([-42,50,0]) Collet(1);
	}
}

//////////////////////////////////////////////////////////////////////////////

module ZMotorThrustSpacer(Qty=1,Length=5) { // to use M5 thrust brearings under the coupler
	for(x= [0:Qty-1]) {
		translate([0,x*15,0]) difference() {
			color("cyan") cylinder(h=Length,d=10);
			translate([0,0,-2]) color("red") cylinder(h=Length+4,d=screw5);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DirectDriveZAxis(Quanity=1,Plates=0,ZNut=0,Coupler=1,Motorshaft=5,LeadScrewDiameter=8) { // set for makerslide
	if($preview) %translate([-100,-115,-2]) cube([200,200,2]);
	for(a=[0:Quanity-1]) {
		translate([a*65-65,0,Thickness/2+3]) MotorMount(1);
		if(Coupler) translate([a*65-65,14,0]) coupler(Motorshaft,LeadScrewDiameter); // printed coupler
		//translate([(a*65)-142,-50,0]) OneZNutBracket(); // one znut nut holder
	}
	if(ZNut) translate([-130,65,0.5]) ZNutBracket(3); // arg is number of znut holder; arg 2 is offset
	if(Plates) translate([60,-112,0]) rotate([0,0,90]) ZAxisMountPlates(3); // arg is quanity*2
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltDrivenZAxis(Quanity=1,Support=1) { // arg is quanity
	//if($preview) %translate([-40,-100,-4.5]) cube([200,200,2]);
	for(a=[0:Quanity-1]) {
		translate([a*60,50,0]) BearingMount(0,0,0,1,Support);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltDrivenZAxisMotorMount(Quanity=1,Idler=1) { // arg is quanity
	//if($preview) %translate([-60,-50,-4.5]) cube([200,200,2]);
	for(a=[0:Quanity-1]) {
		translate([a*60,50,0]) BeltStepperDriveMountZAxis(Idler);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltDrive(Quanity=1,ZNut=1) {
	if($preview) %translate([0,0,-5]) cube([200,200,2],center=true);
	// a motor driving leadscrew via a belt
	for(a=[0:Quanity-1]) {
		translate([a*65-65,0,0]) BearingMount(1); // bearing mount at bottom of z-axis leadscrew
		if(ZNut) translate([(a*65)-142,-50,0]) OneZNutBracket(); // znut holder
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltStepperDriveMountZAxis(Idler=1) {
	translate([-30,-30,0]) BeltMotor(Idler);	// one stepper motor mount with idler
	//translate([-30,-20,-2.5]) LockRing();	// something to hold leadscrew in bearing
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module MotorMount(makerslide=0) { // motor mount
	rotate([180,0,0]) {				// added a thrust bearing?
		NEMAPlate(,makerslide,1);
		mount(makerslide);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltMount(makerslide=0) { // motor mount
	rotate([180,0,0]) {
		NEMAPlate(0,1);
		mount(0);
		translate([50,0,2.5]) rotate([0,180,180]) BearingMount(0,0,0,0);

	}
}

////////////////////////////////////////////////////////////////////////////

module Mount(makerslide=0,Support=1) {
	difference() {
		translate([0,22,-18]) color("cyan") cuboid([BWidth,Thickness,MHeight],rounding=1);
		ScrewMounting(Screw=screw5);
		if(makerslide) NotchForMakerSlide();
	}
	if(Support) {
		SideSupport(Support);
		translate([-BWidth+Thickness,0,0]) SideSupport(Support); 
	}
	if(makerslide) { // inside support at ns notches
		translate([-5+MSNotchOffset,20-MSNotchDepth,-MHeight+3]) color("blue")
			cuboid([10,Thickness-1,MHeight-2],rounding=1,p1=[0,0]);
		translate([-48+MSNotchOffset,20-MSNotchDepth,-MHeight+3]) color("red")
			cuboid([10,Thickness-1,MHeight-2],rounding=1,p1=[0,0]);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module ScrewMounting(Screw=screw5) {
	translate([10,30,-10]) rotate([90,0,0]) color("red") cylinder(h=20,d=Screw); // top screw hole
	translate([10,30,-30]) rotate([90,0,0]) color("white") cylinder(h=20,d=Screw); // bottom screw hole
	translate([-10,30,-10]) rotate([90,0,0]) color("blue") cylinder(h=20,d=Screw);	// top screw hole
	translate([-10,30,-30]) rotate([90,0,0]) color("grey") cylinder(h=20,d=Screw);	// bottom screw hole
	if(Screw==screw5) {
		translate([10,20,-10]) rotate([90,0,0]) color("gray") cylinder(h=5,d=screw5hd); // top screw hole
		translate([10,20,-30]) rotate([90,0,0]) color("blue") cylinder(h=20,d=screw5hd); // bottom screw hole
		translate([-10,20,-10]) rotate([90,0,0]) color("white") cylinder(h=20,d=screw5hd);	// top screw hole
		translate([-10,20,-30]) rotate([90,0,0]) color("red") cylinder(h=20,d=screw5hd);	// bottom screw hole
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module NotchForMakerSlide() {
	translate([-8+MSNotchOffset,31-MSNotchDepth,5]) rotate([0,90,0]) SingleMakerSlideNotch();
	translate([-7.5-MSNotchOffset,31-MSNotchDepth,5]) rotate([0,90,0]) SingleMakerSlideNotch();
}
/////////////////////////////////////////////////////////////////////////////////////////

module SideSupport(MSupport=1,Support=1) {
	if(Support) {
		translate([BWidth/2-Thickness,-(BLength-26),-2.5]) rotate([-34,0,0]) color("gray")
			cuboid([Thickness,BWidth+10,7],rounding=2,p1=[0,0]);
		translate([BWidth/2-Thickness,-(BLength-58),-23]) rotate([40,0,0]) color("lightgray")
			cuboid([Thickness,BWidth-22,7],rounding=2,p1=[0,0]);
	}
}

////////////////////////////////////////////////////////////////////////////

module NEMAPlate(makerslide=0,HSlot=0) {
	echo(HSlot);
	difference() {
		translate([-27.5,-(ShaftOffset-BaseOffset)-29.5,-1]) color("red")
			cuboid([BWidth,BLength,Thickness+1],rounding=2,p1=[0,0]);
		if(HSlot)
			translate([0,-ShaftOffset,-3]) rotate([0,0,90]) color("white") NEMA17_parallel_holes(10,10);
		else
			translate([0,-ShaftOffset,-3]) rotate([0,0,90]) color("white") NEMA17_parallel_holes(10,0);
		if(makerslide) NotchForMakerSlide();
	}
	if(CheckMotorPosition) translate([12,24.5,3]) color("black") rotate([90,0,0])
			cylinder(h=51,d=screw5); // used to help set nema17 position, the 51 is measured off an actual print
}

////////////////////////////////////////////////////////////////////////////////////////

module SingleMakerSlideNotch() {
	rotate([45,0,0]) color("white") cube([100,10,10]);
}

///////////////////////////////////////////////////////////////////////////////////

module OneZNutBracket(AddOffset=0,DoTab=1) { // one z-nut mount
	translate([-50,0,ThicknessZ]) rotate([-90,0,0])	// all coordinates in modules are without this line
		ZNut(1,AddOffset);
	translate([2,5,0]) DoATab(DoTab);
	translate([53,5,0]) color("pink") DoATab(DoTab);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DoATab(DoTab=1) {
	if(DoTab) color("white") cylinder(h=LayerThickness,d=20);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZNutBracket(Qty=1,AddOffset=0,DoTab=1) { // arg is number of znut holder
	for(x = [0 : Qty-1]) translate([0,x*45,0]) OneZNutBracket(AddOffset,DoTab);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZNut(Type=0,AddOffset=0) {	// 0 = nut, 1 = TR8 leadscrew
	difference() {
		translate([OutsideD/3-1,0,0]) color("cyan") cuboid([OutsideD/3+2,ThicknessZ,ZHeight],rounding=2,p1=[0,0]);
		if(Use5mmInsert) {
			PlateMountHole2(0,Yes5mmInsert(Use5mmInsert));
			PlateMountHole2(1,Yes5mmInsert(Use5mmInsert));
		} else {
			PlateMountHole2(0,screw5);
			PlateMountHoleNut(0,nut5);
			PlateMountHole2(1,Yes5mmInsert(Use5mmInsert));
			PlateMountHoleNut(1,nut5);
		}
		ZHole(Type,AddOffset);
		ZNutHole(Type,AddOffset);
		ZHoleCS(Type,AddOffset);
	}
	difference() {
		ZHoleSupport(Type,AddOffset);	// may need some extra around zrod hole
		ZHoleCS(Type,AddOffset);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZHoleCS(Type,AddOffset=0) { // countersink flange nut
	if(Type==1) {
		translate([OutsideD/2,ZNutDepth,ZHeight/2-ZShift-AddOffset]) 
			rotate([90,0,0]) color("red") cylinder(h=10,d=FlangeNutOutsideDiameter);
	}
}

//////////////////////////////////////////////////////////////////

module PlateMountHole(left,screw=screw5) {
	if(!left) translate([ZHeight/2,ThicknessZ/2,-1]) color("blue") cylinder(h=Raise*2,d=screw);
	else translate([OutsideD - ZHeight/2,ThicknessZ/2,-1]) color("white") cylinder(h=Raise*2,d=screw);
}

//////////////////////////////////////////////////////////////////

module PlateMountHole2(left,screw=screw5) {
	if(!left) translate([OutsideD/2-20,ThicknessZ/2,-1]) color("blue") cylinder(h=Raise*2,r=screw/2);
	else
	translate([OutsideD/2+20,ThicknessZ/2,-1]) color("white") cylinder(h=Raise*2,r=screw/2);
}

//////////////////////////////////////////////////////////////////

module PlateMountHoleCS(left,screw=screw5hd) {
	if(!left) translate([ZHeight/2,ThicknessZ/2,-1]) color("blue") cylinder(h=5,r=screw/2);
	else translate([OutsideD - ZHeight/2,ThicknessZ/2,-1]) color("white") cylinder(h=5,r=screw/2);
}

//////////////////////////////////////////////////////////////////

module PlateMountHoleNut(left,screw=screw5hd) {
	if(!left) translate([OutsideD/2-20,ThicknessZ/2,-1]) color("blue") cylinder(h=5,r=screw/2,$fn=6);
	else translate([OutsideD/2+20,ThicknessZ/2,-1]) color("white") cylinder(h=5,r=screw/2,$fn=6);
}

//////////////////////////////////////////////////////////////////

module ZHole(Type,AddOffset=0) {
	if(!Type) {
		translate([OutsideD/2,ThicknessZ*1.5,ZHeight/2-ZShift-AddOffset])
			rotate([90,0,0]) color("gray") cylinder(h=ThicknessZ*2,r = ZRodTDiamater/2);
	} else  {
		translate([OutsideD/2,ThicknessZ*1.5,ZHeight/2-ZShift-AddOffset])
			rotate([90,0,0]) color("gray") cylinder(h=ThicknessZ*2,r = FlangeNutDiameter/2);

	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module ZHoleSupport(Type,AddOffset=0) { // will it need extra width at the zrod?
	difference() {
		if(!Type) {
			color("pink") hull() {
				translate([OutsideD/2,ThicknessZ,ZHeight/2-ZShift+ZAdjust+5])
					rotate([90,0,0]) cylinder(h=ThicknessZ,r = ZRodTDiamater*2.5);
				translate([OutsideD/2,ThicknessZ,ZHeight/2-ZShift]) rotate([90,0,0])
					cylinder(h=ThicknessZ,r = ZRodTDiamater*2.5);
			}
		} else {
			color("pink") //hull() {
				//	rotate([90,0,0]) cylinder(h=ThicknessZ,r = FlangeNutOutsideDiameter/1.5);
				//translate([OutsideD/2,ThicknessZ,ZHeight/2-ZShift+ZAdjust+5])
			union() {
				translate([OutsideD/2,ThicknessZ-7.5,ZHeight/2-ZShift-AddOffset]) rotate([90,0,0])
					cyl(h=ThicknessZ,r = FlangeNutOutsideDiameter/1.5,rounding=2);
				translate([64,0,-18])
					cuboid([FlangeNutOutsideDiameter+5,ThicknessZ,FlangeNutOutsideDiameter+5],rounding=2,p1=[0,0]);
			}
		}
		translate([OutsideD/2+-15,ThicknessZ-25,ZHeight/2-ZShift+ZAdjust+10]) color("blue")  cube([30,30,20]);
		ZHole(Type,AddOffset);
		ZNutHole(Type,AddOffset);
	}
}

/////////////////////////////////////////////////////////////////////

module ZNutHole(Type,AddOffset=0) {
	if(!Type) {
		translate([OutsideD/2,ZNutDepth,ZHeight/2-ZShift]) rotate([90,0,0])
			color("black") cylinder(h=ThicknessZ,r = ZNutDiameter/2,$fn=6);
	} else { // make mounting screw holes
		if(Use3mmInsert) {
			translate([OutsideD/2+FlangeNutScrewOffset/2,ThicknessZ+5,ZHeight/2-ZShift-AddOffset])
				rotate([90,0,0]) color("red") cylinder(h=ThicknessZ+8,d=Yes3mmInsert(Use3mmInsert));
			translate([OutsideD/2-FlangeNutScrewOffset/2,ThicknessZ+5,ZHeight/2-ZShift-AddOffset])
				rotate([90,0,0]) color("white") cylinder(h=ThicknessZ+8,d=Yes3mmInsert(Use3mmInsert));
			translate([OutsideD/2,ThicknessZ+5,ZHeight/2-ZShift+FlangeNutScrewOffset/2-AddOffset])
				rotate([90,0,0]) color("blue") cylinder(h=ThicknessZ+8,d=Yes3mmInsert(Use3mmInsert));
			translate([OutsideD/2,ThicknessZ+5,ZHeight/2-ZShift-FlangeNutScrewOffset/2-AddOffset])
				rotate([90,0,0]) color("black") cylinder(h=ThicknessZ+8,d=Yes3mmInsert(Use3mmInsert));
		} else {
			translate([OutsideD/2+FlangeNutScrewOffset/2,ThicknessZ+5,ZHeight/2-ZShift-AddOffset])
				rotate([90,0,0]) color("red") cylinder(h=ThicknessZ+8,d=screw3);
			translate([OutsideD/2-FlangeNutScrewOffset/2,ThicknessZ+5,ZHeight/2-ZShift-AddOffset])
				rotate([90,0,0]) color("white") cylinder(h=ThicknessZ+8,d=screw3);
			translate([OutsideD/2,ThicknessZ+5,ZHeight/2-ZShift+FlangeNutScrewOffset/2-AddOffset])
				rotate([90,0,0]) color("blue") cylinder(h=ThicknessZ+8,d=screw3);
			translate([OutsideD/2,ThicknessZ+5,ZHeight/2-ZShift-FlangeNutScrewOffset/2-AddOffset])
				rotate([90,0,0]) color("black") cylinder(h=ThicknessZ+8,d=screw3);
		}
	}
}

////////////////////////////////////////////////////////////////////////////

module testnut(Type) { 	// a shortened nut section for test fitting of the nut & ZRodTDiamater or flange nut
	difference() {
		translate([-60,0,0]) ZHolesupport(Type);
		if(!Type) translate([-10,ZNutDepth+3,-35]) cube([60,20,60]);
		else translate([-10,5,-40]) cube([60,20,60]);
		translate([-60,-3.5,0]) ZHoleCS(Type);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

// added a thrust bearing?
module BearingMount(Spc=0,SpcThk=idler_spacer_Thickness,Idler=1,Makerslide=1,Support=1) { // bearing holder at bottom of z-axis
	rotate([180,0,0]) {										// didn't bother to make a left/right versions
		Mount(Makerslide,Support);
		difference() {
			translate([0,-(ShaftOffset-BaseOffset),0]) color("navy") cuboid([BWidth,BLength,Thickness],rounding=1);
			translate([0,-ShaftOffset,-6]) color("red") cylinder(h=10,d=Diameter608);
			NotchForMakerSlide();
		BearingHoldDown(Screw=screw3t);
		}
		translate([0,-ShaftOffset,0]) BearingHole();
	}
	if(Spc) translate([0,10,-2.5]) IdlerSpacers(0,SpcThk);
	if(Idler) SingleAttachedIdler(1);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BearingHole() {	// holds the bearing
	difference() {
		translate([0,0,-Height608+3]) color("white") cyl(h=Height608+4,d1=Diameter608+5,d2=Diameter608+14.5,rounding1=2);
		translate([0,0,-Height608]) color("black") cyl(h=15,d=BearingHoleClearance);
		translate([0,0,-Height608+2]) color("gray") cylinder(h=15,d=Diameter608);
		translate([0,11,0]) BearingHoldDown(Screw=screw3t);
	}
	BearingHole_support();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module BearingHole_support() { // print support for bearing hole
	translate([0,0,-5.3]) color("pink") cylinder(h=LayerThickness,d=Diameter608+5);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BearingHoldDown(Screw=screw3t) { // uses two M3 screws and M3 washers
	translate([0,-24,0]) color("green") rotate([0,0,0]) cyl(h=50,d=Screw);
	translate([0,2.5,0]) color("cyan") rotate([0,0,0]) cyl(h=50,d=Screw);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltMotor(idler=0,HSlot=1) { // motor mount for belt drive
	rotate([180,0,0]) {
		NEMAPlate(0);	// nema17 mount
		MountBelt();	// motor mount base
	}
	difference() {	// mount to 2020
		translate([-BWidth/2,-45,-Thickness/2-ShiftBeltMotor]) color("cyan") cuboid([BWidth,24.5,21],rounding=2,p1=[0,0]);	// base
		translate([-BWidth/2-1,-37,-21-ShiftBeltMotor]) rotate([45,0,0]) color("gray") cube([BWidth+2,22,40]); // remove half
		translate([-BWidth/2+10,-35,-Thickness/2-ShiftBeltMotor])
			color("red") cylinder(h=40,d=screw5);	// mounting screw holes
		translate([BWidth/2-10,-35,-Thickness/2-ShiftBeltMotor]) color("white") cylinder(h=40,d=screw5);
		translate([-BWidth/2+10,-35,-Thickness/2-ShiftBeltMotor+1]) color("blue") cylinder(h=15,d=screw5hd);	// countersinks
		translate([BWidth/2-10,-35,-Thickness/2-ShiftBeltMotor+1]) color("gray") cylinder(h=15,d=screw5hd);
		translate([-BWidth/2-1,-42,-22.5]) color("pink")
			cuboid([BWidth+5,22.5,20],rounding=2,p1=[0,0]); // make sure it doesn't go past top
	}
	BeltMotorMount_support();	// make 2020 mount holes printable
	if(idler) translate([0,0,-2.5]) AttachedIdler(1,1);	// add idler to the motor mount
	if(idler) translate([0,45,-2.5]) AttachedIdler(0); // top idler plate
	//translate([11,42,5]) testf625z(); // this is use to check bearing Clearance to support wall
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltMotorMount_support() {	// print support for inner hole
		translate([-BWidth/2+10,-35,-Thickness/2-ShiftBeltMotor+16]) color("black") cylinder(h=LayerThickness,d=screw5hd);
		translate([BWidth/2-10,-35,-Thickness/2-ShiftBeltMotor+16]) color("yellow") cylinder(h=LayerThickness,d=screw5hd);
}

////////////////////////////////////////////////////////////////////////////

module MountBelt(Support=1) { // the three sides of the motor mount; same as mount(), but no screw holes
	translate([0,22,-18]) color("white") cuboid([BWidth,Thickness,MHeight],rounding=2);
	SideSupport(Support);
	translate([-BWidth+Thickness,0,0]) SideSupport(Support); 
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BearingIdler() {	// belt idler (currently not used)
	difference() {
		color("cyan") cubeX([20,100,20],1);
		translate([10,90,-1]) color("red") cylinder(h=50,d=Yes5mmInsert(Use5mmInsert));
		translate([10,90-DiameterF625Z-12,-1]) color("black") cylinder(h=50,d=Yes5mmInsert(Use5mmInsert));
	}
	difference() {
		translate([-BWidth/3,-19,0]) color("green") cuboid([BWidth,23,20],rounding=1,p1=[0,0]);
		translate([-BWidth/3-1,-36,14]) rotate([-45,0,0]) color("blue") cube([BWidth+2,22,40]);
		translate([-BWidth/2+18,-8,-Thickness/2]) color("white") cylinder(h=40,d=screw5);
		translate([BWidth/2,-8,-Thickness/2]) color("pink") cylinder(h=40,d=screw5);
		translate([-BWidth/2+18,-8,5]) color("salmon") cylinder(h=15,d=screw5hd);
		translate([BWidth/2,-8,5]) color("black") cylinder(h=15,d=screw5hd);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LockRing() { // lock ring to hold TR8 leadscrew in bearing, may not be necessary since gravity will hold it
	difference() {
		color("cyan") cylinder(h=Height608+1,d=NutClearance-2);
		translate([0,0,-1]) color("red") cylinder(h=15,d=TR8Diameter);
		translate([0,0,2.5]) rotate([90,0,0]) color("black") cylinder(h=10,d=screw3t);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AttachedIdler(Spc=0,Spt=0) { // Spc = spacers, Spt = add support to attached idler plate
	if(Spt) {
		difference() { // needs to be a bit wider with Spt==1
			translate([-12,30,-2.5]) color("green") cuboid([39.5,40,Thickness+1],rounding=2,p1=[0,0]);
			translate([-2,60,-5]) color("white") cylinder(h=10,d=Yes5mmInsert(Use5mmInsert));
			translate([DiameterF625Z-DiameterF625Z/2+2,60-DiameterF625Z,-5]) color("red") cylinder(h=10,d=Yes5mmInsert(Use5mmInsert));
		}
	} else {
		difference() {
			color("blue") hull() {
				translate([11,41,-2.5]) cylinder(h=Thickness,d=screw5*2);
				translate([-2,60,-2.5]) cylinder(h=Thickness,d=screw5*2);
			}
			translate([-2,60,-5]) color("cyan") cylinder(h=10,d=screw5);
			translate([DiameterF625Z-DiameterF625Z/2+2,60-DiameterF625Z,-5]) color("pink") cylinder(h=10,d=screw5);
		}
	}
	if(Spt) translate([22.5,26,-2.5]) color("blue") cuboid([Thickness,44,Thickness*3],rounding=1,p1=[0,0]);
	if(Spc) translate([-7.5,10,-2.5]) IdlerSpacers(1,idler_spacer_Thickness);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IdlerSpacers(Two=0,Thk=idler_spacer_Thickness,Spt=0) {
	difference() {
		color("red") cylinder(h=Thk,d=screw5+5);
		translate([0,0,-1]) color("white") cylinder(h=idler_spacer_Thickness*2,d=screw5);
	}
	if(Two) {
		translate([15,0,0]) difference() {
			color("red") cylinder(h=Thk,d=screw5+5);
			translate([0,0,-1]) color("white") cylinder(h=idler_spacer_Thickness*2,d=screw5);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SingleAttachedIdler(Spc=1) { // Spc = spacers, Spt = add support to attached idler plate
	difference() { // needs to be a bit wider with Spt==1
		translate([-27.5,30,-2.5]) color("white") cuboid([55,25,Thickness],rounding=1,p1=[0,0]);
		translate([0,63-DiameterF625Z,-5]) color("red") cylinder(h=10,d=Yes5mmInsert(Use5mmInsert));
	}
	translate([22.5,25,-2.5]) color("salmon") cuboid([Thickness,30,Thickness+7],rounding=1,p1=[0,0]);
	translate([-27.5,25,-2.5]) color("pink") cuboid([Thickness,30,Thickness+7],rounding=1,p1=[0,0]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module ZAxisMountPlates(Qty=1,Screw=screw5,MS=0) { // mouting plates for z axis makerslide (instead of drilling access holes)
	for(i=[0:Qty-1]){
		translate([0,i*45,0]) Plate1(Screw);
		translate([45,i*45,0]) {
			if(MS)
				Plate2(Screw);
			else
				Plate1(Screw);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module Plate1(Screw=screw5) { // no notch for makerslide
	difference() {
		color("cyan") cuboid([40,40,5],rounding=2,p1=[0,0]);
		PlateScrews(Screw);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module Plate2(Screw=screw5) { // no notch for makerslide
	difference() {
		color("cyan") cuboid([40,40,5],rounding=2,p1=[0,0]);
		PlateScrews(Screw);
		translate([-5,20,-11]) SingleMakerSlideNotch();
	}
	difference() {
		translate([2,20,3]) rotate([0,90,0]) color("white") cylinder(h=36,d=10);
		translate([0,15,-6]) color("black") cube([50,10,10]);
		PlateScrews(Screw);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module PlateScrews(Screw=screw5) {
	translate([10,10,-2]) color("red") cylinder(h=10,d=Screw);
	translate([30,10,-2]) color("white") cylinder(h=10,d=Screw);
	translate([10,30,-2]) color("blue") cylinder(h=10,d=Screw);
	translate([30,30,-2]) color("gray") cylinder(h=10,d=Screw);
	// countersinks
	if(Screw==screw5) {
		translate([10,10,4]) color("red") cylinder(h=10,d=screw5hd);
		translate([30,10,4]) color("white") cylinder(h=10,d=screw5hd);
		translate([10,30,4]) color("blue") cylinder(h=10,d=screw5hd);
		translate([30,30,4]) color("gray") cylinder(h=10,d=screw5hd);
	}
	if(Screw==screw3) {
		translate([10,10,4]) color("red") cylinder(h=10,d=screw3hd);
		translate([30,10,4]) color("white") cylinder(h=10,d=screw3hd);
		translate([10,30,4]) color("blue") cylinder(h=10,d=screw3hd);
		translate([30,30,4]) color("gray") cylinder(h=10,d=screw3hd);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

module ReductionMotorMount(Quanity=3) {
	for(i=[0:Quanity-1]){
		translate([i*60,0,0]) BeltMotor(0);	// one stepper motor mount with idler
	}
}

/////////////// end of corexy-z-axis.scad ////////////////////////////////////////////////////////////////////
