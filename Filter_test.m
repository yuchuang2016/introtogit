% A signal is composed of two cosine signals with f1 = 5Hz and f2 = 15Hz
% The filter can get rid of the 15Hz part of the signal

% Generate the original signal
f1 = 5; % Frequency of the first signal
f2 = 15; % Frequency of the second signal
fs = 100; % Sampling frequency
T = 2 ; % Time duration
B = 10; % Cutoff frequency 
n = round(T*fs); % Number of samples
t = linspace(0, T, n); % Sample vector
y = cos(2*pi*f1*t)+cos(2*pi*f2*t); % Generate the signal

% The time and frequency domain of the original signal
 figure; 
 plot(t,y);title('The time domain of the original signal');xlabel('t/s'); ylabel('Magnitude');
 figure;
 fft_y = fftshift(fft(y));
 f=linspace(-fs/2,fs/2,n);
 plot(f,abs(fft_y));
 title('The frequency domain of the original signal');xlabel('f/Hz'); ylabel('Magnitude');axis([ 0 50 0 100]);

 %Generate the filter
 b = fir1(80, B/(fs/2),'high');  
 figure;
 freqz(b);
 
 %Pass the signal through the high-pass filter
 tic
 y_after_fir=filter(b,1,y);
 toc
 
 %The time and frequency domain of the filtered signal
 figure;
 plot(t,y_after_fir);title('The time domain of the filtered signal');xlabel('t/s');ylabel('Magnitude');
 fft_y1=fftshift(fft(y_after_fir));
 f=linspace(-fs/2,fs/2,n);
 figure;
 plot(f,abs(fft_y1));title('The frequency domain of the filtered signal');xlabel('f/Hz');ylabel('Magnitude');axis([ 0 50 0 100]);
 
 