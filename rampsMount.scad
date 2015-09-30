module rampsMount()
{
	translate([6.54, 17.24, 0])
        cylinder(r=3.5, h=3.5);
    translate([54.8, 15.97, 0])
        cylinder(r=3.5, h=3.5);
    translate([6.54, 92.17, 0])
        cylinder(r=3.5, h=3.5);
    translate([54.8, 98.52, 0])
        cylinder(r=3.5, h=3.5);
}
module mountHoles()
{
    translate([6.54, 17.24, -3])
        cylinder(r=1.6, h=20);
    translate([54.8, 15.97, -3])
        cylinder(r=1.6, h=20);
    translate([54.8, 98.52, -3])
        cylinder(r=1.6, h=20);
    translate([6.54, 17.24, -3])
        cylinder(r=3.5, h=3, $fn=6);
    translate([54.8, 15.97, -3])
        cylinder(r=3.5, h=3, $fn=6);
    translate([54.8, 98.52, -3])
        cylinder(r=3.5, h=3, $fn=6);
}
//rampsMount();
//mountHoles();