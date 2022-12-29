function [hTFD] = motion_blur_d(l, c, it, axisLabel)
    % calcularea perturbarii tip miscare discreta pe directia x sau y
    % in domeniul de frecvente
    % I: l, c - dimensiuni matrice perturbare (nr. linii / nr. coloane)
    %    it - intensitatea ("viteza") miscarii (intreg)
    %    axisLabel - directia miscarii ('x' - directia x, 'y' - directia y)
    % E: hTFD - matricea perturbare (impuls) in domeniul de frecvente
    
    hTFD = zeros(l, c);
    if axisLabel == 'x' %miscare pe directia x
        for y = 1:c
            for x = 1:l-1
                hTFD(x+1, y) = (1/it)*(sin(pi*(x*it/l))/sin(pi*(x/l)))*exp(-1i*pi*x*(it-1)/l);
            end
            hTFD(1, y) = 1;
        end
    else %miscare pe directia y
        for x = 1:l
            for y = 1:c-1
                hTFD(x, y+1) = (1/it)*(sin(pi*(y*it/c))/sin(pi*(y/c)))*exp(-1i*pi*y*(it-1)/c);
            end
            hTFD(x, 1) = 1;
        end
    end
end