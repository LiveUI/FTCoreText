//
//  articleViewController.m
//  FTCoreText
//
//  Created by Francesco Frison on 18/08/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "articleViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation articleViewController
@synthesize scrollView;
@synthesize coreTextView;


- (NSString *)textForView
{
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"text" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
}


- (NSArray *)coreTextStyle
{
    NSMutableArray *result = [NSMutableArray array];
    
	FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
	defaultStyle.name = FTCoreTextTagDefault;	//thought the default name is already set to FTCoreTextTagDefault
	defaultStyle.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:16.f];
	defaultStyle.textAlignment = FTCoreTextAlignementJustified;
	[result addObject:defaultStyle];
	
	
	FTCoreTextStyle *titleStyle = [FTCoreTextStyle styleWithName:@"title"]; // using fast method
	titleStyle.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:40.f];
	titleStyle.paragraphInset = UIEdgeInsetsMake(0, 0, 25, 0);
	titleStyle.textAlignment = FTCoreTextAlignementCenter;
	[result addObject:titleStyle];
	
	FTCoreTextStyle *imageStyle = [FTCoreTextStyle new];
	imageStyle.paragraphInset = UIEdgeInsetsMake(0,0,0,0);
	imageStyle.name = FTCoreTextTagImage;
	imageStyle.textAlignment = FTCoreTextAlignementCenter;
	[result addObject:imageStyle];
	
	FTCoreTextStyle *firstLetterStyle = [FTCoreTextStyle new];
	firstLetterStyle.name = @"firstLetter";
	firstLetterStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:30.f];
	[result addObject:firstLetterStyle];
	
	FTCoreTextStyle *linkStyle = [defaultStyle copy];
	linkStyle.name = FTCoreTextTagLink;
	linkStyle.color = [UIColor orangeColor];
	[result addObject:linkStyle];
	
	FTCoreTextStyle *subtitleStyle = [FTCoreTextStyle styleWithName:@"subtitle"];
	subtitleStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:25.f];
	subtitleStyle.color = [UIColor brownColor];
	subtitleStyle.paragraphInset = UIEdgeInsetsMake(10, 0, 10, 0);
	[result addObject:subtitleStyle];
	
	FTCoreTextStyle *bulletStyle = [defaultStyle copy];
	bulletStyle.name = FTCoreTextTagBullet;
	bulletStyle.bulletFont = [UIFont fontWithName:@"TimesNewRomanPSMT" size:16.f];
	bulletStyle.bulletColor = [UIColor orangeColor];
	bulletStyle.bulletCharacter = @"❧";
	[result addObject:bulletStyle];
    
    FTCoreTextStyle *italicStyle = [defaultStyle copy];
	italicStyle.name = @"italic";
	italicStyle.underlined = YES;
    italicStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:16.f];
	[result addObject:italicStyle];
    
    FTCoreTextStyle *boldStyle = [defaultStyle copy];
	boldStyle.name = @"bold";
    boldStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:16.f];
	[result addObject:boldStyle];
    
    FTCoreTextStyle *coloredStyle = [defaultStyle copy];
    [coloredStyle setName:@"colored"];
    [coloredStyle setColor:[UIColor redColor]];
	[result addObject:coloredStyle];
    
    return  result;
}

- (void)coreTextView:(FTCoreTextView *)acoreTextView receivedTouchOnData:(NSDictionary *)data
{
    NSURL *url = [data objectForKey:FTCoreTextDataURL];
    if (!url) return;
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - View Controller Methods

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//add coretextview
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    coreTextView = [[FTCoreTextView alloc] initWithFrame:CGRectMake(20, 20, 280, 0)];
	coreTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // set text
    [coreTextView setText:[self textForView]];
    // set styles
    [coreTextView addStyles:[self coreTextStyle]];
    // set delegate
    [coreTextView setDelegate:self];
	
	[coreTextView fitToSuggestedHeight];

    [scrollView addSubview:coreTextView];
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.bounds), CGRectGetHeight(coreTextView.frame) + 40)];
    
    [self.view addSubview:scrollView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.bounds), CGRectGetHeight(coreTextView.frame) + 40)];
}


@end
