function rif = awgn_channel(xif, sigma2, seed)
% 실수 AWGN 추가
    if nargin >= 3
        rng(seed);
    end
    rif = xif(:).' + sqrt(sigma2)*randn(1, numel(xif));
end
