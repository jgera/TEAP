function [ECG_features] = ECG_feat_extr(ECGSignal)
%Computes the InterBeatInterval mean of an ECG signal
% Inputs:
%  ECGSignal: the ECG signal
% Outputs:
%  ECG_features: 1x17 vector including in the order of appearance in the 
%vector:
%1. HRV variance, 2. mean HRV, 3. mean heart rate, 
%4-8. Multiscale entropy at 5 levels on HRV (5 feaures), 
%9. Spectral power 0-0.1Hz, 
%10. Spectral power 0.1-0.2Hz,
%11. Spectral power 0.2-0.3 
%12. Spectral power 0.3-0.4Hz,
%13. Spectral energy ratio between f<0.08Hz/f>0.15Hz and f<5.0Hz
%14. Low frequency spectral power in tachogram (HRV)  [0.01-0.08Hz]
%15. Medium frequency spectral power in tachogram (HRV)  [0.08-0.15Hz]
%16. High frequency spectral power in tachogram (HRV)  [0.15-0.5Hz]
%17. Energy ratio for tachogram spectral content (MF/(LF+HF))
 
%Copyright Guillaume Chanel 2013
%Copyright Frank Villaro-Dixon, BSD Simplified, 2014


%Make sure we have an ECG signal
ECGSignal = ECG__assert_type(ECGSignal);


%Compute the results

rawSignal = Signal__get_raw(ECGSignal);
samprate = Signal__get_samprate(ECGSignal);

newfs = 256; %Hz, as needed by rpeakdetect
rawSignal = detrend(rawSignal);
ECG = downsample(rawSignal, samprate/newfs);
[~, t, ~, R_index, ~, ~] = rpeakdetect(ECG', newfs);
[BPM, IBI] = correctBPM(R_index, newfs);
IBIVar = var(IBI);
HRV = mean(IBI);
HR = mean(BPM);
%multi-scale entropy for 5 scales on hrv
[MSE] = multiScaleEntropy(IBI,5);
[P, f] = pwelch(ECG, [], [], [], samprate,'power');
P=P/sum(P);
%power spectral featyres
sp0001 = log(sum(P(f>0.0 & f<=0.1))+eps);
sp0102 = log(sum(P(f>0.1 & f<=0.2))+eps);
sp0203 = log(sum(P(f>0.2 & f<=0.3))+eps);
sp0304 = log(sum(P(f>0.3 & f<=0.4))+eps);
energyRatio = log(sum(P(f<0.08))/sum(P(f>0.15 & f<5))+eps);
%tachogram features; psd features on inter beat intervals
%R. McCraty, M. Atkinson, W. Tiller, G. Rein, and A. Watkins, �The
%effects of emotions on short-term power spectrum analysis of
%heart rate variability,� The American Journal of Cardiology, vol. 76,
%no. 14, pp. 1089 � 1093, 1995

tachogram = zeros(length(ECG),1);
tachogram(1:round(t(1)*samprate)) = IBI(1);
for i = 1:length(t)-1
    tachogram(round(t(i)*samprate):round(t(i+1)*samprate)) = IBI(i);
end
tachogram(round(t(end)*samprate):end) = IBI(end);
[Pt, ft] = pwelch(tachogram, [], [], [], samprate,'power');
clear tachogram
LF = log(sum(Pt(ft>0.01 & ft<=0.08))+eps);
MF = log(sum(Pt(ft>0.08 & ft<=0.15))+eps);
HF = log(sum(Pt(ft>0.15 & ft<=0.5))+eps);

ECG_features =[IBIVar HRV HR MSE ... 1:8
    sp0001 sp0102 sp0203 sp0304 energyRatio ... 9:13
    LF MF HF (MF/(LF+HF))];  %14:17




end
