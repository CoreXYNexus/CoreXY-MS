///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// BrassFunctions.scad - returns type of screw hole
// created: 4/13/2020
// last modified: 4/13/2020
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 4/13/20	- Functions that return a screw3t (tap hole) or the hole for a 3mm brass insert
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GetHoleLen2mm(Screw) =	(Screw==screw2in) ? screw2inl*1.5 : 25;
function Yes2mmInsert() = (Use2mmInsert==1) ? screw2in : screw2t;

function GetHoleLen3mm(Screw) =	(Screw==screw3inL) ? screw3inl*1.5 : 25;
function Yes3mmInsert() = (Use3mmInsert==1) ? screw3inS : screw3t;

function Yes3mmLInsert() = (Use3mmInsert==1) ? screw3inL : screw3t;  // got a kit and they are a bit bigger

function GetHoleLen4mm(Screw) =	(Screw==screw4in) ? screw4inl*1.5 : 25;
function Yes4mmInsert() = (Use4mmInsert==1) ? screw4in : screw4t;

function GetHoleLen5mm(Screw) =	(Screw==screw5in) ? screw5inl*1.5 : 25;
function Yes5mmInsert() = (Use5mmInsert==1) ? screw5in : screw5t;

////////////////////////////// end of BrassFunctions.scad ///////////////////////////////////////////////////////
