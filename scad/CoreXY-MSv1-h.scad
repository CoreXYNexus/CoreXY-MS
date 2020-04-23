///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// cxy-msv1_h.scad - variable file for the CXY-MGNv2, a corexy with mgn12 rails
// created: 8/19/2018
// last modified: 8/19/18
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/19/18	 - Created to have only one file for all the common variables
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/configuration.scad> // http://github.com/prusajr/PrusaMendel, which also uses functions.scad & metric.scad
include <inc/screwsizes.scad>
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
use <inc/Nema17.scad>	// https://github.com/mtu-most/most-scad-libraries
use <inc/corner-tools.scad> // got from https://www.myminifactory.com/it/object/3d-print-tools-for-fillets-and-chamfers-on-edges-and-corners-straight-and-or-round-45862 by Ewald Ikemann
$fn=50;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// variables
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
wall = 8;		// thickness of the plates
width = 75;		// width of back/front/extruder plates
depth = wall;	// used where depth is a better description
height = 90;	// height of the back/front plates
widthE = width;	// extruder plate width
depthE = wall;	// thickness of the extruder plate
heightE = 60; 	// screw holes may need adjusting when changing the front to back size
dual_sep = 50.6; // distance between bottom two wheels (this is less than what's on a standard carriage aluminum plate)
tri_sep = 64.6;	// distance between bottom two wheels and top wheel
adjuster = 7.3; // adjuster hole size
extruder = 50;	// mounting hole distance
extruder_back = 18; // adjusts extruder mounting holes from front edge
strutw=8;		// little side struts
struth = 25;
fan_spacing = 32;
fan_offset = -6;  // adjust to align fan with extruder
PCfan_spacing = fan_spacing+30; // spacing for pc part fan adapter mounting
servo_spacing = 32;
servo_offset = 20; // adjust to move servo mount
screw_depth = 25;
vertx_distance = 70; // distance between x rods for vertical x axis
ps_spacer = 10.5; // don't need to print support between lm8uu holders, adjust this when width changes
mount_seperation = 23;	// mount for Prusa i3 stlye extruder; Wilson is 23, Prusa i3 is 30
mount_height = 11.5;	// move the Prusa i3 extruder mounting holes up/down
psensord = 19;	// diameter of proximity sensor
psensornut = 28; // size of proximity sensor nut
layer = 0.2;	// printed layer thickness
// BLTouch variables - uses the screw2 size for the mounting holes, which work fine with the provided screws or can
// ----------------   tapped for 3mm screws
bltouch = 18;// hole distance on BLTouch by ANTCLabs
bltl = 30;	// length of bltouch mount plus a little
bltw = 16;	// width of bltouch mount plus a little
bltd = 14;	// diameter of bltouch body plus 1mm
bltdepth = -2;	// a recess to adjust the z position to keep the retracted pin from hitting the bed
//                         value provided was for the inital test
// BLTouch X offset: 0 - centered behind hotend
// BLTouch Y offset: 38mm - behind hotend (see titan module for titan offsets)
// BLTouch Z offset: you'll have to check this after assembly
// BLTouch retracted size: 42.6mm - as measured on the one I have
// BLTouch extended size: 47.87mm
// The hotend tip must be in the range of the BLTouch to use the plate as coded in here,
// adjust the BLTouch vars as necessary
// The top mounting through hole works for the old MakerGear hotend (which is what I have)
// J-head and the E3dV6 - not tested
// -------------------------------------
belt_adjust = 29;	// belt clamp hole position (increase to move rearward)
//---------------------------------------------------------------------------------------
// following are taken from https://miscsolutions.wordpress.com/mini-height-sensor-board
hole1x = 2.70;
hole1y = 14.92;
hole2x = 21.11;
hole2y = 14.92;
holedia = 2.8;
//---------------------------------------------------------------------------------------
iroffset = 3;		// ir sensor mount hole distance
iroffset2 = 9;	// shift extruder mount holes
irnotch_d = 4;	// depth of notch to clear thru hole components
irmount_height = 25;	// height of the mount
irmount_width = 27;	// width of the mount
irthickness = 6;		// thickness of the mount
irmounty = irmount_height-3; // position of the ir mount holes from end
irreduce = 13.5; // hole in ir mount vertical position
irrecess = -2; // recess in ir mount for pin heater vertical depth
shifttitanup = 0;	// move motor up/down
shifthotend = 0;	// move hotend opening front/rear
shifthotend2 = 2;	// move hotend opening left/right
spacing = 17; 		// ir sensor bracket mount hole spacing
shiftir = -20;	// shift ir sensor bracket mount holes
puck_l = 45.4;	// length of mgn12h
puck_w = 27;	// width of mgn12h
hole_sep = 20;	// distance between mouning holes on mgn12h
thickness = 5; 			// thickness of everything
shift_ir_bowden = 5; // shift ir mount on bowden mount
belt_adjustUD = 2;	// move belt clamp up/down
e3dv6_clearance = 0.1;	// to make the center land a tad thinner
// from http://wiki.e3d-online.com/wiki/E3D-v6_Documentation
e3dv6_od = 16;	// e3dv6 mount outside diameter
e3dv6_id = 12;	// e3dv6 mount inner diameter
ed3v6_tl = 3.7;	// e3dv6 mount top lad height
e3dv6_il = 6-e3dv6_clearance;	// e3dv6 mount inner land height
e3dv6_bl = 3;	// e3dv6 mount bottom land height
e3dv6_total = ed3v6_tl + e3dv6_il + e3dv6_bl; // e3dv6 total mount height
mount_bolt_seperation = 23;	// four bolt mount on x carridge
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Use3mmInsert=1; // set to 1 to use 3mm brass inserts
Use4mmInsert=0; // set to 1 to use 4mm brass inserts
Use5mmInsert=0; // set to 1 to use 5mm brass inserts
