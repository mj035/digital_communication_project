% 검증4: 업샘플 인수 L=3 vs L=6 SER 비교
clear; clc;
p = params();

[EsN0, SER6] = sim_ser_mc(6, 500);
[~,    SER3] = sim_ser_mc(3, 500);

gam = 10.^(EsN0/10);
Pi  = qfunc_local(sqrt(gam));
SER_exact = 2*Pi - Pi.^2;

% 나이퀴스트 여유: 신호 상단 vs fs/2
upper = p.fIF + (1+p.alpha)/2 * p.Rs;
fprintf('신호 상단 %.3f MHz | fs/2: L=6 %.1f MHz, L=3 %.1f MHz\n', ...
        upper/1e6, 6*p.Rs/2/1e6, 3*p.Rs/2/1e6);

fprintf(' Ex/N0   SER(L=6)    SER(L=3)\n');
for i = 1:numel(EsN0)
    fprintf(' %5.1f   %.4e  %.4e\n', EsN0(i), SER6(i), SER3(i));
end

figure;
semilogy(EsN0, SER_exact,'k-','LineWidth',1.5); hold on;
semilogy(EsN0, SER6,'bo-','MarkerSize',6);
semilogy(EsN0, SER3,'rs--','MarkerSize',6);
grid on; ylim([1e-5 1]);
xlabel('E_x/N_0 [dB]'); ylabel('SER'); title('L=3 vs L=6');
legend('이론 Exact','L=6','L=3','Location','southwest');
figure_light(gcf);
