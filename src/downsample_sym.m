function y = downsample_sym(rt, L, Ng, Nsym)
% 심볼 시점 추출 (송수신 RRC 그룹지연 보정: 1-based 인덱스 (k-1)*L + Ng)
    idx = (0:Nsym-1)*L + Ng;
    y   = rt(idx);
end
