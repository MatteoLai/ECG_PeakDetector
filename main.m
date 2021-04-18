  close all
  clear
  clc
%% ------------------------------------------------------------------------
choice = menu('Chose a signal','First signal','Second signal','Third signal','Fourth signal');
switch choice
    case 1
        x = load('first_peak_test.dat','-ascii');
        y = x; % No need to filter this signal
    case 2
        x = load('second_peak_test.dat','-ascii');
        y = x; % No need to filter this signal
    case 3
        x = load('third_peak_test.dat','-ascii'); %Low-frequency noise 
        b1 = 1.8*[1 -1]; 
        a1 = 2*[1 -0.8];
        y = filter(b1,a1,x); % HP filter
    case 4
        x = load('fourth_peak_test.dat','-ascii'); % High-frequency noise
        y1 = notch(x,1,0,0.9);
        y2 = notch(y1,1,0.1,0.9);
        y3 = notch(y2,1,0.2,0.9);
        y = notch(y3,1,0.3,0.9);
    %     By observing normalized-frequency spectrum it's possible to
    %     notice which frequencies are responsible of high-frequency noise,
    %     and it's possible to remove them by using notch filters.
    %     Selective notch is a recursive filter, so it require some time
    %     to stabilize itself, and the first samples won't be well filtered.
    %     By delecting them it's possible to assure the success of the
    %     PeakDetector funtion.
        y(1:600)=[]; 
end

%% ------------------------------------------------------------------------

N = length(x);
X = fftshift(abs(fft(x)))/N;
Y = fftshift(abs(fft(y)))/length(y);
f =((0:N-1)-floor(N/2))/N;
f1 = ((0:length(y)-1)-floor(length(y)/2))/length(y);
%   
% %   
subplot(2,1,1)
plot(x)
title('Original signal')
xlabel('t [s]')
subplot(2,1,2)
plot(f,X)
title('Spectrum of original signal')

figure

subplot(2,1,1)
plot(y)
title('Filtered signal')
xlabel('t [s]')
subplot(2,1,2)
plot(f1,Y)
title('Spectrum of filtered signal')


figure('name','Peaks on filtered signals')
 
PeakDetector(y,0.8);

