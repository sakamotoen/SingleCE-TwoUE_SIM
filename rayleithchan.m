%%%%%%%%%%%%%%%%%%%%%%%%%%%
%这是一个单独的瑞利信道,
%包含AWGN噪声
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [afterchan] = rayleithchan(InputData,SNR)

h=1/(sqrt(randn(1,1)+SNR*randn(1,1)));                %瑞利信道

channel_rayleigh=conv(h,InputData);                   %信号卷积通过瑞利信道

noise_gaussian=awgn(channel_rayleigh,SNR,'measured'); %生成高斯噪声

rx_data = inv(h)*noise_gaussian;                      %加噪声

afterchan = rx_data;