//
//  FTCTViewController.m
//  FTCTExample
//
//  Created by Adam Waite on 13/11/2013.
//  Copyright (c) 2013 Fuerte International. All rights reserved.
//

#import "FTCTViewController.h"
#import "FTCoreTextView.h"

@interface FTCTViewController () <FTCoreTextViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FTCoreTextView *coreTextView;
@end

@implementation FTCTViewController

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //add coretextview
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.coreTextView = [[FTCoreTextView alloc] initWithFrame:CGRectMake(20, 40, 280, 0)];
	self.coreTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.coreTextView.text = [self textForView];
    
    [self.coreTextView addStyles:[self coreTextStyle]];
    
    self.coreTextView.delegate = self;
	
	[self.coreTextView fitToSuggestedHeight];
    
    [self.scrollView addSubview:self.coreTextView];
    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.coreTextView.frame) + 50)];
    
    [self.view addSubview:self.scrollView];
    
}

#pragma mark Load Static Content

- (NSString *)textForView
{
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"text" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark Styling

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
	bulletStyle.paragraphInset = UIEdgeInsetsMake(0, 20.f, 0, 0);
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

#pragma mark FTCoreTextViewDelegate

- (void)coreTextView:(FTCoreTextView *)acoreTextView receivedTouchOnData:(NSDictionary *)data
{
    NSURL *url = [data objectForKey:FTCoreTextDataURL];
    if (!url) return;
    [[UIApplication sharedApplication] openURL:url];
}

@end
