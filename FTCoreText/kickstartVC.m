//
//  kickstartVC.m
//  FTCoreText
//
//  Created by Francesco on 02/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "kickstartVC.h"
#import "articleViewController.h"

@implementation kickstartVC

@synthesize segmentControl;

- (void)start:(UIButton *)sender {
    articleViewController *articleVC = [[articleViewController alloc] init];
    [articleVC setCircles:(sender.tag)];
    [articleVC setUseCoreText:([self.segmentControl selectedSegmentIndex] == 0)];
    [self presentModalViewController:articleVC animated:NO];
    [articleVC release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(60, 80, 200, 40);
    for (int i = 1; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:[NSString stringWithFormat:@"%d times", i] forState:UIControlStateNormal];
        [btn setFrame:frame];
        [btn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [self.view addSubview:btn];
        frame.origin.y += 45;
    }
    
    segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"FTCoreText", @"UIWebView", nil]];
    [self.segmentControl setFrame:CGRectMake(10, 10, 300, 40)];
    [self.segmentControl setSelectedSegmentIndex:0];
    [self.view addSubview:self.segmentControl];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [segmentControl release];
    [super dealloc];
}

@end
