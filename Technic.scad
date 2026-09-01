/**
 * LEGO and Technic are trademarks of the LEGO Group.
 *
 * For standard LEGO-compatible bricks, see LEGO.scad. This module
 * is specifically for parts without studs, like gears and axles.
 *
 * Copyright (c) 2025 Christopher Finke (cfinke@gmail.com)
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
/***
 * @module Technic.scad
 * An OpenSCAD Technic-compatible piece generator. It currently supports generation of beams, axles, pin connectors, axle pins, elbows, and gears.
 */
$fa = 1; $fs = 0.05;

// LEGO.scad values.
stud_spacing = 8; // Matches LEGO.stud_spacing
stud_diameter = 4.85; // Matches LEGO.stud_diameter
stud_height = 1.8; // Matches LEGO.stud_height
stud_inner_diameter = 3.1; // Matches LEGO.hollow_stud_inner_diameter
stud_outer_diameter = 4.85; // Matches LEGO.stud_diameter

// Global Technic.scad values.
technic_height_in_mm = 7.8; // Vertically-oriented technic pieces (like pin connectors) use this
technic_hole_diameter = 4.85; // Matches LEGO.stud_diameter
technic_axle_interference_fit_ratio = 1.022;

technic_axle_and_pin_connector_face_thickness = 1; // You would think this would match technic_bush_shoulder_height, but it doesn't really.

technic_axle_spline_thickness = 1.8;
technic_axle_spline_width = 4.85; // Matches LEGO.stud_diameter
technic_axle_spline_corner_radius = 0.4;
technic_axle_cross_section_radius = 1;
technic_axle_stop_thickness = 0.7; // Matches technic_pin_collar_thickness
technic_axle_stop_diameter = 5.9;
technic_axle_stud_height = 1.8; // Matches LEGO.stud_height
technic_axle_stud_inner_diameter = 3.1; // Matches LEGO.hollow_stud_inner_diameter
technic_axle_stud_outer_diameter = 4.85; // Matches LEGO.stud_diameter
technic_axle_notch_height = 1.3; // Matches technic_bush_shoulder_height
technic_axle_notch_diameter = 4.2;

technic_axle_connector_outer_diameter = 7.36; // @todo Measure IRL
technic_axle_connector_ridged_inner_diameter = 6.5; // @todo Measure IRL
technic_axle_connector_ridge_thickness = 0.6; // @todo Measure IRL

technic_bar_connector_outer_diameter = 7.36; // @todo Measure IRL
technic_bar_connector_inner_diameter = 3.2; // @todo Measure IRL

technic_bush_big_diameter = 7.4;
technic_bush_small_diameter = 5.8;
technic_bush_shoulder_height = 1.3; // Should this match technic_pin_multiple_center_lip_thickness ?

technic_pin_connector_outer_diameter = 7.36;
technic_pin_connector_wall_thickness = 1.3;
technic_pin_connector_shoulder_wall_thickness = 0.6;
technic_pin_connector_shoulder_depth = 0.70;

technic_gear_12_tooth_gear_diameter = 12.7;

// Official single-bevel references 6589 (12T) and 32198/87407 (20T)
// place the body-side tooth tips one LDraw unit (0.4 mm) beyond the
// nominal tooth-count radius.  Keep that radial standard named so the
// backing plate and body-side tooth envelope share one source of truth.
technic_ldraw_unit_in_mm = 0.4;
technic_gear_single_tip_radial_offset_lu = 1;
technic_gear_single_tip_radial_offset =
	technic_gear_single_tip_radial_offset_lu * technic_ldraw_unit_in_mm;
technic_gear_12_tooth_base_thickness = 0.4;
technic_gear_12_tooth_diameter = 12.6;
technic_gear_12_tooth_hub_diameter = 6.3;
technic_gear_12_tooth_lip_inner_diameter = 6.9;
technic_gear_12_tooth_lip_outer_diameter = 8.8;
technic_gear_12_tooth_lip_thickness = 0.8;
technic_gear_12_tooth_tooth_height = 2.4;
technic_gear_12_tooth_tooth_thickness = 2.4;
technic_gear_12_tooth_tooth_width_at_bottom = 1.4;
technic_gear_12_tooth_tooth_width_at_top = 0.8;

/** Normal single-form total height derived from the existing axial standards. */
technic_gear_single_reference_height =
	technic_gear_12_tooth_lip_thickness
	+ technic_gear_12_tooth_base_thickness
	+ technic_gear_12_tooth_tooth_thickness;

technic_gear_24_tooth_outer_diameter = 25.4;
technic_gear_24_tooth_bottom_diameter = 21.65;
technic_gear_24_tooth_inner_diameter = 19.6;
technic_gear_24_tooth_tooth_depth = ( technic_gear_24_tooth_outer_diameter - technic_gear_24_tooth_bottom_diameter ) / 2;
technic_gear_pin_hole_outer_diameter = 6.1;
technic_gear_pin_hole_offset_from_center = 5.675;
technic_gear_pin_hole_thickness = 6.1;
technic_gear_tooth_thickness = 3.7;
technic_gear_wheel_thickness = 1.3;
technic_gear_axle_reinforcement_width = 10;
technic_gear_axle_reinforcement_height = 6;
technic_gear_axle_reinforcement_thickness = 7.73;
technic_gear_axle_slot_length = ( ( technic_gear_pin_hole_offset_from_center * 2 ) + technic_hole_diameter ) * .8; // Close enough :)

technic_pin_outer_diameter = 4.85; // Matches LEGO.stud_diameter.
technic_pin_inner_diameter = 3.1; // Matches LEGO.hollow_stud_inner_diameter
technic_pin_collar_diameter = 5.6;
technic_pin_collar_thickness = 0.7; // Matches technic_axle_stop_thickness
technic_pin_lip_diameter = 5;
technic_pin_lip_thickness = 0.75;
technic_pin_slit_width = 0.75;
technic_pin_slit_length = 3.2;
technic_pin_slot_width = 0.75;
technic_pin_slot_length = 5.2;
technic_pin_friction_thickness = 0.15;
technic_pin_friction_width = 0.8;
technic_pin_friction_vertical_length = 5;
technic_pin_multiple_center_width = 7.8;
technic_pin_multiple_center_lip_thickness = 1.2; // Should this match technic_bush_shoulder_height ?
technic_pin_multiple_offset = stud_spacing; // Pin-to-pin spacing must match the 8mm hole grid so multi-pins can seat in beams and bricks.
technic_pin_multiple_center_lip_overhang = 1.35;
technic_pin_tow_ball_total_length = 6.6;
technic_pin_tow_ball_neck_diameter = 3.2; // I believe this "neck" is really just a bar.

technic_elbow_outer_diameter = 7.9; // Matches LEGO.stud_spacing - LEGO.wall_play
technic_elbow_inner_diameter = 5;
technic_elbow_radius = 12;
technic_elbow_straight_length = 4.85; // Matches LEGO.stud_diameter
technic_elbow_overall_width = 16; // Matches ( LEGO.stud_spacing * 1.5 ) + ( technic_elbow_outer_diameter / 2 )
technic_elbow_axle_socket_depth = 2.4; // Matches LEGO.stud_spacing

technic_beam_hole_spacing = 8; // Matches LEGO.stud_spacing
technic_beam_webbing_thickness = 0.8;

technic_tow_ball_diameter = 5.85;

// @todo These values are preliminary.
wheel_face_inset = 2.8;
wheel_wall_thickness = 1;
wheel_center_groove_depth = 6.5;
wheel_center_groove_width = 1.5;
wheel_spoke_connection_depth = .75;
wheel_spoke_edge_width = 0.9;
wheel_spoke_width = 3;

technic_worm_gear_diameter = 14; // @todo Measure IRL. Measurement from https://www.briquespassion.fr/en/boutique/101_technic-gear-vis/8605_lego-technic-gear-worm-screw-short
technic_worm_gear_end_inset = 0.5; // @todo Measure IRL.

// When OpenSCAD does the preview render, if two objects in a difference() end at exactly
// the same plane, it will show a shadowy 0-thickness layer. If instead, one of the difference()
// children extends any amount past that surface, the preview is much cleaner.
EXTENSION_FOR_DIFFERENCE = 1;

/***
 * @function technic_axle();
 * Generate a Technic-compatible axle.
 * @brief Technic, Axle [x]L [with Stud|Stop]
 * The origin is centered at the bottom of the axle.
 *
 * ![An axle compatible with LEGO part #3704.](images/technic_axle.png)
 *
 * **Part Support:**
 * - `part #3704`:  technic_axle( length = 2 );
 * - `part #3705`:  technic_axle( length = 4 );
 * - `part #3706`:  technic_axle( length = 6 );
 * - `part #3707`:  technic_axle( length = 8 );
 * - `part #3708`:  technic_axle( length = 12 );
 * - `part #3737`:  technic_axle( length = 10 );
 * - `part #4519`:  technic_axle( length = 3 );
 * - `part #6587`:  technic_axle( length = 3, stud = true );
 * - `part #15462`: technic_axle( length = 5, stop = true );
 * - `part #23948`: technic_axle( length = 11 );
 * - `part #24316`: technic_axle( length = 3, stop = true );
 * - `part #32062`: technic_axle( length = 2, notch = true );
 * - `part #32073`: technic_axle( length = 5 );
 * - `part #44294`: technic_axle( length = 7 );
 * - `part #50450`: technic_axle( length = 32 );
 * - `part #50451`: technic_axle( length = 16 );
 * - `part #55013`: technic_axle( length = 8, stop = true );
 * - `part #60485`: technic_axle( length = 9 );
 * - `part #87073`: technic_axle( length = 4, stop = true );
 * @param length *float*  The length of the axle, in Technic units.
 * @param stop *bool* Whether there is a stop at the end.
 * @param stud *bool* Whether there is a stud at the end.
 * @param notch *bool* Wether the axle is notched
 */
module technic_axle(
	length = 2, // The length in studs. An axle of length 2 will be the same length as a 2-stud brick.
	stop = false, // Should it have a stop at the end?
	stud = false, // Should it have a stud on the end?
	notch = false
) {
	translate( [ 0, 0, stud ? technic_axle_stud_height : 0 ] ) {
		// A stud always requires a stop, in my opinion.
		let( has_stop = stop || stud ) {
			difference() {
				union() {
					// If there's a stop (and thus an extra segment of length to cut off, we need to move the axle
					// down a segment, since it's returned from technic_axle_spline with the center of its base at the origin.
					translate( [ 0, 0, has_stop ? - ( technic_height_in_mm ) : 0 ] ) {
						// If there's a stop, add an extra bit of length so that we can cut it off flush without seeing the small bit of rounded corners.
						                       technic_axle_spline( length = has_stop ? length + 1 : length );
						rotate( [ 0, 0, 90 ] ) technic_axle_spline( length = has_stop ? length + 1 : length );
					}

					if ( has_stop ) {
						// The stop itself.
						cylinder( d = technic_axle_stop_diameter, h = technic_axle_stop_thickness );
					}
				}

				if ( has_stop ) {
					// Cut off the extra axle below the stop.
					translate([ 0, 0, -( ( technic_height_in_mm ) + EXTENSION_FOR_DIFFERENCE ) ] ) {
						cylinder( d = technic_axle_spline_width + EXTENSION_FOR_DIFFERENCE, h = ( technic_height_in_mm ) + EXTENSION_FOR_DIFFERENCE );
					}
				}

				if ( notch ) {
					for ( i = [ 0.5 : 1 : length ] ) {
						translate( [ 0, 0, ( technic_height_in_mm * i ) - (
technic_axle_notch_height / 2 ) ] ) {
							difference() {
								cylinder( d = technic_axle_stud_outer_diameter + EXTENSION_FOR_DIFFERENCE, h = technic_axle_notch_height );
								translate( [ 0, 0, -EXTENSION_FOR_DIFFERENCE ] ) {
									cylinder( d = technic_axle_notch_diameter, h = technic_axle_notch_height + 2 * EXTENSION_FOR_DIFFERENCE );
								}
							}
						}
					}
				}
			}

			if ( stud ) {
				// Add a stud on the bottom.
				translate( [ 0, 0, -technic_axle_stud_height ] ) {
					technic_hollow_stud();
				}
			}
		}
	}

	/**
	 * Generate one of the axle splines. An axle is made up of two splines, rotated 90º from each other.
	 * Positioned with the bottom center of the axle spline at the origin.
	 */
	module technic_axle_spline( length ) {
		translate( [ 0, 0, technic_height_in_mm * length / 2 ] ) {
			rotate( [ 90, 0, 0 ] ) {
				minkowski() {
					union () {
						translate( [ 0, 0, - ( technic_axle_spline_thickness - ( 2 * technic_axle_spline_corner_radius ) ) / 2 ] ) linear_extrude( technic_axle_spline_thickness - ( 2 * technic_axle_spline_corner_radius ) ) {
							technic_rounded_rectangle(
								width = technic_axle_spline_width - ( 2 * technic_axle_spline_corner_radius ),
								height = ( technic_height_in_mm * length ) - ( 2 * technic_axle_spline_corner_radius ),
								radius = technic_axle_cross_section_radius
							);
						}
					}

					sphere( r = technic_axle_spline_corner_radius );
				}
			}
		}
	}
}

/***
 * @function technic_axle_and_pin_connector();
 * Generate a Technic-compatible axle and pin connector.
 * @brief Technic, Axle and Pin Connector Perpendicular
 * Axle and pin connectors: they connect axles to pins.
 * The origin is centered underneath the first axle hole.
 *
 * ![An axle connector compatible with LEGO part #6538a.](images/technic_axle_and_pin_connector.png)
 *
 * **Part Support:**
 * - `part #32184`: technic_axle_and_pin_connector( length = 3 );
 * @param length *float* The length of the connector, in Technic holes.
 * @param height *float* The height of the connector, in multiples of standard connector heights.
 */
module technic_axle_and_pin_connector( length = 4, height = 1, bush_on_both_ends = true ) {
	// Add the two bushes, one on each end.
	                                                     technic_bush( height = height, stud_cutouts = false );
    
    if (bush_on_both_ends)
	translate( [ ( length - 1 ) * stud_spacing, 0, 0 ] ) technic_bush( height = height, stud_cutouts = false );

	// Add the connector faces.
	difference() {
		union() {
			difference() {
				union() {
					// The bottom face of the connector.
					hull() {
						cylinder( d = technic_pin_outer_diameter + ( technic_pin_multiple_center_lip_overhang * 2 ), h = technic_axle_and_pin_connector_face_thickness );

						translate( [ stud_spacing * ( length - 1 ), 0, 0 ] ) {
							cylinder( d = technic_pin_outer_diameter + ( technic_pin_multiple_center_lip_overhang * 2 ), h = technic_axle_and_pin_connector_face_thickness );
						}
					}

					// The top face of the connector.
					translate( [ 0, 0, ( height * technic_height_in_mm ) - technic_axle_and_pin_connector_face_thickness ] ) { // 1 is the height of the connector, which in LEGO, is always 1, but we could customize.
						hull() {
							cylinder( d = technic_pin_outer_diameter + ( technic_pin_multiple_center_lip_overhang * 2 ), h = technic_axle_and_pin_connector_face_thickness );

							translate( [ stud_spacing * ( length - 1 ), 0, 0 ] ) {
								cylinder( d = technic_pin_outer_diameter + ( technic_pin_multiple_center_lip_overhang * 2 ), h = technic_axle_and_pin_connector_face_thickness );
							}
						}
					}

				}

				// Remove the cylinders from the face that are occupied by the bushes.
				translate( [ 0, 0, -EXTENSION_FOR_DIFFERENCE / 2 ] ) {
					cylinder( d = technic_bush_big_diameter, h = ( height * technic_height_in_mm ) + EXTENSION_FOR_DIFFERENCE );

                    if (bush_on_both_ends) {
                        translate( [ stud_spacing * ( length - 1 ), 0, 0 ] ) {
                            cylinder( d = technic_bush_big_diameter, h = ( height * technic_height_in_mm ) + EXTENSION_FOR_DIFFERENCE);
                        }
                    }
				}
			}

			let ( webbing_thickness = technic_pin_connector_shoulder_wall_thickness ) {
				// The webbing inside the connector, just like it is in a beam.
				translate( [ technic_bush_small_diameter / 2, -(webbing_thickness/2), 0 ] ) cube( [ ( length - 1 ) * stud_spacing - technic_bush_small_diameter, webbing_thickness,( height * technic_height_in_mm ) ] );
			}
		}

        cylinder_substract = bush_on_both_ends ? 2 : 1; 

		for ( i = [ 1 : length - cylinder_substract ] ) {
			for ( j = [ 1 : height ] ) {
				translate( [ i * technic_beam_hole_spacing, 0, ((j-1) * technic_height_in_mm ) + ( technic_height_in_mm / 2 ) ] ) rotate( [ 90, 0, 0 ] ) translate( [ 0, 0, -( technic_height_in_mm / 2 ) ] ) cylinder( d = technic_pin_connector_outer_diameter, h = technic_height_in_mm );
			}
		}
	}

    
	// Add the pin holes along the center, essentially a beam portion.
	// These protrude every so slightly past the outer connector faces, which looks like an error,
	// but is how those pieces actually are in reality.
    pin_hole_substract = bush_on_both_ends ? 2 : 1; 
	for ( i = [ 1 : length - pin_hole_substract ] ) {
		for ( j = [ 1 : height ] ) {
			translate( [ i * technic_beam_hole_spacing, 0, ((j-1) * technic_height_in_mm ) + ( technic_height_in_mm / 2 ) ] ) rotate( [ 90, 0, 0 ] ) translate( [ 0, 0, -( technic_height_in_mm / 2 ) ] ) technic_pin_connector();
		}
	}
}

/***
 * @function technic_axle_connector();
 * Generate a Technic-compatible axle connector.
 * @brief Technic, Axle Connector [x]L [(Ridged)]
 * Origin is centered at the bottom center of the axle connector.
 *
 * ![An axle connector compatible with LEGO part #6538a.](images/technic_axle_connector.png)
 *
 * **Part Support:**
 * - `part #6538a`: technic_axle_connector( length = 2, ridged = true );
 * - `part #6538c`: technic_axle_connector( length = 2 );
 * @param length *int* The length of the axle connector, in Technic units.
 * @param ridged *bool* Whether the connector should have ridges on it.
 */
module technic_axle_connector(
	length = 1,
	ridged = false
) {
	difference() {
		union() {
			cylinder( d = technic_axle_connector_outer_diameter, h = length * technic_height_in_mm );
			if ( length >= 1 && ridged ) {
				for ( i = [ 1 : (length * 2) - 1 ] ) {
					translate( [ 0, 0, i * technic_height_in_mm / 2 - ( technic_axle_connector_ridge_thickness / 2 ) ] ) cylinder( d = technic_axle_connector_outer_diameter + technic_axle_connector_ridge_thickness, h = technic_axle_connector_ridge_thickness );
				}
			}
		}
		technic_axle_hole( height = length );
		if ( ridged ) {
			technic_stud_cutouts( height = length, diameter = stud_diameter - (technic_axle_connector_outer_diameter - technic_axle_connector_ridged_inner_diameter ) / 2 );
		} else {
			technic_stud_cutouts( height = length );
		}
	}
}

/***
 * @function technic_connector_hub();
 * A connector hub. Some sort of round connector with things like axles or pins protruding like spokes.
 * @brief Technic, Axle and Pin Connector
 * The origin is centered underneath the hub.
 * @todo I haven't measured this in real life to confirm dimensions.
 *
 * ![A connector hub compatible with LEGO part #27940, for example.](images/technic_connector_hub.png)
 *
 * **Part Support:**
 * - `part #4450`:  technic_connector_hub( hub_type = "pin", spoke_angles = [ 0, 168.75 ], spoke_lengths = [ 1, 1 ], spoke_heights = [ 1, 1 ], spoke_types = [ "axle connector", "axle connector" ] );
 * - `part #6611`:  technic_connector_hub( hub_type = "pin", spoke_angles = [ 0, 120, 240 ], spoke_lengths = [ 1, 1, 1 ], spoke_heights = [ 1, 1, 1 ], spoke_types = [ "axle connector", "axle connector", "axle connector" ] );
 * - `part #7329`:  technic_connector_hub( hub_type = "pin", spoke_angles = [ 0, 60, 180 ], spoke_lengths = [ 1, 1, 1 ], spoke_heights = [ 1, 1, 1 ], spoke_types = [ "axle connector", "axle connector", "axle connector" ] );
 * - `part #5713`:  technic_connector_hub( spoke_angles = [ 0 ], spoke_lengths = [ 1 ], spoke_heights = [ 1 ], spoke_types = [ "axle" ], spoke_lengths = [ 3 ] );
 * - `part #10197`: technic_connector_hub( spoke_angles = [ 0, 90 ] );
 * - `part #10288`: technic_connector_hub( hub_type = "pin", spoke_angles = [ 0, 60, 120, 180 ], spoke_lengths = [ 1, 1, 1, 1 ], spoke_heights = [ 1, 1, 1, 1 ], spoke_types = [ "axle connector", "axle connector", "axle connector", "axle connector" ] );
 * - `part #15100`: technic_connector_hub( hub_type = "pin", spoke_lengths = [ 1 ], spoke_angles = [ 0 ], spoke_heights = [ 1 ], spoke_types = [ "pin" ]);
 * - `part #15460`: technic_connector_hub( hub_type = "pin", spoke_lengths = [ 1, 1, 1 ], spoke_angles = [ 0, 90, 180 ], spoke_heights = [ 1, 1, 1 ], spoke_types = [ "tow ball", "tow ball", "tow ball" ] );
 * - `part #22961`: technic_connector_hub( spoke_angles = [ 0 ], spoke_lengths = [ 1 ], spoke_heights = [ 1 ], spoke_types = [ "axle" ] );
 * - `part #27940`: technic_connector_hub( spoke_angles = [ 0, 180 ] );
 * - `part #32013`: technic_connector_hub( hub_type = "pin", spoke_angles = [ 0 ], spoke_lengths = [ 1 ], spoke_heights = [ 1 ], spoke_types = [ "axle connector" ] );
 * - `part #32014`: technic_connector_hub( hub_type = "pin", spoke_angles = [ 0, 90 ], spoke_lengths = [ 1, 1 ], spoke_heights = [ 1, 1 ], spoke_types = [ "axle connector", "axle connector" ] );
 * - `part #32015`: technic_connector_hub( hub_type = "pin", spoke_angles = [ 0, 157.5 ], spoke_lengths = [ 1, 1 ], spoke_heights = [ 1, 1 ], spoke_types = [ "axle connector", "axle connector" ] );
 * - `part #32016`: technic_connector_hub( hub_type = "pin", spoke_angles = [ 0, 112.5 ], spoke_lengths = [ 1, 1 ], spoke_heights = [ 1, 1 ], spoke_types = [ "axle connector", "axle connector" ] );
 * - `part #32034`: technic_connector_hub( hub_type = "pin", spoke_angles = [ 0, 180 ], spoke_lengths = [ 1, 1 ], spoke_heights = [ 1, 1 ], spoke_types = [ "axle connector", "axle connector" ] );
 * - `part #32192`: technic_connector_hub( hub_type = "pin", spoke_angles = [ 0, 135 ], spoke_lengths = [ 1, 1 ], spoke_heights = [ 1, 1 ], spoke_types = [ "axle connector", "axle connector" ] );
 * - `part #24122`: technic_connector_hub( hub_type = "axle", spoke_types = [ "bar connector", "bar connector" ] );
 * - `part #57585`: technic_connector_hub( hub_type = "axle", spoke_lengths = [ 1, 1, 1 ], spoke_angles = [ 0, 120, 240 ], spoke_heights = [ 1, 1, 1 ], spoke_types = [ "axle", "axle", "axle" ] );
 * - `part #87082`: technic_connector_hub( hub_type = "pin", spoke_lengths = [ 1, 1 ], spoke_angles = [ 0, 180 ], spoke_heights = [ 1, 1 ], spoke_types = [ "pin", "pin" ]);
 * @param hub_height *int* The height of the hub, in Technic units.
 * @param hub_type *string* What type of hub should it be? Either "axle" or "pin".
 * @param spoke_lengths *float[]* How long should each spoke be?
 * @param spoke_angles *float[]* At what angle should each spoke connect?
 * @param spoke_heights *float[]* How high up on the hub should each spoke be placed?
 * @param spoke_types *string[]* What type of connector should each spoke be? Either "axle", "axle connector", "pin", "bar connector" or "tow ball"
 */
module technic_connector_hub(
	hub_height = 1,
	hub_type = "pin",
	spoke_lengths = [ 1, 1 ],
	spoke_angles = [ 0, 180 ],
	spoke_heights = [ 1, 1 ],
	spoke_types = [ "axle", "axle" ]
) {

	if ( len( spoke_lengths ) == 0 ) {
		echo( "You must provide at least one spoke." );
	} else if ( len( spoke_lengths ) != len( spoke_angles ) ) {
		echo( "The number of spoke lengths must match the number of spoke lengths." );
	} else if ( len( spoke_lengths ) != len( spoke_types ) ) {
		echo( "The number of spoke types must match the number of spoke lengths." );
	} else if ( max( spoke_heights ) > hub_height ) {
		echo( "You cannot have a spoke placed higher than the top of the hub." );
	} else {
		// The central hub.
		if ( hub_type == "pin" ) {
			technic_pin_connector( length = hub_height );
		} else if ( hub_type == "axle" ) {
			difference() {
				cylinder( d = technic_pin_connector_outer_diameter, h = hub_height * technic_height_in_mm );
				technic_axle_hole( height = hub_height );
			}
		}

		// The spokes.
		difference() {
			union() {
				for ( i = [ 0 : len( spoke_angles ) - 1 ] ) {
					rotate( [ 0, 0, spoke_angles[i] ] ) {
						translate( [ 0, 0, (( spoke_heights[i] - 1 ) * technic_height_in_mm ) + ( technic_height_in_mm / 2 ) ] ) {
							rotate( [ 0, 90, 0 ] ) {
								if ( spoke_types[i] == "axle" ) {
									technic_axle( length = spoke_lengths[i] + .5 );
								} else if ( spoke_types[i] == "bar connector" ) {
									linear_extrude( ( technic_height_in_mm * ( spoke_lengths[i] ) ) ) {
										difference() {
											circle( d = technic_bar_connector_outer_diameter );
											circle( d = technic_bar_connector_inner_diameter );
										}
									}
								} else if ( spoke_types[i] == "pin" ) {
									technic_pin_half( length = spoke_lengths[i] + .5, friction = true, squared_pin_holes = false );
								} else if ( spoke_types[i] == "tow ball" ) {
									// technic_tow_ball() builds upward with the ball at its near end; mirror it across the spoke plane so the ball ends up at the far end of the spoke, pointing outward.
									mirror( [ 0, 0, 1 ] ) translate( [ 0, 0, -(spoke_lengths[i] + 1) * technic_pin_tow_ball_total_length ] ) technic_tow_ball( length = spoke_lengths[i] + .5 );
								} else if ( spoke_types[i] == "axle connector" ) {
									technic_axle_connector( length = spoke_lengths[i] + .5);
								}

								if ( spoke_types[i] != "tow ball" && spoke_types[i] != "axle connector" ) {
									cylinder( d = technic_pin_connector_outer_diameter, h = technic_height_in_mm / 2 );
								}
							}
						}
					}
				}
			}

			// Remove anything that has overlapped into the center of the hub.
			translate( [ 0, 0, -EXTENSION_FOR_DIFFERENCE ] ) cylinder( d = technic_pin_connector_outer_diameter, h = hub_height * technic_height_in_mm +  EXTENSION_FOR_DIFFERENCE * 2 );
		}
	}
}

