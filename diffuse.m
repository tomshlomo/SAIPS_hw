function J = diffuse(I, iterations, medfilt)

if medfilt
    I = medfilt2(I, [5, 5]);
end

if iterations>0
    % [gradThresh,numIter] = imdiffuseest(I);
    J = imdiffusefilt(I,'GradientThreshold', ...
        10,'NumberOfIterations',iterations);
else
    J = I;
end
figure;
tiledlayout(1, 2);
nexttile();
imshow(I,[]);
nexttile();
imshow(J,[]);

end