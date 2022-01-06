/////////////////////////////////////////////////////////////////////////////////////////////////////
// SensorMounts.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////
// created: 6/2/1019
// last update: 11/27/21
////////////////////////////////////////////////////////////////////////////////////////////////////
// 6/2/19	- Separated from single_titan_extruder_mount.scad
// 4/12/20	- Made the mount to extruder plate the same for Proximity & BLTouch
// 8/4/20	- Adjsuted the sensor mount holes to the extruder platform
// 8/17/20	- Copied and edited from M-Max and added an adjustable mount for dc42's ir sensor
// 8/30/20	- Added an adjustable BLTouch mount
// 10/15/20	- Added IR mount for titan aero (mounts on printed extruder mount)
// 9/18/21	- Added a bltount mount for the bmg extruder
// 11/27/21	- Added BMGIRMount() for dc42's IR Sensor
////////////////////////////////////////////////////////////////////////////////////////////////////
include <CoreXY-MSv1-h.scad>
use <fanduct_v3.scad>
include <inc/brassinserts.scad>
////////////////////////////////////////////////////////////////////////////////////////////////
// -- BLTouch 3.1 trigger position: 47.5 +-0.5; retracted 40mm-40.3mm
//*****************************************************
// adjustable proximity mount need beefing up 9/19/20
//*****************************************************
$fn=100;
psensornut = 28; 	// size of proximity sensor nut
FanSpacing = 32;	// hole spacing for a 40mm fan
PCfan_spacing = 47;	//FanSpacing+15;
DuctLength=25; 		// set length of 50150 fan duct
Thickness = 6.5;
MHeight = 6;
MWidth = 60;
FHeight = 10;
MountingHoleHeight = 60; 	// screw holes may need adjusting when changing the front to back size
ExtruderOffset = 18;		// adjusts extruder mounting holes from front edge
IRSpacing=spacing;
LayerThickness=0.3; // layer thickness
Spacing = 17; 			// ir sensor bracket mount hole spacing
//------------------------------------------------------------------------------------------------
Use2p5mmInsert=1;
Use3mmInsert=1; // set to 1 to use 3mm brass inserts
LargeInsert=0;
//Use4mmInsert=1; // set to 1 to use 4mm brass inserts
//Use5mmInsert=1; // set to 1 to use 5mm brass inserts
//-----------------------------------------------------------------------------------------
StepperHoleOffset=31;
////////////////////////////////////////////////////////////////////////////////////////////////////////////

//ProximityMount(6); // arg is shift up/down (min:2)
//BLTouchMount(2,20,1);	// 1st arg:type; 2nd: shift; BLTouch v3.1
//IRAdapter(0,0);
//IRAdapterAero(0);
//Spacer(3,7);
//BMGBLTMount(7); // uses 50mm M3 screws to mount to extruder
BMGIRMount(20); // uses 50mm M3 screws to mount to extruder

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module BMGIRMount(Offset=5) { // X-24 Y0; 230/70; Z1 -- print upside down
	difference() {
		union() {
			translate([0,-Offset-10,0]) color("cyan") cuboid([StepperHoleOffset+10,20+Offset,12],rounding=2,p1=[0,0]);
			//translate([0,-5-Offset,4]) color("plum") cuboid([StepperHoleOffset+10,10+Offset,5],rounding=2,p1=[0,0]);
			//translate([0,-Offset,0]) color("khaki") cuboid([StepperHoleOffset+10,5,25],rounding=2,p1=[0,0]);
		}
		translate([(StepperHoleOffset+20)/2-2,-23,-7]) color("plum") rotate([90,0,0])
			cyl(l=50, d=35, rounding=2); // hotend clearance
		translate([(StepperHoleOffset+20)/2-2,-8,-5]) color("purple")
			cuboid([20,10,15], rounding=2,p1=[0,0]); // berdair mount notch
		translate([5,5,-5]) color("blue") cylinder(h=20,d=screw3);
		translate([StepperHoleOffset+5,5,-5]) color("red") cylinder(h=20,d=screw3);
		translate([5,5,10.5]) color("red") cylinder(h=15,d=screw3hd);
		translate([StepperHoleOffset+5,5,10.5]) color("blue") cylinder(h=15,d=screw3hd);
		translate([14,-Offset-5,15]) rotate([90,90,0]) rotate([0,0,90])
			IRMountHoles(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert));
		union() {
			translate([(StepperHoleOffset+10)/2+2,-6,2]) color("pink") // fan exhaust notch
				cyl(h=20,d=16,rounding=-2);
			translate([(StepperHoleOffset+10)/2+2,-7,2]) color("green") // fan exhaust notch
				cyl(h=20,d=16,rounding=-2);
			translate([(StepperHoleOffset+10)/2+2,-9,2]) color("blue") // fan exhaust notch
				cyl(h=20,d=16,rounding=-2);
			translate([(StepperHoleOffset+10)/2+2,-11,2]) color("white") // fan exhaust notch
				cyl(h=20,d=16,rounding=-2);
			translate([(StepperHoleOffset+10)/2+2,-12,2]) color("gray") // fan exhaust notch
				cyl(h=20,d=16,rounding=-2);
		}
	}
	translate([5,5,10.5-LayerThickness]) color("blue") cylinder(h=LayerThickness,d=screw3hd); // support
	translate([StepperHoleOffset+5,5,10.5-LayerThickness]) color("red") cylinder(h=LayerThickness,d=screw3hd); // support
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////

