%% Script to initialise an Modified Cam Clay calculation
% Initialise_MCC.m

% Initialise
e = [0 0 0 0 0 0]'; % strain, dimensionless
v = vstart;

% Computational constants: isotropic elastic
De_nu = [[1-nu nu nu; nu 1-nu nu; nu nu 1-nu] zeros(3); zeros(3) (((1-2*nu)/2).*eye(3))]; 
De_nu = (1/((1 + nu) * (1 - 2 * nu))) .* De_nu;

% Computational constants: Modified Cam Clay
dpds = [1/3 1/3 1/3 0 0 0]';
M = 6 * sin(phics) / (3 - sin(phics));

% Initialise with an increment of zero so that s and e updating won't break
ds = [0 0 0 0 0 0]';
de = [0 0 0 0 0 0]';
