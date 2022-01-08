///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// BrassInserts.scad - returns type of screw hole
// created: 9/23/2020
// last modified: 9/23/20
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 4/13/20	- Functions that return a tap hole or the hole for a brass insert
// 9/23/20	- New verson of brassfunctions.scad, removed getholelen functions
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <screwsizes.scad>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// place these as necessary in file that calles the file
//Use2mmInsert=1;
//Use2p5Insert=1;
//Use3mmInsert=1;
//Use4mmInsert=1;
//Use5mmInsert=1;

function Yes2mmInsert(Use2mmInsert) = (Use2mmInsert==1) ? screw2in : screw2t;

function Yes2p5mmInsert(Use2p5mmInsert) = (Use2p5mmInsert==1) ? screw2p5in : screw2p5t;

function Yes3mmSInsert(Use3mmInsert) = (Use3mmInsert==1) ? screw3inS : screw3t;

function Yes3mmLInsert(Use3mmInsert) = (Use3mmInsert==1) ? screw3inL : screw3t;  // got a kit and they are a bit bigger


 // default to the large inserts
function Yes3mmInsert(Use3mmInsert,Large=1) = (Large==1) ? Yes3mmLInsert(Use3mmInsert) : Yes3mmSInsert(Use3mmInsert);

function Yes4mmInsert(Use4mmInsert) = (Use4mmInsert==1) ? screw4in : screw4t;

function Yes5mmInsert(Use5mmInsert) = (Use5mmInsert==1) ? screw5in : screw5t;

////////////////////////////// end of BrassInserts.scad ///////////////////////////////////////////////////////
