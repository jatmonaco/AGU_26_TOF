import three;
import graph3;
import solids;

size(400);
currentprojection=perspective(90,20,50);

// Enable proper surface rendering
settings.render=8;

// make invisible background
//currentlight.background=opacity(0.0);
//pen background=nullpen;

// Function to calculate intersection points of 3 ellipsoids
triple[] intersect3ellipsoids(triple f1, triple f2a, triple Pa, 
                                triple f1b, triple f2b, triple Pb,
                                triple f1c, triple f2c, triple Pc) {
    triple[] result;
    // This is complex - for now return empty
    // In practice, numerical methods would be needed
    return result;
}

// Shared focal point at origin
triple F1 = (0,0,0);

// Define the second focal points for each ellipsoid
triple F2_1 = (6.0,-2.0,0);
triple F2_2 = (12.0,-3,0);
triple F2_3 = (8,2,0);
triple F2_4 = (10,2,0);

// Point P that all ellipsoids pass through
triple P = (2, 4, 2);

// Ground plane
pen groundPen = gray(0.9);
pen meshPen = black + opacity(1);
surface groundPlane = shift(-4, -9, 0) * scale(20, 15, 0) * unitplane;
draw(groundPlane, groundPen, meshpen=meshPen);

// For each ellipsoid, calculate major axis length (2a)
// Since ellipse passes through P and has foci at F1 and F2_i:
// 2a = distance(P, F1) + distance(P, F2_i)
real a1 = (length(P - F1) + length(P - F2_1)) / 2;
real a2 = (length(P - F1) + length(P - F2_2)) / 2;
real a3 = (length(P - F1) + length(P - F2_3)) / 2;
real a4 = (length(P - F1) + length(P - F2_4)) / 2;

// Calculate focal distances (c = distance from center to focus)
real c1 = length(F2_1 - F1) / 2;
real c2 = length(F2_2 - F1) / 2;
real c3 = length(F2_3 - F1) / 2;
real c4 = length(F2_4 - F1) / 2;

// Calculate minor axis lengths: b^2 = a^2 - c^2
real b1 = sqrt(a1^2 - c1^2);
real b2 = sqrt(a2^2 - c2^2);
real b3 = sqrt(a3^2 - c3^2);
real b4 = sqrt(a4^2 - c4^2);

// Centers of ellipsoids (midpoint between foci)
triple C1 = (F1 + F2_1) / 2;
triple C2 = (F1 + F2_2) / 2;
triple C3 = (F1 + F2_3) / 2;
triple C4 = (F1 + F2_4) / 2;

// Create transformation matrices for each ellipsoid
// The major axis points from F1 to F2
triple axis1 = unit(F2_1 - F1);
triple axis2 = unit(F2_2 - F1);
triple axis3 = unit(F2_3 - F1);
triple axis4 = unit(F2_4 - F1);

// Function to create rotation matrix that aligns Z-axis with given axis
transform3 alignToAxis(triple axis) {
    triple z = (0,0,1);
    if (length(axis - z) < 0.01) return identity4;
    if (length(axis + z) < 0.01) return rotate(180, (1,0,0));
    
    triple v = cross(z, axis);
    real s = length(v);
    real c = dot(z, axis);
    
    return rotate(atan2(s, c) * 180 / pi, v);
}


material ellipse1 = material(diffusepen=cyan+opacity(0.3), emissivepen=gray(0.2));
material ellipse2 = material(diffusepen=magenta+opacity(0.3), emissivepen=gray(0.2));
material ellipse3 = material(diffusepen=yellow+opacity(0.3), emissivepen=gray(0.2));
material ellipse4 = material(diffusepen=black+opacity(0.3), emissivepen=gray(0.2));

// Draw the ellipsoids
surface s1 = shift(C1) * alignToAxis(axis1) * scale(b1, b1, a1) * unitsphere;
surface s2 = shift(C2) * alignToAxis(axis2) * scale(b2, b2, a2) * unitsphere;
surface s3 = shift(C3) * alignToAxis(axis3) * scale(b3, b3, a3) * unitsphere;
surface s4 = shift(C4) * alignToAxis(axis4) * scale(b4, b4, a4) * unitsphere;

draw(s1, ellipse1);
draw(s2, ellipse2);
draw(s3, ellipse3);
draw(s4, ellipse4);

// Draw point P (where all 4 ellipsoids meet) - C+M+Y+K → white
dot(P, white+linewidth(10));

// Draw the shared focal point at origin
dot(F1, blue+black+linewidth(12));

// Draw the second focal points for each ellipsoid
//dot(F2_1, cyan+black+linewidth(8));
surface rx1 = shift(F2_1) * scale(0.25, 0.25, 0.45) * unitsolidcone;
draw(rx1, cyan);
//dot(F2_2, magenta+black+linewidth(8));
surface rx2 = shift(F2_2) * scale(0.25, 0.25, 0.45) * unitsolidcone;
draw(rx2, magenta);
//dot(F2_3, yellow+black+linewidth(8));
surface rx3 = shift(F2_3) * scale(0.25, 0.25, 0.45) * unitsolidcone;
draw(rx3, yellow);
//dot(F2_4, black+linewidth(8));
surface rx4 = shift(F2_4) * scale(0.25, 0.25, 0.45) * unitsolidcone;
draw(rx4, black);

// Draw lines from second focal points to P
draw(F2_1--P, cyan+linewidth(2));
draw(F2_2--P, magenta+linewidth(2));
draw(F2_3--P, yellow+linewidth(2));
draw(F2_4--P, black+linewidth(2));

// Draw lines from origin to P
draw(F1--P, blue+dashed+linewidth(2));