//
//  QRChecker.m
//  QR Project Take2
//
//  Created by student on 4/30/14.
//  Copyright (c) 2014 Nathan, Ryan, Scott. All rights reserved.
//
//  This class checks for QR codes in images. It also finds the corner points for transformation options.

#import "QRChecker.h"
#import "ImagePass.h"
#import "CordPoints.h"

@interface QRChecker()

@property (nonatomic, strong) ImagePass *iinfo;
@property (nonatomic) int maxx;
@property (nonatomic) int maxy;
@property (nonatomic) int minx;
@property (nonatomic) int miny;
@property (nonatomic) unsigned char *pixels;
@property (nonatomic) float height;
@property (nonatomic) float width;
@property (nonatomic) float bitsPP;
@property (nonatomic) float bytesPR;
@property (nonatomic) CordPoints *cornerA;
@property (nonatomic) CordPoints *cornerB;
@property (nonatomic) CordPoints *cornerC;
@property (nonatomic) int xhold, yhold;
@property (nonatomic) int depth;
@property (nonatomic) int rDepth;
@property (nonatomic) int count;
@property (nonatomic) BOOL lock;

@end


@implementation QRChecker


-(ImagePass *) returnImage: (ImagePass *) imageInfo{
    self.iinfo = [[ImagePass alloc] init];
    self.iinfo = imageInfo;
    
    UIImage *tempImage = [self.iinfo returnImage];
    
    CGImageRef imager = tempImage.CGImage;
    
    self.width = CGImageGetWidth(imager);
    self.height= CGImageGetHeight(imager);
    
   //This data value is being used to get at the bytes in the image.
    NSData *data = (NSData *)CFBridgingRelease(CGDataProviderCopyData(CGImageGetDataProvider(imager)));
   
    
    //Pixels is used throughout the code as a holder for the byte information (RGB);
    self.pixels = (UInt8 *)[data bytes];
    
    
    float bitsPC = CGImageGetBitsPerComponent(imager);
    self.bitsPP = CGImageGetBitsPerPixel(imager);
    self.bytesPR = CGImageGetBytesPerRow(imager);
    CGColorSpaceRef cSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bmInfo = CGImageGetBitmapInfo(imager);
    
    
    if([self isQR]){
        CGDataProviderRef prov = CGDataProviderCreateWithData(NULL, self.pixels, [data length], NULL);
        
        CGImageRef newImager = CGImageCreate(self.width, self.height, bitsPC, self.bitsPP, self.bytesPR, cSpace, bmInfo, prov, NULL, FALSE, kCGRenderingIntentDefault);
        
        tempImage = [UIImage imageWithCGImage:newImager];
        
        [self.iinfo qrTrue:[UIImage imageWithCGImage:newImager]];
    }
    else{
    
    //Implement this code if you wish to make failed photos also return in their edited format.
    /*
    CGDataProviderRef prov = CGDataProviderCreateWithData(NULL, self.pixels, [data length], NULL);
    
    CGImageRef newImager = CGImageCreate(self.width, self.height, bitsPC, self.bitsPP, self.bytesPR, cSpace, bmInfo, prov, NULL, FALSE, kCGRenderingIntentDefault);
    
    tempImage = [UIImage imageWithCGImage:newImager];
    
    [self.iinfo newImage:[UIImage imageWithCGImage:newImager]];
    }
     */
    }
    
    return self.iinfo;
}


//This function makes the images black/white based upon the RGB search constraint. The values can be played with inorder to refine the image search.
-(BOOL) isQR{
    for(int y = 0; y < self.height; y++){
        for(int x = 0; x < self.width; x++){
             int pix = (x + (y *  self.width)) * 4;
            //int pix = (y * self.width * 4 + x * 4);
            //int pix = (self.width*y)+x;
            
            
            int red = pix;
            int green = pix+1;
            int blue = pix+2;
            int alpha = pix+3;
           
          
            
            if(self.pixels[red] > 50 || self.pixels[green] > 50|| self.pixels[blue] > 50){
                self.pixels[red] = 255.0;
                self.pixels[green] = 255.0;
                self.pixels[blue] = 255.0;
                self.pixels[alpha] = self.pixels[alpha];
            }
            else{
                self.pixels[red] = 0;
                self.pixels[green] = 0.0;
                self.pixels[blue] = 0.0;
                self.pixels[alpha] = self.pixels[alpha];
            }
        }
    }
    return [self squareFinder];
}


