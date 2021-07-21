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

h1 = normrnd(0,1)+normrnd(0,1)*i;                          %定义天线1的信道增益

h2 = normrnd(0,1)+normrnd(0,1)*i;                          %定义天线2的信道增益

H = [h1 h2;conj(h2),-1*conj(h1)];                          %用户已知信道矩阵H

for i = 1:len_mod_data/2                                   %Alamouti发射
    
    tx_Alamouti(:,i) = H*tx_data(:,i);
    
end

%% 通过信道

for UE = 1:2                                               %UE1与2
    
    if UE == 1
        
        DataToUE = tx_Alamouti;
        
    else
        
        DataToUE = tx_Alamouti;
        
    end
    
    for i = 1:length(SNR)
        
        for j = 1:2
            
            afterchan(j,:) = rayleithchan(DataToUE(j,:),i);
            
        end
        
        %% Alamouti空时解码
        
        z = H'*afterchan;                                         %H转置相乘
        
        rx_data = z;
        
        rx_data = reshape(rx_data,[1,len_mod_data]);
        
        rx_data_martix = reshape(rx_data,[64,(len_mod_data/64)]); %串并变换
        
        rx_data_ReplaceCP = rx_data_martix(:,17:len_mod_data/64); %去除循环前缀
        
        rx_data_fft = fft(rx_data_ReplaceCP,64);                  %64位FFT
        
        len_fft = length(rx_data_fft(1,:));                       %计算FFT后的行长度
        
        rx_data_vector = reshape(rx_data_fft,[1,64*len_fft]);     %并串变换
        
        %% QPSK解调
        
        for m = 1:len_fft*64
            
            Afterdemod(m) = Q(rx_data_vector(m),'QPSK');
            
        end
        
        %% 误码率计算
        
        num = sum((sign(real(Afterdemod))~=sign(real(qpsk_data))) | (sign(imag(Afterdemod))~=sign(imag(qpsk_data))));
        
        OFDM_s_ray(i) = num/n;
        
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