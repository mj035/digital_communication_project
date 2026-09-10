function su = upsample_L(s, L)
% 심볼 사이에 0을 (L-1)개 삽입
    s  = s(:).';
    su = zeros(1, numel(s)*L);
    su(1:L:end) = s;
end
