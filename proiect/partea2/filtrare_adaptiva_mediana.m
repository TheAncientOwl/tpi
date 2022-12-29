%% Exemplu de apel: filtrare_adaptiva_mediana("LENNA.BMP");
function [] = filtrare_adaptiva_mediana(filePath)
    %% ----------------------------- %%
    %%      [Part 1] Summary.        %%
    %% >> Read the image.            %%
    %% >> Create the noisy version.  %%
    %% >> Extend the image.          %%
    %% ----------------------------- %%
    originalImg = imread(filePath);
    noisyImg = imnoise(originalImg, "salt & pepper", 0.03);

    [m, n] = size(originalImg);
    maxRadius = 3;

    extendedImage = zeros(m+maxRadius*2, n+maxRadius*2);
    extendedImage(1+maxRadius:m+maxRadius, 1+maxRadius:n+maxRadius) = noisyImg;

    % extend upper, right, lower, left boundary
    extendedImage(1:maxRadius, maxRadius+1:n+maxRadius) = noisyImg(1:maxRadius, 1:n);
    extendedImage(1:m+maxRadius, n+maxRadius+1:n+2*maxRadius) = extendedImage(1:m+maxRadius, n+1:n+maxRadius);
    extendedImage(m+maxRadius+1:m+2*maxRadius, maxRadius+1:n+2*maxRadius) = extendedImage(m+1:m+maxRadius, maxRadius+1:n+2*maxRadius);
    extendedImage(1:m+2*maxRadius, 1:maxRadius) = extendedImage(1:m+2*maxRadius, maxRadius+1:2*maxRadius);

    %% ------------------------- %%
    %%     [Part 2] Summary.     %%
    %% >> Filter the image.      %%
    %% ------------------------- %%
    filteredImg = zeros(m, n);
    
    for i = 1+maxRadius:m+maxRadius
        disp(["Filtering line: ", num2str(i), " / ", num2str(m)]);
        for j = 1+maxRadius:n+maxRadius
            % Level A
            radius = 1;
            while radius ~= maxRadius + 1
                window = extendedImage(i-radius:i+radius, j-radius:j+radius);
                Zmin = min(window(:));
                Zmax = max(window(:));
                Zmed = median(window(:));
                Zxy = extendedImage(i, j);

                A1 = Zmed - Zmin;
                A2 = Zmed - Zmax;

                if (A1 > 0) && (A2 < 0)
                    % Level B
                    B1 = Zxy - Zmin;
                    B2 = Zxy - Zmax;

                    if (B1 > 0) && (B2 < 0)
                        filteredImg(i-maxRadius, j-maxRadius) = Zxy;
                    else
                        filteredImg(i-maxRadius, j-maxRadius) = Zmed;
                    end
                    break;
                else
                    % Still level A
                    radius = radius + 2;
                    if (radius > maxRadius)
                        filteredImg(i-maxRadius, j-maxRadius) = Zxy;
                        break;
                    end
                end
            end
        end
    end

    %% ------------------------- %%
    %%     [Part 3] Summary.     %%
    %% >> Display the images.    %%
    %% ------------------------- %%
    lines = 1;
    columns = 3;
    plot_image(originalImg, "Imaginea Initiala", lines, columns, 1);
    plot_image(noisyImg, "Imaginea perturbata cu sare si piper", lines, columns, 2);
    plot_image(uint8(filteredImg),  "Imaginea filtrata", lines, columns, 3);
end

function [] = plot_image(img, imgTitle, lines, columns, region)
    subplot(lines, columns, region);
    imshow(img);
    title(imgTitle);
end
