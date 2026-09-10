function rt = matched_filter(r, g)
% RRC 매치드 필터 (2*fIF 성분도 여기서 제거됨)
    rt = conv(r, g);
end
