# FRAP_analyser
FRAP analyser is a MATLAB based software designed to process data of
photobleaching experiments and calculate diffusion coefficient. It was used to measure mobility of lipid molecules in Supported lipid bilayers
in a research project devoted to investigation on adhesion and grows of neuronal cells in culture. The project was perforemed in the Research Center Juelich and published in the PhD theses: ["Supported lipid bilayer as a biomimetic platform for neuronal cell culture"](https://juser.fz-juelich.de/record/138467)

## List of functions

**SimpleFrapAnalyzer**

The main function. It accepts the
required parameters, calls other functions responsible for data processing and
returnes calculate data. 
The function format is:
```matlab
[D,dD,u_ex,u_ca,t]=SimpleFrapAnalyzer(DirPath,Dinit,PixelSize,X,fi1,fi2,n)
```
Output:
- D – diffusion coefficients (m2/s)
- dD – variance of D (m2/s)
- u_ex – an array of experimentally measured intensity profiles
- u_ca – an array of calculated intensity profiles
- t – an array of time points

Input:
- DirPath – path to a folder with FRAP images
- Dinit – initial guess about diffusion coefficient (m2/s)
- PixelSize – real size of the pixel in the image (m)
- X – is an array [x1 x2] to specify the coordinates of the centre of the bleached
spot. If 0 is provided, the program will try to find the centre automatically (pixels)
- fi1 – start angle for circular averaging (degree)
- fi2 – end angle for circular averaging (degree)
- n – number of therms in the solution. Usually 50 is enough.

The SimpleFrapAnalyzer calls first the ReadFrapData function. It reads the
image files and extract profiles of intensity and time points. Files should be named
in a special way: a file name should contain a word 'time' directly followed by the 
time in hh-mm-ss format, e.g. popc-b1-time16-00-48.jpg. The file with the
reference image should contain a word 'reference' in its name, e.g. popc-b1-
reference.jpg. The ReadFrapData function subtract the reference image from all
the other images which helps to get rid of uneven illumination. If the coordinates
of centre (x1,x2) of the spot was not specified, it calls the FindSpotCentre function
which tries to find them. Then the function RadialMean is called which calculates
the intensity profiles for each image. A function FitD first calls the PolarDifSolv
function (which finds the solution of the diffusion equation) and then performs the
fitting algorithm.
The program returns messages in the MATLAB Command
Window informing the user about the procedure which is being done at the
moment. It displays the centre of the spot in first image for the user to have
possibility to check visually correctness of the centre finding. In the separate
figure extracted intensity profiles together with the calculated ones are plotted


**ReadFrapData.m**

Reads fluorescence recovery images and
extract intensity profiles as well as time of image aquisition
(it is specified in filenames in the following way: *timehh-mm-ss*.*)
```matlab
[u_ex,t]=ReadFrapData(DirPath,X,fi1,fi2)

Output:
- u_ex – an array of experimentally measured intensity profiles
- t – an array of time points
Input:
- DirPath – path to a folder with FRAP images
- X – is an array [x1 x2] to specify the coordinates of the centre of the bleached
spot. If 0 is provided, the program will try to find the centre automatically (pixels)
- fi1 – start angle for circular averaging (degree)
- fi2 – end angle for circular averaging (degree)
```


**FitD**
Fits the solutions of the diffusion equations in polar
coordinates to experimental intensity profiles (*u_ex*) by searching for
suitable diffusion coefficient (*D*)

```matlab
[D,dD,u_ca]=FitD(u_ex,Dinit,scale,t,n)
```
Output:
- D – diffusion coefficients (m2/s)
- dD – variance of D (m2/s)
- u_ca – an array of calculated intensity profiles
Input:
- u_ex - experimental intensity profiles. It is extracted from images by
ReadFrapData
- Dinit – initial guess about diffusion coefficient (m2/s);
- scale - PixelSize
- t – an array of time points

**PolarDifSolv**
Solves the Dirichlet problem for the diffusion equation in polar coordinates
```matlab
u=PolarDifSolv(u0,D,r0,t,n,ur0)
```

- u0 - initial condition (a vector)
- D - diffusion coefficient
- r0 - radius of the area under consideration
- t - time (size = 1x1)
- n - number of terms of the row of the solution // ~50 was OK
- ur0 - boundary condition - u(r0)=const

**FindSpotCentre**
Finds coordinates of a dark spot on a bright background
```matlab
[x1,x2]=FindSpotCentre(I,ShowResult)
```

- x1,x2 - coordinates of the centre of the spot
- I - image to be analyzed
- ShowResult - flag to display the resulted image with the indicated center of the spot


**gray2bw**
Converts an image I to a black and white image I1 according to the specified
threshold
```matlab
I1=gray2bw(I,threshold)
```


**RadialMean**

```matlab
Ir=RadialMean(I,x1,x2,fi1,fi2,n)
```
- I - image to be analyzed
- x1,x2 - coordinates of the centre of the spot
- fi1,fi1 - angles in degrees to start and finish averaging
- n - number of profiles to average
