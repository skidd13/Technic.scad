/**
 * Worm-only examples for the unified centre-interface line.
 *
 * Render one example independently with:
 *   openscad -D 'example="long_axle"' -o long_axle.stl examples/technic_worm_gear.scad
 * Valid values: "all", "long_axle", "short_axle", "frictionless_axle".
 */
include <../Technic.scad>;

example = is_undef( example ) ? "all" : example;

module worm_example_long_axle() {
	technic_worm_gear( height = 2, width = 3, opening = "axle" );
}

module worm_example_short_axle() {
	technic_worm_gear( height = 1, width = 4, opening = "axle" );
}

module worm_example_frictionless_axle() {
	technic_worm_gear( height = 2, width = 3, opening = "frictionless_axle" );
}

assert(
	example == "all" || example == "long_axle" || example == "short_axle" || example == "frictionless_axle",
	str( "unknown worm example: ", example )
);

if ( example == "all" || example == "long_axle" ) {
	translate( [ 0, 0, 0 ] ) color( "beige" ) worm_example_long_axle();
}
if ( example == "all" || example == "short_axle" ) {
	translate( [ 20, 0, 0 ] ) color( "gray" ) worm_example_short_axle();
}
if ( example == "all" || example == "frictionless_axle" ) {
	translate( [ 40, 0, 0 ] ) color( "red" ) worm_example_frictionless_axle();
}
