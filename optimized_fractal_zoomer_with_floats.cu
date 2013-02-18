/* This program demonstrates the use of the Glut library:
   -- It draws two objects (fish) of different sizes, at different locations on the drawing window.
   -- It accepts and reacts to mouse input,
   -- It accepts and reacts to keyboard input.
*/


#include "introGlutLib.h"		//include the basic drawing library
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>				// for malloc and free
#include <string.h>				// for strcpy and other string fcns.
#define PALETTES 14
#define FUNCTIONS 4
#define FILTERS 3
#define MANDELBROT 0
#define NEWTON4 1
#define SPIDER 2
#define LAMBDA 3


typedef struct {
    unsigned char red;
    unsigned char green;
    unsigned char blue;
} Color;

Color *palette;

int colors1[14][4] = {
  {12, 0, 10, 20},
  {12, 50, 100, 240},
  {12, 20, 3, 26},
  {12, 230, 60, 20},
  {12, 25, 10, 9},
  {12, 230, 170, 0},
  {12, 20, 40, 10},
  {12, 0, 100, 0},
  {12, 5, 10, 10},
  {12, 210, 70, 30},
  {12, 90, 0, 50},
  {12, 180, 90, 120},
  {12, 0, 20, 40},
  {12, 30, 70, 200}
};

int colors2[7][4] = { //Rainbow
  {14, 0, 0, 255},
  {14, 111, 0, 255},
  {14, 143, 0, 255},
  {14, 255, 0, 0},
  {14, 255, 127, 0},
  {14, 255, 255, 0},
  {14, 0, 255, 0}
};

int colors3[14][4] = { //Fire
  {10, 10, 0, 0},
  {10, 255, 20, 0},
  {10, 255, 51, 0},
  {10, 255, 111, 0},
  {10, 255, 141, 11},
  {10, 255, 166, 69},
  {10, 255, 185, 105},
  {10, 255, 201, 135},
  {10, 255, 213, 101},
  {10, 255, 223, 184},
  {10, 255, 231, 204},
  {10, 255, 238, 222},
  {10, 255, 244, 237},
  {10, 255, 255, 255},
};

int colors4[4][4] = {
  {10, 70, 0, 20}, 
  {10, 100, 0, 100}, 
  {14, 255, 0, 0}, 
  {10, 255, 200, 0} 
};

int colors5[4][4] = { //Green-White
  {8, 40, 70, 10}, 
  {9, 40, 170, 10}, 
  {6, 100, 255, 70}, 
  {8, 255, 255, 255}
};

int colors6[5][4] = { //Blue
  {12, 0, 0, 64},
  {12, 0, 0, 255}, 
  {10, 0, 255, 255}, 
  {12, 128, 255, 255}, 
  {14, 64, 128, 255}
};

int colors7[2][4] = {
  {16, 0, 0, 0}, 
  {32, 255, 255, 255}
};

int colors8[5][4] = { 
  {14, 12, 0, 0},
  {14, 77, 56, 56},
  {14, 69, 6, 6},
  {14, 148, 55, 56},
  {14, 251, 195, 199}
};


int colors9[4][4] = { 
  {12, 84, 54, 4},
  {12, 116, 35, 7},
  {12, 233, 216, 127},
  {12, 127, 171, 233},
};

int colors10[5][4] = { 
  {12, 59, 90, 58},
  {12, 121, 157, 116},
  {12, 178, 157, 72},
  {12, 211, 191, 111},
  {12, 66, 42, 15}
};

int colors11[5][4] = { 
  {12, 242, 249, 209},
  {12, 254, 213, 121},
  {12, 199, 55, 31},
  {12, 176, 0, 57},
  {12, 53, 12, 26}
};

int colors12[5][4] = { 
  {12, 228, 253, 127},
  {12, 242, 176, 0},
  {12, 171, 33, 33},
  {12, 102, 25, 25},
  {12, 252, 92, 13}
};

int colors13[5][4] = { 
  {12, 214, 198, 146},
  {12, 241, 225, 202},
  {12, 96, 105, 62},
  {12, 129, 170, 102},
  {12, 86, 69, 41}
};

int colors14[5][4] = {   
  {12, 161, 36, 32},
  {12, 32, 15, 8},
  {12, 214, 207, 191},
  {12, 209, 184, 127},
  {12, 164, 117, 49}
};

float edge_kernel[25] = {
  -1.0, -1.0, -2.0, -1.0, -1.0,
  -1.0, -2.0, -4.0, -2.0, -1.0,
  -2.0, -4.0, 44.0, -4.0, -2.0,
  -1.0, -2.0, -4.0, -2.0, -1.0,
  -1.0, -1.0, -2.0, -1.0, -1.0
};

/*float edge_kernel[9] = {
  -1.0, -1.0, -1.0,
  -1.0,  8.0, -1.0,
  -1.0, -1.0, -1.0
};*/

float antialiasing_kernel[25] = {
  0.5625/12/12, 0.5625/12/12, 0.5625/12/12, 0.5625/12/12, 0.5625/12/12,
  0.5625/12/12,    0.5625/12,    0.5625/12,    0.5625/12, 0.5625/12/12,
  0.5625/12/12,    0.5625/12,       0.5625,    0.5625/12, 0.5625/12/12,
  0.5625/12/12,    0.5625/12,    0.5625/12,    0.5625/12, 0.5625/12/12,
  0.5625/12/12, 0.5625/12/12, 0.5625/12/12, 0.5625/12/12, 0.5625/12/12
};

struct BMPHeader {
    char bfType[2];       /* "BM" */
    int bfSize;           /* Size of file in bytes */
    int bfReserved;       /* set to 0 */
    int bfOffBits;        /* Byte offset to actual bitmap data (= 54) */
    int biSize;           /* Size of BITMAPINFOHEADER, in bytes (= 40) */
    int biWidth;          /* Width of image, in pixels */
    int biHeight;         /* Height of images, in pixels */
    short biPlanes;       /* Number of planes in target device (set to 1) */
    short biBitCount;     /* Bits per pixel (24 in this case) */
    int biCompression;    /* Type of compression (0 if no compression) */
    int biSizeImage;      /* Image size, in bytes (0 if no compression) */
    int biXPelsPerMeter;  /* Resolution in pixels/meter of display device */
    int biYPelsPerMeter;  /* Resolution in pixels/meter of display device */
    int biClrUsed;        /* Number of colors in the color table (if 0, use 
                             maximum allowed by biBitCount) */
    int biClrImportant;   /* Number of important colors.  If 0, all colors 
                             are important */
};


typedef struct {
    unsigned char red;
    unsigned char green;
    unsigned char blue;
} Image;

Image image[IMAGE_SIZE * IMAGE_SIZE];

struct timeval calc_start, calc_end;
struct timeval filter_start, filter_end;



int max_iterations;
int tile_size;
int function;
int filter;
int active_palette;
int palette_size;
float xCenter;
float yCenter;
float size;
char calc_time[50];
char spercent_calc[50];
char filter_time[25];
char siterations[15];
char center[100];
char ssize[50];
char window_title[100];
int not_calculated;
int calculating = 0;
Image *d_image;
Image *d_image_out;
Color *d_palette;
float *d_kernel;
int *d_not_calculated;

void (*ptr_function)(Image*, Color*, int, int, float, float, float, int) = NULL;
void (*ptr_function2)(Image*, Color*, int, int, float, float, float, int, int, int*) = NULL;



