///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Dual-Titan-Bowden-E3DV6.scad - to mount two titans with a e3dv6 or two e3dv6 in bowden on the x carridge
// created: 8/17/2018
// last modified: 10/31/2020
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
// 10/31/20	- Use 4mm brass inserts, cahanged mounting to xcarraige
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <CoreXY-MSv1-h.scad> // http://github.com/prusajr/PrusaMendel, which also uses functions.scad & metric.scad
include <inc/brassinserts.scad>
$fn=50; // Compiling does take a while at 100
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// variables
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Use3mmInsert=1;
Use4mmInsert=1;
LargeInsert=1;
AdjustE3DV6_UD = 0; // shouldn't be needed, move the e3dv groove mounts in opposite directions for the bowden setup
					// if one of the hotends is 0.01 too high, then set AdjustE3DV6_UD by half: 0.005
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

dualtitanbowden(1);	// dual hotends that are closer together
				// 1st arg is for sensor type (0-ir,1=blt,2=blt recessed,3=proximity,>=4-none
				// 2nd arg: 0=no titan extruder mounts,1=titan extruder mounts
//just_extruders(); // just the two titan extruder mounts

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module dualtitanbowden(Extruders=0) {
	if($preview) %translate([-100,-100,-5]) cube([200,200,5]);
	translate([33,30,5]) rotate([0,-90,0]) dualmountingblock(Extruders);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module dualmountingblock(Extruders) {
	difference() {
		translate([-5,-30,33]) BracketMount(); // left side
		if(!Use4mmInsert) {
			translate([0.5,-13,31]) color("blue") nut(m4_nut_diameter,5);
			translate([0.5,10,31]) color("plum") nut(m4_nut_diameter,5);
			translate([0.5,32,31]) color("red") nut(m4_nut_diameter,5);
			translate([7.5,-2.5,29]) rotate([0,0,90]) bowden_screws(screw4);
			translate([7.5,-25,29]) rotate([0,0,90]) bowden_screws(screw4);
		} else {
			translate([7.5,-2.5,29]) rotate([0,0,90]) bowden_screws(Yes4mmInsert(Use4mmInsert));
			translate([7.5,-25,29]) rotate([0,0,90]) bowden_screws(Yes4mmInsert(Use4mmInsert));
		}
	}
	TitanBowden(2,5,Extruders);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BracketMount(Screw=screw3) {
	difference() {
		color("cyan") cubeX([13,80,8],2);
		translate([-25,40,4]) rotate([0,0,90]) ExtruderMountHolesFn(Screw,1);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module TitanBowden(Dual=2,Sensor=0,Extruders) { // defaults to two bowden hotends
	if(Dual == 2) { // two bowden hotends
//		if($preview) %translate([-30,-80,-5]) cubeX([200,200,5],2); // show a 200x200 bed in preview
		if(Extruders) {
			translate([-5,-90,-20]) bowden_titan();  // Titan extruder frame mount
			translate([-5,-90,40]) bowden_titan();  // Titan extruder frame mount
		}
		translate([0,-20,0]) E3dv6_bowden(AdjustE3DV6_UD/2);  // move one up, one down, so that they both make the total offset
	}	
	if(Dual == 1) { // one bowen hotend
		if($preview) %translate([-80,-80,-5]) cubeX([200,200,5],2); // show a 200x200 bed in preview
		if(Extruders) {
			translate([50,-40,0]) bowden_titan();  // Titan extruder frame mount
		}
		E3dv6_bowden_single();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module just_extruders() {
	translate([-5,-90,-20]) bowden_titan();  // Titan extruder frame mount
	translate([-5,-90,40]) bowden_titan();  // Titan extruder frame mount
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module E3dv6_bowden(Adjust=0,Sensor=0) {
	difference() {
		translate([7.6,puck_w/2-e3dv6_total/2+10,38]) rotate([0,0,90]) bowden_mount(-Adjust);
		translate([-5.2,puck_w/2-e3dv6_total/2+12,59]) rotate([0,90,0]) e3dv6();
	}
	difference() {
		translate([7.6,puck_w/2-e3dv6_total/2-12,38]) rotate([0,0,90]) bowden_mount(Adjust);
		translate([-5.2,puck_w/2-e3dv6_total/2+34,59]) rotate([0,90,0]) e3dv6();
	}
	translate([-5,-15,84]) rotate([90,0,90]) bowden_fan2();
	translate([-5,-77.4,84]) rotate([90,0,90]) bowden_fan2();
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


//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_mount(Adjust=0) {
	difference() {
		color("grey") hull() {
			cubeX([puck_l,e3dv6_total,3],2);
			translate([e3dv6_od/2,0,17]) cubeX([e3dv6_od*2,e3dv6_total,3],2);
		}
		translate([e3dv6_od+e3dv6_od/2,e3dv6_total+Adjust,21]) rotate([90,0,0]) e3dv6();
		translate([0,0,-10]) bowden_screws();
		bowden_bottom_fan_mount_hole();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_screws(Screw=Yes4mmInsert(Use4mmInsert)) {
	translate([12.5,puck_w/2-e3dv6_total/2-0.5,0]) color("red") cylinder(h=50,d=Screw);
	translate([35,puck_w/2-e3dv6_total/2-0.5,0]) color("blue") cylinder(h=50,d=Screw);
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

module bowden_ir(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) {
	translate([hole2x+shift_ir_bowden,14,6.5]) rotate([90,0,0]) color("red") cylinder(h=15,d=Screw);
	bowden_bottom_ir_mount_hole();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_bottom_ir_mount_hole(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) {
	translate([-(hole1x+shift_ir_bowden)+(hole2x-hole1x),14,6.5]) color("blue") rotate([90,0,0]) cylinder(h=15,d=Screw);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_fan2(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) {  // ir mount, no fan
	difference() {
		translate([73,-46,0]) color("cyan") cubeX([5,fan_spacing,7]);
		translate([80,-45,-3]) rotate([0,0,90]) bowden_ir(Yes3mmInsert(Use3mmInsert,LargeInsert));
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_fan(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) {
	difference() {
		translate([73,-46,0]) color("cyan") cubeX([5,fan_spacing+20,7]);
		translate([69,-(fan_spacing+9.5),5]) rotate([0,90,0]) color("red") cylinder(h=10,d=Screw);
		bowden_bottom_fan_mount_hole(9.5);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bowden_bottom_fan_mount_hole(X=0,Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) {
	translate([64,-X,5]) rotate([0,90,0]) color("blue") cylinder(h=15,d=Screw);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module block_mount(Taller=0,Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) // mounting screw holes for the ir sensor
{
	//mounting screw holes
	translate([hole1x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("black") cylinder(h=20,r=Screw/2);
	translate([hole2x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("white") cylinder(h=20,r=Screw/2);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module block_mount2(Taller=0,Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) // mounting screw holes for the ir sensor
{
	//mounting screw holes
	translate([-5,hole1x+iroffset-1.5,irmounty+Taller]) rotate([0,90,0]) color("black") cylinder(h=20,r=Screw/2);
	translate([-5,hole2x+iroffset-1.5,irmounty+Taller]) rotate([0,90,0]) color("white") cylinder(h=20,r=Screw/2);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module block_mount3(Taller=0,Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) // mounting screw holes for the ir sensor
{
	//mounting screw holes
	translate([-5,hole1x+1,irmounty+Taller]) rotate([0,90,0]) color("black") cylinder(h=20,r=Screw/2);
	translate([-5,fan_spacing+1,irmounty+Taller]) rotate([0,90,0]) color("white") cylinder(h=20,r=Screw/2);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module fan(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert),Left=1) {	// fan mounting holes
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtruderMountHolesFn(Screw=screw3,All=0) {
	translate([0,-15,0]) rotate([90,0,0]) color("red") cylinder(h = 35, d = Screw); // center
	translate([width/2-5,-15,0]) rotate([90,0,0]) color("blue") cylinder(h = 35, d = Screw); //right
	translate([-(width/2-5),-15,0]) rotate([90,0,0]) color("black") cylinder(h = 35, d = Screw); // left
	if(All) {
		translate([width/4-2,-15,0]) rotate([90,0,0]) color("purple") cylinder(h = 35, d = Screw);
		translate([-(width/4-2),-15,0]) rotate([90,0,0]) color("gray") cylinder(h = 35, d = Screw);
	}
}

/////////////////// end of Dual-Titan-Bowden-E3DV6.scad //////////////////////////////////////////////////////////////////
