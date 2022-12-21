% Exemplu de apel:
% unsharp_masking('LENNA.BMP');

function [] = unsharp_masking(fisierImagine)
    disp('> Citirea imaginii...');
    imagineaOriginala = imread(fisierImagine);
    [m, n, p] = size(imagineaOriginala);

    display_image(imagineaOriginala, 'Imaginea originala');

    % masca pentru filtrare medie
    disp('> Crearea mastii de filtrare medie...');
    w = [1 1 1; 1 1 1; 1 1 1];
    [m1, n1] = size(w);
    suma = sum(sum(w));
    w = w / suma;

    % nivelarea imaginii
    disp('> Nivelarea imaginii...');
    imagineaNivelata = zeros(m, n, p);
    for iPlan = 1:p
        plan = double(imagineaOriginala(:, :, iPlan));
        imagineaNivelata(:, :, iPlan) = filtreaza(plan, w);
    end

    display_image(uint8(imagineaNivelata), 'Imaginea nivelata cu filtru medie');

    disp('> Aplicare formula unsharp masking...');
    % unsharp masking
    % (Imagine originală – o variantă nivelată) + Imaginea originală 
    unsharp = imagineaOriginala - imagineaNivelata + imagineaOriginala;
    display_image(uint8(unsharp), 'Rezultat unsharp masking');
end

function []  =  display_image(img, imgTitle)
    figure
    imshow(img);
    title(imgTitle);
end
