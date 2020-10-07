# cam_clay_element

This is a Matlab script to simulate an element of soil using Burland's Modified Cam Clay constitutive model.

To run it, download the whole tree of scripts, edit the input parameters in MCC_main.m, then run MCC_main.m which will call the other scripts.

This script was developed in the same context as, but independently of, hansinimal & Krishna Kumar's [camclay repo](https://github.com/hansinimal/camclay). The main differences are that this repo focused more on vectorization, and used a different iterative method to handle the collapse of residual strength after dry-side yield.

This script can handle both strain increments (input strain increment and current state, output new stress state) and stress increments (input stress increment and current state, output new strain state) using the same underlying formulation of the D (stiffness) matrix.

This series of Matlab files were originally created in connection with the *Advanced numerical methods in geo-mechanics* training course for postgraduate researchers at Cambridge University.