module BMGBLTMount(Offset=5) { // X-24 Y0; 230/70: Z1
	difference() {
		union() {
			translate([0,-Offset,0]) color("cyan") cuboid([StepperHoleOffset+10,10+Offset,12],rounding=2,p1=[0,0]);
			//translate([0,-5-Offset,4]) color("plum") cuboid([StepperHoleOffset+10,10+Offset,5],rounding=2,p1=[0,0]);
			translate([0,-Offset,0]) color("khaki") cuboid([StepperHoleOffset+10,5,25],rounding=2,p1=[0,0]);
		}
		translate([(StepperHoleOffset+20)/2-2,-7,-7]) color("plum") rotate([90,0,0])
			cyl(l=15, d=30, rounding=2);  // hotend clearance
		translate([(StepperHoleOffset+20)/2-2,-9.5,-7]) color("purple")
			cuboid([20,10,15], rounding=2,p1=[0,0]);  // berdair mount notch
		translate([5,5,-5]) color("blue") cylinder(h=20,d=screw3);
		translate([StepperHoleOffset+5,5,-5]) color("red") cylinder(h=20,d=screw3);
		translate([5,5,10.5]) color("red") cylinder(h=15,d=screw3hd);
		translate([StepperHoleOffset+5,5,10.5]) color("blue") cylinder(h=15,d=screw3hd);
		translate([23,-Offset,0]) rotate([90,90,0]) rotate([0,0,90]) BLTouch_Holes(2,Yes2p5mmInsert(Use2p5mmInsert));
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Spacer(Qty=1,Thickness=5,Screw=screw3,BottomSize=3) {
	for(x = [0:Qty-1]) {
		translate([0,x*15,0]) difference() {
			color("cyan") hull() {
				cylinder(h=0.5,d=Screw*BottomSize);
				translate([0,0,Thickness]) cylinder(h=1,d=Screw*2);
			}
			translate([0,0,-2]) color("plum") cylinder(h=Thickness+5,d=Screw);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Short_Motor_Version(Duct=0,Move=0,Raise=0,Back=0,Offset=0) {
	FanBlowerMount(Move,Raise,Back);
	if(Duct) translate([0,12,0]) color("red") FanDuct_v3(DuctLength);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BracketMount_v2(Move=0) {
	translate([3,10,FHeight/4+0.3]) rotate([90,0,0]) color("red") cylinder(h = 18,r = screw3/2,$fn=50);
	translate([3,1,FHeight/4+0.3]) rotate([90,0,0]) color("gray") cylinder(h = 18,r = screw3hd/2,$fn=50);
	translate([3+PCfan_spacing,10,FHeight/4+0.3]) rotate([90,0,0]) color("blue") cylinder(h = 18,r = screw3/2,$fn=50);
	translate([3+PCfan_spacing,1,FHeight/4+0.3]) rotate([90,0,0]) color("plum") cylinder(h = 18,r = screw3hd/2,$fn=50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module FanBlowerMount(Move=0,Raise=0,Back=0,X=0,Y=0,Z=0,Spacer=0,Offset=0) {
	if(Spacer) {
		difference() {
			translate([Move+6,-30+Back,0]) color("gray") cubeX([21,21-Back,Raise+Z+5],1);
			RemoveForBlower(Move+6,Raise,Spacer);
			translate([Move+X,-14-Back+Y,Raise+Z]) rotate([0,90,0]) color("purple") cylinder(h=42,r=screw4/2,$fn=50);
			translate([Move+2,-40+Back,10]) rotate([-45,0,0]) color("black") cube([30,30,10]);
		}
		//difference() {
		//	translate([Move+6,Offset+2,0]) color("lightgray") cubeX([21,Offset,Thickness],1);
		//	translate([0,0,0.5]) BracketMount(Move);
		//	translate([5,-5-Offset,0]) color("plum") cube([30,20,20]);
		//}
	} else {
		difference() {
			translate([Move,-16+Back,0]) color("gray") cubeX([21,21-Back,Raise+4],2);
			RemoveForBlower(Move,Raise);
			translate([Move+X-3,-Back+Y,Raise+Z]) rotate([0,90,0]) color("purple") cylinder(h=42,r=screw4/2,$fn=50);
			translate([Move-5,-29+Back,9]) rotate([-45,0,0]) color("black") cube([30,30,10]);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RemoveForBlower(Move=0,Raise=0,Spacer=0) {
	if(Spacer) {
		translate([Move+3,-57,-10]) color("yellow") cubeX([15,45,Raise*2],1);
		//translate([Move+3,-15.5,-17]) rotate([35,0,0]) color("lightgreen") cubeX([15,15,15],1);
	} else {
		translate([Move+3,-45,-10]) color("yellow") cubeX([15,45,Raise*2],1);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanMountHoles(Screw=screw3,Left=1) {	// fan mounting holes
	if(Left) {
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = 3*(ExtruderThickness+screw_depth),d = Screw);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = 3*(ExtruderThickness+screw_depth),d = Screw);
	} else { // one side fan mounting holes
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = ExtruderThickness+screw_depth,d = Screw);
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = ExtruderThickness+screw_depth,d = Screw);

	}
	translate([-38,-44.5,20]) rotate([0,90,0]) color("plum") nut(nut3,5);	// nut trap for fan
	translate([-38.5,-44.5,52]) rotate([0,90,0]) color("blue") hull() {	// nut trap for fan
		nut(nut3,2.55);
		translate([0,8,0]) nut(nut3,2.5);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanMountHolesPlatform(Screw=screw3,Left=1) {	// fan mounting holes
	if(Left) {
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = 3*(ExtruderThickness+screw_depth),d = Screw);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = 3*(ExtruderThickness+screw_depth),d = Screw);
	} else { // one side fan mounting holes
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = ExtruderThickness+screw_depth,d = Screw);
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = ExtruderThickness+screw_depth,d = Screw);

	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanNutHoles(Nut=nut3,Left=1) {	// fan mounting holes
	rotate([0,90,0]) color("blue") hull() {	// nut trap for fan
		nut(nut3,2.55);
		translate([0,8,0]) nut(nut3,2.5);
	}
	translate([0,0,fan_spacing]) rotate([0,90,0]) color("plum") hull() {	// nut trap for fan
		nut(nut3,2.55);
		translate([0,8,0]) nut(nut3,2.5);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRMountHoles(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) // ir screw holes for mounting to extruder plate
{
	translate([Spacing,0,0]) rotate([90,0,0]) color("blue") cylinder(h=20,d=Screw);
	translate([0,0,0]) rotate([90,0,0]) color("red") cylinder(h=(20),d=Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRMountHolesCS(Screw=screw3hd) { // ir screw holes for mounting to extruder plate
	translate([spacing+shiftir+shifthotend,-25,0]) rotate([90,0,0]) color("blue") cylinder(h=5,d=Screw);
	translate([shiftir+shifthotend,-25,0]) rotate([90,0,0]) color("red") cylinder(h=5,d=Screw);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRAdapter(Top,Taller=0) {  // ir sensor bracket stuff is from irsensorbracket.scad
	difference() {
		color("plum") cubeX([irmount_width,irmount_height+Taller,irthickness],2); // mount base
		if(Taller>=0) ReduceIR(Taller);
		IRMountingHoles(Taller);
		RecessIR(Taller);
		translate([5,4,13]) rotate([90,0,0]) IRMountHoles(screw3); // tp mount on to the extruder mount
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRAdapterAero(Taller=0) {  // ir sensor bracket stuff is from irsensorbracket.scad
	difference() {
		translate([0,0,0]) rotate([90,180,180])  SensorMount(0,0,0);
		translate([0,-13,-32]) IRMountingHoles(Taller,Yes2p5mmInsert(Use2p5mmInsert));
		translate([0,-13,-32.5]) color("blue") RecessIR(Taller);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AdjustableIRMount(Shift=0) {  // adjuster screw has spring between the parts and a lock nut on the bottom
	echo("dc42's IR");
	AdjustSensorBaseMount(Shift);
	//translate([33,-5,0]) { // show in place
	translate([33,-5,0]) rotate([90,0,0]) { // printable placement
		difference() {
			union() {
				color("pink") cubeX([irmount_width,4,30],2);
				translate([0,0,25]) color("plum") cubeX([irmount_width,15,5],2);
			}
			translate([-33,5,20]) AdjustHoles(screw3);
			translate([25,40,3]) IRMountHoles(screw3);
			translate([0,-28,-5]) RecessIR(0);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AdjustSensorBaseMount(Shift=0) {
	difference(){  // base mount
		translate([0,-28,0]) SensorMount(Shift,3);
		AdjustHoles(Yes3mmInsert(Use3mmInsert,LargeInsert));
	}
	difference() { // reinforce for the nylock nut
		translate([46.5,3,0]) color("plum") cylinder(h=11,d=10);
		AdjustHoles(Yes3mmInsert(Use3mmInsert,LargeInsert));
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AdjustableBLTMount(Shift=0,Type=2,DoBase=0) {  // adjuster screw has spring between the parts and a lock nut on the bottom
	echo("BLTouch");
	echo("type:",Type);
	if(DoBase) AdjustSensorBaseMount();
	translate([-5,0,0]) rotate([0,-90,0]) BLTMount(Shift,Type);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AdjustableProximtyMount(Shift=0,DoBase=0) { // shift not used
	if(DoBase) translate([0,40,0]) AdjustSensorBaseMount();
	rotate([0,-90,0]) difference() {
		union() {
			color("red") cubeX([32,33,5],2);
			color("purple") cubeX([32,5,15+Shift],2);
			translate([0,-15,10+Shift]) color("cyan") cubeX([32,20,5],2);
			translate([0,-3,31]) rotate([-90,0,0]) ProximityAngleSupport();
			translate([0,8,-16+Shift]) rotate([90,0,0]) ProximityAngleSupport();
		}
		translate([-30,-11,5+Shift]) AdjustHoles(Yes3mmInsert(Use3mmInsert,LargeInsert),0);
		translate([16,18,-2]) color("olive") cylinder(h=wall*2,d=psensord); // proximity sensor hole
		translate([16,18,-3]) color("blue") cylinder(h=5,d=psensornut,$fn=6); // proximity nut
	}

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTMount(Shift=0,Type=2) {
	difference() {
		union() {
			color("plum") cubeX([irmount_width+10,20,5],2);
			color("blue") cubeX([irmount_width+10,5,15+Shift],2);
			translate([0,-15,10+Shift]) color("green") cubeX([irmount_width+10,20,5],2);
		}
		translate([-28,9,-2]) AdjustHoles(screw3,0);
		translate([18,-23,10+Shift]) BLTouch_Holes(Type);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AdjustHoles(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert),DoNut=1) {
	translate([38,3,-2]) color("blue") rotate([0,0,0]) cylinder(h=20,d=Screw);
	translate([46.5,3,-2]) color("red") rotate([0,0,0]) cylinder(h=20,d=screw3);
	translate([55,3,-2]) color("green") rotate([0,0,0]) cylinder(h=20,d=Screw);
	if(DoNut) translate([46.5,3,-5]) color("black") cylinder(h=10,d=nut3,$fn=6);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RecessIR(Taller=0) { // make space for the thru hole pin header
	translate([hole1x+5,hole1y+irrecess+(irmount_height/4)+Taller,irnotch_d]) color("cyan") cube([11.5,10,5]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ReduceIR(Taller=0) { // reduce plastic usage and gives somewhere for air to go if using an all-metal hotend w/fan
	translate([13.5,irmount_height-irreduce+Taller/2,-1]) color("teal") cylinder(h=10,r = irmount_width/4);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRMountingHoles(Taller=0,Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) { // mounting screw holes for the ir sensor
	translate([hole1x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("black") cylinder(h=20,d=Screw);
	translate([hole2x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("white") cylinder(h=20,d=Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ProximityMount(Shift=0) {
	difference() {
		translate([0,-2.5,0]) color("red") cubeX([32,32,8],2);
		translate([16,12,-2]) color("olive") cylinder(h=wall*2,d=psensord); // proximity sensor hole
		translate([16,12,4.5]) color("blue") cylinder(h=5,d=psensornut,$fn=6); // proximity nut
	}
	SensorMount(Shift);
	ProximityAngleSupport();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module SensorMount(Shift=0,Thicker=0,NoTab=0) {
	difference() {
		translate([0,26,0]) color("cyan") cubeX([60,5+Thicker,13+Shift],2);
		//translate([27,60,8+Shift]) IRMountHoles(screw3);
		//translate([27,53,8+Shift]) IRMountHolesCS(screw3hd);
		translate([37,40,8+Shift]) IRMountHoles(screw3);
		translate([57,53,8+Shift]) IRMountHolesCS(screw3hd);
	}
	if(NoTab) translate([58,28.5,0]) color("black") cylinder(h=LayerThickness,d=15);  // support tab
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ProximityAngleSupport() {
	translate([2,21,8]) {
		difference() {
			color("plum") cube([28,5,5]);
			translate([-1,0.5,4]) rotate([0,90,0]) color("pink") cylinder(h=35,d=10,$fn=100);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchMount(Type,Shift,NoTab=1) {
	difference() {
		translate([0,0,0]) color("salmon") cubeX([26,25,5],2);
		translate([13,-4,bltdepth+3]) BLTouch_Holes(Type);
	}
	if(Type==1) BLTouchSupport();
	translate([0,-5,0]) SensorMount(Shift,0,NoTab);
	translate([0,-5,0]) BLTouchCurvedSupport();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchSupport() {
	translate([1,4,4]) color("green") cube([bltl-6,bltw,LayerThickness]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchCurvedSupport() {
	translate([2,21,5]) {
		difference() {
			color("plum") cube([22,5,5]);
			translate([-1,0.5,4]) rotate([0,90,0]) color("pink") cylinder(h=35,d=10,$fn=100);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
module BLTouchBracketMountHoles(Shift) {
	translate([-15,0,Shift+44.5]) rotate([90,0,90]) FanMountHoles();
	translate([25,70,Shift]) IRMountHoles(screw3);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouch_Holes(recess=0,Screw=Yes2p5mmInsert(Use2p5mmInsert)) {
	if(recess == 2) {	// mounting screw holes only
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,d=Screw);
		translate([-bltouch/2,16,-10]) color("gray") cylinder(h=25,d=Screw);
		translate([bltouch/2-9,16,-10]) color("white") cylinder(h=25,d=screw5); // adjuster access
	}
	//if(recess == 1) {	// dependent on the hotend, for mounting under the extruder plate
	//	translate([-bltl/2+3,bltw/2+2.5,bltdepth-4]) color("cyan") minkowski() { // depression for BLTouch
	//		// it needs to be deep enough for the retracted pin not to touch bed
	//		cube([bltl-6,bltw-6,wall]);
	//		cylinder(h=1,r=3);
	//	}
	//	translate([-bltl/2+8,bltw/2,-5]) color("blue") cube([bltd+1.5,bltd+1.5,wall+3]); // hole for BLTouch
	//	translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,r=screw2/2);
	//	translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,r=screw2/2);
	//}
	if(recess == 0) {	// for mounting on top of the extruder plate
		translate([-bltl/2+8,bltw/2-1,-5]) color("blue") cube([bltd,bltd+2,wall+3]); // hole for BLTouch
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,d=Screw);
		translate([-bltouch/2,16,-10]) color("lightgray") cylinder(h=25,d=Screw);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////