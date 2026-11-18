import three;
import graph3;

real render_size = 200; 
size(render_size);

real tgt_size = 2000; 
real scale_ = tgt_size / render_size;

currentprojection=orthographic(5,25,-20, up=Z, target=(0,0,0), center=false, zoom=4.5, showtarget=true, viewportshift=(1.1,-1.8));
//currentlight.background=opacity(0.0);

// Enable proper surface rendering
settings.render=16;

// Function to calculate intersection points of 3 spheres
triple[] intersect3spheres(triple c1, real r1, triple c2, real r2, triple c3, real r3) {
    triple[] result;
    
    // Find points that are distance r1 from c1, r2 from c2, and r3 from c3
    // This involves solving a system of 3 sphere equations
    
    // Vector from c1 to c2
    triple d = c2 - c1;
    real dnorm = length(d);
    triple ex = d / dnorm;
    
    // Vector from c1 to c3, component perpendicular to ex
    triple i_vec = c3 - c1;
    real i = dot(ex, i_vec);
    triple ey_temp = i_vec - i * ex;
    real eynorm = length(ey_temp);
    if (eynorm < 0.0001) return result; // Collinear centers
    triple ey = ey_temp / eynorm;
    
    triple ez = cross(ex, ey);
    
    real j = dot(ey, i_vec);
    
    // Solve for intersection point coordinates
    real x = (r1*r1 - r2*r2 + dnorm*dnorm) / (2*dnorm);
    real y = (r1*r1 - r3*r3 + i*i + j*j - 2*i*x) / (2*j);
    real z2 = r1*r1 - x*x - y*y;
    
    if (z2 < 0) return result; // No intersection
    
    real z = sqrt(z2);
    
    // Two intersection points (if z != 0)
    triple p1 = c1 + x*ex + y*ey + z*ez;
    triple p2 = c1 + x*ex + y*ey - z*ez;
    
    result.push(p1);
    if (abs(z) > 0.0001) result.push(p2);
    
    return result;
}

// Define the intersection point at origin
triple P = (0,0,0);

// Define sphere centers
triple C1 = (2.0,0,0);
triple C2 = (0.75,2,0);
triple C3 = (-1.5,1.5,1.5);
triple C4 = (1.5,1.5,1.5);
triple CE = (-10, -10, -10);
//triple C1 = (2.0,0,0);
//triple C2 = (0,1.5,0);
//triple C3 = (0,0,2.5);
//triple C4 = (-1.5,-1.5,-1.5);


// Sphere radii - each equals the distance from center to origin
real r1 = length(C1 - P);
real r2 = length(C2 - P);
real r3 = length(C3 - P);
real r4 = length(C4 - P);
real rE = length(CE - P);

// Material settings for spheres (CMYK colors)
material sphere1 = material(diffusepen=cyan+opacity(0.3), emissivepen=gray(0.1));
material sphere2 = material(diffusepen=magenta+opacity(0.3), emissivepen=gray(0.1));
material sphere3 = material(diffusepen=yellow+opacity(0.3), emissivepen=gray(0.1));
material sphere4 = material(diffusepen=gray+opacity(0.3), emissivepen=gray(0.1));
material sphereE = material(purple,shininess=0.3);


// Draw the spheres with transparency
draw(shift(C1)*scale3(r1)*unitsphere, sphere1);
draw(shift(C2)*scale3(r2)*unitsphere, sphere2);
draw(shift(C3)*scale3(r3)*unitsphere, sphere3);
draw(shift(C4)*scale3(r4)*unitsphere, sphere4);
draw(shift(CE)*scale3(rE)*unitsphere, sphereE);


// Intersection between sphere 1 and 2 (cyan + magenta = blue)
triple n12 = unit(C2-C1);
real d12 = length(C2-C1);
real a12 = (r1^2 - r2^2 + d12^2)/(2*d12);
triple center12 = C1 + a12*n12;
real radius12 = sqrt(r1^2 - a12^2);
draw(circle(center12, radius12, n12), opacity(0.2)+blue+linewidth(2/scale_) );

