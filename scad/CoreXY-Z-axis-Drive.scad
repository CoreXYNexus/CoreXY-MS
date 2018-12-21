/////////////////////////////////////////////////////////////////////////////////////////////////////////
// CoreXY-Z-Axis-Drive.scad --  z-axis motor mount for corexy makerslide
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created: 3/2/2013
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Last Update: 12/20/2018
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// 6/28/16	- modified z-axis_motor_mount.scad from Makerslide Mendel printer for corexy z
// 7/3/16	- added assembly info
// 7/4/16	- added flange nut style and testnut() to print only znut section for testing
// 7/27/16	- cleaned up code and added test prints
//			  changed znut to inside mount, added notches for makerslide
//			  spruced up the side supports
// 8/21/16	- Added belt drive version
// 8/23/16	- GT2 40t pulleys arrived, adjusted spacer thickness and motor mount height
// 11/5/16	- Added idler bearing to the z axis bearing mounts, so that the belt would wrap around more
//			  Didn't bother to make left/right versions
// 1/29/17	- Removed bed pivots from here and made a new file: bearing_pivots.scad
// 1/31/17	- Added plates to mount makerslide instead of drilling access holes & threading the makerslide
//			  Made z leadscrew bearing mount outside larger for better strength
// 2/4/17	- Added AddOffset to single() for z-axis rail, changed to a single idler mount on
//			  bearing_mount()
// 2/5/17	- Added a spacer block for the 3rd z-axis makerslide bearing/motor mount
// 7/9/18	- Added use of coreer-tools.scad to round over bearing holder
//			  added bearing_ider() to all()
// 7/13/18	- Made plates to fit a 200x200 bed
// 8/19/18	- OpenSCAD 2018.06.01 for $preview
// 12/20/18	- Removed redundant modules and added for loops for quanities
////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/nema17.scad>	// https://github.com/mtu-most/most-scad-libraries
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
use <corner-tools.scad>
use <Z-Motor_Leadscrew-Coupler.scad>
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
// Uses M5x6 screws & t-nuts for mounting to makerslide & extrusion
//-----------------------------------------------------------------------------------------------------
// For the belt version, you move the stepper motor mount to tension belt
// Uses one 40 tooth GT2 belt pulley, 1 608 bearing, 2 washers, one lockring
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
// variables
///////////////////////////////////////////////////////////////////////////////////////////////////////
shaft_offset = 10.5;	// adjust center of stepper motor or bearing mount
base_offset = 5.5;		// shift base
b_width = 55;			// base width
b_length = 48.5 + shaft_offset;	// base length
thickness = 5; 			// thickness of everything
m_height = 40;			// mount wall height
ms_notch_depth = 2.5;	// depth of the notch for makerslide
ms_notch_offset = 21;	// where to put the notch
//-----------------------------------------------------------------------
hole_off = 140;			// mounting holes on makerslide carriage plate
outside_d = 155;		// overall length
thicknessZ = 20;		// actually the width
shift1 = 4;				// amount to shift mounting columns up/down
raise = 30 + shift1;	// zrod distance from the carriage plate
clearance = 0.7;		// allow threaded rod to slide without problem
zrod = 5 + clearance;	// z rod thread size
znut_d = 9.5;			// diameter of z rod nut (point to point + a little)
z_height = zrod + 10 - clearance;	// height is zrod dependent
zshift = 18;			// move the zrod hole
zadjust = 9.5;			// move inner cylinder hull to make connection to bar
znut_depth = 5; 		// how deep to make the nut hole
// Sizes below are for a TR8 flanged nut
flange_screw = 4;		// screw hole
flangenut_d = 10.7;		// threaded section outside diameter
flangenut_od = 22.5;	// flange outside diameter
flangenut_n	= 16.5;		// flange nut distance of opposite screw holes
TR8_d = 8+clearance;	// diameter of TR8
//-----------------------------------------------------------------------
dia_608 = 22+clearance;		// outside diameter of a 608
h_608 = 7; 					// thickness of a 608
nut_clearance = 17;			// clearance for a 8mm nut
dia_f625z = 18;				// f625z flange diameter
shiftbm = 0; 				// move belt motor mount up/down (- shifts it up)
GT2_40t_h = 6.1;			// thickness of the clamping part on the 40 tooth GT2 pulley
idler_spacer_thickness = GT2_40t_h + 0.9;	// thickness of idler bearing spacer
layer = 0.25;				// printed layer thickness
////////////////////////////////////////////////////////////////////////////

