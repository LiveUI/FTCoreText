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
@synthesize maxLineHeight;
@synthesize spaceBetweenParagraphs;
@synthesize paragraphBodyLeftMargin;
@synthesize bulletInset;

- (id)init
{
	self = [super init];
	if (self) {
		self.name = @"_default";
		self.appendedCharacter = @"";
		self.color = [UIColor blackColor];
		self.isUnderLined = NO;
		self.alignment = kCTLeftTextAlignment;
		self.font = [UIFont systemFontOfSize:12];
		self.paragraphBodyLeftMargin = 0;
		self.bulletInset = 0;
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	FTCoreTextStyle *style = [[FTCoreTextStyle alloc] init];
	style.name = [[self.name copy] autorelease];
	style.appendedCharacter = [[self.appendedCharacter copy] autorelease];
	style.font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize];
	style.color = self.color;
	style.isUnderLined = self.isUnderLined;
    style.alignment = self.alignment;
	style.maxLineHeight = self.maxLineHeight;
	style.spaceBetweenParagraphs = self.spaceBetweenParagraphs;
	style.paragraphBodyLeftMargin = self.paragraphBodyLeftMargin;

	
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
