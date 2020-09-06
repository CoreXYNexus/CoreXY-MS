/////////////////////////////////////////////////////////////////////////////////////////////////////
// SensorAndFanMounts.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////
// created: 6/2/1019
// last update: 8/30/20
////////////////////////////////////////////////////////////////////////////////////////////////////
// 6/2/19	- Separated from single_titan_extruder_mount.scad
// 4/12/20	- Made the mount to extruder plate the same for Proximity & BLTouch
// 8/4/20	- Adjsuted the sensor mount holes to the extruder platform
// 8/17/20	- Copied and edited from M-Max and added an adjustable mount for dc42's ir sensor
// 8/30/20	- Added an adjustable BLTouch mount
///////////////////////////////////////////////////////////////////////////////////////////////////
include <CoreXY-MSv1-h.scad>
use <inc/corner-tools.scad>
use <fanduct_v3.scad>
Use2mmInsert=0;
//Use3mmInsert=1; // set to 1 to use 3mm brass inserts
Use4mmInsert=1; // set to 1 to use 4mm brass inserts
Use5mmInsert=1; // set to 1 to use 5mm brass inserts
include <brassfunctions.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////////////////////////////////////

//ProximityMount(6); // arg is shift up/down (min:2)
//BLTouchMount(0,10);	// 1st arg:type; 2nd: shift
//IRAdapter(0,0);
// Titan with E3Dv6
//AdjustableBLTMount(10,2,0); //Shift=0 (add to 10),Type=2,DoBase= 0 (no) : 1 (yes)
AdjustableProximtyMount(20,0); //Shift=0,DoBase= 0 (no) : 1 (yes)
// Titan Aero -- not tested
//AdjustableBLTMount(0,2,0); //Shift=0 (add to 10),Type=2,DoBase= 0 (no) : 1 (yes)
//AdjustableProximtyMount(0,0); //Shift=0,DoBase= 0 (no) : 1 (yes)
//AdjustableIRMount();
//FanAndProximityMount(8);//**broken** // arg is shift up/down (min:2) *** blocks e3dv6 fan ***

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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRMountHoles(Screw=screw3) { // ir screw holes for mounting to extruder plate
	translate([spacing+shiftir+shifthotend,-25,0]) rotate([90,0,0]) color("red") cylinder(h=25,d=Screw);
	translate([shiftir+shifthotend,-25,0]) rotate([90,0,0]) color("blue") cylinder(h=25,d=Screw);
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
		ReduceIR(Taller);
		IRMountingHoles(Taller);
		RecessIR(Taller);
		translate([24.5,4,45]) rotate([90,0,0]) IRMountHoles(screw3);
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
		translate([0,-27,0]) SensorMount(Shift,3);
		AdjustHoles(Yes3mmInsert());
	}
	difference() { // reinforce for the nylock nut
		translate([46.5,3,0]) color("plum") cylinder(h=11,d=10);
		AdjustHoles(Yes3mmInsert());
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
		translate([-30,-11,5+Shift]) AdjustHoles(Yes3mmInsert(),0);
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

module AdjustHoles(Screw=Yes3mmInsert(),DoNut=1) {
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

module IRMountingHoles(Taller=0) { // mounting screw holes for the ir sensor
	translate([hole1x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("black") cylinder(h=20,r=screw3/2);
	translate([hole2x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("white") cylinder(h=20,r=screw3/2);
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

module SensorMount(Shift=0,Thicker=0) {
	difference() {
		translate([0,26,0]) color("cyan") cubeX([60,5+Thicker,13+Shift],2);
		translate([27,60,8+Shift]) IRMountHoles(screw3);
		translate([27,53,8+Shift]) IRMountHolesCS(screw3hd);
		//translate([57,60,8+Shift]) IRMountHoles(screw3);
		//translate([57,53,8+Shift]) IRMountHolesCS(screw3hd);
	}
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

module BLTouchMount(Type,Shift) {
	difference() {
		translate([-5,0,0]) color("salmon") cubeX([40,30,5],2);
		if(Type==0) translate([15,0,bltdepth+3]) BLTouch_Holes(Type);//BLTouchMountHole(Type); // blt body hole
		if(Type==1) translate([15,0,bltdepth+3]) BLTouch_Holes(Type);//BLTouchMountHole(Type); // no blt body hole
	}
	if(Type==1) BLTouchSupport();
	SensorMount(Shift);
	BLTouchAngleSupport();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchSupport() {
	translate([0,7.5,4]) color("green") cube([bltl,bltw,LayerThickness]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouchAngleSupport() {
	translate([2,21,5]) {
		difference() {
			color("plum") cube([28,5,5]);
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

module BLTouch_Holes(recess=0,Screw=Yes2p5mmInsert()) {
	if(recess == 2) {	// mounting screw holes only
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,d=Screw);
		translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,d=Screw);
		translate([bltouch/2-9,16,-10]) color("black") cylinder(h=25,d=screw5); // adjuster access
	}
	if(recess == 1) {	// dependent on the hotend, for mounting under the extruder plate
		translate([-bltl/2+3,bltw/2+2.5,bltdepth-4]) color("cyan") minkowski() { // depression for BLTouch
			// it needs to be deep enough for the retracted pin not to touch bed
			cube([bltl-6,bltw-6,wall]);
			cylinder(h=1,r=3);
		}
		translate([-bltl/2+8,bltw/2,-5]) color("blue") cube([bltd,bltd+1,wall+3]); // hole for BLTouch
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,r=screw2/2);
		translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,r=screw2/2);

	}
	if(recess == 0) {	// for mounting on top of the extruder plate
		translate([-bltl/2+8,bltw/2,-5]) color("blue") cube([bltd,bltd+1,wall+3]); // hole for BLTouch
		translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,r=screw2/2);
		translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,r=screw2/2);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////