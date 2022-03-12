function bodeWithCutoffFreqs(transferFunction, cutoffFreqAmt)
	% Function to plot Bode graphs for gain and phase, for an input function.
	% Allows overriding matlab's default Bode plot with an option to show the -3dB frequency on the gain plot.
	% Parameters:
	%	transferFunction - a tf() representation of a transfer function.
	%	cutoffFreqAmt - How many expected -3dB points we're looking for. For LPF and HPF we expect 1, and for
	%					a BPF we expect two.
	
	% If cutoffFreqAmt not specified, assume 1.
    if ~exist('cutoffFreqAmt', 'var')
        cutoffFreqAmt=1;
    end


    [mag, phase, wout]  = bode(transferFunction);
	
    % Reduce dims
    mag = squeeze(mag);
    phase = squeeze(phase);
	% Move to magnitude in DB
	mag_db = toDB(mag);
	
    mag_knee_idxes = findClosestValues(mag_db, -3, cutoffFreqAmt);
    cutoff_freqs = toFreq(wout(mag_knee_idxes));

	% Plot!
    figure;
    subplot(2,1,1);
    semilogx(toFreq(wout), toDB(mag));
    yline(-3, "r--");
    
    for freq=1:length(cutoff_freqs)
        xline(cutoff_freqs(freq), "b--");
    end
    
    title(sprintf("Gain Bode: Knee Frequency: %0.2f [Hz]", cutoff_freqs(1)))
    xlabel("Frequency [Hz]");
    ylabel("Gain [dB]");

    % Set tick at -3dB also:
    set(gca, 'YTick', unique([-3, get(gca, 'YTick')]));
    grid on;
    
    
    subplot(2,1,2);
    semilogx(toFreq(wout), phase);
    title("Phase Bode");
    xlabel("Frequency [Hz]");
    ylabel("Phase [degrees]");
    grid on;
	
	disp("Cutoff Frequencies (-3db): ");
    disp(cutoff_freqs);
end


function index = findClosestValues(arr, target, amt)
    [~, min_arr] = sort(abs(arr-target));
    index = min_arr(1:amt);
end

function val_db = toDB(sig)
val_db = 20*log10(sig);
end

function f_axis = toFreq(omegaAxis)
f_axis = omegaAxis/(2 * pi);
end