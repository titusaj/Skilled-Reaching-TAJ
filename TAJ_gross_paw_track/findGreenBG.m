function greenBGmask = findGreenBG(BGimg_ud, boxRegions,targetMean,targetSigma,pawHSVrange)

slotMask = boxRegions.slotMask;
slotMask = imdilate(slotMask,strel('line',6,0)) | imdilate(slotMask,strel('line',6,180));
decorr_BG = decorrstretch(BGimg_ud,'targetmean',targetMean,'targetsigma',targetSigma);
BGhsv = rgb2hsv(decorr_BG);

greenBG = HSVthreshold(BGhsv, pawHSVrange);
greenBGmask = greenBG & slotMask;

end