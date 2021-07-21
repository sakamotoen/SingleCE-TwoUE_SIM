%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%UE发射函数，输入为待调制符号x，发射方式为:
%i=2:QPSK
%i=3:16QAM
%i=4:64QAM
%data为待调制数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mod_data,len_all] = UE_tx(data,i)
if i == 2
    mod_data = pskmod(data,2^i,pi/4);                            %QPSK调制
elseif i == 4
    mod_data = qammod(data,2^i);                            %16QAM调制
elseif i == 6
    mod_data = qammod(data,2^i);                            %64QAM调制
end
len_all = length(mod_data);
