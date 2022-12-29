%% Perturba imaginea img prin inducerea efectului de miscare in caz discret
%% @param img       - imaginea careia trebuie aplicat efectul de tip blur 
%% @param it        - intensitatea miscarii
%% @param axisLabel - directia miscarii ('x' sau 'y')
function [blurredImg] = apply_blur_d(img, it, axisLabel)
  f = double(img(:, :, 1));
  [m, n] = size(f);

  %calculul TFD a imaginii 
  TFDfc = fft2(f);

  %calculul filtrului
  TFDh = motion_blur_d(m, n, it, axisLabel);

  %filtrarea in domeniul frecventelor
  TFDg = TFDh.*TFDfc;

  % calculul imaginii filtrate
  blurredImg = uint8(abs(ifft2(TFDg)));
end
