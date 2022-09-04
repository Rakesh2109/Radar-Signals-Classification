function [data, truth] = GenerateRadarWaveformsFrank(SNR)
global Fs;
global nSignalsPerMod;
global rangeN;
global snrVector;
Ts = 1/Fs; % Sampling period (sec)
rangeFc = [Fs/6, Fs/5]; % Center frequency (Hz) range
rangeB = [Fs/20, Fs/16]; % Bandwidth (Hz) range
sweepDirections = {'Up','Down'};
idxW = 1;
multipathChannel = comm.RicianChannel(...
    'SampleRate', Fs, ...
    'PathDelays', [0 1.8 3.4]/Fs, ...
    'AveragePathGains', [0 -2 -10], ...
    'KFactor', 4, ...
    'MaximumDopplerShift', 4);
hFreqOffset = comm.PhaseFrequencyOffset(...
    'SampleRate',Fs);

            rangeNChip = [4,9,16,25,36,49]; % Number of chips
            rangeNcc = [1,5]; % Cycles per phase code
            
            % Create signal and update SNR
            hPhase = phased.PhaseCodedWaveform(...
                'SampleRate',Fs,...
                'Code','Frank',...
                'OutputFormat','Samples');
            
            for iS = 1:nSignalsPerMod
                %Get randomized parameters
                Fc = randOverInterval(rangeFc);
                N = rangeNChip(randi(length(rangeNChip),1));
                Ncc = rangeNcc(randi(length(rangeNcc),1));
               % SNR = snrVector(randi(length(snrVector),1));
                
                % Create signal and update SNR
                chipWidth = Ncc/Fc;
                chipWidthSamples = round(chipWidth*Fs)-1; % This must be an integer!
                chipWidth = chipWidthSamples*Ts;
                hPhase.ChipWidth = chipWidth;
                hPhase.NumChips = N;
                hPhase.PRF = 1/((chipWidthSamples*N+1)*Ts);
                hPhase.NumSamples = 1024;
                wav = hPhase();
                
                % Adjust SNR
                wav = awgn(wav,SNR);
                
                % Add frequency offset
                hFreqOffset.FrequencyOffset = Fc;
                wav = hFreqOffset(wav); % Frequency shift
                
                % Add multipath offset
                wav = multipathChannel(wav);
                
                % Save signal
                data{idxW} = wav;
                truth(idxW) = "Frank";
                
                idxW = idxW + 1;
                release(hPhase);
                release(hFreqOffset);
            end
end
%% Subroutines
function val = randOverInterval(interval)
% Expect interval to be <1x2> with format [minVal maxVal]
val = (interval(2) - interval(1)).*rand + interval(1);
end