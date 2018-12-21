///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Dual-Titan-E3DV6.scad - to mount two titans with a e3dv6 or two e3dv6 in bowden on the x carridge
// created: 8/17/2018
// last modified: 12/20/2018
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/17/18	- dual filament setup using two Titan extruders on the x carridge and a couple of modules from
//			  corxy-x-carridge.scad
// 8/19/18	- Changed to Development Snapshot of OpenSCAD 2018.06.01 to be able to use $preview
//			- Added a bowden setup for single or dual using the bowden setup from my CXY-MGNv2
// 8/23/18	- Redid titan_motor() supports; added sensor mounts
// 9/15/18	- Added missing m4 screwholes and nut holders on dualmountblock()
//			  Added just_extruders() and sensor_mount()
// 12/20/18	- Removed the version thst used Titan mounted on the x carriage
//			  Dual hotends only
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Not printed as of 8/23/18
// Bowden only
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <CoreXY-MSv1-h.scad> // http://github.com/prusajr/PrusaMendel, which also uses functions.scad & metric.scad
$fn=50; // Compiling does take a while at 100, even with a 1950X, 32GB & 1080ti
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// variables
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
AdjustE3DV6_UD = 0; // move the e3dv groove mounts in opposite directions for the bowden setup
					// if one of the hotends is 0.01 too high, then set AdjustE3DV6_UD by half: 0.005
// these to be adjusted when it's finally printed:
IR_Adapter_Length = 10; // move position of dc42's ir adapter up/down
Shift_BL_Touch = 10; // move bl_touch up/down
Shift_Proximity = 10; // move proximity up/down
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

dualtitan(3,1);	// dual hotends that are closer together
				// 1st arg is for sensor type (0-ir,1=blt,2=blt recessed,3=proximity,>=4-none
				// 2nd arg: 0=no titan extruder mounts,1=titan extruder mounts
