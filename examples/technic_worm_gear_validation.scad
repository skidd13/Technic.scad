/** Worm-only validation fixtures; no spur/single/double gear pairing. */
include <../Technic.scad>;

validation_case = is_undef( validation_case ) ? "long_axle" : validation_case;

assert(
	validation_case == "long_axle"
	|| validation_case == "short_axle"
	|| validation_case == "frictionless_axle",
	str( "unknown worm validation case: ", validation_case )
);

if ( validation_case == "long_axle" ) {
	technic_worm_gear( height = 2, width = 3, opening = "axle", debug = true );
}
if ( validation_case == "short_axle" ) {
	technic_worm_gear( height = 1, width = 4, opening = "axle", debug = true );
}
if ( validation_case == "frictionless_axle" ) {
	technic_worm_gear( height = 2, width = 3, opening = "frictionless_axle", debug = true );
}