/***
 * @function technic_axle_pin();
 * Generate a Technic-compatible axle pin.
 * @brief Technic, Axle [x]L with Pin [x]L [with Friction Ridges]
 * The origin is centered at the bottom of the axle.
 *
 * ![An axle pin compatible with LEGO part #11214.](images/technic_axle_pin.png)
 *
 * **Part Support:**
 * - `part #11214`: technic_axle_pin( axle_length = 1, pin_length = 2 );
 * @param axle_length *int* In studs, how long the axle component should be.
 * @param pin_length *int* In studs, how long the pin component should be.
 * @param friction *bool* Whether the pin component should have friction ridges on it.
 */
module technic_axle_pin(
	axle_length = 1,
	pin_length = 2,
	friction = true
) {
	translate( [ 0, 0, technic_height_in_mm * axle_length ] ) {
		intersection() {
			// Position it so the axle ends at the origin and the pin is above it.
			rotate( [ 180, 0, 0 ] ) {
				// Include a stop, which is the same as the pin collar.
				technic_axle( length = axle_length, stop = true );
			}

			translate( [ 0, 0, -( ( technic_height_in_mm * axle_length ) + EXTENSION_FOR_DIFFERENCE ) ] ) {
				linear_extrude( ( technic_height_in_mm * axle_length ) + EXTENSION_FOR_DIFFERENCE ) {
					circle( d = technic_axle_spline_width + EXTENSION_FOR_DIFFERENCE );
				}
			}
		};

		// The pin collar is already generated in technic_axle() as the stop, so shift the pin down a bit so it's not doubled.
		// @todo In a real piece like this, is the collar part of the axle length or the pin length?
		translate( [ 0, 0, -technic_pin_collar_thickness ] ) {
			technic_pin_half( length = pin_length, friction = friction );
		}
	}
}

/***
 * @function technic_beam();
 * Generate a Technic-compatible beam.
 * @brief Technic, Liftarm [Thick] [x]x[x] - [x]
 * Origin is below the center of the first hole.
 *
 * ![A beam compatible with LEGO part #32524, for example.](images/technic_beam.png)
 *
 * **Part Support:**
 * - `part #6629`:  technic_beam( length = 9, angles = [ 53.5 ], vertices = [ 6 ], axle_holes = [ 1, 9 ] );
 * - `part #6632`:  technic_beam( length = 3, height = 1/2, axle_holes = [ 1, 3 ] );
 * - `part #7229`:  technic_beam( length = 3, axle_holes = [ 2 ] );
 * - `part #11478`: technic_beam( length = 5, height = 1/2, axle_holes = [1, 5] );
 * - `part #18654`: technic_beam( length = 1 ); // equivalent to a pin connector
 * - `part #32009`: technic_beam( length = 12, vertices = [ 3, 6 ], angles = [ 45, 45 ], axle_holes = [ 1, 12 ] );
 * - `part #32017`: technic_beam( length = 5, height = 1/2 );
 * - `part #32056`: technic_beam( length = 5, height = 1/2, angles = [ 90 ], vertices = [ 3 ], axle_holes = [ 1, 3, 5 ] );
 * - `part #32063`: technic_beam( length = 6, height = 1/2 );
 * - `part #32065`: technic_beam( length = 7, height = 1/2 );
 * - `part #32140`: technic_beam( length = 5, angles = [ 90 ], vertices = [ 4 ], axle_holes = [ 1 ] );
 * - `part #32271`: technic_beam( length = 9, angles = [ 53.5 ], vertices = [ 7 ], axle_holes = [ 1, 9 ] );
 * - `part #32278`: technic_beam( length = 15 );
 * - `part #32316`: technic_beam( length = 5 );
 * - `part #32348`: technic_beam( length = 7, angles = [ 53.5 ], vertices = [ 4 ], axle_holes = [ 1, 7 ] );
 * - `part #32449`: technic_beam( length = 4, height = 1/2, axle_holes = [ 1, 4 ] );
 * - `part #32523`: technic_beam( length = 3 );
 * - `part #32524`: technic_beam( length = 7 );
 * - `part #32525`: technic_beam( length = 11 );
 * - `part #32526`: technic_beam( length = 7, angles = [ 90 ], vertices = [ 1 ] );
 * - `part #40490`: technic_beam( length = 9 );
 * - `part #41239`: technic_beam( length = 13 );
 * - `part #41677`: technic_beam( length = 2, height = 1/2, axle_holes = [ 1, 2 ] );
 * - `part #43857`: technic_beam( length = 2 );
 * - `part #60483`: technic_beam( length = 2, axle_holes = [ 1 ] );
 * - `part #77107`: technic_beam( length = 33, axle_holes = [ 1, 17 ], angles = [ 11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25,11.25 ], vertices = [ 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32 ] ); // This is roughly equivalent but not visually identical.
 * @param length *int* The number of holes in the beam.
 * @param height *float* How tall (in multiples of technic beam thicknesses) should the beam be?
 * @param angles *float[]* The change in angle (clockwise) that will occur at the vertex'th hole.
 * @param vertices *int[]* The number of each hole at which the angle should change.
 * @param axle_holes *int[]* Which holes should be axle holes instead.
 */
module technic_beam( length = 5, height = 1, angles = [], vertices = [], axle_holes = [], depth = 0 ) {
	// When making the second part of an angled beam, remap the axle hole locations for that smaller beam.
	function angled_axle_holes( all_axle_holes, original_vertex ) = [
		if ( len( all_axle_holes ) > 0 ) for ( i = [ 0 : len( all_axle_holes ) - 1 ] ) if ( all_axle_holes[i] > original_vertex ) all_axle_holes[i] - original_vertex + 1
	];

	// Some error cases.
	if ( length < 1 ) {
		echo( "Length must be one or greater: ", length );
	} else if ( len( angles ) != len( vertices ) ) {
		echo( "Number of angles (", len(angles), ") must equal number of vertices (", len( vertices ), ")." );
	} else if ( len( vertices ) >= length ) {
		echo( "The number of vertices", len( vertices ), " cannot be as long as the length." );
	} else if ( len( vertices ) > 0 && max( vertices ) >= length ) {
		echo( "The largest vertex ", max( vertices ), " has to be smaller than the length, ", length );
	} else {
		if ( len( angles ) > 0 ) {
			let(
				// Each section of the beam will be as long as the first vertex in the list.
				this_length = vertices[0],
				this_angle = angles[0],
				// Remove the first vertex from the list.
				new_vertices = [ for ( i = [ 0 : ( len( vertices ) - 1 ) ] ) if ( i > 0 ) vertices[i] - this_length + 1 ],
				// Remove the first angle from the list.
				new_angles = [ for ( i = [ 0 : ( len( angles ) - 1 ) ] ) if ( i > 0 ) angles[i] ],
				// Remove any axle holes we've already added, and shift the axle hole indices down to account for the beam portion we've already output.
				new_axle_holes = len( axle_holes ) > 0 ? [ for ( i = [ 0 : ( len( axle_holes ) - 1 ) ] ) if ( axle_holes[i] > this_length ) axle_holes[i] - this_length + 1 ] : []
			) {
				technic_beam( length = vertices[0], height = height, axle_holes = axle_holes, depth = depth + 1 );

				translate( [ ( this_length - 1 ) * technic_beam_hole_spacing, 0, 0 ] ) {
					rotate( [ 0, 0, this_angle ] ) {
						technic_beam(
							// The length argument should be the total remaining length, plus the additional hole that will be overlayed on the last output hole. It came into the function as length, we output vertices[0] holes, so now we still need to output length - vertices[0] + 1 holes.
							length = length - this_length + 1,
							height = height,
							angles = new_angles,
							vertices = new_vertices,
							axle_holes = new_axle_holes,
							depth = depth + 1
						);
					}
				}
			}
		} else {
			// Generate the pin connectors that make up the inside of the beam.
			for ( i = [ 1 : length ] ) {
				translate( [ technic_beam_hole_spacing * ( i - 1 ), 0, 0 ] ) {
					if ( len( search( i, axle_holes ) ) > 0 ) {
						difference() {
							cylinder( d = technic_pin_connector_outer_diameter, h = height * technic_height_in_mm );

							// @todo This still leaves a tiny bit of extra material in the axle hole at the vertex of an angled beam (if there is one there).
							technic_axle_hole( height = height );
						}
					} else {
						technic_pin_connector( length = height );
					}
				}
			}

			// Add the walls along the edges of the rows of pins.
			translate( [ 0, -( technic_pin_connector_outer_diameter / 2 ), ( technic_height_in_mm * height ) / 2 ] ) {
				difference() {
					translate( [ 0, 0, -technic_beam_webbing_thickness / 2 ] ) {
						cube( [ ( length - 1 ) * technic_beam_hole_spacing, technic_pin_connector_outer_diameter, technic_beam_webbing_thickness ] );
					}

					union () {
						for ( i = [ 1 : length ] ) {
							translate( [ technic_beam_hole_spacing * ( i - 1 ), technic_pin_connector_outer_diameter / 2, 0 ] ) {
								cylinder( d = technic_pin_connector_outer_diameter, h = technic_beam_webbing_thickness + EXTENSION_FOR_DIFFERENCE, center = true );
							}
						}
					}
				}
			}

			// Add the webbing between the pin connector walls.
			// @todo 1/2 thick beams don't have webbing, they're just solid.
			translate( [ 0, - ( technic_pin_connector_outer_diameter / 2 ), 0 ] ) {
				cube( [ ( length - 1 ) * technic_beam_hole_spacing, technic_pin_connector_shoulder_wall_thickness, technic_height_in_mm * height ] );
				translate( [ 0, technic_pin_connector_outer_diameter - technic_pin_connector_shoulder_wall_thickness, 0 ] ) {
					cube( [ ( length - 1 ) * technic_beam_hole_spacing, technic_pin_connector_shoulder_wall_thickness, technic_height_in_mm * height ] );
				}
			}
		}
	}
}

/***
 * @function technic_bush();
 * Generate a Technic-compatible bush.
 * @brief Technic Bush
 * Origin is centered beneath the bush.
 *
 * ![A bush compatible with LEGO part #4265c, for example.](images/technic_bush.png)
 *
 * **Part Support:**
 * - `part #3713`:  technic_bush( height = 1 );
 * - `part #4265c`: technic_bush( height = 1/2 );
 * @param height *int* The height of the bush.
 * @param stud_cutouts *bool* Whether one end should have cutouts in the edge to fit between studs. Only applies to heights greater than 1/2.
 */
module technic_bush( height = 1/2, stud_cutouts = true ) {
	difference() {
		union () {
			difference() {
				// The main inner cylinder that forms the interior walls.
				cylinder( h = height * technic_height_in_mm, d = technic_bush_small_diameter );

				// Bushes at least 1 unit tall have slots in the side (for air? material savings?)
				if ( height >= 1 ) {
					translate ( [ 0,  ( technic_bush_small_diameter + EXTENSION_FOR_DIFFERENCE ) / 2, ( ( height * technic_height_in_mm ) - ( 2 * technic_bush_shoulder_height ) ) / 2 + technic_bush_shoulder_height ]) {
						rotate( [ 90, 0, 0 ] ) {
							linear_extrude( technic_bush_small_diameter + EXTENSION_FOR_DIFFERENCE ) {
								technic_rounded_rectangle( width = technic_pin_slot_width, height = ( height * technic_height_in_mm ) - ( 2 * technic_bush_shoulder_height ) );
							}
						}
					}
				}
			}

			// The bottom shoulder.
			cylinder( h = technic_bush_shoulder_height, d = technic_bush_big_diameter );

			// The top shoulder.
			translate( [ 0, 0, ( height * technic_height_in_mm ) - technic_bush_shoulder_height ] ) {
				difference() {
					cylinder( h = technic_bush_shoulder_height, d = technic_bush_big_diameter );

					if ( height > 1/2 && stud_cutouts ) {
						// Bushes taller than 1/2 units get cutouts in the lip so that they'll fit between studs.
						technic_stud_cutouts( height = technic_bush_shoulder_height );
					}
				}
			}
		}

		// The axle hole. technic_axle_hole() centers its own cutter on the part, so no translation is needed.
		technic_axle_hole( height = height );
	}
}

/***
 * @function technic_elbow();
 * Generate a Technic-compatible 90º elbow.
 * @brief Brick, Round Tube 1 x 1 d. 90 degrees Elbow Macaroni
 * Origin is at the point where the X and Y axes would meet, with each of them centered in the hole at the end of each leg of the elbow.
 *
 * ![A 90º elbow compatible with LEGO part #25214.](images/technic_elbow.png)
 *
 * **Part Support:**
 * - `part #25214`: technic_elbow( length = 2, width = 2 );
 * @param length *int* The number of studs one leg would cover, if laid down on a plate.
 * @param width *int* The number of studs the other leg would cover, if laid down on a plate.
 * @param axle_socket_on_length *bool* Whether there should be an interior socket for accepting an axle on the X axis.
 * @param axle_socket_on_width *bool* Whether there should be an interior socket for accepting an axle on the Y axis.
 */
module technic_elbow(
	length = 2, // The number of studs one leg would cover, if laid down on a plate.
	width = 2, // The number of studs the other leg would cover, if laid down on a plate.
	axle_socket_on_length = true, // Whether there should be an interior socket for accepting an axle on the X axis.
	axle_socket_on_width = true, // Whether there should be an interior socket for accepting an axle on the Y axis.
) {
	// Use the longer dimension as the length and the shorter dimension as the width.
	// This simplifies some decisions we need to make about what goes where.
	//
	// length is along the X axis, width is along the Y axis.
	real_length = max( 2, max( length, width ) );
	real_width = max( 2, min( length, width ) );

	difference() {
		union() {
			// The two straight parts can be placed in their known positions, and then we can calculate
			// the starting and stopping points of the elbow.
			translate( [ ( real_length * stud_spacing ) - technic_elbow_straight_length, 0, 0 ] ) {
				rotate( [ 0, 90, 0 ] ) {
					difference() {
						cylinder( d = technic_elbow_outer_diameter, h = technic_elbow_straight_length );
						translate( [ 0, 0, -EXTENSION_FOR_DIFFERENCE ] ) {
							cylinder( d = technic_elbow_inner_diameter, h = technic_elbow_straight_length + ( 2 * EXTENSION_FOR_DIFFERENCE ) );
						}
					}

					if ( axle_socket_on_length ) {
						// Add the material that will be the ridges for the axle socket.
						cylinder( d = technic_elbow_inner_diameter, h = technic_elbow_straight_length - technic_elbow_axle_socket_depth );
					}
				}
			}

			translate( [ 0, ( real_width * stud_spacing ) - technic_elbow_straight_length, 0 ] ) {
				rotate( [ -90, 0, 0 ] ) {
					difference() {
						cylinder( d = technic_elbow_outer_diameter, h = technic_elbow_straight_length );
						translate( [ 0, 0, -EXTENSION_FOR_DIFFERENCE ] ) cylinder( d = technic_elbow_inner_diameter, h = technic_elbow_straight_length + ( 2 * EXTENSION_FOR_DIFFERENCE ) );
					}

					if ( axle_socket_on_width ) {
						// Add the material that will be the ridges for the axle socket.
						cylinder( d = technic_elbow_inner_diameter, h = technic_elbow_straight_length - technic_elbow_axle_socket_depth );
					}
				}
			}

			// So we need a tube to connect ( real_width * stud_spacing ) - technic_elbow_straight_length on both X and Y.
			translate( [ ( real_width * stud_spacing ) - technic_elbow_straight_length, ( real_width * stud_spacing ) - technic_elbow_straight_length, 0 ] ) {
				rotate( [ 180, 180, 0 ] ) {
					rotate_extrude( angle = 90 ) {
						translate( [ ( real_width * stud_spacing ) - technic_elbow_straight_length, 0, 0 ] ) {
							circle( d = technic_elbow_outer_diameter );
						}
					}
				}
			}

			// And we also need to fill in any gaps if length doesn't match width.
			if ( real_length > real_width ) {
				translate( [ ( real_width * stud_spacing ) - technic_elbow_straight_length, 0, 0 ] ) {
					rotate( [ 0, 90, 0 ] ) {
						cylinder( d = technic_elbow_outer_diameter, h = ( real_length - real_width ) * stud_spacing );
					}
				}
			}
		}

		if ( axle_socket_on_length ) {
			// Subtract the axle socket area along the length.
			translate( [ real_length * stud_spacing, 0, 0 ] ) {
				rotate( [ 0, -90, 0 ] ) {
					technic_axle_hole( height = 1 );
				}
			}
		}

		if ( axle_socket_on_width ) {
			// Subtract the axle socket area along the width.
			translate( [ 0, real_width * stud_spacing, 0 ] ) {
				rotate( [ 90, 0, 0 ] ) {
					technic_axle_hole( height = 1 );
				}
			}
		}
	}
}

/**
 * Return the canonical module-1 pitch diameter for a Technic gear.
 */
function technic_gear_pitch_diameter( teeth ) = teeth;

/**
 * Return the canonical module-1 tip diameter for a Technic gear.
 */
function technic_gear_tip_diameter( teeth ) = teeth + 2;

/**
 * Return the canonical module-1 root diameter for the pinned involute source.
 */
function technic_gear_root_diameter( teeth ) = teeth - 2 * ( 1 + 1 / 6 );

/**
 * Return the classic measured reduced-rim inner diameter relationship.
 * This is not a universal bore, hub, or body diameter.
 */
function technic_gear_classic_rim_inner_diameter( teeth ) =
	technic_gear_root_diameter( teeth )
	- ( technic_gear_24_tooth_bottom_diameter - technic_gear_24_tooth_inner_diameter );

/**
 * Return the normal overall height for the selected gear axial construction.
 * `gear_height = undef` is resolved through this function by technic_gear().
 */
function technic_gear_normal_height( axial_form ) =
	axial_form == "double" ? 7.73 :
	axial_form == "single" ? technic_gear_single_reference_height :
	assert( false, str( "invalid axial_form: ", axial_form ) );

/** Double-axial secondary connector-wall height derived from gear_height. */
function technic_gear_double_secondary_wall_height( gear_height ) =
	gear_height
	- ( technic_gear_axle_reinforcement_thickness - technic_gear_pin_hole_thickness );

/** Axial reduction from the normal full-height reinforcement to normal tooth thickness. */
technic_gear_double_reduced_tooth_axial_offset =
	technic_gear_axle_reinforcement_thickness - technic_gear_tooth_thickness;

/** Reduced-only double normal tooth-section height. */
function technic_gear_double_reduced_tooth_section_height( gear_height ) =
	gear_height - technic_gear_double_reduced_tooth_axial_offset;

/** Topology-dispatched double normal tooth-section height. */
function technic_gear_double_tooth_section_height( gear_height, resolved_body_topology ) =
	resolved_body_topology == "reduced"
		? technic_gear_double_reduced_tooth_section_height( gear_height )
		: resolved_body_topology == "solid" || resolved_body_topology == "hollow"
			? gear_height
			: assert( false, str( "invalid resolved body topology: ", resolved_body_topology ) );

/**
 * WP10 fixed outer clutch-interface reference.
 * The outer engagement geometry is the functional clutch datum; the inner
 * boundary is clearance only and may grow only to accommodate the selected
 * center connector.
 */
technic_gear_clutch_reference_half_height_lu = 10;
technic_gear_clutch_reference_start_z_lu = 2;
// Positive mating part 32187 has a 10-LDU inner bore.  The official
// 81346 mating gear keeps its recess floor at 9 LDU, establishing a
// 1-LDU nominal radial running allowance for the preserved inner core.
technic_gear_clutch_positive_bore_radius_lu = 10;
technic_gear_clutch_nominal_radial_clearance_lu = 1;
technic_gear_clutch_outer_radius_lu = 14.7171;
technic_gear_clutch_key_inner_radius_lu = 13.218;
technic_gear_clutch_key_outer_base_radius_lu = 14.6183;
technic_gear_clutch_key_half_width_lu = 1.5;
technic_gear_clutch_key_narrow_inner_radius_lu = 13.718;
technic_gear_clutch_key_narrow_outer_radius_lu = 14.6842;
technic_gear_clutch_key_tip_half_width_lu = 0.5;
technic_gear_clutch_key_broad_end_z_lu = 8.4;
technic_gear_clutch_key_narrow_z_lu = 9.4;
technic_gear_clutch_key_narrow_end_z_lu = 9.7865;
technic_gear_clutch_profile_slice_thickness = EXTENSION_FOR_DIFFERENCE / 100;

function technic_gear_clutch_face_count( secondary_feature ) =
	secondary_feature == "clutch_single" ? 1 :
	secondary_feature == "clutch_dual" ? 2 : 0;

function technic_gear_clutch_interface_depth( gear_height ) =
	gear_height
	* ( technic_gear_clutch_reference_half_height_lu - technic_gear_clutch_reference_start_z_lu )
	/ ( 2 * technic_gear_clutch_reference_half_height_lu );

function technic_gear_clutch_interface_radius( teeth, resolved_body_topology ) =
	technic_gear_clutch_outer_radius_lu * technic_ldraw_unit_in_mm;

/**
 * Circular center-side clearance only.  It does not define the clutch profile.
 * The pin wall is slightly larger than the 9-LDU reference floor, so pin
 * centers derive the larger radius instead of changing the outer keys.
 */
function technic_gear_clutch_positive_bore_radius() =
	technic_gear_clutch_positive_bore_radius_lu * technic_ldraw_unit_in_mm;

function technic_gear_clutch_reference_inner_core_radius() =
	( technic_gear_clutch_positive_bore_radius_lu - technic_gear_clutch_nominal_radial_clearance_lu )
	* technic_ldraw_unit_in_mm;

function technic_gear_clutch_center_outer_radius( center ) =
	center == "pin"
		? technic_pin_connector_outer_diameter / 2
		: ( technic_axle_spline_width + 2 * technic_pin_connector_shoulder_wall_thickness ) / 2;

function technic_gear_clutch_positive_bore_gap( center ) =
	technic_gear_clutch_positive_bore_radius() - technic_gear_clutch_center_outer_radius( center );

function technic_gear_clutch_inner_clearance_radius( center ) =
	max(
		technic_gear_clutch_reference_inner_core_radius(),
		technic_gear_clutch_center_outer_radius( center )
	);

/**
 * Deep/start-plane profile of one modern outer clutch key.
 * The official 18946/81346 interface is a 3-LDU-wide rectangular key at the
 * 2-LDU recess start.  Its faceward narrowing is generated separately in Z;
 * do not encode that axial taper by distorting this XY profile.
 */
function technic_gear_clutch_profile_points( teeth, gear_height, resolved_body_topology ) =
	let(
		key_inner_radius = technic_gear_clutch_key_inner_radius_lu * technic_ldraw_unit_in_mm,
		key_outer_radius = technic_gear_clutch_key_outer_base_radius_lu * technic_ldraw_unit_in_mm,
		key_half_width = technic_gear_clutch_key_half_width_lu * technic_ldraw_unit_in_mm
	)
	[
		[ key_inner_radius, -key_half_width ],
		[ key_outer_radius, -key_half_width ],
		[ key_outer_radius, key_half_width ],
		[ key_inner_radius, key_half_width ]
	];

/** Faceward narrowed section of the same fixed outer key. */
function technic_gear_clutch_narrow_profile_points() =
	let(
		inner_radius = technic_gear_clutch_key_narrow_inner_radius_lu * technic_ldraw_unit_in_mm,
		outer_radius = technic_gear_clutch_key_narrow_outer_radius_lu * technic_ldraw_unit_in_mm,
		half_width = technic_gear_clutch_key_tip_half_width_lu * technic_ldraw_unit_in_mm
	)
	[
		[ inner_radius, -half_width ],
		[ outer_radius, -half_width ],
		[ outer_radius, half_width ],
		[ inner_radius, half_width ]
	];

/** Map an official face-side axial LDU station into the local cutout Z axis. */
function technic_gear_clutch_local_z( depth, axial_lu ) =
	-depth / 2
	+ depth
		* ( axial_lu - technic_gear_clutch_reference_start_z_lu )
		/ ( technic_gear_clutch_reference_half_height_lu - technic_gear_clutch_reference_start_z_lu );

/** Center positions of the identical face cutouts. */
function technic_gear_clutch_face_z_positions( secondary_feature, gear_height, depth ) =
	secondary_feature == "clutch_single"
		? [ ( gear_height - depth ) / 2 ]
		: secondary_feature == "clutch_dual"
			? [ -( gear_height - depth ) / 2, ( gear_height - depth ) / 2 ]
			: [];

/**
 * The current reusable clutch face requires full-height solid material.
 * Hollow/reduced bodies need separate face-material/body adapters, not a
 * distorted clutch.  Radial fit is derived from the fixed clutch envelope.
 */
function technic_gear_clutch_interface_fits( teeth, center, resolved_body_topology ) =
	let(
		interface_radius = technic_gear_clutch_interface_radius( teeth, resolved_body_topology ),
		root_radius = technic_gear_double_rim_outer_diameter( teeth ) / 2,
		inner_clearance = technic_gear_clutch_inner_clearance_radius( center ),
		positive_bore_gap = technic_gear_clutch_positive_bore_gap( center ),
		key_inner_radius = technic_gear_clutch_key_inner_radius_lu * technic_ldraw_unit_in_mm,
		minimum_wall = technic_pin_connector_shoulder_wall_thickness
	)
	resolved_body_topology == "solid"
	&& root_radius - interface_radius >= minimum_wall
	&& key_inner_radius - inner_clearance >= minimum_wall
	&& positive_bore_gap > 0;

/**
 * WP09 reinforced/stepped-tooth reference geometry from LDraw tooth8a.dat.
 *
 * The official primitive uses a 20 LDU axial reference envelope.  Its full
 * normal crown occupies -4.75..+4.75 LDU, while the two recessed shoulder
 * sections occupy -9.8..-4.75 and +4.75..+9.8 LDU.  Their visible radial
 * crown is inset by 5.43 - 2.10 = 3.33 LDU from the full center crown.
 *
 * Axial dimensions therefore scale with the resolved tooth envelope, while
 * the radial inset remains a fixed module-1 reference dimension.  These are
 * source-derived constants, not an 8T selector branch.
 */
