% 송신 체인 확인 (20비트)
clear; clc;
p = params();
g = rrc_filter(p.alpha, p.span, p.L);

bits = [0 1 1 1 0 0 0 1 1 1 0 1 1 0 0 0 0 1 0 0];
s   = qpsk_map(bits);
su  = upsample_L(s, p.L);
x   = pulse_shape(su, g);
xif = upconvert(x, p.fIF, p.fs);

fprintf('평균 심볼에너지 E[|s|^2]: %.4f\n', mean(abs(s).^2));
fprintf('Ppb/Pbb: %.4f\n', mean(xif.^2)/mean(abs(x).^2));