//This function looks for the 3 qr corner markers. rDepth is used in order to avoid memory errors. (MUST BE LOWER than 400 when used on the IPhone).
-(BOOL) squareFinder{
  
    self.maxx = 0;
    self.maxy = 0;
    self.minx = self.width;
    self.miny = self.height;
    self.rDepth =10000;
    int cord = 0;
    
    self.cornerA = [[CordPoints alloc] init];
    self.cornerB = [[CordPoints alloc] init];
    self.cornerC = [[CordPoints alloc] init];
    
    for(int y = 0; y < self.height; y++){
        for(int x = 0; x < self.width; x++){
            int pix = (x + (y *  self.width)) * 4;
            int red = pix;
            int green = pix+1;
            int blue = pix+2;
            
           
            
            if(self.pixels[red] == 0 && self.pixels[green] == 0 && self.pixels[blue] == 0){
                self.lock = TRUE;
                self.depth = 0;
                
                [self wePaintItGreen:x :y];
                self.lock = TRUE;
                self.depth = 0;
                
                if([self squareCheck] == TRUE){
                    cord++;
                    if(cord == 1){
                        [self.cornerA cordPoints:((self.maxx - self.minx) / 2) + self.minx :((self.maxy - self.miny) / 2) + self.miny];
                    }
                    if(cord == 2){
                        [self.cornerB cordPoints:((self.maxx - self.minx) / 2) + self.minx :((self.maxy - self.miny) / 2) + self.miny];
                    }
                    if(cord == 3){
                        [self.cornerC cordPoints:((self.maxx - self.minx) / 2) + self.minx :((self.maxy - self.miny) / 2) + self.miny];
                    }
                    if(cord > 3){
                        return FALSE;
                    }
                }
                self.maxx = 0;
                self.maxy = 0;
                self.minx = self.width;
                self.miny = self.height;
            }
        }
    }
    if(cord == 3){
        return TRUE;
    }
    else{
        return FALSE;
    }
}


//This function is called inorder to see if one of the squares have been encountered.
-(BOOL) squareCheck{
    int x = 0;
    int y = 0;
    
    
    x = ((self.maxx - self.minx) / 2) + self.minx;
    y = ((self.maxy - self.miny) / 2) + self.miny;
    int pix = (x + (y *  self.width)) * 4;

  
    if(x <= self.width && x >= 0 && y < self.height && y >= 0){
        if(self.pixels[pix] <= 100 && self.pixels[pix+1] <= 100 && self.pixels[pix+2] <= 100){
            [self wePaintItRed:x :y];
            return TRUE;
        }
    }
    return FALSE;
}

