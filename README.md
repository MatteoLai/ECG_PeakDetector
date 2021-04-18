# ECG_PeakDetector
Peak detector algorithm for ECG signal.

In main.m is possible to select one of four signals properly filtered to test the function PeakDetector. The idea of the function is to build an array to store in each row the regions of continuous samples above the threshold. By applying the max operator is possible to find the peaks and relative indexes. This algorithm is not optimazed, because it doesn't takes advantages of Matlab potentiality, so I'll modify it or I'll propose an alternative.
