# 3DDoubleBodyFlows
revisiting 3D panel codes for double body conditions - especially as relevant for infinite frequency added mass

## Presently
This file merely computes the double body flow around a sphere, using the method of images to enforce a 0 potential gradient, no wave condition at what would be the free surface.  In this way, the flow is actually deeply submerged.  This is similar, in this condition, to the 0 frequency (infinite period) solution to the 3d radiation problems of a 3D radiation-diffraction solver.

Next, we will need to enforce the antisymmetric image condition to mimic the infinite frequency (0 period) solution to the 3D radiation problem.  

Of course, this is a steady code, with forward speed.  This is a totally diffeent boundary condition than any of the radiation potentials solved for in 3D-diffraction.  Nevertheless, much of the programming is similar.  This is the point of the exercise.