///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// TitanAero.scad - titan aero - single or dual
// created: 10/14/2020
// last modified: 1/6/22
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/12/16	- added bevel on rear carriage for x-stop switch to ride up on
// 5/30/20	- Added ability to use a Titan Aero on mirrored version
// 6/4/20	- Removed some unecessary code
// 8/2/20	- Edited for the CXY-MSv1 files
// 10/13/20	- Changed width of base to allow 42mm long stepper motor
// 10/14/20	- Converted to single to dual
// 10/25/20	- You can nan remove the stepper notch, added tabs to prevent lifting
// 11/23/20	- Added mounts for a brace mount to top of SingleAero() and brace bracket
// 1/6/22	- BOSL2
//////////////////////////////////////////////////////////////////////////////////////////////////////////
include <CoreXY-MSv1-h.scad>
include <inc/brassinserts.scad>
//-------------------------------------------------------------------------------------------------------------
$fn=100;
Use3mmInsert=1; // set to 1 to use 3mm brass inserts
Use5mmInsert=1;
LargeInsert=1;
HorizontallCarriageWidth=width;
ExtruderThickness = wall;	// thickness of the extruder plate
LayerThickness=0.3;
Spacing = 17; 			// ir sensor bracket mount hole spacing
//---------------------------------------------------------------------------------------------------------
LEDLight=1; // print LED ring mounting
LEDSpacer=0;//8;  // length need for titan is 8; length need for aero is 0 (none)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//DualAero(1,0,1);	// arg 1: Mounting holes, arg2: stepper notch to allow inserting motor
//SingleAero(1,0,1,35,0,1); // e3d short stepper motor .9 degree with heatsink on end
SingleAero(1,0,1,40,0,1); // e3d short stepper motor .9 degree with heatsink on end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Brace(DoTab=0,Length=35,Dual=0) {
	if(!Dual) {
		difference() {
			union() {
				color("cyan") cuboid([Length+20,4,5],rounding=1,p1=[0,0]);
				translate([0,59,0]) color("blue") cuboid([Length+20,4,5],rounding=1,p1=[0,0]);
				color("red") cuboid([4,63,5],rounding=1,p1=[0,0]);
			}
			translate([Length+17,65,2.6]) color("plum") rotate([90,0,0]) cylinder(h=70,d=screw3);
		}
		if(DoTab) {
			translate([Length+17,59,0]) color("lightgray") cylinder(h=LayerThickness,d=20);
			translate([Length+17,2,0]) color("gray") cylinder(h=LayerThickness,d=20);
			translate([2,59,0]) color("green") cylinder(h=LayerThickness,d=20);
			translate([2,2,0]) color("pink") cylinder(h=LayerThickness,d=20);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////

module DualAero(Mounting=1,StepperNotch=1,DoTab=1,StepperLength=42) {
	TitanDual(Mounting,StepperNotch,DoTab);
	translate([50,-38,-4]) Brace(DoTab,StepperLength,1);  // something to help with drooping over time
}

/////////////////////////////////////////////////////////////////////////////////////////

module SingleAero(Mounting=1,StepperNotch=1,DoTab=1,StepperLength=42,ShowLength=0,BraceAttachment=0) {
	TitanSingle(Mounting,StepperNotch,DoTab,StepperLength,ShowLength,BraceAttachment);
	if(BraceAttachment) translate([50,-38,-4]) Brace(DoTab,StepperLength,0);  // something to help with drooping over time
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderPlatformNotch() {
	color("blue") minkowski() {
		cube([25,60,wall+5],true);
		cylinder(h = 1,r = 5);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanDual(Mounting=1,StepperNotch=1,DoTab=1) {
	// extruder platform for e3d titan with (0,1)BLTouch or (2)Proximity or (3)dc42's ir sensor
	difference() {
		union() {
			//%translate([-15,0,wall*2]) cube([45,10,10]); // check for room for a 42mm long stepper
			translate([13,-34,-wall/2])	color("lightgray") 
				cuboid([30,HorizontallCarriageWidth+23,wall],rounding=1,p1=[0,0]); // extruder side
			translate([-21,-34,-wall/2]) color("gray") cuboid([40,10,wall],rounding=1,p1=[0,0]); // extruder side
			translate([-21,10,-wall/2]) color("purple") cuboid([40,10,wall],rounding=1,p1=[0,0]); // extruder side
			translate([-21,54,-wall/2]) color("white") cuboid([40,10,wall],rounding=1,p1=[0,0]); // extruder side
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
		translate([-24,19,-2]) color("plum") cuboid([wall*2,36,wall],rounding=3,p1=[0,0]); // clearance for hotend
		translate([-24,-25,-2]) color("pink") cuboid([wall*2,36,wall],rounding=3,p1=[0,0]); // clearance for hotend
		translate([-16,90,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
		translate([11,90,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
		translate([-16,175,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
		translate([11,175,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
		if(StepperNotch) {
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
	if(DoTab) {
		translate([-17,59,-4]) color("green") AddTab();
		translate([-17,16,-4]) color("gray") AddTab();
		translate([-17,-29,-4]) AddTab();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanSingle(Mounting=1,StepperNotch=1,DoTab=1,StepperLength=42,ShowLength=0,BraceAttachment=0) {
	//single titan aero and should work with a titan with e3dv6
	difference() {
		union() {
			if(ShowLength) %translate([-15,0,wall/2]) cube([StepperLength,10,10]); // check for room for the StepperLength
			translate([StepperLength,0,0]) difference() {
				translate([-20,-35,-wall/2]) color("lightgray")
					cuboid([20,HorizontallCarriageWidth-18,wall],rounding=1,p1=[0,0]); // extruder side
				if(Mounting) translate([-5,1,10]) rotate([90,0,90]) ExtruderMountHoles();
				if(LEDLight) translate([-38,-15,0]) LEDRingMount();
			}
			translate([-21,-35,-wall/2]) color("gray") cuboid([45,10,wall],rounding=1,p1=[0,0]); // extruder side
			translate([-21,12,-wall/2]) color("green") cuboid([45,10,wall],rounding=1,p1=[0,0]); // extruder side
			//translate([-21,54,-wall/2]) color("white") cuboid([40,10,wall],rounding=1,p1=[0,0]); // extruder side
		}
		SensorAnd1LCMountSingle();
	}
	if(BraceAttachment) {
		translate([-14,19,52]) {
			difference() {
				color("green") rotate([90,0,0]) cyl(h=4,d=screw5hd+1,rounding=1);
				color("pink") rotate([90,0,0]) cyl(h=6,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
			}
		}
		translate([-14,-32,52]) {
			difference() {
				color("lightgray") rotate([90,0,0]) cyl(h=4,d=screw5hd+1,rounding=1);
				color("pink") rotate([90,0,0]) cyl(h=6,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
			}
		}
	}
	if(LEDLight && LEDSpacer) translate([0,40,-4]) LED_Spacer(LEDSpacer,screw5);
	difference() {
		translate([-0.5,-32,0]) rotate([90,0,90]) TitanMotorMountSingle();
		translate([-24,-26,-3]) color("plum") cuboid([wall*2,39,wall],rounding=3,p1=[0,0]); // clearance for hotend
		SensorAnd1LCMountSingle();
		if(StepperNotch) color("green") hull() {
			translate([-22,-11.5,55])cube([wall,10,1]); // cut out to allow motor be install after nount to xcarriage
			translate([-22,-14.25,35]) cube([wall,15,1]);
		}
	}
	if(DoTab) {
		translate([-17,16,-4]) color("gray") AddTab();
		translate([-17,-29,-4]) AddTab();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AddTab() {
	color("khaki") cylinder(h=LayerThickness,d=20);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SensorAnd1LCMountSingle() {
	translate([-16,91,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
	translate([1,91,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
	translate([-16,130,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
	translate([1,130,0]) SensorAnd1LCMounting(Yes3mmInsert(Use3mmInsert,LargeInsert)); // mounting holes for irsensor bracket
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
	if(!Use5mmInsert) translate([30.5+ShiftHotend2,12.5+ShiftHotend,1.5]) color("cyan") nut(nut5,5);
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
		translate([-1,0,-20.5]) color("red") cuboid([96,51,5],rounding=1,p1=[0,0]);
		translate([25,27,-22]) rotate([0,0,45]) color("purple") NEMA17_x_holes(8,1);
		translate([70,27,-22]) rotate([0,0,45]) color("blue") NEMA17_x_holes(8,1);
	}
	translate([-50,0,-20]) TitanSupport();
	translate([42,0,-20]) TitanSupport();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanMotorMountSingle() {
	difference() {	// motor mount
		translate([-2,0,-20.5]) color("red") cuboid([55,51,5],rounding=1,p1=[0,0]);
		translate([25,27,-22]) rotate([0,0,45]) color("purple") NEMA17_x_holes(8,1);
		//translate([70,27,-22]) rotate([0,0,45]) color("blue") NEMA17_x_holes(8,1);
	}
	translate([0,0,-20]) color("blue") TitanSupport();
	translate([-51,0,-20]) TitanSupport();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanSupport() {
	difference() { // rear support
		translate([49,47.5,-1.5]) rotate([50]) color("cyan") cuboid([4,6,69],rounding=1,p1=[0,0]);
		translate([47,-1,-67]) color("gray") cube([7,70,70]);
		translate([47,-73,-26]) color("lightgray") cube([7,75,75]);
	}
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHoles(Screw=screw3,All=1) {		// screw holes to mount extruder plate
	translate([0,0,0]) rotate([90,0,0]) color("blue") cylinder(h = 20, d = Screw);
	translate([HorizontallCarriageWidth/2-5,0,0]) rotate([90,0,0]) color("red") cylinder(h = 20, d = Screw);
	translate([-(HorizontallCarriageWidth/2-5),0,0]) rotate([90,0,0]) color("green") cylinder(h = 20, d = Screw);
	if(All) {	
		translate([HorizontallCarriageWidth/4-2,0,0]) rotate([90,0,0]) color("gray") cylinder(h = 20, d = Screw);
		translate([-(HorizontallCarriageWidth/4-2),0,0]) rotate([90,0,0]) color("cyan") cylinder(h = 20, d = Screw);
	}
}

