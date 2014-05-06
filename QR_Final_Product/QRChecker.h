//
//  QRChecker.h
//  QR Project Take2
//
//  Created by student on 4/30/14.
//  Copyright (c) 2014 Nathan, Ryan, Scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImagePass.h"

@interface QRChecker : NSObject

-(ImagePass *) returnImage: (ImagePass *) imageInfo;


typedef struct{
    int recholder[10];
} Rech;

@end
