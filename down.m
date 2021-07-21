%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%下行仿真
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;
close all;

%% 基础参数
SNR = 0:1:20;                 %信噪比变化范围
SNR1 = 0.5*(10.^(SNR/10));    %将信噪比转化成直角坐标
n = 2^20;                     %发射数据流长度
M = 1;                        %UE天线数量
N = 2;                        %CE天线发射数量

tx_data_origion = randi([0,1],1,n);   %产生二进制随机信号

%% CE广播
[mod_data,qpsk_data,len_mod_data] = CE_modulate(tx_data_origion);    %OFDM信号调制
tx_data = reshape(mod_data,2,len_mod_data/2);              %将数据流分为两部分

%Alamouti空时编码发射======================================================

tx_Alamouti = [];
%tx_Alamouti = cell(len_mod_data,1);                        %预设大小
h1 = normrnd(0,1)+normrnd(0,1)*i;                          %定义天线1的信道增益
h2 = normrnd(0,1)+normrnd(0,1)*i;                          %定义天线2的信道增益
H_channel = [h1 h2;conj(h2),-1*conj(h1)];                          %用户已知信道矩阵H

for i = 1:len_mod_data/2                                   %Alamouti发射
    tx_Alamouti(:,i) = H_channel*tx_data(:,i);
    %    tx_Alamouti{i} = [h1*tx_data(1,i),h2*tx_data(2,i);[h1*-1*conj(tx_data(2,i)),h2*conj(tx_data(1,i))]];
end
len_Alamouti = length(tx_Alamouti(1,:));
%结束======================================================================
for UE = 1:2                                               %UE1与2
    if UE == 1
        
        DataToUE = tx_Alamouti;
        
    else
        
        DataToUE = tx_Alamouti;
        
    end
    for snr = 1:length(SNR)
        
        sigma=0.5/(sqrt(N)*10^(snr/10));
        
        for j = 1:len_Alamouti
            h=1/(sqrt(randn(1,1)+snr*randn(1,1)));                %瑞利信道
            d = DataToUE(:,j);
            %d = tx_Alamouti(:,j);
            channel_rayleigh=h*d;
            noise_gaussian=awgn(channel_rayleigh,snr,'measured');
            rx_data_temp = inv(h)*noise_gaussian;
            afterchan = rx_data_temp;
            z = H_channel'*afterchan;                                       %H转置相乘
            %rx_data = z-(abs(h1)^2+abs(h2)^2);                      %去除信道增益影响
            rx_data_deAlamouti(:,j) = z;
            
        end
        len_deAlamouti = length(rx_data_deAlamouti(1,:));
        rx_data = reshape(rx_data_deAlamouti,[1,2*len_deAlamouti]);
        rx_data_martix = reshape(rx_data,[64,2*len_deAlamouti/64]);
        rx_data_ReplaceCP = rx_data_martix(:,17:2*len_deAlamouti/64);
        rx_data_fft = fft(rx_data_ReplaceCP,64);
        len_fft = length(rx_data_fft(1,:));
        rx_data_vector = reshape(rx_data_fft,[1,64*len_fft]);
        
        %% QPSK解调
        for m =1:len_fft*64
            Afterdemod(m) = Q(rx_data_vector(m),'QPSK');
        end
        
        %% 误码率计算
        num = sum((sign(real(Afterdemod))~=sign(real(qpsk_data))) | (sign(imag(Afterdemod))~=sign(imag(qpsk_data))));
        OFDM_s_ray(snr) = num/n;
        
    end
    if UE == 1
        
        semilogy(SNR,OFDM_s_ray,'r*-');
        
    else
        
        semilogy(OFDM_s_ray,'go-');
        
    end
    hold on;
end
grid on;

title('下行时隙广播接收用户端误码率');

xlabel('SNR(dB)');

ylabel('BER');

legend('UE_1','UE_2');