// ========================== Function prototypes:============================
void myDisplay();
void myMouse(int button, int state, int x, int y);
void myKeyboard(unsigned char key, int x, int y);
void imageProcessing(float* kernel, int kernel_size);
void startingPosition(void);
void zoomIn(int x, int y);
void zoomOut(int x, int y);
int createPalette(int colors[][4], int colors_size);
void nextPalette(void);
void nextFunction(void);
void nextFilter(void);
void calculateFractal(float xCenter, float yCenter, float size, int max_iterations, int palette_size, int tile_size);
void saveBMPImage(void);
__global__ void MandelbrotGPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size);
__global__ void Newton4GPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size);
__global__ void SpiderGPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size);
__global__ void LambdaGPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size);
__global__ void TiledMandelbrotGPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size, int tile_size, int *d_not_calculated);
__global__ void TiledNewton4GPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size, int tile_size, int *d_not_calculated);
__global__ void TiledSpiderGPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size, int tile_size, int *d_not_calculated);
__global__ void TiledLambdaGPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size, int tile_size, int *d_not_calculated);
__global__ void convolve2D(Image *in, Image *out, int image_size, float* kernel, int kernel_size);
__device__ void inline Mandelbrot(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float re, float im, int i, int j, int image_size);
__device__ void inline Newton4(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float re, float im, int i, int j, int image_size);
__device__ void inline Spider(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float re, float im, int i, int j, int image_size);
__device__ void inline Lambda(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float re, float im, int i, int j, int image_size);

// =================================Main:=======================================				
int main(int argc, char *argv[]) {
  
    if(argc < 6) {
        printf("\nToo few arguments.\n");
	printf("\n./project_part1 'function' 'iterations' palette' 'calculation algorithm' 'filter'\n");
	printf("\nfunction = 0 (Mandelbrot) or 1 (Newton 4) or 2 (Spider) or 3 (Lambda).\n");
	printf("\niterations > 0.\n");
	printf("\npalette = 0 (Palette 0) or 1 (Rainbow) or 2 (Fire) or 3 (Palette 3) or 4 (Green-White) or 5 (Blue) or 6 (Palette 6) or 7 (Palette 7) or 8 (Palette 8) or 9 (Palette 9) or 10 (Palette 11) or 12 (Palette 12) or 13 (Palette 13).\n");
	printf("\ncalculation algorithm = 0 (Simple algorithm), calculation algorithm > 0 (Tile size, be advised small sizes might lead to error)\n");
	printf("\nfilter = 0 (No Filter) or 1 (Antialiasing) or 2 (Edge Detection).\n\n");
	return 0;
    }
    else if(argc > 6) {
        printf("\nToo many arguments.\n");
	printf("\n./project_part1 'function' 'iterations' 'palette'  'calculation algorithm' 'filter'\n");
	printf("\nfunction = 0 (Mandelbrot) or 1 (Newton 4) or 2 (Spider) or 3 (Lambda).\n");
	printf("\niterations > 0.\n");
	printf("\npalette = 0 (Palette 0) or 1 (Rainbow) or 2 (Fire) or 3 (Palette 3) or 4 (Green-White) or 5 (Blue) or 6 (Palette 6) or 7 (Palette 7) or 8 (Palette 8) or 9 (Palette 9) or 10 (Palette 11) or 12 (Palette 12) or 13 (Palette 13).\n");
	printf("\ncalculation algorithm = 0 (Simple algorithm), calculation algorithm > 0 (Tile size, be advised small sizes might lead to error)\n");
	printf("\nfilter = 0 (No Filter) or 1 (Antialiasing) or 2 (Edge Detection).\n\n");
	return 0;
    }
     
    function = atoi(argv[1]);
    if(function < 0 || function > 3) {
        printf("\nThe function must be a number between 0 and 3.\n\n");
	return 0;
    }
    
    max_iterations = atoi(argv[2]);
    if(max_iterations < 2) {
        printf("\nThe iterations number must be a number > 1.\n\n");
	return 0;
    }
    
    active_palette = atoi(argv[3]);
    if(active_palette < 0 || active_palette > 13) {
        printf("\nThe palette, can only get values between 0 and 13.\n\n");
	return 0;
    }
    
    tile_size = atoi(argv[4]);
    if(tile_size < 0) {
        printf("\nCalculation algorithm must a number >= 0.\n\n");
	return 0;
    }
    
    filter = atoi(argv[5]);
    if(filter < 0 || filter > 2) {
        printf("\nFilter, can only get values between 0 and 2.\n\n");
	return 0;
    }
    
    printf("\n          q , Esc : quit\n                f : next function\n                p : next palette\n                t : next filter\n                1 : starting position\n                s : save bmp image\n                + : zoom in (old center)\n                - : zoom out (old center)\n left mouse click : zoom in (chosen center)\nright mouse click : zoom out (chosen center)\n\n");

    
    InitGraphics();			// initialize GLUT/OpenGL
    
    if(function == 0) {
        sprintf(window_title, "Fractal Zoomer [Function: Mandelbrot, Iterations: %d, Image Size: %d]", max_iterations, IMAGE_SIZE);
        glutSetWindowTitle(window_title);
	ptr_function = &MandelbrotGPU;	
	ptr_function2 = &TiledMandelbrotGPU;
    }
    else if(function == 1) {
        sprintf(window_title, "Fractal Zoomer [Function: Newton 4, Iterations: %d, Image Size: %d]", max_iterations, IMAGE_SIZE);
        glutSetWindowTitle(window_title);
	ptr_function = &Newton4GPU;
	ptr_function2 = &TiledNewton4GPU;
    }
    else if(function == 2) {
        sprintf(window_title, "Fractal Zoomer [Function: Spider, Iterations: %d, Image Size: %d]", max_iterations, IMAGE_SIZE);
        glutSetWindowTitle(window_title);
	ptr_function = &SpiderGPU;
	ptr_function2 = &TiledSpiderGPU;
    }
    else {
        sprintf(window_title, "Fractal Zoomer [Function: Lambda, Iterations: %d, Image Size: %d]", max_iterations, IMAGE_SIZE);
        glutSetWindowTitle(window_title); 
	ptr_function = &LambdaGPU;
	ptr_function2 = &TiledLambdaGPU;
    }
    
    switch(active_palette) {
        case 0:
	    palette_size = createPalette(colors1, 14);
	    break;
	case 1:
	    palette_size = createPalette(colors2, 7);
	    break;
	case 2:
	    palette_size = createPalette(colors3, 14);
	    break;
	case 3:
	    palette_size = createPalette(colors4, 4);
	    break;
	case 4:
	    palette_size = createPalette(colors5, 4);
	    break;
	case 5:
	    palette_size = createPalette(colors6, 5);
	    break;
	case 6:
	    palette_size = createPalette(colors7, 2);
	    break;
	case 7:
	    palette_size = createPalette(colors8, 5);
	    break;
	case 8:
	    palette_size = createPalette(colors9, 4);
	    break;
	case 9:
	    palette_size = createPalette(colors10, 5);
	    break;
	case 10:
	    palette_size = createPalette(colors11, 5);
	    break;
	case 11:
	    palette_size = createPalette(colors12, 5);
	    break;
	case 12:
	    palette_size = createPalette(colors13, 5);
	    break;
	case 13:
	    palette_size = createPalette(colors14, 5);
	    break;  
    }
	
    
    startingPosition();
    
    glutMainLoop();			// keep drawing
    
    free(palette);
    
    return 0;
    
}



/**********************************************************************
 myMouse(button, state, x, y)

 GLUT CALLBACK: Don't call this function in your program--GLUT does it.

 button: Which button was clicked. 
			Possible values are GLUT_LEFT for the left button and GLUT_RIGHT for the right one
 state: Is the button clicked (GLUT_DOWN) or not (GLUT_UP)?
 x, y: The coordinates of the place where you clicked (in pixels)
***********************************************************************/
			
