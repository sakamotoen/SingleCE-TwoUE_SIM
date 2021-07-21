clc
close all;
clear all;
a = 0:10000;
data = randi([0,63],1,10000);
b = qammod(data,64);
plot(b,'o');
title('64QAM星座图');