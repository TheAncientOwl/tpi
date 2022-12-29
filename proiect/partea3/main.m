%% Exemplu de apel: main("LENNA.BMP", 9, 'y', 3, 0.01, 0.2, 0.0001); 
%% Exemplu de apel: main("LENNA.BMP", 9, 'y', 3, 0, 0.2, 0.0001); (filtrul Wiener)
%% 
%% @param filePath         - calea de pe disc a imaginii
%% @param it               - intensitatea miscarii
%% @param axisLabel        - directia miscarii ('x' sau 'y')
%% @param medianFilterSize - dimensiunea mastii pentru filtrul median
%% @param alpha            - parametrul de ajustare al filtrului medie geometrica
%% @param gamma            - parametrul de ajustare al filtrului medie geometrica
%% @param epsilon          - defineste vecinatatea lui zero (pentru a evita impartirea)
function [] = main(filePath, it, axisLabel, medianFilterSize, alpha, gamma, epsilon)
%% -------------------------------------------------------------------------------- %%
%% Plan de lucru:                                                                   %%
%% >> Partea 1: (pregatirea imaginii cu efect blur si zgomot de tip sare si piper)  %%
%%   1.1. Citeste imaginea initiala                                                 %%
%%   1.2. Adauga blur imaginii                                                      %%
%%   1.3. Adauga zgomot de tip sare si piper imaginii                               %%
%% -------------------------------------------------------------------------------- %%
  disp(""); disp(">> Partea 1: pregatirea imaginii.");

  disp(">> Se citeste imaginea originala...");
  originalImg = imread(filePath);

  disp([">> Se aplica efect blur pe directia ", axisLabel, "..."]);
  blurredImg = apply_blur_d(originalImg, it, axisLabel);

  disp(">> Se aplica zgomot de tip sare si piper...");
  noisyImg = imnoise(blurredImg, "salt & pepper", 0.03);

%% -------------------------------------------------------------------------------- %%
%% >> Partea 2: (filtrarea imaginii)                                                %%
%%   2.1. Elimina zgomotul cu filtrul median (medfilt2 matlab)                      %%
%%   2.2. Elimina efectul de miscare in caz discret cu filtrul geometric            %%
%% -------------------------------------------------------------------------------- %%
  disp(""); disp(">> Partea 2: filtrarea imaginii.");

  disp(">> Se filtreaza imaginea cu filtrul median pentru eliminarea zgomotului de tip sare si piper...")
  noiseFreeImg = medfilt2(noisyImg, [medianFilterSize, medianFilterSize]);

  disp(">> Se filtreaza imaginea cu filtrul medie geometrica...")
  blurFreeImg = apply_geometric_mean_filter(noiseFreeImg, it, axisLabel, alpha, gamma, epsilon);

%% -------------------------------------------------------------------------------- %%
%% >> Partea 3:                                                                     %%
  %   3.1. Afiseaza imaginile                                                       %%
%% -------------------------------------------------------------------------------- %%
  lines = 2;
  columns = 3;
  plot_image(originalImg, "1. Imaginea originala", lines, columns, 1);
  plot_image(blurredImg, "2. Imaginea cu effect blur pe directia X", lines, columns, 2);
  plot_image(noisyImg, "3. Imaginea cu efect blur pe directia x si zgomot de tip sare si piper", lines, columns, 3);
  plot_image(noiseFreeImg, "4. Imaginea filtrata cu filtrul median", lines, columns, 4);
  plot_image(blurFreeImg, "5. Imaginea filtrata cu filtrul medie geometrica", lines, columns, 5);
end

function [] = plot_image(img, imgTitle, lines, columns, region)
    subplot(lines, columns, region);
    imshow(img);
    title(imgTitle);
end
