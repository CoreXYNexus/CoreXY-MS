/////////////////////////////////////////////////////////////////////////////////////////
// corexy-motor-bearing.scad - hove the motors, belts & bearing bracket inside the frame
/////////////////////////////////////////////////////////////////////////////////////////
// created 7/5/2026
// last update 8/24/16
/////////////////////////////////////////////////////////////////////////////////////////
// 7/7/16 - added built-in spacer to the bearing_bracket
// 7/14/16 - adjusted 2002 mounting holes to have motor mount clear the makerslide rails
//		   - mirrored bearing() for other side and it now makes all four parts
// 7/15/16 - Made the bearing_bracket() bearing screw hole to be tap sized or not
// 7/16/16 - Made makerslide rail notch in bearing_bracket() optional
//           Added nut hole to bearing_bracket() to use M5x50 screw
// 7/18/16 - Made motor_mount taller above the makerslide
// 7/19/16 - Changed 3rd wall to a diagonal support on motor_mount() and removed notch on
//			 the non-makerslide wall
// 7/20/16 - Moved upper belt stepper motor up 10mm
// 8/23/16 - Added Vthickness & Tthickness for bearing_support()
/////////////////////////////////////////////////////////////////////////////////////////
// NOTE: Bearing position in bearing_bracket() must match stepper motor shaft in motor_mount()
//       If the motors get hot, print it from something that can handle it
//       Bearing stack is 5mm washer,F625Z,F625Z,5mm washer,5mm washer,F625Z,F625Z,5mm washer,
//       M5x50, and a 5mm nut in the nut trap
//		 Motor mounts have two holes on the makerslide side, to allow the makerslide to be installed
//		 either way.
// --------------------------------------------------------------------------------------
//		 Taller motor_mount on left side rear.
//		 Bearing brackets at inside front corners & supports on outside
//		 Install one M5 nut in each bearing bracket
/////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/nema17.scad>	// https://github.com/mtu-most/most-scad-libraries
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
$fn=50;
/////////////////////////////////////////////////////////////////////////////////////////
// vars
b_posY = 29.5;		// bearing position X
b_posX = 20;		// bearing position Y
b_height = 10;		// amount to raise bearings
one_stack = 11.78;	// just the length of two washers & two F625Z bearings
nut5_d = 9.5;		// diameter of z rod nut (point to point + a little)
layer_t = 0.2;		// layer thickness used to print
Vthickness = 7;		// thickness of bearing support vertical section
Tthickness = 5;		// thickness of bearing support top and fillet
/////////////////////////////////////////////////////////////////////////////////////////

//all(0); // all the needed parts
partial();

/////////////////////////////////////////////////////////////////////////////////////////

module all(MS) {
	motor_mount(1);
	translate([65,-29.5,-2.5]) rotate([0,0,90]) bearing_bracket();
	translate([85,25,one_stack*2+b_height+40]) rotate([0,180,0]) bearing_support(MS);
	translate([0,70,0]) motor_mount(0);
	translate([65,99.5,-2.5]) rotate([0,0,90]) mirror() bearing_bracket(); // mirror it for the other side
	translate([60,-65,one_stack*2+b_height+40]) rotate([0,180,0]) bearing_support(MS);
}

/////////////////////////////////////////////////////////////////////////////////////////

module partial() { // uncomment the parts you want and adjust translates as needed
	motor_mount(1);
	//translate([0,70,0]) motor_mount(0);
	//bearing_bracket(0);
	//translate([-5,0,0]) mirror() bearing_bracket(); // mirror it for the other side
	//rotate([0,180,0]) 
	//	bearing_support(1);
	//translate([0,50,0]) rotate([0,180,0]) bearing_support(1);
}

/////////////////////////////////////////////////////////////////////////////////////////

