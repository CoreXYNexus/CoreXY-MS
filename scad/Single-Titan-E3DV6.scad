///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Single Titan - titan, titan aero
// created: 2/3/2014
// last modified: 1/4/22
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/12/16	- added bevel on rear carriage for x-stop switch to ride up on
// 5/30/20	- Added ability to use a Titan Aero on mirrored version
// 6/4/20	- Removed some unecessary code
// 8/2/20	- Edited for the CXY-MSv1 files
// 10/13/20	- Changed width of base to allow 42mm long stepper motor
// 1/4/22	- BOSL2
//////////////////////////////////////////////////////////////////////////////////////////////////////////
include <CoreXY-MSv1-h.scad>
use <inc/corner-tools.scad>
include <inc/brassinserts.scad>
//-------------------------------------------------------------------------------------------------------------
Use3mmInsert=1; // set to 1 to use 3mm brass inserts
Use5mmInsert=1;
LargeInsert=1;
HorizontallCarriageWidth=width;
ExtruderThickness = wall;	// thickness of the extruder plate
ShiftTitanUp = -9;	// move motor +up/-down: -13:Titan Aero; -2.5: Titan w/e3dv6
ShiftHotend = 0;		// move hotend opening front/rear
ShiftHotend2 = -20;		// move hotend opening left/right
Spacing = 17; 			// ir sensor bracket mount hole spacing
ShiftIR = -20;			// shift ir sensor bracket mount holes
ShiftBLTouch = 10;		// shift bltouch up/down
ShiftProximity = 5;		// shift proximity sensor up/down
ShiftProximityLR = 3;	// shift proximity sensor left/right
HotendLength = 50;	// 50 for E3Dv6
BoardOverlap = 2.5; // amount ir board overlaps sensor bracket
IRBoardLength = 17 - BoardOverlap; // length of ir board less the overlap on the bracket
IRGap = 0;			// adjust edge of board up/down
HeightIR = (HotendLength - IRBoardLength - IRGap) - irmount_height;	// height of the mount
//---------------------------------------------------------------------------------------------------------
LEDLight=1; // print LED ring mounting with spacer
LEDSpacer=0;  // length need for titan is 8; length need for aero is 0
//==================================================================================================
//**** NOTE: heater blocker on a areo titan: heater side towards fan side
//==================================================================================================

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Extruder(1,5,1);	// arg1: extruderplatform type
					//	0 - flat plate platform for a Wades type extruder
					//	1 - mirrored titan extruder platform
					//	2 - titan extruder platform
					// arg2: sensor type
					//	0 = BLTouch with top mounting, no recess
					//	1 - BLT9ouch with bottom mount in recess
					//	2 - proximity sensor hole in psensord size
					//	3 - dc42's ir sensor
					//	4 - all sensors, except for the ExtruderPlatform()
					//	5 or higher - none
					// arg 3: 0 - titan; 1 - aero
/////////////////////////////////////////////////////////////////////////////////////////

