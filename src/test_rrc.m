% RRC 필터 확인: 탭수, 에너지, 대칭, ISI-free
clear; clc;
p = params();
g = rrc_filter(p.alpha, p.span, p.L);

fprintf('탭 수: %d\n', numel(g));
fprintf('에너지 sum(g^2): %.6f\n', sum(g.^2));
fprintf('대칭성: %.3e\n', max(abs(g - fliplr(g))));

prc = conv(g, g);               % 매치드필터 결합 = RC 펄스
c   = (numel(prc)+1)/2;
fprintf('RC 피크: %.4f\n', prc(c));
for m = -3:3
    fprintf('  m=%+d: %+.6f\n', m, prc(c + m*p.L));
end

figure;
subplot(2,1,1);
nidx = (-(numel(g)-1)/2:(numel(g)-1)/2) / p.L;
stem(nidx, g, 'filled'); grid on;
xlabel('Time [symbol periods]'); ylabel('g[n]'); title('RRC impulse response');
subplot(2,1,2);
nrc = (-(numel(prc)-1)/2:(numel(prc)-1)/2) / p.L;
plot(nrc, prc,'b-'); hold on; stem(-3:3, prc(c + (-3:3)*p.L),'r','filled'); grid on;
xlabel('Time [symbol periods]'); ylabel('RC pulse'); title('Matched-filter cascade');
