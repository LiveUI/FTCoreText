//
//  FTCTHTMLSyntaxExampleViewController.m
//  FTCTExample
//
//  Created by Lukas Kukacka on 18/11/13.
//  Copyright (c) 2013 Fuerte International. All rights reserved.
//

#import "FTCTHTMLSyntaxExampleViewController.h"
#import "FTCoreTextView.h"

static const CGFloat kBasicTextSize = 12.0f;

@interface FTCTHTMLSyntaxExampleViewController () <FTCoreTextViewDelegate>

@end

@implementation FTCTHTMLSyntaxExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  This text uses syntax *similar* to HTML
    //  See the example text file
    self.coreTextView.text = [[self class] textFromTextFileNamed:@"ftcoretext-example-text-html-syntax.txt"];
    
    //  Define styles
    FTCoreTextStyle *defaultStyle = [[FTCoreTextStyle alloc] init];
    defaultStyle.name = FTCoreTextTagDefault;
    defaultStyle.textAlignment = FTCoreTextAlignementJustified;
    defaultStyle.font = [UIFont systemFontOfSize:kBasicTextSize];
    
    FTCoreTextStyle *h1Style = [defaultStyle copy];
    h1Style.name = @"h1";
    h1Style.font = [UIFont boldSystemFontOfSize:kBasicTextSize*2.0f];
    h1Style.textAlignment = FTCoreTextAlignementCenter;
    
    FTCoreTextStyle *h2Style = [h1Style copy];
    h2Style.name = @"h2";
    h2Style.font = [UIFont boldSystemFontOfSize:kBasicTextSize*1.25];
    
    FTCoreTextStyle *pStyle = [defaultStyle copy];
    pStyle.name = @"p";
    
    //  HTML list "li" style
    //  We first get default style for "_bullet" tag, rename it to "li"
    //  and then replace the default with new tag
    FTCoreTextStyle *liStyle = [FTCoreTextStyle styleWithName:FTCoreTextTagBullet];
    liStyle.name = @"li";
    liStyle.paragraphInset = UIEdgeInsetsMake(0, 14.0f, 0, 0);

    [self.coreTextView changeDefaultTag:FTCoreTextTagBullet toTag:@"li"];

    
    //  HTML image "img" style
    //  We first get default style for "_image" tag, rename it to "img"
    //  and then replace the default with new tag
    FTCoreTextStyle *imgStyle = [FTCoreTextStyle styleWithName:FTCoreTextTagImage];
    imgStyle.name = @"img";
    imgStyle.textAlignment = FTCoreTextAlignementCenter;
    
    [self.coreTextView changeDefaultTag:FTCoreTextTagImage toTag:@"img"];
    
    
    //  HTML link anchor "a"
    //  We first get default style for "_link" tag, rename it to "a"
    //  and then replace the default with new tag
    //  Mind you still need to use "_link"-like format
    //  <a>http://url.com|Dislayed text</a> format, not the html "<a href..." format
    FTCoreTextStyle *aStyle = [FTCoreTextStyle styleWithName:FTCoreTextTagLink];
    aStyle.name = @"a";
    aStyle.underlined = YES;
    aStyle.color = [UIColor blueColor];
    
    [self.coreTextView changeDefaultTag:FTCoreTextTagLink toTag:@"a"];
    
    //  Apply styles
    [self.coreTextView addStyles:@[defaultStyle, imgStyle, h1Style, h2Style, pStyle, liStyle, aStyle]];

    //  Make self delegate so we receive links actions
    self.coreTextView.delegate = self;
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
