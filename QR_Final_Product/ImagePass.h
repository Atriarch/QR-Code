//
//  ImagePass.h
//  QR Project Take2
//
//  Created by student on 4/30/14.
//  Copyright (c) 2014 Nathan, Ryan, Scott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagePass : NSObject

-(void) newImage: (UIImage *) image;
-(void) qrTrue: (UIImage *) image;
-(UIImage *) returnImage;
-(BOOL) returnTruth;



@end
