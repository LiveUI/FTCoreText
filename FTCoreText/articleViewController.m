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



#pragma mark - View lifecycle


- (NSString *)textForView {
    return @"<title>Article Title</title>\nMaecenas faucibus mollis interdum. Morbi leo risus, <_link>http://www.google.com|I am a link</_link> ac consectetur ac, vestibulum at eros.\n<_image>homer.png</_image><black>Curabitur blandit tempus porttitor</black>. Donec ullamcorper nulla non metus auctor fringilla. Sed posuere consectetur est at lobortis.\n<_image>homer.png</_image>Cras justo odio, dapibus ac facilisis in, egestas eget quam. Nullam quis risus eget urna mollis ornare vel eu leo:\n<bullet />Fusce dapibus\n<bullet />tellus ac cursus commodo\n<bullet />tortor mauris condimentum nibh\n  <_bullet />Cras justo odio<_bullet />Dapibus ac facilisis in<_bullet />Gestas eget quam. Vivamus hendrerit arcu sed erat molestie vehicula. Sed auctor neque.\n<disclaimer>Ut fermentum massa justo sit amet risus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.</disclaimer>";
}


- (NSArray *)coreTextStyle {
    
    NSMutableArray *result = [NSMutableArray array];
           
    FTCoreTextStyle *defaultStyle = [[FTCoreTextStyle alloc] init];
    [defaultStyle setName:@"_default"];
    defaultStyle.color = [UIColor darkGrayColor];
    defaultStyle.font = [UIFont systemFontOfSize:14];
    [result addObject:defaultStyle];
    [defaultStyle release];
    
    FTCoreTextStyle *blackBold = [[FTCoreTextStyle alloc] init];
    blackBold.name = @"black";
    blackBold.color = [UIColor blackColor];
    blackBold.font = [UIFont boldSystemFontOfSize:14];
    [result addObject:blackBold];
    [blackBold release];
    
    FTCoreTextStyle *titleStyle = [[FTCoreTextStyle alloc] init];
    titleStyle.name = @"title";
    titleStyle.color = [UIColor redColor];
    titleStyle.font = [UIFont boldSystemFontOfSize:20];
    titleStyle.alignment = kCTCenterTextAlignment;
	
    [result addObject:titleStyle];
    [titleStyle release];
    
    FTCoreTextStyle *disclaimerStyle = [[FTCoreTextStyle alloc] init];
    disclaimerStyle.name = @"disclaimer";
    disclaimerStyle.color = [UIColor blueColor];
    disclaimerStyle.font = [UIFont italicSystemFontOfSize:13];
    [result addObject:disclaimerStyle];
    [disclaimerStyle release];
    
    FTCoreTextStyle *bullet = [[FTCoreTextStyle alloc] init];
    bullet.name = @"_bullet";
    bullet.color = [UIColor purpleColor];
    bullet.font = [UIFont systemFontOfSize:14];
	bullet.appendedCharacter = @"\n•";
	bullet.bulletInset = 15;
    [result addObject:bullet];
    [bullet release];
    
    FTCoreTextStyle *imgStyle = [[FTCoreTextStyle alloc] init];
    imgStyle.name = @"_image";
    imgStyle.color = [UIColor purpleColor];
    imgStyle.font = [UIFont systemFontOfSize:14];
    imgStyle.alignment = kCTCenterTextAlignment;
    imgStyle.spaceBetweenParagraphs = 10;
    [result addObject:imgStyle];
    [imgStyle release];
    
    FTCoreTextStyle *linkStyle = [[FTCoreTextStyle alloc] init];
    linkStyle.name = @"_link";
    [linkStyle setColor:[UIColor blueColor]];
    [linkStyle setFont:[UIFont italicSystemFontOfSize:14]];
    [result addObject:linkStyle];
    [linkStyle release];

    
    return  result;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
    //add coretextview
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    FTCoreTextView *coreTextV = [[FTCoreTextView alloc] initWithFrame:CGRectMake(20, 0, 280, 800)];
    // set text
    [coreTextV setText:[self textForView]];
    // set styles
    [coreTextV addStyles:[self coreTextStyle]];
    //set deelgate
    [coreTextV setDelegate:self];
    
    coreTextV.layer.shadowColor = [UIColor blackColor].CGColor;
    coreTextV.layer.shadowOffset = CGSizeMake(1, 1);
    coreTextV.layer.shadowOpacity = 0.4;
    coreTextV.layer.shadowRadius = 2;
    
    [scrollView addSubview:coreTextV];
    [scrollView setContentSize:[coreTextV suggestedSizeConstrainedToSize:CGSizeMake(coreTextV.bounds.size.width, CGFLOAT_MAX)]];
    
    [self.view addSubview:scrollView];
	[scrollView release];
    [coreTextV release];
    
    
}

- (void)touchedData:(NSDictionary *)data inCoreTextView:(FTCoreTextView *)textView {
    NSURL *url = [data objectForKey:@"url"];
    if (!url) return;
    [[UIApplication sharedApplication] openURL:url];
}





@end