technic_gear_stepped_reference_total_axial_units = 20;
technic_gear_stepped_reference_center_axial_units = 9.5;
technic_gear_stepped_reference_outer_axial_units = 5.05;
technic_gear_stepped_reference_outer_center_units = 7.275;
technic_gear_stepped_reference_crown_radial_inset = ( 5.43 - 2.10 ) * 0.4;

/** Accessors for one [pitch_diameter, height, z] tooth-section record. */
function technic_gear_tooth_section_pitch_diameter( record ) = record[ 0 ];
function technic_gear_tooth_section_height( record ) = record[ 1 ];
function technic_gear_tooth_section_z( record ) = record[ 2 ];

/**
 * Pitch diameter for the recessed stepped shoulder sections.
 *
 * technic_gear_normal_tooth_solid() derives module from pitch diameter /
 * tooth count.  Convert the source-derived target tip diameter back to the
 * pitch diameter that gives that tip with the same tooth count.
 */
function technic_gear_stepped_outer_pitch_diameter( teeth ) =
	let(
		target_tip_diameter = technic_gear_tip_diameter( teeth )
			- 2 * technic_gear_stepped_reference_crown_radial_inset
	)
	target_tip_diameter * teeth / ( teeth + 2 );

/** Resolved tooth-envelope height used by section records. */
function technic_gear_tooth_section_envelope_height( gear_height, resolved_body_topology ) =
	resolved_body_topology == "single"
		? technic_gear_single_tooth_height( gear_height )
		: technic_gear_double_tooth_section_height( gear_height, resolved_body_topology );

/**
 * Create every normal/stepped tooth-section record in one calculation path.
 * Callers must consume these records rather than constructing section arrays.
 */
function technic_gear_tooth_section_records(
	teeth,
	gear_height,
	tooth_sections,
	resolved_body_topology
) =
	let(
		tooth_height = technic_gear_tooth_section_envelope_height( gear_height, resolved_body_topology ),
		center_height = tooth_height
			* technic_gear_stepped_reference_center_axial_units
			/ technic_gear_stepped_reference_total_axial_units,
		outer_height = tooth_height
			* technic_gear_stepped_reference_outer_axial_units
			/ technic_gear_stepped_reference_total_axial_units,
		outer_z = tooth_height
			* technic_gear_stepped_reference_outer_center_units
			/ technic_gear_stepped_reference_total_axial_units,
		outer_pitch_diameter = technic_gear_stepped_outer_pitch_diameter( teeth )
	)
	tooth_sections == "normal"
		? [ [ technic_gear_pitch_diameter( teeth ), tooth_height, 0 ] ]
		: tooth_sections == "stepped"
			? [
				[ outer_pitch_diameter, outer_height, -outer_z ],
				[ technic_gear_pitch_diameter( teeth ), center_height, 0 ],
				[ outer_pitch_diameter, outer_height, outer_z ]
			]
			: assert( false, str( "invalid tooth_sections: ", tooth_sections ) );

/** Double-axial reduced continuous-body height derived from gear_height. */
technic_gear_double_reduced_body_axial_offset =
	technic_gear_axle_reinforcement_thickness - technic_gear_wheel_thickness;

function technic_gear_double_reduced_body_height( gear_height ) =
	gear_height - technic_gear_double_reduced_body_axial_offset;

/**
 * Reference axial proportions for normal double-bevel teeth.
 * The LDraw tooth primitive spans -10..+10 axially and preserves its
 * straight central tooth land from -3..+3. Keep these as source-derived
 * proportions rather than independent millimetre tuning knobs.
 */
technic_gear_double_bevel_reference_total_axial_units = 20;
technic_gear_double_bevel_reference_uncut_axial_units = 6;

/** Straight central tooth-land height retained by a double bevel. */
function technic_gear_double_bevel_uncut_height( tooth_height ) =
	tooth_height
	* technic_gear_double_bevel_reference_uncut_axial_units
	/ technic_gear_double_bevel_reference_total_axial_units;

/** Axial depth owned by each exposed-face cutter of a double bevel. */
function technic_gear_double_bevel_face_depth( tooth_height ) =
	( tooth_height - technic_gear_double_bevel_uncut_height( tooth_height ) ) / 2;

/**
 * Fixed local reference geometry for the positive radial double-bevel tooth.
 * Values are expressed from the agreed LEGO/LDraw reference stations and are
 * intentionally independent of tooth count and requested gear height.
 */
technic_gear_double_bevel_center_half_height = 3 * 0.4;       // 1.20 mm
technic_gear_double_bevel_reference_face_z   = 10 * 0.4;      // 4.00 mm
technic_gear_double_bevel_arc_radius         = 8.125 * 0.4;   // 3.25 mm
technic_gear_double_bevel_arc_segments       = 8;
/** R4 crown sampling: 14 vs 16 divisions (~11% fewer involute vertices). */
technic_gear_double_bevel_involute_steps      = 14;

/** Fixed axial run of one radial crown continuation. */
function technic_gear_double_bevel_arc_run() =
	technic_gear_double_bevel_reference_face_z
	- technic_gear_double_bevel_center_half_height;

/** Tip diameter produced by the common involute source at a derived pitch. */
function technic_gear_tooth_tip_diameter_for_pitch( teeth, pitch_diameter ) =
	pitch_diameter * ( teeth + 2 ) / teeth;

/**
 * Tip radius on the shared fixed tangent circle at axial distance dz from
 * handover. The caller supplies the pitch diameter owning the un-beveled
 * tooth envelope, so the same radial law serves single and double forms.
 */
function technic_gear_radial_bevel_tip_radius(
	teeth, pitch_diameter, dz, arc_radius = technic_gear_double_bevel_arc_radius
) =
	let(
		tip_radius = technic_gear_tooth_tip_diameter_for_pitch( teeth, pitch_diameter ) / 2,
		circle_center_radius = tip_radius - arc_radius
	)
	circle_center_radius
	+ sqrt( max( 0, arc_radius * arc_radius - dz * dz ) );

/** Radial profile scale corresponding to the shared fixed-circle tip radius. */
function technic_gear_radial_bevel_scale(
	teeth, pitch_diameter, dz, arc_radius = technic_gear_double_bevel_arc_radius
) =
	technic_gear_radial_bevel_tip_radius( teeth, pitch_diameter, dz, arc_radius )
	/ ( technic_gear_tooth_tip_diameter_for_pitch( teeth, pitch_diameter ) / 2 );

/** Accepted double-bevel wrappers retain the canonical module-1 envelope. */
function technic_gear_double_bevel_arc_tip_radius( teeth, dz ) =
	technic_gear_radial_bevel_tip_radius( teeth, technic_gear_pitch_diameter( teeth ), dz );

function technic_gear_double_bevel_arc_scale( teeth, dz ) =
	technic_gear_radial_bevel_scale( teeth, technic_gear_pitch_diameter( teeth ), dz );

/** Single-bevel tangent-circle radius scaled from the accepted normal form. */
function technic_gear_single_bevel_arc_radius( tooth_height ) =
	technic_gear_double_bevel_arc_radius
	* tooth_height
	/ technic_gear_12_tooth_tooth_thickness;

/** Single-axial lip height derived proportionally from gear_height. */
function technic_gear_single_lip_height( gear_height ) =
	gear_height * technic_gear_12_tooth_lip_thickness / technic_gear_single_reference_height;

/** Single-axial base height derived proportionally from gear_height. */
function technic_gear_single_base_height( gear_height ) =
	gear_height * technic_gear_12_tooth_base_thickness / technic_gear_single_reference_height;

/** Single-axial tooth/body-hub height derived proportionally from gear_height. */
function technic_gear_single_tooth_height( gear_height ) =
	gear_height * technic_gear_12_tooth_tooth_thickness / technic_gear_single_reference_height;

/** Return whether all single-form axial dimensions remain positive. */
function technic_gear_single_axial_dimensions_valid( gear_height ) =
	is_num( gear_height ) && gear_height > 0
	&& technic_gear_single_lip_height( gear_height ) > 0
	&& technic_gear_single_base_height( gear_height ) > 0
	&& technic_gear_single_tooth_height( gear_height ) > 0;

/**
 * Return whether all owned axial dimensions are positive before geometry work.
 */
function technic_gear_axial_dimensions_valid( axial_form, gear_height, resolved_body_topology = undef ) =
	is_num( gear_height ) && gear_height > 0
	&& (
		axial_form == "double"
			? technic_gear_double_secondary_wall_height( gear_height ) > 0
				&& (
					resolved_body_topology == "reduced"
						? technic_gear_double_reduced_tooth_section_height( gear_height ) > 0
							&& technic_gear_double_reduced_body_height( gear_height ) > 0
						: resolved_body_topology == "solid" || resolved_body_topology == "hollow"
							? true
							: false
				)
			: axial_form == "single"
				? technic_gear_single_axial_dimensions_valid( gear_height )
				: false
	);

function _technic_gear_value_in( value, values ) = len( [ for ( candidate = values ) if ( value == candidate ) candidate ] ) > 0;

module _technic_gear_support_record( feature, requested, effective, state, reason, debug = false ) {
	if ( debug || state == "partial" || state == "missing" || state == "fallback" ) {
		echo( str(
			"TECHNIC_GEAR_SUPPORT|feature=", feature,
			"|requested=", requested,
			"|effective=", effective,
			"|state=", state,
			"|reason=", reason
		) );
	}
}

/**
 * Canonical local positive support for one secondary axle station (P1).
 *
 * The four cylindrical scallops are intrinsic to the local support. They are
 * present even when neighboring pin-wall geometry is not instantiated.
 */
module technic_gear_axle_support( height ) {
	cutout_offset = technic_gear_pin_hole_offset_from_center / sqrt( 2 );

	difference() {
		cube(
			size = [
				technic_gear_axle_reinforcement_width,
				technic_gear_axle_reinforcement_height,
				height
			],
			center = true
		);

		for ( x = [ -cutout_offset, cutout_offset ] ) {
			for ( y = [ -cutout_offset, cutout_offset ] ) {
				translate( [ x, y, 0 ] ) {
					cylinder(
						d = technic_gear_pin_hole_outer_diameter - ( EXTENSION_FOR_DIFFERENCE / 4 ),
						h = height + EXTENSION_FOR_DIFFERENCE,
						center = true
					);
				}
			}
		}
	}
}

/**
 * Negative axle-entry relief paired with P1.
 *
 * The relief follows the 10 mm long support axis. The default 9.4 mm length
 * retains 0.3 mm positive material at each long-side end.
 */
module technic_gear_axle_entry_relief_cutout(
	height,
	length = technic_gear_axle_reinforcement_width - technic_pin_connector_shoulder_wall_thickness
) {
	relief_thickness = ( technic_axle_spline_thickness * technic_axle_interference_fit_ratio ) / 3;

	linear_extrude( height = height + EXTENSION_FOR_DIFFERENCE, center = true ) {
		technic_rounded_rectangle(
			width = length,
			height = relief_thickness,
			radius = relief_thickness / 2
		);
	}
}

/**
 * Geometry-only fixed-phase axle hole used by double-form axle stations.
 *
 * The native Technic axle-hole phase is authoritative. Placement/support
 * orientation must never rotate this helper.
 */
module technic_gear_axle_hole_fixed( height ) {
	technic_axle_hole( height = height );
}

/**
 * WP06C secondary-station selector constants.
 *
 * The placement grid is the union of two 8 mm phases. WP06A selected the
 * offset phase for dense pin walls and derives centered-phase axle candidates
 * from complete four-pin cells.
 */
technic_gear_secondary_lattice_pitch = 8;
technic_gear_secondary_lattice_half_pitch = technic_gear_secondary_lattice_pitch / 2;
technic_gear_secondary_bridge_overlap = 0.4;

/** Usable classic body radius for secondary station envelopes. */
function technic_gear_secondary_usable_radius( teeth ) =
	technic_gear_classic_rim_inner_diameter( teeth ) / 2;

/** True when one complete secondary pin wall fits at the final coordinate. */
function technic_gear_secondary_pin_station_fits( teeth, point ) =
	sqrt( point[0] * point[0] + point[1] * point[1] )
		+ ( technic_gear_pin_hole_outer_diameter / 2 )
		<= technic_gear_secondary_usable_radius( teeth );

/** Generate the legal dense offset-phase pin field accepted by WP06A. */
function technic_gear_secondary_pin_stations( teeth ) =
	let(
		half = technic_gear_secondary_lattice_half_pitch,
		pitch = technic_gear_secondary_lattice_pitch,
		usable = technic_gear_secondary_usable_radius( teeth ),
		limit = floor( ( usable - ( technic_gear_pin_hole_outer_diameter / 2 ) - half ) / pitch ) + 1
	)
	[
		for ( i = [ -limit : limit ] )
			for ( j = [ -limit : limit ] )
				let( point = [ half + pitch * i, half + pitch * j ] )
				if ( technic_gear_secondary_pin_station_fits( teeth, point ) )
					point
	];

function _technic_gear_point_in_list( point, points ) =
	len( [ for ( candidate = points ) if ( candidate[0] == point[0] && candidate[1] == point[1] ) candidate ] ) > 0;

/**
 * A centered-phase axle candidate exists exactly when its four surrounding
 * offset-phase pin stations exist. The singular center remains WP04-owned.
 */
function technic_gear_secondary_axle_cell_complete( center, pin_stations ) =
	center != [ 0, 0 ]
	&& _technic_gear_point_in_list( [ center[0] - 4, center[1] - 4 ], pin_stations )
	&& _technic_gear_point_in_list( [ center[0] - 4, center[1] + 4 ], pin_stations )
	&& _technic_gear_point_in_list( [ center[0] + 4, center[1] - 4 ], pin_stations )
	&& _technic_gear_point_in_list( [ center[0] + 4, center[1] + 4 ], pin_stations );

/** Select every complete non-central four-pin cell, as approved in WP06A. */
function technic_gear_secondary_axle_stations( teeth ) =
	let(
		pins = technic_gear_secondary_pin_stations( teeth ),
		pitch = technic_gear_secondary_lattice_pitch,
		usable = technic_gear_secondary_usable_radius( teeth ),
		limit = floor( usable / pitch )
	)
	[
		for ( i = [ -limit : limit ] )
			for ( j = [ -limit : limit ] )
				let( center = [ pitch * i, pitch * j ] )
				if ( technic_gear_secondary_axle_cell_complete( center, pins ) )
					center
	];

/**
 * Grid-aligned P1 support orientation nearest to the local tangent.
 * Only 0/90 are valid by the accepted WP06B contract.
 */
function technic_gear_secondary_axle_support_orientation( point ) =
	let(
		x = point[0],
		y = point[1],
		radial_angle = atan2( y, x ),
		tangent = ( radial_angle + 90 + 360 ) % 180,
		d0 = min( abs( tangent ), abs( tangent - 180 ) ),
		d90 = abs( tangent - 90 )
	)
	d0 < d90 ? 0 :
	d90 < d0 ? 90 :
	abs( x ) >= abs( y ) ? 0 : 90;

/** Return the four pin stations that structurally define one axle cell. */
function technic_gear_secondary_axle_cell_pins( center ) = [
	[ center[0] - 4, center[1] - 4 ],
	[ center[0] - 4, center[1] + 4 ],
	[ center[0] + 4, center[1] - 4 ],
	[ center[0] + 4, center[1] + 4 ]
];

/**
 * Emit the exact WP06C selector manifest without instantiating gear geometry.
 */
module technic_gear_secondary_allocation_manifest( teeth ) {
	pins = technic_gear_secondary_pin_stations( teeth );
	axles = technic_gear_secondary_axle_stations( teeth );

	echo( str( "TECHNIC_GEAR_SECONDARY|teeth=", teeth, "|pin_count=", len( pins ), "|axle_count=", len( axles ) ) );
	echo( "TECHNIC_GEAR_SECONDARY_PINS", pins );
	echo( "TECHNIC_GEAR_SECONDARY_AXLES", axles );
	echo( "TECHNIC_GEAR_SECONDARY_SUPPORTS", [ for ( point = axles ) [ point, technic_gear_secondary_axle_support_orientation( point ) ] ] );
	echo( "TECHNIC_GEAR_SECONDARY_CELLS", [ for ( point = axles ) [ point, technic_gear_secondary_axle_cell_pins( point ) ] ] );

	assert( !_technic_gear_point_in_list( [ 0, 0 ], axles ), "secondary axle allocation must exclude center" );
	assert(
		len( [ for ( point = axles ) if ( _technic_gear_point_in_list( point, pins ) ) point ] ) == 0,
		"secondary pin and axle sets must be disjoint"
	);
	assert(
		len( [ for ( point = axles ) if ( !technic_gear_secondary_axle_cell_complete( point, pins ) ) point ] ) == 0,
		"every selected secondary axle must own a complete four-pin cell"
	);
	assert(
		len( [ for ( point = axles ) let( orientation = technic_gear_secondary_axle_support_orientation( point ) ) if ( orientation != 0 && orientation != 90 ) point ] ) == 0,
		"secondary axle support orientation must be grid aligned"
	);
}

/** WP06D-R2 approved positive minimum wall/clearance. */
technic_gear_axle_station_minimum_clearance = technic_pin_connector_shoulder_wall_thickness;

/** Half extents of an oriented local rectangle. */
function technic_gear_oriented_half_extents( width, height, orientation ) =
	orientation == 0 ? [ width / 2, height / 2 ] :
	orientation == 90 ? [ height / 2, width / 2 ] :
	assert( false, str( "axle station orientation must be 0 or 90 degrees: ", orientation ) );

/** Maximum radial extent of a complete oriented rectangular footprint. */
function technic_gear_oriented_rectangle_outer_radius( point, width, height, orientation ) =
	let( half = technic_gear_oriented_half_extents( width, height, orientation ) )
	max( [
		for ( sx = [ -1, 1 ] )
			for ( sy = [ -1, 1 ] )
				sqrt(
					( point[0] + sx * half[0] ) * ( point[0] + sx * half[0] )
					+ ( point[1] + sy * half[1] ) * ( point[1] + sy * half[1] )
				)
	] );

/** Root-side structural envelope available to full-height local support. */
function technic_gear_axle_structural_radius( teeth ) = technic_gear_root_diameter( teeth ) / 2;

/** Inner boundary of the full-height tooth-support ring. */
function technic_gear_tooth_support_ring_inner_radius( teeth ) = technic_gear_classic_rim_inner_diameter( teeth ) / 2;

/** Complete P1 footprint fit check, independent of station role/tooth special cases. */
function technic_gear_axle_support_fits( teeth, point, orientation, minimum_clearance = technic_gear_axle_station_minimum_clearance ) =
	technic_gear_axle_structural_radius( teeth )
		- technic_gear_oriented_rectangle_outer_radius(
			point,
			technic_gear_axle_reinforcement_width,
			technic_gear_axle_reinforcement_height,
			orientation
		) >= minimum_clearance;

/**
 * Resolve the local double-body topology used by axle applicability.
 * Compact bodies whose complete center P1 footprint cannot exist are treated
 * as already-solid local material; this derives the D08 policy geometrically.
 */
function technic_gear_double_body_topology( teeth, body_mode ) =
	body_mode == "hollow" ? "hollow" :
	body_mode == "reduced"
		&& technic_gear_axle_support_fits( teeth, [ 0, 0 ], 0 )
		? "reduced" : "solid";

/** WP13E experimental reduced RING pattern from official LDraw 4019.dat.
 *
 * This is deliberately a reduced-body pattern, not a hollow graph.  The
 * existing reduced axial stack owns the thin web and tooth-support rim; four
 * source-positioned circular openings/collars reshape that web.  The normal
 * reduced center axle support and relief remain in the composition path and
 * are carved by these openings, allowing the 4019 center lands to emerge from
 * shared reduced infrastructure instead of a second bespoke hub.
 */
technic_gear_reduced_ring_reference_root_radius_ldu = 17;
technic_gear_reduced_ring_reference_rim_inner_radius_ldu = 7 * 2.13;
technic_gear_reduced_ring_cell_center_radius_ldu = 10;
technic_gear_reduced_ring_cell_inner_radius_ldu = 2.83;
technic_gear_reduced_ring_cell_outer_radius_ldu = 4.24;
// 4019 open-side axle support from the official source coordinates.
// The full-height center envelope has axis flats at 8 LDU and diagonal
// transitions at 4 LDU, putting the four tall support lands in the diagonal
// quadrants.  This is the same native axle phase as the classic reduced P1;
// unlike I3, no cardinal-point diamond is introduced.
technic_gear_reduced_ring_center_outer_axis_ldu = 8;
technic_gear_reduced_ring_center_outer_chamfer_ldu = 4;
// The open-side relief extends to 6 LDU on each axle axis.  Its width is
// matched to the fitted axle spline so the opening continues the native axle
// arms instead of creating a second rotated hole phase.
technic_gear_reduced_ring_center_relief_axis_ldu = 6;
// Official 4019 web faces sit at +/-2 LDU inside a +/-10 LDU center envelope.
technic_gear_reduced_ring_reference_half_height_ldu = 10;
technic_gear_reduced_ring_reference_web_half_height_ldu = 2;

technic_gear_reduced_ring_tooth_support_ring_width =
    ( technic_gear_reduced_ring_reference_root_radius_ldu
      - technic_gear_reduced_ring_reference_rim_inner_radius_ldu ) * technic_ldraw_unit_in_mm;

function technic_gear_reduced_ring_cell_center_radius() =
    technic_gear_reduced_ring_cell_center_radius_ldu * technic_ldraw_unit_in_mm;
function technic_gear_reduced_ring_cell_inner_radius() =
    technic_gear_reduced_ring_cell_inner_radius_ldu * technic_ldraw_unit_in_mm;
function technic_gear_reduced_ring_cell_outer_radius() =
    technic_gear_reduced_ring_cell_outer_radius_ldu * technic_ldraw_unit_in_mm;
function technic_gear_reduced_ring_cell_wall_thickness() =
    technic_gear_reduced_ring_cell_outer_radius() - technic_gear_reduced_ring_cell_inner_radius();
/** Circumferential support rib uses the source cell wall thickness. */
function technic_gear_reduced_ring_wave_ring_width() =
    technic_gear_reduced_ring_cell_wall_thickness();
function technic_gear_reduced_ring_rim_inner_diameter( teeth ) =
    max( 0, technic_gear_root_diameter( teeth ) - ( 2 * technic_gear_reduced_ring_tooth_support_ring_width ) );
function technic_gear_reduced_ring_web_height( gear_height ) =
    gear_height
    * ( 2 * technic_gear_reduced_ring_reference_web_half_height_ldu )
    / ( 2 * technic_gear_reduced_ring_reference_half_height_ldu );

function technic_gear_reduced_ring_reference_rim_gap() =
    technic_gear_reduced_ring_rim_inner_diameter( 16 ) / 2
    - technic_gear_reduced_ring_cell_center_radius()
    - technic_gear_reduced_ring_cell_outer_radius();
function technic_gear_reduced_ring_outer_shell_radius_from_inner_diameter( inner_diameter ) =
    max(
        technic_gear_reduced_ring_cell_center_radius(),
        inner_diameter / 2
        - technic_gear_reduced_ring_cell_outer_radius()
        - technic_gear_reduced_ring_reference_rim_gap()
    );
function technic_gear_reduced_ring_max_shell_pitch() =
    ( 2 * technic_gear_reduced_ring_cell_outer_radius() )
    + technic_gear_reduced_ring_reference_rim_gap();
function technic_gear_reduced_ring_shell_count_from_inner_diameter( inner_diameter ) =
    let(
        first_shell_radius = technic_gear_reduced_ring_cell_center_radius(),
        outer_shell_radius = technic_gear_reduced_ring_outer_shell_radius_from_inner_diameter( inner_diameter )
    )
    outer_shell_radius <= first_shell_radius + 0.0001
        ? 1
        : 1 + ceil(
            ( outer_shell_radius - first_shell_radius )
            / technic_gear_reduced_ring_max_shell_pitch()
        );
function technic_gear_reduced_ring_shell_radius_from_inner_diameter( inner_diameter, index ) =
    let(
        shell_count = technic_gear_reduced_ring_shell_count_from_inner_diameter( inner_diameter ),
        first_shell_radius = technic_gear_reduced_ring_cell_center_radius(),
        outer_shell_radius = technic_gear_reduced_ring_outer_shell_radius_from_inner_diameter( inner_diameter )
    )
    shell_count <= 1
        ? first_shell_radius
        : first_shell_radius + ( index * ( outer_shell_radius - first_shell_radius ) / ( shell_count - 1 ) );
function technic_gear_reduced_ring_shell_radii_from_inner_diameter( inner_diameter ) =
    [
        for ( index = [ 0 : technic_gear_reduced_ring_shell_count_from_inner_diameter( inner_diameter ) - 1 ] )
            technic_gear_reduced_ring_shell_radius_from_inner_diameter( inner_diameter, index )
    ];
function technic_gear_reduced_ring_shell_cell_count( shell_radius ) =
    max(
        4,
        4 * ceil( shell_radius / technic_gear_reduced_ring_cell_center_radius() )
    );
// Quarter-step twist from the source 4-cell shell.  The structural annular
// ribs/waves carry load, so hole shells may rotate without creating a spoke
// dependency.  22.5 deg is one quarter of the 4019 shell's 90 deg pitch.
function technic_gear_reduced_ring_shell_phase( shell_index ) = 22.5 * shell_index;
function technic_gear_reduced_ring_shell_points( shell_radius, cell_count, phase = 0 ) =
    [
        for ( index = [ 0 : cell_count - 1 ] )
            [
                shell_radius * cos( phase + 360 * index / cell_count ),
                shell_radius * sin( phase + 360 * index / cell_count )
            ]
    ];


/** WP13E recursive semicircle scale resolver.
 *
 * The accepted 4019 four-circle core supplies four cardinal anchor points at
 * radius a0 = 4 mm.  One generation connects every adjacent anchor pair with
 * the OUTWARD semicircle whose diameter is exactly that pair.  Geometry then
 * closes analytically:
 *
 *   semicircle radius = a / sqrt(2)
 *   semicircle centre radius = a / sqrt(2)
 *   next anchor radius = a * sqrt(2)
 *   next anchor phase = phase + 45 deg
 *
 * Thus each generation is derived only from the previous four anchors.  No
 * arbitrary circle offsets, spoke grid, or concentric-ring stack is needed.
 */
function technic_gear_reduced_ring_interlock_width() =
    technic_gear_reduced_ring_cell_wall_thickness();
function technic_gear_reduced_ring_interlock_growth() = sqrt( 2 );
function technic_gear_reduced_ring_interlock_first_anchor_radius() =
    technic_gear_reduced_ring_cell_center_radius();
