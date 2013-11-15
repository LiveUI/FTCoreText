//
//  FTCTViewController.h
//  FTCTExample
//
//  Created by Adam Waite on 13/11/2013.
//  Copyright (c) 2013 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTCoreTextView;

@interface FTCTViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FTCoreTextView *coreTextView;

@end