module motor_mount(Side=0) {	// 0 - lower belt motor; 1 = upper belt motor
	difference() {	// motor mounting holes
		cubeX([59,59,5],radius=2,center=true);
		translate([0,0,-4]) rotate([0,0,45])  NEMA17_x_holes(7, 2);
		//translate([0,0,10]) notchit(Side);
	}
	if(!Side) {
		diag_side(Side);
		difference() { // make wall thicker at notch
			translate([0,25,5]) cubeX([58,4,14],radius=2,center=true);
			translate([0,0,10]) notchit(Side);
		}
		difference() {
			translate([0,27,23]) cubeX([59,5,48],radius=2,center=true);
			mountscrews(18);
			translate([0,0,10]) notchit(Side);
		}
		difference() {
			translate([27,0,23]) cubeX([5,59,48],radius=2,center=true);
			mountscrews(18);
			translate([0,0,10]) notchit(Side);
		}
	} else {
		diag_side(Side);
		difference() {
			translate([0,-27,28]) cubeX([59,5,58],radius=2,center=true);
			mountscrews(28);
			translate([0,0,20]) notchit(Side);
		}
		difference() { // make wall thicker at notch
			translate([0,-25,17]) cubeX([58,4,14],radius=2,center=true);
			translate([0,0,10]) notchit(Side);
		}
		difference() {
			translate([27,0,28]) cubeX([5,59,58],radius=2,center=true);
			mountscrews(28);
			translate([0,0,20]) notchit(Side);
		}
	}
	//difference() { // make wall thicker at notch
	//	translate([25,0,5]) cubeX([4,55,14],radius=2,center=true);
	//	translate([0,0,10]) notchit(Side);
	//}
}

/////////////////////////////////////////////////////////////////////////////////////////

module notchit(Side=0) {
	if(Side)
		translate([-59,-59/2-4.5,-10]) ms_notch();
	else
		translate([-59,59/2+4.5,-10]) ms_notch();
	//translate([59/2+4.5,-59,-10]) rotate([0,0,90]) ms_notch();
}

////////////////////////////////////////////////////////////////////////////////////////

module ms_notch() {
	rotate([45,0,0]) cube([100,10,10]);
}

/////////////////////////////////////////////////////////////////////////////////////////

module mountscrews(Mount_S) { // all of them; Mount_S is hight of top screw holes
	translate([-14,40,Mount_S]) rotate([90,0,0]) cylinder(h=80,r=screw5/2);
//	translate([14,40,Mount_S]) rotate([90,0,0]) cylinder(h=80,r=screw5/2);
	translate([-42,14,Mount_S]) rotate([0,90,0]) cylinder(h=80,r=screw5/2);
	translate([-42,-14,Mount_S]) rotate([0,90,0]) cylinder(h=80,r=screw5/2);
	translate([-14,40,Mount_S+20]) rotate([90,0,0]) cylinder(h=80,r=screw5/2);
//	translate([14,40,Mount_S+20]) rotate([90,0,0]) cylinder(h=80,r=screw5/2);
	translate([-42,14,Mount_S+20]) rotate([0,90,0]) cylinder(h=80,r=screw5/2);
	translate([-42,-14,Mount_S+20]) rotate([0,90,0]) cylinder(h=80,r=screw5/2);
}

/////////////////////////////////////////////////////////////////////////////////////////

