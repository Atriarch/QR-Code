Nathan McGaughy
Scott
Ryan

Friday 2, 2014
CS 470

QR Code Recognizer

For our project, we decided to create an app that could scan images, locate QR markers within the images, and post the information stored, if it is indeed a QR Code. Though we were able to implement the camera function, including the ability to scan the images, locate QR markers, and post whether or not the image is that of a QR Code, we were unable to implement the reader.

ViewController:
In the view, we call upon the camera functions (including the photo library) in order to take pictures. Once taken, the user can decide on whether or not he/she would like to use the photo. If so, it is processed by the QRChecker to see if it is in fact a QR code. The QRChecker will then return a boolean, along with a new image. The image will be a scanned and edited version of the photo if it is a QR code. If not, it will return the old image. 

ImagePass:
The ImagePass class is used to pass the old and new images, including the boolean that will determine if the old image is in fact a QR Code.

QRChecker:
The QRChecker is given an image from which it converts it into an NSData class. The NSData class then passes the byte reference to an unsigned char. It is through the manipulation of this char array that we are able to work with the image data. The data is first passed to the isQR function which converts the RGB pixels into 0 or 255 (black/white). This can also be done with CMYK pixels, though the searching values would have to be changed. The image is then passed to the squareFinder function which loops through the entire image until a black pixel is encountered. Once this occurs, the wePaintItRed function is called to convert most of the surrounding black pixels to green. At this point, the highest x/y values, along with the lowest x/y values are saved for usage by the squareCheck function. The squareCheck function examines the these 4 values, and attempts to find the point from which these values intersect. If the pixel at the new coordinate is black, then it is safe to assume that it is in fact a corner point. This function may be called upon 3 times. If it is not called upon exactly 3 times, the image is not that of a QR Code. 

PROBLEMS: This was discovered when applying the code to the Iphone. The main strength behind the QR finders algorithm is through the recursion applied. However, the maximum recursion depth of the Iphone is very low (maximum around 400). This implies that each search down the tree is very limited. The max depth also happens to be the max number of pixels that can be scanned in any one direction. To improve upon this depth, a coordinate holder was made to save the max x/y range has been encountered at the rDepth range. The rDepth range was made to avoid running into a memory error on the Iphone. It is safe to set it to 10,000 on the computer. However, even with this implementation, the accuracy of the searching algorithm is very hit or miss on the Iphone. On the computer, the accuracy is near perfect. Furthermore, any changes made to the UIImages to reduce the number of pixels was rejected during run attempts on the Iphone due to data access errors. We were unable to solve this issue with the given time on the Iphone. 


Usage:
Iphone:
To use this app with an Iphone, simply select a photo from your library, or take a picture of a QR code. However, the accuracy on the Iphone is currently low. 

Computer:
To test this code on a computer, simply switch out the starting example located under the computerfunction function. The computer is very accurate at a rDepth level of 10000 (this can be changed in the squareFinder function).

In order to see the edited version of a failed image, uncomment the commented code located in the “returnImage” function in the QRChecker.


