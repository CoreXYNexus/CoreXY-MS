/////////////////////////////////////////////////////////////////////////////////////////
// MotorAndBearingMounts.scad - hold the motors, belts & bearing bracket inside the frame
/////////////////////////////////////////////////////////////////////////////////////////
// created 7/5/2016
// last update 1/4/22
/////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 7/7/16	- added built-in spacer to the bearing_bracket
// 7/14/16	- adjusted 2002 mounting holes to have motor mount clear the makerslide rails
//			  mirrored bearing() for other side and it now makes all four parts
// 7/15/16	- Made the FrontBearingBracket() bearing screw hole to be tap sized or not
// 7/16/16	- Made makerslide rail notch in FrontBearingBracket() optional
//            Added nut hole to FrontBearingBracket() to use M5x50 screw
// 7/18/16	- Made motor_mount taller above the makerslide
// 7/19/16	- Changed 3rd wall to a diagonal support on MotorMount() and removed notch on
//			  the non-makerslide wall
// 7/20/16	- Moved upper belt stepper motor up 10mm
// 8/23/16	- Added Vthickness & Tthickness for BearingSupport()
// 1/10/17	- Added labels to motor mounts and colors to preview for easier editing
// 2/14/17	- Adjusted bearing screw hole in BearingSupport, noticed that it's off by 2mm when I replaced the
//			  makerslide with a 2040 to use the makerslide for a three motor z axis.
//			  Tapered the spacer on the bearing_bracket and added L/R labels.
// 7/13/18	- Added a cube showing a 200x200 bed to all()
// 8/19/18	- OpenSCAD 2018.06.01 for $preview
// 12/8/18	- Changed stepper motor mount to slots for belt adjustment, adjusted diagonal supports
//			  on the stepper motor mounts
// 2/28/19	- Bugfix in all() and FrontBearingBracket()
// 4/16/19	- Changed the angle support for the motor mounts to match the Z motor mounts
//			  Changed the BearingSupport() to match the motor mount notch supports
// 7/2/19	- Made the labels tilted a bit to print better, updated mirror() to 2019.05 version
// 5/16/20	- Rounded the end of the bearing bracket end and reduced the width that connects to the 2020
// 8/8/20	- Changed the supports for the BearingSupport()
// 10/17/20	- Can now use 5mm inserts
// 4/1/21	- Added an adjustable front bearing mount
// 4/24/21	- Added thrust washer to front bearing mount base
// 10/16/21	- Changed support on MotorMount()
// 1/4/22	- BOSL2
/////////////////////////////////////////////////////////////////////////////////////////
// NOTE: Bearing position in FrontBearingBracket() must match stepper motor shaft in MotorMount()
//       If the motors get hot, print it from something that can handle it
//       Bearing stack is 5mm washer,F625Z,F625Z,5mm washer,5mm washer,F625Z,F625Z,5mm washer,
//       M5x50, and a 5mm nut in the nut trap or brass insert
//		 Motor mounts have two holes on the makerslide side, to allow the makerslide to be installed
//		 either way.
//		 Adjustable front bearing has the motor adjustable, since you may not get the belts the same length.
//		 Used M3x40 screw in the bearing holder, held in with a M3 mut. Each base uses a M3x10 Thrust washer.
// --------------------------------------------------------------------------------------
//		 Taller motor_mount on left side rear.
//		 NON-adjustable bearing brackets at inside front corners & supports on outside
//		 Install one M5 nut in each bearing bracket
/////////////////////////////////////////////////////////////////////////////////////////
include <CoreXY-MSv1-h.scad>
include <inc/brassinserts.scad>
$fn=100;
/////////////////////////////////////////////////////////////////////////////////////////
// vars for this file
b_posY = 29.5;		// bearing position X
b_posX = 20;		// bearing position Y
b_height = 10;		// amount to raise bearings
F625ZDoulbleStack = 11.78;	// just the length of two washers & two F625Z bearings
F625ZDiameter = 18; // diameter of the f625z bearing
LayerThickness = 0.35;		// layer thickness used to print
Vthickness = 7;		// thickness of bearing support vertical section
Tthickness = 5;		// thickness of bearing support top and fillet
Use3mmInsert=1;
LargeInsert=1;
Use5mmInsert=1;
Knob_Diameter=nut3*3;
Knob_Height=3;
WasherThickness=1;
ThrustBrearingDiameter=10;
/////////////////////////////////////////////////////////////////////////////////////////

