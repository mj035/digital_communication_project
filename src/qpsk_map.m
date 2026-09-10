function s = qpsk_map(bits)
% 비트 -> Gray QPSK 심볼 (단위 에너지)
    b  = bits(:).';
    b1 = b(1:2:end);            % I 비트
    b2 = b(2:2:end);            % Q 비트
    I = 1 - 2*b1;               % 0->+1, 1->-1
    Q = 1 - 2*b2;
    s = (I + 1j*Q) / sqrt(2);   % E[|s|^2] = 1
end
