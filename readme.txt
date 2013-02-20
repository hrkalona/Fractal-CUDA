A CUDA implementation of some fractal functions & image processing.

The application includes different coloring palettes and ofcourse the ability to zoom!
The application uses openGL for drawing.

Compile:

for doubles
nvcc -O4 optimized_fractal_zoomer.cu introGlutLib.cu -o fractal_zoomer -lglut -lGL -lGLU
 -arch=sm_20

for floats
nvcc -O4 optimized_fractal_zoomer_with_floats.cu introGlutLib.cu -o fractal_zoomer -lglut -lGL -lGLU


Functions:
Mandelbrot
Lambda
Spider
Newton4

Image Processing Kernels:
Blurring
Edge Detection