void myMouse(int button, int state, int x, int y) {
	
	
	//int new_y = NU_SCREENHEIGHT-y;  // Even thought the normal output window has 
									// the origin point in the lower left corner, 
									// the mouse handling function assumes that
									// it's the upper left corner. 
									// So we change y to keep things consistent .

	
    if (state == GLUT_DOWN) {
		
		/* A button is being pressed. Set the correct motion function */
		
        if (button==GLUT_LEFT && !calculating) {
	    zoomIn(x, y);		
	}
	else if (!calculating) {
	    zoomOut(x, y);
	  
	}
		
    }
	
} 


/**********************************************************************
 myKeyboard(key, x, y)

 GLUT CALLBACK: Don't call this function in your program--GLUT does it.
***********************************************************************/

void myKeyboard(unsigned char key, int x, int y) {

    switch(key)  {
        case '=':
	    if(!calculating) {
	        zoomIn(IMAGE_SIZE / 2, IMAGE_SIZE / 2);
	    }
	    break;
	case '-':
	    if(!calculating) {
	        zoomOut(IMAGE_SIZE / 2, IMAGE_SIZE / 2);
	    }
	    break;
	case '1':
	    if(!calculating) {
	        startingPosition();
	    }
	    break;
	case 'p':
	    if(!calculating) {
	        nextPalette();
	    }
	    break;
	case 'f':
	    if(!calculating) {
	        nextFunction();
	    }
	    break;
	case 't':
	    if(!calculating) {
	        nextFilter();
	    }
	    break;
	case 's':
	    if(!calculating) {
	        saveBMPImage();
	    }
	    break;
        case 27:	// User pressed the Esc key 
	case 'Q':	// User pressed the Q key
	case 'q':   
	    exit(1);
	    break;
    }
	
}


/***************************************************************
 myDisplay()

 GLUT CALLBACK: Don't call this function in your program--GLUT does it.

 ######################################################################
 Students: put your drawing commands/function calls in this function, 
 rather than in main().
 ######################################################################
***************************************************************/

void myDisplay(void) {
  int x, y, temp_trans, temp_y, temp1, temp2, temp3, temp4, temp5;
    
    ClearWindow();
	
    SetBackgndColor(0.5, 0.5, 0.5);
 
    glBegin(GL_POINTS);
    for(y = 0; y < IMAGE_SIZE; y++) {
        temp_y = NU_SCREENHEIGHT - y;
        for(x = 0; x < IMAGE_SIZE; x++) {
            temp_trans = x * IMAGE_SIZE + y;
            SetPenColor(image[temp_trans].red / 255.0, image[temp_trans].green / 255.0, image[temp_trans].blue / 255.0);
            glVertex2d(x, temp_y);
        }
    }
    glEnd();
    glFlush();
	
    SetPenColor(0.0, 0.0, 0.0);
        
	
    temp1 = IMAGE_SIZE + 10;
    temp2 = IMAGE_SIZE - 130;
    temp3 = IMAGE_SIZE - 90;
    temp4 = IMAGE_SIZE - 50;
    temp5 = IMAGE_SIZE - 170;
    DrawText2D(helv10, temp1, temp4,  "Center:");
    if(-yCenter > 0) {
        sprintf(center, "%20.15lf+%20.15lfi", xCenter, -yCenter);	 
    }
    else if(yCenter == 0) {
        sprintf(center, "%20.15lf+%20.15lfi", xCenter, yCenter);
    }
    else {
        sprintf(center, "%20.15lf%20.15lfi", xCenter, -yCenter);
    }    
    DrawText2D(helv10, IMAGE_SIZE + 70, temp4, center);
	
    DrawText2D(helv10, temp1, temp3, "Size:");
    sprintf(ssize, "%20.15lf", size);
    DrawText2D(helv10, IMAGE_SIZE + 50, temp3, ssize);
		
    sprintf(spercent_calc, "(%3.2f%%)", (((float)IMAGE_SIZE * IMAGE_SIZE - not_calculated) / (IMAGE_SIZE * IMAGE_SIZE)) * 100);
    DrawText2D(helv10, temp1, temp2, spercent_calc);

    DrawText2D(helv10, IMAGE_SIZE + 100, temp2, "Calculation Time:");
    sprintf(calc_time, "%ld microseconds", (calc_end.tv_sec * 1000000 + calc_end.tv_usec) - (calc_start.tv_sec * 1000000 + calc_start.tv_usec));
    DrawText2D(helv10, IMAGE_SIZE + 260, temp2, calc_time);
	
    DrawText2D(helv10, temp1, temp5, "Filter Time:");    
    sprintf(filter_time, "%ld microseconds", (filter_end.tv_sec * 1000000 + filter_end.tv_usec) - (filter_start.tv_sec * 1000000 + filter_start.tv_usec));	
    DrawText2D(helv10, IMAGE_SIZE + 120, temp5, filter_time);
			
}


void startingPosition(void) {
  
    calculating = 1;
    
    if(function == LAMBDA) {
        xCenter = 1.0;
        yCenter = 0.0;
        size = 8.0;
    }
    else {
        xCenter = 0.0;
        yCenter = 0.0;
        size = 6.0;
    }
    
    
    calculateFractal(xCenter, yCenter, size, max_iterations, palette_size, tile_size);
    
    if(filter == 1) {
        imageProcessing(antialiasing_kernel, 5);
    }
    else if(filter == 2){
        imageProcessing(edge_kernel, 5);
    }
    else {
        gettimeofday(&filter_start, NULL);
        gettimeofday(&filter_end, NULL);    
    }
    
    printf("\n(%3.2f%%) Calculation time: %ld microseconds\n", ((((float)IMAGE_SIZE * IMAGE_SIZE - not_calculated) / (IMAGE_SIZE * IMAGE_SIZE)) * 100), (calc_end.tv_sec * 1000000 + calc_end.tv_usec) - (calc_start.tv_sec * 1000000 + calc_start.tv_usec));
    printf("Filter time: %ld microseconds\n", (filter_end.tv_sec * 1000000 + filter_end.tv_usec) - (filter_start.tv_sec * 1000000 + filter_start.tv_usec));
    
    calculating = 0;
    
}

void zoomIn(int x, int y) {
  
    calculating = 1;
    
    if(x < 0 || x >= IMAGE_SIZE || y < 0 || y >= IMAGE_SIZE) {
        calculating = 0;
        return;
    }
    

    xCenter = xCenter - size / 2 + size * x / IMAGE_SIZE;
    yCenter = yCenter - size / 2 + size * y / IMAGE_SIZE;
		    
    size /= 2;
		    
    calculateFractal(xCenter, yCenter, size, max_iterations, palette_size, tile_size);
    
    if(filter == 1) {
        imageProcessing(antialiasing_kernel, 5);
    }
    else if(filter == 2){
        imageProcessing(edge_kernel, 5);
    }
    else {
        gettimeofday(&filter_start, NULL);
        gettimeofday(&filter_end, NULL);    
    }
    
    printf("\n(%3.2f%%) Calculation time: %ld microseconds\n", ((((float)IMAGE_SIZE * IMAGE_SIZE - not_calculated) / (IMAGE_SIZE * IMAGE_SIZE)) * 100), (calc_end.tv_sec * 1000000 + calc_end.tv_usec) - (calc_start.tv_sec * 1000000 + calc_start.tv_usec));
    printf("Filter time: %ld microseconds\n", (filter_end.tv_sec * 1000000 + filter_end.tv_usec) - (filter_start.tv_sec * 1000000 + filter_start.tv_usec));
    
    calculating = 0;
    
}

