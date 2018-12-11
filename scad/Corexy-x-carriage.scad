///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Corexy-x-carriage - x carriage for makerslide and vertical x-axis with 8mm rods
// created: 2/3/2014
// last modified: 12/8/2018
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1/12/16 - added bevel on rear carriage for x-stop switch to ride up on
// 1/21/16 - added Prusa i3 style extruder mount to makerslide carriage and put it into a seperate module
// 3/6/16  - added BLTouch mounting holes, sized for the tap for 3mm screws (centered behind hotend)
// 5/24/16 - adjusted makerslide carriage for i3(30mm) mount by making it a bit wider
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
// 12/22/16 - changed z probe mounts and mounting for titan() extruder plate
// 12/23/16 - cleaned up some code and fixed the screw hole sizes in prox_adapter() & iradapter()
// 12/27/16 - fixed fan mount screw holes on titan()
// 1/8/17	- changed side mounting holes of titan3(), shifted up to allow access to lower mouting holes when
//			  assembled
// 1/9/17	- made titan() able to be used as the titan bowden mount
// 7/9/18	- added a rounded bevel around the hotend clearance hole to the titan mount using corner-tools.scad
//			  and fixed the rear support to be rounded in titan() and removed some unecessary code
//			  added rounded hole under motor to titan3() and fixed mounting holes
// 7/12/18	- Noticed the plate was not setup for a 200x200 bed
// 8/19/18	- Dual Titabnmount is in DualTitan.scad, OpenSCAD 2018.06.01 for $preview, which is used to make sure
//			  a 200x200 bed can print multiple parts.
// 8/20/18	- Added a carridge and belt only for DualTitan.scad, redid the modules for the other setups
// 12/8/18	- Changed belt clamp from adjusting type to solid (stepper motors are adjustable)
//			  Added preview color to belt modules
//			  Added x-carriage belt drive loop style
// 12/10/18	- Edited carriage() and carriagebelt() to not use center=true for the cubeX[]
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// What rides on the x-axis is separate from the extruder plate
// The screw2 holes must be drilled with a 2.5mm drill for a 3mm tap or to allow a 3mm to be screwed in without tapping
// I used 3x16mm cap head screws to mount the extruder plate to the carriage
// ---------------------------------------------------------
// PLA can be used for the carriage & belt parts
// ---------------------------------------------------------
// Extruder plate use ABS or better if you have a hotend that gets hot at it's mounting.
// for example: using an E3DV6, PLA will work fine, since it doesn't get hot at the mount.
// ---------------------------------------------------------
// Belt clamp style: Assemble both belt clamps before mounting on x-carriage, leave loose enough to install belts
// The four holes on top are for mounting an endstopMS.scad holder, tap them with a 5mm tap.
// ---------------------------------------------------------
// For the loop belt style: tap holes for 3mm and mount two belt holders, it's in belt_holder.scad
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
// IR sensor bracket is in irsensorbracket.scad
//-----------------------------------------------------------
// corner-tools.scad fillet_r() doesn't show in preview
//////////////////////////////////////////////////////////////////////////////////////////////////////////
include <cxy-msv1_h.scad>
$fn=50;
TestLoop=1; // have original belt clamp mount hole visible
LoopHoleOffset=28;	// distance between the belt lopp mounting holes (same as in belt_holder.scad)
LoopHOffset=0;		// shift horizontal the belt loop mounting holes
LoopVOffset=-2;		// shift vertical the belt loop mounting holes
// NOTE: there are some variables defined right before titan()
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//partial();
FrontCarridge(0,1);  // 1st:0-no clamps,1-clamps;2nd:clamps style,2-belt loop style
//RearCarridge(0,1); // 1st:0-no clamps,1-clamps;2nd:clamps style,2-belt loop style
//ExtruderPlateMount(2,2);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FrontCarridge(Clamps=1,Loop=0) {
	if($preview) %translate([-100,-100,-1]) cube([200,200,1]);
	translate([-40,0,0]) carriage(0);			// makerslide x-carriage
	translate([-10,-50,0]) belt(Clamps,Loop);  // x-carriage belt attachment
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RearCarridge(Clamps=1,Loop=0) {
	if($preview) %translate([-100,-100,-1]) cube([200,200,1]);
	translate([10,-40,0]) carriagebelt(Clamps,Loop);
	translate([-80,-40,0]) carriage(1,0); // makerslide x-carriage
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module ExtruderPlateMount(Ext=0,Sensor=0) {
	if($preview) %translate([-100,-100,-5]) cube([200,200,1]);
	if(Ext == 0)
		extruder(Sensor);	// for BLTouch: 0 = top mounting through hole, 1 - bottom mount in recess
							// 2 - proximity sensor hole in psensord size
							// 3 - dc42's ir sensor
	if(Ext == 1) {			// 4 or higher = none
		// drill guide for using an AL plate instead of a printed one
		rotate([0,0,90]) extruderplatedrillguide();
	}
	if(Ext == 2)  // Proximity
		translate([5,5,0]) rotate([0,0,-90]) titan(Sensor);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module partial() {
	//if($preview) %translate([-100,-100,-1]) cube([200,200,1]); // parts may not be on the preview plate
	//carriage(1,0);	// makerslide x-carriage, set arg to 1 for a titan thumbwheel notch,
					// second arg to shift notch (-# towards center)
	//extruder(4);	// for BLTouch: 0 & 1, 2 is proximity, 3 is dc42 ir sensor, 4- none
	belt(0,1); 		// x-carriage belt attachment with the clamps
	//belt(1,0); 		// x-carriage belt attachment with the clamps
	//belt_drive(0);	// x-carriage belt attachment only
	//extruderplatedrillguide();	// drill guide for using an AL plate instead of a printed one
	//wireclamp();
	//carriagebelt(1);
	//translate([0,-45,26]) rotate([-90,0,0]) // this puts the titan mount on the carraige
	//	titan(3);	// extruder platform for e3d titan with (0,1)BLTouch or (2)Proximity or (3)dc42's ir sensor
					// 4 - all sensor brackets; 5 - no sensor brackets
	//titan2(); // right angle titan mount to 2020 for bowden
	//titan3();	// extruder platform to mount directly on x_carridge()
	//prox_mount(shiftprox);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module carriage(Titan=0,Tshift=0) { // wheel side
	difference() {
		color("cyan") cubeX([width,height,wall],radius=2); // makerslide side
		notch_bottom();	// square bottom for an extruder plate
		// wheel holes
		translate([width/2,42,0]) color("red") hull() { // bevel the countersink to get easier access to adjuster
			translate([0,tri_sep/2,3]) cylinder(h = depth+10,r = screw_hd/2,$fn=50);
			translate([0,tri_sep/2,10]) cylinder(h = depth,r = screw_hd/2+11,$fn=50);
		}
		translate([width/2,42,0]) {
			translate([0,tri_sep/2,-10]) color("blue") cylinder(h = depth+10,r = adjuster/2,$fn=50);
			translate([dual_sep/2,-tri_sep/2,-10]) color("yellow") cylinder(h = depth+10,r = screw/2,$fn=50);
			translate([-dual_sep/2,-tri_sep/2,-10]) color("purple") cylinder(h = depth+10,r = screw/2,$fn=50);
			translate([dual_sep/2,-tri_sep/2,3]) color("gray") cylinder(h = depth+10,r = screw_hd/2,$fn=50);
			translate([-dual_sep/2,-tri_sep/2,3]) color("green") cylinder(h = depth+10,r = screw_hd/2,$fn=50);
		}
		translate([38,45,2]) color("red") hull() { // side notch
			translate([width/2-9,height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([width/2-9,-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([width/2,height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([width/2,-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
		}
		translate([38,45,2]) color("black") hull() { // side notch
			translate([-(width/2-9),height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([-(width/2-9),-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([-(width/2),height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			translate([-(width/2),-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
		}
		//if(Titan) translate([20-Tshift,50,5]) color("yellow") cylinder(h=5,d=20,$fn=100); // Titan thumbwheel notch
		translate([38,37,2]) color("gray") hull() { // reduce usage of filament
			translate([0,height/8,-wall]) cylinder(h = wall+10, r = 6,$fn=50);
			translate([0,-height/4,-wall]) cylinder(h = wall+10, r = 6,$fn=50);
		}
		// screw holes to mount extruder plate
		translate([38,45,4]) {
			translate([0,-15,0]) rotate([90,0,0]) color("red") cylinder(h = 35, r = screw2/2, $fn = 50);
			translate([width/2-5,-15,0]) rotate([90,0,0]) color("blue") cylinder(h = 35, r = screw2/2, $fn = 50);
			translate([-(width/2-5),-15,0]) rotate([90,0,0]) color("black") cylinder(h = 35, r = screw2/2, $fn = 50);
			translate([width/4-2,-15,0]) rotate([90,0,0]) color("purple") cylinder(h = 35, r = screw2/2, $fn = 50);
			translate([-(width/4-2),-15,0]) rotate([90,0,0]) color("gray") cylinder(h = 35, r = screw2/2, $fn = 50);
			// screw holes in top (alternate location for a belt holder)
			translate([width/4-5,height/2+2,0]) rotate([90,0,0]) color("red") cylinder(h = 25, r = screw2/2, $fn = 50);
			translate([-(width/4-5),height/2+2,0]) rotate([90,0,0]) color("blue") cylinder(h = 25, r = screw2/2, $fn = 50);
			CarridgeMount(); // mounting holes for a Prusa i3 style extruder
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module servo(Screw=screw3t,Left=1) {	// servo mounting holes
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
			rotate([0,90,0]) color("blue") cylinder(h = depthE+screw_depth,d = Screw,$fn=50);
		translate([extruder/2-12,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
			rotate([0,90,0]) color("white") cylinder(h = depthE+screw_depth,d = Screw,$fn=50);
	if(Left) {
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back + servo_spacing/2 - servo_offset])
			rotate([0,90,0]) color("black") cylinder(h = depthE+screw_depth,d = Screw,$fn=50);
		translate([-extruder/2-22,-heightE/2 - 1.8*wall,heightE - extruder_back - servo_spacing/2 - servo_offset])
			rotate([0,90,0]) color("red") cylinder(h = depthE+screw_depth,d = Screw,$fn=50);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module sidemounts(Screw=screw3t,Left=1) {	// combo of above two modules
	fan(Screw,Left);
	servo(Screw,Left);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module extruder(recess=0) // bolt-on extruder platform, works for either makerslide or lm8uu versions
{							// used for extruder mount via a wades extruder style
	difference() {
		color("red") cubeX([widthE,heightE,wall],radius=2,center=true); // extruder side
		if(recess == 2) {
			translate([0,-height/3-6,0]) { // extruder notch
				color("blue") minkowski() {
					cube([25,60,wall+5],true);
					cylinder(h = 1,r = 5,$fn=50);
				}
			}
		} else {
			translate([0,-height/3,0]) { // extruder notch
				color("pink") minkowski() {
					cube([25,60,wall+5],true);
					cylinder(h = 1,r = 5,$fn=50);
				}
			}
		}
		// screw holes to mount extruder plate
		translate([0,30-wall/2,-10]) color("gray") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/2-5,30-wall/2,-10]) color("blue") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/2-5),30-wall/2,-10]) color("pink") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/4-2,30-wall/2,-10]) color("black") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/4-2),30-wall/2,-10]) color("lightblue") cylinder(h = 25, r = screw3/2, $fn = 50);
		// extruder mounting holes
		color("black") hull() {
			translate([extruder/2+2,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
			translate([extruder/2-4,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
		}
		color("gray") hull() {
			translate([-extruder/2+4,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
			translate([-extruder/2-2,-heightE/2+14,-8]) cylinder(h = depthE+10,r = screw4/2,$fn=50);
		}
		translate([0,28,41+wall/2]) rotate([90,0,0]) servo();
		translate([0,26,41+wall/2]) rotate([90,0,0]) fan();
		if(recess != 4) {
			if(recess == 1) {	// dependent on the hotend, for mounting under the extruder plate
				translate([-bltl/2+3,bltw/2+3,bltdepth]) color("cyan") minkowski() { // depression for BLTouch
				// it needs to be deep enough for the retracted pin not to touch bed
				cube([bltl-6,bltw-6,wall]);
				cylinder(h=1,r=3,$fn=100);
			}
			translate([-bltl/2+8,bltw/2,-5]) color("blue") cube([bltd,bltd+1,wall+3]); // hole for BLTouch
			translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,r=screw2/2,$fn=100);
			translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,r=screw2/2,$fn=100);
			}
			if(recess == 0) {	// for mounting on top of the extruder plate
				translate([-bltl/2+8,bltw/2,-5]) color("blue") cube([bltd,bltd+1,wall+3]); // hole for BLTouch
				translate([bltouch/2,16,-10]) color("pink") cylinder(h=25,r=screw2/2,$fn=100);
				translate([-bltouch/2,16,-10]) color("black") cylinder(h=25,r=screw2/2,$fn=100);
			}
			if(recess == 2) { // proximity sensor
				translate([0,10,-6]) color("pink") cylinder(h=wall*2,r=psensord/2,$fn=50);
			}
		}
	}
	if(recess == 3) { // dc42's ir sensor mount
		translate([irmount_width/2,5,0]) rotate([90,0,180]) iradapter();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module notch_bottom()
{
	translate([38,-2,4]) cube([width+1,wall,wall+2], true);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_drive(Loop=0)	// corexy
{
	difference() {	// base
		translate([-3,-0,0]) color("cyan") cubeX([47,40,wall],2);
		if(!Loop) {
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
		translate([6,wall/2,-1]) rotate([0,0,0]) color("blue") cylinder(h = 15, r = screw3/2, $fn = 50);
		translate([6+(width/4+8.5),wall/2,-1]) rotate([0,0,0]) color("black") cylinder(h = 15, r = screw3/2, $fn = 50);
		color("white") hull() { // plastic reduction
			translate([21,16,-5]) cylinder(h= 20, r = 8,$fn=50);
			translate([21,25,-5]) cylinder(h= 20, r = 8,$fn=50);
		}
		 // mounting holes for an endstop holder
		translate([4,13,-5]) color("khaki") cylinder(h= 20, r = screw5t/2,$fn=50);
		translate([4,33,-5]) color("plum") cylinder(h= 20, r = screw5t/2,$fn=50);
		translate([37,13,-5]) color("gold") cylinder(h= 20, r = screw5t/2,$fn=50);
		translate([37,33,-5]) color("red") cylinder(h= 20, r = screw5t/2,$fn=50);
	}
	difference() {	// right wall
		translate([-wall/2-1,0,0]) color("yellow") cubeX([wall-2,40,29],2);
		if(!Loop) {
			translate([-wall/2-2,belt_adjust,27]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([-wall/2-2,belt_adjust,4]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([-0.5,belt_adjust,27]) rotate([0,90,0]) color("blue") nut(m3_nut_diameter,3);
			translate([-0.5,belt_adjust,4]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		} else beltloopholder();
		if(TestLoop) // add one of belt clamp holes for adjusting the belt loop holder mounting holes
				translate([-wall/2-2,belt_adjust,4]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, r = screw3/2,$fn=50);
	}
	if(!Loop) beltbump(0);
	difference() {	// left wall
		translate([36+wall/2,0,0]) color("pink") cubeX([wall-2,40,29],2);
		if(!Loop) {
			translate([32,belt_adjust,4]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([32,belt_adjust,27]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([38.5,belt_adjust,4]) rotate([0,90,0]) color("blue") nut(m3_nut_diameter,3);
			translate([38.5,belt_adjust,27]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		} else {
			translate([32,belt_adjust,27]) rotate([0,90,0]) color("black") cylinder(h = 2*wall, r = screw3/2,$fn=50);
			beltloopholder();
		}
	}
	difference() {	// rear wall - adds support to walls holding the belts
		translate([-wall/2+1,42-wall,0]) color("gray") cubeX([47,wall-2,belt_adjust],2);
		translate([4,33,-5]) color("blue") cylinder(h= 25, r = screw5/2,$fn=50);	// clearance for endstop screws
		translate([37,33,-5]) color("red") cylinder(h= 25, r = screw5/2,$fn=50);
		if(Loop) beltloopholder();
	}
	if(!Loop) beltbump(1);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module beltloopholder() { // for beltholder.scad
	// pink side
	translate([35,10+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("black") cylinder(h = 2*wall, r = screw3t/2,$fn=50);
	translate([35,4+LoopHoleOffset+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("white") cylinder(h = 2*wall, r = screw3t/2,$fn=50);
	// yellow side
	translate([-10,10+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("plum") cylinder(h = 2*wall, r = screw3t/2,$fn=50);
	translate([-10,4+LoopHoleOffset+LoopHOffset,17+LoopVOffset]) rotate([0,90,0])
		color("gray") cylinder(h = 2*wall, r = screw3t/2,$fn=50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module beltbump(Bump) { // add a little plastic at the belt clamp screw holes at the edge
	if(Bump) {
		difference() {	
			translate([40,belt_adjust,27]) rotate([0,90,0]) color("cyan") cylinder(h = wall-2, r = screw3+0.5,$fn=50);
			translate([32,belt_adjust,27]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([38.5,belt_adjust,27]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		}
	} else {
		difference() {	
			translate([-wall/2-1,belt_adjust,27]) rotate([0,90,0]) color("cyan") cylinder(h = wall-2, r = screw3+0.5,$fn=50);
			translate([-wall/2-2,belt_adjust,27]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([-0.5,belt_adjust,27]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt(Clamps=0,Loop=0) // belt mount plate - loop or clamps
{
	belt_drive(Loop);
	if(Clamps && !Loop) {
		translate([60,0,-0.5]) belt_adjuster();
		translate([60,35,-0.5]) belt_adjuster();
		translate([52,0,3.5]) belt_roundclamp();
		translate([75,0,4]) belt_anvil();
		translate([52,35,3.5]) belt_roundclamp();
		translate([75,35,4]) belt_anvil();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_adjuster()
{
	difference() {
		translate([-1,0,0]) color("blue") cubeX([9,30,9],2);
		translate([-1.5,5.5,7]) color("red") cube([11,7,3.5]);
		translate([-1.5,16.5,7]) color("cyan") cube([11,7,3.5]);
		translate([4,3,-5]) color("white") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([4,26,-5]) color("plum") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-5,9,4.5]) rotate([0,90,0]) color("gray") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([-2,9,4.5]) rotate([0,90,0]) color("black") nut(m3_nut_diameter,3);
		translate([-5,20,4.5]) rotate([0,90,0]) color("khaki") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([7,20,4.5]) rotate([0,90,0]) color("gold") nut(m3_nut_diameter,3);
	}
}

module belt_adjuster_captive() {
	difference() {
		translate([-1,0,0]) color("blue") cubeX([9,30,9],2);
		translate([4,3,-5]) color("white") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		translate([4,26,-5]) color("plum") cylinder(h = 2*wall, r = screw3/2,$fn=50);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_anvil()
{
	translate([0,0,-3]) rotate([0,0,90]) difference() {
		rotate([0,90,0]) cylinder(h = 9, r = 4, $fn= 100);
		translate([3,0,-6]) cube([15,10,10],true);
		translate([4,0,-3]) cylinder(h = 5, r = screw3/2,$fn = 50);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_roundclamp() // something round to let the belt smoothly move over when using the tensioner screw
{
	rotate([0,90,90]) difference() {
		cylinder(h = 30, r = 4, $fn= 100);
		translate([-6,0,3]) rotate([0,90,0])cylinder(h = 15, r = screw3/2,$fn = 50);
		translate([-6,0,26]) rotate([0,90,0])cylinder(h = 15, r = screw3/2,$fn = 50);
		translate([4.5,0,8]) cube([2,8,45],true); // flatten the top & bottom
		translate([-4.5,0,8]) cube([2,8,45],true);
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CarridgeMount() { // four mounting holes for using seperate mounting extruder brcket
	// lower
	translate([mount_seperation/2,-height/4 + mount_height,-5]) color("black") cylinder(h = wall+10, r = screw4/2,$fn = 50);
	translate([-mount_seperation/2,-height/4+ mount_height,-5]) color("blue") cylinder(h = wall+10, r = screw4/2,$fn = 50);
	// upper
	translate([mount_seperation/2,-height/4 + mount_height + mount_seperation,-5]) color("red") cylinder(h = wall+10, r = screw4/2,$fn = 50);
	translate([-mount_seperation/2,-height/4+ mount_height + mount_seperation,-5]) color("plum") cylinder(h = wall+10, r = screw4/2,$fn = 50);
}

////////////////////////////////////////////////////////////////////

module extruderplatedrillguide() { // for drilling 1/8" 6061 in place of a printed extruder plate
	// Use the printed extruder plate as a guide to making an aluminum version
	difference() {
		color("cyan") cube([width,wall,wall],true); // makerslide side
		// screw holes to mount extruder plate
		translate([0,10,0]) rotate([90,0,0]) color("red") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/2-5,10,0]) rotate([90,0,0]) color("blue") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/2-5),10,0]) rotate([90,0,0]) color("black") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/4-2,10,0]) rotate([90,0,0]) color("gray") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([-(width/4-2),10,0]) rotate([90,0,0]) color("yellow") cylinder(h = 25, r = screw3/2, $fn = 50);
	}
}

/////////////////////////////////////////////////////////////////////////////

module wireclamp() {  // uses screws holding the extruder plate, this is current not used
	difference() {
		translate([8.5,0,0]) color("cyan") cube([25,wall,wall-2],true); // makerslide side
		translate([0,10,0]) rotate([90,0,0]) color("blue") cylinder(h = 25, r = screw3/2, $fn = 50);
		translate([width/4-2,10,0]) rotate([90,0,0]) color("black") cylinder(h = 25, r = screw3/2, $fn = 50);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module iradapter(Top,Taller=0) {  // ir sensor bracket stuff is from irsensorbracket.scad
	difference() {
		color("plum") cubeX([irmount_width,irmount_height+Taller,irthickness],2); // mount base
		reduce(Taller);
		block_mount(Taller);
		recess(Taller);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module recess(Taller=0) { // make space for the thru hole pin header
	translate([hole1x+3,hole1y+irrecess+(irmount_height/4)+Taller,irnotch_d]) color("cyan") cube([15.5,10,5]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module reduce(Taller=0) { // reduce plastic usage and gives somewhere for air to go if using an all-metal hotend w/fan
	translate([13.5,irmount_height-irreduce+Taller/2,-1]) color("teal") cylinder(h=10,r = irmount_width/4);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module block_mount(Taller=0) // mounting screw holes for the ir sensor
{
	//mounting screw holes
	translate([hole1x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("black") cylinder(h=20,r=screw3t/2,$fn=50);
	translate([hole2x+iroffset-1.5,irmounty+Taller,-5]) rotate([0,0,0]) color("white") cylinder(h=20,r=screw3t/2,$fn=50);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module carriagebelt(Clamps=0,Loop=0) {
	difference() { // back side carriage
		color("cyan") cubeX([width,height+3,wall],2); // makerslide side
		translate([38,45,2]) { // wheel holes
			translate([0,tri_sep/2,-1]) color("red") cylinder(h = depth+10,r = screw_hd/2,$fn=50);
			translate([0,tri_sep/2,-10]) color("black") cylinder(h = depth+10,r = adjuster/2,$fn=50);
			translate([dual_sep/2,-tri_sep/2,-10]) color("yellow") cylinder(h = depth+10,r = screw/2,$fn=50);
			translate([-dual_sep/2,-tri_sep/2,-10]) color("blue") cylinder(h = depth+10,r = screw/2,$fn=50);
			translate([dual_sep/2,-tri_sep/2,0]) color("purple") cylinder(h = depth+10,r = screw_hd/2,$fn=50);
			translate([-dual_sep/2,-tri_sep/2,0]) color("gray") cylinder(h = depth+10,r = screw_hd/2,$fn=50);
			// hole supports
			translate([0,tri_sep/2,-1]) color("red") cylinder(h = layer,r = screw_hd/2,$fn=50);
			translate([dual_sep/2,-tri_sep/2,0]) color("black") cylinder(h = layer,r = screw_hd/2,$fn=50);
			translate([-dual_sep/2,-tri_sep/2,0]) color("gray") cylinder(h = layer,r = screw_hd/2,$fn=50);
			color("blue") hull() { // side notch
				translate([width/2-6,height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
				translate([width/2-6,-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
				translate([width/2,height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
				translate([width/2,-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			}
			color("red") hull() { // side notch
				translate([-(width/2-6),height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
				translate([-(width/2-6),-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
				translate([-(width/2),height,-5]) cylinder(h = wall+5, r = 10,$fn=50);
				translate([-(width/2),-height/8,-5]) cylinder(h = wall+5, r = 10,$fn=50);
			}
			color("purple") hull() { // reduce usage of filament
				translate([0,height/8,-wall]) cylinder(h = wall+10, r = 6,$fn=50);
				translate([0,-height/4,-wall]) cylinder(h = wall+10, r = 6,$fn=50);
			}
		}
	}
	translate([38,45,2]) difference() {
		translate([20.5,53,36]) rotate([90,180,0]) belt_drive2(Loop);	// x-carriage belt attachment only
		translate([0,tri_sep/2,-10]) color("blue") cylinder(h = depth+10,r = adjuster/2,$fn=50);
		rotate([0,180,0]) translate([0,tri_sep/2,-1]) color("gray") cylinder(h = depth+10,r = screw_hd/2,$fn=50);
	}
	if(Clamps && !Loop) translate([38,45,2]) belt2(Loop);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt_drive2(Loop=0)	// corexy
{
	difference() {	// base
		translate([-3,-10,0]) color("red") cubeX([47,50,wall],2); // base (top)
		if(!Loop) {
			color("blue") hull() {	// belt clamp nut access slot
				translate([-4,belt_adjust-10,8]) rotate([0,90,0]) nut(m3_nut_diameter,14); // make room for nut
				translate([-4,belt_adjust-10,4]) rotate([0,90,0]) nut(m3_nut_diameter,14); // make room for nut
			}
			color("purple") hull() {	// belt clamp nut access slot
				translate([31,belt_adjust-10,8]) rotate([0,90,0]) nut(m3_nut_diameter,14);
				translate([31,belt_adjust-10,4]) rotate([0,90,0]) nut(m3_nut_diameter,14);
			}
		}
		// mounting screw holes to x-carriage plate
		translate([7,wall/2-10,-1]) rotate([0,0,0]) color("gray") cylinder(h = 15, r = screw3/2, $fn = 50);
		translate([7+(width/4+8.5),wall/2-10,-1]) rotate([0,0,0]) color("black") cylinder(h = 15, r = screw3/2, $fn = 50);
		color("cyan") hull() { // plastic reduction
			translate([21,6,-5]) cylinder(h= 20, r = 8,$fn=50);
			translate([21,23,-5]) cylinder(h= 20, r = 8,$fn=50);
		}
		 // mounting holes for an endstop holder
		translate([4,5,-5]) color("yellow") cylinder(h= 20, r = screw5t/2,$fn=50);
		translate([4,25,-5]) color("purple") cylinder(h= 20, r = screw5t/2,$fn=50);
		translate([37,5,-5]) color("blue") cylinder(h= 20, r = screw5t/2,$fn=50);
		translate([37,25,-5]) color("lightblue") cylinder(h= 20, r = screw5t/2,$fn=50);
	}
	difference() {	// right wall
		translate([-wall/2-1,-10,0]) color("blue") cubeX([wall-2,50,29],2);
		if(!Loop) {
			translate([-wall/2-2,belt_adjust-10,27]) rotate([0,90,0]) color("red") cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([-0.5,belt_adjust-10,27]) color("purple") rotate([0,90,0]) nut(m3_nut_diameter,3);
			translate([-0.5,belt_adjust-10,4]) color("cyan") rotate([0,90,0]) nut(m3_nut_diameter,3);
			translate([-wall/2-2,belt_adjust-10,4]) rotate([0,90,0]) color("yellow") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		} else { 
			translate([0,-7,0]) beltloopholder();
			if(TestLoop)
				translate([-wall/2-2,belt_adjust-10,4]) rotate([0,90,0]) color("yellow") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		}
	}
	if(!Loop) beltbump2(0);
	difference() {	// left wall
		translate([36+wall/2,-10,0]) color("purple") cubeX([wall-2,50,29],2);
		if(!Loop) {
			translate([32,belt_adjust-10,4]) rotate([0,90,0]) color("pink") cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([32,belt_adjust-10,27]) rotate([0,90,0]) color("yellow") cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([38.5,belt_adjust-10,4]) rotate([0,90,0]) color("cyan") nut(m3_nut_diameter,3);
			translate([32,belt_adjust-10,27]) rotate([0,90,0]) color("black") cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([38.5,belt_adjust-10,27]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		} else {
			translate([0,-7,0]) beltloopholder();
			if(TestLoop)
				translate([32,belt_adjust-10,4]) rotate([0,90,0]) color("pink") cylinder(h = 2*wall, r = screw3/2,$fn=50);
		}
	}
	if(!Loop) beltbump2(1);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module belt2() // belt mount plate or if MkrSld: top plate
{
	translate([-35,-10,-0.5]) color("red") belt_roundclamp();
	translate([-50,-10,-4.5]) color("blue") belt_adjuster();
	translate([-45,-40,0]) color("black") belt_anvil();
	translate([-35,25,-0.5]) color("cyan") belt_roundclamp();
	translate([-50,25,-4.5]) color("purple") belt_adjuster();
	translate([-45,-25,0]) color("gray") belt_anvil();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module beltbump2(Bump) { // add a little plastic at the belt clamp screw holes at the edge
	if(Bump) {
		difference() {	
			translate([40,belt_adjust-10,27]) rotate([0,90,0]) color("red") cylinder(h = wall-2, r = screw3+1,$fn=50);
			translate([32,belt_adjust-10,27]) rotate([0,90,0]) color("yellow") cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([38.5,belt_adjust-10,27]) rotate([0,90,0]) color("gray") nut(m3_nut_diameter,3);
		}
	} else {
		difference() {	
			translate([-wall/2-1,belt_adjust-10,27]) rotate([0,90,0]) color("blue") cylinder(h = wall-2, r = screw3+1,$fn=50);
			translate([-wall/2-2,belt_adjust-10,27]) rotate([0,90,0]) color("cyan") cylinder(h = 2*wall, r = screw3/2,$fn=50);
			translate([-0.5,belt_adjust-10,27]) rotate([0,90,0]) color("yellow") nut(m3_nut_diameter,3);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

e3dv6 = 35;			// hole for e3dv6
shifttitanup = 5;	// move motor up/down
shifthotend = 0;	// move hotend opening front/rear
shifthotend2 = -20;	// move hotend opening left/right
spacing = 17; 		// ir sensor bracket mount hole spacing
shiftir = -20;	// shift ir sensor bracket mount holes
shiftblt = 0;	// shift bltouch up/down
shiftprox = 0;	// shift proximity sensor up/down
//-----------------------------------------------------------------------------------------
// info from irsensorbracket.scad
//-----------------------------------
hotend_length = 50; // 50 for E3DV6
board_overlap = 2.5; // amount ir borad overlap sensor bracket
irboard_length = 17 - board_overlap; // length of ir board less the overlap on the bracket
ir_gap = 0;		// adjust edge of board up/down
//-----------------------------------------------------------------------------------------
ir_height = (hotend_length - irboard_length - ir_gap) - irmount_height;	// height of the mount

module titan(recess=3) { // extruder platform for e3d titan with (0,1)BLTouch or (2)Proximity or (3)dc42's ir sensor
 	difference() {
		translate([-37.5,-42,-wall/2]) color("cyan") cubeX([widthE+shifthotend2/1.3,heightE+13,wall],2); // extruder side
		extmount(screw3);
        e3dv6hole();
 		 // remove some under the motor
		translate([20+shifthotend2,-5,-10]) color("pink") cylinder(h=20,d=23.5,$fn=100);
	    translate([0,-5,wall/2]) color("purple") fillet_r(2,23/2,-1,$fn);	// round top edge
	    translate([0,-5,-wall/2]) color("purple") rotate([180]) fillet_r(2,23/2,-1,$fn);	// round bottom edge
	    
		translate([-15,16.5,44]) rotate([90,0,0]) fan(screw3t,0); // fan & servo mounting holes
		translate([-50,0,44.5]) rotate([90,0,90]) fan(); // mounting holes for bltouch & prox sensor
		translate([-10,0,0]) ir_mount_screws(); // mounting holes for irsensor bracket
	}
	difference() {
		translate([shifthotend2,-32,0]) rotate([90,0,90]) titanmotor();
		translate([-50,0,44.5]) rotate([90,0,90]) fan(); // mounting holes for bltouch & prox sensor
		translate([-10,0,0]) ir_mount_screws(); // mounting holes for irsensor bracket
	}
	if(recess != 4) {
		if(recess == 0 || recess == 1) translate([30,0,-wall/2]) blt_mount(recess,shiftblt); // BLTouch mount
		if(recess == 2) translate([30,0,-wall/2]) prox_mount(shiftprox); // round hole mount proximity sensor
		if(recess == 3) { // ir mount
			translate([30,-10,-wall/2]) difference() {
				iradapter(0,ir_height);
				translate([25,4,40]) rotate([90,0,0]) ir_mount_screws();
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module e3dv6hole() {
		// hole for e3dv6, shifted to front by 11mm
		translate([-15.5+shifthotend2,-18+shifthotend,-10]) color("pink") cylinder(h=20,d=e3dv6,$fn=100);
		// round top edge
	    translate([-15.5+shifthotend2,-18+shifthotend,wall/2]) color("purple") fillet_r(2,e3dv6/2,-1,$fn);
		// round bottom edge
	    translate([-15.5+shifthotend2,-18+shifthotend,-wall/2]) rotate([180]) color("purple") fillet_r(2,e3dv6/2,-1,$fn);
}
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module prox_mount(Shift) {
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

module blt_mount(Type,Shift) {
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titan2() { // extruder platform for e3d titan to mount on a AL extruder plate
	difference() {
		translate([0,0,0]) cubeX([40,53,5],2); // extruder side
		translate([20,28,-10]) cylinder(h=20,d=20,$fn=100); // remove some plastic under the motor
		translate([10,10,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
		translate([30,10,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
		translate([10,45,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
		translate([30,45,-1]) cylinder(h=20,d=screw4,$fn=100); // mounting screw hole
	}
	translate([0,1,0]) rotate([90,0,90]) titanmotor();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titan3(Screw=screw4) { // extruder platform for e3d titan to mount directly on the x-carraige
	difference() { // bottom support
		translate([0,0,0]) color("pink") cubeX([45,57,5],2); // extruder side
		translate([20,28,-10]) color("red") cylinder(h=20,d=23,$fn=100); // remove some plastic under the motor
	    translate([20,28,-wall/2+4]) color("purple") rotate([180]) fillet_r(2,23/2,-1,$fn);	// round bottom edge
	    translate([20,28,wall/2+1]) color("purple") fillet_r(2,23/2,-1,$fn);	// round top edge
		translate([6,65,47]) rotate([90,0,0]) fan(screw3t,0); // fan & servo mounting holes at rear
		translate([-15,45,47]) rotate([90,0,90]) fan(); // mounting holes for bltouch & prox sensor on the side
		translate([25,43,2.6]) ir_mount_screws(); // mounting holes for irsensor bracket on the side
	}
	difference() {
		translate([0,1,0]) rotate([90,0,90]) titanmotor(1);
		translate([25,43,2.6]) ir_mount_screws(); // clear the mounting holes for irsensor bracket on the side
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module extmount(Screw=screw3) {		// screw holes to mount extruder plate
	if(Screw==screw3) {
		translate([0,30-wall/2,-10]) color("red") cylinder(h = 25, d = Screw, $fn = 50);
		translate([width/2-5,30-wall/2,-10]) color("white") cylinder(h = 25, d = Screw, $fn = 50);
		translate([-(width/2-5),30-wall/2,-10]) color("blue") cylinder(h = 25, d = Screw, $fn = 50);
		translate([width/4-2,30-wall/2,-10]) color("green") cylinder(h = 25, d = Screw, $fn = 50);
		translate([-(width/4-2),30-wall/2,-10]) color("purple") cylinder(h = 25, d = Screw, $fn = 50);
	}
	if(Screw==screw5) {
		translate([-(width/2-5),30-wall/2,-10]) color("blue") cylinder(h = 25, d = Screw, $fn = 50);
		translate([-(width/4-10),30-wall/2,-10]) color("red") cylinder(h = 25, d = Screw, $fn = 50);
		translate([width/4-2,30-wall/2,-10]) color("green") cylinder(h = 25, d = Screw, $fn = 50);
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module titanmotor(WallMount=0,Screw=screw4) {
	difference() {	// motor mount
		translate([-1,0,0]) color("red") cubeX([57,60+shifttitanup,5],2);
		translate([25,35+shifttitanup,-1]) rotate([0,0,45]) color("purple") NEMA17_x_holes(8, 2);
	}
	difference() { // front support
		translate([-1,24,-48]) color("blue") rotate([60,0,0]) cubeX([4,60,60],2);
		translate([-3,-30,-67]) cube([7,90,70]);
		translate([-3,-67,-45]) cube([7,70,90]);
	}
	if(WallMount) {
		difference() { // rear support
			translate([52,0,0]) color("cyan") cubeX([4,45+shifttitanup,45],2);
			// lower mounting screw holes
			translate([40,15,11]) rotate([0,90,0]) color("cyan") cylinder(h=20,d=Screw,$fn=100);
			translate([40,15,11+mount_seperation]) rotate([0,90,0])  color("blue") cylinder(h=20,d=Screw,$fn=100);
			if(Screw==screw4) { // add screw holes for horizontal extrusion
				translate([40,15+mount_seperation,34]) rotate([0,90,0]) color("red") cylinder(h=20,d=Screw,$fn=100);
				translate([40,15+mount_seperation,34-mount_seperation]) rotate([0,90,0])  color("pink") cylinder(h=20,d=Screw,$fn=100);
			}
		}
	} else {
		difference() { // rear support
			translate([49,24,-48]) rotate([60]) color("cyan") cubeX([4,60,60],2);
			translate([47,0,-67]) cube([7,70,70]);
			translate([47,-70,-36]) cube([7,70,70]);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ir_mount_screws(Screw=screw3t) // ir screw holes for mounting to extruder plate
{
	translate([spacing+shiftir+shifthotend,-25,0]) rotate([90,0,0]) color("red") cylinder(h=20,d=Screw,$fn=50);
	translate([shiftir+shifthotend,-25,0]) rotate([90,0,0]) color("blue") cylinder(h=20,d=Screw,$fn=50);
}

///////////////////end of x-carriage.scad////////////////////////////////////////////////////////////////////////////
