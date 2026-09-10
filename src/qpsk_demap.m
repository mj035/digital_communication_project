function bits = qpsk_demap(Ihat, Qhat)
% I/Q 부호 -> 비트 (매핑의 역)
    b1 = (Ihat(:).' < 0);       % +1->0, -1->1
    b2 = (Qhat(:).' < 0);
    bits = reshape([b1; b2], 1, []);
end
