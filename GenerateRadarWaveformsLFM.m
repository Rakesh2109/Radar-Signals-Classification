function [data, truth] = GenerateRadarWaveformsLFM(SNR)
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
            % Create signal
            hLfm = phased.LinearFMWaveform(...
                'SampleRate',Fs,...
                'OutputFormat','Samples');
            
            for iS = 1:nSignalsPerMod
                %Get randomized parameters
                Fc = randOverInterval(rangeFc);
                B = randOverInterval(rangeB);
                Ncc = round(randOverInterval(rangeN));
               % SNR = snrVector(randi(length(snrVector),1));
                
                % Generate LFM
                hLfm.SweepBandwidth = B;
                hLfm.PulseWidth = Ncc*Ts;
                hLfm.NumSamples = 1024;
                hLfm.PRF = 1/(Ncc*Ts);
                hLfm.SweepDirection = sweepDirections{randi(2)};
                wav = hLfm();
                
                % Adjust SNR
                wav = awgn(wav,SNR);
                
                % Add frequency offset
                hFreqOffset.FrequencyOffset = Fc;
                wav = hFreqOffset(wav); % Frequency shift
                
                % Add multipath offset
                wav = multipathChannel(wav);
                
                % Save signal
                data{idxW} = wav;
                truth(idxW) = "LFM";
                
                idxW = idxW + 1;
                release(hLfm);
                release(hFreqOffset);
            end
end
%% Subroutines
function val = randOverInterval(interval)
% Expect interval to be <1x2> with format [minVal maxVal]
val = (interval(2) - interval(1)).*rand + interval(1);
end