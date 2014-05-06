//
//  ImagePass.m
//  QR Project Take2
//
//  Created by student on 4/30/14.
//  Copyright (c) 2014 Nathan, Ryan, Scott. All rights reserved.
//
//  This class passes the QR images. It also holds a Boolean value which dicates if the current image is a QR code. 

#import "ImagePass.h"
@interface ImagePass()

@property (nonatomic) UIImage *currentImage;
@property (nonatomic) BOOL checker;

@end

@implementation ImagePass

-(void) newImage:(UIImage *)image{
    self.currentImage = image;
    self.checker = FALSE;
}

-(void) qrTrue: (UIImage *) image{
    self.currentImage = image;
    self.checker = TRUE;
}

-(UIImage *) returnImage{
    return self.currentImage;
}

-(BOOL) returnTruth{
    return self.checker;
}



@end
