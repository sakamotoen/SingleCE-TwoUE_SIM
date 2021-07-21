%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%这是一个通信仿真系统，该系统由1台CE与2台UE组成
%其CE天线数量为8根，UE为单天线系统，调制方式为OFDM调制，子载波为64，
%循环前缀CP为16，信道长度为10，且信道符合瑞利分布
%下行时隙：随机选择两天线发射，采用Alamouti 空时编码，且采用QPSK星座
%上行时隙采用MMSE或者迫零接收，QAM（QPSK,16QAM,64QAM）发射
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
close all;

%% 基础参数
SNR = 0:1:20;                 %信噪比变化范围

SNR1 = 0.5*(10.^(SNR/10));    %将信噪比转化成直角坐标

n = 3*2^18;                      %仿真点数

data_1 = randi([0,1],1,n);    %产生二进制随机信号UE1

data_2 = randi([0,1],1,n);    %产生二进制随机信号UE2

%定义天线数量

M=8;%CErx

N=2;%UEtx

alg = input('请输入CE解调算法（ZF/MM）:','s');

for itr = 1:3                                                %1，2，3分别对应QPSK,16QAM,64QAM
    
    modulations = ["QPSK","16QAM","64QAM"];
    
    modulation = modulations{itr};
    
    switch modulation
        case 'QPSK'
            mod=2;
        case '16QAM'
            mod=4;
        case '64QAM'
            mod=6;
    end
    
    idx = 1;                      %设置初始计数器
    
    % 上行========================================================================================
    %% UE发射
    mod_data_1 = tx_modulate(data_1,modulation);                 %UE1发射
    
    mod_data_2 = tx_modulate(data_2,modulation);                 %UE2发射
    
    len_all = length(mod_data_1);
    
    %同时发送，信号混叠
    mod_data = [mod_data_1;mod_data_2];
    
    %% 通过信道
    for i = 1:length(SNR)
        %定义高斯噪声标准差sigma
        sigma=0.5/(sqrt(N)*10^(i/10));
        
        for j = 1:len_all
            
            H=(randn(M,N)+j*randn(M,N))/sqrt(2);
            
            H_save = H;
            
            d = mod_data(:,j);
            
            AWGN_noise = sqrt(sigma)*(randn(M, N)+j*randn(M, N));                      %AWGN噪声
            
            rx_data = (H_save*d)/sqrt(N) + sqrt(sigma)*(randn(M, 1)+j*randn(M, 1));    %加入AWGN噪声的接收机信号矢量
            
            %% CE解调
            
            if alg == 'MM'                                      %MMSE接收机
                
                G=inv(H'*H+N/(10^(0.1*i))*eye(N))*H';
                
                [gk k0]=min(sum(abs(G).^2,2));
                
                for m=1:N     %计算排序序列k1和a'矩阵
                    
                    k1(m)=k0;
                    
                    w(m,:)=G(k1(m),:);
                    
                    y=w(m,:)*rx_data;
                    
                    a(k1(m),1)=Q(y,modulation);
                    
                    rx_data = rx_data - a(k1(m)) * H_save(:, k1(m));
                    
                    H(:,k0)=zeros(M,1);
                    
                    G=inv(H'*H+N/(10^(0.1*i))*eye(N))*H';
                    
                    for t=1:m
                        
                        G(k1(t),:)=inf;
                        
                    end
                    
                    [gk k0]=min(sum(abs(G).^2,2));
                    
                end
                
            elseif alg == 'ZF'                                  %迫零接收机
                
                G=pinv(H);
                
                [gk k0]=min(sum(abs(G).^2,2));
                
                for m=1:N     %计算排序序列k1和a'矩阵
                    
                    k1(m)=k0;
                    
                    w(m,:)=G(k1(m),:);
                    
                    y=w(m,:)*rx_data;
                    
                    a(k1(m),1)=Q(y,modulation);
                    
                    rx_data = rx_data - a(k1(m)) * H_save(:, k1(m));
                    
                    H(:,k0)=zeros(M,1);
                    
                    G=pinv(H);
                    
                    for t=1:m
                        
                        G(k1(t),:)=inf;
                        
                    end
                    
                    [gk k0]=min(sum(abs(G).^2,2));
                    
                end
                
            end
            
            %% 错误计数
            
            errors(j) = sum((sign(real(a))~=sign(real(d))) | sign(imag(a))~=sign(imag(d)));
            
        end
        
        BER(idx) = sum(errors)/(2*len_all);         %误码率
        
        SER(idx)=BER(idx)*mod;
        
        idx = idx+1;
        
    end
    
    if itr == 1
        
        semilogy(SNR,BER,'b--');                    %QPSK曲线设置为蓝色--
        
    elseif itr == 2
        
        semilogy(SNR,BER,'g*-');                    %16QAM曲线设置为绿色*-
        
    elseif itr == 3
        
        semilogy(SNR,BER,'ro-');                    %64QAM曲线设置为红色o-
        
    end
    
    
    hold on;
    
end

xlabel('SNR[dB]');

ylabel('BER');

title('双UE发送CE接收误比特率(MMSE)');

grid on;

legend('QPSK','16QAM','64QAM');