module Extruder(Extruder=1,Sensor=5,Aero=1,Mounting=1) {
	//if($preview) %translate([-100,-100,-5]) cube([200,200,1]);
	if(Extruder == 0)
		ExtruderPlatform(Sensor);	// for BLTouch: 0 = top mounting through hole, 1 - bottom mount in recess
									// 2 - proximity sensor hole in psensord size
									// 3 - dc42's ir sensor
	// args: recess=3,InnerSupport=0,MountingHoles=1,Mirror=0,Aero=0
	if(Extruder == 1) // titan/E3Dv6 combo or titan aero
			MirrorTitanExtruderPlatform(Sensor,0,1,1,Aero,Mounting);
	if(Extruder == 2) // titan/E3Dv6 combo of  titan aero
			MirrorTitanExtruderPlatform(Sensor,0,1,0,Aero,Mounting); // not mirror version
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderPlatform(recess=0) // bolt-on extruder platform
{										 // used for extruder mount via a wades extruder style
	difference() {
		color("red") cuboid([HorizontallCarriageWidth,heightE,wall],rounding=2); // extruder side
		translate([0,-height/3-6,0]) ExtruderPlatformNotch(); // extruder notch
		translate([0,26,10]) rotate([90,0,0]) ExtruderMountHoles(screw3);	// screw holes to mount extruder plate
		// extruder mounting holes
		color("black") hull() {
			translate([extruder/2+2,-heightE/2+14,-8]) cylinder(h = ExtruderThickness+10,r = screw4/2);
			translate([extruder/2-4,-heightE/2+14,-8]) cylinder(h = ExtruderThickness+10,r = screw4/2);
		}
		color("gray") hull() {
			translate([-extruder/2+4,-heightE/2+14,-8]) cylinder(h = ExtruderThickness+10,r = screw4/2);
			translate([-extruder/2-2,-heightE/2+14,-8]) cylinder(h = ExtruderThickness+10,r = screw4/2);
		}
		//translate([0,26,41+wall/2])
		translate([-50,28,45]) rotate([90,0,0]) FanMountHoles(Yes3mmInsert(Use3mmInsert,LargeInsert));
		if(recess==0 || recess==1) translate([0,-4,0]) BLTouch_Holes(recess);
		if(recess == 2) translate([0,10,-6]) color("pink") cylinder(h=wall*2,r=psensord/2); // proximity sensor
	}
	if(recess == 3) { // dc42's ir sensor mount
		translate([irmount_width/2,5,0]) rotate([90,0,180]) IRAdapter();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderPlatformNotch() {
	color("blue") minkowski() {
		cube([25,60,wall+5],true);
		cylinder(h = 1,r = 5);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanExtruderPlatform(recess=2,InnerSupport=0,MountingHoles=1,Aero=0,Mounting) {
	// extruder platform for e3d titan with (0,1)BLTouch or (2)Proximity or (3)dc42's ir sensor
	difference() {
		union() {
			translate([-37.5+17,-37,-wall/2]) color("cyan")
				cuboid([HorizontallCarriageWidth+ShiftHotend2/1.3-12,heightE+8,wall],rounding=2,p1=[0,0]); // extruder side
			translate([14,23,-wall/2]) color("plum") cuboid([23,wall,wall],rounding=2,p1=[0,0]);
			translate([-38,23,-wall/2]) color("blue") cuboid([25,wall,wall],rounding=2,p1=[0,0]);
		}
		//if(MountingHoles && Yes3mmInsert(Use3mmInsert,LargeInsert)==screw3)
		if(Mounting) translate([0,27,10]) rotate([90,0,0]) ExtruderMountHoles();
 		if(LEDLight) LEDRingMount();
		if(Aero) {
			translate([-19,3,-5]) color("purple") cylinder(wall*2,d=30); // clearance for aero titan e3dv6 heater block
			translate([-19,3,wall/2]) color("purple") fillet_r(2,15,-1,$fn);	// round top edge
			translate([-19,3,-wall/2]) color("purple") rotate([180]) fillet_r(2,15,-1,$fn);	// round bottom edge
		} else {
			translate([20+ShiftHotend2,-5,-10]) color("pink") cylinder(h=20,d=23.5); // remove some under the motor
			translate([0,-5,wall/2]) color("purple") fillet_r(2,23/2,-1,$fn);	// round top edge
			translate([0,-5,-wall/2]) color("purple") rotate([180]) fillet_r(2,23/2,-1,$fn);	// round bottom edge
		}
	    
		
		translate([-13,80,0]) IRMountHoles(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
		translate([-17,20,44.5]) rotate([90,0,0]) PCFanMounting(Yes3mmInsert(Use3mmInsert,LargeInsert));
		if(!Use3mmInsert) translate([15,15,0]) rotate([90,0,0]) PCFanNutHoles(nut3);

	}
	if(LEDLight && LEDSpacer) translate([30,10,-4]) ScrewSpacer(LEDSpacer,screw5);
	difference() {
		translate([ShiftHotend2-0.5,-32,0]) rotate([90,0,90]) TitanMotorMount(0,0,InnerSupport);
		translate([-13,73,0]) IRMountHoles(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
		translate([-17,20,44.5]) rotate([90,0,0]) PCFanMounting(Yes3mmInsert(Use3mmInsert,LargeInsert));
	}
	DoSensorMount(recess);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DoSensorMount(recess=2) {
	if(recess == 0 || recess == 1) translate([-13,40,-wall/2]) BLTouchMount(recess,ShiftBLTouch); // BLTouch mount
	if(recess == 2) translate([10,45,-wall/2]) ProximityMount(ShiftProximity); // mount proximity sensor
	if(recess == 3) { // ir mount
		translate([0,33,-wall/2]) difference() {
			IRAdapter(0,HeightIR);
			translate([25,4,40]) rotate([90,0,0]) IRMountHoles(Yes3mmInsert(Use3mmInsert,LargeInsert));
		}
	}
	if(recess==4) {
		translate([-50,37,-wall/2]) BLTouchMount(0,ShiftBLTouch); // BLTouch mount
		translate([39,55,-wall/2]) ProximityMount(ShiftProximity); // mount proximity sensor
		translate([10,35,-wall/2]) difference() { // ir mount
			IRAdapter(0,HeightIR);
			translate([25,4,40]) rotate([90,0,0]) IRMountHoles(Yes3mmInsert(Use3mmInsert,LargeInsert));
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MirrorTitanExtruderPlatform(recess=2,InnerSupport=0,MountingHoles=1,Mirror=0,Aero=0,Mounting=1) {
	if(Mirror) {
		mirror([1,1,0]) {// reverse the platform to have the titan adjusting screw to the front
			rotate([0,0,90]) TitanExtruderPlatform(recess,InnerSupport,MountingHoles,Aero,Mounting);
		}
	} else {
		TitanExtruderPlatform(recess,InnerSupport,MountingHoles,Aero);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanMountHoles(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert),Left=1) {	// fan mounting holes
	ScrewL=20;
	translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
		rotate([0,90,0]) color("pink") cylinder(h =ScrewL,d = Screw);
	translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
		rotate([0,90,0]) color("skyblue") cylinder(h = ScrewL,d = Screw);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanNutHoles(Nut=nut3,Left=1) {	// fan mounting holes
	translate([0,-10,0]) rotate([0,90,0]) color("blue") hull() {	// nut trap for fan
		nut(nut3,3);
		translate([0,18,0]) nut(nut3,3);
	}
	translate([0,-10,fan_spacing]) rotate([0,90,0]) color("plum") hull() {	// nut trap for fan
		nut(nut3,3);
		translate([0,18,0]) nut(nut3,3);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRMountHoles(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) // ir screw holes for mounting to extruder plate
{
	translate([Spacing,-107,0]) rotate([90,0,0]) color("blue") cylinder(h=20,d=Screw);
	translate([0,-107,0]) rotate([90,0,0]) color("red") cylinder(h=20,d=Screw);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BLTouch_Holes(recess=0) {
	if(recess == 1) {	// dependent on the hotend, for mounting under the extruder plate
		translate([-bltl/2+3,bltw/2+3,bltdepth]) color("cyan") minkowski() { // depression for BLTouch
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LEDRingMount(Screw=Yes3mmInsert(Use5mmInsert)) {
	// a mounting hole for a holder for 75mm circle led
	translate([30.5+ShiftHotend2,2+ShiftHotend,-10]) color("lightgray") cylinder(h=20,d=Screw);
	if(!Use5mmInsert) translate([30.5+ShiftHotend2,12.5+ShiftHotend,1.5]) color("black") nut(nut5,5);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PCFanMounting(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) {
		translate([-extruder/2+54,-heightE/2 - 1.8*wall,heightE - extruder_back - PCfan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("red") cylinder(h = 20,d = Yes3mmInsert(Use3mmInsert,LargeInsert));
		translate([-extruder/2+54,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("blue") cylinder(h = 20,d = Yes3mmInsert(Use3mmInsert,LargeInsert));
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module ScrewSpacer(Length=10,Screw=screw5) {
	difference() {
		color("blue") cylinder(h=Length,d=Screw*2,$fn=100);
		translate([0,0,-2]) color("red") cylinder(Length+4,d=Screw,$fn=100);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanMotorMount(WallMount=0,Screw=screw4,InnerSupport=1) {
	difference() {	// motor mount
		translate([-1,0,0]) color("red") cuboid([54,60+ShiftTitanUp,5],rounding=2,p1=[0,0]);
		translate([25,35+ShiftTitanUp,-1]) rotate([0,0,45]) color("purple") NEMA17_x_holes(8,1);
		if(ShiftTitanUp > -2.6) {
			color("blue") hull() {
				translate([14,5,0]) cylinder(h=wall*2,d=20); // hotend cooling hole
				translate([37,5,0]) cylinder(h=wall*2,d=20); // hotend cooling hole
			}
		}
	}
	TitanMountSupports(WallMount,InnerSupport,Screw);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanMountSupports(WallMount=0,InnerSupport=0,Screw=screw4) {
	if(WallMount) {
		difference() { // front support
			translate([52,0,0]) color("cyan") cuboid([4,45+ShiftTitanUp,45],rounding=2,p1=[0,0]);
			// lower mounting screw holes
			translate([40,15,11]) rotate([0,90,0]) color("cyan") cylinder(h=20,d=Screw);
			translate([40,15,11+mount_seperation]) rotate([0,90,0])  color("blue") cylinder(h=20,d=Screw);
			if(Screw==screw4) { // add screw holes for horizontal extrusion
				translate([40,15+mount_seperation,34]) rotate([0,90,0]) color("red") cylinder(h=20,d=Screw);
				translate([40,15+mount_seperation,34-mount_seperation]) rotate([0,90,0])  color("pink") cylinder(h=20,d=Screw);
			}
		}
	} else {
		if(!InnerSupport) TitanSupport(0,Yes3mmInsert(Use3mmInsert,LargeInsert));
		translate([-50,0,0]) TitanSupport(1,Yes3mmInsert(Use3mmInsert,LargeInsert));
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanSupport(Clear=0, Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) {
	difference() { // rear support
		translate([49,47.5,-1.5]) rotate([50]) color("cyan") cuboid([4,6,69],rounding=2,p1=[0,0]);
		translate([47,-1,-67]) color("gray") cube([7,70,70]);
		translate([47,-73,-26]) color("lightgray") cube([7,75,75]);
		if(Clear) translate([44,44.5,75]) rotate([0,90,0]) PCFanMounting(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert));
	}
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHoles(Screw=screw3,All=1) {		// screw holes to mount extruder plate
	translate([0,0,0]) rotate([90,0,0]) color("blue") cylinder(h = 20, d = Screw);
	translate([HorizontallCarriageWidth/2-5,0,0]) rotate([90,0,0]) color("red") cylinder(h = 20, d = Screw);
	translate([-(HorizontallCarriageWidth/2-5),0,0]) rotate([90,0,0]) color("black") cylinder(h = 20, d = Screw);
	if(All) {	
		translate([HorizontallCarriageWidth/4-2,0,0]) rotate([90,0,0]) color("gray") cylinder(h = 20, d = Screw);
		translate([-(HorizontallCarriageWidth/4-2),0,0]) rotate([90,0,0]) color("cyan") cylinder(h = 20, d = Screw);
	}
}

