%% Exemple de apel
%perturba_DM('LENNAA.bmp', 9, 1); 
%perturba_DM('LENNAA.bmp', 11, 2); 
%perturba_DM('im2.tif', 11, 1); 
%perturba_DM('im2.tif', 7, 2); 

%% Perturba imaginea img prin inducerea efectului de miscare in caz discret
% axisLabel = 1 - pe directia x,  pt = 2 - directia y
function [blurredImg] = apply_blur_d(img, it, axisLabel)
  J = img(:, :, 1);
  [m, n] = size(J);

  f = double(J);

  %calculul TFD a imaginii 
  TFDfc = fft2(f);

  %calculul filtrului
  TFDh = motion_blur_d(m, n, it, axisLabel);

  %filtrarea in domeniul frecventelor
  TFDg = TFDh.*TFDfc;

  % calculul imaginii filtrate
  blurredImg = uint8(abs(ifft2(TFDg)));
end