function technic_gear_reduced_ring_interlock_anchor_radius( generation ) =
    technic_gear_reduced_ring_interlock_first_anchor_radius()
    * exp( generation * ln( technic_gear_reduced_ring_interlock_growth() ) );
function technic_gear_reduced_ring_interlock_arc_radius( generation ) =
    technic_gear_reduced_ring_interlock_anchor_radius( generation ) / sqrt( 2 );
function technic_gear_reduced_ring_interlock_phase( generation ) =
    45 * generation;
function technic_gear_reduced_ring_interlock_outer_anchor_target( inner_diameter ) =
    max(
        technic_gear_reduced_ring_interlock_first_anchor_radius(),
        inner_diameter / 2 - technic_gear_reduced_ring_reference_rim_gap()
    );
function technic_gear_reduced_ring_interlock_generation_count( inner_diameter ) =
    let(
        target = technic_gear_reduced_ring_interlock_outer_anchor_target( inner_diameter ),
        first = technic_gear_reduced_ring_interlock_first_anchor_radius(),
        growth = technic_gear_reduced_ring_interlock_growth()
    )
    target <= first + 0.0001
        ? 0
        : ceil( ln( target / first ) / ln( growth ) );
function technic_gear_reduced_ring_interlock_positive_clip_radius( inner_diameter ) =
    inner_diameter / 2
    + max( 0, technic_gear_reduced_ring_interlock_width() - technic_gear_reduced_ring_reference_rim_gap() );



/** WP13E CELLULAR-I8: staggered interlocking circular support lattice.
 *
 * 16T keeps the source 4019 four-circle reduced primitive.  Larger gears use
 * concentric shells of FULL circular collars.  Each shell is staggered off the
 * native axle axes; neighboring collars overlap circumferentially and collars
 * on adjacent shells overlap radially.  The result is a continuous circle-based
 * load network rather than a crosshair or spoke graph.
 */
function technic_gear_reduced_ring_cellular_row_radius_increment() =
    // I15: each newly added radial row grows the relief diameter by one
    // eighth of the source 4019 wall thickness. Radius therefore grows by
    // one sixteenth wall per row: visibly stepped in top view while remaining
    // independent of total gear size / shell count.
    technic_gear_reduced_ring_cell_wall_thickness() / 16;
function technic_gear_reduced_ring_cellular_hole_radius_for_shell( shell_index ) =
    technic_gear_reduced_ring_cell_inner_radius()
    + shell_index * technic_gear_reduced_ring_cellular_row_radius_increment();
function technic_gear_reduced_ring_cellular_outer_radius_for_shell( shell_index ) =
    // Preserve the source 4019 collar wall at every row even as the hole grows.
    technic_gear_reduced_ring_cellular_hole_radius_for_shell( shell_index )
    + technic_gear_reduced_ring_cell_wall_thickness();
function technic_gear_reduced_ring_cellular_pitch_for_shell( shell_index ) =
    // A golf-ball-like invariant: adjacent holes retain exactly one source wall
    // and adjacent full-height collars overlap by exactly one source wall.
    ( 2 * technic_gear_reduced_ring_cellular_hole_radius_for_shell( shell_index ) )
    + technic_gear_reduced_ring_cell_wall_thickness();
function technic_gear_reduced_ring_cellular_shell_pitch() =
    // Compatibility / diagnostics: the first scalable row uses the original
    // I13 golf packing pitch.
    technic_gear_reduced_ring_cellular_pitch_for_shell( 0 );
function technic_gear_reduced_ring_cellular_overlap() =
    technic_gear_reduced_ring_cell_wall_thickness();
function technic_gear_reduced_ring_cellular_nominal_shell_radius( shell_index ) =
    let(
        first = technic_gear_reduced_ring_cell_center_radius(),
        base_pitch = technic_gear_reduced_ring_cellular_pitch_for_shell( 0 ),
        growth = technic_gear_reduced_ring_cellular_row_radius_increment()
    )
    // Sum of all preceding row-to-row pitches.  Since ri(i)=ri0+i*growth,
    // each transition pitch is ri(i)+ri(i+1)+wall and the closed form is:
    // first + k*base_pitch + k^2*growth.
    first + shell_index * base_pitch + shell_index * shell_index * growth;
function technic_gear_reduced_ring_cellular_shell_count( inner_diameter ) =
    let(
        target = technic_gear_reduced_ring_outer_shell_radius_from_inner_diameter( inner_diameter ),
        first = technic_gear_reduced_ring_cell_center_radius(),
        base_pitch = technic_gear_reduced_ring_cellular_pitch_for_shell( 0 ),
        growth = technic_gear_reduced_ring_cellular_row_radius_increment(),
        // Solve growth*k^2 + base_pitch*k + first <= target.
        max_index = target <= first + 0.0001
            ? 0
            : floor(
                ( -base_pitch + sqrt( base_pitch * base_pitch + 4 * growth * ( target - first ) ) )
                / ( 2 * growth )
            )
    )
    max_index + 1;
function technic_gear_reduced_ring_cellular_shell_radius( inner_diameter, shell_index ) =
    let(
        count = technic_gear_reduced_ring_cellular_shell_count( inner_diameter ),
        target = technic_gear_reduced_ring_outer_shell_radius_from_inner_diameter( inner_diameter ),
        nominal_last = technic_gear_reduced_ring_cellular_nominal_shell_radius( count - 1 ),
        // Spread any harmless leftover envelope space across the rows.  This
        // never reduces the source-derived row spacing; it only lets the outer
        // row approach the tooth-support rim cleanly.
        extra = count <= 1 ? 0 : max( 0, target - nominal_last )
    )
    count <= 1
        ? technic_gear_reduced_ring_cell_center_radius()
        : technic_gear_reduced_ring_cellular_nominal_shell_radius( shell_index )
          + extra * shell_index / ( count - 1 );
function technic_gear_reduced_ring_cellular_cell_count_for_radius( shell_radius, shell_index ) =
    shell_index == 0
        ? 4
        : max(
            4,
            4 * floor(
                ( PI / 2 ) * shell_radius
                / technic_gear_reduced_ring_cellular_pitch_for_shell( shell_index )
            )
        );
// Cumulative half-cell staggering.  Every scalable shell is offset from the
// previous shell, preventing persistent radial hole rows / crosshair appearance.
function technic_gear_reduced_ring_cellular_phase_from_shells( inner_diameter, shell_index ) =
    shell_index <= 0
        ? 0
        : technic_gear_reduced_ring_cellular_phase_from_shells( inner_diameter, shell_index - 1 )
          + 180 / technic_gear_reduced_ring_cellular_cell_count_for_radius(
                technic_gear_reduced_ring_cellular_shell_radius( inner_diameter, shell_index ),
                shell_index
            );
function technic_gear_reduced_ring_cellular_outer_radius( shell_radius, cell_count, shell_index ) =
    technic_gear_reduced_ring_cellular_outer_radius_for_shell( shell_index );
function technic_gear_reduced_ring_cellular_hole_radius( inner_diameter, shell_index, outer_radius ) =
    min(
        outer_radius - ( technic_gear_reduced_ring_cell_wall_thickness() / 2 ),
        technic_gear_reduced_ring_cellular_hole_radius_for_shell( shell_index )
    );

/** CELLULAR-I16 golf-packed recessed-web + row-wise growing circular relief.
 *
 * Positive cellular support and negative weight relief are deliberately
 * separated.  The collar lattice is clipped to the reserved tooth-rim inner
 * boundary.  Relief holes are emitted only when the whole circular hole plus
 * one source 4019 wall thickness fits inside that boundary.  This removes
 * both accidental inter-cell sliver holes and clipped/partial rim holes.
 */
function technic_gear_reduced_ring_cellular_hole_fits_rim(
    inner_diameter, shell_radius, hole_radius
) =
    shell_radius
    + hole_radius
    + technic_gear_reduced_ring_cell_wall_thickness()
    <= inner_diameter / 2 + 0.0001;

module technic_gear_reduced_ring_cellular_field_2d( inner_diameter ) {
    shell_count = technic_gear_reduced_ring_cellular_shell_count( inner_diameter );

    intersection() {
        union() {
            for ( shell_index = [ 0 : shell_count - 1 ] ) {
                r = technic_gear_reduced_ring_cellular_shell_radius( inner_diameter, shell_index );
                n = technic_gear_reduced_ring_cellular_cell_count_for_radius( r, shell_index );
                phase = technic_gear_reduced_ring_cellular_phase_from_shells( inner_diameter, shell_index );
                ro = technic_gear_reduced_ring_cellular_outer_radius( r, n, shell_index );
                for ( index = [ 0 : n - 1 ] ) {
                    a = phase + 360 * index / n;
                    translate( [ r * cos( a ), r * sin( a ) ] ) circle( r = ro );
                }
            }
        }
        circle( r = inner_diameter / 2 );
    }
}

module technic_gear_reduced_ring_cellular_openings_field_2d( inner_diameter ) {
    shell_count = technic_gear_reduced_ring_cellular_shell_count( inner_diameter );

    intersection() {
        circle( r = inner_diameter / 2 );
        union() {
            for ( shell_index = [ 0 : shell_count - 1 ] ) {
                r = technic_gear_reduced_ring_cellular_shell_radius( inner_diameter, shell_index );
                n = technic_gear_reduced_ring_cellular_cell_count_for_radius( r, shell_index );
                phase = technic_gear_reduced_ring_cellular_phase_from_shells( inner_diameter, shell_index );
                ro = technic_gear_reduced_ring_cellular_outer_radius( r, n, shell_index );
                ri = technic_gear_reduced_ring_cellular_hole_radius( inner_diameter, shell_index, ro );

                if ( technic_gear_reduced_ring_cellular_hole_fits_rim(
                    inner_diameter, r, ri
                ) ) {
                    for ( index = [ 0 : n - 1 ] ) {
                        a = phase + 360 * index / n;
                        translate( [ r * cos( a ), r * sin( a ) ] ) circle( r = ri );
                    }
                }
            }
        }
    }
}

module technic_gear_reduced_ring_cellular_openings_negative( height, inner_diameter ) {
    // Extrude the complete selected relief field once.  This is geometrically
    // identical to hundreds of individual cylinders but keeps OpenSCAD's CSG
    // normalization bounded at 80T/128T.
    linear_extrude( height = height + EXTENSION_FOR_DIFFERENCE, center = true )
        technic_gear_reduced_ring_cellular_openings_field_2d(
            inner_diameter = inner_diameter
        );
}

module technic_gear_reduced_ring_cellular_lattice_positive( height, inner_diameter ) {
    linear_extrude( height = height, center = true )
        technic_gear_reduced_ring_cellular_field_2d( inner_diameter = inner_diameter );
}

/** Fixed 4019-style collar used as a robust transfer joint between recursive arcs. */
module technic_gear_reduced_ring_interlock_joint_collar( height ) {
    difference() {
        cylinder( r = technic_gear_reduced_ring_cell_outer_radius(), h = height, center = true );
        cylinder(
            r = technic_gear_reduced_ring_cell_inner_radius(),
            h = height + EXTENSION_FOR_DIFFERENCE,
            center = true
        );
    }
}

/** Four transfer collars at one recursive anchor generation. */
module technic_gear_reduced_ring_interlock_joint_generation( generation, height ) {
    anchor_radius = technic_gear_reduced_ring_interlock_anchor_radius( generation );
    phase = technic_gear_reduced_ring_interlock_phase( generation );

    for ( quadrant = [ 0 : 3 ] ) {
        angle = phase + 90 * quadrant;
        translate( [ anchor_radius * cos( angle ), anchor_radius * sin( angle ), 0 ] )
            technic_gear_reduced_ring_interlock_joint_collar( height = height );
    }
}

/**
 * Source-derived hollow-body proportions from the official LDraw 32269 hub
 * geometry.  The quarter-body source uses radius 17 for the body boundary and
 * 11.998 for the cardinal opening boundary.  Store the source coordinates once
 * and derive the dimensionless ratio used by all hollow body sizes.
 */
technic_gear_hollow_reference_body_radius_units = 17;
technic_gear_hollow_reference_opening_radius_units = 11.998;
technic_gear_hollow_reference_opening_ratio =
	technic_gear_hollow_reference_opening_radius_units
	/ technic_gear_hollow_reference_body_radius_units;

/** WP13C CROSS-only fixed geometry derived from LEGO/LDraw dimensions. */
technic_gear_hollow_cross_tooth_support_ring_width =
	( technic_gear_hollow_reference_body_radius_units - technic_gear_hollow_reference_opening_radius_units ) * 0.4;
technic_gear_hollow_cross_member_width = technic_gear_secondary_lattice_pitch;

/** CROSS owns its rim thickness independently from FRAME/RING. */
function technic_gear_hollow_cross_rim_inner_diameter( teeth ) =
	max( 0, technic_gear_root_diameter( teeth ) - ( 2 * technic_gear_hollow_cross_tooth_support_ring_width ) );

/** Largest secondary center radius that remains fully inside the 1-brick cross. */
function technic_gear_hollow_cross_secondary_max_radius( teeth ) =
	technic_gear_hollow_cross_rim_inner_diameter( teeth ) / 2
	- technic_gear_hollow_cross_member_width / 2;

/** Fixed 8 mm station pitch along each CROSS arm. */
function technic_gear_hollow_cross_secondary_radii( teeth ) =
	let(
		pitch = technic_gear_secondary_lattice_pitch,
		maximum_radius = technic_gear_hollow_cross_secondary_max_radius( teeth ),
		count = maximum_radius < pitch ? 0 : floor( maximum_radius / pitch )
	)
	count > 0 ? [ for ( i = [ 1 : count ] ) pitch * i ] : [];

function technic_gear_hollow_cross_secondary_points( teeth ) =
	[
		for ( radius = technic_gear_hollow_cross_secondary_radii( teeth ) )
			for ( point = [ [ radius, 0 ], [ -radius, 0 ], [ 0, radius ], [ 0, -radius ] ] )
				point
	];

function technic_gear_hollow_cross_pin_points( teeth, requested ) =
	requested == "pin" ? technic_gear_hollow_cross_secondary_points( teeth ) :
	requested == "pin+axle" ? [ for ( p = technic_gear_hollow_cross_secondary_points( teeth ) ) if ( p[0] != 0 ) p ] : [];

function technic_gear_hollow_cross_axle_points( teeth, requested ) =
	requested == "axle" ? technic_gear_hollow_cross_secondary_points( teeth ) :
	requested == "pin+axle" ? [ for ( p = technic_gear_hollow_cross_secondary_points( teeth ) ) if ( p[1] != 0 ) p ] : [];

function technic_gear_hollow_cross_effective_secondary_feature( teeth, requested ) =
	let(
		has_pin = len( technic_gear_hollow_cross_pin_points( teeth, requested ) ) > 0,
		has_axle = len( technic_gear_hollow_cross_axle_points( teeth, requested ) ) > 0
	)
	requested == "none" || requested == "clutch_single" || requested == "clutch_dual" ? "none" :
	requested == "pin" ? ( has_pin ? "pin" : "none" ) :
	requested == "axle" ? ( has_axle ? "axle" : "none" ) :
	requested == "pin+axle" ? ( has_pin && has_axle ? "pin+axle" : has_pin ? "pin" : has_axle ? "axle" : "none" ) : "none";

/** WP13D FRAME-only dimensions from the official 32498 LDraw model. */
technic_gear_hollow_frame_reference_root_radius_units = 37;
technic_gear_hollow_frame_reference_rim_inner_radius_units = 29.5;
technic_gear_hollow_frame_tooth_support_ring_width =
	( technic_gear_hollow_frame_reference_root_radius_units - technic_gear_hollow_frame_reference_rim_inner_radius_units ) * 0.4;
technic_gear_hollow_frame_first_station_radius = technic_gear_secondary_lattice_pitch;
technic_gear_hollow_frame_reference_teeth = 36;

/** FRAME owns a fixed-width tooth-support rim independently from CROSS/RING. */
function technic_gear_hollow_frame_rim_inner_diameter( teeth ) =
	max( 0, technic_gear_root_diameter( teeth ) - ( 2 * technic_gear_hollow_frame_tooth_support_ring_width ) );

/** Largest FRAME joint-center radius leaving its complete local pad inside the opening. */
function technic_gear_hollow_frame_secondary_max_radius( teeth ) =
	technic_gear_hollow_frame_rim_inner_diameter( teeth ) / 2
	- ( technic_gear_pin_hole_outer_diameter / 2 );

/**
 * Preserve the accepted 36T visual clearance between the outer FRAME joint and
 * the tooth-support rim. The value is derived from the reference envelope; it
 * is not repeated as an anonymous dimensional literal.
 */
technic_gear_hollow_frame_reference_outer_joint_clearance =
	technic_gear_hollow_frame_secondary_max_radius( technic_gear_hollow_frame_reference_teeth )
	- technic_gear_hollow_frame_first_station_radius;

/** Target radius for the outermost FRAME joint centres. */
function technic_gear_hollow_frame_outer_joint_target_radius( teeth ) =
	max(
		0,
		technic_gear_hollow_frame_secondary_max_radius( teeth )
		- technic_gear_hollow_frame_reference_outer_joint_clearance
	);

/** Effective radial radius of a diamond or axis-aligned square frame layer. */
function _technic_gear_hollow_frame_layer_radius( shape, coordinate ) =
	shape == "diamond" ? coordinate :
	shape == "square" ? sqrt( 2 ) * coordinate :
	assert( false, str( "invalid FRAME layer shape: ", shape ) );

/** Count complete D(a)+S(a) generations that fit from the 8 mm reference seed. */
function _technic_gear_hollow_frame_generation_count( coordinate, target_radius ) =
	_technic_gear_hollow_frame_layer_radius( "square", coordinate ) <= target_radius
		? 1 + _technic_gear_hollow_frame_generation_count( coordinate * 2, target_radius )
		: 0;

/** Build `count` alternating D(a), S(a) generations. */
function _technic_gear_hollow_frame_scaled_generations( coordinate, count ) =
	count <= 0 ? [] : concat(
		[
			[ "diamond", coordinate, coordinate ],
			[ "square", coordinate, _technic_gear_hollow_frame_layer_radius( "square", coordinate ) ]
		],
		_technic_gear_hollow_frame_scaled_generations( coordinate * 2, count - 1 )
	);

/**
 * Resolve FRAME layers from the tooth-support rim inward.
 *
 * The 36T anchor remains D8 because its derived target radius is exactly the
 * accepted first-station radius. Once a complete diamond+square generation can
 * fit, the number of generations is selected using the 8 mm reference grammar,
 * then the whole alternating sequence is uniformly scaled so the outermost
 * square reaches the same derived clearance from the tooth-support rim as 36T.
 *
 * Successive geometry remains D(a) -> S(a) -> D(2a) -> S(2a). Therefore each
 * inner-frame vertex lies exactly at the centre of a side of the next frame;
 * no transition diagonals are required or emitted.
 */
function technic_gear_hollow_frame_layers( teeth ) =
	let(
		target_radius = technic_gear_hollow_frame_outer_joint_target_radius( teeth ),
		first = technic_gear_hollow_frame_first_station_radius,
		generation_count = _technic_gear_hollow_frame_generation_count( first, target_radius ),
		outer_coordinate_multiplier = generation_count > 0 ? pow( 2, generation_count - 1 ) : 1,
		base_coordinate = generation_count > 0
			? target_radius / ( sqrt( 2 ) * outer_coordinate_multiplier )
			: target_radius
	)
	target_radius < first ? [] :
	generation_count == 0 ? [ [ "diamond", base_coordinate, base_coordinate ] ] :
	_technic_gear_hollow_frame_scaled_generations( base_coordinate, generation_count );

function _technic_gear_hollow_frame_layer_points( layer ) =
	let( shape = layer[0], c = layer[1] )
	shape == "diamond" ? [ [ c, 0 ], [ 0, c ], [ -c, 0 ], [ 0, -c ] ] :
	shape == "square" ? [ [ c, c ], [ -c, c ], [ -c, -c ], [ c, -c ] ] :
	assert( false, str( "invalid FRAME layer shape: ", shape ) );

/** Every FRAME polygon vertex is a functional structural joint. */
function technic_gear_hollow_frame_joint_points( teeth ) =
	[ for ( layer = technic_gear_hollow_frame_layers( teeth ) ) for ( p = _technic_gear_hollow_frame_layer_points( layer ) ) p ];

/**
 * Project one functional FRAME joint radially onto the tooth-support rim.
 *
 * This is the global FRAME reinforcement rule: once secondary functionality is
 * present, each functional joint owns one same-width load path toward the rim.
 * Cardinal projections coincide with the permanent CROSS; square-corner
 * projections form the four 45-degree diagonals. The projected point is
 * structural only and never creates another pin/axle hole.
 */
function technic_gear_hollow_frame_rim_projection( point, rim_connection_radius ) =
	let(
		radius = sqrt( point[0] * point[0] + point[1] * point[1] ),
		scale = radius > 0 ? rim_connection_radius / radius : 0
	)
	[ point[0] * scale, point[1] * scale ];

/** First square layer, if FRAME has grown beyond the single-diamond seed. */
function technic_gear_hollow_frame_first_square_layer( teeth ) =
	let( squares = [ for ( layer = technic_gear_hollow_frame_layers( teeth ) ) if ( layer[0] == "square" ) layer ] )
	len( squares ) > 0 ? squares[0] : undef;

/**
 * Structural 45-degree rim anchors begin with the first square, independent of
 * secondary-feature selection. The first square's four corners define the four
 * global diagonal rays; later square joints lie on the same rays and therefore
 * need no additional rim anchor nodes.
 */
function technic_gear_hollow_frame_diagonal_rim_points( teeth, rim_connection_radius ) =
	let( first_square = technic_gear_hollow_frame_first_square_layer( teeth ) )
	is_undef( first_square ) ? [] :
	[ for ( point = _technic_gear_hollow_frame_layer_points( first_square ) )
		technic_gear_hollow_frame_rim_projection( point, rim_connection_radius ) ];

/** Backward diagnostic name: cardinal radii of diamond layers only. */
function technic_gear_hollow_frame_secondary_radii( teeth ) =
	[ for ( layer = technic_gear_hollow_frame_layers( teeth ) ) if ( layer[0] == "diamond" ) layer[1] ];

/** No secondary stations exist between FRAME joints. */
function technic_gear_hollow_frame_diagonal_points( teeth ) = [];

function technic_gear_hollow_frame_secondary_points( teeth ) =
	technic_gear_hollow_frame_joint_points( teeth );

/**
 * Mixed pin+axle allocation is joint-local and 180-degree symmetric.
 * Cardinal diamond joints preserve the 32498 anchor: horizontal joints are
 * pins, vertical joints are axles. Square joints alternate by diagonal pair.
 * Axle-hole geometry itself remains fixed-phase at placement time.
 */
function _technic_gear_hollow_frame_joint_is_pin( point ) =
	point[0] == 0 || point[1] == 0 ? point[1] == 0 : point[0] * point[1] > 0;

function technic_gear_hollow_frame_pin_points( teeth, requested ) =
	requested == "pin" ? technic_gear_hollow_frame_secondary_points( teeth ) :
	requested == "pin+axle"
		? [ for ( p = technic_gear_hollow_frame_joint_points( teeth ) ) if ( _technic_gear_hollow_frame_joint_is_pin( p ) ) p ] : [];

function technic_gear_hollow_frame_axle_points( teeth, requested ) =
	requested == "axle" ? technic_gear_hollow_frame_secondary_points( teeth ) :
	requested == "pin+axle"
		? [ for ( p = technic_gear_hollow_frame_joint_points( teeth ) ) if ( !_technic_gear_hollow_frame_joint_is_pin( p ) ) p ] : [];

function technic_gear_hollow_frame_effective_secondary_feature( teeth, requested ) =
	let(
		has_pin = len( technic_gear_hollow_frame_pin_points( teeth, requested ) ) > 0,
		has_axle = len( technic_gear_hollow_frame_axle_points( teeth, requested ) ) > 0
	)
	requested == "none" || requested == "clutch_single" || requested == "clutch_dual" ? "none" :
	requested == "pin" ? ( has_pin ? "pin" : "none" ) :
	requested == "axle" ? ( has_axle ? "axle" : "none" ) :
	requested == "pin+axle" ? ( has_pin && has_axle ? "pin+axle" : has_pin ? "pin" : has_axle ? "axle" : "none" ) : "none";

/** WP08 inner boundary of the tooth-support rim for each double topology. */
function technic_gear_double_rim_inner_diameter( teeth, resolved_body_topology ) =
	resolved_body_topology == "solid" ? 0 :
	resolved_body_topology == "reduced"
		? technic_gear_classic_rim_inner_diameter( teeth ) :
	resolved_body_topology == "hollow"
		? technic_gear_root_diameter( teeth ) * technic_gear_hollow_reference_opening_ratio
		: assert( false, str( "invalid resolved body topology: ", resolved_body_topology ) );

/** WP08 double-body hub envelope derived from the selected center interface. */
function technic_gear_double_hub_diameter( teeth, center, resolved_body_topology ) =
	let(
		// Axle hubs need only the spline envelope plus the existing shoulder wall.
		// Pin centers retain the existing pin-connector outer diameter.
		center_wall_diameter = center == "pin"
			? technic_pin_connector_outer_diameter
			: technic_axle_spline_width
				+ ( 2 * technic_pin_connector_shoulder_wall_thickness ),
		envelope_diameter = resolved_body_topology == "solid"
			? technic_gear_root_diameter( teeth )
			: technic_gear_double_rim_inner_diameter( teeth, resolved_body_topology )
	)
	min( center_wall_diameter, envelope_diameter );

/** WP08 outer body boundary: the common tooth-root envelope. */
function technic_gear_double_rim_outer_diameter( teeth ) = technic_gear_root_diameter( teeth );

/** Base structural-member width derived from existing Technic wall/web dimensions. */
function _technic_gear_hollow_base_member_width() =
	max(
		2 * technic_beam_webbing_thickness,
		technic_gear_pin_hole_outer_diameter - technic_hole_diameter
	);

/** Minimum real radial opening, derived from the existing Technic shoulder wall. */
technic_gear_hollow_minimum_open_span = technic_pin_connector_shoulder_wall_thickness;

/** Whether a real open hollow span exists between the derived hub and rim. */
function technic_gear_hollow_structure_valid( teeth, hollow_structure, center, secondary_feature ) =
	let(
		hub_diameter = technic_gear_double_hub_diameter( teeth, center, "hollow" ),
		rim_inner_diameter = hollow_structure == "cross"
			? technic_gear_hollow_cross_rim_inner_diameter( teeth )
			: hollow_structure == "frame"
			? technic_gear_hollow_frame_rim_inner_diameter( teeth )
			: technic_gear_double_rim_inner_diameter( teeth, "hollow" ),
		radial_open_span = ( rim_inner_diameter - hub_diameter ) / 2
	)
	_technic_gear_value_in( hollow_structure, [ "cross", "frame", "ring" ] )
	&& rim_inner_diameter > hub_diameter
	&& radial_open_span >= technic_gear_hollow_minimum_open_span;

