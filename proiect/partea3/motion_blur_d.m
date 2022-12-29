function [hTFD] = motion_blur_d(l, c, iT, dir)
    % calcularea perturbarii tip miscare discreta pe directia x sau y
    % in domeniul de frecvente
    % I: l, c - dimensiuni matrice perturbare (nr. linii / nr. coloane)
    %    iT - intensitatea ("viteza") miscarii (intreg)
    %    dir - directia miscarii ('x' - directia x, 'y' - directia y)
    % E: hTFD - matricea perturbare (impuls) in domeniul de frecvente
    
    hTFD = zeros(l, c);
    if dir == 'x' %miscare pe directia x
        for y = 1:c
            for x = 1:l-1
                hTFD(x+1, y) = (1/iT)*(sin(pi*(x*iT/l))/sin(pi*(x/l)))*exp(-1i*pi*x*(iT-1)/l);
            end
            hTFD(1, y) = 1;
        end
    else %miscare pe directia y
        for x = 1:l
            for y = 1:c-1
                hTFD(x, y+1) = (1/iT)*(sin(pi*(y*iT/c))/sin(pi*(y/c)))*exp(-1i*pi*y*(iT-1)/c);
            end
            hTFD(x, 1) = 1;
        end
    end
end