//Corner squares are colored red.
-(void) wePaintItRed: (int) x : (int) y{
    
    int pix = (x + (y *  self.width)) * 4;
    self.depth++;
    
    self.pixels[pix] = 255;
    self.pixels[pix+1] = 0;
    self.pixels[pix+2] = 0;
        
    if(self.depth<self.rDepth){
        if(y+1 < self.height){
            pix = (x + ((y+1) *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 10 && self.pixels[pix+2] <= 10){
                [self wePaintItRed:x :y+1];
            }
        }
    
        if(x+4 < self.width && y+1 < self.height){
            pix = ((x+1) + ((y+1) *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 10 && self.pixels[pix+2] <= 10){
                [self wePaintItRed:x+1 :y+1];
            }
        }
    
        if(x+4 <= self.width){
            pix = ((x+1) + (y *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 10 && self.pixels[pix+2] <= 10){
                [self wePaintItRed:x+1 :y];
            }
        }
    
        if(x+4 <= self.width && y-1 >= 0){
            pix = ((x+1) + ((y-1) *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 100 && self.pixels[pix+2] <= 10){
                [self wePaintItRed:x+1 :y-1];
            }
        }
    
        if(y-1 >= 0){
            pix = (x + ((y-1) *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 10 && self.pixels[pix+2] <= 10){
                [self wePaintItRed:x :y-1];
            }
        }
    
        if(x-4 >= 0 && y-1 > 0){
            pix = ((x-1) + ((y-1) *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 10 && self.pixels[pix+2]<= 10){
                [self wePaintItRed:x-1 :y-1];
            }
        }
    
        if(x-4 >= 0){
            pix = ((x-1) + (y *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 10 && self.pixels[pix+2] <= 10){
                [self wePaintItRed:x-1 :y];
            }
        }
    
        if(x-4 >= 0 && y+1 < self.height){
            pix = ((x-1) + ((y+1) *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 10 && self.pixels[pix+2] <= 10){
                [self wePaintItRed:x-1 :y+1];
            }
        }
        }
    
    if(self.depth == self.rDepth){
    
        self.lock = FALSE;
        self.xhold = x;
        self.yhold = y;
    }
    if(self.depth == 0 && self.lock != TRUE ){

        [self wePaintItRed:self.xhold :self.yhold];
    }
    
    self.depth--;

}


//Everything else is colored green.
-(void) wePaintItGreen: (int) x : (int) y{
    if(x > self.maxx){
        self.maxx = x;
    }
    if(x < self.minx){
        self.minx = x;
    }
    if(y > self.maxy){
        self.maxy = y;
    }
    if(y < self.miny){
        self.miny = y;
    }
    
    int pix = (x + (y *  self.width)) * 4;
    self.pixels[pix] = 0;
    self.pixels[pix+1] = 255;
    self.pixels[pix+2] = 0;
    self.depth++;
    
    if(self.depth<self.rDepth){
        if(x+4 < self.width && y+1 < self.height){
            pix = (x + ((y+1) *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 10 && self.pixels[pix+2] <= 10){
                [self wePaintItGreen:x :y+1];
            }
        }
    
        if(x+4 < self.width && y+1 < self.height){
            pix = ((x+1) + ((y+1) *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 10 && self.pixels[pix+2] <= 10){
                [self wePaintItGreen:x+1 :y+1];
            }
        }
    
        if(x+4 < self.width && y+1 < self.height){
            pix = ((x+1) + (y *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 10 && self.pixels[pix+2] <= 10){
                [self wePaintItGreen:x+1 :y];
            }
        }
    
        if(x+4 < self.width && y-1 > 0){
            pix = ((x+1) + ((y-1) *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 10 && self.pixels[pix+2] <= 10){
                [self wePaintItGreen:x+1 :y-1];
            }
        }
    
        if(x-4 > 0 && y-1 > 0){
            pix = (x + ((y-1) *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 10 && self.pixels[pix+2] <= 10){
                [self wePaintItGreen:x :y-1];
            }
        }
    
        if(x-4 > 0 && y-1 > 0){
            pix = ((x-1) + ((y-1) *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 10 && self.pixels[pix+2] <= 10){
                [self wePaintItGreen:x-1 :y-1];
            }
        }
    
        if(x-4 > 0 && y-1 >0){
            pix = ((x-1) + (y *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 10 && self.pixels[pix+2] <= 10){
                [self wePaintItGreen:x-1 :y];
            }
        }
    
        if(x-4 > 0 && y+1 < self.height){
            pix = ((x-1) + ((y+1) *  self.width)) * 4;
            if(self.pixels[pix] <= 10 && self.pixels[pix+1] <= 10 && self.pixels[pix+2] <= 10){
                [self wePaintItGreen:x-1 :y+1];
            }
        }
            }
   
    if(self.depth == self.rDepth){
       // self.depth--;
        self.lock = FALSE;
        self.xhold = x;
        self.yhold = y;
    }
    if(self.depth == 0 && self.lock != TRUE ){
        self.depth--;
        [self wePaintItGreen:self.xhold :self.yhold];
   }
        
       self.depth--;
  
}

//This function is used to decide which corner point is which.
-(void) transforms{

    int ax = [self.cornerA returnX];
    int ay = [self.cornerA returnY];
    int bx = [self.cornerB returnX];
    int by = [self.cornerB returnY];
    int cx = [self.cornerC returnX];
    int cy = [self.cornerC returnY];
    int ab, bc, ca;
    int dx, dy;
    CordPoints *topLeftMost;
    
    if(ax > bx){
        dx=ax-bx;
    }
    else{
        dx=bx-ax;
    }
    
    if(ay>by){
        dy=ay-by;
    }
    else{
        dy=by-ay;
    }
    
    ab = sqrt((dx*dx)+(dy*dy));
    
    if(bx > cx){
        dx=bx-cx;
    }
    else{
        dx=cx-bx;
    }
    
    if(by > cy){
        dy=by-cy;
    }
    else{
        dy=cy-by;
    }
    
    bc = sqrt((dx*dx)+(dy*dy));
    
    if(cx > ax){
        dx=cx-ax;
    }
    else{
        dx=ax-cx;
    }
    
    if(cy > ay){
        dy=cy-ay;
    }
    else{
        dy=ay-cy;
    }
    
    ca = sqrt((dx*dx)+(dy*dy));

    NSLog(@"%d and %d and %d", ab, bc, ca);
    
    
    if((ab+ca) < (ca+bc) && (ab+ca) < (ab+bc)){
        topLeftMost=self.cornerA;
        NSLog(@"It is A");
    }
    
    if((ab+bc) < (ca+ab) && (ab+bc) < (ca+bc)){
        topLeftMost=self.cornerB;
        NSLog(@"It is B");
    }
    
    if((ca+bc) < (ab+ca) && (ca+bc) < (ab+bc)){
        topLeftMost=self.cornerC;
        NSLog(@"It is C");
    }
}

@end
