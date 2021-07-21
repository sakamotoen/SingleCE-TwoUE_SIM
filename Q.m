function [a]=Q(rx_symbol,modulation)
%***********************************************************************
% 星座图切片
%***********************************************************************

if ~isempty(findstr(modulation, 'QPSK'))
    
    % QPSK
    
    soft_bits = zeros(2*size(rx_symbol,1),size(rx_symbol,2));   %生成矩阵备用
    
    bit0 = real(rx_symbol);                                     %信号实部符号
    
    bit1 = imag(rx_symbol);                                     %信号虚部符号
    
    soft_bits(1:2:size(soft_bits, 1),:) = bit0;                 %第一行为实部
    
    soft_bits(2:2:size(soft_bits, 1),:) = bit1;                 %第二行为虚部
    
    a=bit0+j*bit1;                                              %解码结果
    
elseif ~isempty(findstr(modulation, '16QAM'))
    
    %16QAM
    
    soft_bits = zeros(4*size(rx_symbol,1), size(rx_symbol,2));  % 每个符号由4位组成
    
    bit0 = real(rx_symbol);                                     %信号实部符号
    
    bit2 = imag(rx_symbol);                                     %信号虚部符号
    
    bit1 = 2/sqrt(10)-(abs(real(rx_symbol)));                   %16QAM星座图靠近数轴x的点的值
    
    bit3 = 2/sqrt(10)-(abs(imag(rx_symbol)));                   %16QAM星座图靠近数轴y的点的值
    
    soft_bits(1:4:size(soft_bits,1),:) = bit0;
    
    soft_bits(2:4:size(soft_bits,1),:) = bit1;
    
    soft_bits(3:4:size(soft_bits,1),:) = bit2;
    
    soft_bits(4:4:size(soft_bits,1),:) = bit3;
    
    a=bit0+j*bit2;                                              %解码结果
    
elseif ~isempty(findstr(modulation, '64QAM'))
    
    %64QAM
    
    soft_bits = zeros(6*size(rx_symbol,1), size(rx_symbol,2));  % 每个符号由6位组成
    
    bit0 = real(rx_symbol);
    
    bit3 = imag(rx_symbol);
    
    bit1 = 4/sqrt(42)-abs(real(rx_symbol));
    
    bit4 = 4/sqrt(42)-abs(imag(rx_symbol));
    
    for m=1:size(rx_symbol,2)
        
        for k=1:size(rx_symbol,1)
            
            if abs(4/sqrt(42)-abs(real(rx_symbol(k,m)))) <= 2/sqrt(42)  % 位为1
                
                bit2(k,m) = 2/sqrt(42) - abs(4/sqrt(42)-abs(real(rx_symbol(k,m))));
                
            elseif abs(real(rx_symbol(k,m))) <= 2/sqrt(42) % 位为0
                
                bit2(k,m) = -2/sqrt(42) + abs(real(rx_symbol(k,m)));
                
            else
                
                bit2(k,m) = 6/sqrt(42)-abs(real(rx_symbol(k,m))); % 位为0
                
            end;
            
            if abs(4/sqrt(42)-abs(imag(rx_symbol(k,m)))) <= 2/sqrt(42)  % 位为1
                
                bit5(k,m) = 2/sqrt(42) - abs(4/sqrt(42)-abs(imag(rx_symbol(k,m))));
                
            elseif abs(imag(rx_symbol(k,m))) <= 2/sqrt(42) % 位为0
                
                bit5(k,m) = -2/sqrt(42) + abs(imag(rx_symbol(k,m)));
                
            else
                
                bit5(k,m) = 6/sqrt(42)-abs(imag(rx_symbol(k,m)));
                
            end;
            
        end;
        
    end;
    
    soft_bits(1:6:size(soft_bits,1),:) = bit0;
    
    soft_bits(2:6:size(soft_bits,1),:) = bit1;
    
    soft_bits(3:6:size(soft_bits,1),:) = bit2;
    
    soft_bits(4:6:size(soft_bits,1),:) = bit3;
    
    soft_bits(5:6:size(soft_bits,1),:) = bit4;
    
    soft_bits(6:6:size(soft_bits,1),:) = bit5;
    
    a=bit0+j*bit3;
    
end