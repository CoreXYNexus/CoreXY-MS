///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// XCarriage - x carriage for the COREXY-MSv1 using makerslide
// created: 2/3/2014
// last modified: 1/5/22
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/12/16 - added bevel on rear carriage for x-stop switch to ride up on
// 1/21/16 - added Prusa i3 style extruder mount to carriage and put it into a seperate module
// 3/6/16  - added BLTouch mounting holes, sized for the tap for 3mm screws (centered behind hotend)
// 5/24/16 - adjusted carriage for i3(30mm) style mount by making it a bit wider
//			 added a proximity sensor option
// 6/27/16 - added corexy belt holder
// 7/2/16  - new file from x-carraige.scad and removed everything not needed for corexy
//			 one belt clamp set per side
// 7/3/16  - added tappable mounting holes for the endstopMS.scad holders
//			 added all() to print everything
//			 added third wall to the belt holder frame (it broke without one)
//			 added assembly info
// 7/17/16 - adjusted proximity sensor position
// 8/1/16  - added note on extruder plate & proximity sensor
// 9/11/16 - added irsensor bracket to extruder plate
// 9/16/16 - added combined rear carriage & belt holder
// 9/26/16 - design for using the E3D Titan
// 10/25/16 - added Titan mount for AL extruder plate and for mounting right on x-carraige using mount_seperation
// 11/29/16 - made titanmotor expand up/down with shiftitanup variable
// 12/18/16 - on the titan extruder plate, the titan was shifted towards the hotend side by 20mm to make the
//			  adjusting screw easier to get to.  Also, began adding color to parts for easier editing.
// 12/22/16 - changed z probe mounts and mounting for TitanExtruderPlatform() extruder plate
// 12/23/16 - cleaned up some code and fixed the screw hole sizes in prox_adapter() & iradapter()
// 12/27/16 - fixed fan mount screw holes on TitanExtruderPlatform()
// 1/8/17	- changed side mounting holes of titan3(), shifted up to allow access to lower mouting holes when
//			  assembled
// 1/9/17	- made TitanExtruderPlatform() able to be used as the titan bowden mount
// 7/9/18	- added a rounded bevel around the hotend clearance hole to the titan mount using corner-tools.scad
//			  and fixed the rear support to be rounded in TitanExtruderPlatform() and removed some unecessary code
//			  added rounded hole under motor to titan3() and fixed mounting holes
// 7/12/18	- Noticed the plate was not setup for a 200x200 bed
// 8/19/18	- Dual Titanmount is in DualTitan.scad, OpenSCAD 2018.06.01 for $preview, which is used to make sure
//			  a 200x200 bed can print multiple parts.
// 8/20/18	- Added a carridge and belt only for DualTitan.scad, redid the modules for the other setups
// 12/8/18	- Changed belt clamp from adjusting type to solid (stepper motors are adjustable)
//			  Added preview color to belt modules
//			  Added x-carriage belt drive loop style
// 12/10/18	- Edited carriage() and carriagebelt() to not use center=true for the cubeX[]
// 1/26/19	- Edited BLTouchMount() to use cubeX() for recess hole and have mounting holes defined in BLTouchMount()
//			  at fan spacing. Removed servo mounting holes. Added one piece titan direct mount on x carriage
// 1/31/18	- Fixed/added a few mounting holes
//			  Adjusted fan adapter position on TitanExtruderPlatform()
//			  Changed titan2() name to TitanExtruderBowdenMount()
//			  Removed titan3()
//			  Ziptie hole on BLTouchMount()
// 2/12/19	- Moved BeltHolder.scad into here.  Renamed BeltHolder.scad height to LoopHeight.
// 2/21/19	- Fixed bevel hole access to adjuster on carraige plate in carriagebelt()
// 2/23/19	- Combined carriagebelt() into carriage(), bug fixes, removed unused modules, renamed modules for a better
//			  description of what they do
// 3/9/19	- Added a m3 nut holder on the titanextrudermount() at the end since tapping that hole may not be strong enough
// 4/20/19	- Added a nut holder on the proximity sensor holder.
// 4/23/19	- Added nut holders for fan/sensor mount on titanextrudermount()
// 5/4/19	- Added v2 of carriage(), a simpler squared off version made with cubeX()
// 5/26/19 	- Added nut holes for the extruder & belt mounts on the Carriage();
// 5/28/18	- Rounded the corner fillers between the bottom and vertical parts of the carriage
// 6/14/19	- Added a third version of the carriage with belt as a single part
// 7/2/19	- Adjusted beltloop belt position
// 7/19/19	- Added a mirror version of the titan extruder platform, so that the adjusting screw faces the front
// 8/4/19	- Made nut holes on carriage_v2 and ExtruderPlateMount through holes
// 8/5/19	- extruderplatemount() to allow mirrored version to work
// 8/7/19	- Widened tha pc blower fan adapter mounting holes
// 10/10/19	- Added ability to add/remove led ring mount with the needed spacer
// 3/8/20	- Added ability to use 3mm brass inserts on carriage_v2() and carriage_v3(), The var Use3mmInsert enables it
// 4/7/20	- Changed 3mmBrassInsert to screw3in (dia), 3mmBrasssInsertlen to screw3inl; now in screwsizes.scad
//			  Added ability for other modules that use 3mm nut to able to use the 3mm brass inserts
// 4/11/20	- Renamed some variables and have the all in one x-carriages put together correctly,
//			  BeltLoopHolder() now uses a for loop
// 4/25/20	- Adjusted belt loop belt offset, made a new var:BeltLoopShiftY if shift the belt loop on the mounting
// 5/8/20	- Fixed belt loop holder so you don't need to twist belts
// 6/15/20	- Adjust the belt loop holders, wider screw mounts nd position
// 8/2/20	- Removed extruder mounts
// 8/4/20	- Added an x carraidge with the single titan extruder mount: CarridgeAllInOneAndSingleTitanExtruder();
// 9/27/20	- Added abilitiy to use M3 or M5 to BeltLoopHolderOppo() and CarridgeAllInOneAndSingleTitanExtruder()
//			  for the belt loop holders. Changed recomendation from ABS to PETG. PETG prints without a heated chamber.
//			  WireChainMount lets you change the monting holes on top of the belt mounting bracket to M4 or M5 inserts
// 10/17/20	- changed extruder mount to allow dual titan areos
// 11/8/20	- Added extra set of holes to mount the single titan aero extruder mount
// 9/23/21	- BeltLoop adapter for exoslide
// 1/6/22	- BOSL2 finished
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// What rides on the x-axis is separate from the extruder plate
// The screw2 holes must be drilled with a 2.5mm drill for a 3mm tap or to allow a 3mm to be screwed in without tapping
// I used 3x16mm cap head screws to mount the extruder plate to the carriage
// ---------------------------------------------------------
// PLA can be used for the carriage & belt parts
// Use PETG or better if you have a hotend that gets hot at it's mounting, like on with no insulation sock
// ---------------------------------------------------------
// Extruder plate use PETG or better if you have a hotend that gets hot at it's mounting.
// for example: using an E3Dv6, PLA will work fine, since it doesn't get hot at the mount.
// ---------------------------------------------------------
// Belt clamp style: Assemble both belt clamps before mounting on x-carriage, leave loose enough to install belts
// The four holes on top are for mounting an endstopMS.scad holder, tap them with a 5mm tap.
// ---------------------------------------------------------
// For the loop belt style: tap holes or brass inserts for 3mm and mount two belt holders, it's in belt_holder.scad
//----------------------------------------------------------
// If the extruder plate is used with an 18mm proximity sensor, don't install the center mounting screw, it gets
// in the way of the washer & nut.
//-----------------------------------------------------------
// Changed to using a front & rear carriage plate with the belt holder as part of it.  The single carriage plate
// wasn't solid enough, the top started to bend, loosening the hold the wheels had on the makerslide
//-----------------------------------------------------------
// To use rear carriage belt in place of the belt holder, you need three M5x50mm, three 7/8" nylon M5 spacers along
// with the three makerslide wheels, three M5 washers, three M5 nuts, two M3x16mm screws
//-----------------------------------------------------------
// corner-tools.scad fillet_r() doesn't show in preview
//////////////////////////////////////////////////////////////////////////////////////////////////////////
include <CoreXY-MSv1-h.scad>
include <inc/brassinserts.scad>
include <BOSL2/std.scad>
use <TitanAero.scad>
use <yBeltClamp.scad>
//-------------------------------------------------------------------------------------------------------------
$fn=75;
TestLoop=0; 			// 1 = have original belt clamp mount hole visible
LoopHoleOffset=34.5;	// distance between the belt loop mounting holes
LoopHOffset=0;			// shift horizontal the belt loop mounting holes
LoopVOffset=-2;			// shift vertical the belt loop mounting holes
BeltLoopShiftY=-5;
MountThickness=5;
BeltSpacing=7;
BeltMSSpacing=10;
BeltWidth=6;
LoopHeight = 18;
VerticalCarriageWidth = 37.2;
HorizontalCarriageHeigth = 20;
LayerThickness=0.3;
//---------------------------------------------------------------------------------------------------------------
E3Dv6 = 36.5;			// hole for E3Dv6 with fan holder
ShiftTitanUp = 2.5;		// move motor +up/-down
ShiftHotend = 0;		// move hotend opening front/rear
ShiftHotend2 = -20;		// move hotend opening left/right
Spacing = 17; 			// ir sensor bracket mount hole spacing
ShiftIR = -20;			// shift ir sensor bracket mount holes
ShiftBLTouch = 10;		// shift bltouch up/down
ShiftProximity = 5;		// shift proximity sensor up/down
ShiftProximityLR = 3;	// shift proximity sensor left/right
EWCMountLength=48;
EWCMountWidth=32;
//-----------------------------------------------------------------------------------------
// info from irsensorbracket.scad
//-----------------------------------
HotendLength = 50;	// 50 for E3Dv6
BoardOverlap = 2.5; // amount ir board overlaps sensor bracket
IRBoardLength = 17 - BoardOverlap; // length of ir board less the overlap on the bracket
IRGap = 0;			// adjust edge of board up/down
//-----------------------------------------------------------------------------------------
HeightIR = (HotendLength - IRBoardLength - IRGap) - irmount_height;	// height of the mount
//---------------------------------------------------------------------------------------------------------
LEDLight=1; // print LED ring mounting with spacer
LEDSpacer=20;
//------------------------------------------------------------------------------------------------
// The variable WireChainMount lets you change the mounting holes on top of the belt mounting bracket to M4 or M5 inserts
//WireChainMount=Yes4mmInsert(Use4mmInsert);
WireChainMount=Yes5mmInsert(Use5mmInsert);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//partial();
//FrontCarridge(0,0,0,0);	// Clamps,Loop,Titan
//CarridgeAllInOne(0,1,2,0,Yes5mmInsert(Use5mmInsert),1,0);
// 				Clamps=1,Loop=0,Titan=0,LoopMounts=0,Screw=Yes3mmInsert(Use3mmInsert,LargeInsert),ExtMount=1,TitanAero=0
//CarridgeAllInOne(0,1,2,0,Yes3mmInsert(Use3mmInsert),1);	// Clamps,Loop,Titan
//RearCarridge(0,1,1);	// Clamps,Loop
//FrontAndRear(0,1,0,1);
//TitanExtruderBowdenMount(); // right angle titan mount to 2020 for bowden
//CarridgeAllInOneAndSingleTitanExtruder(0,1,1,Yes3mmInsert(Use3mmInsert,LargeInsert));// Clamps,Loop,Titan
//							Clamps=1,Loop=0,Titan=0,Screw=Yes3mmInsert(Use3mmInsert,LargeInsert),ExtType=1
//CarridgeAllInOneAndSingleTitanExtruder(0,1,1,Yes5mmInsert(Use5mmInsert));// Clamps,Loop,Titan
//translate([30,70,-8]) // position either below to print with CarridgeAllInOneAndSingleTitanExtruder()
//	BeltLoopHolderOppo(2,BeltLoopShiftY,screw3); // loop mounts opposite of each other
//	BeltLoopHolderOppo(BeltLoopShiftY,screw5); // loop mounts opposite of each other
EXOSLideAdapter(9,10.5); // arg is beltloop holder screw hieght above bottom

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EXOSLideAdapter(UpDownAdjust=0,LRAdjust=0,Screw=Yes5mmInsert(Use5mmInsert),LRAdjust=10.5) {
	difference() {
		color("cyan") cuboid([EWCMountWidth,EWCMountLength,30],rounding=2,p1=[0,0]);
		translate([EWCMountWidth/6,0,0]) {
			translate([0,EWCMountLength/2,-10]) color("blue") cylinder(h=50,d=screw4);
			translate([20,EWCMountLength/2,-10]) color("red") cylinder(h=50,d=screw4);
			translate([0,EWCMountLength/2,16]) color("red") cylinder(h=20,d=screw4hd);
			translate([20,EWCMountLength/2,16]) color("blue") cylinder(h=20,d=screw4hd);
		}
		translate([-10,LoopHoleOffset/2-LRAdjust,UpDownAdjust]) {
			color("blue") rotate([0,90,0]) cylinder(h=LoopHeight*3,d=Screw);
			translate([0,LoopHoleOffset,0]) color("red") rotate([0,90,0])
				cylinder(h=LoopHeight*3,d=Screw);
		}
		translate([EWCMountWidth-39,0,0]) {
			translate([-5,0.5,20]) XWCMountHoles();
			translate([5,7.5,20]) XStopMountHoles();
		}
		translate([15,8,-5]) color("green")  hull() { // reduce plastic/weight
			cylinder(h=50,d=8);
			translate([0,32,0]) cylinder(h=50,d=8);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XStopMountHoles(Screw=Yes5mmInsert(Use5mmInsert)) {
	translate([8,6,-1]) color("red") cylinder(h=15,d=Screw);
	color("blue") translate([8,26.5,-1]) color("blue") cylinder(h=15,d=Screw);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XWCMountHoles(Screw=Yes5mmInsert(Use5mmInsert)) {
	color("gold") translate([37,13,-5]) cylinder(h=20, d=Screw);
	color("red") translate([37,33,-5]) cylinder(h=20, d=Screw);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CarridgeAllInOneAndSingleTitanExtruder(Clamps=1,Loop=0,Titan=0,Screw=Yes3mmInsert(Use3mmInsert,LargeInsert),ExtType=1,Stiffner=0) {
	CarridgeAllInOne(Clamps,Loop,Titan,0,Screw);
	translate([0,-wall,-4]) color("plum")
		cuboid([width,wall,wall],rounding=1,p1=[0,0]); // make front xcarriage even with extruder mount
	translate([-0.6,35,-4]) color("red") cuboid([width,wall,wall],rounding=1,p1=[0,0]); // make rear xcarriage even with front
	translate([33,-42,0]) rotate([0,0,90]) TitanSingle(0);
	if(Stiffner) translate([49,-14,42.5]) color("blue")
		cuboid([6.75,14,wall],rounding=1,p1=[0,0]);  // don't use this if flexibility is needed
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FrontCarridge(Clamps=1,Loop=0,Titan=0,BeltDrive=0) {
	//if($preview) %translate([-70,-50,-1]) cube([200,200,1]);
	Carriage_v2(Titan,0,Clamps,Loop,0,0,1);
			// Titan=0,Tshift=0,Clamps=0,Loop=0,DoBeltDrive=1,Rear=0,MoveBeltLoops=0,ExtMountingHoles=1
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CarridgeAllInOne(Clamps=1,Loop=0,Titan=0,LoopMounts=0,Screw=Yes3mmInsert(Use3mmInsert,LargeInsert),ExtMount=1,TitanAero=0) {
	//if($preview) %translate([-70,-50,-1]) cube([200,200,1]);
	Carriage_v3(Titan,0,Clamps,Loop,1,LoopMounts,ExtMount,Screw,TitanAero);
			// Titan=0,Tshift=0,Clamps=0,Loop=0,DoBeltDrive=1,LoopMounts=1,ExtMountingHoles=1
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FrontAndRear(Clamps=1,Loop=0,Titan=0,BeltDrive=0) {
	//if($preview) %translate([-90,-50,-1]) cube([200,200,1]);
	FrontCarridge(Clamps,Loop,Titan,BeltDrive);	// Clamps,Loop,Titan
	translate([15,90,0]) rotate([0,0,180]) RearCarridge(Clamps,Loop,BeltDrive);	// Clamps,Loop
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RearCarridge(Clamps=0,Loop=0,DoBelt=0) {
	//if($preview) %translate([-10,-70,-1]) cube([200,200,1]);
	Carriage_v2(0,1,Clamps,Loop,0,1,0);	// rear x-carriage plate
			// Titan=0,Tshift=0,Clamps=0,Loop=0,DoBeltDrive=0,Rear=0,MoveBeltLoops=0,ExtMountingHoles=1
	if(DoBelt) translate([85,0,0]) CarriageBeltDriveStandAlone(1,1,0);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module partial() {
	//if($preview) %translate([-100,-100,-1]) cube([200,200,1]); // parts may not be on the preview plate
	//roundedinner();
	Carriage_v2(1,0,0,1,0,0,0);	// x-carriage, 1st arg: Titan mount; 2nd arg:Shift Titan mount;
					// 3rd arg: belt clamps; 4th arg: Loop style belt holders
					// 5:arg DoBeltDrive if 1; 6th arg: Rear carriage plate if 1; 7th arg: 1 or 2 Moves the Belt loops
					// defaults: Titan=0,Tshift=0,Clamps=0,Loop=0,DoBeltDrive=1,Rear=0,MoveBeltLoops=0
	//Carriage_v3();	//Titan=0,Tshift=0,Clamps=0,Loop=0,DoBeltDrive=1,LoopMounts=1,ExtMountingHoles=1
	//ExtruderPlatform(0);	// for BLTouch: 0 & 1, 2 is proximity, 3 is dc42 ir sensor, 4- none
	//translate([-50,0,0]) CarriageBeltDrive(1);	// 1 - belt loop style
	//MirrorTitanExtruderPlatform(5,1,1,1); // reverse the platform to have the titan adjusting screw to the front
	//TitanCarriage(); // one piece titan/E3Dv6 on x-carriage + belt drive holder
	//TitanExtruderBowdenMount(); // right angle titan mount to 2020 for bowden
	//TitanMotorMount(0);
	//ProximityMount(ShiftProximity);
	//mirror([1,1,0]) ProximityMount(ShiftProximity);
	//BLTouchMount(0,ShiftBLTouch);
	//BLTouchMount(0); // makes hole for bltouch mount
	//BeltLoopHolderOppo(BeltLoopShiftY); // loop mounts opposite of each other
	//BeltLoopHolder(2,BeltLoopShiftY);
	//CarriageBeltDriveStandAlone(1,1,0);
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Carriage_v2(Titan=0,Tshift=0,Clamps=0,Loop=0,DoBeltDrive=0,Rear=0,MoveBeltLoops=0,ExtMountingHoles=1) { // extruder side
	difference() {
		union() {
			translate([VerticalCarriageWidth/2,0,0]) color("cyan")
				cuboid([VerticalCarriageWidth,height,wall],rounding=1,p1=[0,0]);
			color("blue") cuboid([width,HorizontalCarriageHeigth,wall],rounding=1,p1=[0,0]);
				translate([VerticalCarriageWidth/2+31,HorizontalCarriageHeigth+0.9,0]) roundedinner();
			translate([VerticalCarriageWidth/2+6.5,HorizontalCarriageHeigth+0.9,8]) rotate([0,180,0]) roundedinner();
		}
		BeltDriveNotch(Loop);
		// wheel holes
		if(!Rear) { // top wheel hole, if rear, don't bevel it
			translate([VerticalCarriageWidth,tri_sep+10,0]) color("red") hull() {
				// bevel the countersink to get easier access to adjuster
				translate([0,0,3]) cylinder(h = depth+10,d = screw5hd);
				translate([0,0,10]) cylinder(h = depth,d = screw5hd+25);
			}
		} else // if rear, don't do it
			translate([width/2,tri_sep/2+42,3]) color("lightgray") nut(nut5,10);
		translate([width/2,tri_sep/2+42,-10]) color("blue") cylinder(h = depth+10,d = adjuster); // top hole
		translate([dual_sep/2+width/2,-tri_sep/2+42,-10]) color("yellow") cylinder(h = depth+10,d = screw5); // right hole
		translate([-dual_sep/2+width/2,-tri_sep/2+42,-10]) color("purple") cylinder(h = depth+10,d = screw5); // left hole
		if(Rear) // rear needs a nut hole for the wheel holes
				NutAccessHole(); // nut hoe for the wheel holes
		else { // otherwise, contersink them
			translate([dual_sep/2+width/2,-tri_sep/2+42,4]) color("yellow") cylinder(h = depth+10,d = screw5hd); // right hole
			translate([-dual_sep/2+width/2,-tri_sep/2+42,4]) color("purple") cylinder(h = depth+10,d = screw5hd); // left hole
		}
		translate([38,height/2+8,-wall/2]) color("gray") hull() { // reduce usage of filament
			cylinder(h = wall+10, r = 6);
			translate([0,-40,0]) cylinder(h = wall+10, r = 6);
		}
		// screw holes to mount extruder plate
		if(ExtMountingHoles && !Rear) translate([37.5,45,4])
			ExtruderMountHolesFn(Yes3mmInsert(Use3mmInsert,LargeInsert),1);
		// screw holes in top (alternate location for a belt holder)
		if(Use3mmInsert) translate([38,44,4]) TopMountBeltHoles(Yes3mmInsert(Use3mmInsert,LargeInsert));
		else translate([38,45,4]) TopMountBeltHoles(screw3);
		if(!Use3mmInsert) TopMountBeltNuts(Nut=nut3);
		if(!Rear) translate([38,45,4]) CarridgeMount(Yes4mmInsert(Use4mmInsert));//screw4); // 4 mounting holes for an extruder
        if(ExtMountingHoles) CarriageExtruderPlateNuts();
	}
	if(DoBeltDrive) {
		echo("belt drive ");
		echo(DoBeltDrive);
		difference() {
			translate([70,30,0]) CarriageBeltDrive(Loop);	// belt attachment to above
			translate([128,3,30]) rotate([0,90,0]) TitanTensionHole();
		}
		if(Loop) {
			if(MoveBeltLoops==1) translate([80,0,0]) BeltLoopHolderOppo(BeltLoopShiftY);
			if(MoveBeltLoops==2) translate([60,120,-(BeltMSSpacing-BeltWidth)]) BeltLoopHolderOppo(BeltLoopShiftY);
		}
	}
	BeltClamps(Clamps,Loop);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Carriage_v3(Titan=0,Tshift=0,Clamps=0,Loop=0,DoBeltDrive=1,LoopMounts=1,ExtMountingHoles=1,Screw=Yes3mmInsert(Use3mmInsert,LargeInsert),TitanAero=0) { // main carriage assembly
	rotate([90,0,0]) difference() { // front
		union() {
			translate([VerticalCarriageWidth/2,0,0]) color("cyan")
				cuboid([VerticalCarriageWidth,height,wall],rounding=1,p1=[0,0]);
			color("blue") cuboid([width,HorizontalCarriageHeigth,wall],rounding=1,p1=[0,0]);
				translate([VerticalCarriageWidth/2+31,HorizontalCarriageHeigth+0.9,0]) roundedinner();
			translate([VerticalCarriageWidth/2+6.5,HorizontalCarriageHeigth+0.9,8]) rotate([0,180,0]) roundedinner();
			if(ExtMountingHoles) {  // front print support tabs
				translate([0,LayerThickness,4]) color("cyan") rotate([90,0,0])
					cylinder(h=LayerThickness,d=20); // print support tab
				translate([70,LayerThickness,4]) color("red") rotate([90,0,0])
					cylinder(h=LayerThickness,d=20); // print support tab
			}
		}
		rotate([-90,0,0]) translate([16,-8,68]) BeltLoopHolderMountingHoles(Screw);
		// wheel holes
		translate([VerticalCarriageWidth,tri_sep+10,0]) color("red") hull() {
			// bevel the countersink to get easier access to adjuster
			translate([0,0,3]) cylinder(h = depth+10,d = screw5hd/2);
			translate([0,0,10]) cylinder(h = depth,d = screw5hd+25);
		}
		translate([width/2,tri_sep/2+42,-10]) color("blue") cylinder(h = depth+10,d = adjuster); // top hole
		translate([dual_sep/2+width/2,-tri_sep/2+42,-10]) color("yellow") cylinder(h = depth+10,d = screw5); // right hole
		translate([-dual_sep/2+width/2,-tri_sep/2+42,-10]) color("purple") cylinder(h = depth+10,d = screw5); // left hole
		translate([dual_sep/2+width/2,-tri_sep/2+42,7]) color("yellow") cylinder(h = depth+10,d = screw5hd); // right hole
		translate([-dual_sep/2+width/2,-tri_sep/2+42,7]) color("purple") cylinder(h = depth+10,d = screw5hd); // left hole
		translate([38,height/2+8,-wall/2]) color("gray") hull() { // reduce usage of filament
			cylinder(h = wall+10, r = 6);
			translate([0,-40,0]) cylinder(h = wall+10, r = 6);
		}
		// screw holes to mount extruder plate
		if(ExtMountingHoles) {
			if(TitanAero) 
				translate([29,45,4]) ExtruderMountHolesFn(Yes3mmInsert(Use3mmInsert,LargeInsert),1,1);
			else
				translate([37.5,45,4]) ExtruderMountHolesFn(Yes3mmInsert(Use3mmInsert,LargeInsert),1);
		}
		// screw holes in top (alternate location for a belt holder)
		if(!Titan)	translate([38,45,4]) CarridgeMount(screw4); // 4 mounting holes for an extruder
		CarriageExtruderPlateNuts();
 	}
	translate([0,39,0]) color("black") cylinder(h=LayerThickness,d=20); // rear print support tab
	translate([70,39,0]) color("gray") cylinder(h=LayerThickness,d=20); // rear print support tab
	translate([17,-4,90.0009])  color("green") cube([40,38,LayerThickness]);  // support for the holes in the top
	//%translate([0,0,4]) cube([10,35,10]); // show distance needed between carriages
	translate([VerticalCarriageWidth*2,35,0]) rotate([90,0,180]) difference() { // rear
		union() {
			translate([VerticalCarriageWidth/2,0,0]) color("cyan")
				cuboid([VerticalCarriageWidth,height,wall],rounding=1,p1=[0,0]);
			color("blue") cuboid([width,HorizontalCarriageHeigth,wall],rounding=1,p1=[0,0]);
				translate([VerticalCarriageWidth/2+31,HorizontalCarriageHeigth+0.9,0]) roundedinner();
			translate([VerticalCarriageWidth/2+6.5,HorizontalCarriageHeigth+0.9,8]) rotate([0,180,0]) roundedinner();
		}
		BeltDriveNotch(Loop);
		if(!Use5mmInsert) {
			translate([width/2,tri_sep/2+42,3]) color("lightgray") nut(nut5,10);
			NutAccessHole();
			translate([width/2,tri_sep/2+42,-2]) color("green") cylinder(h=15,d=screw5);
			translate([dual_sep/2+width/2,-tri_sep/2+42,-10]) color("yellow")
				cylinder(h = depth+10,d=screw5); // right hole
			translate([-dual_sep/2+width/2,-tri_sep/2+42,-10]) color("purple")
				cylinder(h = depth+10,d=screw5); // left hole
		} else {
			translate([width/2,tri_sep/2+42,-2]) color("green") cylinder(h=15,d=Yes5mmInsert(Use5mmInsert));
			translate([dual_sep/2+width/2,-tri_sep/2+42,-10]) color("yellow")
				cylinder(h = depth+10,d = Yes5mmInsert(Use5mmInsert)); // right hole
			translate([-dual_sep/2+width/2,-tri_sep/2+42,-10]) color("purple")
				cylinder(h = depth+10,d = Yes5mmInsert(Use5mmInsert)); // left hole
		}
		translate([38,height/2+8,-wall/2]) color("gray") hull() { // reduce usage of filament
			cylinder(h = wall+10, r = 6);
			translate([0,-40,0]) cylinder(h = wall+10, r = 6);
		}
		if(!Titan) translate([38,45,4]) CarridgeMount(screw4); // 4 mounting holes for an extruder
 	}
	if(DoBeltDrive) {
		translate([59,-8,98]) rotate([180,0,180]) CarriageBeltDrive(Loop,0,0,Screw);	// belt attachment to above
	}
	BeltClamps(Clamps,Loop);
	if(LoopMounts) translate([40,70,-(BeltMSSpacing-BeltWidth)]) BeltLoopHolderOppo(BeltLoopShiftY);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NutAccessHole(Nut=1) {
	if(!Nut) {
		translate([dual_sep/2+width/2,-tri_sep/2+42,3]) color("gray") cylinder(h = depth+10,d = screw5hd); // right
		translate([-dual_sep/2+width/2,-tri_sep/2+42,3]) color("green") cylinder(h = depth+10,d = screw5hd); // left
	} else {
		translate([dual_sep/2+width/2,-tri_sep/2+42,3]) color("gray") nut(nut5,10); // right
		translate([-dual_sep/2+width/2,-tri_sep/2+42,3]) color("green")  nut(nut5,10); // left
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CarriageExtruderPlateNuts(){
	if(Yes3mmInsert(Use3mmInsert,LargeInsert) == screw3) {
		translate([5,HorizontalCarriageHeigth+3,nut3/2+1]) rotate([90,0,0]) color("black") nut(nut3,5);
		translate([widthE/2,HorizontalCarriageHeigth-10,nut3/2+1]) rotate([90,0,0]) color("white") nut(nut3,5);
		translate([widthE-5,HorizontalCarriageHeigth+3,nut3/2+1]) rotate([90,0,0]) color("gray") nut(nut3,5);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TopMountBeltHoles(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) {
	ScrewL=20;
	echo(ScrewL);
	translate([width/4-6,height/2+2,0]) rotate([90,0,0]) color("red") cylinder(h = ScrewL, d = Screw);
	translate([-(width/4-5),height/2+2,0]) rotate([90,0,0]) color("blue") cylinder(h = ScrewL, d = Screw);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TopMountBeltNuts(Nut=nut3) {
	translate([13,-3,-5]) color("gray") hull() {
		translate([width/2,height,nut3/2]) rotate([90,0,0]) nut(nut3,3);
		translate([width/2,height,nut3/2+12]) rotate([90,0,0]) nut(nut3,3);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltDriveNotch(Belt=1) {
	if(Belt) {
		difference() {
			color("pink") hull() {
				translate([15,height-10,1]) rotate([0,90,0]) cylinder(h=VerticalCarriageWidth+10,d=screw3);
				translate([15,height-6,1]) rotate([0,90,0]) cylinder(h=VerticalCarriageWidth+10,d=screw3);
			}
			translate([22,height-13,-3]) color("plum") cube([30,10,10]);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHolesFn(Screw=screw3,All=0,Just4=0) {
	translate([0,-15,0]) rotate([90,0,0]) color("red") cylinder(h = 35, d = Screw); // center
	translate([width/2-5,-15,0]) rotate([90,0,0]) color("blue") cylinder(h = 35, d = Screw); //right
	if(!Just4) translate([-(width/2-5),-15,0]) rotate([90,0,0]) color("black") cylinder(h = 35, d = Screw); // left
	if(All) {
		translate([width/4-2,-15,0]) rotate([90,0,0]) color("purple") cylinder(h = 35, d = Screw);
		translate([-(width/4-2),-15,0]) rotate([90,0,0]) color("gray") cylinder(h = 35, d = Screw);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanMountHoles(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert),Left=1) {	// fan mounting holes
	ScrewL=20;
	if(Left) {
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("blue") cylinder(h = ScrewL*2,d = Screw);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = 2*ScrewL,d = Screw);
	} else { // one side fan mounting holes
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h =ScrewL,d = Screw);
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = ScrewL,d = Screw);
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = ScrewL*2,d = Screw);
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = ScrewL*2,d = Screw);
	}
	if(Screw == screw3) {
		translate([-38.5,-50,52]) rotate([0,90,0]) color("blue") hull() {	// nut trap for fan
			nut(nut3,3);
			translate([0,18,0]) nut(nut3,3);
		}
	}
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NotchBottom()
{
	translate([38,-2,4]) cube([width+1,wall,wall+2], true);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CarriageBeltDrive(Loop=0,DoRearWall=1,DoLayer=0,Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) {
	difference() {	// base
		translate([-3,-0,0]) color("cyan") cuboid([47,40,wall],rounding=1,p1=[0,0]);
		if(!Loop && Screw == screw3) {
			hull() {	// belt clamp nut access slot
				translate([-4,belt_adjust,8]) rotate([0,90,0]) color("red") nut(m3_nut_diameter,14); // make room for nut
				translate([-4,belt_adjust,4]) rotate([0,90,0]) color("blue") nut(m3_nut_diameter,14); // make room for nut
			}
			color("gray") hull() {	// belt clamp nut access slot
				translate([31,belt_adjust,8]) rotate([0,90,0]) nut(m3_nut_diameter,14);
				translate([31,belt_adjust,4]) rotate([0,90,0]) nut(m3_nut_diameter,14);
			}
		}
		// mounting screw holes to x-carriage plate
		if(DoRearWall) {
			translate([6,wall/2,-1]) rotate([0,0,0]) color("blue") cylinder(h=15,d=screw3);
			translate([6+(width/4+8.5),wall/2,-1]) rotate([0,0,0]) color("black") cylinder(h=15,d=screw3);
		}
		color("white") hull() { // plastic reduction
			translate([21,16,-5]) cylinder(h= 20, r = 8);
			translate([21,25,-5]) cylinder(h= 20, r = 8);
		}
		 // mounting holes for an endstop holder & wire chain
		EndStopAndWireChainHoles();
	}
	if(DoLayer) translate([1,2,7.7]) color("black") cube([44,40,layer]);
	difference() {	// right wall
		difference() {
			translate([-wall/2-1,0,0]) color("yellow") cuboid([wall-2,40,35],rounding=1,p1=[0,0]);
			translate([-23,-4,31]) rotate([0,40,0]) color("lightgray") cube([20,60,20]);
		}
		if(!Loop) {
			translate([-wall/2-2,belt_adjust,27]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, d=screw3);
			translate([-wall/2-2,belt_adjust,4]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, d=screw3);
			translate([-0.5,belt_adjust,27]) rotate([0,90,0]) color("blue") nut(m3_nut_diameter,3);
			translate([-0.5,belt_adjust,4]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		} else BeltLoopHolderMountingHoles(Screw);
		if(TestLoop) // add one of belt clamp holes for adjusting the belt loop holder mounting holes
			translate([-wall/2-2,belt_adjust,4]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, d=screw3);
		EndStopAndWireChainHoles();
	}
	if(!Loop) BeltMountingHoleBump(0);
	difference() {	// left wall
		translate([36+wall/2,0,0]) color("pink") cuboid([wall-2,40,31],rounding=1,p1=[0,0]);
		translate([35,-4,34]) rotate([0,50,0]) color("red") cube([20,60,20]);
		if(!Loop) {
			translate([32,belt_adjust,4]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, d=screw3);
			translate([32,belt_adjust,27]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, d=screw3);
			translate([38.5,belt_adjust,4]) rotate([0,90,0]) color("blue") nut(m3_nut_diameter,3);
			translate([38.5,belt_adjust,27]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		} else {
			BeltLoopHolderMountingHoles(Screw);
		}
		EndStopAndWireChainHoles();
	}
	if(DoRearWall) {
		difference() {	// rear wall - adds support to walls holding the belts
			translate([-wall/2+1,42-wall,0]) color("gray") cuboid([47,wall-2,belt_adjust],rounding=1,p1=[0,0]);
			translate([4,33,-5]) color("blue") cylinder(h=25,d=screw5);	// clearance for endstop screws
			translate([37,33,-5]) color("red") cylinder(h=25, d=screw5);
			if(Loop) BeltLoopHolderMountingHoles(Screw);
	}
	} else { // fillers
		difference() {
			union() {
				translate([-3,0,4]) color("black") cuboid([10,wall,30],rounding=1,p1=[0,0]);
				translate([35,0,4]) color("gray") cuboid([10,wall,30],rounding=1,p1=[0,0]);
				difference() {
					translate([-5,wall+28,4]) color("white") cuboid([10,wall+7,30],rounding=1,p1=[0,0]);
					EndStopAndWireChainHoles();
				}
				difference() {
					translate([36,wall+28,4]) color("plum") cuboid([10,wall+7,30],rounding=1,p1=[0,0]);
					EndStopAndWireChainHoles();
				}
				difference() {
					translate([-1,wall-8,1]) color("green") cuboid([42,wall,9],rounding=1,p1=[0,0]);
					translate([VerticalCarriageWidth-17,tri_sep-56.8,22]) rotate([90,0,0]) color("red") hull() {
						// bevel the countersink to get easier access to adjuster
						translate([0,0,3]) cylinder(h = depth+10,d = screw5hd/2);
						translate([0,0,10]) cylinder(h = depth,d = screw5hd+25);
					}
				}
				difference() {
					translate([-5,wall+27.5,0]) color("blue") cuboid([51,wall+7.5,15],rounding=1,p1=[0,0]);
					EndStopAndWireChainHoles();
				}
			}
			translate([1,wall+27,wall]) color("green") cube([39,8,50]);
			translate([-23,-4,31]) rotate([0,40,0]) color("lightgray") cube([20,60,20]);
			translate([35,-4,34]) rotate([0,50,0]) color("blue") cube([20,60,20]);
			translate([1,2,7.7]) color("black") cube([44,40,layer]);
			BeltLoopHolderMountingHoles(Screw);
		}
	}
	if(!Loop) BeltMountingHoleBump(1);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module EndStopAndWireChainHoles(Screw=WireChainMount) {
	translate([4,13,-5]) color("khaki") cylinder(h= 20, d=Screw);// screw5t);
	translate([4,33,-5]) color("plum") cylinder(h= 20, d= Screw);// screw5t);
	translate([37,13,-5]) color("gold") cylinder(h= 20, d= Screw);// screw5t);
	translate([37,33,-5]) color("red") cylinder(h= 20, d= Screw);// screw5t);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CarriageBeltDriveStandAlone(Loop=0,DoRearWall=1,DoLayer=0,Screw) {
	difference() {	// base
		translate([-3,-0,0]) color("cyan") cuboid([47,50,wall],rounding=1,p1=[0,0]);
		if(!Loop && (Yes3mmInsert(Use3mmInsert,LargeInsert) == screw3)) {
			hull() {	// belt clamp nut access slot
				translate([-4,belt_adjust,8]) rotate([0,90,0]) color("red") nut(m3_nut_diameter,14); // make room for nut
				translate([-4,belt_adjust,4]) rotate([0,90,0]) color("blue") nut(m3_nut_diameter,14); // make room for nut
			}
			color("gray") hull() {	// belt clamp nut access slot
				translate([31,belt_adjust,8]) rotate([0,90,0]) nut(m3_nut_diameter,14);
				translate([31,belt_adjust,4]) rotate([0,90,0]) nut(m3_nut_diameter,14);
			}
		}
		// mounting screw holes to x-carriage plate
		translate([21.5,wall/2,-30]) rotate([90,0,0]) TopMountBeltHoles(screw3);
		translate([-6.5+(width/4+8.5),wall/2+42,-30]) rotate([90,0,0]) TopMountBeltHoles(screw3);
		color("white") hull() { // plastic reduction
			translate([21,16,-5]) cylinder(h= 20, r = 8);
			translate([21,25,-5]) cylinder(h= 20, r = 8);
		}
		 // mounting holes for an endstop holder & wire chain
		EndStopAndWireChainHoles();
	}
	difference() {	// right wall
		translate([-wall/2-1,0,0]) color("yellow") cuboid([wall-2,50,31],rounding=1,p1=[0,0]);
		if(!Loop) {
			translate([-wall/2-2,belt_adjust,27]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, d=screw3);
			translate([-wall/2-2,belt_adjust,4]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, d=screw3);
			translate([-0.5,belt_adjust,27]) rotate([0,90,0]) color("blue") nut(m3_nut_diameter,3);
			translate([-0.5,belt_adjust,4]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		} else BeltLoopHolderMountingHoles(Screw);
		if(TestLoop) // add one of belt clamp holes for adjusting the belt loop holder mounting holes
			translate([-wall/2-2,belt_adjust,4]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, d=screw3);
		EndStopAndWireChainHoles();
	}
	if(!Loop) BeltMountingHoleBump(0);
	difference() {	// left wall
		translate([36+wall/2,0,0]) color("pink") cuboid([wall-2,50,31],rounding=1,p1=[0,0]);
		//translate([35,-4,34]) rotate([0,50,0]) color("red") cube([20,60,20]);
		if(!Loop) {
			translate([32,belt_adjust,4]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, d=screw3);
			translate([32,belt_adjust,27]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, d=screw3);
			translate([38.5,belt_adjust,4]) rotate([0,90,0]) color("blue") nut(m3_nut_diameter,3);
			translate([38.5,belt_adjust,27]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		} else {
			BeltLoopHolderMountingHoles(Screw);
		}
		EndStopAndWireChainHoles();
	}
	if(!Loop) BeltMountingHoleBump(1);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltLoopHolderMountingHoles(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) { // for beltholder
	// pink side
	translate([35,8+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("black") cylinder(h = 20, d=Screw);
	translate([35,4+LoopHoleOffset+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("white") cylinder(h = 20, d=Screw);
	// yellow side
	translate([-10,8+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("plum") cylinder(h = 20, d=Screw);
	translate([-10,4+LoopHoleOffset+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("gray") cylinder(h = 20, d=Screw);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltMountingHoleBump(Bump) { // add a little plastic at the belt clamp screw holes at the edge
	if(Bump) {
		difference() {	
			translate([40,belt_adjust,27]) rotate([0,90,0]) color("cyan") cylinder(h = wall-2, r = screw3+0.5);
			translate([32,belt_adjust,27]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, d=screw3);
			translate([38.5,belt_adjust,27]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		}
	} else {
		difference() {	
			translate([-wall/2-1,belt_adjust,27]) rotate([0,90,0]) color("cyan") cylinder(h = wall-2, r = screw3+0.5);
			translate([-wall/2-2,belt_adjust,27]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, d=screw3);
			translate([-0.5,belt_adjust,27]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltAdjuster() {
	difference() {
		translate([-1,0,0]) color("blue") cuboid([9,30,9],rounding=1,p1=[0,0]);
		translate([-1.5,5.5,7]) color("red") cube([11,7,3.5]);
		translate([-1.5,16.5,7]) color("cyan") cube([11,7,3.5]);
		translate([4,3,-5]) color("white") cylinder(h = 2*wall, d=screw3);
		translate([4,26,-5]) color("plum") cylinder(h = 2*wall, d=screw3);
		translate([-5,9,4.5]) rotate([0,90,0]) color("gray") cylinder(h = 2*wall, d=screw3);
		translate([-2,9,4.5]) rotate([0,90,0]) color("black") nut(m3_nut_diameter,3);
		translate([-5,20,4.5]) rotate([0,90,0]) color("khaki") cylinder(h = 2*wall, d=screw3);
		translate([7,20,4.5]) rotate([0,90,0]) color("gold") nut(m3_nut_diameter,3);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltAnvil()
{
	translate([0,0,-3]) rotate([0,0,90]) difference() {
		rotate([0,90,0]) cylinder(h = 9, r = 4);
		translate([3,0,-6]) cube([15,10,10],true);
		translate([4,0,-3]) cylinder(h = 5, d=screw3);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Belt_RoundClamp() { // something round to let the belt smoothly move over when using the tensioner screw
	rotate([0,90,90]) difference() {
		cylinder(h = 30, r = 4);
		translate([-6,0,3]) rotate([0,90,0])cylinder(h = 15, d=screw3);
		translate([-6,0,26]) rotate([0,90,0])cylinder(h = 15, d=screw3);
		translate([4.5,0,8]) cube([2,8,45],true); // flatten the top & bottom
		translate([-4.5,0,8]) cube([2,8,45],true);
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CarridgeMount(Screw=screw4) { // four mounting holes for using seperate mounting extruder brcket
	// lower
	translate([mount_seperation/2,-height/4 + mount_height,-5]) color("black") cylinder(h = wall+10, d = Screw);
	translate([-mount_seperation/2,-height/4+ mount_height,-5]) color("blue") cylinder(h = wall+10, d = Screw);
	// upper
	translate([mount_seperation/2,-height/4 + mount_height + mount_seperation,-5])
		color("red") cylinder(h = wall+10, d = Screw);
	translate([-mount_seperation/2,-height/4+ mount_height + mount_seperation,-5])
		color("plum") cylinder(h = wall+10, d = Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanTensionHole() {
	color("pink") cylinder(h=10,d=20);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltClamps(Clamps=0,Loop=0) // belt clamps
{
	if(Clamps && !Loop) {
		translate([-35,-10,-0.5]) color("red") Belt_RoundClamp();
		translate([-50,-10,-4.5]) color("blue") BeltAdjuster();
		translate([-45,-40,0]) color("black") BeltAnvil();
		translate([-35,25,-0.5]) color("cyan") Belt_RoundClamp();
		translate([-50,25,-4.5]) color("purple") BeltAdjuster();
		translate([-45,-25,0]) color("gray") BeltAnvil();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanExtruderBowdenMount() { // extruder bracket for e3d titan to mount on a AL extruder plate
	difference() {
		translate([0,0,0]) cuboid([40,53,5],rounding=1,p1=[0,0]); // extruder side
		translate([20,28,-10]) cylinder(h=20,d=20); // remove some plastic under the motor
		translate([10,10,-1]) cylinder(h=20,d=screw4); // mounting screw hole
		translate([30,10,-1]) cylinder(h=20,d=screw4); // mounting screw hole
		translate([10,45,-1]) cylinder(h=20,d=screw4); // mounting screw hole
		translate([30,45,-1]) cylinder(h=20,d=screw4); // mounting screw hole
	}
	translate([0,1,0]) rotate([90,0,90]) TitanMotorMount();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHoles(Screw=screw3,All=0) {		// screw holes to mount extruder plate
	if(Screw==screw3) {
		translate([0,30-wall/2,-10]) color("red") cylinder(h = 25, d = Screw); // center
		translate([width/2-5,30-wall/2,-10]) color("white") cylinder(h = 25, d = Screw); // right
		translate([-(width/2-5),30-wall/2,-10]) color("lightblue") cylinder(h = 25, d = Screw); // left
		if(All) {
			translate([width/4-2,30-wall/2,-10]) color("green") cylinder(h = 25, d = Screw); // 2nd from right
			translate([-(width/4-2),30-wall/2,-10]) color("purple") cylinder(h = 25, d = Screw); // 2nd from left
		}
	}
	if(Screw==screw5) {
		translate([-(width/2-5),30-wall/2,-10]) color("lightblue") cylinder(h = 25, d = Screw);
		translate([-(width/4-10),30-wall/2,-10]) color("red") cylinder(h = 25, d = Screw);
		translate([width/4-2,30-wall/2,-10]) color("green") cylinder(h = 25, d = Screw);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanMotorMount(WallMount=0,Screw=screw4,InnerSupport=1) {
	difference() {	// motor mount
		translate([-1,0,0]) color("red") cuboid([54,60+ShiftTitanUp,5],rounding=1,p1=[0,0]);
		translate([25,35+ShiftTitanUp,-1]) rotate([0,0,45]) color("purple") NEMA17_x_holes(8, 2);
		color("blue") hull() {
			translate([14,5,0]) cylinder(h=wall*2,d=20); // hotend cooling hole
			translate([37,5,0]) cylinder(h=wall*2,d=20); // hotend cooling hole
		}
	}
	difference() { // front support
		translate([-1,24,-48]) color("blue") rotate([60,0,0]) cuboid([4,60,60],rounding=1,p1=[0,0]);
		translate([-3,-30,-67]) cube([7,90,70]);
		translate([-3,-67,-45]) cube([7,70,90]);
		color("gray") hull() {
			translate([-4,10,wall-1]) rotate([0,90,0]) cylinder(h=10,d=screw5);;
			translate([-4,10,wall+13.5]) rotate([0,90,0]) cylinder(h=10,d=screw5);;
			translate([-4,35,wall-1]) rotate([0,90,0]) cylinder(h=10,d=screw5);;
		}
	}
	if(WallMount) {
		difference() { // front support
			translate([52,0,0]) color("cyan") cuboid([4,45+ShiftTitanUp,45],rounding=1,p1=[0,0]);
			// lower mounting screw holes
			translate([40,15,11]) rotate([0,90,0]) color("cyan") cylinder(h=20,d=Screw);
			translate([40,15,11+mount_seperation]) rotate([0,90,0])  color("blue") cylinder(h=20,d=Screw);
			if(Screw==screw4) { // add screw holes for horizontal extrusion
				translate([40,15+mount_seperation,34]) rotate([0,90,0]) color("red") cylinder(h=20,d=Screw);
				translate([40,15+mount_seperation,34-mount_seperation]) rotate([0,90,0])  color("pink") cylinder(h=20,d=Screw);
			}
		}
	} else {
		if(!InnerSupport) {
			difference() { // rear support
				translate([49,24,-48]) rotate([60]) color("cyan") cuboid([4,60,60],rounding=1,p1=[0,0]);
				translate([47,0,-67]) cube([7,70,70]);
				translate([47,-69,-36]) cube([7,70,70]);
				color("lightgray") hull() {
					translate([46,10,wall-1]) rotate([0,90,0]) cylinder(h=10,d=screw5);;
					translate([46,10,wall+13.5]) color("gray") rotate([0,90,0]) cylinder(h=10,d=screw5);;
					translate([46,35,wall-1]) color("gray") rotate([0,90,0]) cylinder(h=10,d=screw5);;
				}
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module BeltLoopHolder(Quanity=1,ShiftY=-3) {
	for(a=[0:Quanity-1]) {
		difference() {
			translate([a*-30,ShiftY,BeltMSSpacing-BeltWidth]) color("blue") cuboid([23,16,LoopHeight],rounding=1,p1=[0,0]);
			translate([a*-30-1,ShiftY+3,-2]) beltLoop(); // lower
			translate([a*-30-1,ShiftY+3,BeltMSSpacing+BeltSpacing-1]) beltLoop(); // upper
			translate([a*-30+19,-8,0]) BeltLoopMountingCountersink();
			translate([a*-30+19,-8,0]) BeltLoopMouningHoles();
		}
		translate([a*-30+19,-8,0]) BeltLoopMountingBlock();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module BeltLoopHolderOppo(ShiftY=-3,Screw=screw3) {
	BeltLoopHolder(ShiftY,Screw,0);
	translate([60,0,0]) BeltLoopHolder(ShiftY,Screw,1);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module BeltLoopHolder(ShiftY=-3,Screw=screw3,Invert=0) {
	if(Invert) {
			mirror([0,1,0]) rotate([0,0,180]) {
				difference() {
					translate([0,ShiftY-10,BeltMSSpacing-BeltWidth]) color("blue")
						cuboid([23,29,LoopHeight],rounding=1,p1=[0,0]);
					translate([0,ShiftY+3,-2]) beltLoop(); // lower
					translate([0,ShiftY+3,BeltMSSpacing+BeltSpacing-2]) rotate([0,0,0]) beltLoop(); // upper
					if(Screw==screw5)
						translate([20,-21,0]) BeltLoopMountingCountersink(2,screw5hd);
					else if(Screw==screw3)
						translate([20,-21,0]) BeltLoopMountingCountersink(3,screw3hd);
				}
				translate([19,-8,0]) BeltLoopMountingBlock(3,Screw);
			}
	} else {
		difference() {
			translate([0,ShiftY-10,BeltMSSpacing-BeltWidth]) color("blue") cuboid([23,29,LoopHeight],rounding=1,p1=[0,0]);
			translate([0,ShiftY+3,-2]) beltLoop(); // lower
			translate([0,ShiftY+3,BeltMSSpacing+BeltSpacing-2]) rotate([0,0,0]) beltLoop(); // upper
			if(Screw==screw5)
				translate([20,-21,0]) BeltLoopMountingCountersink(2,screw5hd);
			else if(Screw==screw3)
				translate([20,-21,0]) BeltLoopMountingCountersink(3,screw3hd);
		}
		translate([19,-8,0]) BeltLoopMountingBlock(3,Screw);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltLoopMountingBlock(ExtraThickness=0,Screw=screw3) {
	difference() {
		translate([0,-15,BeltMSSpacing-BeltWidth]) color("pink") 
			cuboid([MountThickness+ExtraThickness,45,LoopHeight],rounding=1,p1=[0,0]);
		translate([0,-13,0]) BeltLoopMouningHoles(Screw);
		if(Screw==screw5)
			translate([-3,-13,0]) BeltLoopMountingCountersink(ExtraThickness,screw5hd);
		else if(Screw==screw3)
			translate([-3,-13,0]) BeltLoopMountingCountersink(ExtraThickness,screw3hd);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltLoopMouningHoles(Screw=screw3) {
	color("red") hull() {
		translate([-5,LoopHoleOffset+0.75,BeltMSSpacing+BeltWidth/2]) rotate([0,90,0]) cylinder(h=LoopHeight,d=Screw);
		translate([-5,LoopHoleOffset-0.75,BeltMSSpacing+BeltWidth/2]) rotate([0,90,0]) cylinder(h=LoopHeight,d=Screw);
	}
	 color("blue") hull() {
		translate([-5,4.75,BeltMSSpacing+BeltWidth/2]) rotate([0,90,0]) cylinder(h=LoopHeight,d=Screw);
		translate([-5,3.25,BeltMSSpacing+BeltWidth/2]) rotate([0,90,0]) cylinder(h=LoopHeight,d=Screw);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BeltLoopMountingCountersink(ExtraThickness=0,Screw=screw3hd) {
	color("plum") hull() {
		translate([-22+ExtraThickness,LoopHoleOffset+0.75,BeltMSSpacing+BeltWidth/2]) rotate([0,90,0])
			cylinder(h=LoopHeight+5,d=Screw);
		translate([-22+ExtraThickness,LoopHoleOffset-0.75,BeltMSSpacing+BeltWidth/2]) rotate([0,90,0])
			cylinder(h=LoopHeight+5,d=Screw);
	}
	color("red") hull() {
		translate([-22+ExtraThickness,4.75,BeltMSSpacing+BeltWidth/2]) rotate([0,90,0])
			cylinder(h=LoopHeight+5,d=Screw);
		translate([-22+ExtraThickness,3.25,BeltMSSpacing+BeltWidth/2]) rotate([0,90,0])
			cylinder(h=LoopHeight+5,d=Screw);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module roundedinner() {
	rotate([0,0,-45]) {
		difference() {
			translate([0,0,0]) color("red") cuboid([10,10,wall],p1=[0,0]);
			translate([5,11.9,wall/2]) color("blue") cyl(h=wall+0.1,d=12,rounding=-1);
		}
	}
}

///////////////////end of x-carriage.scad////////////////////////////////////////////////////////////////////////////
