function x = pulse_shape(su, g)
% RRC 펄스 성형
    x = conv(su, g);
end
