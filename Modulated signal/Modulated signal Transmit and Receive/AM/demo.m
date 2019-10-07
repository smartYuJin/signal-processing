clc
clear all
close all
%% base parameter
signal.type="LSB";  %AM,LSB,USB
signal.am.m_a=0.3;                          %modulation index,|m_a|<1
signal.am.fs=64e3;                          %baseband fs
signal.am.IFfs=1e6;                         % IF fs
signal.am.fc=20e3;
signal.am.fc_amp=1;
signal.am.f_offset=0;
% baseband para (x=Asin(w1t+p1)+Bsin(w2t+p2)+Csin(w3+p3))
signal.am.in_sig_amp=[1,0,0];
signal.am.in_sig_f0=[1e3,1e2,0];
signal.am.in_sig_phase=[0,0,0];
%ddc para
signal.am.lpf_lowf_stop=40*max(signal.am.in_sig_f0)/signal.am.IFfs;
signal.am.len=1000;                         % baseband len of one package
%channel para
signal.noise=30;                            %SNR
%buffer
signal.am.LOphaseTemp=0;                    %IF Local Oscillator Phase
signal.am.LOphaseTemp_ddc=0;                %DDC Local Oscillator Phase
signal.am.ddcrebuffer=[];                   %DDC resample Buffer
signal.am.Ifrebuffer=[];                    %IF resample Buffer
signal.am.ddcconvbuffer=[];                 %DDC CONV Buffer
% three gen signal type
signal.gen_method="Baseband";
signal.gen_method="IF";
% signal.gen_method="IF2Base";
signaltmp=signal;
%% gen signal
packageN=50;
signaltmp.srcdata=[];
rxSignal=[];
for ii=1:packageN
    [rxSignalTemp,signal] = gen_AM(signal);
    rxSignal=[rxSignal,rxSignalTemp];
    signaltmp.srcdata=signal.srcdata;
end
figure;
subplot(2,1,1)
plot(real(rxSignal))
subplot(2,1,2)
plot(imag(rxSignal))
figure
len=length(rxSignal);
ff=(-len/2:len/2-1)*(signal.am.IFfs/len);
plot(ff,abs(fftshift(fft(rxSignal))))
%% save data
if signal.type=="AM"
    gen_AMfile(signaltmp,rxSignal,'.dat','float')
end
if signal.type=="LSB"||signal.type=="USB"
    gen_SSBfile(signaltmp,rxSignal,'.dat','float')
end
%% read data test
[filename, pathname] = uigetfile('*.dat', 'Pick a data file');
fid = fopen([pathname,filename]);
data_wav = fread(fid,[1 10000],'float');
fclose(fid);
figure;plot(data_wav(1,100:end))
