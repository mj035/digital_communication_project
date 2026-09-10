% 검증3: 수신 심볼 성상도 (Ex/N0 = 5, 10, 15 dB)
clear; clc;
p = params();
g  = rrc_filter(p.alpha, p.span, p.L);
Ng = numel(g);

rng(p.seed);
bits = gen_bits(1e5);
Nsym = numel(bits)/p.k;
s   = qpsk_map(bits);
su  = upsample_L(s, p.L);
x   = pulse_shape(su, g);
xif = upconvert(x, p.fIF, p.fs);

SNRs  = [5 10 15];
Nshow = min(Nsym, 20000);       % 산점도 과밀 방지

figure;
subplot(2,2,1);
plot(real(s(1:Nshow)), imag(s(1:Nshow)), 'k.', 'MarkerSize', 12); grid on; axis square;
xlim([-2 2]); ylim([-2 2]); xlabel('I'); ylabel('Q'); title('송신 심볼 (Gray 코딩)');
a = 1/sqrt(2);                                  % Gray 비트 레이블 (b1=I부호, b2=Q부호)
gc = [0 0.5 0];
text( a,  a+0.28, '00', 'Color',gc,'FontWeight','bold','HorizontalAlignment','center');
text(-a,  a+0.28, '10', 'Color',gc,'FontWeight','bold','HorizontalAlignment','center');
text(-a, -a-0.28, '11', 'Color',gc,'FontWeight','bold','HorizontalAlignment','center');
text( a, -a-0.28, '01', 'Color',gc,'FontWeight','bold','HorizontalAlignment','center');

for idx = 1:numel(SNRs)
    sigma2 = 1/(2*10^(SNRs(idx)/10));
    rif = awgn_channel(xif, sigma2);
    r   = downconvert(rif, p.fIF, p.fs);
    rt  = matched_filter(r, g);
    y   = downsample_sym(rt, p.L, Ng, Nsym);

    subplot(2,2,idx+1);
    plot(real(y(1:Nshow)), imag(y(1:Nshow)), 'r.', 'MarkerSize',1); hold on;
    plot([-1 -1 1 1]/sqrt(2), [-1 1 -1 1]/sqrt(2), 'k.', 'MarkerSize',12);
    grid on; axis square; xlim([-2 2]); ylim([-2 2]);
    xlabel('I'); ylabel('Q'); title(sprintf('E_x/N_0 = %d dB', SNRs(idx)));

    nse = y - s;                % 클러스터 분산이 sigma^2 와 일치하는지
    fprintf('%2d dB: 잡음분산 I=%.4f Q=%.4f (이론 %.4f)\n', ...
            SNRs(idx), var(real(nse)), var(imag(nse)), sigma2);
end
figure_light(gcf);
