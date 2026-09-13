use <../../candidate/Technic.scad>;
$fn = 16;
technic_gear(
    axial_form = "double",
    teeth = 8,
    body_mode = "filled",
    center = "axle",
    secondary_feature = "none",
    center_construction = "integral",
    bottom_end = "axle",
    top_end = "axle",
    bottom_end_length = 2,
    top_end_length = 2
);
