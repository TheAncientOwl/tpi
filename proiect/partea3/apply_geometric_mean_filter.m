%% Aplica filtrul medie geometrica in domeniul frecventelor 
%% @param it               - intensitatea miscarii
%% @param axisLabel        - directia miscarii ('x' sau 'y')
%% @param alpha            - parametrul de ajustare al filtrului medie geometrica
%% @param gamma            - parametrul de ajustare al filtrului medie geometrica
%% @param epsilon          - defineste vecinatatea lui zero (pentru a evita impartirea)
function [filteredImg] = apply_geometric_mean_filter(img, it, axisLabel, alpha, gamma, epsilon)
  [m, n] = size(img);
  
  lTFD = laplace_fr(m, n);

  g = double(img);
  gTFD = fft2(g);

  hTFD = motion_blur_d(m, n, it, axisLabel);

  fTFD = zeros(m, n);
    for x = 1:m
        for y = 1:n
            % geom part
            geomPart = (abs(hTFD(x, y)) / (abs(hTFD(x, y)))^2) ^ alpha;

            % wiener part
            numitor = (abs(hTFD(x, y)))^2 + gamma*(abs(lTFD(x, y))^2);
            if numitor > epsilon
                val = (hTFD(x, y))' / numitor;
            else
                val = 1;
            end
            wienerPart = (gTFD(x, y)*val)^ (1 - alpha);

            % result
            fTFD(x, y) = geomPart * wienerPart;
        end
    end

  filteredImg = uint8(abs(ifft2(fTFD))); 
end

function [hTFD] = laplace_fr(l, c)
    % reprezentarea filtrului spatial Laplace in domeniul de frecvente 
    % NU se face filtrarea Laplace, deci NU se face centrare
    % I: l, c - dimensiunile filtrului care trebuie construit
    %    w - matricea filtrului spatial Laplace
    % E: TFDh - filtrul in domeniul de frecvente construit
    
    % construire matrice (l, c) nula, cu matricea w in centru
    w = [0 -1 0; -1 4 -1; 0 -1 0];
    [m, n] = size(w);
    h = zeros(l, c);
    l1 = uint16(l/2);
    c1 = uint16(c/2);
    for i = -(m-1)/2:(m-1)/2
        for j = -(n-1)/2:(n-1)/2
            h(l1+i, c1+j) = w(i+(m-1)/2+1, j+(n-1)/2+1);
        end
    end
    
    % aplicarea transformarii fourier pentru obtinerea filtrului in frecv.
    hTFD = fft2(h);
end
