///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Dual_titan.scad - to mount two titans with a e3dv6 or two e3dv6 in bowden on the x carridge
// created: 8/17/2018
// last modified: 8/19/2018
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/17/18	- dual filament setup using two Titan extruders on the x carridge, varibles and a couple of modules from
//			  corxy-x-carridge.scad
//			  Uses two stl files from https://www.thingiverse.com/thing:2065461
//			  Fan mount (print two): SE_Titan_i3mk2_-_nozzle_fan_mount_radial_v1.2x.stl or
//									 SE_Titan_i3mk2_-_nozzle_fan_mount_axial.stl
//			  Titan mount (print two): SE_Titan_i3mk2_-_extruder_mount_v1.1.stl
// 8/19/18	- Changed to Development Snapshot of OpenSCAD 2018.06.01 to be able to use $preview
//			- Added a bowden setup for single or dual using the bowden setup from my CXY-MGNv2
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-msv1_h.scad> // http://github.com/prusajr/PrusaMendel, which also uses functions.scad & metric.scad
//$fn=100; // Compiling does take a while at 100
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// variables
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
AdjustE3DV6_UD = 0; // move one of the e3dv6 mounts up/down, moves by shifting the e3dv6 mount itself
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

titan(2,0);  // first arg is quanity of 1 or 2, second arg is 0 no bowden, 1 for bowden (defaul1 is 1 and no bowden)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titan(Qty = 1,Bowden=0) {
	if(Bowden) titanbowden(Qty);
	else {
		if($preview) %titanbracket(Qty); // show the titan mounts
		mountingblock(Qty);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module mountingblock(Qty=1,X=0,Y=0,Z=0,TMountholes=1) {
	if(Qty == 1) {
		translate([X,Y,Z]) {
			difference() {
				translate([-5,-30,33])	bracketmount(TMountholes);
				translate([25,-15,33]) i3mount();	// carriage mount is behind left titan
			}
		}
	}
	if(Qty == 2) {
		translate([X,Y,Z]) {
			difference() {
				translate([-5,-30,33])	bracketmount(TMountholes);
				translate([25,-6,33]) i3mount();	// carriage mount is behind left titan
			}
			translate([-5,28,33]) bracketmount();		
			difference() {
				translate([-5,19,33]) color("purple") cubeX([60,13,8],2); // connect the two bracketmounts together
				translate([5.5,33.5,36]) color("white") nut(m3_nut_diameter,14);
				translate([45,16.5,36]) color("white") nut(m3_nut_diameter,14);
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bracketmount(TMountholes) {
	difference() {
		color("cyan") cubeX([60,53,8],2);
		if(TMountholes) {
			translate([50,46.5,-38]) color("blue") cylinder(h=50,d=screw3);
			translate([10.5,5.5,-38]) color("lightblue") cylinder(h=50,d=screw3);
			translate([50,46.5,6]) color("white") nut(m3_nut_diameter,14);
			translate([10.5,5.5,6]) color("white") nut(m3_nut_diameter,14);
		}
	}
}


	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module i3mount() { // four mounting holes for using a Prusa i3 style extruder
	// lower
	translate([mount_bolt_seperation/2,0,-5]) color("pink") cylinder(h = 18, r = screw4/2);
	translate([-mount_bolt_seperation/2,0,-5]) color("black") cylinder(h = 18, r = screw4/2);
	// upper
	translate([mount_bolt_seperation/2,mount_bolt_seperation,-5]) color("red") cylinder(h = 18, r = screw4/2);
	translate([-mount_bolt_seperation/2,mount_bolt_seperation,-5]) color("blue") cylinder(h = 18, r = screw4/2);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titanbracket(Qty) {
	import("SE_Titan_i3mk2_-_extruder_mount_v1.1.stl");
	if(Qty ==2) translate([0,58,0]) import("SE_Titan_i3mk2_-_extruder_mount_v1.1.stl");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titanbowden(Dual=2) { // defaults to two bowden hotends
	if($preview) %translate([-30,-80,-5]) cubeX([200,200,5],2); // show a 200x200 bed in preview
	if(Dual == 2) { // two bowden hotends
		translate([100,-40,0]) bowden_titan();  // Titan extruder frame mount
		translate([100,30,0]) bowden_titan();  // Titan extruder frame mount
		e3dv6_bowden(AdjustE3DV6_UD);
	}	
	if(Dual == 1) { // one bowen hotend
		translate([100,-40,0]) bowden_titan();  // Titan extruder frame mount
		e3dv6_bowden_single(AdjustE3DV6_UD);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module e3dv6_bowden(Adjust=0) {
	difference() {
		translate([0,puck_w/2-e3dv6_total/2,0]) rotate([90,0,0]) bowden_mount(0);
		translate([8,puck_w/2-e3dv6_total/2-10,5]) cubeX([10,5,10]);	// access hole for M4 nuts
		translate([30,puck_w/2-e3dv6_total/2-10,5]) cubeX([10,5,10]);	// access hole for M4 nuts
		translate([40,puck_w/2-e3dv6_total/2-17,-5]) color("lightgrey") cube([20,20,20]);
	}
	difference() {
		translate([32,puck_w/2-e3dv6_total/2,0]) rotate([-90,180,180]) bowden_mount(Adjust);
		translate([40,puck_w/2-e3dv6_total/2-10,5]) cubeX([10,5,10]);
		translate([61,puck_w/2-e3dv6_total/2-10,5]) cubeX([10,5,10]);
		translate([20,puck_w/2-e3dv6_total/2-17,-5]) color("lightgrey") cube([20,20,20]);
	}
	rotate([180,90,90]) mountingblock(2,-55,15,-45,0);
	bowden_ir();
	bowden_fan();
	translate([30,20,0]) rotate([0,0,90]) bowden_clamp(0);
	translate([70,20,0]) rotate([0,0,90]) bowden_clamp(Adjust);
}

module e3dv6_bowden_single() {
	difference() {
		translate([0,puck_w/2-e3dv6_total/2,0]) rotate([90,0,0]) bowden_mount(0);
		translate([8,puck_w/2-e3dv6_total/2-10,5]) cubeX([10,5,10]);	// access hole for M4 nuts
		translate([30,puck_w/2-e3dv6_total/2-10,5]) cubeX([10,5,10]);	// access hole for M4 nuts
	}
	rotate([180,90,90]) mountingblock(1,-55,25,-45,0);
	bowden_ir();
	translate([-31,0,0]) bowden_fan();
	translate([30,20,0]) rotate([0,0,90]) bowden_clamp(0);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_mount(Adjust=0) {
	difference() {
		color("grey") hull() {
			cubeX([puck_l,e3dv6_total,3],2);
			translate([e3dv6_od/2,0,27]) cubeX([e3dv6_od*2,e3dv6_total,3],2);
		}
		translate([e3dv6_od+e3dv6_od/2,e3dv6_total+Adjust,31]) rotate([90,0,0]) e3dv6();
		bowden_screws();
		bowden_bottom_ir_mount_hole();
		bowden_bottom_fan_mount_hole();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_screws() {
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,0]) color("red") cylinder(h=50,d=screw4);
	translate([35,puck_w/2-e3dv6_total/2-0.5,0]) color("blue") cylinder(h=50,d=screw4);
	bowden_nuts();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_nuts(Len=20) {
	translate([35,puck_w/2-e3dv6_total/2-0.5,0]) color("red") cylinder(h=Len,d=nut4,$fn=6);
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,0]) color("blue") cylinder(h=Len,d=nut4,$fn=6);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_screws_CS() {
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,-5]) color("red") cylinder(h=50,d=screw4);
	translate([35,puck_w/2-e3dv6_total/2-0.5,-5]) color("blue") cylinder(h=50,d=screw4);
	translate([35,puck_w/2-e3dv6_total/2-0.5,-1.5]) color("red") cylinder(h=24,d=screw4hd);
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,-1.5]) color("blue") cylinder(h=24,d=screw4hd);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_nut_support() {
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,22.51]) color("red") cylinder(h=layer,d=nut4);
	translate([35,puck_w/2-e3dv6_total/2-0.5,22.51]) color("blue") cylinder(h=layer,d=nut4);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_clamp(Adjust=0) {
	difference() {
		translate([e3dv6_od/2,0,0]) color("blue") cubeX([e3dv6_od*2,e3dv6_total,15],2);	//main body
		translate([e3dv6_od+e3dv6_od/2,e3dv6_total+Adjust,16]) rotate([90,0,0]) e3dv6(); // e3dv6 mount in clamp
		translate([0,0,-20]) bowden_screws_CS(); // countersink the screw holes
	}
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,2.51]) color("red") cylinder(h=layer,d=screw4hd); // support for the CS
	translate([35,puck_w/2-e3dv6_total/2-0.5,2.51]) color("blue") cylinder(h=layer,d=screw4hd);  // support for the CS
}

module bowden_titan(Screw=screw4) { // platform for e3d titan
	difference() {
		cubeX([40,54,5],2); // extruder side
		translate([20,28,-10]) cylinder(h=20,d=20,$fn=100); // remove some plastic under the motor
		translate([10,10,-1]) cylinder(h=20,d=Screw,$fn=100); // mounting screw hole
		translate([30,10,-1]) cylinder(h=20,d=Screw,$fn=100); // mounting screw hole
		translate([10,45,-1]) cylinder(h=20,d=Screw,$fn=100); // mounting screw hole
		translate([30,45,-1]) cylinder(h=20,d=Screw,$fn=100); // mounting screw hole
	}
	translate([0,1,1]) rotate([90,0,90]) titanmotor(5+shifttitanup);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titanmotor(ShiftUp=0) {
	difference() {	// motor mounting holes
		translate([-1,0,0]) cubeX([54,50+ShiftUp,5],2);
		translate([25,25+ShiftUp,-1]) rotate([0,0,45])  NEMA17_x_holes(8, 2);
	}
	difference() { // front support
		translate([-1,0,0]) color("red") cubeX([4,50,50],2);
		translate([-3,50,4]) rotate([56,0,0]) cube([7,50,70]);
		translate([-4,-4,36]) cube([wall,wall,wall]);
		titanmotor_slots();
	}
	difference() { // rear support
		translate([49,0,0]) color("blue") cubeX([4,50,50],2);
		translate([47,50,4]) rotate([56,0,0]) cube([7,50,70]);
		translate([47,-4,36]) cube([wall,wall,wall]);
		titanmotor_slots();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titanmotor_slots() {
	color("cyan") hull() {
		translate([-10,33,6]) rotate([0,90,0]) cylinder(h=70,d=5,$fn=100);
		translate([-10,13,12]) rotate([0,90,0]) cylinder(h=70,d=16,$fn=100);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module e3dv6() {
	color("plum") cylinder(h=e3dv6_total,d=e3dv6_id,$fn=100);
	translate([0,0,e3dv6_total-ed3v6_tl]) color("pink") cylinder(h=ed3v6_tl+10,d=e3dv6_od,$fn=100);
	translate([0,0,-1]) color("powderblue")cylinder(h=e3dv6_bl+1,d=e3dv6_od,$fn=100);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_ir() {
	difference() {
		translate([3,-40,3]) color("pink") cubeX([5,hole2x+9+shift_ir_bowden,7]);
		translate([1,hole2x+shift_ir_bowden-60,6.5]) rotate([0,90,0]) color("red") cylinder(h=10,d=screw3t);
		bowden_bottom_ir_mount_hole();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_bottom_ir_mount_hole() {
	translate([2,(hole2x+shift_ir_bowden-60)+(hole2x-hole1x),6.5]) color("blue") rotate([0,90,0]) cylinder(h=15,d=screw3t);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_fan() {
		difference() {
			translate([73,-47,2]) color("cyan") cubeX([5,fan_spacing+20,7]);
			translate([69,-(fan_spacing+9.5),5]) rotate([0,90,0]) color("red") cylinder(h=10,d=screw3t);
			bowden_bottom_fan_mount_hole(9.5);
		}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_bottom_fan_mount_hole(X=0) {
	translate([64,-X,5]) rotate([0,90,0]) color("blue") cylinder(h=15,d=screw3t);
}

///////////////////end of dualtitan.scad////////////////////////////////////////////////////////////////////////////
