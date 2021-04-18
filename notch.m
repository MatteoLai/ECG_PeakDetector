function Y2 = notch(X, fs, fn, rho, fig)

%Y=notch(X, fc, fn, rho)
%
%Input:
% X = signal to filter
% fs = sampling frequency
% fn = notch frequency (che voglio eliminare)
% rho = selectivity coefficient; 
       %eg: rho=0.99 ---> filter more selective than rho=0.8
% fig = 'on' if you want to see the plots
%     = 'off if ou don't want to see the plots (default)
%
%Output:
% Y2 = Signal filtered with selective notch filter.

if nargin < 5
    fig = 'off';
end

% NOT selective notch:
b1=[1 -2*cos(2*pi*(fn/fs)) 1];
a1=1;
%Y1=filter(b1,a1,X)  <---- To be normalized respect to maximum gain


% Selective notch:
b2=b1;
a2=[1 -2*rho*cos(pi*(fn)/(fs/2)) (rho)^2];
%Y2=filter(b2,a2,X);  <---- To be normalized respect to maximum gain

% To normalize respect to the gain I have to take in account the notch
% frequency: if omega<pi/2 it'll be an HP, otherwise a LP.

omega=2*pi*(fn/fs);


% For NOT selective filter:
b11=b1;
a11=a1;

% For selective filter:
b21=b2;
a21=a2;

% - If omega>pi/2, the filter is like a low-pass,
%                 so the gain will be:
%                            1 + b1 + b2 + b3 + b4...
%               |H(z)|MAX =  ------------------------
%                            1 + a1 + a2 + a3 + a4...
 
% - If omega<pi/2, the filter is like an high-pass, 
%                 so the gain will be:
%                            1 - b1 + b2 - b3 + b4...
%               |H(z)|MAX =  ------------------------  
%                            1 - a1 + a2 - a3 + a4...


if omega<pi/2 
    
    % For NOT selective filter:
    b11(2:2:end)=b1(2:2:end)*(-1);
    a11(2:2:end)=a1(2:2:end)*(-1);
    
    % For selective filter:
    b21(2:2:end)=b2(2:2:end)*(-1);
    a21(2:2:end)=a2(2:2:end)*(-1);
    
end

% Gain of NOT selective filter:
    G1=sum(b11)/sum(a11);
    
% Gain of selective filter:
    G2=sum(b21)/sum(a21);
   

% NOT selective notch normalized respect to the gain:
Y1=filter(b1,a1*G1,X);

% Selective notch normalized respect to the gain:
Y2=filter(b2,a2*G2,X);



if strcmp(fig,'on')
    t=(0:1:length(X)-1)./fs;

    subplot(2,1,1)
    plot(t,X)
    xlabel('t [s]');
    ylabel('X(t)');
    title('Original signal');


    subplot(2,1,2)
    N=length(X);
    Z=abs(fftshift(fft(X)))/N;
    f=((0:N-1)-floor(N/2))*fs/N;
    plot(f,Z)
    xlabel('f [Hz]');
    title('Spectrum of original signal');

    figure

    subplot(2,1,1)
    plot(t,X)
    hold on
    plot(t,Y1)
    legend('Original signal','Filtered signal');
    xlabel('t [s]');
    ylabel('Y1(t)');
    title('Signal filtered with NOT selective notch');
    
    subplot(2,1,2)
    N=length(Y1);
    Z1=abs(fftshift(fft(Y1)))/N;
    f=((0:N-1)-floor(N/2))*fs/N;
    plot(f,Z1)
    xlabel('f [Hz]');
    title('Spectrum of signal filtered with NOT selective notch');

    figure

    freqz(b1/G1,a1)
    title('Frequency response of NOT selective notch (unitary gain)');

    figure


    subplot(2,1,1)

    plot(t,X)
    hold on
    plot(t,Y2)
    legend('Original signal','Filtered signal');
    xlabel('t [s]');
    ylabel('Y2(t)');
    title('Signal filtered with selective notch');

    subplot(2,1,2)
    N=length(Y2);
    Z2=abs(fftshift(fft(Y2)))/N;
    f=((0:N-1)-floor(N/2))*fs/N;
    plot(f,Z2)
    xlabel('f [Hz]');
    title('Spectrum of signal filtered with selective notch');

    figure
    X1=X(1:1:length(X)/2);
    t1=[0:1:(length(X)/2)-1]/fs;
    plot(t1,X1)
    hold on
    Y21=Y2(1:1:length(X)/2);

    plot(t1,Y21)
    legend('Original signale','Filtered signal');
    xlabel('t [s]');
    ylabel('Y2(t)');
    title('Focus on the start of signal filtered with selective notch');
    annotation('textbox',[0.15,0.6,0.7,0.15],'string',"Note: the start of the signal is deformed because the filter is recursive, so it need some time to stabilize itself.");


    figure 

    freqz(b2,a2*G2)
    title('Frequency response of selective notch (unitary gain)');
elseif strcmp(fig,'off')
    return
else
    error("Input not valid. Insert 'on' or 'off'")
end


