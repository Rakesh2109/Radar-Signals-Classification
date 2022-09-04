function [data, truth] = GenerateRadarWaveformsRect(SNR)
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
            hRect = phased.RectangularWaveform(...
                'SampleRate',Fs,...
                'OutputFormat','Samples');
            
            for iS = 1:nSignalsPerMod
                %Get randomized parameters
                Fc = randOverInterval(rangeFc);
                Ncc = round(randOverInterval(rangeN));
              %  SNR = snrVector(randi(length(snrVector),1));
                
                % Create waveform
                hRect.PulseWidth = Ncc*Ts;
                hRect.PRF = 1/(Ncc*Ts);
                hRect.NumSamples = 1024;
                wav = hRect();
                
                % Adjust SNR
                wav = awgn(wav,SNR);
                
                % Add frequency offset
                hFreqOffset.FrequencyOffset = Fc;
                wav = hFreqOffset(wav); % Frequency shift
                
                % Add multipath offset
                wav = multipathChannel(wav);
                
                % Save signal
                data{idxW} = wav;
                truth(idxW) = "Rect";
                
                idxW = idxW + 1;
                release(hRect);
                release(hFreqOffset);
            end
end
%% Subroutines
function val = randOverInterval(interval)
% Expect interval to be <1x2> with format [minVal maxVal]
val = (interval(2) - interval(1)).*rand + interval(1);
end