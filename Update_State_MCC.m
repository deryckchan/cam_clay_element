%% Update_State_MCC.m

% Update strains and stresses based on most recent calculation, if any
e = e + de;
s = s + ds;
v = vstart * (1 - e(1) - e(2) - e(3)); % Compress is positive in e but large is positive in v

% Derived state variables
p = (s(1) + s(2) + s(3)) / 3;
q = max(s(1:3)) - min(s(1:3));
% dpds is a constant
% dqds = (3 / 2 / q) .* (s + s.*[0 0 0 1 1 1]' - p.*[1 1 1 0 0 0]');

% Derived state variables: Elastic
Ke = v * p / kappa;
Ee = 3 * Ke * (1 - 2 * nu);
De = Ee .* De_nu;