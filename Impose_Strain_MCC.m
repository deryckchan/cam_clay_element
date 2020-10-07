%% Strain stepping: set de before running this script; it gives ds
% Impose_Strain_MCC

% Calculate F. If F >= 0 already then update pc and do plastic flow
F = q*q/M/M - pc*p + p*p;
vCSL = vatm - (lambda - kappa) * log(2) - lambda * log(p / patm);
vCSLmarginp = 0.002; % Numerical hack to prevent too much flip-flopping between wet and dry side for no good reason
vCSLmarginm = -0.001;
% Derived state variables: Plastic

if F > 0    
    % Split dry side and wet side!
    if (v > vCSL + vCSLmarginp) % Dry side. Bubble is expanding, just expand bubble
        % update pc based on new values of p and q at the start of this stage
        pc = q*q/M/M/p + p;
    elseif (v < vCSL - vCSLmarginm)
        % Wet side. Bubble is contracting, use volume
        pc = patm * exp((vatm - v - kappa * log(p / patm)) / (lambda - kappa));
    end % Else: very close to critical state already, stop updating pc

    % Calculate plastic terms
    dFds = (6/M/M).*s.*[0 0 0 1 1 1]' + ((2*p-pc)/3 + (3/M/M).*(s-p)).*[1 1 1 0 0 0]';
    dFdWdWde = (-p * pc * vstart / (lambda - kappa)) .* [1 1 1 0 0 0]; % Using vstart gives more stable results than v(instantaneous)
    
    Hbottom = -dFdWdWde * dFds + dFds' * De * dFds;
    D = De - (1/Hbottom).*(De * (dFds * dFds') * De);
    
else
    % Get stress changes based on D matrix
    D = De;
end 

ds = D * de;
