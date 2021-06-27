clear all
clc

% setup
info = enviinfo('croped.hdr');
hcube = hypercube(info.Filename);
rgbImg = colorize(hcube,'Method','rgb','ContrastStretching',true);
fileroot = matlabshared.supportpkg.getSupportPackageRoot();
addpath(fullfile(fileroot,'toolbox','images','supportpackages','hyperspectral','hyperdata','ECOSTRESSSpectraFiles'));
lib = readEcostressSig("manmade.roofingmaterial.metal.solid.all.0692uuucop.jhu.becknic.spectrum.txt");
wavelength = lib.Wavelength;
reflectance = lib.Reflectance;
datacube = hcube.DataCube;


% task a
point1 = datacube(100,100,:);
point2 = datacube(100,350,:);
point3 = datacube(350,350,:);

plot(point1(:))


% task b
angleThreshold = 6; %angle threshold
figure;
result = SAMonAllPixels(datacube, point1, angleThreshold);
imshow(result)

figure;
result2 = SAMonAllPixels(datacube, point2, angleThreshold);
imshow(result2)

figure;
result3 = SAMonAllPixels(datacube, point3, angleThreshold);
imshow(result3)

function binaryImage = SAMonAllPixels(datacube, referenceSpectrum, angleThreshold)
    binaryImage = zeros(500,500);
    
    % loops through all pixels
    for y = 1:500 
        for x = 1:500
            % compare pixel (1x186) 
            pixelSpectrum = datacube(y,x,:);
            X = pixelSpectrum;
            Y = referenceSpectrum;

            % SAM algoritme
            xTimesY = X.*Y;
            upper = sum(xTimesY);
            % I have to make it like this becouse of matlabs calulation order
            placeholderX = X.*X;
            xMultiplied = sum(placeholderX);
            placeholderY = Y.*Y;
            yMultiplied = sum(placeholderY);
            lower = sqrt(xMultiplied*yMultiplied);
            angle = acosd(upper/lower);

            if angle <= angleThreshold
                binaryImage(y,x) = 1;
            end
        end
    end
end


