//
//  FTCTBasicExampleViewController.h
//  FTCTExample
//
//  Created by Lukas Kukacka on 15/11/13.
//  Copyright (c) 2013 Fuerte International. All rights reserved.
//
//  This controller is meant to be subclassed to provide
//  automatically manager creation of FTCoreText view inside UIScrollView

#import <UIKit/UIKit.h>

@class FTCoreTextView;

@interface FTCTBasicExampleViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FTCoreTextView *coreTextView;

+ (NSString *)textFromTextFileNamed:(NSString *)filename;

@end
