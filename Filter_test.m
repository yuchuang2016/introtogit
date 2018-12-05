

clear; clc; close all;

do_plots = 0;

%% Generate the original signal
A1 = 0.1; % Amplitude of low frequency leakage
f1 = 5; % Frequency of the first signal

A2 = 1; %Amplitude of our main signal
f2 = 10e6; % Frequency of the second signal
fs = 40e6; % Sampling frequency

B = 1000; % Cutoff frequency
N = 100; % Filter order

i = 1;

time_cpu = zeros(1001, 1);
time_gpu = zeros(1001, 1);

for T = 0.0001:0.001:1 % Time duration of simulation
    T_array(i) = T;
    n = round(T*fs); % Number of samples
    t = linspace(0, T, n); % Sample vector
    y = A1*cos(2*pi*f1*t) + A2*cos(2*pi*f2*t); % Generate the signal
    
    % The time and frequency domain of the original signal
    
    if do_plots
        samples_to_plot = 1024;
        figure(1);
        t_plot = t(1:samples_to_plot);
        y_plot = y(1:samples_to_plot);
        plot(t_plot, y_plot);title('Time Domain Before/After');xlabel('t (s)'); ylabel('Magnitude');
        hold on;
        figure(2);
        fft_y = fftshift(fft(y, 1024));
        f=linspace(-fs/2,fs/2,1024)/1e6;
        plot(f,abs(10*log10(fft_y)));
        hold on;
        title('Frequency Domain Before/After');xlabel('f (MHz)'); ylabel('Magnitude');%axis([ 0 50 0 100]);
    end
    %% Generate the filter
    b = firls(N,[0 0.05 0.1 1], [0 0 1 1]);
    
    %Pass the signal through the high-pass filter
    
    tic
    y_after_fir=filter(b,1,y);
    time_cpu(i) = toc;
    
    if do_plots
        figure;
        freqz(b);
        
        y_after_fir_shifted = y_after_fir(N/2 +1 :end);
        y_after_fir_shifted = y_after_fir_shifted(1:samples_to_plot);
        
        %The time and frequency domain of the filtered signal
        figure(1);
        plot(t_plot,y_after_fir_shifted, '--');
        fft_y1=fftshift(fft(y_after_fir_shifted, 1024));
        figure(2);
        plot(f,abs(10*log10(fft_y1)));ylabel('Magnitude');%axis([ 0 50 0 100]);
    end
    
    %% GPU Version
    
    y_gpu = gpuArray(y);
    b_gpu = gpuArray(b);
    
    tic
    y_after_fir_GPU = filter(b_gpu, 1, y_gpu);
    time_gpu(i) = toc;
    
    i = i + 1;
    fprintf("%d out of 1001\n",i);
end

fprintf("---------- Results Summary --------------\n");
fprintf("%.1f Times faster!\n", time_cpu./time_gpu);
