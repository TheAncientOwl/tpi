%% Aplica efect de tip sare si piper unei imagini
%% @param img - imaginea
function [noisyImg] = apply_noise(img)
  noisyImg = imnoise(img, "salt & pepper", 0.03);
end
