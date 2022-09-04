clc
clear all
close all
% give global params
%% Setup Simulation Parameters: User defined parameters

global nSignalsPerMod;
nSignalsPerMod = 75; % Number of signals per modulation type
global Fs;
global rangeN;
global snrVector;
Fs = 1e8; % Sampling frequency (Hz)
rangeN = [512, 1920]; % Number of collected signal samples range
snrVector = -6:5:30; % Range of Signal-to-Noise Ratios (SNRs) for training (dB)
for sn=1:length(snrVector)
    SNR=snrVector(sn);
for i=1:9
    i
    if i==1
        [wav, truth] = GenerateRadarWaveformsRect(SNR);
        for idxW = 1:nSignalsPerMod
        sig = wav{idxW};
        csvwrite( sprintf( 'Rect_%d_%d.csv', SNR, idxW ), sig );    
        end
    elseif i==2
        [wav, truth] = GenerateRadarWaveformsLFM(SNR); 
        for idxW = 1:nSignalsPerMod
        sig = wav{idxW};
        csvwrite( sprintf( 'LFM_%d_%d.csv', SNR, idxW ), sig );     
        end
    elseif i==3
        [wav, truth] = GenerateRadarWaveformsBarker(SNR);
        for idxW = 1:nSignalsPerMod
        sig = wav{idxW};
        csvwrite( sprintf( 'Barker_%d_%d.csv', SNR, idxW ), sig );    
        end
    elseif i==4
        [wav, truth] = GenerateRadarWaveformsFrank(SNR);
        for idxW = 1:nSignalsPerMod
        sig = wav{idxW};
        csvwrite( sprintf( 'Frank_%d_%d.csv', SNR, idxW ), sig );    
        end
    elseif i==5
        [wav, truth] = GenerateRadarWaveformsP1(SNR);
        for idxW = 1:nSignalsPerMod
        sig = wav{idxW};
        csvwrite( sprintf( 'P1_%d_%d.csv', SNR, idxW ), sig );    
        end
    elseif i==6
        [wav, truth] = GenerateRadarWaveformsP2(SNR);
        for idxW = 1:nSignalsPerMod
        sig = wav{idxW};
        csvwrite( sprintf( 'P2_%d_%d.csv', SNR, idxW ), sig );    
        end
    elseif i==7
        [wav, truth] = GenerateRadarWaveformsP3(SNR);
        for idxW = 1:nSignalsPerMod
        sig = wav{idxW};
        csvwrite( sprintf( 'P3_%d_%d.csv', SNR, idxW ), sig );    
        end
    elseif i==8
        [wav, truth] = GenerateRadarWaveformsP4(SNR);
        for idxW = 1:nSignalsPerMod
        sig = wav{idxW};
        csvwrite( sprintf( 'P4_%d_%d.csv', SNR, idxW ), sig );    
        end
    elseif i==9
        [wav, truth] = GenerateRadarWaveformsPx(SNR);
        for idxW = 1:nSignalsPerMod
        sig = wav{idxW};
        csvwrite( sprintf( 'Px_%d_%d.csv', SNR, idxW ), sig );    
        end
    end % if ends
end % class ends
end % SNR ends