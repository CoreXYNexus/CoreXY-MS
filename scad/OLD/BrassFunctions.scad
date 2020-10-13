///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// BrassFunctions.scad - returns type of screw hole
// created: 4/13/2020
// last modified: 4/13/2020
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 4/13/20	- Functions that return a tap hole or the hole for a brass insert
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Use2mmInsert=1;
Use2p5mmInsert=1;
Use3mmInsert=1;
Use4mmInsert=1;
Use5mmInsert=1;


function GetHoleLen2mm() =(Use2mmInsert==1) ? screw2inl*1.5 : 25;
function Yes2mmInsert() = (Use2mmInsert==1) ? screw2in : screw2t;

function GetHoleLen2p5mm() =	(Use2p5mmInsert==1) ? screw2p5l*1.5 : 25;
function Yes2p5mmInsert() = (Use2p5mmInsert==1) ? screw2p5in : screw2p5t;

function GetHoleLen3mm() =	(Use3mmInsert==1) ? screw3inl*1.5 : 25;
function Yes3mmSInsert() = (Use3mmInsert==1) ? screw3inS : screw3t;

function Yes3mmLInsert() = (Use3mmInsert==1) ? screw3inL : screw3t;  // got a kit and they are a bit bigger

function Yes3mmInsert(Large=0) = (Large==1) ? Yes3mmLInsert() : Yes3mmSInsert(); // default to the smaller inserts

function GetHoleLen4mm() =	(Use4mmInsert==1) ? screw4inl*1.5 : 25;
function Yes4mmInsert() = (Use4mmInsert==1) ? screw4in : screw4t;

function GetHoleLen5mm() =	(Use5mmInsert==1) ? screw5inl*1.5 : 25;
function Yes5mmInsert() = (Use5mmInsert==1) ? screw5in : screw5t;

////////////////////////////// end of BrassFunctions.scad ///////////////////////////////////////////////////////
