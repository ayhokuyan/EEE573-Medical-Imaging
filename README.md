# EEE573 Medical Imaging
The assignment and project implementations for CS550 Machine Learning course, Bilkent University.

## Coverage of the repository

### Homeworks
Homework Assignments can be found under this folder. 
#### Homework 1
Medical Imaging Modalities, Signals and System Revision
- Display and comment on various medical imaging modalities.
- Determine the linearity and shift invariance of the given systems. 
- Find 2D Fourier transforms of the given systems.
- 2D Fourier transform and Magnitude Spectrum Visualization on MATLAB.
- Implemented in MATLAB

#### Homework 2
Image Quality
 - Find the input and output modulations given a the PSF (Point Spread Function) of a system and an object. Calculate the MTF (Modulation Transfer Function) of the system.
 - Find the FWHM (Full-Width Half Maximum) of the systems.
 - Calculate prevalence, sensitivity, specificity, PPV and NPV of a disease given its test statistics. 
 - Measure the FWHMs and SNRs (Signal to Noise Ratio) of three MPI (Magnetic Particle Imaging) tracers, and compare them with three convolved images and decide, which image is taken using which tracer. 
 - Implemented in MATLAB
 
#### Homework 3
Projection Radiography and Computerized Tomography (CT) 
- Calculate linear attenuation coefficients given various tissues. 
- Determine the projection of a hexagonal object from a point source onto a projector plane.
- Use MATLAB to calculate and plot the linear intensity. 
- Find the 2D Radon transform of a Gaussian. 
- Given a geometric object, find the 2D Radon transform (g) of the object at 0 and 90 degrees. 
- Implemented in MATLAB

#### Homework 4
CT Backprojection and Projection-Slice Theorem
- Given a CT backprojection of a projection at 15 degrees, determine if the projections at 165 and 195 degrees can be inferred.
- Given the same geometric object in the previous question, determine the back projection at 45 degrees and find the Field of View (FOV) required to capture this image. 
- Use projection-slice theorem to find the 2D Radon transforms of the given functions.  
- Given CT projections, find the objects. 
- Using MATLAB, find the CT images of a Phantom image 
- Implemented in MATLAB

#### Homework 5
Magnetic Resonance Imaging 
- Given an MR sequence, find the longitudinal and transverse magnetization at requested time points. 
- Show that a steady-state magnetization can be reached, and prove the mathematics. 
- Draw a pulse sequence diagram given a k-space trajectory. 
- Estimate the T1 values of the three major brain tissues (White matter, Gray matter and CSF) given the T1 map of the brain MRI. 
- Implemented in MATLAB
<hr  />

### Project
MRI Simulator 

- Using a discrete anatomical model of brain from the [BrainWeb](https://brainweb.bic.mni.mcgill.ca/brainweb/anatomic_normal.html) dataset, we have build an MRI simulator that is able to simulate many imperfection and option in the MRI process. 
- Simulated,
	- T1. T2, T2* weighted imaging. 
	- Slice Thickness and Selection
	- Proton Density
	- T2 Decay
	- Chemical Shift on Fat Tissue
	- Gradient/Spin Echo Sequences 
	- B0 variation noise 
- Implemented in MATLAB
