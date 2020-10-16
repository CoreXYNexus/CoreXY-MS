///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Dual Titan - titan w/e3dv6 or titan aero
// created: 10/14/2020
// last modified: 10/14/20
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/12/16	- added bevel on rear carriage for x-stop switch to ride up on
// 5/30/20	- Added ability to use a Titan Aero on mirrored version
// 6/4/20	- Removed some unecessary code
// 8/2/20	- Edited for the CXY-MSv1 files
// 10/13/20	- Changed width of base to allow 42mm long stepper motor
// 10/14/20	- Converted to single to dual
//////////////////////////////////////////////////////////////////////////////////////////////////////////
include <CoreXY-MSv1-h.scad>
include <inc/brassinserts.scad>
//-------------------------------------------------------------------------------------------------------------
Use3mmInsert=1; // set to 1 to use 3mm brass inserts
Use5mmInsert=1;
LargeInsert=1;
HorizontallCarriageWidth=width;
ExtruderThickness = wall;	// thickness of the extruder plate
//ShiftTitanUp = -9;	// move motor +up/-down: -13:Titan Aero; -2.5: Titan w/e3dv6
//ShiftHotend = 0;		// move hotend opening front/rear
//ShiftHotend2 = -20;		// move hotend opening left/right
Spacing = 17; 			// ir sensor bracket mount hole spacing
//ShiftIR = -20;			// shift ir sensor bracket mount holes
//ShiftBLTouch = 10;		// shift bltouch up/down
//ShiftProximity = 5;		// shift proximity sensor up/down
//ShiftProximityLR = 3;	// shift proximity sensor left/right
//HotendLength = 50;	// 50 for E3Dv6
//BoardOverlap = 2.5; // amount ir board overlaps sensor bracket
//IRBoardLength = 17 - BoardOverlap; // length of ir board less the overlap on the bracket
//IRGap = 0;			// adjust edge of board up/down
//HeightIR = (HotendLength - IRBoardLength - IRGap) - irmount_height;	// height of the mount
//---------------------------------------------------------------------------------------------------------
LEDLight=1; // print LED ring mounting with spacer
LEDSpacer=0;//8;  // length need for titan is 8; length need for aero is 0
//==================================================================================================
//**** NOTE: heater blocker on a areo titan: heater side towards fan side
//==================================================================================================

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

DualExtruder(1,1);	// arg1: extruderplatform type
					//	1 - mirrored titan extruder platform
					//	2 - titan extruder platform
					// arg 2: 0 - titan; 1 - aero
/////////////////////////////////////////////////////////////////////////////////////////

module DualExtruder(Extruder=1,Mounting=1) {
	TitanExtruderPlatform(Mounting);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderPlatformNotch() {
	color("blue") minkowski() {
		cube([25,60,wall+5],true);
		cylinder(h = 1,r = 5);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanExtruderPlatform(Mounting=1) {
	// extruder platform for e3d titan with (0,1)BLTouch or (2)Proximity or (3)dc42's ir sensor
	difference() {
		union() {
			//%translate([-15,0,wall*2]) cube([45,10,10]); // check for room for a 42mm long stepper
			translate([13,-34,-wall/2])	color("lightgray") cubeX([30,HorizontallCarriageWidth+23,wall],1); // extruder side
			translate([-21,-34,-wall/2]) color("gray") cubeX([40,10,wall],1); // extruder side
			translate([-21,10,-wall/2]) color("black") cubeX([40,10,wall],1); // extruder side
			translate([-21,54,-wall/2]) color("white") cubeX([40,10,wall],1); // extruder side
		}
		if(Mounting) translate([37,16,10]) rotate([90,0,90]) ExtruderMountHoles();
		if(LEDLight) LEDRingMount();
		if(LEDLight) translate([0,43,0]) LEDRingMount();
		translate([-16,90,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
		translate([11,90,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
		translate([-16,175,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
		translate([11,175,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
	}
	if(LEDLight && LEDSpacer) translate([0,40,-4]) LED_Spacer(LEDSpacer,screw5);
	difference() {
		translate([-0.5,-32,0]) rotate([90,0,90]) TitanMotorMount();
		translate([-24,19,-2]) color("plum") cubeX([wall*2,36,wall],3); // clearance for hotend
		translate([-24,-25,-2]) color("pink") cubeX([wall*2,36,wall],3); // clearance for hotend
		translate([-16,90,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
		translate([11,90,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
		translate([-16,175,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
		translate([11,175,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
		color("blue") hull() {
			translate([-22,33,55])cube([wall,10,1]); // cut out to allow motor be install after nount to xcarriage
			translate([-22,30.5,35]) cube([wall,15,1]);
		}
		color("green") hull() {
			translate([-22,-11.5,55])cube([wall,10,1]); // cut out to allow motor be install after nount to xcarriage
			translate([-22,-14.25,35]) cube([wall,15,1]);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SensorAnd1LCMounting(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) // ir screw holes for mounting to extruder plate
{
	translate([Spacing,-107,0]) rotate([90,0,0]) color("blue") cylinder(h=20,d=Screw);
	translate([0,-107,0]) rotate([90,0,0]) color("red") cylinder(h=20,d=Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LEDRingMount(Screw=Yes5mmInsert(Use5mmInsert)) {
	// a mounting hole for a holder for 75mm circle led
	translate([25,2,-10]) color("white") cylinder(h=20,d=Screw);
	if(!Use5mmInsert) translate([30.5+ShiftHotend2,12.5+ShiftHotend,1.5]) color("black") nut(nut5,5);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module LED_Spacer(Length=10,Screw=screw5) {
	difference() {
		color("blue") cylinder(h=Length,d=Screw*2,$fn=100);
		translate([0,0,-2]) color("red") cylinder(Length+4,d=Screw,$fn=100);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanMotorMount() {
	difference() {	// motor mount
		translate([-1,0,-20.5]) color("red") cubeX([96,51,5],1);
		translate([25,27,-22]) rotate([0,0,45]) color("purple") NEMA17_x_holes(8,1);
		translate([70,27,-22]) rotate([0,0,45]) color("blue") NEMA17_x_holes(8,1);
	}
	translate([-50,0,-20]) TitanSupport();
	translate([42,0,-20]) TitanSupport();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanSupport() {
	difference() { // rear support
		translate([49,47.5,-1.5]) rotate([50]) color("cyan") cubeX([4,6,69],1);
		translate([47,-1,-67]) color("gray") cube([7,70,70]);
		translate([47,-73,-26]) color("lightgray") cube([7,75,75]);
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

