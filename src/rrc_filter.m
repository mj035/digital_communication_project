function g = rrc_filter(alpha, span, L)
% RRC FIR 필터 생성 후 에너지 정규화
    N   = round(span*L/2);
    n   = -N:N;
    tau = n / L;                                  % 정규화 시간 t/Tsym

    h = zeros(size(tau));
    idx0 = abs(tau) < 1e-10;                      % tau = 0 특이점
    idxs = abs(abs(4*alpha*tau) - 1) < 1e-10;     % tau = ±1/(4a) 특이점
    idxg = ~(idx0 | idxs);

    tg = tau(idxg);
    h(idxg) = (sin(pi*tg*(1-alpha)) + 4*alpha*tg.*cos(pi*tg*(1+alpha))) ...
              ./ (pi*tg.*(1 - (4*alpha*tg).^2));

    h(idx0) = 1 - alpha + 4*alpha/pi;             % L'Hopital 극한
    if any(idxs)
        h(idxs) = (alpha/sqrt(2)) * ((1+2/pi)*sin(pi/(4*alpha)) + (1-2/pi)*cos(pi/(4*alpha)));
    end

    g = h / sqrt(sum(h.^2));                       % sum(g^2) = 1
end
