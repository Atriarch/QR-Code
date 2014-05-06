//
//  CordPoints.m
//  QR Project Take2
//
//  Created by student on 4/30/14.
//  Copyright (c) 2014 Nathan, Ryan, Scott. All rights reserved.
//
//  This class holds the corner points which can then be used for transformation references.

#import "CordPoints.h"
@interface CordPoints()
@property (nonatomic) int xs;
@property (nonatomic) int ys;

@end

@implementation CordPoints

-(void) cordPoints:(int)x :(int)y{
    self.xs=x;
    self.ys=y;
}

-(int) returnX{
    return self.xs;
}

-(int) returnY{
    return self.ys;
}



@end
