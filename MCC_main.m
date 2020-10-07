%% 5R5 EP2 Q4 and Q6
% Modified (Burland's) Cam Clay

% Strategy: model everything in effective stress
% To impose undrained shear, implose e2 = e3 = -0.5 e1, gammas = 0

close all;
clearvars;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input these values before running Initialise_MCC

% Material properties
kappa = 0.05;
lambda = 0.20;
nu = 0.20; % Only used in elastic
phics = 33.5 * pi() / 180; % Critical state friction angle

patm = 100;
vatm = 2.12;

% State variables: Initial conditions
vstart = vatm; % specific volume at start, dimensionless 2.12
pstart = patm;
pc = pstart; % kPa
s = [100 99.9 99.9 0 0 0]'; % kPa. Note dqds will blow up if s1==s2==s3 at start

% Targets
pcompact = 400;
pswell = 100;

% Iteration setting
destep = 1e-5; % Absolute strain, dimensionless. Strain step.

% End of things to set before running Initialise_MCC
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Initialise_MCC;
Update_State_MCC;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do whatever you want here with the soil

% The Save_State routine also creates the storage variables 
% if they don't already exist
Impose_Strain_MCC;
Update_State_MCC;
%
% Isotropically compress
while (p < pcompact)
    % Try to impose some strain increment
    de = destep .* [1 1 1 0 0 0]';

    Impose_Strain_MCC;
    Update_State_MCC;

    pt = p;
    u = 0;
    
    Save_State;
end

ti %Print ti

% Isotropically swell
while (p > pswell)
    % Try to impose some strain increment
    de = -destep .* [1 1 1 0 0 0]';

    Impose_Strain_MCC;
    Update_State_MCC;
    
    pt = p;
    u = 0;
    
    Save_State;
end

tiStartShear = ti

%% Undrained shear to failure
for eq = 0:destep:0.2
    de = destep .* [1 -0.5 -0.5 0 0 0]'; 
    
    Impose_Strain_MCC;
    Update_State_MCC;
    
    pt = pswell + q / 3; % Total stress
    u = pt - p;
    
    Save_State;
end
%%
% Plot the results
figure(901);
semilogx(ResultsStruct.p, ResultsStruct.v);
xlabel('p (kPa, log scale)');
ylabel('v');

figure(902);
plot(ResultsStruct.pc);
title('pc');

figure(903);
hold all;
plot(ResultsStruct.p, ResultsStruct.q);
plot(ResultsStruct.pt, ResultsStruct.q);
xlabel('p (kPa)');
ylabel('q (kPa)');
legend('Effective stress', 'Total stress');
strcat('Peak excess pore pressure: ', num2str(max(ResultsStruct.pt - ResultsStruct.p)))
strcat('Ultimate excess pore pressure: ', num2str(ResultsStruct.pt(end) - ResultsStruct.p(end)))
strcat('Peak shear strength: ', num2str(max(ResultsStruct.q)/2))
strcat('Residual shear strength: ', num2str(ResultsStruct.q(end)/2))

figure(913);
plot(ResultsStruct.e(:,1) - ResultsStruct.e(tiStartShear,1), ResultsStruct.u);
xlabel('Axial strain');
ylabel('Excess pore pressure (kPa)');

figure(904);
plot(ResultsStruct.e(:,1) - ResultsStruct.e(tiStartShear,1), ResultsStruct.q);
xlabel('Axial strain');
ylabel('q (kPa)');

figure(905);
plot(ResultsStruct.s(:,2));
title('s2');

figure(906);
hold on;
plot(ResultsStruct.F);
plot(ResultsStruct.ndF);
legend('F', 'ndF');

figure(907);
hold on;
plot(ResultsStruct.v);
plot(ResultsStruct.vCSL);
legend('v', 'vCSL');