function p = params()
% 시뮬레이션 파라미터
    p.M    = 4;            % QPSK
    p.k    = log2(p.M);
    p.Nbit = 1e6;

    p.Rs    = 1e6;         % 심볼률 1 MHz
    p.Tsym  = 1/p.Rs;
    p.fIF   = 2e6;         % IF 2 MHz
    p.L     = 6;           % 업샘플 인수
    p.fs    = p.L*p.Rs;    % 6 MHz
    p.Tsamp = 1/p.fs;

    p.alpha = 0.25;        % RRC roll-off
    p.span  = 10;          % RRC span [심볼]

    p.EsN0_dB = -2:1:12;
    p.seed    = 12345;
end
