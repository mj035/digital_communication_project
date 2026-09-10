% 수신 체인 확인: 무잡음 루프백(y≈s) + 10 dB
clear; clc;
p = params();
g  = rrc_filter(p.alpha, p.span, p.L);
Ng = numel(g);

bits = [0 1 1 1 0 0 0 1 1 1 0 1 1 0 0 0 0 1 0 0];
Nsym = numel(bits)/p.k;
s   = qpsk_map(bits);
su  = upsample_L(s, p.L);
x   = pulse_shape(su, g);
xif = upconvert(x, p.fIF, p.fs);

% 무잡음
r  = downconvert(xif, p.fIF, p.fs);
rt = matched_filter(r, g);
y  = downsample_sym(rt, p.L, Ng, Nsym);
[~, Ihat, Qhat] = ml_detect(y);
fprintf('무잡음 max|y-s|: %.3e, 비트오류: %d\n', max(abs(y-s)), sum(qpsk_demap(Ihat,Qhat) ~= bits));

% 10 dB
sigma2 = 1/(2*10^(10/10));
rif = awgn_channel(xif, sigma2, p.seed);
y2  = downsample_sym(matched_filter(downconvert(rif,p.fIF,p.fs), g), p.L, Ng, Nsym);
[~, Ih2, Qh2] = ml_detect(y2);
fprintf('10dB 비트오류: %d\n', sum(qpsk_demap(Ih2,Qh2) ~= bits));
