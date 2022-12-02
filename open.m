load data/S02_restingPre_EC.mat

order = 14;
chan1 = 1;
chan2 = 2;

points = size(dataRest, 2);

% get AR coefficients and error from each signal
[Ax,Ex] = armorf(dataRest(chan1,:), 1, points, order);
[Ay,Ey] = armorf(dataRest(chan2,:), 1, points, order);

%%% we are going to reconstruct the data using the autoregressive coefficients
x = zeros(1, points);
y = zeros(1, points);

x(1:order) = dataRest(chan1, 1:order);
y(1:order) = dataRest(chan2, 1:order);

for i = order + 1:points
    thispointX = 0;
    thispointY = 0;
    
    for ai = 1:order
        thispointX = thispointX + dataRest(chan1,i-ai)*Ax(ai);
        thispointY = thispointY + dataRest(chan2,i-ai)*Ay(ai);
    end
    x(i-1) = thispointX;
    y(i-1) = thispointY;
end
%% 

time = [1:1:points] / 256;

figure(14), clf
plot(time(1:end-2000), dataRest(chan1, 1:end-2000), 'b', time(1:end-2000), x(1:end-2000),'r')
legend({'Real data';'Reconstructed from ARmodel'})