void zoomOut(int x, int y) {
  
    calculating = 1;
    
    if(x < 0 || x >= IMAGE_SIZE || y < 0 || y >= IMAGE_SIZE) {
        calculating = 0;
        return;
    }
    
    
    xCenter = xCenter - size / 2 + size * x / IMAGE_SIZE;
    yCenter = yCenter - size / 2 + size * y / IMAGE_SIZE;
		    
    size *= 2;
		    
    calculateFractal(xCenter, yCenter, size, max_iterations, palette_size, tile_size);
    
    if(filter == 1) {
        imageProcessing(antialiasing_kernel, 5);
    }
    else if(filter == 2){
        imageProcessing(edge_kernel, 5);
    }
    else {
        gettimeofday(&filter_start, NULL);
        gettimeofday(&filter_end, NULL);    
    }
    
    printf("\n(%3.2f%%) Calculation time: %ld microseconds\n", ((((float)IMAGE_SIZE * IMAGE_SIZE - not_calculated) / (IMAGE_SIZE * IMAGE_SIZE)) * 100), (calc_end.tv_sec * 1000000 + calc_end.tv_usec) - (calc_start.tv_sec * 1000000 + calc_start.tv_usec));
    printf("Filter time: %ld microseconds\n", (filter_end.tv_sec * 1000000 + filter_end.tv_usec) - (filter_start.tv_sec * 1000000 + filter_start.tv_usec));
    
    calculating = 0;
    
}

void nextFunction(void) {
    
    function = (function + 1) % FUNCTIONS;
    
    if(function == 0) {
        sprintf(window_title, "Fractal Zoomer [Function: Mandelbrot, Iterations: %d, Image Size: %d]", max_iterations, IMAGE_SIZE);
        glutSetWindowTitle(window_title);
	ptr_function = &MandelbrotGPU;	
	ptr_function2 = &TiledMandelbrotGPU;
    }
    else if(function == 1) {
        sprintf(window_title, "Fractal Zoomer [Function: Newton 4, Iterations: %d, Image Size: %d]", max_iterations, IMAGE_SIZE);
        glutSetWindowTitle(window_title);
	ptr_function = &Newton4GPU;
	ptr_function2 = &TiledNewton4GPU;
    }
    else if(function == 2) {
        sprintf(window_title, "Fractal Zoomer [Function: Spider, Iterations: %d, Image Size: %d]", max_iterations, IMAGE_SIZE);
        glutSetWindowTitle(window_title);
	ptr_function = &SpiderGPU;
	ptr_function2 = &TiledSpiderGPU;
    }
    else {
        sprintf(window_title, "Fractal Zoomer [Function: Lambda, Iterations: %d, Image Size: %d]", max_iterations, IMAGE_SIZE);
        glutSetWindowTitle(window_title); 
	ptr_function = &LambdaGPU;
	ptr_function2 = &TiledLambdaGPU;
    }
    
    startingPosition();
    
}

void nextFilter(void) {
  
    calculating = 1;
    
    filter = (filter + 1) % FILTERS;
    
    calculateFractal(xCenter, yCenter, size, max_iterations, palette_size, tile_size);
    
    if(filter == 1) {
        imageProcessing(antialiasing_kernel, 5);
    }
    else if(filter == 2){
        imageProcessing(edge_kernel, 5);
    }
    else {
        gettimeofday(&filter_start, NULL);
        gettimeofday(&filter_end, NULL);    
    }
    
    printf("\n(%3.2f%%) Calculation time: %ld microseconds\n", ((((float)IMAGE_SIZE * IMAGE_SIZE - not_calculated) / (IMAGE_SIZE * IMAGE_SIZE)) * 100), (calc_end.tv_sec * 1000000 + calc_end.tv_usec) - (calc_start.tv_sec * 1000000 + calc_start.tv_usec));
    printf("Filter time: %ld microseconds\n", (filter_end.tv_sec * 1000000 + filter_end.tv_usec) - (filter_start.tv_sec * 1000000 + filter_start.tv_usec));
    
    calculating = 0;
}

void nextPalette(void) {
    
    calculating = 1;
    
    active_palette = (active_palette + 1) % PALETTES;
    
    free(palette);
    
    switch(active_palette) {
        case 0:
	    palette_size = createPalette(colors1, 14);
	    break;
	case 1:
	    palette_size = createPalette(colors2, 7);
	    break;
	case 2:
	    palette_size = createPalette(colors3, 14);
	    break;
	case 3:
	    palette_size = createPalette(colors4, 4);
	    break;
	case 4:
	    palette_size = createPalette(colors5, 4);
	    break;
	case 5:
	    palette_size = createPalette(colors6, 5);
	    break;
	case 6:
	    palette_size = createPalette(colors7, 2);
	    break;
	case 7:
	    palette_size = createPalette(colors8, 5);
	    break;
	case 8:
	    palette_size = createPalette(colors9, 4);
	    break;
	case 9:
	    palette_size = createPalette(colors10, 5);
	    break;
	case 10:
	    palette_size = createPalette(colors11, 5);
	    break;
	case 11:
	    palette_size = createPalette(colors12, 5);
	    break;
	case 12:
	    palette_size = createPalette(colors13, 5);
	    break;
	case 13:
	    palette_size = createPalette(colors14, 5);
	    break;	  
    }
    
    calculateFractal(xCenter, yCenter, size, max_iterations, palette_size, tile_size);
    
    if(filter == 1) {
        imageProcessing(antialiasing_kernel, 5);
    }
    else if(filter == 2){
        imageProcessing(edge_kernel, 5);
    }
    else {
        gettimeofday(&filter_start, NULL);
        gettimeofday(&filter_end, NULL);    
    }
    
    printf("\n(%3.2f%%) Calculation time: %ld microseconds\n", ((((float)IMAGE_SIZE * IMAGE_SIZE - not_calculated) / (IMAGE_SIZE * IMAGE_SIZE)) * 100), (calc_end.tv_sec * 1000000 + calc_end.tv_usec) - (calc_start.tv_sec * 1000000 + calc_start.tv_usec));
    printf("Filter time: %ld microseconds\n", (filter_end.tv_sec * 1000000 + filter_end.tv_usec) - (filter_start.tv_sec * 1000000 + filter_start.tv_usec));
    
    calculating = 0;
    
}


int createPalette(int colors[][4], int colors_size) {
  int i, n = 0, j;
  int *c1, *c2;
  
    for(i = 0; i < colors_size; i++) {
        n += colors[i][0];
    }
    
    palette = (Color *) malloc(sizeof(Color) * n);
    
    n = 0;
    for(i = 0; i < colors_size; i++) {
        c1 = colors[i];
	c2 = colors[(i + 1) % colors_size];
	for(j = 0; j < c1[0]; j++) {
	    palette[n + j].red = (c1[1] * (c1[0] - 1 - j) + c2[1] * j) / (c1[0] - 1);
	    palette[n + j].green = (c1[2] * (c1[0] - 1 - j) + c2[2] * j) / (c1[0] - 1);
	    palette[n + j].blue = (c1[3] * (c1[0] - 1 - j) + c2[3] * j) / (c1[0] - 1);
	}
	n += c1[0];
    }
    
    
    return n;
       
}

