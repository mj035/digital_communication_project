function xif = upconvert(x, fIF, fs)
% baseband -> IF passband (sqrt(2) 정규화로 전력 보존)
    n   = 0:numel(x)-1;
    xif = sqrt(2) * real(x(:).' .* exp(1j*2*pi*fIF*n/fs));
end
