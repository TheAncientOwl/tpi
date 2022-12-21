function [R] = filtreaza(matrix, mask)
    [m, n] = size(matrix);
    [m1, n1] = size(mask);

    % extinderea imaginii cu cate m1 - 1 linii deasupra / sub imagine si cate n1 - 1 coloane la stanga / dreapta imaginii 
    l = m + 2 * m1 - 2;
    c = n + 2 * n1 - 2;
    f = zeros(l, c);
    f(m1:m + m1 - 1, n1:n + n1 - 1) = matrix;

    % calculul matricei rezultat al corelatiei / convolutie
    g = zeros(l, c);
    a = (m1 - 1) / 2;b = (n1 - 1) / 2;

    % filtrare cu masca mask
    for x = m1:m + m1 - 1
        for y = n1:n + n1 - 1
            for s = 1:m1
                for t = 1:n1
                    % convolutie
                    g(x, y) = g(x, y) + mask(s, t) * f(x - s + a + 1, y - t + b + 1);
                end
            end
        end
    end
    R = g(m1:m + m1 - 1, n1:n + n1 - 1);
end