module bearing_bracket(TapIt=0) {
	difference() {
		cubeX([40,30,40],2);
		if(TapIt)
			translate([b_posY,b_posX,-2]) cylinder(h=50,r=screw5t/2);
		else
			translate([b_posY,b_posX,-2]) cylinder(h=50,r=screw5/2);
		translate([-2,10,30]) rotate([0,90,0]) cylinder(h=45,r=screw5/2);
		translate([5,10,30]) rotate([0,90,0]) cylinder(h=45,r=screw5hd/2);
		translate([20,32,10]) rotate([90,0,0]) cylinder(h=45,r=screw5/2);
		translate([20,25,10]) rotate([90,0,0]) cylinder(h=45,r=screw5hd/2);
		translate([20,32,30]) rotate([90,0,0]) cylinder(h=45,r=screw5/2);
		translate([20,25,30]) rotate([90,0,0]) cylinder(h=45,r=screw5hd/2);
		translate([-2,10,10]) rotate([0,90,0]) cylinder(h=45,r=screw5/2);
		translate([5,10,10]) rotate([0,90,0]) cylinder(h=45,r=screw5hd/2);
		if(!TapIt) translate([b_posY,b_posX,-b_height-8]) cylinder(h=50,d=nut5_d,$fn=6); // nut hole
	}
	if(!TapIt) translate([b_posY-4,b_posX-4.5,b_height+30-8]) cube([10,10,layer_t]); // nut hole support
	translate([b_posY,b_posX,40]) spacer(TapIt);
}

/////////////////////////////////////////////////////////////////////////////////////////

module spacer(TapIt=0) { // spacer to raise bearing on bearing braket to match the corexy-xy.scad
	difference() {
		cylinder(h=b_height,r=screw5);
		if(TapIt)
			translate([0,0,-1]) cylinder(h=b_height+2,r=screw5t/2);
		else
			translate([0,0,-1]) cylinder(h=b_height+2,r=screw5/2);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////

module bearing_support(NotchIt=0) {	// keep the bearing from tilting on the bracket
	// NotchIt == 1 to notch it for the makerslide rail
	difference() { // vertical
		translate([-1,-10,0]) cubeX([Vthickness,40,one_stack*2+b_height+43],2); // vertical
		translate([-3,0,10]) rotate([0,90,0]) cylinder(h=20,d=screw5); // screw mounting holes
		translate([-3,20,10]) rotate([0,90,0]) cylinder(h=20,d=screw5);
		translate([-3,0,30]) rotate([0,90,0]) cylinder(h=20,d=screw5);
		translate([-3,20,30]) rotate([0,90,0]) cylinder(h=20,d=screw5);
		if(NotchIt)	translate([Vthickness+3,-40,33]) rotate([0,0,90]) ms_notch(); // notch it?
	}
	if(NotchIt) {
		difference() {	// extra support at notch
			translate([0,28.5,40]) rotate([90,0,0]) cylinder(h=37,d=12,$fn=100); // strengthen the vertical
			translate([-5,0,30]) rotate([0,90,0]) cylinder(h=5,d=screw5hd);	// screw head clearance
			translate([-5,20,30]) rotate([0,90,0]) cylinder(h=5,d=screw5hd);
			translate([2,-15,35]) cube([10,50,10]); // remove any of the cylinder on notch side
		}
	}
	difference() { // top
		translate([0,0,one_stack*2+b_height+38]) cubeX([50,20,Tthickness],2);
		translate([Vthickness+28,10,one_stack*2+b_height]) cylinder(h=50,d=screw5);
	}
	difference() { // angled support for top
		translate([-11,8,one_stack*2+b_height+30]) rotate([0,45,0]) cubeX([20,Tthickness,45],2);
		translate([-19,7,one_stack*2+b_height+10]) cube([20,7,40]);
		translate([-4,7,one_stack*2+b_height+42]) cube([40,7,25]);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

module diag_side(Side) {
	if(Side) {
		difference() {
			translate([-2,24.5,-7]) rotate([0,-45,0]) cubeX([50,5,10],2);
			translate([-20,23.5,-10]) cube([50,10,10],2);
			translate([27,23.5,40]) rotate([0,90,0]) cube([50,10,10],2);
		}
	} else {
		difference() {
			translate([-2,-29.5,-7]) rotate([0,-45,0]) cubeX([50,5,10],2);
			translate([-20,-30.5,-10]) cube([50,10,10],2);
			translate([27,-30.5,40]) rotate([0,90,0]) cube([50,10,10],2);
		}
	}
}

/////////////////// emd of corexy-motor-bearing.scad ////////////////////////////////////