//NonAdjustableBearingMountSet(); // all the needed parts
AdjustableFrontBearingMountSet(0);
//AdjustableFrontBearingMount(0);
//AdjustingKnob();

/////////////////////////////////////////////////////////////////////////////////////////

module NonAdjustableBearingMountSet() {
	//if($preview) %translate([20,10,-4]) cube([200,200,2],center=true); // show a 200x200 bed
	translate([0,-5,0]) MotorMount(1);
	translate([35,60,-2.5]) rotate([0,0,0]) FrontBearingBracket(0,"Right");
	translate([80,-30,F625ZDoulbleStack*2+b_height+40]) rotate([0,180,0]) BearingSupport(2,0);
	translate([0,65,0]) MotorMount(0);
	translate([75,20,-2.5]) rotate([0,0,0]) mirror([1,0,0]) FrontBearingBracket(0,"Left"); // mirror it for the other side
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module AdjustingKnob() {
	difference() {
		union() {
			translate([0,0,27/2]) color("cyan") cyl(h=27,d=nut3*2,rounding=1);
			translate([0,0,Knob_Height/2]) color("blue") cyl(h=Knob_Height,d=Knob_Diameter,rounding=1);
		}
		if(Use3mmInsert)  translate([0,0,-5]) color("red") cylinder(h=35,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
		else translate([0,0,-4]) color("purple") cylinder(h=5,d=nut3,$fn=6);
		translate([0,0,-5]) color("white") cylinder(h=35,d=screw3+0.1); // throuch hole for M3
		for(i=[22.5:45:360]) {
			translate([(Knob_Diameter)*sin(i)/2,(Knob_Diameter)*cos(i)/2,-1]) // knurls
				color("purple") cylinder(r=0.7,h=Knob_Height+2);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module AdjustableFrontBearingMountSet(Fit=0) {
	translate([0,-33,2.55]) MotorMount(1,1);
	translate([0,86,2.55]) MotorMount(0,1);
	rotate([0,-90,0]) AdjustableFrontBearingMount(Fit);
	translate([95,0,0]) rotate([0,-90,0]) AdjustableFrontBearingMount(Fit);
	translate([-25,10,0]) AdjustingKnob();
	translate([-5,10,0]) AdjustingKnob();
}

/////////////////////////////////////////////////////////////////////////////////////////

module AdjustableFrontBearingMount(Fit=0) {
	difference() { // vertical
		union() {
			translate([0,0,45]) color("cyan")
				cuboid([Vthickness,F625ZDiameter,F625ZDoulbleStack*2+b_height-2],rounding=1,p1=[0,0]);
			translate([0,0,45-WasherThickness]) color("white") cuboid([34,F625ZDiameter,Tthickness-1],rounding=1,p1=[0,0]);
			translate([33,9,F625ZDoulbleStack*2+b_height+11.45-WasherThickness+2]) color("red")
				cyl(h=Tthickness-1,d=F625ZDiameter,rounding=1); // bottom
			translate([0,0,F625ZDoulbleStack*2+b_height+38]) color("blue") 
				cuboid([34,F625ZDiameter,Tthickness],rounding=1,p1=[0,0]);
			translate([33,9,F625ZDoulbleStack*2+b_height+40.5]) color("cyan")
				cyl(h=Tthickness,d=F625ZDiameter,rounding=1); // top
			translate([0,0,45]) color("green") cuboid([22,Tthickness-1,30],rounding=2,p1=[0,0]);
			translate([0,14,45]) color("lightgreen") cuboid([22,Tthickness-1,30],rounding=2,p1=[0,0]);
		}
		translate([Vthickness+26,9,F625ZDoulbleStack+b_height+30]) color("lightgray") cylinder(h=50,d=screw5); // top
		translate([Vthickness+26,9,F625ZDoulbleStack+b_height-5]) color("gray")
			cylinder(h=50,d=Yes5mmInsert(Use5mmInsert)); // bottom
		translate([Vthickness+26,9,F625ZDoulbleStack*2+b_height+42]) color("blue") cylinder(h=5,d=screw5hd);
		translate([-10,9,F625ZDoulbleStack*2+b_height+27.5]) rotate([0,90,0]) color("plum") cylinder(h=50,d=screw3+0.1);
		translate([Vthickness-1,9,F625ZDoulbleStack*2+b_height+27.5]) rotate([0,90,0]) color("white")
			cylinder(h=50,d=screw3hd);
		translate([Vthickness-8,9,F625ZDoulbleStack*2+b_height+27.5]) rotate([0,90,0]) color("plum")
			cylinder(h=3,d=nut3,$fn=6);
	}
	translate([Vthickness-5,9,F625ZDoulbleStack*2+b_height+27.5]) rotate([0,90,0]) color("purple") // support for m3 hole
		cylinder(h=LayerThickness,d=screw3hd);
	if(Fit) translate([0,0,-1]) AdjustableFrontBearingMountBase();  // fit parts
	else  translate([5,27,-5]) AdjustableFrontBearingMountBase();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AdjustableFrontBearingMountBase(ThrustBearing=1,DoTabs=1) {
	difference() {
		union() {
			translate([-5,-5,1]) color("purple")
				cuboid([Vthickness-2,F625ZDiameter+10,F625ZDoulbleStack*2+b_height+48],rounding=2,p1=[0,0]);
			translate([-5,-5,78.75]) color("cyan") cuboid([32,F625ZDiameter+10,Tthickness],rounding=2,p1=[0,0]);
			translate([-5,-37,39.75]) color("khaki") cuboid([24,F625ZDiameter+75,Tthickness],rounding=2,p1=[0,0]);
			translate([-5,-5,40]) color("black") cuboid([32,Tthickness-0.25,42],rounding=2,p1=[0,0]);
			translate([-5,18.5,40]) color("white") cuboid([32,Tthickness-0.25,42],rounding=2,p1=[0,0]);
			translate([15,-5,39.75]) color("gray") cuboid([12,28.25,Tthickness],rounding=2,p1=[0,0]); 
		}
		translate([-10,9,F625ZDoulbleStack*2+b_height+27.5]) rotate([0,90,0])
			color("plum") cylinder(h=50,d=screw3+0.1);
		if(ThrustBearing) {
			translate([-8,9,F625ZDoulbleStack*2+b_height+27.5]) rotate([0,90,0]) color("pink")
				cylinder(h=5,d=ThrustBrearingDiameter);
		}
		color("blue") hull() {
			translate([10,-30,30]) cylinder(h=20,d=screw5); // top
			translate([10,-10,30]) cylinder(h=20,d=screw5); // top
		}
		color("red") hull() {
			translate([10,50,30]) cylinder(h=20,d=screw5); // top
			translate([10,29,30]) cylinder(h=20,d=screw5); // top
		}
		color("red") hull() {
			translate([10,-30,44]) cylinder(h=5,d=screw5hd); // top
			translate([10,-10,44]) cylinder(h=5,d=screw5hd); // top
		}
		color("blue") hull() {
			translate([10,50,44]) cylinder(h=5,d=screw5hd); // top
			translate([10,29,44]) cylinder(h=5,d=screw5hd); // top
		}
		translate([-11,9,10]) rotate([0,90,0]) color("red") cylinder(h=20,d=screw5);  // screw mounting holes
		translate([-8,9,10]) rotate([0,90,0]) color("blue") cylinder(h=5,d=screw5hd); // countersink
		translate([-11,9,30]) rotate([0,90,0]) color("blue") cylinder(h=20,d=screw5); // screw mounting holes
		translate([-8,9,30]) rotate([0,90,0]) color("red") cylinder(h=5,d=screw5hd);  // countersink
	}
	translate([-3,9,10]) rotate([0,90,0]) color("black") cylinder(h=LayerThickness,d=screw5hd); // countersink support
	translate([-3,9,30]) rotate([0,90,0]) color("white") cylinder(h=LayerThickness,d=screw5hd); // countersink support
	if(DoTabs) {
		translate([-5,-38,42]) rotate([90,0,90]) color("gray") cylinder(h=LayerThickness,d=screw5hd); // tab support
		translate([-5,55,42]) rotate([90,0,90]) color("lightgray") cylinder(h=LayerThickness,d=screw5hd); // tab support
		translate([-5,23,82]) rotate([90,0,90]) color("red") cylinder(h=LayerThickness,d=screw5hd); // tab support
		translate([-5,-3.5,82]) rotate([90,0,90]) color("blue") cylinder(h=LayerThickness,d=screw5hd); // tab support
		translate([-5,23,1]) rotate([90,0,90]) color("blue") cylinder(h=LayerThickness,d=screw5hd); // tab support
		translate([-5,-3.5,1]) rotate([90,0,90]) color("red") cylinder(h=LayerThickness,d=screw5hd); // tab support
	}
	if(ThrustBearing) { // support
		translate([-3,9,F625ZDoulbleStack*2+b_height+27.5]) rotate([0,90,0]) color("green")
			cylinder(h=LayerThickness,d=ThrustBrearingDiameter);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MotorMount(Side=0,Adjustable=1) {	// 0 - lower belt motor; 1 = upper belt motor
	difference() {	// motor mounting holes
		color("blue") cuboid([59,59,5],rounding=2);
		if(Adjustable)
			translate([-2,0,-4]) color("red") NEMA17_parallel_holes(7,5);
		else 
			translate([-2,0,-4]) rotate([0,0,45]) color("white")  NEMA17_x_holes(7,3);
		//translate([0,0,10]) MakerslideNotchIt(Side);
	}
	if(!Side) {
		MotorMountSupport(Side);
		difference() { // make wall thicker at notch
			translate([0,25,5]) color("white") cuboid([58,4,14],rounding=2);
			translate([0,0,10]) MakerslideNotchIt(Side);
			MountScrews(28);
		}
		difference() {
			translate([0,27,23]) color("cyan") cuboid([59,5,48],rounding=2);
			MountScrews(18);
			translate([0,0,10]) MakerslideNotchIt(Side);
		}
		difference() {
			translate([27,0,23]) color("pink") cuboid([5,59,48],rounding=2);
			MountScrews(18);
			translate([0,0,10]) MakerslideNotchIt(Side);
		}
		translate([25.8,1,30]) rotate([110,180,-90]) PrintString("R");//,1.5,4,"Babylon Industrial:style=Normal");
	} else {
		MotorMountSupport(Side);
		difference() {
			translate([0,-27,28]) color("cyan") cuboid([59,5,58],rounding=2);
			translate([0,0,20]) MakerslideNotchIt(Side);
			MountScrews(28);
		}
		difference() { // make wall thicker at notch
			translate([0,-25,17]) color("white") cuboid([58,4,14],rounding=2);
			translate([0,0,10]) MakerslideNotchIt(Side);
			MountScrews(28);
		}
		difference() {
			translate([27,0,28]) color("pink") cuboid([5,59,58],rounding=2);
			MountScrews(28);
			translate([0,0,20]) MakerslideNotchIt(Side);
		}
		translate([25.8,-1,40]) rotate([110,180,-90]) PrintString("L");//,1.5,4,"Babylon Industrial:style=Normal");
	}
}

/////////////////////////////////////////////////////////////////////////////////////////

module MakerslideNotchIt(Side=0) {
	if(Side)
		translate([-59,-59/2-4.5,-10]) MakerslideNotch();
	else
		translate([-59,59/2+4.5,-10]) MakerslideNotch();
}

////////////////////////////////////////////////////////////////////////////////////////

module MakerslideNotch() {
	rotate([45,0,0]) color("black") cube([100,10,10]);
}

/////////////////////////////////////////////////////////////////////////////////////////

module MountScrews(Mount_S,Screw=screw5) { // all of them; Mount_S is hight of top screw holes
	translate([-14,40,Mount_S]) rotate([90,0,0]) color("white") cylinder(h=80,d=Screw);
	translate([-14,-21,Mount_S]) rotate([90,0,0]) color("gray") cylinder(h=5,d=screw5hd);
	translate([-14,26,Mount_S]) rotate([90,0,0]) color("green") cylinder(h=5,d=screw5hd);
	translate([-42,18,Mount_S]) rotate([0,90,0]) color("blue") cylinder(h=80,d=Screw);
	translate([-42,-18,Mount_S]) rotate([0,90,0]) color("green") cylinder(h=80,d=Screw);
	translate([21,18,Mount_S]) rotate([0,90,0]) color("green") cylinder(h=5,d=screw5hd);
	translate([21,-18,Mount_S]) rotate([0,90,0]) color("blue") cylinder(h=5,d=screw5hd);
	translate([-14,40,Mount_S+20]) rotate([90,0,0]) color("yellow") cylinder(h=80,d=Screw);
	translate([-14,26,Mount_S+20]) rotate([90,0,0]) color("khaki") cylinder(h=5,d=screw5hd);
	translate([-42,18,Mount_S+20]) rotate([0,90,0]) color("gold") cylinder(h=80,d=Screw);
	translate([21,18,Mount_S+20]) rotate([0,90,0]) color("gold") cylinder(h=5,d=screw5hd);
	translate([-42,-18,Mount_S+20]) rotate([0,90,0]) color("plum") cylinder(h=80,d=Screw);
	translate([21,-18,Mount_S+20]) rotate([0,90,0]) color("white") cylinder(h=5,d=screw5hd);
}

/////////////////////////////////////////////////////////////////////////////////////////

module FrontBearingBracket(TapIt=0,Label="") {
	difference() {
		color("white") cuboid([40,30,40],rounding=2,p1=[0,0]);
		translate([b_posY,b_posX,-2]) color("gray") cylinder(h=50,d=Yes5mmInsert(Use5mmInsert));
		translate([-2,10,30]) rotate([0,90,0]) color("red") cylinder(h=45,d=screw5);
		translate([5,10,30]) rotate([0,90,0]) color("white") cylinder(h=45,d=screw5hd);
		translate([20,32,10]) rotate([90,0,0]) color("blue") cylinder(h=45,d=screw5);
		translate([20,25,10]) rotate([90,0,0]) color("green") cylinder(h=45,d=screw5hd);
		translate([20,32,30]) rotate([90,0,0]) color("plum") cylinder(h=45,d=screw5);
		translate([20,25,30]) rotate([90,0,0]) color("yellow") cylinder(h=45,d=screw5hd);
		translate([-2,10,10]) rotate([0,90,0]) color("snow") cylinder(h=45,d=screw5);
		translate([5,10,10]) rotate([0,90,0]) color("lawngreen") cylinder(h=45,d=screw5hd);
	}
	translate([b_posY,b_posX,40]) Spacer(TapIt,Yes5mmInsert(Use5mmInsert));
	if(Label=="Right") translate([4,0.5,20]) rotate([80,0,0]) PrintString(Label);
	if(Label=="Left") translate([14,0.5,20]) rotate([80,0,0]) mirror([1,0,0]) PrintString(Label);
}

/////////////////////////////////////////////////////////////////////////////////////////

module Spacer(TapIt=0,Screw=Yes5mmInsert(Use5mmInsert)) { // spacer to raise bearing on bearing braket to match the corexy-xy.scad
	difference() {
		color("cyan") cylinder(h=b_height,d1=Screw*2.5,d2=Screw+4);
		translate([0,0,-1]) color("darkgray") cylinder(h=b_height+2,d=Screw);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////

module BearingSupport(Qty=1,NotchIt=0) {	// keep the idler bearings from tilting on the bracket
	// NotchIt == 1 to notch it for the makerslide rail
	for(x = [0 : Qty-1]) {
		translate([0,x*25,0]) {
			difference() { // vertical
				union() {
					// long vertical section
					translate([0,0,0]) color("gray")
						cuboid([Vthickness-2,F625ZDiameter,F625ZDoulbleStack*2+b_height+43],rounding=1,p1=[0,0]);
					// support
					translate([0,0,40]) color("white") cuboid([15+Vthickness,F625ZDiameter,Tthickness-2],rounding=1,p1=[0,0]);
					translate([0,0,40]) color("cyan") cuboid([15+Vthickness,Tthickness-2,35],1);
					translate([0,F625ZDiameter-Tthickness+2,40]) color("green")
						cuboid([15+Vthickness,Tthickness-2,35],rounding=1,p1=[0,0]);
					BearingBracketHorizontal();
				}
				translate([-3,9,10]) rotate([0,90,0]) color("red") cylinder(h=20,d=screw5); // screw mounting holes
				translate([-9,9,10]) rotate([0,90,0]) color("blue") cylinder(h=10,d=screw5hd); // screw mounting holes
				translate([-3,9,30]) rotate([0,90,0]) color("blue") cylinder(h=20,d=screw5);
				translate([-9,9,30]) rotate([0,90,0]) color("red") cylinder(h=10,d=screw5hd);
				translate([Vthickness+8,9,35]) color("red") cylinder(h=50,d=screw5); // screw mounting holes
				translate([Vthickness+8,9,42]) color("black") cylinder(h=10,d=screw5hd); // screw mounting holes
				if(NotchIt)	translate([Vthickness+3,-40,33]) rotate([0,0,90]) MakerslideNotch(); // notch it?
			}
			if(NotchIt) {
				difference() {	// extra support at notch
					// strengthen at the notch
					translate([-2,F625ZDiameter,35]) rotate([90,0,0]) color("cyan")
						cuboid([5,10,F625ZDiameter],rounding=2,p1=[0,0]);
					translate([-5,9,30]) rotate([0,90,0]) color("red") cylinder(h=5,d=screw5hd);	// screw head clearance
					translate([2,-15,35]) color("black") 
						cuboid([10,50,10],p1=[0,0]); // remove any of the cylinder on notch side
				}
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BearingBracketHorizontal() {
	difference() {
		union() {
			translate([0,0,F625ZDoulbleStack*2+b_height+39]) color("blue") 
				cuboid([38,F625ZDiameter,Tthickness],rounding=1,p1=[0,0]);
			translate([37,9,F625ZDoulbleStack*2+b_height+39]) color("red") cylinder(h=Tthickness,d=F625ZDiameter);
		}
		translate([Vthickness+30,9,F625ZDoulbleStack*2+b_height]) color("blue") cylinder(h=50,d=screw5);
		translate([Vthickness+30,9,F625ZDoulbleStack*2+b_height+43]) color("cyan") cylinder(h=5,d=screw5hd);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module 	BearingBracketHorizontalSupport() {
	difference() { // angled support for top
		translate([-11,6.5,F625ZDoulbleStack*2+b_height+30]) rotate([0,45,0]) color("yellow")
			cuboid([20,Tthickness,45],rounding=2,p1=[0,0]);
		translate([-19,6,F625ZDoulbleStack*2+b_height+10]) color("black") cube([20,7,40]);
		translate([-4,6,F625ZDoulbleStack*2+b_height+42]) color("silver") cube([40,7,25]);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

module MotorMountSupport(Side) {
	if(Side)
		translate([-29,24.5,1.5]) rotate([0,46,0]) color("gray") cuboid([6,5,76.5],rounding=2,p1=[0,0]);
	else
		translate([-28,-29.5,1.5]) rotate([0,51,0]) color("gray") cuboid([6,5,69],rounding=2,p1=[0,0]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module PrintString(String,Height=1.5,Size=4,Font="Liberation Sans",Color="coral") { // print something
	color(Color) linear_extrude(height = Height) text(String, font = Font,size=Size);
	//"Babylon Industrial:style=Normal",size=Size);
	//"Liberation Sans",size=Size);
}

/////////////////// emd of MotorAndBearingMounts.scad ////////////////////////////////////