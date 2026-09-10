% 검증1: 송신 단계별 파형 및 스펙트럼 (입력 20비트), 가이드 그림7 구성에 맞춤
clear; clc;
p = params();
g  = rrc_filter(p.alpha, p.span, p.L);
Ng = numel(g);

bits = [0 1 1 1 0 0 0 1 1 1 0 1 1 0 0 0 0 1 0 0];   % 01 11 00 01 11 01 10 00 01 00
Nsym = numel(bits)/p.k;

s   = qpsk_map(bits);
su  = upsample_L(s, p.L);
x   = pulse_shape(su, g);
xif = upconvert(x, p.fIF, p.fs);

idxsym = 1:Nsym;                                    % 1-based 심볼 인덱스
t_su = (0:numel(su)-1) * p.Tsamp * 1e6;             % 업샘플 [us]
gd   = (Ng-1)/2;                                    % 필터 그룹지연 [샘플]
t_x  = ((0:numel(x)-1) - gd) * p.Tsamp * 1e6;       % 지연 보정 [us] (심볼 0~9us)

% 표시용 연속곡선 재구성 (이산 직선연결은 각지므로 baseband/passband 공통 사용)
F  = 40;
nf = 0:1/F:(numel(x)-1);
xI_f = interp1(0:numel(x)-1, real(x), nf, 'spline');
xQ_f = interp1(0:numel(x)-1, imag(x), nf, 'spline');
t_f  = (nf - gd) * p.Tsamp * 1e6;

% (a)~(d) 심볼 / 업샘플
figure;
subplot(2,2,1); stem(idxsym, real(s),'b','filled'); grid on; ylim([-1 1]);
  xlabel('Symbol Index'); ylabel('Amplitude'); title('(a) QPSK 심볼 I');
subplot(2,2,3); stem(idxsym, imag(s),'r','filled'); grid on; ylim([-1 1]);
  xlabel('Symbol Index'); ylabel('Amplitude'); title('(b) QPSK 심볼 Q');
subplot(2,2,2); stem(t_su, real(su),'b','filled'); grid on; ylim([-1 1]);
  xlabel('Time [\mus]'); ylabel('Amplitude'); title('(c) 업샘플 I');
subplot(2,2,4); stem(t_su, imag(su),'r','filled'); grid on; ylim([-1 1]);
  xlabel('Time [\mus]'); ylabel('Amplitude'); title('(d) 업샘플 Q');
figure_light(gcf);

% (e)(f) RRC 임펄스 / 주파수 응답
figure;
subplot(2,1,1);
nrrc = (-(Ng-1)/2:(Ng-1)/2) / p.L;
stem(nrrc, g, 'filled', 'MarkerSize', 3); grid on;
  xlabel('Time [symbol periods]'); ylabel('g_{tx}[n]'); title('(e) RRC 임펄스 응답');
subplot(2,1,2);
Nf = 4096;
G  = fftshift(fft(g, Nf));
fG = (-Nf/2:Nf/2-1) * (p.fs/Nf) / 1e6;
plot(fG, 20*log10(abs(G)/max(abs(G))), 'b-'); grid on;
  xlabel('Frequency [MHz]'); ylabel('|G(f)| [dB]'); title('(f) RRC 주파수 응답');
  xlim([-3 3]); ylim([-80 5]);
figure_light(gcf);

% (g)(h) 펄스성형 후 기저대역 (지연 보정)
figure;
subplot(2,1,1); plot(t_f, xI_f,'b-'); hold on; stem(t_x, real(x),'b','filled','MarkerSize',3);
  grid on; xlim([0 Nsym-1]); xlabel('Time [\mus]'); ylabel('Amplitude'); title('(g) Baseband I');
  legend('x_I(t)','x_I[n]','Location','northeast');
subplot(2,1,2); plot(t_f, xQ_f,'r-'); hold on; stem(t_x, imag(x),'r','filled','MarkerSize',3);
  grid on; xlim([0 Nsym-1]); xlabel('Time [\mus]'); ylabel('Amplitude'); title('(h) Baseband Q');
  legend('x_Q(t)','x_Q[n]','Location','northeast');
figure_light(gcf);

% (i) Passband 시간 / (j) 단측 스펙트럼
xif_f = sqrt(2) * (xI_f.*cos(2*pi*p.fIF/p.fs*nf) - xQ_f.*sin(2*pi*p.fIF/p.fs*nf));

figure;
subplot(2,1,1); plot(t_f, xif_f, '-', 'Color', [0.5 0.5 0.5]); hold on;
  plot(t_x, xif, 'k.', 'MarkerSize', 9);
  grid on; xlim([0 Nsym-1]); xlabel('Time [\mus]'); ylabel('Amplitude');
  title('(i) Passband x_{IF}[n]'); legend('x_{IF}(t)','x_{IF}[n]','Location','northeast');

Nfft = 4096;
X = fft(xif, Nfft);
f = (0:Nfft-1) * (p.fs/Nfft) / 1e6;
half = 1:(Nfft/2+1);
mag = 20*log10(abs(X(half)) / max(abs(X(half))));
W  = (1+p.alpha)/2 * p.Rs / 1e6;
fc = p.fIF/1e6;
subplot(2,1,2); plot(f(half), mag,'b-'); grid on;
  xlabel('Frequency [MHz]'); ylabel('Magnitude [dB]'); ylim([-100 5]); xlim([0 3]);
  title('(j) Passband 단측 스펙트럼'); hold on;
  xline(fc,'r--'); xline(fc-W,'g:'); xline(fc+W,'g:');
figure_light(gcf);

P = abs(X(half)).^2;
inband = (f(half) >= fc-W) & (f(half) <= fc+W);
fprintf('대역 [%.3f, %.3f] MHz 내 에너지 비율: %.1f%%\n', fc-W, fc+W, 100*sum(P(inband))/sum(P));
