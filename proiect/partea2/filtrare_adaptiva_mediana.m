function [] = filtrare_adaptiva_mediana(filePath)
% function [] = filtrare_adaptiva_mediana()
%% [Part 1] Read the image, create the noisy version.
    originalImg = imread(filePath);
    noisyImg = imnoise(originalImg, "salt & pepper", 0.03);

    % m = 3; n = 3; noisyImg = [1 1 1; 1 1 1; 1 1 1]; display(noisyImg);

%% [Part 2] Extend the image.
    [m, n] = size(originalImg);
    maxRadius = 3;

    extendedImage = zeros(m+maxRadius*2, n+maxRadius*2);

    % copy the noisy img in z
    extendedImage(1+maxRadius:m+maxRadius, 1+maxRadius:n+maxRadius) = noisyImg;

    % extend upper boundary
    extendedImage(1:maxRadius, maxRadius+1:n+maxRadius) = noisyImg(1:maxRadius, 1:n);

    % extend right boundary
    extendedImage(1:m+maxRadius, n+maxRadius+1:n+2*maxRadius) = extendedImage(1:m+maxRadius, n+1:n+maxRadius);
    
    % extend the lower boundary
    extendedImage(m+maxRadius+1:m+2*maxRadius, maxRadius+1:n+2*maxRadius) = extendedImage(m+1:m+maxRadius, maxRadius+1:n+2*maxRadius);

    % extend the left boundary
    extendedImage(1:m+2*maxRadius, 1:maxRadius) = extendedImage(1:m+2*maxRadius, maxRadius+1:2*maxRadius);

    % display(extendedImage);

    display(">> HERE");
%% [Part 3] Filter.
    filteredImg = zeros(m, n);
    
    for i = 1+maxRadius:m+maxRadius
        disp(["Line: ", num2str(i), " / ", num2str(m)]);
        for j = 1+maxRadius:n+maxRadius
        % disp('-----------------------------------------------------');
        % disp(['x(', num2str(i), ") y(", num2str(j), ")"]);
            % Level A
            radius = 1;
            while radius ~= maxRadius + 1
                % disp(["radius: ", num2str(radius)]);
                window = extendedImage(i-radius:i+radius, j-radius:j+radius);
                Zmin = min(window(:));
                Zmax = max(window(:));
                Zmed = median(window(:));
                Zxy = extendedImage(i, j);
                % disp(["Zmin(", num2str(Zmin), ") Zmax(", num2str(Zmax), ") Zmed(", num2str(Zmed), ") Zxy(", num2str(Zxy), ") | x(", num2str(i), ") y(", num2str(j), ")"]);

                A1 = Zmed - Zmin;
                A2 = Zmed - Zmax;

                if (A1 > 0) && (A2 < 0)
                    % Level B
                    B1 = Zxy - Zmin;
                    B2 = Zxy - Zmax;

                    if (B1 > 0) && (B2 < 0)
                        filteredImg(i-maxRadius, j-maxRadius) = Zxy;
                        % disp(["Output: Zxy(", num2str(Zxy), ")"]);
                    else
                        filteredImg(i-maxRadius, j-maxRadius) = Zmed;
                        % disp(["Output: Zmed(", num2str(Zmed), ")"]);
                    end
                    break;
                else
                    % Still level A
                    radius = radius + 2;
                    if (radius > maxRadius)
                        filteredImg(i-maxRadius, j-maxRadius) = Zxy;
                        % disp(["Output: Zxy(", num2str(Zxy), ")"]);
                        break;
                    end
                end
            end
        end
    end

    display_image(originalImg, "Imaginea Initiala");
    display_image(noisyImg, "Imaginea perturbata cu sare si piper");
    display_image(uint8(filteredImg),  "Imaginea filtrata");
end

function [] = display_image(img, imgTitle)
    figure
    imshow(img);
    title(imgTitle);
end
