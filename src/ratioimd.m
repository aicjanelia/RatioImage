function [imdimage,minratio,maxratio,minint,maxint] = ratioimd(imgnum,imgdenom,minratio,maxratio,minint,maxint,map)
%imdimage = ratioimd(imgnum,imgdenom,minratio,maxratio,minint,maxint,map)
%
%RATIOIMD creates an intensity modulated display of a ratiometric image
%given the following inputs:
%
%IMGNUM:  "numerator" image
%IMGDENOM: "denominator" image
%
%and optionally:
%
%MINRATIO:  minimum displayed ratio
%MAXRATIO:  maximum displayed ratio
%MININT:  minimum displayed image intensity (from denominator)
%MAXINT:  maximum displayed image intensity (from denominator)
%MAP: name of any matlab recognized colormap (e.g. Jet, Spring, etc.)
%
%This function will work with 3D images (i.e. z-sections, time-lapse) but
%not 4D data.  You'll have to put this function in a for loop to accomodate
%higher than 3D.
%
%This function will remove the offset, but does not substract background
%signal, nor does it normalize the images.  That should be done in a
%pre-processing step if needed.
%
%You can read more about intensity modulated display at:
%http://www.ncbi.nlm.nih.gov/pubmed/11815633
%
%(C) 2014 Jesse S. Aaron, Advanced Imaging Center, HHMI Janelia Research
%Campus.


if nargin < 2
    error('Not enough input arguments')
end

if size(imgnum) ~= size(imgdenom)
    error('Images are not the same size')
end

imgnumbg = imgnum - min(imgnum(imgnum>0));
imgdenombg = imgdenom - min(imgdenom(imgdenom>0));
imgnumbg(imgnumbg<0) = 0;
imgdenombg(imgdenombg<0) = 0;
imgratio = double(imgnumbg)./double(imgdenombg);
imgratio(isnan(imgratio)) = 0;
imgratio(imgratio==inf) = 0;
%figure; hist(imgratio(:),256); title('Ratio Histogram');
%figure; hist(imgdenom(:),256); title('Denominator Intensity');
if nargin < 7
    map = 'Jet';
end

if nargin < 6
    minratio = min(imgratio(:));
    maxratio = max(imgratio(:));
    minint = min(imgdenom(:));
    maxint = max(imgdenom(:));
end

rgbmap = colormap(map);
x = 1:size(rgbmap,1);
xv = linspace(1,size(rgbmap,1),256);
rgbmap2 = flipud(interp1(x,rgbmap,xv,'linear'));
imgratio(imgratio < minratio) = minratio;
imgratio(imgratio > maxratio) = maxratio;
imgratio2 = imgratio - minratio;
imgratioind = round(255*imgratio2/max(imgratio2(:)));
brightness = double(imgdenom)/double(maxint);
brightness(brightness > 1) = 1;
brightness(brightness < minint/maxint) = 0;
imdimage = zeros(size(imgratioind,1),size(imgratioind,2),3,size(imgratioind,3),'uint8');
for a = 1:size(imgratioind,3)
    imgratiorgb = uint8(255*(ind2rgb(uint8(imgratioind(:,:,a)),rgbmap2)));
    scaleimg = repmat(brightness(:,:,a),1,1,3);
    imdimage(:,:,:,a) = uint8(double(imgratiorgb).*scaleimg);
end