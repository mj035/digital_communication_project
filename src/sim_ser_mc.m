function [EsN0, SER, BER, totSym] = sim_ser_mc(L, minErr, blockSym, maxSym)
% SNR별 SER 시뮬. 각 점에서 심볼오류 minErr개 모일 때까지 누적 -> 고SNR도 정확
    if nargin < 2 || isempty(minErr),   minErr   = 500;   end
    if nargin < 3 || isempty(blockSym), blockSym = 5e5;   end
    if nargin < 4 || isempty(maxSym),   maxSym   = 1e7;   end

    p = params();
    p.L = L;  p.fs = p.L*p.Rs;  p.Tsamp = 1/p.fs;     % fs는 L에 따라 변함
    g  = rrc_filter(p.alpha, p.span, p.L);
    Ng = numel(g);

    EsN0   = p.EsN0_dB;
    SER    = zeros(size(EsN0));
    BER    = zeros(size(EsN0));
    totSym = zeros(size(EsN0));

    rng(p.seed);
    for i = 1:numel(EsN0)
        sigma2 = 1/(2*10^(EsN0(i)/10));               % sigma^2 = 1/(2*gamma)
        symErr = 0;  bitErr = 0;  nSym = 0;
        while (nSym < maxSym) && (symErr < minErr)
            bits  = gen_bits(blockSym*p.k);
            Ibits = bits(1:2:end);  Qbits = bits(2:2:end);
            s   = qpsk_map(bits);
            su  = upsample_L(s, p.L);
            x   = pulse_shape(su, g);
            xif = upconvert(x, p.fIF, p.fs);
            rif = awgn_channel(xif, sigma2);
            r   = downconvert(rif, p.fIF, p.fs);
            rt  = matched_filter(r, g);
            y   = downsample_sym(rt, p.L, Ng, blockSym);
            [~, Ihat, Qhat] = ml_detect(y);
            Ierr = (Ihat < 0) ~= Ibits;
            Qerr = (Qhat < 0) ~= Qbits;
            symErr = symErr + sum(Ierr | Qerr);
            bitErr = bitErr + sum(Ierr) + sum(Qerr);
            nSym   = nSym + blockSym;
        end
        SER(i)    = symErr / nSym;
        BER(i)    = bitErr / (nSym * p.k);
        totSym(i) = nSym;
    end
end