/** WP08 member width; topology fit is validated separately before geometry. */
function technic_gear_hollow_member_width( teeth, hollow_structure, center, secondary_feature ) =
	hollow_structure == "cross" ? technic_gear_hollow_cross_member_width : _technic_gear_hollow_base_member_width();

/**
 * WP08 structure-node records. First two values are XY; third is node role.
 * Base frame nodes use the 8 mm Technic lattice whenever the envelope permits.
 */
function technic_gear_hollow_structure_nodes( teeth, hollow_structure, center, secondary_feature ) =
	let(
		effective_secondary = hollow_structure == "frame"
			? technic_gear_hollow_frame_effective_secondary_feature( teeth, secondary_feature )
			: technic_gear_secondary_effective_feature( teeth, secondary_feature ),
		hub_diameter = technic_gear_double_hub_diameter( teeth, center, "hollow" ),
		rim_inner_diameter = hollow_structure == "cross"
			? technic_gear_hollow_cross_rim_inner_diameter( teeth )
			: hollow_structure == "frame"
			? technic_gear_hollow_frame_rim_inner_diameter( teeth )
			: technic_gear_double_rim_inner_diameter( teeth, "hollow" ),
		member_width = technic_gear_hollow_member_width( teeth, hollow_structure, center, effective_secondary ),
		hub_radius = hub_diameter / 2,
		connection_overlap = technic_beam_webbing_thickness / 2,
		rim_connection_radius = ( rim_inner_diameter / 2 ) - ( member_width / 2 ) + connection_overlap,
		mid_radius = ( hub_radius + rim_connection_radius ) / 2,
		frame_layers = hollow_structure == "frame" ? technic_gear_hollow_frame_layers( teeth ) : [],
		frame_joint_points = hollow_structure == "frame" ? technic_gear_hollow_frame_joint_points( teeth ) : [],
		frame_axle_points = hollow_structure == "frame" ? technic_gear_hollow_frame_axle_points( teeth, effective_secondary ) : [],
		frame_pin_points = hollow_structure == "frame" ? technic_gear_hollow_frame_pin_points( teeth, effective_secondary ) : [],
		frame_rim_joint_points = hollow_structure == "frame"
			? technic_gear_hollow_frame_diagonal_rim_points( teeth, rim_connection_radius ) : [],
		frame_nodes = hollow_structure == "frame" ? concat(
			[ [ 0, 0, "hub" ] ],
			[ for ( point = frame_joint_points )
				[ point[0], point[1],
					_technic_gear_point_in_list( point, frame_axle_points ) ? "axle" :
					_technic_gear_point_in_list( point, frame_pin_points ) ? "pin" : "structure" ] ],
			[ for ( point = frame_rim_joint_points ) [ point[0], point[1], "structure" ] ]
		) : [],
		base_nodes = hollow_structure == "cross" ? [
			[ 0, 0, "hub" ],
			[ rim_connection_radius, 0, "structure" ],
			[ -rim_connection_radius, 0, "structure" ],
			[ 0, rim_connection_radius, "structure" ],
			[ 0, -rim_connection_radius, "structure" ]
		] : hollow_structure == "ring" ? [
			[ 0, 0, "hub" ],
			[ mid_radius, 0, "structure" ],
			[ -mid_radius, 0, "structure" ],
			[ 0, mid_radius, "structure" ],
			[ 0, -mid_radius, "structure" ],
			[ rim_connection_radius, 0, "structure" ],
			[ -rim_connection_radius, 0, "structure" ],
			[ 0, rim_connection_radius, "structure" ],
			[ 0, -rim_connection_radius, "structure" ]
		] : [],
		axle_points = hollow_structure == "cross" || hollow_structure == "frame" ? [] :
			( effective_secondary == "axle" || effective_secondary == "pin+axle"
				? technic_gear_secondary_axle_stations( teeth ) : [] ),
		pin_points = hollow_structure == "cross" || hollow_structure == "frame" ? [] :
			( effective_secondary == "pin" || effective_secondary == "pin+axle"
				? technic_gear_secondary_pin_stations( teeth ) : [] ),
		base_points = [ for ( node = base_nodes ) [ node[0], node[1] ] ],
		resolved_base_nodes = [
			for ( node = base_nodes )
				let(
					point = [ node[0], node[1] ],
					role = _technic_gear_point_in_list( point, axle_points ) ? "axle"
						: _technic_gear_point_in_list( point, pin_points ) ? "pin" : node[2]
				)
				[ node[0], node[1], role ]
		],
		secondary_nodes = concat(
			[ for ( point = axle_points ) if ( !_technic_gear_point_in_list( point, base_points ) ) [ point[0], point[1], "axle" ] ],
			[ for ( point = pin_points ) if ( !_technic_gear_point_in_list( point, axle_points ) && !_technic_gear_point_in_list( point, base_points ) ) [ point[0], point[1], "pin" ] ]
		)
	)
	technic_gear_hollow_structure_valid( teeth, hollow_structure, center, effective_secondary )
		? ( hollow_structure == "frame" ? frame_nodes : concat( resolved_base_nodes, secondary_nodes ) ) : [];

/** Squared XY distance for deterministic hollow-graph attachment. */
function _technic_gear_hollow_node_distance_squared( node_a, node_b ) =
	( node_a[0] - node_b[0] ) * ( node_a[0] - node_b[0] )
	+ ( node_a[1] - node_b[1] ) * ( node_a[1] - node_b[1] );

/** Attach a station to the nearest already-connected base structure node. */
function _technic_gear_hollow_nearest_base_node_index( nodes, station_index, base_count ) =
	let(
		distances = [
			for ( i = [ 0 : base_count - 1 ] )
				_technic_gear_hollow_node_distance_squared( nodes[i], nodes[station_index] )
		],
		minimum_distance = min( distances ),
		matches = [ for ( i = [ 0 : base_count - 1 ] ) if ( distances[i] == minimum_distance ) i ]
	)
	matches[0];

/**
 * WP08 graph edges.
 *
 * FRAME polygons retain no inter-layer connector edges. Once the first square
 * exists, its four corners define four permanent 45-degree structural rays to
 * the tooth-support rim. This is FRAME geometry, not secondary-feature
 * geometry, so it remains present for none, clutch and pin/axle modes alike.
 */
function technic_gear_hollow_structure_edges( nodes, hollow_structure, teeth = undef ) =
	let(
		frame_layers = hollow_structure == "frame" && !is_undef( teeth ) ? technic_gear_hollow_frame_layers( teeth ) : [],
		frame_layer_count = len( frame_layers ),
		frame_joint_count = 4 * frame_layer_count,
		frame_rim_count = hollow_structure == "frame" ? max( 0, len( nodes ) - 1 - frame_joint_count ) : 0,
		first_square_layer_index = hollow_structure == "frame"
			? let( matches = [ for ( i = [ 0 : frame_layer_count - 1 ] ) if ( frame_layers[i][0] == "square" ) i ] )
				( len( matches ) > 0 ? matches[0] : -1 )
			: -1,
		frame_edges = hollow_structure == "frame" && frame_layer_count > 0 ?
			concat(
				[ for ( layer = [ 0 : frame_layer_count - 1 ] )
					for ( edge = [ [ 0,1 ], [ 1,2 ], [ 2,3 ], [ 3,0 ] ] )
						[ 1 + 4 * layer + edge[0], 1 + 4 * layer + edge[1] ] ],
				frame_rim_count == 4 && first_square_layer_index >= 0
					? let(
						square_start = 1 + 4 * first_square_layer_index,
						rim_start = 1 + frame_joint_count
					  )
						[ for ( i = [ 0 : 3 ] ) [ square_start + i, rim_start + i ] ]
					: []
			) : [],
		base_count = hollow_structure == "cross" ? 5 : hollow_structure == "ring" ? 9 : 0,
		base_edges = hollow_structure == "cross" ? [
			[ 0, 1 ], [ 0, 2 ], [ 0, 3 ], [ 0, 4 ]
		] : hollow_structure == "ring" ? [
			[ 0, 1 ], [ 0, 2 ], [ 0, 3 ], [ 0, 4 ],
			[ 1, 5 ], [ 2, 6 ], [ 3, 7 ], [ 4, 8 ]
		] : [],
		secondary_edges = base_count > 0 && len( nodes ) > base_count
			? [ for ( i = [ base_count : len( nodes ) - 1 ] ) [ _technic_gear_hollow_nearest_base_node_index( nodes, i, base_count ), i ] ] : []
	)
	hollow_structure == "frame" ? frame_edges :
	base_count > 0 && len( nodes ) >= base_count ? concat( base_edges, secondary_edges ) : [];

/** P1 reinforcement is required only for genuinely reduced local topology. */
function technic_gear_axle_support_required( resolved_body_topology ) = resolved_body_topology == "reduced";

/** Complete transformed relief footprint radial extent. */
function technic_gear_axle_relief_outer_radius( point, orientation ) =
	technic_gear_oriented_rectangle_outer_radius(
		point,
		technic_gear_axle_reinforcement_width - technic_pin_connector_shoulder_wall_thickness,
		( technic_axle_spline_thickness * technic_axle_interference_fit_ratio ) / 3,
		orientation
	);

function technic_gear_axle_relief_body_gap( teeth, point, orientation ) =
	technic_gear_axle_structural_radius( teeth ) - technic_gear_axle_relief_outer_radius( point, orientation );

function technic_gear_axle_relief_ring_gap( teeth, point, orientation ) =
	technic_gear_tooth_support_ring_inner_radius( teeth ) - technic_gear_axle_relief_outer_radius( point, orientation );

function technic_gear_axle_relief_fits_body( teeth, point, orientation, minimum_clearance = technic_gear_axle_station_minimum_clearance ) =
	technic_gear_axle_relief_body_gap( teeth, point, orientation ) >= minimum_clearance;

function technic_gear_axle_relief_clears_tooth_ring( teeth, point, orientation, body_mode, minimum_clearance = technic_gear_axle_station_minimum_clearance ) =
	body_mode != "reduced"
	|| technic_gear_axle_relief_ring_gap( teeth, point, orientation ) >= minimum_clearance;

function technic_gear_axle_relief_fits( teeth, point, orientation, body_mode, minimum_clearance = technic_gear_axle_station_minimum_clearance ) =
	technic_gear_axle_relief_fits_body( teeth, point, orientation, minimum_clearance )
	&& technic_gear_axle_relief_clears_tooth_ring( teeth, point, orientation, body_mode, minimum_clearance );

/** Effective secondary feature selected from actual WP06C capacity. */
function technic_gear_secondary_effective_feature( teeth, requested ) =
	requested == "none" ? "none" :
	requested == "pin" ? ( len( technic_gear_secondary_pin_stations( teeth ) ) > 0 ? "pin" : "none" ) :
	requested == "axle" ? ( len( technic_gear_secondary_axle_stations( teeth ) ) > 0 ? "axle" : "none" ) :
	requested == "pin+axle" ?
		( len( technic_gear_secondary_axle_stations( teeth ) ) > 0 ? "pin+axle" :
		  len( technic_gear_secondary_pin_stations( teeth ) ) > 0 ? "pin" : "none" ) :
	"none";

/** Thin subtype dispatcher; placement mathematics remains subtype-owned. */
function technic_gear_secondary_effective_feature_resolved( teeth, requested, body_mode, hollow_structure ) =
	body_mode == "hollow" && hollow_structure == "cross"
		? technic_gear_hollow_cross_effective_secondary_feature( teeth, requested )
		: body_mode == "hollow" && hollow_structure == "frame"
		? technic_gear_hollow_frame_effective_secondary_feature( teeth, requested )
		: technic_gear_secondary_effective_feature( teeth, requested );

/** Build one axle station with all applicability resolved before placement. */
function technic_gear_axle_station_record( teeth, point, orientation, body_mode, resolved_body_topology, role ) =
	let(
		support_required = technic_gear_axle_support_required( resolved_body_topology ),
		support_fits = technic_gear_axle_support_fits( teeth, point, orientation ),
		emit_support = support_required && support_fits,
		relief_fits_body = technic_gear_axle_relief_fits_body( teeth, point, orientation ),
		relief_clears_ring = technic_gear_axle_relief_clears_tooth_ring( teeth, point, orientation, body_mode ),
		emit_relief = emit_support && relief_fits_body && relief_clears_ring,
		relief_outer_radius = technic_gear_axle_relief_outer_radius( point, orientation ),
		ring_inner_radius = technic_gear_tooth_support_ring_inner_radius( teeth ),
		ring_gap = ring_inner_radius - relief_outer_radius
	)
	[
		point[0], point[1], orientation, emit_support, emit_relief, role,
		support_required, support_fits, relief_fits_body, relief_clears_ring,
		relief_outer_radius, ring_inner_radius, ring_gap, technic_gear_axle_station_minimum_clearance
	];

/** One composition-time registry for center plus selected secondary axle records. */
function technic_gear_axle_station_records( teeth, center, secondary_feature, body_mode, resolved_body_topology, hollow_structure = undef ) =
	let(
		secondary_axle_points = body_mode == "hollow" && hollow_structure == "cross"
			? technic_gear_hollow_cross_axle_points( teeth, secondary_feature )
			: body_mode == "hollow" && hollow_structure == "frame"
			? technic_gear_hollow_frame_axle_points( teeth, secondary_feature )
			: ( secondary_feature == "axle" || secondary_feature == "pin+axle" ? technic_gear_secondary_axle_stations( teeth ) : [] )
	)
	concat(
		center == "axle"
			? [ technic_gear_axle_station_record( teeth, [ 0, 0 ], 0, body_mode, resolved_body_topology, "center" ) ]
			: [],
		[ for ( point = secondary_axle_points )
			technic_gear_axle_station_record(
				teeth, point, technic_gear_secondary_axle_support_orientation( point ),
				body_mode, resolved_body_topology, "secondary"
			) ]
	);

/**
 * Sole production placement path for all three independent axle helpers.
 * Geometry policy is precomputed in the station flags; role never selects geometry.
 */
module technic_gear_place_axle_stations( records, height, operand ) {
	assert( operand == "positive" || operand == "negative", str( "invalid axle station operand: ", operand ) );

	for ( station = records ) {
		translate( [ station[0], station[1], 0 ] ) {
			if ( operand == "positive" && station[3] ) {
				rotate( [ 0, 0, station[2] ] ) {
					technic_gear_axle_support( height = height );
				}
			}

			if ( operand == "negative" ) {
				technic_gear_axle_hole_fixed( height = height );

				if ( station[4] ) {
					rotate( [ 0, 0, station[2] ] ) {
						technic_gear_axle_entry_relief_cutout( height = height );
					}
				}
			}
		}
	}
}

/** Dense selected pin-wall positives. */
module technic_gear_secondary_pins_positive( teeth, secondary_feature, height ) {
	if ( secondary_feature == "pin" || secondary_feature == "pin+axle" ) {
		for ( point = technic_gear_secondary_pin_stations( teeth ) ) {
			translate( [ point[0], point[1], 0 ] ) {
				cylinder( d = technic_gear_pin_hole_outer_diameter, h = height, center = true );
			}
		}
	}
}

/** Dense selected pin bores. */
module technic_gear_secondary_pins_negative( teeth, secondary_feature, height, body_mode = "reduced", hollow_structure = undef ) {
	points = body_mode == "hollow" && hollow_structure == "cross"
		? technic_gear_hollow_cross_pin_points( teeth, secondary_feature )
		: body_mode == "hollow" && hollow_structure == "frame"
		? technic_gear_hollow_frame_pin_points( teeth, secondary_feature )
		: ( secondary_feature == "pin" || secondary_feature == "pin+axle" ? technic_gear_secondary_pin_stations( teeth ) : [] );
	for ( point = points ) {
		translate( [ point[0], point[1], 0 ] ) {
			cylinder( d = technic_hole_diameter, h = height + EXTENSION_FOR_DIFFERENCE, center = true );
		}
	}
}

/** Thin profile slice used only to hull the fixed outer-key taper. */
module _technic_gear_clutch_profile_slice( points, z ) {
	translate( [ 0, 0, z ] )
		linear_extrude( height = technic_gear_clutch_profile_slice_thickness, center = true )
			polygon( points = points );
}

/**
 * One fixed outer engagement key used as a mask inside the annular recess.
 * Radial/tangential dimensions remain fixed LEGO/LDraw dimensions; only the
 * axial stations scale with the requested gear height through `depth`.
 */
module _technic_gear_clutch_key_mask( profile_points, depth ) {
	narrow_points = technic_gear_clutch_narrow_profile_points();
	start_z = -depth / 2 - ( EXTENSION_FOR_DIFFERENCE / 2 );
	broad_end_z = technic_gear_clutch_local_z( depth, technic_gear_clutch_key_broad_end_z_lu );
	narrow_z = technic_gear_clutch_local_z( depth, technic_gear_clutch_key_narrow_z_lu );
	narrow_end_z = technic_gear_clutch_local_z( depth, technic_gear_clutch_key_narrow_end_z_lu );

	// Full-width engagement wall through the source-defined broad section.
	translate( [ 0, 0, ( start_z + broad_end_z ) / 2 ] )
		linear_extrude( height = broad_end_z - start_z + technic_gear_clutch_profile_slice_thickness, center = true )
			polygon( points = profile_points );

	// Source-derived faceward narrowing of the functional outer key.
	hull() {
		_technic_gear_clutch_profile_slice( profile_points, broad_end_z );
		_technic_gear_clutch_profile_slice( narrow_points, narrow_z );
	}

	translate( [ 0, 0, ( narrow_z + narrow_end_z ) / 2 ] )
		linear_extrude( height = narrow_end_z - narrow_z + technic_gear_clutch_profile_slice_thickness, center = true )
			polygon( points = narrow_points );
}

/**
 * One face's negative clutch recess.  The annular recess is removed everywhere
 * except the four repeated outer engagement keys.  The inner circle is only
 * center-side clearance.
 */
module technic_gear_clutch_interface_cutout(
	profile_points, inner_clearance_radius, interface_radius, depth
) {
	difference() {
		linear_extrude( height = depth + EXTENSION_FOR_DIFFERENCE, center = true ) {
			difference() {
				circle( r = interface_radius );
				circle( r = inner_clearance_radius );
			}
		}

		for ( angle = [ 0 : 90 : 270 ] ) {
			rotate( [ 0, 0, angle ] )
				_technic_gear_clutch_key_mask( profile_points = profile_points, depth = depth );
		}
	}
}

/** Place one or two identical face recesses at the derived axial stations. */
module technic_gear_place_clutch_interfaces(
	face_z_positions, profile_points, inner_clearance_radius, interface_radius, depth
) {
	for ( face_z = face_z_positions ) {
		translate( [ 0, 0, face_z ] ) {
			if ( face_z < 0 ) {
				mirror( [ 0, 0, 1 ] )
					technic_gear_clutch_interface_cutout(
						profile_points = profile_points,
						inner_clearance_radius = inner_clearance_radius,
						interface_radius = interface_radius,
						depth = depth
					);
			} else {
				technic_gear_clutch_interface_cutout(
					profile_points = profile_points,
					inner_clearance_radius = inner_clearance_radius,
					interface_radius = interface_radius,
					depth = depth
				);
			}
		}
	}
}

function _technic_gear_station_coordinate_seen_before( records, index, prior = 0 ) =
	prior >= index ? false :
	( records[prior][0] == records[index][0] && records[prior][1] == records[index][1] ) ? true :
	_technic_gear_station_coordinate_seen_before( records, index, prior + 1 );

/** Machine-readable station/component applicability manifest. */
module technic_gear_axle_station_manifest( teeth, center = "axle", secondary_feature = "pin+axle", body_mode = "reduced" ) {
	effective_secondary = technic_gear_secondary_effective_feature( teeth, secondary_feature );
	resolved_body_topology = technic_gear_double_body_topology( teeth, body_mode );
	records = technic_gear_axle_station_records( teeth, center, effective_secondary, body_mode, resolved_body_topology );

	echo( "TECHNIC_GEAR_AXLE_TOPOLOGY", resolved_body_topology );
	echo( "TECHNIC_GEAR_EFFECTIVE_SECONDARY", effective_secondary );
	echo( "TECHNIC_GEAR_AXLE_REGISTRY", records );

	assert( len( [ for ( r = records ) if ( r[0] == 0 && r[1] == 0 ) r ] ) == ( center == "axle" ? 1 : 0 ), "combined axle registry center count mismatch" );
	assert( len( [ for ( r = records ) if ( r[2] != 0 && r[2] != 90 ) r ] ) == 0, "combined axle registry orientation must be 0/90" );
	assert( len( [ for ( i = [ 0 : len( records ) - 1 ] ) if ( _technic_gear_station_coordinate_seen_before( records, i ) ) i ] ) == 0, "combined axle registry contains duplicate coordinates" );
	assert( len( [ for ( r = records ) if ( r[4] && !r[3] ) r ] ) == 0, "entry relief requires P1 support" );
	assert( len( [ for ( r = records ) if ( body_mode == "reduced" && r[4] && r[12] < r[13] ) r ] ) == 0, "enabled relief violates tooth-support-ring clearance" );
}


/**
 * Positive material for the singular center connector.
 *
 * This module owns connector-local reinforcement only; the owning body remains
 * outside. Pin wall/shoulder geometry reuses the existing connector primitive.
 */
module technic_gear_center_positive(
	center,
	axial_form,
	reinforcement_height,
	axle_reinforcement = false
) {
	if ( center == "axle" ) {
		if ( axle_reinforcement ) {
			cube(
				size = [
					technic_gear_axle_reinforcement_width,
					technic_gear_axle_reinforcement_height,
					reinforcement_height
				],
				center = true
			);
		}
	} else if ( center == "pin" ) {
		translate( [ 0, 0, -reinforcement_height / 2 ] ) {
			technic_pin_connector( length = reinforcement_height / technic_height_in_mm );
		}
	}
}

/** Generate only the negative geometry for the singular center connector. */
module technic_gear_center_negative( center, height, wide_axle = false, pin_clearance_diameter = technic_pin_connector_outer_diameter - ( EXTENSION_FOR_DIFFERENCE / 4 ) ) {
	if ( center == "axle" ) {
		if ( wide_axle ) {
			technic_gear_wide_axle_hole( height = height, center_of_multiple = true );
		} else {
			technic_axle_hole( height = height );
		}
	} else if ( center == "pin" ) {
		cylinder(
			d = pin_clearance_diameter,
			h = height + EXTENSION_FOR_DIFFERENCE,
			center = true
		);
	}
}

/**
 * Positive outer wall for one singular center pin interface.
 *
 * The wall owns only positive material.  The functional bore and optional
 * end counterbores are paired negative geometry in
 * `technic_gear_center_pin_cutout(...)`.  Keeping the operands separate
 * prevents surrounding body material from refilling the pin bore.
 */
module technic_gear_center_pin_wall( height, shoulder ) {
	assert( is_num( height ) && height > 0, str( "invalid center pin height: ", height ) );
	assert( shoulder == true || shoulder == false, str( "invalid center pin shoulder flag: ", shoulder ) );

	cylinder( d = technic_pin_connector_outer_diameter, h = height, center = true );
}

/**
 * Negative bore for one singular center pin interface.
 *
 * A plain pin interface uses the standard Technic hole diameter through the
 * full wall.  A shouldered interface additionally opens the two end regions
 * to the existing connector shoulder diameter.  The end counterbores extend
 * outward by `EXTENSION_FOR_DIFFERENCE` while retaining the exact inner
 * shoulder transition plane.
 */
module technic_gear_center_pin_cutout( height, shoulder ) {
	assert( is_num( height ) && height > 0, str( "invalid center pin height: ", height ) );
	assert( shoulder == true || shoulder == false, str( "invalid center pin shoulder flag: ", shoulder ) );
	assert( !shoulder || height > 2 * technic_pin_connector_shoulder_depth,
		str( "center pin height too small for shoulders: ", height ) );

	cylinder(
		d = technic_hole_diameter,
		h = height + EXTENSION_FOR_DIFFERENCE,
		center = true
	);

	if ( shoulder ) {
		shoulder_diameter = technic_pin_connector_outer_diameter
			- 2 * technic_pin_connector_shoulder_wall_thickness;
		shoulder_depth = technic_pin_connector_shoulder_depth;

		for ( direction = [ -1, 1 ] ) {
			translate( [
				0, 0,
				direction * ( height / 2 - shoulder_depth / 2 + EXTENSION_FOR_DIFFERENCE / 2 )
			] ) {
				cylinder(
					d = shoulder_diameter,
					h = shoulder_depth + EXTENSION_FOR_DIFFERENCE,
					center = true
				);
			}
		}
	}
}

/**
 * Sole placement/operand selector for a singular center pin interface.
 *
 * The caller owns the resolved center position.  This helper owns only which
 * paired local geometry participates in the positive or negative boolean pass.
 */
module technic_gear_place_center_pin( height, shoulder, operand ) {
	assert( operand == "positive" || operand == "negative", str( "invalid center pin operand: ", operand ) );

	if ( operand == "positive" ) {
		technic_gear_center_pin_wall( height = height, shoulder = shoulder );
	} else {
		technic_gear_center_pin_cutout( height = height, shoulder = shoulder );
	}
}

/** Radial clearance for the singular center connector against the owning body. */
function technic_gear_center_radial_clearance_valid( center, axial_form, teeth ) =
	center == "axle"
		? true
		: axial_form == "double"
			? technic_gear_classic_rim_inner_diameter( teeth ) >= technic_pin_connector_outer_diameter
			: true;

/**
 * Return the single-form backing-plate / body-side tooth-tip diameter.
 *
 * Official 6589 and 32198/87407 LDraw references use radii of 16 LDU
 * for 12T and 26 LDU for 20T respectively.  Both resolve to the same
 * rule: the body-side tip radius is the nominal tooth-count radius plus
 * one LDraw unit.  This is deliberately single-form geometry and does
 * not redefine the canonical module-1 double-gear diameter helpers.
 */
function technic_gear_single_body_diameter( teeth ) =
	teeth + 2 * technic_gear_single_tip_radial_offset;

/**
 * Derive the pitch diameter needed by the shared involute source so its
 * body-side tip diameter lands exactly on the single backing plate.
 */
function technic_gear_single_tooth_pitch_diameter( teeth ) =
	technic_gear_single_body_diameter( teeth ) * teeth / ( teeth + 2 );

/** Legacy single-form exposed tooth length retained for hub sizing. */
function technic_gear_single_exposed_tooth_length() =
	technic_gear_12_tooth_gear_diameter - technic_gear_12_tooth_hub_diameter;

/**
 * Preserve the pre-correction hub-sizing reference independently from the
 * corrected backing-plate diameter.  The radial-alignment correction owns
 * only the backing plate, teeth, and bevel envelope; hub redesign is out of
 * scope and remains frozen for the later single-body packages.
 */
