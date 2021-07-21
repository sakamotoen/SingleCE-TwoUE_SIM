# SingleCE-TwoUE_SIM
考虑一个简单的单小区蜂窝通信系统，基站配置8 根天线/通道。小区内假设有2 个单天线用户，采用
OFDM 调制方式， 64 个子载波，CP 长度为16。仅考虑基站每根天线到每个用户之间的信道经历小尺度
衰落（为了简化问题，不考虑大尺度衰落），小尺度衰落是频率选择性衰落信道（假设每个用户等效基带
信道长度为10，每个信道系数的统计特性满足Rayleigh 分布），且这些信道均独立衰落。
两个用户和基站之间的通信分为上行和下行两个时隙：
1. 下行时隙为广播阶段，基站有完全相同的信息要发给两个用户，假设两个用户与基站之间的时间
和频率已经理想同步。此时基站采用空时编码技术。为了简化发射方案，基站随机选择两个天线，
并采用Alamouti 空时编码发射（在连续的两个OFDM 符号块之间在相同的子载波上采用Alamouti
空时编码，假设信道在相邻两个OFDM 块之内不变化）。用户各自对接收到的信号进行解调。假
设通过信道训练和估计，用户已知各自的精确信道系数，并假设用户接收机白噪声功率归一化为
1（0dBm）。
2. 上行时隙，两个用户同时同频发送各自的信号给基站，因此基站将收到两个信号的叠加。为了正
确接收两个用户的上行信号，基站可以利用多天线进行下面两种逐子载波操作以分离两个用户的
信号：1)利用MMSE 接收机；2）利用迫零接收机。假设两个用户与基站之间的时间和频率已经
理想同步，且基站精确已知每个用户的上行信道。并假设基站接收机白噪声功率归一化为1
（0dBm）。
完成下列问题：
(1). 为了简化问题，考虑基带等效系统（不考虑脉冲成型、上下变频等过程），并不考虑信道编码，
通过Matlab 编程实现上述发射接收过程；
(2). 下行时隙，假设基站采用OPSK 星座，画出基站发射功率从0dB-20dB 的两个用户各自的误比特率
曲线；
3. 上行时隙，假设每个用户的发射功率均为从0dB-20dB，星座点选择范围为三种正方形QAM（QPSK，
16QAM，64QAM），试分别画出三种调制下两用户各自的误比特率曲线。
