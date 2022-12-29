function [noisyImg] = apply_noise(img)
  noisyImg = imnoise(img, "salt & pepper", 0.03);
end