void calculateFractal(float xCenter, float yCenter, float size, int max_iterations, int palette_size, int tile_size) {
  int temp_break;
  cudaError_t error;
  float temp_size_2;
  
    not_calculated = 0;
    temp_size_2 = size / 2;
  
    if(tile_size == 0) { 
        cudaMalloc(&d_image, IMAGE_SIZE * IMAGE_SIZE * sizeof(Image));
        cudaMalloc(&d_palette, palette_size * sizeof(Color));

        gettimeofday(&calc_start, NULL);
   
        cudaMemcpy(d_palette, palette, palette_size * sizeof(Color), cudaMemcpyHostToDevice);
    
        temp_break = IMAGE_SIZE >> 3;
        temp_break = temp_break == 0 ? 1 : temp_break;
        dim3 dimGrid(temp_break, temp_break);    
        dim3 dimBlock(IMAGE_SIZE / temp_break, IMAGE_SIZE / temp_break);
        ptr_function<<<dimGrid, dimBlock>>>(d_image, d_palette, max_iterations, palette_size, xCenter - temp_size_2 , yCenter - temp_size_2 , size / IMAGE_SIZE, IMAGE_SIZE);
    
        cudaThreadSynchronize();
    
        error = cudaGetLastError();
    
        if(error != cudaSuccess) {
            printf("\nCUDA Error: %s\n\n", cudaGetErrorString(error));
	    cudaFree(d_image);
            cudaFree(d_palette);
	    return;
        }
    
        if(!filter) {
            cudaMemcpy(&image, d_image, IMAGE_SIZE * IMAGE_SIZE * sizeof(Image), cudaMemcpyDeviceToHost);
	    cudaFree(d_image);
	}

        gettimeofday(&calc_end, NULL);
    
        cudaFree(d_palette); 
    }
    else {
        cudaMalloc(&d_image, IMAGE_SIZE * IMAGE_SIZE * sizeof(Image));
        cudaMalloc(&d_palette, palette_size * sizeof(Color));
        cudaMalloc(&d_not_calculated, sizeof(int));
      
        gettimeofday(&calc_start, NULL);
      
        cudaMemcpy(d_palette, palette, palette_size * sizeof(Color), cudaMemcpyHostToDevice);
        cudaMemset(d_not_calculated, 0, sizeof(int));
    
        temp_break = tile_size >> 3;
        temp_break = temp_break == 0 ? 1 : temp_break;
        dim3 dimGrid(temp_break, temp_break);    
        dim3 dimBlock(tile_size / temp_break, tile_size / temp_break);
        ptr_function2<<<dimGrid, dimBlock>>>(d_image, d_palette, max_iterations, palette_size, xCenter - temp_size_2, yCenter - temp_size_2, size / IMAGE_SIZE, IMAGE_SIZE, tile_size, d_not_calculated);

        cudaThreadSynchronize();
    
        error = cudaGetLastError();
    
        if(error != cudaSuccess) {
            printf("\nCUDA Error: %s\n\n", cudaGetErrorString(error));
	    cudaFree(d_image);
            cudaFree(d_palette);
	    cudaFree(d_not_calculated);
	    return;
        }
    
        if(!filter) {
            cudaMemcpy(&image, d_image, IMAGE_SIZE * IMAGE_SIZE * sizeof(Image), cudaMemcpyDeviceToHost);
	    cudaFree(d_image);
	}
        cudaMemcpy(&not_calculated, d_not_calculated, sizeof(int), cudaMemcpyDeviceToHost);

        gettimeofday(&calc_end, NULL);
    
        cudaFree(d_palette);
        cudaFree(d_not_calculated);
    }
     
}

void imageProcessing(float* kernel, int kernel_size) {
  int temp_break;
  cudaError_t error;
  
    cudaMalloc(&d_image_out, IMAGE_SIZE * IMAGE_SIZE * sizeof(Image));
    cudaMalloc(&d_kernel, kernel_size * kernel_size * sizeof(float));
    
    gettimeofday(&filter_start, NULL);
    
    
    cudaMemcpy(d_kernel, kernel, kernel_size * kernel_size * sizeof(float), cudaMemcpyHostToDevice);
       
    temp_break = IMAGE_SIZE >> 3;
    temp_break = temp_break == 0 ? 1 : temp_break;
    dim3 dimGrid(temp_break, temp_break);    
    dim3 dimBlock(IMAGE_SIZE / temp_break, IMAGE_SIZE / temp_break);
    convolve2D<<<dimGrid, dimBlock>>>(d_image, d_image_out, IMAGE_SIZE, d_kernel, kernel_size);
    
    cudaThreadSynchronize();
    
    error = cudaGetLastError();
    
    if(error != cudaSuccess) {
        printf("\nCUDA Error: %s\n\n", cudaGetErrorString(error));
	cudaFree(d_kernel);
        cudaFree(d_image_out);
        return;
    }

    
    cudaMemcpy(&image, d_image_out, IMAGE_SIZE * IMAGE_SIZE * sizeof(Image), cudaMemcpyDeviceToHost);
    
 
    gettimeofday(&filter_end, NULL);
    

    cudaFree(d_kernel);
    cudaFree(d_image_out);
  
}

void saveBMPImage(void) {
  int i, j;
    int bytesPerLine;
    unsigned char *line;

    FILE *file;
    struct BMPHeader bmph;

    // The length of each line must be a multiple of 4 bytes 
    calculating = 1;

    bytesPerLine = (3 * (IMAGE_SIZE + 1) / 4) * 4;

    //strcpy(bmph.bfType, "BM");
    bmph.bfType[0] = 'B';
    bmph.bfType[1] = 'M';
    bmph.bfOffBits = 54;
    bmph.bfSize = bmph.bfOffBits + bytesPerLine * IMAGE_SIZE;
    bmph.bfReserved = 0;
    bmph.biSize = 40;
    bmph.biWidth = IMAGE_SIZE;
    bmph.biHeight = IMAGE_SIZE;
    bmph.biPlanes = 1;
    bmph.biBitCount = 24;
    bmph.biCompression = 0;
    bmph.biSizeImage = bytesPerLine * IMAGE_SIZE;
    bmph.biXPelsPerMeter = 0;
    bmph.biYPelsPerMeter = 0;
    bmph.biClrUsed = 0;       
    bmph.biClrImportant = 0; 

    file = fopen ("image.bmp", "wb");
    if(file == NULL) {  
       return;
    }
  
    fwrite(&bmph.bfType, 2, 1, file);
    fwrite(&bmph.bfSize, 4, 1, file);
    fwrite(&bmph.bfReserved, 4, 1, file);
    fwrite(&bmph.bfOffBits, 4, 1, file);
    fwrite(&bmph.biSize, 4, 1, file);
    fwrite(&bmph.biWidth, 4, 1, file);
    fwrite(&bmph.biHeight, 4, 1, file);
    fwrite(&bmph.biPlanes, 2, 1, file);
    fwrite(&bmph.biBitCount, 2, 1, file);
    fwrite(&bmph.biCompression, 4, 1, file);
    fwrite(&bmph.biSizeImage, 4, 1, file);
    fwrite(&bmph.biXPelsPerMeter, 4, 1, file);
    fwrite(&bmph.biYPelsPerMeter, 4, 1, file);
    fwrite(&bmph.biClrUsed, 4, 1, file);
    fwrite(&bmph.biClrImportant, 4, 1, file);
  
    line = (unsigned char *)malloc(bytesPerLine);
    if (line == NULL) {
        fprintf(stderr, "Can't allocate memory for BMP file.\n");
        return;
    }

    for (i = IMAGE_SIZE - 1; i >= 0; i--) {
        for (j = 0; j < IMAGE_SIZE; j++) {
	    line[3 * j + 2] = (char)((image[j * IMAGE_SIZE + i].red > 255 ? 255 : image[j * IMAGE_SIZE + i].red));
	    line[3 * j + 1] = (char)((image[j * IMAGE_SIZE + i].green > 255 ? 255 : image[j * IMAGE_SIZE + i].green)); 
            line[3 * j] = (char)((image[j * IMAGE_SIZE + i].blue > 255 ? 255 : image[j * IMAGE_SIZE + i].blue));      
        }
        fwrite(line, bytesPerLine, 1, file);
    }

    free(line);
    fclose(file);
    
    calculating = 0;

}