function technic_gear_single_hub_reference_body_diameter( teeth ) =
	( teeth / 12 ) * technic_gear_12_tooth_gear_diameter;

/**
 * Single-form body-hub diameter.
 *
 * `center` is resolved at the calculation boundary so later single-center
 * placement does not need to rediscover body sizing.  WP11A deliberately
 * preserves the accepted hub envelope for both axle and pin centers; the
 * center-specific positive/negative geometry remains owned by WP11C.
 *
 * Hub sizing intentionally consumes the preserved pre-WP03B-C1 hub reference,
 * not the corrected backing-plate diameter.  This prevents the radial envelope
 * correction from leaking into hub geometry during this refactor.
 */
function technic_gear_single_hub_diameter( teeth, center ) =
	assert( _technic_gear_value_in( center, [ "axle", "pin" ] ), str( "invalid center: ", center ) )
	max(
		technic_gear_12_tooth_hub_diameter,
		technic_gear_single_hub_reference_body_diameter( teeth ) - technic_gear_single_exposed_tooth_length()
	);

/** Positive single-form lip/washer geometry only. */
module technic_gear_single_lip_solid( outer_diameter, inner_diameter, height ) {
	linear_extrude( height ) {
		difference() {
			circle( d = outer_diameter );
			circle( d = inner_diameter );
		}
	}
}

/**
 * Positive single-form base and body-hub geometry only.
 *
 * Local Z=0 is the bottom of the base.  The owning assembly places this body
 * above the separately owned lip; tooth and center geometry remain outside.
 */
module technic_gear_single_body_solid( gear_diameter, hub_diameter, base_height, tooth_height ) {
	cylinder( d = gear_diameter, h = base_height );

	translate( [ 0, 0, base_height ] ) {
		cylinder( d = hub_diameter, h = tooth_height );
	}
}

/** WP08 full-height solid double body inside the common tooth-root envelope. */
module technic_gear_double_filled_body( root_diameter, height ) {
	cylinder( d = root_diameter, h = height, center = true );
}

/**
 * WP08 classic reduced body: a thin inner web plus the full tooth-support rim.
 * The rim overlaps the minimum root-overlap ring in the common tooth solid.
 */
module technic_gear_webbed_ring_body( root_diameter, inner_diameter, web_height, ring_height ) {
	union() {
		cylinder( d = inner_diameter, h = web_height, center = true );

		difference() {
			cylinder( d = root_diameter, h = ring_height, center = true );
			cylinder( d = inner_diameter, h = ring_height + EXTENSION_FOR_DIFFERENCE, center = true );
		}
	}
}

/**
 * One generation of the recursive 4019 semicircle support mesh.
 *
 * Four outward semicircles connect the four adjacent anchor pairs.  Each arc
 * is obtained by taking a source-width circular rib and keeping only the half
 * outside its anchor chord.  The chord endpoints are exactly the current
 * generation anchors; the outer apex is exactly the next generation anchor.
 */
module technic_gear_reduced_ring_interlock_generation_2d(
    anchor_radius, phase, width, clip_radius
) {
    arc_radius = anchor_radius / sqrt( 2 );
    arc_extent = arc_radius + width;

    for ( quadrant = [ 0 : 3 ] ) {
        mid_phase = phase + 45 + 90 * quadrant;
        center = [
            arc_radius * cos( mid_phase ),
            arc_radius * sin( mid_phase )
        ];

        intersection() {
            circle( r = clip_radius );

            translate( center )
                rotate( mid_phase )
                    intersection() {
                        difference() {
                            circle( r = arc_radius + width / 2 );
                            circle( r = max( 0, arc_radius - width / 2 ) );
                        }

                        // Local +X is radially outward from the gear centre.
                        translate( [ 0, -arc_extent ] )
                            square( [ arc_extent * 2, arc_extent * 2 ] );
                    }
        }
    }
}

/** Positive 4019 core collars plus the recursive semicircle support mesh. */
module technic_gear_reduced_ring_collars_positive( height, inner_diameter ) {
    inner_radius = technic_gear_reduced_ring_cell_inner_radius();
    outer_radius = technic_gear_reduced_ring_cell_outer_radius();
    shell_count = technic_gear_reduced_ring_shell_count_from_inner_diameter( inner_diameter );
    center_radius = technic_gear_reduced_ring_cell_center_radius();

    // Freeze the accepted 16T primitive exactly: four source-sized collars.
    for ( point = [
        [ center_radius, 0 ], [ -center_radius, 0 ],
        [ 0, center_radius ], [ 0, -center_radius ]
    ] ) {
        translate( [ point[0], point[1], 0 ] ) {
            difference() {
                cylinder( r = outer_radius, h = height, center = true );
                cylinder( r = inner_radius, h = height + EXTENSION_FOR_DIFFERENCE, center = true );
            }
        }
    }

    if ( shell_count > 1 ) {
        width = technic_gear_reduced_ring_interlock_width();
        clip_radius = technic_gear_reduced_ring_interlock_positive_clip_radius( inner_diameter );
        generation_count = technic_gear_reduced_ring_interlock_generation_count( inner_diameter );

        // Curved ribs carry load from one four-point anchor generation to the next.
        linear_extrude( height = height, center = true )
            union() {
                for ( generation = [ 0 : generation_count - 1 ] )
                    technic_gear_reduced_ring_interlock_generation_2d(
                        anchor_radius = technic_gear_reduced_ring_interlock_anchor_radius( generation ),
                        phase = technic_gear_reduced_ring_interlock_phase( generation ),
                        width = width,
                        clip_radius = clip_radius
                    );
            }

        // A mathematical apex/tangency is not a robust structural joint.  Reuse
        // the source 4019 collar itself at every INTERNAL transfer generation.
        // The last apex terminates directly in the tooth-support rim and needs
        // no extra collar.
        if ( generation_count > 1 ) {
            for ( generation = [ 1 : generation_count - 1 ] )
                technic_gear_reduced_ring_interlock_joint_generation(
                    generation = generation, height = height
                );
        }
    }
}

/** Weight-relief coffer opening for one recursive semicircle generation.
 *
 * The opening follows the same outward half-circle construction as the
 * structural rib, but is inset by the source 4019 cell-wall thickness.  A
 * half-wall bridge is retained along the anchor chord.  The cutter is applied
 * only to the thin reduced web; full-height semicircle ribs remain untouched.
 */
module technic_gear_reduced_ring_coffer_generation_negative_2d(
    anchor_radius, phase, width, clip_radius
) {
    arc_radius = anchor_radius / sqrt( 2 );
    opening_radius = max( 0, arc_radius - width );
    chord_bridge = width / 2;
    opening_extent = opening_radius + width;

    if ( opening_radius > 0 ) {
        for ( quadrant = [ 0 : 3 ] ) {
            mid_phase = phase + 45 + 90 * quadrant;
            center = [
                arc_radius * cos( mid_phase ),
                arc_radius * sin( mid_phase )
            ];

            intersection() {
                circle( r = clip_radius );

                translate( center )
                    rotate( mid_phase )
                        intersection() {
                            circle( r = opening_radius );

                            // Keep a source-wall-derived bridge along the
                            // anchor chord; only the outward lobe is relieved.
                            translate( [ chord_bridge, -opening_extent ] )
                                square( [ opening_extent * 2, opening_extent * 2 ] );
                        }
            }
        }
    }
}

/** Through-holes cut only into the thin reduced web between curved ribs. */
module technic_gear_reduced_ring_coffer_openings_negative( height, inner_diameter ) {
    generation_count = technic_gear_reduced_ring_interlock_generation_count( inner_diameter );
    width = technic_gear_reduced_ring_interlock_width();
    clip_radius = inner_diameter / 2;

    if ( generation_count > 0 ) {
        linear_extrude( height = height + EXTENSION_FOR_DIFFERENCE, center = true )
            union() {
                for ( generation = [ 0 : generation_count - 1 ] )
                    technic_gear_reduced_ring_coffer_generation_negative_2d(
                        anchor_radius = technic_gear_reduced_ring_interlock_anchor_radius( generation ),
                        phase = technic_gear_reduced_ring_interlock_phase( generation ),
                        width = width,
                        clip_radius = clip_radius
                    );
            }
    }
}

/** Through-openings remain the invariant four-circle 4019 core.
 *
 * The scalable semicircles are positive full-height ribs.  Larger gears also
 * receive source-wall-inset coffer openings in the thin reduced web between
 * those ribs; the core four 4019 holes remain invariant.
 */
module technic_gear_reduced_ring_openings_negative( height, inner_diameter ) {
    inner_radius = technic_gear_reduced_ring_cell_inner_radius();
    center_radius = technic_gear_reduced_ring_cell_center_radius();

    for ( point = [
        [ center_radius, 0 ], [ -center_radius, 0 ],
        [ 0, center_radius ], [ 0, -center_radius ]
    ] ) {
        translate( [ point[0], point[1], 0 ] )
            cylinder( r = inner_radius, h = height + EXTENSION_FOR_DIFFERENCE, center = true );
    }
}

/**
 * Full-height 4019 open-side center support.
 *
 * The official face uses the axis-aligned octagonal envelope through
 * (±8,±4)/(±4,±8) LDU.  Its four diagonal lands carry the axle while the
 * open-side relief stays on the native 0°/90° axle phase.
 */
module technic_gear_reduced_ring_center_positive( height ) {
    axis = technic_gear_reduced_ring_center_outer_axis_ldu * technic_ldraw_unit_in_mm;
    chamfer = technic_gear_reduced_ring_center_outer_chamfer_ldu * technic_ldraw_unit_in_mm;
    points = [
        [ axis, chamfer ], [ chamfer, axis ], [ -chamfer, axis ], [ -axis, chamfer ],
        [ -axis, -chamfer ], [ -chamfer, -axis ], [ chamfer, -axis ], [ axis, -chamfer ]
    ];

    linear_extrude( height = height, center = true ) polygon( points = points );
}

/**
 * 4019 open-side axle relief.
 *
 * This is deliberately the same phase as the canonical reduced P1 entry
 * relief, but present on both native axle axes.  The slot width is exactly the
 * fitted axle-spline thickness: the relief therefore meets the axle arms
 * without rotating or widening the axle hole itself.  Its source-derived
 * 6-LDU half-length leaves the thin molded bridge before each round opening.
 */
module technic_gear_reduced_ring_open_axle_relief_negative( height ) {
    // The real 16T relief opens directly into all four circular holes.  Derive
    // its half-length from their 4 mm centre radius so the relief necessarily
    // overlaps the holes instead of stopping short of them.
    relief_length = 2 * technic_gear_reduced_ring_cell_center_radius();
    // Keep the canonical reduced P1 relief THICKNESS; only extend its length
    // until the rounded end opens into the four source 4019 circular holes.
    // This preserves the accepted reduced support appearance instead of
    // turning the center into one oversized cross-shaped void.
    relief_width = ( technic_axle_spline_thickness * technic_axle_interference_fit_ratio ) / 3;

    for ( angle = [ 0, 90 ] ) {
        rotate( [ 0, 0, angle ] )
            linear_extrude( height = height + EXTENSION_FOR_DIFFERENCE, center = true )
                technic_rounded_rectangle(
                    width = relief_length,
                    height = relief_width,
                    radius = relief_width / 2
                );
    }
}

/** 4019 reduced pattern: exact 16T primitive, scalable circular lattice. */
module technic_gear_reduced_ring_body(
    root_diameter, inner_diameter, web_height, ring_height, center_height
) {
    shell_count = technic_gear_reduced_ring_cellular_shell_count( inner_diameter );

    union() {
        if ( shell_count == 1 ) {
            // Freeze the accepted 16T construction: reduced web + source collars.
            technic_gear_webbed_ring_body(
                root_diameter = root_diameter, inner_diameter = inner_diameter,
                web_height = web_height, ring_height = ring_height
            );
            technic_gear_reduced_ring_collars_positive( height = ring_height, inner_diameter = inner_diameter );
        } else {
            // Source-faithful scaling: retain a thin REDUCED web beneath the
            // full-height overlapping circular collars.  The web fills only
            // accidental interstitial slivers; the explicit circular cutters
            // remain the sole through-relief pattern.  The reserved tooth rim
            // is still generated independently at full ring height.
            cylinder( d = inner_diameter, h = web_height, center = true );

            difference() {
                cylinder( d = root_diameter, h = ring_height, center = true );
                cylinder( d = inner_diameter, h = ring_height + EXTENSION_FOR_DIFFERENCE, center = true );
            }
            technic_gear_reduced_ring_cellular_lattice_positive(
                height = ring_height, inner_diameter = inner_diameter
            );
        }

        technic_gear_reduced_ring_center_positive( height = center_height );
    }
}

module _technic_gear_hollow_member_between( point_a, point_b, width, height ) {
	hull() {
		translate( [ point_a[0], point_a[1], 0 ] ) cylinder( d = width, h = height, center = true );
		translate( [ point_b[0], point_b[1], 0 ] ) cylinder( d = width, h = height, center = true );
	}
}

module _technic_gear_hollow_graph_members( nodes, edges, member_width, height ) {
	for ( edge = edges ) {
		_technic_gear_hollow_member_between(
			point_a = nodes[edge[0]], point_b = nodes[edge[1]],
			width = member_width, height = height
		);
	}
}

/** Local pads bind selected secondary holes/axles to the hollow graph. */
module _technic_gear_hollow_node_pads( nodes, member_width, height ) {
	for ( node = nodes ) {
		if ( node[2] == "pin" ) {
			translate( [ node[0], node[1], 0 ] )
				cylinder( d = max( member_width, technic_gear_pin_hole_outer_diameter ), h = height, center = true );
		} else if ( node[2] == "axle" ) {
			axle_wall_diameter = technic_axle_spline_width
				+ ( 2 * technic_pin_connector_shoulder_wall_thickness );
			translate( [ node[0], node[1], 0 ] )
				cylinder( d = max( member_width, axle_wall_diameter ), h = height, center = true );
		}
	}
}

module _technic_gear_hollow_hub_and_rim( hub_diameter, rim_inner_diameter, rim_outer_diameter, height ) {
	union() {
		cylinder( d = hub_diameter, h = height, center = true );
		difference() {
			cylinder( d = rim_outer_diameter, h = height, center = true );
			cylinder( d = rim_inner_diameter, h = height + EXTENSION_FOR_DIFFERENCE, center = true );
		}
	}
}

/**
 * CROSS-only orthogonal members.
 *
 * Do not reuse the generic hull/capsule graph member here: its circular end
 * caps neck the arm into the rim and create an inward structural radius at the
 * load-transfer point.  A plain LEGO-style cross carries its full one-brick
 * width into the tooth-support rim.  The outer cylinder clips only the remote
 * corners to the gear-root envelope; the arm-to-rim transition itself remains
 * straight and full width.
 */
module _technic_gear_hollow_cross_members( rim_outer_diameter, member_width, height ) {
	intersection() {
		cylinder( d = rim_outer_diameter, h = height, center = true );
		union() {
			cube( [ rim_outer_diameter, member_width, height ], center = true );
			cube( [ member_width, rim_outer_diameter, height ], center = true );
		}
	}
}

module technic_gear_hollow_cross_body(
	hub_diameter, rim_inner_diameter, rim_outer_diameter, height, member_width, nodes, edges
) {
	union() {
		_technic_gear_hollow_hub_and_rim( hub_diameter, rim_inner_diameter, rim_outer_diameter, height );
		_technic_gear_hollow_cross_members( rim_outer_diameter, member_width, height );
		_technic_gear_hollow_node_pads( nodes, member_width, height );
	}
}

module technic_gear_hollow_frame_body(
	hub_diameter, rim_inner_diameter, rim_outer_diameter, height, member_width, nodes, edges
) {
	union() {
		_technic_gear_hollow_hub_and_rim( hub_diameter, rim_inner_diameter, rim_outer_diameter, height );
		// FRAME is an extension of CROSS: keep the cardinal backbone continuously hub-to-rim.
		// Use the same member width as every square/diamond edge.
		_technic_gear_hollow_cross_members( rim_outer_diameter, member_width, height );
		_technic_gear_hollow_graph_members( nodes, edges, member_width, height );
		_technic_gear_hollow_node_pads( nodes, member_width, height );
	}
}

module technic_gear_hollow_ring_body(
	hub_diameter, rim_inner_diameter, rim_outer_diameter, height, member_width, nodes, edges
) {
	mid_radius = len( nodes ) >= 5 ? sqrt( nodes[1][0] * nodes[1][0] + nodes[1][1] * nodes[1][1] ) : 0;

	union() {
		_technic_gear_hollow_hub_and_rim( hub_diameter, rim_inner_diameter, rim_outer_diameter, height );
		_technic_gear_hollow_graph_members( nodes, edges, member_width, height );
		_technic_gear_hollow_node_pads( nodes, member_width, height );

		if ( mid_radius > member_width / 2 ) {
			difference() {
				cylinder( d = 2 * ( mid_radius + member_width / 2 ), h = height, center = true );
				cylinder( d = 2 * ( mid_radius - member_width / 2 ), h = height + EXTENSION_FOR_DIFFERENCE, center = true );
			}
		}
	}
}

/** WP08 double-only body dispatcher. Inputs are resolved by technic_gear(). */
module technic_gear_double_body_positive(
	resolved_body_topology, reduced_pattern, hollow_structure, root_diameter, inner_diameter, hub_diameter,
	gear_height, reduced_body_height, tooth_height, member_width = 0, nodes = [], edges = []
) {
	if ( resolved_body_topology == "solid" ) {
		technic_gear_double_filled_body( root_diameter = root_diameter, height = gear_height );
	} else if ( resolved_body_topology == "reduced" ) {
		if ( reduced_pattern == "ring" ) {
			technic_gear_reduced_ring_body(
				root_diameter = root_diameter, inner_diameter = inner_diameter,
				web_height = technic_gear_reduced_ring_web_height( gear_height ),
				ring_height = tooth_height, center_height = gear_height
			);
		} else {
			technic_gear_webbed_ring_body(
				root_diameter = root_diameter, inner_diameter = inner_diameter,
				web_height = reduced_body_height, ring_height = tooth_height
			);
		}
	} else if ( resolved_body_topology == "hollow" && len( nodes ) > 0 ) {
		if ( hollow_structure == "cross" ) {
			technic_gear_hollow_cross_body( hub_diameter, inner_diameter, root_diameter, gear_height, member_width, nodes, edges );
		} else if ( hollow_structure == "frame" ) {
			technic_gear_hollow_frame_body( hub_diameter, inner_diameter, root_diameter, gear_height, member_width, nodes, edges );
		} else if ( hollow_structure == "ring" ) {
			technic_gear_hollow_ring_body( hub_diameter, inner_diameter, root_diameter, gear_height, member_width, nodes, edges );
		}
	}
}

module technic_gear(
	axial_form = "double",
	teeth = 24,
	gear_height = undef,
	tooth_sections = "normal",
	bevel = "none",
	body_mode = "reduced",
	reduced_pattern = "classic",
	hollow_structure = undef,
	center = "axle",
	secondary_feature = "pin+axle",
	debug = false
) {
	assert( _technic_gear_value_in( axial_form, [ "single", "double" ] ), str( "invalid axial_form: ", axial_form ) );
	assert( is_num( teeth ) && teeth > 0 && teeth == floor( teeth ), str( "teeth must be a positive integer: ", teeth ) );
	assert( is_undef( gear_height ) || ( is_num( gear_height ) && gear_height > 0 ), str( "gear_height must be positive when specified: ", gear_height ) );
	assert( _technic_gear_value_in( tooth_sections, [ "normal", "stepped" ] ), str( "invalid tooth_sections: ", tooth_sections ) );
	assert( _technic_gear_value_in( bevel, [ "none", "single", "double" ] ), str( "invalid bevel: ", bevel ) );
	assert( _technic_gear_value_in( body_mode, [ "filled", "reduced", "hollow" ] ), str( "invalid body_mode: ", body_mode ) );
	assert( _technic_gear_value_in( reduced_pattern, [ "classic", "ring" ] ), str( "invalid reduced_pattern: ", reduced_pattern ) );
	assert( is_undef( hollow_structure ) || _technic_gear_value_in( hollow_structure, [ "cross", "frame", "ring" ] ), str( "invalid hollow_structure: ", hollow_structure ) );
	assert( _technic_gear_value_in( center, [ "axle", "pin" ] ), str( "invalid center: ", center ) );
	assert( _technic_gear_value_in( secondary_feature, [ "none", "pin", "axle", "pin+axle", "clutch_single", "clutch_dual" ] ), str( "invalid secondary_feature: ", secondary_feature ) );

	normal_height = technic_gear_normal_height( axial_form );
	requested_height = is_undef( gear_height ) ? normal_height : gear_height;
	effective_height = requested_height;
	effective_bevel = axial_form == "single" ? ( bevel == "double" ? "single" : bevel ) : ( bevel == "double" ? "double" : "none" );
	// WP09 owns stepped sections for the double, non-beveled path first.
	// Unsupported cross-feature combinations stay explicit fallbacks instead
	// of silently claiming stepped geometry that another bevel path replaces.
	effective_tooth_sections = tooth_sections == "stepped"
		&& axial_form == "double" && effective_bevel == "none" ? "stepped" : "normal";
	legacy_body_mode = axial_form == "double" ? "reduced" : "filled";
	// Do not substitute a reduced double body for an explicitly requested filled
	// or hollow topology. Unsupported double topologies stay visible as missing.
	effective_body_mode = axial_form == "double"
		? body_mode
		: body_mode == "hollow" ? "hollow" : legacy_body_mode;
	resolved_body_topology = axial_form == "double" ? technic_gear_double_body_topology( teeth, body_mode ) : "single";
	resolved_tooth_height = axial_form == "double" ? technic_gear_double_tooth_section_height( effective_height, resolved_body_topology ) : technic_gear_single_tooth_height( effective_height );
	tooth_section_records = technic_gear_tooth_section_records(
		teeth, effective_height, effective_tooth_sections, resolved_body_topology
	);
	effective_center = center;
	clutch_requested = axial_form == "double"
		&& ( secondary_feature == "clutch_single" || secondary_feature == "clutch_dual" );
	clutch_fits = clutch_requested
		? technic_gear_clutch_interface_fits( teeth, center, resolved_body_topology ) : false;
	effective_secondary_feature = axial_form == "double"
		? ( clutch_requested
			? ( clutch_fits ? secondary_feature : "none" )
			: technic_gear_secondary_effective_feature_resolved( teeth, secondary_feature, body_mode, hollow_structure ) )
		: "none";
	body_root_diameter = axial_form == "double" ? technic_gear_double_rim_outer_diameter( teeth ) : 0;
	body_inner_diameter = axial_form == "double"
		? ( resolved_body_topology == "reduced" && reduced_pattern == "ring"
			? technic_gear_reduced_ring_rim_inner_diameter( teeth )
			: resolved_body_topology == "hollow" && hollow_structure == "cross"
			? technic_gear_hollow_cross_rim_inner_diameter( teeth )
			: resolved_body_topology == "hollow" && hollow_structure == "frame"
			? technic_gear_hollow_frame_rim_inner_diameter( teeth )
			: technic_gear_double_rim_inner_diameter( teeth, resolved_body_topology ) )
		: 0;
	body_hub_diameter = axial_form == "double" ? technic_gear_double_hub_diameter( teeth, center, resolved_body_topology ) : 0;
	hollow_valid = axial_form == "double" && body_mode == "hollow"
		? technic_gear_hollow_structure_valid( teeth, hollow_structure, center, effective_secondary_feature )
		: false;
	hollow_member_width = hollow_valid
		? technic_gear_hollow_member_width( teeth, hollow_structure, center, effective_secondary_feature ) : 0;
	hollow_nodes = hollow_valid
		? technic_gear_hollow_structure_nodes( teeth, hollow_structure, center, effective_secondary_feature ) : [];
	hollow_edges = hollow_valid ? technic_gear_hollow_structure_edges( hollow_nodes, hollow_structure, teeth ) : [];
	height_state = "supported";
	tooth_sections_state = tooth_sections == effective_tooth_sections ? "supported" : "fallback";
	bevel_state = bevel == effective_bevel ? "supported" : "fallback";
	body_mode_state = axial_form == "double"
		? ( body_mode == "hollow" ? ( hollow_valid ? "supported" : "missing" ) : "supported" )
		: body_mode == "hollow" ? "missing" : ( body_mode == effective_body_mode ? "supported" : "fallback" );
	center_state = "supported";
	secondary_state = axial_form == "double"
		? ( clutch_requested
			? ( clutch_fits ? "supported" : "missing" )
			: ( secondary_feature == effective_secondary_feature ? "supported" : "partial" ) )
		: ( secondary_feature == "none" ? "supported" : "fallback" );
	hollow_effective = body_mode == "hollow" && hollow_valid ? hollow_structure : body_mode == "hollow" ? "none" : "inactive";
	hollow_state = body_mode == "hollow" ? ( hollow_valid ? "supported" : "missing" ) : "derived";
	hollow_reason = body_mode == "hollow"
		? ( hollow_valid ? "wp08-derived-hollow-structure" : ( is_undef( hollow_structure ) ? "hollow-structure-required" : "hollow-envelope-too-small" ) )
		: "body-not-hollow";

	_technic_gear_support_record( "axial_form", axial_form, axial_form, "supported", "legacy-path", debug );
	_technic_gear_support_record( "teeth", teeth, teeth, "supported", "legacy-path", debug );
	_technic_gear_support_record( "gear_height", requested_height, effective_height, height_state, is_undef( gear_height ) ? "normal-default" : "configured-height", debug );
	_technic_gear_support_record(
		"tooth_sections", tooth_sections, effective_tooth_sections, tooth_sections_state,
		tooth_sections_state == "supported"
			? ( effective_tooth_sections == "stepped" ? "wp09-derived-stepped-sections" : "legacy-normal" )
			: ( axial_form != "double" ? "stepped-single-deferred" : "stepped-bevel-combination-deferred" ),
		debug
	);
	_technic_gear_support_record( "bevel", bevel, effective_bevel, bevel_state, bevel_state == "supported" ? ( axial_form == "double" && effective_bevel == "double" ? "wp07-double-bevel" : axial_form == "single" && effective_bevel == "single" ? "wp11b-single-radial-bevel" : "normal-no-bevel" ) : "bevel-not-implemented", debug );
	_technic_gear_support_record(
		"body_mode", body_mode, effective_body_mode, body_mode_state,
		body_mode_state == "supported" ? ( axial_form == "double" ? "wp08-double-body-dispatcher" : "body-dispatcher" ) :
		body_mode_state == "missing" ? ( body_mode == "hollow" ? hollow_reason : "body-mode-not-implemented" ) :
		"body-mode-not-implemented",
		debug
	);
	_technic_gear_support_record(
		"reduced_pattern", reduced_pattern,
		body_mode == "reduced" ? reduced_pattern : "inactive",
		body_mode == "reduced" ? "supported" : "derived",
		body_mode == "reduced" && reduced_pattern == "ring" ? "wp13e-4019-cellular-i16-row-wise-growing-golf-relief" : "classic-reduced-pattern",
		debug
	);
	_technic_gear_support_record( "hollow_structure", hollow_structure, hollow_effective, hollow_state, hollow_reason, debug );
	_technic_gear_support_record( "center", center, effective_center, center_state, axial_form == "double" && center == "pin" ? "cross-interface-reuse" : "legacy-path", debug );
	_technic_gear_support_record(
		"secondary_feature", secondary_feature, effective_secondary_feature, secondary_state,
		secondary_state == "supported"
			? ( clutch_requested ? "wp10-fixed-outer-clutch-interface" : ( axial_form == "double" ? "wp06c-capacity" : "legacy-none" ) )
			: secondary_state == "partial" ? "geometry-capacity"
			: clutch_requested ? "clutch-interface-does-not-fit" : "secondary-feature-not-implemented",
		debug
	);

	if ( debug && axial_form == "double" ) {
		for ( section_index = [ 0 : len( tooth_section_records ) - 1 ] ) {
			section_record = tooth_section_records[ section_index ];
			echo( str(
				"TECHNIC_GEAR_TOOTH_SECTION|index=", section_index,
				"|pitch_diameter=", technic_gear_tooth_section_pitch_diameter( section_record ),
				"|height=", technic_gear_tooth_section_height( section_record ),
				"|z=", technic_gear_tooth_section_z( section_record )
			) );
		}

		echo( str(
			"TECHNIC_GEAR_AXIAL|gear_height=", effective_height,
			"|topology=", resolved_body_topology,
			"|tooth_height=", resolved_tooth_height,
			"|tooth_offset=", effective_height - resolved_tooth_height
		) );
		echo( str(
			"TECHNIC_GEAR_BODY|root_diameter=", body_root_diameter,
			"|inner_diameter=", body_inner_diameter,
			"|hub_diameter=", body_hub_diameter,
			"|member_width=", hollow_member_width,
			"|nodes=", len( hollow_nodes ),
			"|edges=", len( hollow_edges )
		) );

		if ( clutch_requested ) {
			clutch_depth = technic_gear_clutch_interface_depth( effective_height );
			echo( str(
				"TECHNIC_GEAR_CLUTCH|fits=", clutch_fits,
				"|faces=", technic_gear_clutch_face_count( secondary_feature ),
				"|depth=", clutch_depth,
				"|outer_radius=", technic_gear_clutch_interface_radius( teeth, resolved_body_topology ),
				"|inner_clearance=", technic_gear_clutch_inner_clearance_radius( center ),
				"|positive_bore=", technic_gear_clutch_positive_bore_radius(),
				"|positive_bore_gap=", technic_gear_clutch_positive_bore_gap( center ),
				"|z=", technic_gear_clutch_face_z_positions( secondary_feature, effective_height, clutch_depth )
			) );
		}
	}

	assert( technic_gear_axial_dimensions_valid( axial_form, effective_height, axial_form == "double" ? resolved_body_topology : undef ), str( "gear_height produces invalid axial dimensions: ", effective_height ) );
	assert( technic_gear_center_radial_clearance_valid( effective_center, axial_form, teeth ), str( "center connector lacks radial clearance: center=", effective_center, ", axial_form=", axial_form, ", teeth=", teeth ) );

	if ( axial_form == "double" ) {
		// A valid-but-unimplemented clutch request must remain visibly missing.
		// Do not substitute either an unclutched double gear or the single-form path.
		if ( !( clutch_requested && !clutch_fits ) ) {
			_technic_gear_double_sided_legacy(
				teeth = teeth, gear_height = effective_height, center = effective_center,
				body_mode = effective_body_mode, reduced_pattern = reduced_pattern, secondary_feature = effective_secondary_feature,
				resolved_body_topology = resolved_body_topology,
				resolved_tooth_height = resolved_tooth_height,
				tooth_sections = effective_tooth_sections, tooth_section_records = tooth_section_records,
				bevel = effective_bevel,
				body_root_diameter = body_root_diameter, body_inner_diameter = body_inner_diameter,
				body_hub_diameter = body_hub_diameter, hollow_structure = hollow_structure,
				hollow_member_width = hollow_member_width, hollow_nodes = hollow_nodes, hollow_edges = hollow_edges
			);
		}
	} else {
		_technic_gear_single_assembly( teeth = teeth, bevel = effective_bevel == "single", center_hole = effective_center, gear_height = effective_height, body_mode = effective_body_mode );
	}
}

