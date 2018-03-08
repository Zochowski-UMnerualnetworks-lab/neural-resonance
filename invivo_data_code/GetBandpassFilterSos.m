function [sos,g] = GetBandpassFilterSos(lowCutoff, highCutoff, sampleRate)
% GetFilterSos - Creates a bandpass filter suitable for use with filtfilt.
%
% Syntax:
% [sos,g] = GetFilterSos(lowCutoff, highCutoff, sampleRate)
%
% Description:
% Returns second-order sections & gain for a 4th order elliptical bandpass 
% filter to filter the NEX data.
% Inputs are expected to be in Hz, not normalized Nyquist values.
%
% Input:
% lowCutoff (scalar) - Low cutoff frequency. (Hz)
% highCutoff (scalar) - High cutoff frequency. (Hz)
% sampleRate (scalar) - The sample rate of the the data to be filtered.
%
% Output:
% sos - 2nd order sections representation of filter
% g - gain of filter

narginchk(3, 3);

% Convert the cutoff frequencies into normalized values.
lowCutoff = lowCutoff / (sampleRate / 2);
highCutoff = highCutoff / (sampleRate / 2);

% Check to make sure these are valid cutoffs for the input sample rate
assert(lowCutoff>0 & highCutoff<1,...
    'NapTime:GetFilterSos:InvalidCutoffFrequency', ...
    ['Invalid cutoff frequency specified. Frequency must be greater than 0'...
    ' and less than 1/2 the sample rate.']);

% Create a 4th order elliptical filter.
% Since the effective magnitudes will be squared by using filtfilt, use 1/2
% the magnitudes for passband & stopband attenuation that were initially
% specified (1 & 60 in CreateBandpassFilter.m)
[z,p,k] = ellip(4, 0.5, 30, [lowCutoff highCutoff]);
[sos,g] = zp2sos(z, p, k);