__global__ void convolve2D(Image* in, Image* out, int image_size, float* kernel, int kernel_size) {
  int i, j, k, l, p, t, temp_trans, temp_trans2, temp, temp2, temp3;
  float sum_red = 0, sum_green = 0, sum_blue = 0;
  
    i = threadIdx.x + blockDim.x * blockIdx.x;
    j = threadIdx.y + blockDim.y * blockIdx.y;
      
    temp = kernel_size >> 1;

    for(k = i - temp, p = 0; p < kernel_size; k++, p++) {
        if(k >= 0 && k < image_size) {
            temp2 = k * image_size;
            temp3 = p * kernel_size;
            for(l = j - temp, t = 0; t < kernel_size; l++, t++) {
	        if(l >= 0 && l < image_size) {
		    temp_trans = temp2 + l;
		    temp_trans2 = temp3 + t;
	            sum_red += in[temp_trans].red * kernel[temp_trans2];
		    sum_green += in[temp_trans].green * kernel[temp_trans2];
		    sum_blue += in[temp_trans].blue * kernel[temp_trans2];
	        }
	    }
	}
    }
  
    temp_trans = i * image_size + j;
    out[temp_trans].red = sum_red;
    out[temp_trans].green = sum_green;
    out[temp_trans].blue = sum_blue;
  
}

__global__ void MandelbrotGPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size) {
  int i, j;
    
    i = threadIdx.x + blockDim.x * blockIdx.x;
    j = threadIdx.y + blockDim.y * blockIdx.y;
    
    Mandelbrot(d_image, d_palette, max_iterations, palette_size, xcenter_size_2 + temp_size_image_size * i, ycenter_size_2 + temp_size_image_size * j, i, j, image_size);
    
}

__global__ void Newton4GPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size) {
  int i, j;
    
    i = threadIdx.x + blockDim.x * blockIdx.x;
    j = threadIdx.y + blockDim.y * blockIdx.y;
    
    Newton4(d_image, d_palette, max_iterations, palette_size, xcenter_size_2 + temp_size_image_size * i, ycenter_size_2 + temp_size_image_size * j, i, j, image_size);
    
}

__global__ void SpiderGPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size) {
  int i, j;
    
    i = threadIdx.x + blockDim.x * blockIdx.x;
    j = threadIdx.y + blockDim.y * blockIdx.y;
    
    Spider(d_image, d_palette, max_iterations, palette_size, xcenter_size_2 + temp_size_image_size * i, ycenter_size_2 + temp_size_image_size * j, i, j, image_size);
  
}

__global__ void LambdaGPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size) {
  int i, j;
    
    i = threadIdx.x + blockDim.x * blockIdx.x;
    j = threadIdx.y + blockDim.y * blockIdx.y;
    
    Lambda(d_image, d_palette, max_iterations, palette_size, xcenter_size_2 + temp_size_image_size * i, ycenter_size_2 + temp_size_image_size * j, i, j, image_size);
    
}