/***
 * @function technic_gear_double_sided();
 * Generate a Technic-compatible double-sided spur gear.
 * @brief Technic, Gear [x] Tooth with [x] Axle Hole
 * Double-sided gears (as opposed to the one-sided gears sometimes called "half-gears").
 * Origin is at the center of the gear in all directions.
 *
 * ![A spur gear compatible with LEGO part #3648.](images/technic_gear_double_sided.png)
 *
 * **Part Support:**
 * - `part #3647`:  technic_gear_double_sided( teeth = 8, width = 1.5 ); // @todo Multiple issues.
 * - `part #3648`:  technic_gear_double_sided( teeth = 24 );
 * - `part #3549`:  technic_gear_double_sided( teeth = 40 );
 * - `part #10928`: technic_gear_double_sided( teeth = 8, width = 1.5 ); // @todo The teeth are not exactly right.
 * @param teeth *int* How many teeth should the gear have? The minimum reasonable value is probably X.
 * @param width *int* In multiples of the original gear width, how wide should it be? e.g., a width of 3 would generate a single gear with the same total width as three gears set side-by-side.
 */
module technic_gear_double_sided(
	teeth = 24,
	width = 1
) {
	technic_gear(
		axial_form = "double", teeth = teeth,
		gear_height = width * technic_gear_normal_height( "double" ),
		tooth_sections = "normal", bevel = "none", body_mode = "reduced",
		hollow_structure = undef, center = "axle", secondary_feature = "pin+axle"
	);
}

/**
 * Generate the positive normal-tooth solid shared by normal spur-based gear paths.
 *
 * This primitive pins the vendor involute call and owns only the minimum
 * tooth-root overlap required to connect the tooth solid to its owning body.
 * Body topology, center cuts, secondary connectors, placement, bevel cuts,
 * and stepped tooth sections remain outside this module.
 */
module technic_gear_normal_tooth_solid(
	teeth,
	height,
	bore_diameter,
	pitch_diameter = undef
) {
	include <lib/gears/gears.scad>;

	effective_pitch_diameter = is_undef( pitch_diameter )
		? technic_gear_pitch_diameter( teeth ) : pitch_diameter;
	tooth_module = effective_pitch_diameter / teeth;
	section_root_diameter = effective_pitch_diameter
		- 2 * tooth_module * ( 1 + 1 / 6 );

	translate( [ 0, 0, - ( height / 2 ) ] ) {
		spur_gear( modul = tooth_module, tooth_number = teeth, width = height, bore = bore_diameter, pressure_angle=20, optimized = false );
	};

	// The vendor gear leaves tiny gaps at the tooth-root corners. This ring is
	// the minimum positive overlap needed to connect those roots to the body.
	difference() {
		cylinder( d = section_root_diameter, h = height, center = true );
		cylinder( d = bore_diameter - ( EXTENSION_FOR_DIFFERENCE / 2 ), h = height + EXTENSION_FOR_DIFFERENCE, center = true );
	};
}

/** Compose all normal/stepped tooth sections from the one common tooth solid. */
module technic_gear_tooth_sections_solid( teeth, records, bore_diameter ) {
	for ( record = records ) {
		translate( [ 0, 0, technic_gear_tooth_section_z( record ) ] ) {
			technic_gear_normal_tooth_solid(
				teeth = teeth,
				height = technic_gear_tooth_section_height( record ),
				bore_diameter = bore_diameter,
				pitch_diameter = technic_gear_tooth_section_pitch_diameter( record )
			);
		}
	}
}

/**
 * Generate the subtraction solid for one exposed-face bevel on normal teeth.
 *
 * The taper is derived from the LDraw 20T bevel-tooth primitive: 3 radial
 * units over 6.5 axial units. The cutter removes nothing at the body-side
 * tooth plane and reaches its maximum radial depth at the exposed face.
 */
module technic_gear_single_bevel_cutter(
	teeth,
	height
) {
	bevel_radial_per_axial = 3 / 6.5;
	// The single bevel starts at the same body-side radial envelope owned
	// by the backing plate, not at the canonical module-1 double tip.
	tip_radius = technic_gear_single_body_diameter( teeth ) / 2;
	max_radial_removal = height * bevel_radial_per_axial;
	z_extension = EXTENSION_FOR_DIFFERENCE;
	outer_radius = tip_radius + max_radial_removal + EXTENSION_FOR_DIFFERENCE;
	inner_radius_body_side = tip_radius + ( z_extension * bevel_radial_per_axial );
	inner_radius_exposed_side = tip_radius - max_radial_removal - ( z_extension * bevel_radial_per_axial );

	translate( [ 0, 0, -( height / 2 ) - z_extension ] ) {
		difference() {
			cylinder( r = outer_radius, h = height + ( z_extension * 2 ) );
			cylinder(
				r1 = inner_radius_body_side,
				r2 = inner_radius_exposed_side,
				h = height + ( z_extension * 2 )
			);
		}
	}
}

/**
 * Provide the exact normal involute tooth crowns in 2D for radial sweeping.
 * The equations and involute helpers are the same pinned vendor equations used
 * by technic_gear_normal_tooth_solid(), avoiding an independently tuned tooth
 * profile.  A very small inward overlap derived from EXTENSION_FOR_DIFFERENCE
 * keeps the swept crown manifold with the full-height root/filler ring.
 */
module technic_gear_normal_tooth_crown_profile_2d( teeth, pitch_diameter = undef ) {
	include <lib/gears/gears.scad>;

	// Exact 20-degree, zero-helix profile equations used by the pinned vendor
	// spur_gear() call in technic_gear_normal_tooth_solid(). Double form keeps
	// module 1; single form supplies its approved derived pitch diameter.
	effective_pitch_diameter = is_undef( pitch_diameter )
		? technic_gear_pitch_diameter( teeth )
		: pitch_diameter;
	modul = effective_pitch_diameter / teeth;
	pressure_angle = 20;
	helix_angle = 0;
	d = modul * teeth;
	r = d / 2;
	alpha_spur = atan( tan( pressure_angle ) / cos( helix_angle ) );
	db = d * cos( alpha_spur );
	rb = db / 2;
	da = d + modul * 2;
	ra = da / 2;
	c = teeth < 3 ? 0 : modul / 6;
	df = d - 2 * ( modul + c );
	rf = df / 2;
	rho_ra = acos( rb / ra );
	rho_r = acos( rb / r );
	phi_r = grad( tan( rho_r ) - radian( rho_r ) );
	step = rho_ra / technic_gear_double_bevel_involute_steps;
	tau = 360 / teeth;
	tooth_width = ( 180 * ( 1 - clearance ) ) / teeth + 2 * phi_r;
	crown_overlap = EXTENSION_FOR_DIFFERENCE / 100;

	difference() {
		rotate( [ 0, 0, -phi_r - 90 * ( 1 - clearance ) / teeth ] ) {
			union() {
				for ( rot = [ 0 : tau : 360 ] ) {
					rotate( rot ) {
						polygon( concat(
							[ [ 0, 0 ] ],
							[ for ( rho = [ 0 : step : rho_ra ] ) polar_to_cartesian( ev( rb, rho ) ) ],
							[ polar_to_cartesian( ev( rb, rho_ra ) ) ],
							[ for ( rho = [ rho_ra : -step : 0 ] )
								polar_to_cartesian( [ ev( rb, rho )[0], tooth_width - ev( rb, rho )[1] ] ) ]
						) );
					}
				}
			}
		}

		// Remove the root circle while retaining a tiny positive overlap so the
		// swept crowns join the independently full-height root/filler ring.
		circle( r = max( 0, rf - crown_overlap ) );
	}
}

/**
 * Positive one-sided fixed-circle radial crown for a single bevel.
 *
 * The tangent handover is the body-side tooth plane. The crown then follows
 * the same fixed-radius law used by the accepted double bevel all the way to
 * the exposed face. The caller supplies the single-form derived pitch so the
 * body-side tooth tips remain exactly coincident with the backing plate.
 */
module technic_gear_single_radial_bevel_crown(
	teeth,
	height,
	pitch_diameter
) {
	segment_height = height / technic_gear_double_bevel_arc_segments;
	handover_z = -height / 2;
	handover_overlap = EXTENSION_FOR_DIFFERENCE / 100;
	arc_radius = technic_gear_single_bevel_arc_radius( height );

	translate( [ 0, 0, handover_z - handover_overlap ] ) {
		linear_extrude( height = handover_overlap * 2 ) {
			technic_gear_normal_tooth_crown_profile_2d(
				teeth = teeth, pitch_diameter = pitch_diameter
			);
		}
	}

	for ( segment = [ 0 : technic_gear_double_bevel_arc_segments - 1 ] ) {
		dz0 = segment * segment_height;
		dz1 = ( segment + 1 ) * segment_height;
		scale0 = technic_gear_radial_bevel_scale( teeth, pitch_diameter, dz0, arc_radius );
		scale1 = technic_gear_radial_bevel_scale( teeth, pitch_diameter, dz1, arc_radius );

		translate( [ 0, 0, handover_z + dz0 ] ) {
			linear_extrude( height = segment_height, scale = scale1 / scale0 ) {
				scale( [ scale0, scale0 ] ) {
					technic_gear_normal_tooth_crown_profile_2d(
						teeth = teeth, pitch_diameter = pitch_diameter
					);
				}
			}
		}
	}
}

/**
 * Complete positive single-bevel tooth/root solid.
 *
 * The root/filler ring stays full height. Only the involute crowns follow the
 * one-sided fixed-circle continuation, tangent to the full body-side tooth
 * profile and clipped at the actual exposed face.
 */
module technic_gear_single_bevel_tooth_solid(
	teeth,
	height,
	bore,
	pitch_diameter
) {
	tooth_module = pitch_diameter / teeth;
	tip_radius = technic_gear_tooth_tip_diameter_for_pitch( teeth, pitch_diameter ) / 2;
	root_diameter = pitch_diameter - 2 * tooth_module * ( 1 + 1 / 6 );
	clip_extension = EXTENSION_FOR_DIFFERENCE / 100;

	intersection() {
		union() {
			difference() {
				cylinder( d = root_diameter, h = height, center = true );
				cylinder(
					d = bore - ( EXTENSION_FOR_DIFFERENCE / 2 ),
					h = height + EXTENSION_FOR_DIFFERENCE,
					center = true
				);
			}

			technic_gear_single_radial_bevel_crown(
				teeth = teeth, height = height, pitch_diameter = pitch_diameter
			);
		}

		cylinder(
			r = tip_radius + clip_extension,
			h = height,
			center = true
		);
	}
}

/**
 * Generate one mirrored half of the fixed-circle radial crown continuation.
 * Every segment endpoint derives only from technic_gear_double_bevel_arc_scale().
 */
module technic_gear_double_bevel_radial_side(
	teeth,
	tooth_height,
	upper = true
) {
	arc_run = technic_gear_double_bevel_arc_run();
	segment_height = arc_run / technic_gear_double_bevel_arc_segments;
	handover_overlap = EXTENSION_FOR_DIFFERENCE / 100;

	module _positive_side() {
		// Finite overlap at the tangent handover avoids a zero-thickness CSG seam.
		translate( [ 0, 0, technic_gear_double_bevel_center_half_height - handover_overlap ] ) {
			linear_extrude( height = handover_overlap * 2 ) {
				technic_gear_normal_tooth_crown_profile_2d( teeth = teeth );
			}
		}

		for ( segment = [ 0 : technic_gear_double_bevel_arc_segments - 1 ] ) {
			dz0 = segment * segment_height;
			dz1 = ( segment + 1 ) * segment_height;
			scale0 = technic_gear_double_bevel_arc_scale( teeth, dz0 );
			scale1 = technic_gear_double_bevel_arc_scale( teeth, dz1 );

			translate( [ 0, 0, technic_gear_double_bevel_center_half_height + dz0 ] ) {
				linear_extrude(
				height = segment_height,
				scale = scale1 / scale0
				) {
					scale( [ scale0, scale0 ] ) {
						technic_gear_normal_tooth_crown_profile_2d( teeth = teeth );
					}
				}
			}
		}
	}

	if ( upper ) {
		_positive_side();
	} else {
		mirror( [ 0, 0, 1 ] ) {
			_positive_side();
		}
	}
}

/**
 * Complete positive double-bevel tooth/root solid.
 *
 * The full-height root ring is not radially scaled.  The centered normal tooth
 * owns exactly 2.40 mm before the fixed-circle crown takes over.  Continuation
 * is generated to the fixed reference face and the actual requested height is
 * established only by the final symmetric clipping volume.
 */
module technic_gear_double_bevel_tooth_solid(
	teeth,
	height,
	bore
) {
	tip_radius = technic_gear_tip_diameter( teeth ) / 2;
	root_diameter = technic_gear_root_diameter( teeth );
	clip_extension = EXTENSION_FOR_DIFFERENCE / 100;

	intersection() {
		union() {
			// Full-height tooth-root/filler ring: never scaled by the radial law.
			difference() {
				cylinder( d = root_diameter, h = height, center = true );
				cylinder( d = bore - ( EXTENSION_FOR_DIFFERENCE / 2 ), h = height + EXTENSION_FOR_DIFFERENCE, center = true );
			}

			// Short centered normal involute tooth: fixed 2.40 mm total height.
			technic_gear_normal_tooth_solid(
				teeth = teeth,
				height = 2 * technic_gear_double_bevel_center_half_height,
				bore_diameter = bore
			);

			technic_gear_double_bevel_radial_side(
				teeth = teeth, tooth_height = height, upper = true
			);
			technic_gear_double_bevel_radial_side(
				teeth = teeth, tooth_height = height, upper = false
			);
		}

		// Horizontal top/bottom clipping plus the normal un-beveled tip radius.
		cylinder(
			r = tip_radius + clip_extension,
			h = height,
			center = true
		);
	}
}

/**
 * Generate the symmetric two-face bevel cutter for normal double-form teeth.
 *
 * Each exposed face reuses the approved WP03B single-face cutter only over
 * the source-derived face depth, preserving a straight central tooth land.
 */
module technic_gear_double_bevel_cutter(
	teeth,
	height
) {
	bevel_depth = technic_gear_double_bevel_face_depth( height );
	bevel_center_offset = ( height / 2 ) - ( bevel_depth / 2 );

	translate( [ 0, 0, bevel_center_offset ] ) {
		technic_gear_single_bevel_cutter( teeth = teeth, height = bevel_depth );
	}

	mirror( [ 0, 0, 1 ] ) {
		translate( [ 0, 0, bevel_center_offset ] ) {
			technic_gear_single_bevel_cutter( teeth = teeth, height = bevel_depth );
		}
	}
}

module _technic_gear_double_sided_legacy(
	teeth = 24,
	gear_height = technic_gear_normal_height( "double" ),
	center = "axle",
	body_mode = "reduced",
	reduced_pattern = "classic",
	secondary_feature = "pin+axle",
	resolved_body_topology = "reduced",
	resolved_tooth_height = technic_gear_double_reduced_tooth_section_height( technic_gear_normal_height( "double" ) ),
	tooth_sections = "normal",
	tooth_section_records = [],
	bevel = "none",
	body_root_diameter = undef,
	body_inner_diameter = undef,
	body_hub_diameter = undef,
	hollow_structure = undef,
	hollow_member_width = 0,
	hollow_nodes = [],
	hollow_edges = []
) {
	include <lib/gears/gears.scad>;

	desired_gear_axle_reinforcement_thickness = gear_height;
	desired_pin_wall_thickness = technic_gear_double_secondary_wall_height( gear_height );
	// A reduced body needs only the historical local boss-height bore because
	// the surrounding web is thinner.  Full-height solid/hollow bodies own
	// material through H, so their requested pin holes must cut through H too.
	desired_pin_cutout_height = resolved_body_topology == "reduced"
		? desired_pin_wall_thickness : gear_height;
	desired_gear_tooth_thickness = resolved_tooth_height;
	tooth_bore_diameter = body_root_diameter - ( EXTENSION_FOR_DIFFERENCE / 2 );

	// Resolve the combined station registry once. Both boolean operands consume
	// this exact value so center and secondary geometry cannot drift.
	station_body_topology = resolved_body_topology == "reduced" && reduced_pattern == "ring" ? "solid" : resolved_body_topology;
	axle_records = technic_gear_axle_station_records( teeth, center, secondary_feature, body_mode, station_body_topology, hollow_structure );

	// Preserve the accepted WP05 nested body boolean ownership.
	difference() {
		union() {
			difference() {
				union() {
					technic_gear_double_body_positive(
						resolved_body_topology = resolved_body_topology,
						reduced_pattern = reduced_pattern,
						hollow_structure = hollow_structure,
						root_diameter = body_root_diameter,
						inner_diameter = body_inner_diameter,
						hub_diameter = body_hub_diameter,
						gear_height = gear_height,
						reduced_body_height = technic_gear_double_reduced_body_height( gear_height ),
						tooth_height = resolved_tooth_height,
						member_width = hollow_member_width,
						nodes = hollow_nodes,
						edges = hollow_edges
					);

					// Solid bodies already contain the local pin wall; hollow bodies build
					// derived node pads for selected stations.  Only the thin reduced web
					// still needs the legacy positive pin-wall operand.
					if ( resolved_body_topology == "reduced" ) {
						technic_gear_secondary_pins_positive(
							teeth = teeth, secondary_feature = secondary_feature,
							height = desired_pin_wall_thickness
						);
					}
				}

				technic_gear_secondary_pins_negative(
					teeth = teeth, secondary_feature = secondary_feature,
					height = desired_pin_cutout_height,
					body_mode = body_mode, hollow_structure = hollow_structure
				);
			}

			if ( bevel == "double" ) {
				technic_gear_double_bevel_tooth_solid(
					teeth = teeth,
					height = desired_gear_tooth_thickness,
					bore = tooth_bore_diameter
				);
			} else if ( tooth_sections == "stepped" ) {
				technic_gear_tooth_sections_solid(
					teeth = teeth, records = tooth_section_records,
					bore_diameter = tooth_bore_diameter
				);
			} else {
				technic_gear_normal_tooth_solid(
					teeth = teeth,
					height = desired_gear_tooth_thickness,
					bore_diameter = tooth_bore_diameter
				);
			}

			technic_gear_place_axle_stations(
				records = axle_records, height = desired_gear_axle_reinforcement_thickness,
				operand = "positive"
			);
		}

		technic_gear_place_axle_stations(
			records = axle_records, height = desired_gear_axle_reinforcement_thickness,
			operand = "negative"
		);

		// 4019 keeps the canonical reduced P1 center support/relief alignment.
		// Its four cardinal circular openings reshape that shared support instead
		// of replacing it with a bespoke center primitive.
		if ( resolved_body_topology == "reduced" && reduced_pattern == "ring" ) {
			if ( technic_gear_reduced_ring_shell_count_from_inner_diameter( body_inner_diameter ) == 1 ) {
				// Preserve the exact accepted-looking 4019 one-shell Boolean path.
				technic_gear_reduced_ring_open_axle_relief_negative( height = gear_height );
				technic_gear_reduced_ring_openings_negative( height = gear_height, inner_diameter = body_inner_diameter );
			} else {
				// Large patterns cut one selected circular relief field through both
				// the full-height collars and the thin reduced web.
				union() {
					technic_gear_reduced_ring_open_axle_relief_negative( height = gear_height );
					technic_gear_reduced_ring_cellular_openings_negative(
						height = gear_height, inner_diameter = body_inner_diameter
					);
				}
			}
		}

		if ( secondary_feature == "clutch_single" || secondary_feature == "clutch_dual" ) {
			clutch_depth = technic_gear_clutch_interface_depth( gear_height );
			clutch_radius = technic_gear_clutch_interface_radius( teeth, resolved_body_topology );
			clutch_inner_clearance = technic_gear_clutch_inner_clearance_radius( center );
			clutch_profile = technic_gear_clutch_profile_points( teeth, gear_height, resolved_body_topology );
			clutch_face_z = technic_gear_clutch_face_z_positions( secondary_feature, gear_height, clutch_depth );

			technic_gear_place_clutch_interfaces(
				face_z_positions = clutch_face_z,
				profile_points = clutch_profile,
				inner_clearance_radius = clutch_inner_clearance,
				interface_radius = clutch_radius,
				depth = clutch_depth
			);
		}

		// Pin center remains on the accepted WP04 path and is not an axle record.
		if ( center == "pin" ) {
			technic_gear_center_negative(
				center = "pin", height = desired_gear_axle_reinforcement_thickness
			);
		}
	}

	if ( center == "pin" ) {
		technic_gear_center_positive(
			center = "pin", axial_form = "double",
			reinforcement_height = desired_gear_axle_reinforcement_thickness
		);
	}
}

/***
 * @function technic_gear_single_sided();
 * Generate a single-sided gear, sometimes called a half-gear.
 * @brief Technic, Gear [x] Tooth Bevel
 * Origin is centered at the bottom of the gear (the non-toothed side).
 *
 * ![A single-sided gear, compatible with LEGO part #6589.](images/technic_gear_single_sided.png)
 *
 * **Part Support:**
 * - `part #6589`:  technic_gear_single_sided();
 * - `part #32198`: technic_gear_single_sided( teeth = 20 );
 * - `part #87407`: technic_gear_single_sided( teeth = 20, center_hole = "pin" );
 * @param teeth *int* How many teeth should the gear have? The minimum reasonable value is probably 10.
 * @param bevel *bool* Should the gear teeth be beveled?
 * @param center_hole *string* What connector should the center hole be compatible with? Supported values are "axle" and "pin".
 */
module technic_gear_single_sided( teeth = 12, bevel = true, center_hole = "axle" ) {
	technic_gear(
		axial_form = "single", teeth = teeth, gear_height = technic_gear_normal_height( "single" ),
		tooth_sections = "normal", bevel = bevel ? "single" : "none", body_mode = "filled",
		hollow_structure = undef, center = center_hole, secondary_feature = "none"
	);
}

module _technic_gear_single_assembly( teeth = 12, bevel = true, center_hole = "axle", gear_height = technic_gear_normal_height( "single" ), body_mode = "filled" ) {
	lip_height = technic_gear_single_lip_height( gear_height );
	base_height = technic_gear_single_base_height( gear_height );
	tooth_height = technic_gear_single_tooth_height( gear_height );
	gear_diameter = technic_gear_single_body_diameter( teeth );
	hub_diameter = technic_gear_single_hub_diameter( teeth, center_hole );
	center_pin_height = technic_height_in_mm;
	center_pin_shoulder = true;
	center_pin_z = lip_height + center_pin_height / 2;

