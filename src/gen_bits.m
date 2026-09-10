function bits = gen_bits(Nbit, seed)
% 랜덤 비트 생성 (seed 주면 고정)
    if nargin >= 2
        rng(seed);
    end
    bits = randi([0 1], 1, Nbit);
end
