function [shat, Ihat, Qhat] = ml_detect(y)
% QPSK ML 검출 = I/Q 부호 판정
    Ihat = 2*(real(y) >= 0) - 1;
    Qhat = 2*(imag(y) >= 0) - 1;
    shat = (Ihat + 1j*Qhat) / sqrt(2);
end
