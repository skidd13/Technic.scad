use <../../candidate/Technic.scad>;
$fn = 16;
technic_gear(
    axial_form = "double",
    teeth = 24,
    body_mode = "filled",
    center = "axle",
    secondary_feature = "none",
    center_construction = "integral",
    bottom_end = "pin",
    top_end = "pin",
    bottom_end_length = 2,
    top_end_length = 2
);
