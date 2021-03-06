function Hd = halfband
%HALFBAND Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.4 and DSP System Toolbox 9.6.
% Generated on: 19-Jul-2019 22:18:49

% FIR Window Halfband lowpass filter designed using the FIRHALFBAND
% function.

% All frequency values are normalized to 1.

N    = 30;   % Order
Beta = 0.5;  % Window Parameter

% Create the window vector for the design algorithm.
win = kaiser(N+1, Beta);

% Calculate the coefficients using the FIR1 function.
b  = firhalfband(N, win);
Hd = dfilt.dffir(b);

% [EOF]