//just_extruders(); // just the two titan extruder mounts
//sensor_mount(0);	// sensor mount only; arg is for sensor type (0-ir,1=blt,2=blt recessed,3=proximity,>=4-nothing

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module dualtitan(Sensor=0,Extruders=0) {
	if($preview) %translate([-100,-100,-5]) cube([200,200,5]);
	translate([33,30,5]) rotate([0,-90,0]) dualmountingblock(Sensor,Extruders);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module dualmountingblock(Sensor,Extruders) {
	difference() {
		translate([-5,-30,33]) newbracketmount(0); // left side
		translate([30,0,33]) NewCarriageMount();
				// mounting screw holes and nuts for clamp
		translate([7.5,-2.5,29]) rotate([0,0,90]) bowden_screws();
		translate([7.5,-25,29]) rotate([0,0,90]) bowden_screws();
		translate([0.5,-13,31]) color("blue") nut(m4_nut_diameter,5);
		translate([0.5,10,31]) color("plum") nut(m4_nut_diameter,5);
		translate([0.5,32,31]) color("red") nut(m4_nut_diameter,5);
	}
	Newtitanbowden(2,Sensor,Extruders);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module newbracketmount(TMountholes=0) {
	difference() {
		color("cyan") cubeX([60,80,8],2);
		if(TMountholes) {
			translate([50,46.5,-38]) color("blue") cylinder(h=50,d=screw3);
			translate([10.5,5.5,-38]) color("lightblue") cylinder(h=50,d=screw3);
			translate([50,46.5,6]) color("white") nut(m3_nut_diameter,14);
			translate([10.5,5.5,6]) color("white") nut(m3_nut_diameter,14);
			translate([50,105,-38]) color("blue") cylinder(h=50,d=screw3);
			translate([10.5,63,-38]) color("lightblue") cylinder(h=50,d=screw3);
			translate([50,105,6]) color("white") nut(m3_nut_diameter,14);
			translate([10.5,63,6]) color("white") nut(m3_nut_diameter,14);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bracketmount(TMountholes) {
	difference() {
		color("cyan") cubeX([60,53,8],2);
		if(TMountholes) {
			translate([50,46.5,-38]) color("blue") cylinder(h=50,d=screw3);
			translate([10.5,5.5,-38]) color("lightblue") cylinder(h=50,d=screw3);
			//translate([50,46.5,6]) color("white") nut(m3_nut_diameter,14);
			//translate([10.5,5.5,6]) color("white") nut(m3_nut_diameter,14);
		}
	}
}


	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module newbracketmount(TMountholes=1) {
	difference() {
		color("cyan") cubeX([60,80,8],2);
		if(TMountholes) {
			translate([50,46.5,-38]) color("blue") cylinder(h=50,d=screw3);
			translate([10.5,5.5,-38]) color("lightblue") cylinder(h=50,d=screw3);
			translate([50,46.5,6]) color("white") nut(m3_nut_diameter,14);
			translate([10.5,5.5,6]) color("white") nut(m3_nut_diameter,14);
			translate([50,105,-38]) color("blue") cylinder(h=50,d=screw3);
			translate([10.5,63,-38]) color("lightblue") cylinder(h=50,d=screw3);
			translate([50,105,6]) color("white") nut(m3_nut_diameter,14);
			translate([10.5,63,6]) color("white") nut(m3_nut_diameter,14);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module NewCarriageMount() { // four mounting holes
	// lower
	translate([mount_bolt_seperation/2,0,-5]) color("pink") cylinder(h = 18, r = screw4/2);
	translate([mount_bolt_seperation/2,0,6]) color("white") nut(m3_nut_diameter,14);
	translate([-mount_bolt_seperation/2,0,-5]) color("black") cylinder(h = 18, r = screw4/2);
	translate([-mount_bolt_seperation/2,0,6]) color("white") nut(m3_nut_diameter,14);
	// upper
	translate([mount_bolt_seperation/2,mount_bolt_seperation,-5]) color("red") cylinder(h = 18, r = screw4/2);
	translate([mount_bolt_seperation/2,mount_bolt_seperation,6]) color("white") nut(m3_nut_diameter,14);
	translate([-mount_bolt_seperation/2,mount_bolt_seperation,-5]) color("blue") cylinder(h = 18, r = screw4/2);
	translate([-mount_bolt_seperation/2,mount_bolt_seperation,6]) color("white") nut(m3_nut_diameter,14);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CarriageMount() { // four mounting holes
	// lower
	translate([mount_bolt_seperation/2,0,-5]) color("pink") cylinder(h = 18, r = screw4/2);
	translate([mount_bolt_seperation/2,0,6]) color("white") nut(m3_nut_diameter,14);
	translate([-mount_bolt_seperation/2,0,-5]) color("black") cylinder(h = 18, r = screw4/2);
	translate([-mount_bolt_seperation/2,0,6]) color("white") nut(m3_nut_diameter,14);
	// upper
	translate([mount_bolt_seperation/2,mount_bolt_seperation,-5]) color("red") cylinder(h = 18, r = screw4/2);
	translate([mount_bolt_seperation/2,mount_bolt_seperation,6]) color("white") nut(m3_nut_diameter,14);
	translate([-mount_bolt_seperation/2,mount_bolt_seperation,-5]) color("blue") cylinder(h = 18, r = screw4/2);
	translate([-mount_bolt_seperation/2,mount_bolt_seperation,6]) color("white") nut(m3_nut_diameter,14);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Newtitanbowden(Dual=2,Sensor=0,Extruders) { // defaults to two bowden hotends
	if(Dual == 2) { // two bowden hotends
//		if($preview) %translate([-30,-80,-5]) cubeX([200,200,5],2); // show a 200x200 bed in preview
		if(Extruders) {
			translate([-5,-90,-20]) bowden_titan();  // Titan extruder frame mount
			translate([-5,-90,40]) bowden_titan();  // Titan extruder frame mount
		}
		translate([0,-20,0]) Newe3dv6_bowden(AdjustE3DV6_UD/2,Sensor);  // move one up, one down, so that they both make the total offset
	}	
	if(Dual == 1) { // one bowen hotend
		if($preview) %translate([-80,-80,-5]) cubeX([200,200,5],2); // show a 200x200 bed in preview
		if(Extruders) {
			translate([50,-40,0]) bowden_titan();  // Titan extruder frame mount
		}
		Newe3dv6_bowden_single(Sensor);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module just_extruders() {
	translate([-5,-90,-20]) bowden_titan();  // Titan extruder frame mount
	translate([-5,-90,40]) bowden_titan();  // Titan extruder frame mount
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Newe3dv6_bowden(Adjust=0,Sensor=0) {
	difference() {
		translate([7.6,puck_w/2-e3dv6_total/2+10,38]) rotate([0,0,90]) bowden_mount(-Adjust);
		translate([-5.2,puck_w/2-e3dv6_total/2+12,69]) rotate([0,90,0]) e3dv6();
	}
	difference() {
		translate([7.6,puck_w/2-e3dv6_total/2-12,38]) rotate([0,0,90]) bowden_mount(Adjust);
		translate([-5.2,puck_w/2-e3dv6_total/2+34,69]) rotate([0,90,0]) e3dv6();
	}
	translate([-5,-15,84]) rotate([90,0,90]) bowden_fan2();
	translate([-5,-77.4,84]) rotate([90,0,90]) bowden_fan2();
	// sensor (0-ir,1=blt,2=blt recessed,3=proxmtity
	if(Sensor==0) translate([-5,20,-20]) iradapter2(IR_Adapter_Length);
	if(Sensor==1) translate([-5,10,20]) rotate([0,90,0]) blt_mount(1,Shift_BL_Touch);
	if(Sensor==2) translate([-5,10,20]) rotate([0,90,0]) blt_mount(0,Shift_BL_Touch);
	if(Sensor==3) translate([-5,10,20]) rotate([0,90,0]) prox_mount(Shift_Proximity);
		
	translate([-85,0,85]) rotate([0,90,0]) difference() {
		union() {
			difference() {
				translate([6,-4.5,80]) rotate([0,0,90]) bowden_clamp(-Adjust);
				translate([-6.6,19.6,95]) rotate([0,90,0]) e3dv6(); // clear clamp for e3dv6
				translate([-6.6,42,95]) rotate([0,90,0]) e3dv6(); // clear clamp for e3dv6
			}
			difference() {
				translate([6,17.5,80]) rotate([0,0,90]) bowden_clamp(Adjust);
				translate([-6.6,19.6,95]) rotate([0,90,0]) e3dv6(); // clear clamp for e3dv6
				translate([-6.6,42,95]) rotate([0,90,0]) e3dv6(); // clear clamp for e3dv6
			}
		}
		translate([-65,46.8,75]) { // fan spacing mounting holes on the bowden_clamp()
			translate([64,-(fan_spacing),3.5]) color("red") cylinder(h=25,d=screw3t);
			translate([64,0,3.5]) color("cyan") cylinder(h=25,d=screw3t);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module sensor_mount(Sensor) {
	if(Sensor==0) iradapter2(IR_Adapter_Length);
	if(Sensor==1) rotate([0,90,0]) blt_mount(1,Shift_BL_Touch);
	if(Sensor==2) rotate([0,90,0]) blt_mount(0,Shift_BL_Touch);
	if(Sensor==3) rotate([0,90,0]) prox_mount(Shift_Proximity);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_mount(Adjust=0) {
	difference() {
		color("grey") hull() {
			cubeX([puck_l,e3dv6_total,3],2);
			translate([e3dv6_od/2,0,27]) cubeX([e3dv6_od*2,e3dv6_total,3],2);
		}
		translate([e3dv6_od+e3dv6_od/2,e3dv6_total+Adjust,31]) rotate([90,0,0]) e3dv6();
		translate([0,0,-10]) bowden_screws();
		bowden_bottom_fan_mount_hole();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_screws() {
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,0]) color("red") cylinder(h=50,d=screw4);
	translate([35,puck_w/2-e3dv6_total/2-0.5,0]) color("blue") cylinder(h=50,d=screw4);
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
		color("cyan") cubeX([40,54,5],2); // extruder side
		translate([20,28,-10]) color("blue") cylinder(h=20,d=20,$fn=100); // remove some plastic under the motor
		translate([10,10,-1]) color("red") cylinder(h=20,d=Screw,$fn=100); // mounting screw hole
		translate([30,10,-1]) color("white") cylinder(h=20,d=Screw,$fn=100); // mounting screw hole
		translate([10,45,-1]) color("gray") cylinder(h=20,d=Screw,$fn=100); // mounting screw hole
		translate([30,45,-1]) color("black") cylinder(h=20,d=Screw,$fn=100); // mounting screw hole
	}
	translate([0,1,1]) rotate([90,0,90]) titanmotor(5+shifttitanup);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titanmotor(ShiftUp=0) {
	difference() {	// motor mounting holes
		translate([-1,0,0]) color("plum") cubeX([54,50+ShiftUp,5],2);
		translate([25,25+ShiftUp,-1]) rotate([0,0,45]) color("gray") NEMA17_x_holes(8, 2);
	}
	difference() { // front support
		translate([-1,19,-46]) rotate([56,0,0]) color("red") cubeX([4,60,63],2);
		translate([-2,-49,-37]) color("blue") cube([7,50,75]);
		translate([-2,0,-48])  color("cyan")cube([7,75,50]);
		titanmotor_slots();
	}
	difference() { // rear support
		translate([49.5,0,0]) {
			difference() {
				translate([-0.5,19,-46]) rotate([56,0,0]) color("red") cubeX([4,60,63],2);
				translate([-2,-49,-37])  color("blue")cube([7,50,75]);
				translate([-2,0,-48])  color("cyan")cube([7,75,50]);
			}
		}
		titanmotor_slots();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titanmotor_slots() {
	color("cyan") hull() {
		translate([-10,36,8]) rotate([0,90,0]) cylinder(h=70,d=5,$fn=100);
		translate([-10,14,15]) rotate([0,90,0]) cylinder(h=70,d=19,$fn=100);
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
		translate([hole2x+shift_ir_bowden,14,6.5]) rotate([90,0,0]) color("red") cylinder(h=15,d=screw3t);
		bowden_bottom_ir_mount_hole();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_bottom_ir_mount_hole() {
	translate([-(hole1x+shift_ir_bowden)+(hole2x-hole1x),14,6.5]) color("blue") rotate([90,0,0]) cylinder(h=15,d=screw3t);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_fan2() {
	difference() {
		translate([73,-46,0]) color("cyan") cubeX([5,fan_spacing+20,7]);
		translate([69,-(fan_spacing),3.5]) rotate([0,90,0]) color("red") cylinder(h=10,d=screw3t);
		translate([64,0,3.5]) rotate([0,90,0]) color("blue") cylinder(h=15,d=screw3t);
//		translate([70,-hole2x,3.5]) rotate([0,90,0]) color("gray") cylinder(h=15,d=screw3t);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_fan() {
		difference() {
			translate([73,-46,0]) color("cyan") cubeX([5,fan_spacing+20,7]);
			translate([69,-(fan_spacing+9.5),5]) rotate([0,90,0]) color("red") cylinder(h=10,d=screw3t);
			bowden_bottom_fan_mount_hole(9.5);
		}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_bottom_fan_mount_hole(X=0) {
	translate([64,-X,5]) rotate([0,90,0]) color("blue") cylinder(h=15,d=screw3t);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module iradapter(Taller=0) {  // ir sensor bracket stuff is from irsensorbracket.scad
	difference() {
		color("plum") cubeX([irmount_width,irmount_height+Taller,irthickness],2); // mount base
		block_mount(Taller,screw3t);
		reduce(Taller);
		recess(Taller);
		block_mount(-18,screw3); // holes for sensor
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module iradapter2(Taller=0) { //  fan_spacing mounting width version
	difference() {
		color("plum") cubeX([irthickness,fan_spacing+5,irmount_height+Taller],2); // mount base
		translate([0,5,0]) block_mount2(Taller,screw3t);
		hull() {
			translate([-2.5,irmount_height-irreduce+Taller/2-3,16]) rotate([0,90,0]) color("teal") cylinder(h=10,r=irmount_width/3);
			translate([-2.5,irmount_height-irreduce+Taller/2+6,16]) rotate([0,90,0]) color("teal") cylinder(h=10,r=irmount_width/3);
		}
		translate([hole1y+irrecess+(irmount_height/4)+Taller-26,irnotch_d+7,hole1x+23]) color("cyan") cube([5,15.5,10]);
		block_mount3(-18,screw3); // holes for sensor
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module recess(Taller=0) { // make space for the thru hole pin header
	translate([hole1x+3,hole1y+irrecess+(irmount_height/4)+Taller,irnotch_d]) color("cyan") cube([15.5,10,5]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module reduce(Taller=0) { // reduce plastic usage and gives somewhere for air to go if using an all-metal hotend w/fan
	translate([13.5,irmount_height-irreduce+Taller/2,-1]) color("teal") cylinder(h=10,r = irmount_width/3);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module block_mount(Taller=0,Screw=screw3t) // mounting screw holes for the ir sensor
{
	//mounting screw holes
	translate([hole1x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("black") cylinder(h=20,r=Screw/2,$fn=50);
	translate([hole2x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("white") cylinder(h=20,r=Screw/2,$fn=50);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module block_mount2(Taller=0,Screw=screw3t) // mounting screw holes for the ir sensor
{
	//mounting screw holes
	translate([-5,hole1x+iroffset-1.5,irmounty+Taller]) rotate([0,90,0]) color("black") cylinder(h=20,r=Screw/2,$fn=50);
	translate([-5,hole2x+iroffset-1.5,irmounty+Taller]) rotate([0,90,0]) color("white") cylinder(h=20,r=Screw/2,$fn=50);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module block_mount3(Taller=0,Screw=screw3t) // mounting screw holes for the ir sensor
{
	//mounting screw holes
	translate([-5,hole1x+1,irmounty+Taller]) rotate([0,90,0]) color("black") cylinder(h=20,r=Screw/2,$fn=50);
	translate([-5,fan_spacing+1,irmounty+Taller]) rotate([0,90,0]) color("white") cylinder(h=20,r=Screw/2,$fn=50);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module prox_mount(Shift=0) {
	difference() {
		color("red") cubeX([30,30,5],2);
		translate([15,12,-2]) color("olive") cylinder(h=wall*2,r=psensord/2,$fn=50); // proximity sensor hole
	}
	difference() {
		translate([0,26,0]) color("blue") cubeX([40,5,13+Shift],2);
		translate([-16,60,53+Shift]) rotate([90,0,90]) fan(screw3);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module blt_mount(Type=0,Shift=0) {
	difference() {
		color("salmon") cubeX([40,30,5],2);
		if(Type==0) translate([20,0,bltdepth+6]) blt(Type); // recessed
		if(Type==1) translate([20,0,bltdepth+3]) blt(Type); 
	}
	difference() {
		translate([0,26,0]) color("cyan") cubeX([40,5,15+Shift],2);
		translate([-16,60,55+Shift]) rotate([90,0,90]) fan();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module fan(Screw=screw3t,Left=1) {	// fan mounting holes
	if(Left) {
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = 3*(depthE+screw_depth),d = Screw,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = 3*(depthE+screw_depth),d = Screw,$fn=50);
	} else { // one side fan mounting holes
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back - fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("pink") cylinder(h = depthE+screw_depth,d = Screw,$fn=50);
		translate([-extruder/2+35,-heightE/2 - 1.8*wall,heightE - extruder_back + fan_spacing/2 + fan_offset])
			rotate([0,90,0]) color("skyblue") cylinder(h = depthE+screw_depth,d = Screw,$fn=50);

	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module blt(Ver=0) { // BLTouch mounts
	if(Ver == 0) {
		translate([-bltl/2+3,bltw/2+3,bltdepth]) minkowski() { // depression for BLTouch
			// it needs to be deep enough for the retracted pin not to touch bed
			color("red") cube([bltl-6,bltw-6,wall]);
			cylinder(h=1,r=3,$fn=100);
		}
		translate([-bltl/2+8,bltw/2,-5]) color("blue") cube([bltd,bltd+1,wall+3]); // hole for BLTouch
		translate([bltouch/2,16,-10]) color("cyan") cylinder(h=25,r=screw2/2,$fn=100);
		translate([-bltouch/2,16,-10]) color("purple") cylinder(h=25,r=screw2/2,$fn=100);
	}
	if(Ver == 1) {
		translate([-bltl/2+8,bltw/2,-5]) color("blue") cube([bltd,bltd+1,wall+3]); // hole for BLTouch
		translate([bltouch/2,16,-10]) color("cyan") cylinder(h=25,r=screw2/2,$fn=100);
		translate([-bltouch/2,16,-10]) color("purple") cylinder(h=25,r=screw2/2,$fn=100);
	}
}
///////////////////end of dualtitan.scad////////////////////////////////////////////////////////////////////////////
