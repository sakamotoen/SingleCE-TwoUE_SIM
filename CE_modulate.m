%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CE调制发射函数，输入为待调制符号x，发射
%方式为OFDM，星座图采用QPSK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mod_data,qpsk_data,len_mod_data] = CE_modulate(bits_in)

len_full = length(bits_in);                    %计算输入数据流长度

%QPSK调制==============================================================

table=exp(j*[-3/4*pi 3/4*pi 1/4*pi -1/4*pi]);  % 生成QPSK符号

table=table([0 1 3 2]+1);                      % QPSK符号的格雷码映射

inp=reshape(bits_in,2,len_full/2);             %向量-矩阵变换

mod_data=table([2 1]*inp+1);                   %QPSK映射

len_mod = length(mod_data);                    %调制后信号长度

qpsk_data = mod_data;

%OFDM==================================================================

mod_reshape = reshape(mod_data,[64,((len_mod)/64)]);     %串并变换

mod_data = ifft(mod_reshape,64);                         %64位IFFT

len_ifft = len_mod/64; 

%添加循环前缀

mod_data_temp = mod_data;                                %保存调制信号

zero_martix = zeros(64,16);                              %CP长度为16

mod_data = [mod_data,zero_martix];

for m = 1:64

    mod_data(m,:) = [mod_data_temp(m,len_ifft-16+1:len_ifft),mod_data_temp(m,1:len_ifft)];%添加循环前缀

end

%并串变换

mod_data = reshape(mod_data,[1,len_ifft*(1+16/len_ifft)*64]);

len_mod_data = length(mod_data);