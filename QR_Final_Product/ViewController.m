//
//  ViewController.m
//  QR Project Take2
//
//  Created by student on 4/30/14.
//  Copyright (c) 2014 Nathan, Ryan, Scott. All rights reserved.
//

#import "ViewController.h"
#import "QRChecker.h"
#import "ImagePass.h"
#import <AVFoundation/AVFoundation.h>


@interface ViewController ()

@property (nonatomic) ImagePass *iPass;
@property (nonatomic, strong) QRChecker *qrCheck;
@property (strong, nonatomic) IBOutlet UILabel *isaQRimage;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.iPass = [[ImagePass alloc] init];
    self.qrCheck = [[QRChecker alloc] init];
    [self computerfunction];
}

-(IBAction)takePhoto :(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    [imagePickerController setDelegate:self];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}



-(IBAction)chooseFromLibrary:(id)sender
{
    
    UIImagePickerController *imagePickerController= [[UIImagePickerController alloc]init];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePickerController setDelegate:self];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//This delegate methode will be called after picking photo either from camera or library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
  
    UIImage *imag = [info objectForKey:UIImagePickerControllerOriginalImage];
   
    
    [self.iPass newImage:imag];
    
    self.iPass = [self.qrCheck returnImage:self.iPass];
    
    
    CGRect myImageRect = CGRectMake(0.0f, 0.0f, 320.0f, 320.0f);
    UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
    myImage.image = [self.iPass returnImage];
    
    myImage.opaque = YES; // explicitly opaque for performance
    [self.view addSubview:myImage];

    
    }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//This function is used to test the code.
-(void) computerfunction{
    
    [self.isaQRimage setAlpha:0];
    
    
    
    //To try out image searches on a computer, change the file located in the line below. 
    UIImage *imag = [UIImage imageNamed:@"images.JPG"];
    [self.iPass newImage:imag];
    
    self.iPass = [self.qrCheck returnImage:self.iPass];
    
    
    CGRect myImageRect = CGRectMake(0.0f, 0.0f, 320.0f, 320.0f);
    UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
    //Photos taken with the camera are rotated by 90 degrees, use this to unrotate.
    //myImage.transform = CGAffineTransformMakeRotation(45*M_PI/90);
    myImage.image = [self.iPass returnImage];
    
    if([self.iPass returnTruth]){
        [self.isaQRimage setAlpha:1];
    }
    
    myImage.opaque = YES; // explicitly opaque for performance
    [self.view addSubview:myImage];
    
    
}



 

@end
