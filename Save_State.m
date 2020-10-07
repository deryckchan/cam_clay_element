%% Save current state variables
% Save_State.m

if ~exist('ti','var')
    ti = 0;
end

ti = ti + 1;

ResultsStruct.s(ti,:) = s'; % Need to save in the other dimension
ResultsStruct.e(ti,:) = e';
ResultsStruct.p(ti) = p;
ResultsStruct.q(ti) = q;
ResultsStruct.pc(ti) = pc;
ResultsStruct.v(ti) = v;
ResultsStruct.F(ti) = F;
ResultsStruct.vCSL(ti) = vCSL;
ResultsStruct.pt(ti) = pt;
ResultsStruct.u(ti) = u;

if exist('dFds','var')
    ResultsStruct.ndF(ti) = norm(dFds);
else
    ResultsStruct.ndF(ti) = 0;
end
