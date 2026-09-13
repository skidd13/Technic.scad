/**
 * Worm-only examples for the unified connector descriptor.
 *
 * Render one example independently with:
 *   openscad -D 'example="long_axle"' -o long_axle.stl examples/technic_worm_gear.scad
 * Valid values: "all", "long_axle", "short_axle", "frictionless_axle", "bushing_ends".
 */
include <../Technic.scad>;

example = is_undef( example ) ? "all" : example;

module worm_example_long_axle() {
	technic_worm_gear( height = 2, width = 3, connector = "axle" );
}
module worm_example_short_axle() {
	technic_worm_gear( height = 1, width = 4, connector = "axle" );
}
module worm_example_frictionless_axle() {
	technic_worm_gear( height = 2, width = 3, connector = "frictionless_axle" );
}
module worm_example_bushing_ends() {
	technic_worm_gear(
		height = 1, width = 3,
		connector = [ "bushing", "bushing" ],
		connector_length = [ 1, 1 ]
	);
}

assert(
	example == "all" || example == "long_axle" || example == "short_axle"
	|| example == "frictionless_axle" || example == "bushing_ends",
	str( "unknown worm example: ", example )
);

if ( example == "all" || example == "long_axle" ) translate( [ 0, 0, 0 ] ) color( "beige" ) worm_example_long_axle();
if ( example == "all" || example == "short_axle" ) translate( [ 20, 0, 0 ] ) color( "gray" ) worm_example_short_axle();
if ( example == "all" || example == "frictionless_axle" ) translate( [ 40, 0, 0 ] ) color( "red" ) worm_example_frictionless_axle();
if ( example == "all" || example == "bushing_ends" ) translate( [ 60, 0, 0 ] ) color( "yellow" ) worm_example_bushing_ends();
