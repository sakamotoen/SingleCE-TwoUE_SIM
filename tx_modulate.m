function mod_symbols = tx_modulate(bits_in, modulation)

full_len = length(bits_in);                        %计算输入bit流长度

%QPSK调制

if ~isempty(findstr(modulation, 'QPSK'))
    
    table=exp(j*[-3/4*pi 3/4*pi 1/4*pi -1/4*pi]);  % 生成QPSK符号
    
    table=table([0 1 3 2]+1);                      % QPSK符号的格雷码映射
    
    inp=reshape(bits_in,2,full_len/2);             %向量-矩阵变换
    
    mod_symbols=table([2 1]*inp+1);                %QPSK映射
    
    % 16-QAM调制
    
elseif ~isempty(findstr(modulation, '16QAM'))
    
    %生成16QAM符号
    
    m=1;
    
    for k=-3:2:3
        
        for l=-3:2:3
            
            table(m) = (k+j*l)/sqrt(10); %归一化
            
            m=m+1;
            
        end;
        
    end;
    
    table=table([0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10]+1); %8PSK符号的格雷码映射
    
    inp=reshape(bits_in,4,full_len/4);                      %向量-矩阵变换
    
    mod_symbols=table([8 4 2 1]*inp+1);                     %16QAM映射
    
    % 64-QAM调制
    
elseif ~isempty(findstr(modulation, '64QAM'))
    
    %生成64QAM符号
    
    m=1;
    
    for k=-7:2:7
        
        for l=-7:2:7
            
            table(m) = (k+j*l)/sqrt(42);                    %归一化
            
            m=m+1;
            
        end;
        
    end;
    
    table=table([[ 0  1  3  2  7  6  4  5]...
        
    8+[ 0  1  3  2  7  6  4  5]...
    
    24+[ 0  1  3  2  7  6  4  5]...
    
    16+[ 0  1  3  2  7  6  4  5]...
    
    56+[ 0  1  3  2  7  6  4  5]...
    
    48+[ 0  1  3  2  7  6  4  5]...
    
    32+[ 0  1  3  2  7  6  4  5]...
    
    40+[ 0  1  3  2  7  6  4  5]]+1);                      %64QAM格雷码映射

inp=reshape(bits_in,6,full_len/6);

mod_symbols=table([32 16 8 4 2 1]*inp+1);                  %64QAM映射

else
    
    error('Unimplemented modulation');                     %出错返回
    
end