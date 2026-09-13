/** Worm-only validation fixtures; no cross-family gear pairing. */
include <../Technic.scad>;
validation_case = is_undef( validation_case ) ? "long_axle" : validation_case;
assert(
	validation_case == "long_axle" || validation_case == "short_axle"
	|| validation_case == "frictionless_axle" || validation_case == "bushing_ends",
	str( "unknown worm validation case: ", validation_case )
);
if ( validation_case == "long_axle" ) technic_worm_gear( height = 2, width = 3, connector = "axle", debug = true );
if ( validation_case == "short_axle" ) technic_worm_gear( height = 1, width = 4, connector = "axle", debug = true );
if ( validation_case == "frictionless_axle" ) technic_worm_gear( height = 2, width = 3, connector = "frictionless_axle", debug = true );
if ( validation_case == "bushing_ends" ) technic_worm_gear( height = 1, width = 3, connector = [ "bushing", "bushing" ], connector_length = [ 1, 1 ], debug = true );
