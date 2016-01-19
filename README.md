# HfPR

This code implements the photometric stereo method described in the paper "Height from Photometric Ratio with Model-based Light Source Selection". There are two parts to the method and they can be used independently:

1. The first part uses a probabilistic model to choose a subset of observations for each pixel with the goal of excluding shadows, specularities or other noise. This part requires guide surface normals and albedo which can be provided by any standard photometric stereo algorith. We include implementations of a number of such methods. The best results are provided by using our RANSAC-based implementation of classical photometric stereo.
2. The second part directly computes surface height from the images and the observation selections made in step 1. If you want to use all observations (for example if you're object is approximately Lambertian and there aren't many cast shadows) then you can simply use all observations. The easiest way to do this is create the list of pairs as a cycle through all observations:
```matlab
    for row=1:rows
        for col=1:cols
            for k=1:size(L,2)-1
                pairs{row,col}(k,:)=[k k+1];
            end
            pairs{row,col}(end+1,:)=[1 size(L,2)];
        end
    end
```

At both stages, you have the option of providing a binary foreground mask. If you don't wish to use a mask, simply pass all ones the same dimensions as the images.

If you only want to run the second part of the code, please invoke HfPR.m. If you only want to run the first part of the code, please invoke guided_PS.m, and comment out the last line

Demo Code
---------
For a demonstration of this code repository, please run demo.m. 

Reference
---------

If you use this code in your research, please cite the following paper:

W. A. P. Smith and F. Fang. "Height from Photometric Ratio with Model-based Light Source Selection." Computer Vision and Image Understanding (2015).

Bibtex:

    @article{smith2015height,
        title={Height from Photometric Ratio with Model-based Light Source Selection},
        author={W. A. P. Smith and F. Fang},
        journal={Computer Vision and Image Understanding},
        year={2015},
        publisher={Elsevier}
    }


Third Party Licenses
--------------------
This repository ships with a copy of ransac.m from http://www.peterkovesi.com/matlabfns/Robust/ransac.m

    Copyright (c) 2003-2013 Peter Kovesi
    Centre for Exploration Targeting
    The University of Western Australia
    peter.kovesi at uwa edu au
    http://www.csse.uwa.edu.au/~pk

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    The Software is provided "as is", without warranty of any kind.
