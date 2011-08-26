//
//  FTCoreTextStyle.m
//  Deloitte
//
//  Created by Francesco Freezone <cescofry@gmail.com> on 10/08/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTCoreTextStyle.h"

@implementation FTCoreTextStyle

@synthesize name;
@synthesize appendedCharacter;
@synthesize font;
@synthesize color;
@synthesize isUnderLined;
@synthesize alignment;


- (id)copyWithZone:(NSZone *)zone
{
	FTCoreTextStyle *style = [[FTCoreTextStyle alloc] init];
	style.name = [[self.name copy] autorelease];
	style.appendedCharacter = [[self.appendedCharacter copy] autorelease];
	style.font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize];
	const CGFloat *components = CGColorGetComponents(color.CGColor);
	style.color = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:components[3]];
	style.isUnderLined = self.isUnderLined;
    style.alignment = self.alignment;
	return style;
}

- (void)dealloc {
    
    [name release], name = nil;
    [appendedCharacter release], appendedCharacter = nil;
    [font release], font = nil;
    [color release], color = nil;
    [super dealloc];
}

@end