	difference() {
		union() {
			technic_gear_single_lip_solid(
				outer_diameter = technic_gear_12_tooth_lip_outer_diameter,
				inner_diameter = technic_gear_12_tooth_lip_inner_diameter,
				height = lip_height
			);

			translate( [ 0, 0, lip_height ] ) {
				technic_gear_single_body_solid(
					gear_diameter = gear_diameter, hub_diameter = hub_diameter,
					base_height = base_height, tooth_height = tooth_height
				);
			}

			// The teeth. Non-bevel single gears use the ordinary shared involute
			// solid. Beveled single gears use a positive one-sided fixed-circle
			// crown, tangent to the same approved body-side tooth envelope.
			translate( [ 0, 0, lip_height + base_height + ( tooth_height / 2 ) ] ) {
				if ( bevel ) {
					technic_gear_single_bevel_tooth_solid(
						teeth = teeth,
						height = tooth_height,
						bore = hub_diameter - ( EXTENSION_FOR_DIFFERENCE / 2 ),
						pitch_diameter = technic_gear_single_tooth_pitch_diameter( teeth )
					);
				} else {
					// Preserve the predecessor CSG grouping for the no-bevel control.
					difference() {
						technic_gear_normal_tooth_solid(
							teeth = teeth,
							height = tooth_height,
							bore_diameter = hub_diameter - ( EXTENSION_FOR_DIFFERENCE / 2 ),
							pitch_diameter = technic_gear_single_tooth_pitch_diameter( teeth )
						);
					}
				}
			}

			if ( center_hole == "pin" ) {
				translate( [ 0, 0, center_pin_z ] ) {
					technic_gear_place_center_pin(
						height = center_pin_height,
						shoulder = center_pin_shoulder,
						operand = "positive"
					);
				}
			}
		}

		if ( center_hole == "axle" ) {
			// Single-form axle center stays on the general compatible axle primitive.
			technic_axle_hole( height = 1 );
		} else if ( center_hole == "pin" ) {
			translate( [ 0, 0, center_pin_z ] ) {
				technic_gear_place_center_pin(
					height = center_pin_height,
					shoulder = center_pin_shoulder,
					operand = "negative"
				);
			}
		}
	}
}

/***
 * @function technic_pin();
 * Generate a Technic-compatible pin.
 * @brief Technic, Pin [with Friction Ridges]
 * Origin is centered at the bottom of the pin.
 *
 * ![A pin compatible with LEGO part #2780.](images/technic_pin.png)
 *
 * **Part Support:**
 * - `part #2780`:  technic_pin( top_length = 1, top_friction = true, bottom_length = 1, bottom_friction = true );
 * - `part #3673`:  technic_pin( top_length = 1, top_friction = false, bottom_length = 1, bottom_friction = false );
 * - `part #4274`:  technic_pin( top_length = 1, stud = true );
 * - `part #4459`:  technic_pin( top_length = 1, top_friction = true, bottom_length = 1, bottom_friction = true ); // This part has long friction ridges along the length of the pin, which isn't supported yet.
 * - `part #6558`:  technic_pin( top_length = 2, top_friction = true, bottom_length = 1, bottom_friction = true );
 * - `part #6628`:  technic_pin( bottom_type = "tow ball" );
 * - `part #32054`: technic_pin( top_length = 2, bottom_length = 1, bottom_type = "bush" );
 * - `part #32138`: technic_pin( multiplier = 2 );
 * - `part #32556`: technic_pin( top_length = 2, top_friction = false, bottom_length = 1, bottom_friction = false );
 * - `part #65098`: technic_pin( multiplier = 2, squared_pin_holes = true );
 * - `part #77765`: technic_pin( top_length = 3, top_friction = false, bottom_length = 0, bottom_friction = false );
 * - `part #80477`: technic_pin( bottom_length = 2, bottom_type = "tow ball" );
 * - `part #89678`: technic_pin( top_length = 1, top_friction = true, bottom_type = "stud" );
 * @param top_length *float* How long is the pin on the top?
 * @param top_friction *bool* Should the top part have friction ridges?
 * @param bottom_type *string* What should the bottom of the pin be? "pin", "tow ball", "stud", or "bush"
 * @param bottom_length *float* How long is the pin on the bottom?
 * @param bottom_friction *bool* Should the bottom part have friction ridges?
 * @param multiplier *int* How many pin sets should there be?
 * @param axle_hole *bool* If a multiple pin, should there be an axle hole?
 */
module technic_pin(
	top_length = 1,
	top_friction = true,
	bottom_length = 1,
	bottom_friction = true,
	multiplier = 1,
	axle_holes = true,
	squared_pin_holes = false,
	bottom_type = "pin"
) {
	let ( bottom_length_in_mm = ( bottom_type == "stud" ? stud_height : ( bottom_type == "tow ball" ? bottom_length * technic_pin_tow_ball_total_length : bottom_length * technic_height_in_mm ) ) ) {
		if ( multiplier > 1 ) {
			translate( [ 0, 0, bottom_length_in_mm ] ) {
				difference() {
					union() {
						// The pin halves.
						for ( i = [ 1 : multiplier ] ) {
							translate( [ ( i - 1 ) * technic_pin_multiple_offset, 0, technic_pin_multiple_center_width ] ) technic_pin_half( length = top_length, friction = top_friction, squared_pin_holes = squared_pin_holes );

							if ( bottom_type == "stud" ) {
								translate( [ ( i - 1 ) * technic_pin_multiple_offset, 0, -bottom_length_in_mm] ) technic_hollow_stud();
							} else if ( bottom_type == "tow ball" ) {
								translate( [ ( i - 1 ) * technic_pin_multiple_offset, 0, -bottom_length_in_mm] ) technic_tow_ball( length = bottom_length );
							} else if ( bottom_type == "bush" ) {
								translate( [ ( i - 1 ) * technic_pin_multiple_offset, 0, 0 ] ) rotate( a = 180, v = [ 0, 1, 0 ] ) technic_bush( height = bottom_length, stud_cutouts = false );
							} else {
								translate( [ ( i - 1 ) * technic_pin_multiple_offset, 0, 0 ] ) rotate( [ 0, 180, 0 ] ) technic_pin_half( length = bottom_length, friction = bottom_friction, squared_pin_holes = squared_pin_holes );
							}
						}

						// The bottom lip that separates the pins from the center section.
						hull() {
							cylinder( d = technic_pin_outer_diameter + ( technic_pin_multiple_center_lip_overhang * 2 ), h = technic_pin_multiple_center_lip_thickness );
							translate( [ technic_pin_multiple_offset * ( multiplier - 1 ), 0, 0 ] ) {
								cylinder( d = technic_pin_outer_diameter + ( technic_pin_multiple_center_lip_overhang * 2 ), h = technic_pin_multiple_center_lip_thickness );
							}
						}

						// The top lip that separates the pins from the center section.
						translate( [ 0, 0, technic_pin_multiple_center_width - technic_pin_multiple_center_lip_thickness ] ) {
							hull() {
								cylinder( d = technic_pin_outer_diameter + ( technic_pin_multiple_center_lip_overhang * 2 ), h =technic_pin_multiple_center_lip_thickness );
								translate( [ technic_pin_multiple_offset * ( multiplier - 1 ), 0, 0 ] ) cylinder( d = technic_pin_outer_diameter + ( technic_pin_multiple_center_lip_overhang * 2 ), h =technic_pin_multiple_center_lip_thickness );
							}
						}

						// The body of the center section.
						hull() {
							cylinder( d = technic_pin_outer_diameter, h = technic_pin_multiple_center_width );
							translate( [ technic_pin_multiple_offset * ( multiplier - 1 ), 0, 0 ] ) cylinder( d = technic_pin_outer_diameter, h = technic_pin_multiple_center_width );
						}

						if ( axle_holes ) {
							// Generate the support area around the axle holes.
							for ( i = [ 1 : multiplier - 1 ] ) {
								translate( [ ( ( i - .5 ) * technic_pin_multiple_offset ), 0, technic_pin_multiple_center_width / 2 ] ) {
									rotate( [ 90, 0, 0 ] ) {
										intersection() {
											// 1.5 is an arbitrary choice that is correct enough, assuming the cross-section size of an axle can't be customized and the width of the center of a multiple-pin can't be customized.
											scale( [ 1.5, 1.5, 1 ] ) {
												technic_axle_hole( height = technic_pin_outer_diameter + EXTENSION_FOR_DIFFERENCE );
											}

											// Only allow the axle support to extend as far as the edge of the lip of the center section.
											cube( [ technic_pin_multiple_center_width, technic_pin_multiple_center_width, technic_pin_outer_diameter + ( 2 * technic_pin_multiple_center_lip_overhang ) ], center = true );
										}
									}
								}
							}

						}
					}

					if ( axle_holes ) {
						// Remove the axle holes.
						for ( i = [ 1 : multiplier - 1 ] ) {
							translate( [ ( ( i - .5 ) * technic_pin_multiple_offset ), 0, technic_pin_multiple_center_width / 2 ] ) {
								rotate( [ 90, 0, 0 ] ) {
									translate( [ 0, 0, 0 ] ) {
										technic_axle_hole( height = technic_pin_outer_diameter + EXTENSION_FOR_DIFFERENCE );
									}
								}
							}
						}
					}
				}
			}
		} else {
			// Only shift down to merge the two halves' collars if there is actually a bottom pin half to merge with.
			translate( [ 0, 0, ( bottom_length_in_mm ) - ( bottom_type == "pin" && bottom_length > 0 ? technic_pin_collar_thickness : 0 ) ] ) {
				// The top half of the pin.
				technic_pin_half( length = top_length, friction = top_friction, squared_pin_holes = squared_pin_holes );

				if ( bottom_type == "stud" ) {
					// The stud.
					translate( [ 0, 0, -bottom_length_in_mm ] ) technic_hollow_stud();
				} else if ( bottom_type == "tow ball" ) {
					// The tow ball.
					translate( [ 0, 0, -bottom_length_in_mm ] ) technic_tow_ball( length = bottom_length );
				} else if ( bottom_type == "bush" ) {
					// The bush.
					rotate( a = 180, v = [ 0, 1, 0 ] ) technic_bush( height = bottom_length, stud_cutouts = false );
				} else {
					// The bottom half of the pin.
					translate( [ 0, 0, technic_pin_collar_thickness ] ) rotate( [ 0, 180, 0 ] ) technic_pin_half( length = bottom_length, friction = bottom_friction, squared_pin_holes = squared_pin_holes );
				}
			}
		}
	}
}

/***
 * @function technic_pin_connector();
 * Generate a Technic-compatible pin connector.
 * @brief Technic, Liftarm Thick 1 x 1 (Spacer)
 * Origin is centered at the bottom center of the pin connector.
 *
 * ![A pin connector compatible with LEGO part #18654.](images/technic_pin_connector.png)
 *
 * **Part Support:**
 * - `part #18654`: technic_pin_connector( length = 1 ); // equivalent to a 1-hole beam
 * @param length *int* The length of the pin connector in "studs." FWIW, LEGO only makes these in length 1.
 */
module technic_pin_connector(
	length = 1, // The length in studs. An axle of length 2 will be the same length as a 2-stud brick.
) {
	translate( [ 0, 0, ( technic_height_in_mm * length ) / 2 ] ) {
		union() {
			// The hollow cylinder that forms the outer wall.
			difference() {
				cylinder( h = technic_height_in_mm * length, d = technic_pin_connector_outer_diameter, center = true );
				cylinder( h = technic_height_in_mm * length + EXTENSION_FOR_DIFFERENCE, r = ( technic_pin_connector_outer_diameter / 2 ) - technic_pin_connector_shoulder_wall_thickness, center = true );
			};

			difference() {
				cylinder( h = ( technic_height_in_mm * length ) - ( technic_pin_connector_shoulder_depth * 2 ), d = technic_pin_connector_outer_diameter, center = true );
				cylinder( h = ( technic_height_in_mm * length ) - ( technic_pin_connector_shoulder_depth * 2 ) + EXTENSION_FOR_DIFFERENCE, r = ( technic_hole_diameter / 2 ), center = true );
			};
		};
	}
}

/**
 * @param float length How long, in Technic units, is the pin half?
 * @param bool friction Whether it should have friction ridges.
 * @param bool squared_pin_holes Apparently "squared" pin holes mean the slits at the end of the pin are rotated 90º from their usual orientation.
 */
module technic_pin_half(
	length = 1,
	friction = true,
	squared_pin_holes = false
) {
	if ( length > 0 ) { // A "half pin" just has a 1.7mm extension (2.5 including the collar) of the pin body past the collar.
		difference() {
			union() {
				// Pin body
				if ( length == 0.5 ) {
					cylinder( d = technic_pin_outer_diameter, h = 1.8 + technic_pin_collar_thickness ); // 1.8 matches stud height
				} else {
					cylinder( d = technic_pin_outer_diameter, h = length * technic_height_in_mm );
				}

				// Pin collar.
				cylinder( d = technic_pin_collar_diameter, h = technic_pin_collar_thickness );

				if ( length > ( 0.5 ) ) {
					// Pin lip
					translate( [ 0, 0, ( length * technic_height_in_mm ) - technic_pin_lip_thickness ] ) {
						cylinder( d = technic_pin_lip_diameter, h = technic_pin_lip_thickness );
					}

					if ( friction ) {
						// End lines
						intersection() {
							// The cylinders that define the areas vertically where the friction lines will appear
							union() {
								for ( idx = [ 0 : 1 : length ] ) {
									// Center.
									translate( [ 0, 0, ( idx * 2 * technic_height_in_mm ) / 2 - ( technic_pin_friction_vertical_length / 2 )  ] ) {
										cylinder( d = technic_pin_outer_diameter + ( 2 * technic_pin_friction_thickness ), h = technic_pin_friction_vertical_length );
									}
								}
							}

							// The cubes that define the areas radially where the friction lines will appears.
							union() {
								rotate( [0, 0, 45 ] ) translate( [0, 0, ( length * technic_height_in_mm ) / 2 ] ) {
									cube( [ technic_pin_friction_width, technic_pin_outer_diameter * 2, length * technic_height_in_mm ], center = true );
								}

								rotate( [0, 0, 135 ] ) translate( [0, 0, ( length * technic_height_in_mm ) / 2 ] ) {
									cube( [ technic_pin_friction_width, technic_pin_outer_diameter * 2, length * technic_height_in_mm ], center = true );
								}
							}
						}

						// The radial friction lines
						if ( length > 1 ) {
							for ( idx = [ 1 : 1 : length - 1 ] ) {
								translate( [ 0, 0, ( idx * 2 * technic_height_in_mm ) / 2 ] ) {
									cylinder( d = technic_pin_outer_diameter + ( 2 * technic_pin_friction_thickness ), h = technic_pin_friction_width, center = true );
								}
							}
						}
					}
				}
			};

			// Remove the center of the pin.
			translate( [ 0, 0, -EXTENSION_FOR_DIFFERENCE ] ) cylinder( d = technic_pin_inner_diameter, h = ( length * technic_height_in_mm ) + ( 2 * EXTENSION_FOR_DIFFERENCE ) );

			if ( length >= 1 ) { // Half-pins don't get slits and slots.
				// Remove the slit at the top that makes the pin end flex.
				rotate( [ 0, 0, squared_pin_holes ? 90 : 0 ] ) {
					translate( [ 0, technic_pin_lip_diameter, length * technic_height_in_mm ] ) {
						rotate( [ 90, 0, 0 ] ) {
							linear_extrude( technic_pin_lip_diameter * 2 ) {
								technic_rounded_rectangle( width = technic_pin_slit_width, height = technic_pin_slit_length * 2, radius = technic_pin_slit_width / 2 );
							}
						}
					}
				}
			}

			// Remove the slot across the center of the pin.
			if ( length > 1 ) {
				for ( idx = [ 1 : 1 : length - 1 ] ) {
					translate( [ 0, 0, ( idx * 2 * technic_height_in_mm ) / 2 ] ) {
						rotate( [ 90, 0, idx % 2 == 0 ? 0 : 90 ] ) {
							translate( [ 0, 0, - technic_pin_lip_diameter ] ) {
								linear_extrude( technic_pin_lip_diameter * 2 ) {
									technic_rounded_rectangle( width = technic_pin_slot_width, height = technic_pin_slot_length, radius = technic_pin_slot_width / 2 );
								}
							}
						}
					}
				}
			}
		}
	}
}

/***
 * @function technic_tire();
 * Generate a Technic-compatible tire.
 * @brief Tyre
 * @todo Tread pattern.
 * @todo Inner band
 *
 * ![A tire connector compatible with LEGO part #89201.](images/technic_tire.png)
 *
 * @param tread_width *float* Width of the tire tread.
 * @param diameter *float* Outer diameter of the tire.
 * @param tread_thickness *float* Thickness of the tire tread.
 */
module technic_tire(
	tread_width = 14,
	diameter = 24,
	tread_thickness = 3
) {
	linear_extrude( tread_width ) {
		difference() {
			circle( d = diameter );
			circle( d = diameter - ( tread_thickness * 2 ) );
		}
	}
}

/***
 * @function technic_wheel();
 * Generate a Technic-compatible wheel (also referred to as rims).
 * @brief Wheel
 * @todo Fake studs.
 * @todo spokes aren't curved downward.
 * @todo Multiple grooves.
 *
 * ![A wheel compatible with LEGO part #20896.](images/technic_wheel.png)
 *
 * @param diameter *float* The diameter of the wheel.
 * @param width *float* The width of the wheel, across where the tread would lie.
 * @param center_groove *bool* Whether it has a center groove for holding a tire in place.
 * @param hole_type *string* Is the center hole for an "axle" or a "pin"?
 * @param spoke_count *int* How many spokes should it have?
 * @param spoke_style *string* What style of spoke does it have? Only "double" is supported now.
 */
module technic_wheel( diameter = 1, width = 1, center_groove = true, hole_type = "axle", spoke_count = 6, spoke_style = "double" ) {
	difference() {
		union() {
			difference() {
				// The bulk of the wheel.
				cylinder( d = diameter, h = width );

				// Remove the inset portions on either face.
				translate( [ 0, 0, -EXTENSION_FOR_DIFFERENCE / 2 ] ) cylinder( d = diameter - ( wheel_wall_thickness * 2 ), h = wheel_face_inset + EXTENSION_FOR_DIFFERENCE );
				translate( [ 0, 0, width - wheel_face_inset + ( EXTENSION_FOR_DIFFERENCE / 2 ) ] ) cylinder( d = diameter - ( wheel_wall_thickness * 2 ), h = wheel_face_inset + EXTENSION_FOR_DIFFERENCE );

				// Remove the center groove.
				if ( center_groove ) {
					translate( [ 0, 0, ( width / 2 ) - ( wheel_center_groove_width / 2 ) ] ) {
						difference() {
							cylinder( d = diameter + EXTENSION_FOR_DIFFERENCE, h = wheel_center_groove_width );
							cylinder( d = diameter - wheel_center_groove_depth, h = wheel_center_groove_width );
						}
					}
				}
			}

			// Add any support around the center hole.
			if ( hole_type == "axle" ) {
				cylinder( d = technic_pin_connector_outer_diameter, h = width );
			} else if ( hole_type == "pin" ) {
				technic_pin_connector( length = width / technic_height_in_mm );
			}

			// Remove
			difference() {
				translate([ 0, 0, width - wheel_face_inset ] ) {
					intersection() {
						// Add the spokes.
						if ( spoke_count > 0 ) {
							for ( i = [ 1 : spoke_count ] ) {
								rotate( [ 0, 0, ( 360 / spoke_count ) * i ] ) {
									translate( [ 0, -wheel_spoke_width / 2, 0 ] ) {
										difference() {
											cube( [ diameter, wheel_spoke_width, wheel_face_inset ] );
											translate( [ 0, wheel_spoke_edge_width, 0 ] ) cube( [ diameter, wheel_spoke_width - ( 2 * wheel_spoke_edge_width ), wheel_face_inset + EXTENSION_FOR_DIFFERENCE ] );
										}
									}
								}
							}
						}

						// But only keep the part of the spokes that are inside the wheel.
						cylinder( d = diameter, h = wheel_face_inset );
					}

				}

				// Remove the spoke parts that cross into the center hole.
				cylinder( d = technic_pin_connector_outer_diameter, h = width + EXTENSION_FOR_DIFFERENCE );
			}

		}

		// Remove the center hole.
		if ( hole_type == "axle" ) {
			technic_axle_hole( height = width );
		} else if ( hole_type == "pin" ) {
			translate( [ 0, 0, -EXTENSION_FOR_DIFFERENCE / 2 ] ) cylinder( d = technic_pin_connector_outer_diameter - ( 2 * technic_pin_connector_wall_thickness ), h = width + EXTENSION_FOR_DIFFERENCE );
		}
	}
}

/***
 * @function technic_worm_gear();
 * Generate a Technic-compatible worm gear.
 * @brief Technic, Gear Worm Screw
 *
 * ![A worm gear compatible with LEGO part #4716.](images/technic_worm_gear.png)
 *
 * **Part Support:**
 * - `part #4716`:  technic_worm_gear( height = 2, width = 3 );                    // 10mm wide, 16mm tall
 * - `part #27938`: technic_worm_gear( height = 1, width = 4 );                    // 13.5mm wide, 8mm tall
 * - `part #32905`: technic_worm_gear( height = 2, width = 3, opening = "axle2" ); // 10mm wide, 15.7mm tall
 * @param height *float* The height of the gear, in Technic units.
 * @param width *int* The width of the gear, in some unknown units. The two real-world Technic worm gears seem to be roughly multiples of 3.5mm (3x and 4x), and values outside of 3-5 don't really work.
 * @param opening *string* Whether the opening should be axle shaped, or the half-axle/half-circle shape that some new gears use. "axle" or "axle2"
 */
module technic_worm_gear( height = 2, width = 3, opening = "axle" ) {
	include <lib/gears/gears.scad>;

	// This is BS, but it works for values 1 through 5
	lead_angle = 102.37 - 106.1667 * width + 44.55417 * width^2 - 8.333333 * width^3 + 0.5758333 * width^4;

	difference() {
		// These parameters appear to be correct, but I can't guarantee that they are.
		worm( modul = 1, thread_starts = 1, length = technic_height_in_mm * height, bore = 0, lead_angle = lead_angle, pressure_angle = 30 );

		// Remove the axle hole.
		technic_axle_hole( height = height );

		// Remove a little indented circle around the axle at each end.
		translate( [ 0, 0, -EXTENSION_FOR_DIFFERENCE ] ) cylinder( d = technic_pin_connector_outer_diameter, h = technic_worm_gear_end_inset + EXTENSION_FOR_DIFFERENCE );
		translate( [ 0, 0, technic_height_in_mm * height - technic_worm_gear_end_inset ] ) cylinder( d = technic_pin_connector_outer_diameter, h = technic_worm_gear_end_inset + EXTENSION_FOR_DIFFERENCE );
	}
}

/**
 * Utility modules. None of these produce an entire Technic-compatible piece on their own.
 */

/**
 * Generate a rounded rectangle.
 */
module technic_rounded_rectangle( width = 1, height = 1, radius = 0.1 ) {
	hull() {
		// Position a circle to act as each rounded corner of the axle.
		translate( [ -( width / 2 ) + radius,  ( height / 2 ) - radius, 0 ] ) circle( r = radius );
		translate( [  ( width / 2 ) - radius,  ( height / 2 ) - radius, 0 ] ) circle( r = radius );
		translate( [  ( width / 2 ) - radius, -( height / 2 ) + radius, 0 ] ) circle( r = radius );
		translate( [ -( width / 2 ) + radius, -( height / 2 ) + radius, 0 ] ) circle( r = radius );
	}
}

module technic_axle_hole( height = 1 ) {
	scale( [ technic_axle_interference_fit_ratio, technic_axle_interference_fit_ratio, technic_axle_interference_fit_ratio ] ) {
		// By default, the axle hole will begin at the origin and build up.
		// We want it to be centered on the part, which is centered at height * technic_height_in_mm / 2.
		// So first move it up to that location, and then move it down half of its length.
		translate( [ 0, 0, ( height * technic_height_in_mm / 2 ) - ( height * 2 * technic_height_in_mm ) / 2 ] ) {
			technic_axle( length = height * 2 );
		}
	}
}

module technic_gear_wide_axle_hole( height, center_of_multiple = false ) {
	technic_axle_hole( height = height );

	scale( [ technic_axle_interference_fit_ratio, technic_axle_interference_fit_ratio, technic_axle_interference_fit_ratio ] ) {
		// The cross-opening for the axle fit is as wide as the widest edges of the pin holes. ~12.75
		linear_extrude( height = height + EXTENSION_FOR_DIFFERENCE, center = true ) {
			technic_rounded_rectangle(
				width = technic_axle_spline_thickness * technic_axle_interference_fit_ratio,
				height = technic_gear_axle_slot_length * ( center_of_multiple ? 0.7 : 1 ),
				radius = ( technic_axle_spline_thickness * technic_axle_interference_fit_ratio ) / 2
			);
		}
	}
}

module technic_hollow_stud() {
	linear_extrude( stud_height ) {
		difference() {
			circle( d = stud_outer_diameter );
			circle( d = stud_inner_diameter );
		}
	}
}

module technic_tow_ball( length = 1 ) {
	// I don't have a tow ball piece longer than length 1, but I'm assuming it's just a multiple of the original length. @todo
	translate( [ 0, 0, technic_tow_ball_diameter / 2 ] ) {
		sphere( d = technic_tow_ball_diameter );
		cylinder( h = ( length * technic_pin_tow_ball_total_length ) - ( technic_tow_ball_diameter / 2 ), d = technic_pin_tow_ball_neck_diameter );
	}
}

module technic_stud_cutouts( height = 1, diameter = stud_diameter ) {
	translate( [ 0, 0, -EXTENSION_FOR_DIFFERENCE / 2 ] ) {
		union () {
			translate( [ -0.5 * stud_spacing, -0.5 * stud_spacing, 0 ] )cylinder( d = diameter, h = height * technic_height_in_mm + EXTENSION_FOR_DIFFERENCE );
			translate( [ -0.5 * stud_spacing, 0.5 * stud_spacing, 0 ] ) cylinder( d = diameter, h = height * technic_height_in_mm + EXTENSION_FOR_DIFFERENCE );
			translate( [ 0.5 * stud_spacing, -0.5 * stud_spacing, 0 ] ) cylinder( d = diameter, h = height * technic_height_in_mm + EXTENSION_FOR_DIFFERENCE );
			translate( [ 0.5 * stud_spacing, 0.5 * stud_spacing, 0 ] ) cylinder( d = diameter, h = height * technic_height_in_mm + EXTENSION_FOR_DIFFERENCE );
		}
	}
}
