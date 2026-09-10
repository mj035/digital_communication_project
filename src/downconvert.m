function r = downconvert(rif, fIF, fs)
% IF passband -> 복소 baseband (sqrt(2) 정규화)
    n  = 0:numel(rif)-1;
    rI =  sqrt(2) * rif(:).' .* cos(2*pi*fIF*n/fs);
    rQ = -sqrt(2) * rif(:).' .* sin(2*pi*fIF*n/fs);     % Q는 -sin
    r  = rI + 1j*rQ;
end
