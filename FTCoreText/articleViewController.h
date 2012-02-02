//
//  articleViewController.h
//  FTCoreText
//
//  Created by Francesco Frison on 18/08/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCoreTextView.h"

@interface articleViewController : UIViewController <FTCoreTextViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) FTCoreTextView *coreTextView;
@property (nonatomic, assign) int circles;
@property (nonatomic, assign) BOOL useCoreText;

@end
