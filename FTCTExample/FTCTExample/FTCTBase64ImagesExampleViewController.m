//
//  FTCTBase64ImagesExampleViewController.m
//  FTCTExample
//
//  Created by Lukas Kukacka on 15/11/13.
//  Copyright (c) 2013 Fuerte International. All rights reserved.
//

#import "FTCTBase64ImagesExampleViewController.h"

#import "FTCoreTextView.h"

@interface FTCTBase64ImagesExampleViewController () <FTCoreTextViewDelegate>

@end

@implementation FTCTBase64ImagesExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  This text file contains images in Base64 formatting
    //  Just add <_image>base64:BASE64_ENCODED_IMAGE</_image> to the text
    //  See the example text file
    self.coreTextView.text = [[self class] textFromTextFileNamed:@"ftcoretext-example-text-inline-base64-images.txt"];
    
    
    
    //  We just add some formatting and delegate, but it is not really needed for images to work
    self.coreTextView.delegate = self;
    
    FTCoreTextStyle *imageStyle = [FTCoreTextStyle styleWithName:FTCoreTextTagImage];
    imageStyle.textAlignment = FTCoreTextAlignementCenter;
    
    [self.coreTextView addStyle:imageStyle];
}

#pragma mark FTCoreTextViewDelegate

- (void)coreTextView:(FTCoreTextView *)acoreTextView receivedTouchOnData:(NSDictionary *)data
{
    NSURL *url = [data objectForKey:FTCoreTextDataURL];
    
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
