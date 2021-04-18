function QRS = PeakDetector(x, th)
% QRS = PeakDetector(x, th)
%
% Input: x, ECG filtered signal
%        th, threshold 
% Output: QRS, indexs of the found peaks
% The function also return the plot of the peaks.

%% Parts of the signal under the threshold are posed equal to zero
p = x.*(x>th*max(x));

%% Build-up an array that will contain a peak in each row
v=[];
j=0;
i=1;
while i<length(p)
     if  p(i)~=0
        j=j+1;                  
    while p(i)~=0 && i<length(p)
        v(j,i)=p(i);
        i=i+1;
    end
    else
        i=i+1;
    end
end



[massimi,QRS] = max(v,[],2);

plot(x)
hold on
plot(QRS,massimi,'*')
end