__global__ void TiledMandelbrotGPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size, int tile_size, int *d_not_calculated) {
  int x, y, i, j, tile_FROMx, tile_TOx, tile_FROMy, tile_TOy, whole_area, temp, temp1, temp2, temp3, temp4, temp5, k, l, step, temp_trans;
  float temp_y0, temp_x0;
  Color starting_color;
  __shared__ int s_not_calculated;
      
      s_not_calculated = 0;
  
      i = threadIdx.x + blockDim.x * blockIdx.x;
      j = threadIdx.y + blockDim.y * blockIdx.y;
  
      tile_FROMy = i * image_size / tile_size;
      tile_TOy = (i + 1) * image_size / tile_size;

      tile_FROMx = j * image_size / tile_size;
      tile_TOx = (j + 1) * image_size / tile_size;
	  
      temp = (tile_TOy - tile_FROMy + 1) / 2;
	     
      for(y = tile_FROMy, whole_area = 1, step = 0; step < temp; step++, whole_area = 1) {
          temp_y0 = ycenter_size_2 + temp_size_image_size * y;
	
	  x = tile_FROMx + step;
	  temp_x0 = xcenter_size_2 + temp_size_image_size * x;
		
	  Mandelbrot(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		  
	  temp_trans = x * image_size + y;
	  starting_color.red = d_image[temp_trans].red;
	  starting_color.green = d_image[temp_trans].green;
	  starting_color.blue = d_image[temp_trans].blue;
		
	  for(; x < tile_TOx - step; x++) {  //FIRST ROW (moving right)
	      temp_x0 = xcenter_size_2 + temp_size_image_size * x;
		    
	      Mandelbrot(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		      
	      temp_trans = x * image_size + y;
       	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }   
	  }
		
	  for(x--, y++; y < tile_TOy - step; y++) { //LAST COLUMN (moving down)
              temp_y0 = ycenter_size_2 + temp_size_image_size * y;
		     
       	      Mandelbrot(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		    
	      temp_trans = x * image_size + y;
	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }      
	  }
		
	  for(y--, x--; x >= tile_FROMx + step; x--) { //LAST ROW (moving left)
	      temp_x0 = xcenter_size_2 + temp_size_image_size * x;
		    
	      Mandelbrot(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		    
	      temp_trans = x * image_size + y;
	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }     
	  }
	
	  for(x++, y--; y > tile_FROMy + step; y--) { //FIRST COLUMN (moving up)
	      temp_y0 = ycenter_size_2 + temp_size_image_size * y;
		    
	      Mandelbrot(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		    
	      temp_trans = x * image_size + y;
	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }    
	  }
		
	  y++;
		
	  if(whole_area) {
	      temp5 = step + 1;
	      temp1 = tile_TOx - temp5;
	      temp2 = tile_TOy - temp5;
	      temp3 = temp1 - x;
	      temp4 = temp2 - y;
		      
	      atomicAdd(&s_not_calculated, temp3 * temp4);
		    
	      for(k = y; k < temp2; k++) {
	          for(l = x + 1; l < temp1; l++) {
	    	      temp_trans = l * image_size + k;
		      d_image[temp_trans].red = starting_color.red;
		      d_image[temp_trans].green = starting_color.green;
		      d_image[temp_trans].blue = starting_color.blue;
		  }
	      }
		    
	      break;
	  }	
	
      }

      __syncthreads();

      if(threadIdx.x == 0 && threadIdx.y == 0) {
          atomicAdd(d_not_calculated, s_not_calculated);
      }
	
}


__global__ void TiledNewton4GPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size, int tile_size, int *d_not_calculated) {
  int x, y, i, j, tile_FROMx, tile_TOx, tile_FROMy, tile_TOy, whole_area, temp, temp1, temp2, temp3, temp4, temp5, k, l, step, temp_trans;
  float temp_y0, temp_x0;
  Color starting_color;
  __shared__ int s_not_calculated;
      
      s_not_calculated = 0;
  
      i = threadIdx.x + blockDim.x * blockIdx.x;
      j = threadIdx.y + blockDim.y * blockIdx.y;
  
      tile_FROMy = i * image_size / tile_size;
      tile_TOy = (i + 1) * image_size / tile_size;

      tile_FROMx = j * image_size / tile_size;
      tile_TOx = (j + 1) * image_size / tile_size;
	  
      temp = (tile_TOy - tile_FROMy + 1) / 2;
	     
      for(y = tile_FROMy, whole_area = 1, step = 0; step < temp; step++, whole_area = 1) {
          temp_y0 = ycenter_size_2 + temp_size_image_size * y;
	
	  x = tile_FROMx + step;
	  temp_x0 = xcenter_size_2 + temp_size_image_size * x;
		
	  Newton4(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		  
	  temp_trans = x * image_size + y;
	  starting_color.red = d_image[temp_trans].red;
	  starting_color.green = d_image[temp_trans].green;
	  starting_color.blue = d_image[temp_trans].blue;
		
	  for(; x < tile_TOx - step; x++) {  //FIRST ROW (moving right)
	      temp_x0 = xcenter_size_2 + temp_size_image_size * x;
		    
	      Newton4(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		      
	      temp_trans = x * image_size + y;
       	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }   
	  }
		
	  for(x--, y++; y < tile_TOy - step; y++) { //LAST COLUMN (moving down)
              temp_y0 = ycenter_size_2 + temp_size_image_size * y;
		     
       	      Newton4(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		    
	      temp_trans = x * image_size + y;
	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }      
	  }
		
	  for(y--, x--; x >= tile_FROMx + step; x--) { //LAST ROW (moving left)
	      temp_x0 = xcenter_size_2 + temp_size_image_size * x;
		    
	      Newton4(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		    
	      temp_trans = x * image_size + y;
	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }     
	  }
	
	  for(x++, y--; y > tile_FROMy + step; y--) { //FIRST COLUMN (moving up)
	      temp_y0 = ycenter_size_2 + temp_size_image_size * y;
		    
	      Newton4(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		    
	      temp_trans = x * image_size + y;
	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }    
	  }
		
	  y++;
		
	  if(whole_area) {
	      temp5 = step + 1;
	      temp1 = tile_TOx - temp5;
	      temp2 = tile_TOy - temp5;
	      temp3 = temp1 - x;
	      temp4 = temp2 - y;
		      
	      atomicAdd(&s_not_calculated, temp3 * temp4);
		    
	      for(k = y; k < temp2; k++) {
	          for(l = x + 1; l < temp1; l++) {
	    	      temp_trans = l * image_size + k;
		      d_image[temp_trans].red = starting_color.red;
		      d_image[temp_trans].green = starting_color.green;
		      d_image[temp_trans].blue = starting_color.blue;
		  }
	      }
		    
	      break;
	  }	
	
      }

      __syncthreads();

      if(threadIdx.x == 0 && threadIdx.y == 0) {
          atomicAdd(d_not_calculated, s_not_calculated);
      }
	
}


__global__ void TiledSpiderGPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size, int tile_size, int *d_not_calculated) {
  int x, y, i, j, tile_FROMx, tile_TOx, tile_FROMy, tile_TOy, whole_area, temp, temp1, temp2, temp3, temp4, temp5, k, l, step, temp_trans;
  float temp_y0, temp_x0;
  Color starting_color;
  __shared__ int s_not_calculated;
      
      s_not_calculated = 0;
  
      i = threadIdx.x + blockDim.x * blockIdx.x;
      j = threadIdx.y + blockDim.y * blockIdx.y;
  
      tile_FROMy = i * image_size / tile_size;
      tile_TOy = (i + 1) * image_size / tile_size;

      tile_FROMx = j * image_size / tile_size;
      tile_TOx = (j + 1) * image_size / tile_size;
	  
      temp = (tile_TOy - tile_FROMy + 1) / 2;
	     
      for(y = tile_FROMy, whole_area = 1, step = 0; step < temp; step++, whole_area = 1) {
          temp_y0 = ycenter_size_2 + temp_size_image_size * y;
	
	  x = tile_FROMx + step;
	  temp_x0 = xcenter_size_2 + temp_size_image_size * x;
		
	  Spider(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		  
	  temp_trans = x * image_size + y;
	  starting_color.red = d_image[temp_trans].red;
	  starting_color.green = d_image[temp_trans].green;
	  starting_color.blue = d_image[temp_trans].blue;
		
	  for(; x < tile_TOx - step; x++) {  //FIRST ROW (moving right)
	      temp_x0 = xcenter_size_2 + temp_size_image_size * x;
		    
	      Spider(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		      
	      temp_trans = x * image_size + y;
       	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }   
	  }
		
	  for(x--, y++; y < tile_TOy - step; y++) { //LAST COLUMN (moving down)
              temp_y0 = ycenter_size_2 + temp_size_image_size * y;
		     
       	      Spider(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		    
	      temp_trans = x * image_size + y;
	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }      
	  }
		
	  for(y--, x--; x >= tile_FROMx + step; x--) { //LAST ROW (moving left)
	      temp_x0 = xcenter_size_2 + temp_size_image_size * x;
		    
	      Spider(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		    
	      temp_trans = x * image_size + y;
	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }     
	  }
	
	  for(x++, y--; y > tile_FROMy + step; y--) { //FIRST COLUMN (moving up)
	      temp_y0 = ycenter_size_2 + temp_size_image_size * y;
		    
	      Spider(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		    
	      temp_trans = x * image_size + y;
	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }    
	  }
		
	  y++;
		
	  if(whole_area) {
	      temp5 = step + 1;
	      temp1 = tile_TOx - temp5;
	      temp2 = tile_TOy - temp5;
	      temp3 = temp1 - x;
	      temp4 = temp2 - y;
		      
	      atomicAdd(&s_not_calculated, temp3 * temp4);
		    
	      for(k = y; k < temp2; k++) {
	          for(l = x + 1; l < temp1; l++) {
	    	      temp_trans = l * image_size + k;
		      d_image[temp_trans].red = starting_color.red;
		      d_image[temp_trans].green = starting_color.green;
		      d_image[temp_trans].blue = starting_color.blue;
		  }
	      }
		    
	      break;
	  }	
	
      }

      __syncthreads();

      if(threadIdx.x == 0 && threadIdx.y == 0) {
          atomicAdd(d_not_calculated, s_not_calculated);
      }
	
}


__global__ void TiledLambdaGPU(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float xcenter_size_2, float ycenter_size_2, float temp_size_image_size, int image_size, int tile_size, int *d_not_calculated) {
  int x, y, i, j, tile_FROMx, tile_TOx, tile_FROMy, tile_TOy, whole_area, temp, temp1, temp2, temp3, temp4, temp5, k, l, step, temp_trans;
  float temp_y0, temp_x0;
  Color starting_color;
  __shared__ int s_not_calculated;
      
      s_not_calculated = 0;
  
      i = threadIdx.x + blockDim.x * blockIdx.x;
      j = threadIdx.y + blockDim.y * blockIdx.y;
  
      tile_FROMy = i * image_size / tile_size;
      tile_TOy = (i + 1) * image_size / tile_size;

      tile_FROMx = j * image_size / tile_size;
      tile_TOx = (j + 1) * image_size / tile_size;
	  
      temp = (tile_TOy - tile_FROMy + 1) / 2;
	     
      for(y = tile_FROMy, whole_area = 1, step = 0; step < temp; step++, whole_area = 1) {
          temp_y0 = ycenter_size_2 + temp_size_image_size * y;
	
	  x = tile_FROMx + step;
	  temp_x0 = xcenter_size_2 + temp_size_image_size * x;
		
	  Lambda(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		  
	  temp_trans = x * image_size + y;
	  starting_color.red = d_image[temp_trans].red;
	  starting_color.green = d_image[temp_trans].green;
	  starting_color.blue = d_image[temp_trans].blue;
		
	  for(; x < tile_TOx - step; x++) {  //FIRST ROW (moving right)
	      temp_x0 = xcenter_size_2 + temp_size_image_size * x;
		    
	      Lambda(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		      
	      temp_trans = x * image_size + y;
       	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }   
	  }
		
	  for(x--, y++; y < tile_TOy - step; y++) { //LAST COLUMN (moving down)
              temp_y0 = ycenter_size_2 + temp_size_image_size * y;
		     
       	      Lambda(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		    
	      temp_trans = x * image_size + y;
	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }      
	  }
		
	  for(y--, x--; x >= tile_FROMx + step; x--) { //LAST ROW (moving left)
	      temp_x0 = xcenter_size_2 + temp_size_image_size * x;
		    
	      Lambda(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		    
	      temp_trans = x * image_size + y;
	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }     
	  }
	
	  for(x++, y--; y > tile_FROMy + step; y--) { //FIRST COLUMN (moving up)
	      temp_y0 = ycenter_size_2 + temp_size_image_size * y;
		    
	      Lambda(d_image, d_palette, max_iterations, palette_size, temp_x0, temp_y0, x, y, image_size);
		    
	      temp_trans = x * image_size + y;
	      if(d_image[temp_trans].red != starting_color.red || d_image[temp_trans].green != starting_color.green || d_image[temp_trans].blue != starting_color.blue) {
                  whole_area = 0;
    	      }    
	  }
		
	  y++;
		
	  if(whole_area) {
	      temp5 = step + 1;
	      temp1 = tile_TOx - temp5;
	      temp2 = tile_TOy - temp5;
	      temp3 = temp1 - x;
	      temp4 = temp2 - y;
		      
	      atomicAdd(&s_not_calculated, temp3 * temp4);
		    
	      for(k = y; k < temp2; k++) {
	          for(l = x + 1; l < temp1; l++) {
	    	      temp_trans = l * image_size + k;
		      d_image[temp_trans].red = starting_color.red;
		      d_image[temp_trans].green = starting_color.green;
		      d_image[temp_trans].blue = starting_color.blue;
		  }
	      }
		    
	      break;
	  }	
	
      }

      __syncthreads();

      if(threadIdx.x == 0 && threadIdx.y == 0) {
          atomicAdd(d_not_calculated, s_not_calculated);
      }
	
}

__device__ void inline Mandelbrot(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float re, float im, int i, int j, int image_size) {
  int iterations = 0, bailout = 4, temp_trans;
  float z_re = re, z_im = im, c_re = re, c_im = im, z_re_temp, squared_re, squared_im;
  int iterations_palette_size;
  unsigned char temp = 0;
  
    
    for(; iterations < max_iterations; iterations++) {
      
        squared_re = z_re * z_re;
	squared_im = z_im * z_im;
	
        if(squared_re + squared_im > bailout) {
	    break;
	}
	
	z_re_temp = squared_re - squared_im + c_re;
	z_im = 2 * z_re * z_im + c_im;
	z_re = z_re_temp;
	
    }
    
    temp_trans = i * image_size + j;
    iterations_palette_size = iterations % palette_size;
    temp -= (iterations != max_iterations);
    d_image[temp_trans].red = d_palette[iterations_palette_size].red & temp; 
    d_image[temp_trans].green = d_palette[iterations_palette_size].green & temp; 
    d_image[temp_trans].blue = d_palette[iterations_palette_size].blue & temp; 
    
}

__device__ void inline Newton4(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float re, float im, int i, int j, int image_size) {
  int iterations = 0, temp_trans;
  float epsilon = 1E-9;
  float z_re = re, z_im = im;
  float temp, temp2, temp3, divide_re, divide_im, dz_re, dz_im, old_re, old_im, temp_zre_oldre, temp_zim_old_im;
  int iterations_palette_size;
  unsigned char temp4 = 0;
  
  
    for(; iterations < max_iterations; iterations++) {
      
        if(iterations > 0 && (temp_zre_oldre = z_re - old_re) * (temp_zre_oldre) + (temp_zim_old_im = z_im - old_im) * (temp_zim_old_im) < epsilon) {
	    break;
	}
	
	old_re = z_re;
	old_im = z_im;
	
	temp = z_re * z_re;
	temp2 = z_im * z_im;

        dz_re = z_re * (temp - 3 * temp2);
        dz_im = z_im * (3 * temp - temp2);

        z_re = z_re * dz_re - z_im * dz_im - 1;
        z_im = old_re * dz_im + dz_re * z_im;

        dz_re *= 4;
        dz_im *= 4;
	
	temp3 = dz_re * dz_re + dz_im * dz_im;
	
	divide_re = (z_re * dz_re + z_im * dz_im) / temp3;
	divide_im = (z_im * dz_re - z_re * dz_im) / temp3;
	
	z_re = old_re - divide_re;
	z_im = old_im - divide_im;
    
    }
    
    temp_trans = i * image_size + j;
    iterations_palette_size = iterations % palette_size;
    temp4 -= (iterations != max_iterations);
    d_image[temp_trans].red = d_palette[iterations_palette_size].red & temp4; 
    d_image[temp_trans].green = d_palette[iterations_palette_size].green & temp4; 
    d_image[temp_trans].blue = d_palette[iterations_palette_size].blue & temp4; 
    
}

__device__ void inline Spider(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float re, float im, int i, int j, int image_size) {
  int iterations = 0, bailout = 4, temp_trans;
  float z_re = re, z_im = im, c_re = re, c_im = im, temp_re, squared_re, squared_im;
  int iterations_palette_size;
  unsigned char temp = 0;
 
  
    for(; iterations < max_iterations; iterations++) {
      
        squared_re = z_re * z_re;
	squared_im = z_im * z_im;
      
        if(squared_re + squared_im > bailout) {
	    break;
	}
	
	temp_re = squared_re - squared_im + c_re;
	z_im = 2 * z_re * z_im + c_im;
	z_re = temp_re;
	
	c_re = c_re / 2 + z_re;
	c_im = c_im / 2 + z_im;
	
    }
    
    temp_trans = i * image_size + j;
    iterations_palette_size = iterations % palette_size;
    temp -= (iterations != max_iterations);
    d_image[temp_trans].red = d_palette[iterations_palette_size].red & temp; 
    d_image[temp_trans].green = d_palette[iterations_palette_size].green & temp; 
    d_image[temp_trans].blue = d_palette[iterations_palette_size].blue & temp; 
  
}

__device__ void inline Lambda(Image *d_image, Color *d_palette, int max_iterations, int palette_size, float re, float im, int i, int j, int image_size) {
  int iterations = 0, bailout = 4, temp_trans;
  float z_re = 0.5, z_im = 0, c_re = re, c_im = im, temp_re, temp_im, temp_re2, temp_im2;
  int iterations_palette_size;
  unsigned char temp = 0;
  
  
    for(; iterations < max_iterations; iterations++) {
    
        if(z_re * z_re + z_im * z_im > bailout) {
	    break;
        }
      
        temp_re = c_re * z_re - c_im * z_im;
        temp_im = c_re * z_im + c_im * z_re;
      
        temp_re2 = 1 - z_re;
        temp_im2 = -z_im;
      
        z_re = temp_re * temp_re2 - temp_im * temp_im2;
        z_im = temp_re * temp_im2 + temp_im * temp_re2;
      
    } 
    
    temp_trans = i * image_size + j;
    iterations_palette_size = iterations % palette_size;
    temp -= (iterations != max_iterations);
    d_image[temp_trans].red = d_palette[iterations_palette_size].red & temp; 
    d_image[temp_trans].green = d_palette[iterations_palette_size].green & temp; 
    d_image[temp_trans].blue = d_palette[iterations_palette_size].blue & temp; 
    
}