// Intersection between sphere 1 and 3 (cyan + yellow = green)
triple n13 = unit(C3-C1);
real d13 = length(C3-C1);
real a13 = (r1^2 - r3^2 + d13^2)/(2*d13);
triple center13 = C1 + a13*n13;
real radius13 = sqrt(r1^2 - a13^2);
draw(circle(center13, radius13, n13), opacity(0.2)+green+linewidth(2/scale_));

// Intersection between sphere 1 and 4 (cyan + black = cyan)
triple n14 = unit(C4-C1);
real d14 = length(C4-C1);
real a14 = (r1^2 - r4^2 + d14^2)/(2*d14);
triple center14 = C1 + a14*n14;
real radius14 = sqrt(r1^2 - a14^2);
draw(circle(center14, radius14, n14), opacity(0.2)+cyan+linewidth(2/scale_));

// Intersection between sphere 2 and 3 (magenta + yellow = red)
triple n23 = unit(C3-C2);
real d23 = length(C3-C2);
real a23 = (r2^2 - r3^2 + d23^2)/(2*d23);
triple center23 = C2 + a23*n23;
real radius23 = sqrt(r2^2 - a23^2);
draw(circle(center23, radius23, n23), opacity(0.2)+red+linewidth(2/scale_));

// Intersection between sphere 2 and 4 (magenta + black = magenta)
triple n24 = unit(C4-C2);
real d24 = length(C4-C2);
real a24 = (r2^2 - r4^2 + d24^2)/(2*d24);
triple center24 = C2 + a24*n24;
real radius24 = sqrt(r2^2 - a24^2);
draw(circle(center24, radius24, n24), opacity(0.2)+magenta+linewidth(2/scale_));

// Intersection between sphere 3 and 4 (yellow + black = yellow)
triple n34 = unit(C4-C3);
real d34 = length(C4-C3);
real a34 = (r3^2 - r4^2 + d34^2)/(2*d34);
triple center34 = C3 + a34*n34;
real radius34 = sqrt(r3^2 - a34^2);
draw(circle(center34, radius34, n34), opacity(0.2)+yellow+linewidth(2/scale_));

// Calculate and draw 3-sphere intersection points

// Spheres 1,2,3 (C,M,Y) → black
triple[] p123 = intersect3spheres(C1, r1, C2, r2, C3, r3);
for (int i = 0; i < p123.length; ++i) {
    dot(p123[i], black+linewidth(6/scale_));
}

// Spheres 1,2,4 (C,M,K) → blue-black
triple[] p124 = intersect3spheres(C1, r1, C2, r2, C4, r4);
for (int i = 0; i < p124.length; ++i) {
    dot(p124[i], blue+black+linewidth(6/scale_));
}

// Spheres 1,3,4 (C,Y,K) → green-black
triple[] p134 = intersect3spheres(C1, r1, C3, r3, C4, r4);
for (int i = 0; i < p134.length; ++i) {
    dot(p134[i], green+black+linewidth(6/scale_));
}

// Spheres 2,3,4 (M,Y,K) → red-black
triple[] p234 = intersect3spheres(C2, r2, C3, r3, C4, r4);
for (int i = 0; i < p234.length; ++i) {
    dot(p234[i], red+black+linewidth(6/scale_));
}

// Calculate 4-sphere intersection at origin (C+M+Y+K → white)
dot(P, white+linewidth(10/scale_));

// Calculate 4-sphere intersection at origin (C+M+Y+K → white)
dot(P, white+linewidth(10/scale_));

// Draw lines from centers to origin P
draw(C1--P, cyan+dashed+linewidth(2/scale_));
draw(C2--P, magenta+dashed+linewidth(2/scale_));
draw(C3--P, yellow+dashed+linewidth(2/scale_));
draw(C4--P, black+dashed+linewidth(2/scale_));

// Draw the center points of each sphere
dot(C1, cyan+black+linewidth(8/scale_));
dot(C2, magenta+black+linewidth(8/scale_));
dot(C3, yellow+black+linewidth(8/scale_));
dot(C4, black+linewidth(8/scale_));

// clipping 
//pair min = currentpicture.min(identity());
//pair max = currentpicture.max(identity());
//clip(currentpicture, box(min, max));