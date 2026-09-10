% 검증2: QPSK SER 시뮬레이션 vs 이론
clear; clc;
[EsN0, SER_sim, BER_sim] = sim_ser_mc(6, 500);

gam = 10.^(EsN0/10);
Pi  = qfunc_local(sqrt(gam));
SER_exact  = 2*Pi - Pi.^2;
SER_approx = 2*Pi;
SER_union  = 3*Pi;

fprintf(' Ex/N0   SER_sim     SER_exact   ratio\n');
for i = 1:numel(EsN0)
    fprintf(' %5.1f   %.4e  %.4e  %.3f\n', EsN0(i), SER_sim(i), SER_exact(i), SER_sim(i)/SER_exact(i));
end

figure;
semilogy(EsN0, SER_exact, 'k-',  'LineWidth',1.5); hold on;
semilogy(EsN0, SER_approx,'r--', 'LineWidth',1.5);
semilogy(EsN0, SER_union, 'b-.', 'LineWidth',1.5);
semilogy(EsN0, SER_sim,   'ko',  'MarkerSize',7, 'MarkerFaceColor','k');
grid on; ylim([1e-5 1]);
xlabel('E_x/N_0 [dB]'); ylabel('SER'); title('QPSK SER');
legend('Exact','Approx (High SNR)','Union Bound','Simulation','Location','southwest');
figure_light(gcf);

save('ser_results.mat','EsN0','SER_sim','BER_sim','SER_exact','SER_approx','SER_union');