direct_drive(3,1,5,8); 	// Z axis for bed leveling
					// 1st arg: quantiy;2nd arg: printable couplers; 3rd arg is motor shaft diameter; 4th arg is leadscrew diameter
//belt_drive(3);	// arg is quanity, belt drive leadscrew mounts and znut
//belt_motor_Mount();  // z motor mount for belt version
//plates(3); // arg is quanity*2
//partial();
	
//////////////////////////////////////////////////////////////////////////////

module direct_drive(Quanity=1,Coupler,Motorshaft,LeadScrewDiameter) { // set for makerslide
	if($preview) %translate([-100,-100,-2]) cube([200,200,2]);
	for(a=[0:Quanity-1]) {
		translate([a*65-65,0,thickness/2]) motor_mount(1);
		if(Coupler) translate([a*65-65,50,0]) coupler(Motorshaft,LeadScrewDiameter); // printed coupler
		translate([(a*65)-142,-50,0]) single(); // one znut nut holder
	}
	echo("-----------------Don't forget the plates-------------------"); // adding plates makes it bigger than a 200x200 bed
}

module belt_drive(Quanity=1) {
	if($preview) %translate([0,0,-5]) cube([200,200,2],center=true);
	// a motor driving leadscrew via a belt
	for(a=[0:Quanity-1]) {
		translate([a*65-65,0,0]) bearing_mount(1); // bearing mount at bottom of z-axis leadscrew
		translate([(a*65)-142,-50,0]) single(); // znut holder
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_motor_Mount() {
	if($preview) %translate([0,0,-5]) cube([200,200,2],center=true);
	translate([-30,-30,0]) belt_motor(1);	// one stepper motor mount with idler
	translate([10,-30,-2.5]) lockring();	// something to hold leadscrew in bearing
	translate([10,0,-2.5]) lockring();	// something to hold leadscrew in bearing
	translate([10,30,-2.5]) lockring();	// something to hold leadscrew in bearing
}

module motor_direct(Quanity=1) {  // z motor mount for 3 z motors
	if($preview) %translate([0,0,-5]) cube([200,200,2],center=true);
	for(a=[0:Quanity-1]) {
		translate([a*65-65,0,0]) motor_mount(1);
		translate([(a*65)-142,-50,0]) single(); // znut holder
	}
}

/////////////////////////////////////////////////////////////////////////////

module partial() { // this is here just to make it easier to print a single item
	//translate([0,0,2.5]) motor_mount(1);
	//translate([60,0,0]) motor_mount(1);
	//translate([-65,0,0]) single(); // one znut nut holder
	//translate([-15,30,0]) single(25); // znut nut holder for third rail where Z makerslide is mounted on outside of makerslide
	//test();  // test print for checking motor alignment
	//rotate([-90,0,0]) testnut(1);	// print a shortened nut section for test fitting
	//translate([0,0,2.5]) bearing_mount(0);
	//translate([70,0,2.5]) bearing_mount(); // bearing mount at bottom of z-axis leadscrew
	//test_bearing_hole(); // test fit the bearing hole
	//translate([60,0,0])
	//	belt_motor(1);	// 1 - include idlers on mount
	//translate([95,-50,-2.5])
	//	bearing_idler();
	//translate([-37,0,0]) lockring();
	//translate([-37,20,0]) lockring();
	//idler_spacers(1); // included with belt_motor()
	//translate([0,60,0]) plates(2,1);
	//translate([-20,60,0]) plate2();
	//translate([25,60,0]) plate2();
	//translate([40,0,0]) third_z_spacer();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module motor_mount(makerslide=0) { // motor mount
	rotate([180,0,0]) {
		nema_plate(makerslide);
		mount(makerslide);
	}
}

////////////////////////////////////////////////////////////////////////////

module mount(makerslide=0) {
	difference() {
		translate([0,22,-18]) color("cyan") cubeX([b_width,thickness,m_height],2, center=true);
		translate([10,30,-10]) rotate([90,0,0]) color("red") cylinder(h=20,d=screw5); // top screw hole
		translate([10,30,-30]) rotate([90,0,0]) color("white") cylinder(h=20,d=screw5); // bottom screw hole
		translate([-10,30,-10]) rotate([90,0,0]) color("blue") cylinder(h=20,d=screw5);	// top screw hole
		translate([-10,30,-30]) rotate([90,0,0]) color("grey") cylinder(h=20,d=screw5);	// bottom screw hole
		if(makerslide) notchit();
	}
	side_support();
	translate([-b_width+thickness,0,0]) side_support(); 
	if(makerslide) { // inside support at ns notches
		translate([-5+ms_notch_offset,20-ms_notch_depth,-m_height+3]) color("blue") cubeX([10,thickness-1,m_height-2],2);
		translate([-48+ms_notch_offset,20-ms_notch_depth,-m_height+3]) color("red") cubeX([10,thickness-1,m_height-2],2);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module notchit() {
	translate([-7+ms_notch_offset,31-ms_notch_depth,5]) rotate([0,90,0]) ms_notch();
	translate([-7-ms_notch_offset,31-ms_notch_depth,5]) rotate([0,90,0]) ms_notch();
}
/////////////////////////////////////////////////////////////////////////////////////////

module side_support() {
	difference() {	// side support
		union() {
			translate([b_width/2-thickness,-(b_length-29),-8]) rotate([-30,0,0])
				color("gray") cubeX([thickness,b_width+6,m_height],2);
			translate([b_width/2-thickness,-(b_length-22),-4]) rotate([-30,0,0])
				color("gray") cubeX([thickness,b_width+6,m_height],2);
		}
		translate([b_width/2-thickness-0.5,-(b_length-20),1]) color("cyan") cube([6,90,60]);
		translate([b_width/2-thickness-0.5,-(b_length-82),-50]) color("pink") cube([6,50,60]);
		color("yellow") hull() {
			translate([b_width/2-thickness-0.5,7,-14]) rotate([0,90,0]) cylinder(h=6,r=10,$fn=100);
			translate([b_width/2-thickness-0.5,-12,-9]) rotate([0,90,0]) cylinder(h=6,r=5,$fn=100);
		}
		notchit();
	}
}

////////////////////////////////////////////////////////////////////////////

module nema_plate(makerslide=0) {
	difference() {
		translate([0,-(shaft_offset-base_offset),0]) color("red") cubeX([b_width,b_length,thickness],2,center=true);
		//translate([0,-shaft_offset+2,-4]) rotate([0,0,90])  NEMA17_parallel_holes(b_width,8);
		translate([0,-shaft_offset,-4]) rotate([0,0,45]) color("white") NEMA17_x_holes(7, 2);
		if(makerslide) notchit();
	}
}

/////////////////////////////////////////////////////////////////////////////

module test() { // do a partial print to test fit position of motor to nut/flange
	difference() {
		ms_motor_mount();
		translate([-50,-50,4]) cube([100,100,100]);
	}
}

////////////////////////////////////////////////////////////////////////////////////////

module ms_notch() {
	rotate([45,0,0]) color("white") cube([100,10,10]);
}

///////////////////////////////////////////////////////////////////////////////////

module single(,AddOffset=0) { // one z-nut mount
	translate([0,0,thicknessZ]) rotate([-90,0,0])	// all coordinates in modules are without this line
		znut(1,AddOffset);
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module znut(Type=0,AddOffset=0) {	// 0 = nut, 1 = TR8 leadscrew
	difference() {
		translate([outside_d/3-1,0,0]) color("cyan") cubeX([outside_d/3+2,thicknessZ,z_height],2);
		platemounthole2(0,screw5);
		platemountholeNut(0,nut5);
		platemounthole2(1,screw5);
		platemountholeNut(1,nut5);
		zhole(Type);
		znuthole(Type);
		zholeCS(Type,AddOffset);
	}
	difference() {
		zholesupport(Type,AddOffset);	// may need some extra around zrod hole
		zholeCS(Type,AddOffset);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module zholeCS(Type,AddOffset=0) { // countersink flange nut
	if(Type==1) {
		translate([outside_d/2,znut_depth,z_height/2-zshift-AddOffset]) 
			rotate([90,0,0]) color("red") cylinder(h=10,d=flangenut_od,$fn=100);
	}
	if(Type==0) ; // nothing
}

//////////////////////////////////////////////////////////////////

module platemounthole(left,screw=screw5) {
	if(!left) translate([z_height/2,thicknessZ/2,-1]) color("blue") cylinder(h=raise*2,r=screw/2,$fn=100);
	if(left) translate([outside_d - z_height/2,thicknessZ/2,-1]) color("white") cylinder(h=raise*2,r=screw/2,$fn=100);
}

//////////////////////////////////////////////////////////////////

module platemounthole2(left,screw=screw5) {
	if(!left) translate([outside_d/2-20,thicknessZ/2,-1]) color("blue") cylinder(h=raise*2,r=screw/2,$fn=100);
	if(left) translate([outside_d/2+20,thicknessZ/2,-1]) color("white") cylinder(h=raise*2,r=screw/2,$fn=100);
}

//////////////////////////////////////////////////////////////////

module platemountholeCS(left,screw=screw5hd) {
	if(!left) translate([z_height/2,thicknessZ/2,-1]) color("blue") cylinder(h=5,r=screw/2,$fn=100);
	if(left) translate([outside_d - z_height/2,thicknessZ/2,-1]) color("white") cylinder(h=5,r=screw/2,$fn=100);
}

//////////////////////////////////////////////////////////////////

module platemountholeNut(left,screw=screw5hd) {
	if(!left) translate([outside_d/2-20,thicknessZ/2,-1]) color("blue") cylinder(h=5,r=screw/2,$fn=6);
	if(left) translate([outside_d/2+20,thicknessZ/2,-1]) color("white") cylinder(h=5,r=screw/2,$fn=6);
}

//////////////////////////////////////////////////////////////////

module zhole(Type,AddOffset) {
	if(!Type) {
		translate([outside_d/2,thicknessZ*1.5,z_height/2-zshift-AddOffset])
			rotate([90,0,0]) color("gray") cylinder(h=thicknessZ*2,r = zrod/2,$fn=100);
	}
	if(Type) {
		translate([outside_d/2,thicknessZ*1.5,z_height/2-zshift-AddOffset])
			rotate([90,0,0]) color("gray") cylinder(h=thicknessZ*2,r = flangenut_d/2,$fn=100);

	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module zholesupport(Type,AddOffset=0) { // will it need extra width at the zrod?
	difference() {
		if(!Type) {
			color("pink") hull() {
				translate([outside_d/2,thicknessZ,z_height/2-zshift+zadjust])
					rotate([90,0,0]) cylinder(h=thicknessZ,r = zrod*2.5,$fn=100);
				translate([outside_d/2,thicknessZ,z_height/2-zshift]) rotate([90,0,0])
					cylinder(h=thicknessZ,r = zrod*2.5,$fn=100);
			}
		}
		if(Type) {
			color("pink") hull() {
				translate([outside_d/2,thicknessZ,z_height/2-zshift+zadjust])
					rotate([90,0,0]) cylinder(h=thicknessZ,r = flangenut_od/1.5,$fn=100);
				translate([outside_d/2,thicknessZ,z_height/2-zshift-AddOffset]) rotate([90,0,0])
					cylinder(h=thicknessZ,r = flangenut_od/1.5,$fn=100);
			}
		}
		zhole(Type,AddOffset);
		znuthole(Type,AddOffset);
	}
}

/////////////////////////////////////////////////////////////////////

module znuthole(Type,AddOffset) {
	if(!Type) {
		translate([outside_d/2,znut_depth,z_height/2-zshift]) rotate([90,0,0])
			color("black") cylinder(h=thicknessZ,r = znut_d/2,$fn=6);
	}
	if(Type) { // make mounting screw holes
		translate([outside_d/2+flangenut_n/2,thicknessZ+5,z_height/2-zshift-AddOffset])
			rotate([90,0,0]) color("red") cylinder(h=thicknessZ+8,r = flange_screw/2);
		translate([outside_d/2-flangenut_n/2,thicknessZ+5,z_height/2-zshift-AddOffset])
			rotate([90,0,0]) color("white") cylinder(h=thicknessZ+8,r = flange_screw/2);
		translate([outside_d/2,thicknessZ+5,z_height/2-zshift+flangenut_n/2-AddOffset])
			rotate([90,0,0]) color("blue") cylinder(h=thicknessZ+8,r = flange_screw/2);
		translate([outside_d/2,thicknessZ+5,z_height/2-zshift-flangenut_n/2-AddOffset])
			rotate([90,0,0]) color("black") cylinder(h=thicknessZ+8,r = flange_screw/2);
	}
}

////////////////////////////////////////////////////////////////////////////

module testnut(Type) { 	// a shortened nut section for test fitting of the nut & zrod or flange nut
	difference() {
		translate([-60,0,0]) zholesupport(Type);
		if(!Type) translate([-10,znut_depth+3,-35]) cube([60,20,60]);
		if(Type) translate([-10,5,-40]) cube([60,20,60]);
		translate([-60,-3.5,0]) zholeCS(Type);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bearing_mount(Spc=0,SpcThk=idler_spacer_thickness) { // bearing holder at bottom of z-axis
	rotate([180,0,0]) {										// didn't bother to make a left/right versions
		mount(1);
		difference() {
			translate([0,-(shaft_offset-base_offset),0]) color("navy") cubeX([b_width,b_length,thickness],2,center=true);
			translate([0,-shaft_offset,-6]) color("red") cylinder(h=10,d=dia_608,$fn=100);
			notchit();
		}
		translate([0,-shaft_offset,0]) bearing_hole();
		translate([-5+ms_notch_offset,20-ms_notch_depth,-m_height+3]) color("white") cubeX([10,thickness-1,m_height-2],2);
		translate([-48+ms_notch_offset,20-ms_notch_depth,-m_height+3])
			color("green") cubeX([10,thickness-1,m_height-2],2);
	}
	if(Spc) translate([0,10,-2.5]) idler_spacers(0,SpcThk);
	single_attached_idler(1);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bearing_hole() {	// holds the bearing
	translate([0,0,-6.5]) difference() {
		translate([0,0,thickness/3]) color("blue") cylinder(h=h_608,d=dia_608+10,$fn=100);
		translate([0,0,0]) color("red") cylinder(h=15,d=dia_608,$fn=100);
	}
	difference() {
		translate([0,0,-h_608-1.3]) color("white") cylinder(h=h_608/2,d=dia_608+10,$fn=100);
		translate([0,0,-h_608-5]) color("black") cylinder(h=15,d=nut_clearance,$fn=100);
		translate([0,0,-8.4]) rotate([0,180,0]) color("red") fillet_r(2,(dia_608+10.1)/2,1,$fn);
	}
	bearing_hole_support();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module bearing_hole_support() { // print support for bearing hole
	translate([0,0,-5]) color("pink") cylinder(h=layer,d=dia_608+5,$fn=100);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module test_bearing_hole() { // test to see if it really fits
	difference() {
		cubeX([dia_608+10,dia_608+10,thickness],2,center=true);
		translate([0,0,-5]) cylinder(h=10,d=nut_clearance,$fn=100);
	}
	bearing_hole();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_motor(idler=0) { // motor mount for belt drive
	rotate([180,0,0]) {
		nema_plate(0);	// nema17 mount
		mountbelt();	// motor mount base
	}
	difference() {	// mount to 2020
		translate([-b_width/2,-45,-thickness/2-shiftbm]) color("cyan") cubeX([b_width,24.5,21],2);	// base
		translate([-b_width/2-1,-38,-21-shiftbm]) rotate([45,0,0]) color("gray") cube([b_width+2,22,40]); // remove half
		translate([-b_width/2+10,-35,-thickness/2-shiftbm])
			color("red") cylinder(h=40,d=screw5);	// mounting screw holes
		translate([b_width/2-10,-35,-thickness/2-shiftbm]) color("white") cylinder(h=40,d=screw5);
		translate([-b_width/2+10,-35,-thickness/2-shiftbm+1]) color("blue") cylinder(h=15,d=screw5hd);	// countersinks
		translate([b_width/2-10,-35,-thickness/2-shiftbm+1]) color("gray") cylinder(h=15,d=screw5hd);
		translate([-b_width/2-1,-42,-22.5]) color("pink") cube([b_width+5,22.5,20],2); // make sure it doesn't go past top
	}
	belt_motor_mount_support();	// make 2020 mount holes printable
	if(idler) attached_idler(1,1);	// add idler to the motor mount
	if(idler) translate([0,45,0]) attached_idler(0); // top idler plate
	//translate([11,42,5]) testf625z(); // this is use to check bearing clearance to support wall
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_motor_mount_support() {	// print support for inner hole
		translate([-b_width/2+10,-35,-thickness/2-shiftbm+16]) color("black") cylinder(h=layer,d=screw5hd);
		translate([b_width/2-10,-35,-thickness/2-shiftbm+16]) color("yellow") cylinder(h=layer,d=screw5hd);
}

////////////////////////////////////////////////////////////////////////////

module mountbelt() { // the three sides of the motor mount; same as mount(), but no screw holes
	translate([0,22,-18]) color("white") cubeX([b_width,thickness,m_height],2, center=true);
	side_support();
	translate([-b_width+thickness,0,0]) side_support(); 
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bearing_idler() {	// belt idler (currently not used)
	difference() {
		color("cyan") cubeX([20,100,20],2);
		translate([10,90,-1]) color("red") cylinder(h=50,d=screw5,$fn=100);
		translate([10,90-dia_f625z-12,-1]) color("black") cylinder(h=50,d=screw5,$fn=100);
	}
	difference() {
		translate([-b_width/3,-19,0]) color("green") cubeX([b_width,23,20],2);
		translate([-b_width/3-1,-36,14]) rotate([-45,0,0]) color("blue") cube([b_width+2,22,40]);
		translate([-b_width/2+18,-8,-thickness/2]) color("white") cylinder(h=40,d=screw5);
		translate([b_width/2,-8,-thickness/2]) color("pink") cylinder(h=40,d=screw5);
		translate([-b_width/2+18,-8,5]) color("salmon") cylinder(h=15,d=screw5hd);
		translate([b_width/2,-8,5]) color("black") cylinder(h=15,d=screw5hd);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module lockring() { // lock ring to hold TR8 leadscrew in bearing, may not be necessary since gravity will hold it
	difference() {
		color("cyan") cylinder(h=h_608+1,d=nut_clearance-2,$fn=100);
		translate([0,0,-1]) color("red") cylinder(h=15,d=TR8_d,$fn=100);
		translate([0,0,2.5]) rotate([90,0,0]) color("black") cylinder(h=10,d=screw3t);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module attached_idler(Spc=0,Spt=0) { // Spc = spacers, Spt = add support to attached idler plate
	if(Spt) {
		difference() { // needs to be a bit wider with Spt==1
			translate([-12,30,-2.5]) color("green") cubeX([39.5,40,thickness],2);
			translate([-2,60,-5]) color("white") cylinder(h=10,d=screw5);
			translate([dia_f625z-dia_f625z/2+2,60-dia_f625z,-5]) color("red") cylinder(h=10,d=screw5);
		}
	} else {
		difference() {
			translate([-12,30,-2.5]) color("lightgreen") cubeX([33,40,thickness],2);
			translate([-2,60,-5]) color("cyan") cylinder(h=10,d=screw5);
			translate([dia_f625z-dia_f625z/2+2,60-dia_f625z,-5]) color("pink") cylinder(h=10,d=screw5);
		}
	}
	if(Spt) translate([22.5,26,-2.5]) color("blue") cubeX([thickness,44,thickness*3],2);
	if(Spc) translate([-7.5,10,-2.5]) idler_spacers(1,idler_spacer_thickness);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module idler_spacers(Two=0,Thk=idler_spacer_thickness,Spt=0) {
	difference() {
		color("red") cylinder(h=Thk,d=screw5+5);
		translate([0,0,-1]) color("white") cylinder(h=idler_spacer_thickness*2,d=screw5);
	}
	if(Two) {
		translate([15,0,0]) difference() {
			color("red") cylinder(h=Thk,d=screw5+5);
			translate([0,0,-1]) color("white") cylinder(h=idler_spacer_thickness*2,d=screw5);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module testf625z() { // used to check fit
	difference() {
		color("cyan") cylinder(h=5,d=dia_f625z);
		translate([0,0,-1]) color("red") cylinder(h=7,d=screw5);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_attached_idler(Spc=1) { // Spc = spacers, Spt = add support to attached idler plate
	difference() { // needs to be a bit wider with Spt==1
		translate([-27.5,30,-2.5]) color("white") cubeX([55,25,thickness],2);
		translate([0,63-dia_f625z,-5]) color("red") cylinder(h=10,d=screw5);
	}
	translate([22.5,25,-2.5]) color("salmon") cubeX([thickness,30,thickness+7],2);
	translate([-27.5,25,-2.5]) color("pink") cubeX([thickness,30,thickness+7],2);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module plates(Qty=1,MS=0) { // mouting plates for z axis makerslide (instead of drilling access holes)
	if($preview) %translate([-50,-50,-2]) cube([200,200,2]);
	for(i=[0:Qty-1]){
		translate([0,i*45,0]) plate1();
		translate([45,i*45,0]) {
			if(MS)
				plate2();
			else
				plate1();
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module plate1() { // no notch for makerslide
	difference() {
		color("cyan") cubeX([40,40,5],2);
		plate_screws();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module plate2() { // no notch for makerslide
	difference() {
		color("cyan") cubeX([40,40,5],2);
		plate_screws();
		translate([-5,20,-11]) ms_notch2();
	}
	difference() {
		translate([2,20,3]) rotate([0,90,0]) color("white") cylinder(h=36,d=10,$fn=100);
		translate([0,15,-6]) color("black") cube([50,10,10]);
		plate_screws();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module plate_screws() {
	translate([10,10,-2]) color("red") cylinder(h=10,d=screw5,$fn=100);
	translate([30,10,-2]) color("white") cylinder(h=10,d=screw5,$fn=100);
	translate([10,30,-2]) color("blue") cylinder(h=10,d=screw5,$fn=100);
	translate([30,30,-2]) color("gray") cylinder(h=10,d=screw5,$fn=100);
	// countersinks
	translate([10,10,4]) color("red") cylinder(h=10,d=screw5hd,$fn=100);
	translate([30,10,4]) color("white") cylinder(h=10,d=screw5hd,$fn=100);
	translate([10,30,4]) color("blue") cylinder(h=10,d=screw5hd,$fn=100);
	translate([30,30,4]) color("gray") cylinder(h=10,d=screw5hd,$fn=100);
}


////////////////////////////////////////////////////////////////////////////////////////////////////

module ms_notch2() {
	rotate([45,0,0]) color("tan") cube([50,10,10]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module third_z_spacer() { // allow z makerslide to mount to the outside of a makerslide
	difference() {
		color("cyan") cubeX([40,25,15],2);
		translate([10,30,7.5]) rotate([90,0,0]) color("red") cylinder(h=40,d=screw5,$fn=100);
		translate([30,30,7.5]) rotate([90,0,0]) color("blue") cylinder(h=40,d=screw5,$fn=100);
	}
}

/////////////// end of corexy-z-axis.scad ////////////////////////////////////////////////////////////////////
