%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%用于ofdm解码，包括串并变换，
%FFT变换等部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [decode] = OFDM_decode(rx_data_temp,len_all)
rx_data_temp = rx_data(:,1:len_all);
rx_data_temp = reshape(rx_data_temp,[64,(len_all/64)]);
rx_data_temp = rx_data_temp(:,17:len_all/64);
rx_data_temp = fft(rx_data_temp,64);
rx_data_temp = reshape(1,64*(len_all/4-16)*4);
decode = rx_data_temp;