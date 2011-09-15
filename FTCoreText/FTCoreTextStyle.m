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
@synthesize URLStringReplacement;
@synthesize maxLineHeight;
@synthesize spaceBetweenParagraphs;

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
    style.URLStringReplacement = self.URLStringReplacement;
	style.maxLineHeight = self.maxLineHeight;
	style.spaceBetweenParagraphs = self.spaceBetweenParagraphs;
	return style;
}

- (void)dealloc {
    
    [name release], name = nil;
    [appendedCharacter release], appendedCharacter = nil;
    [font release], font = nil;
    [color release], color = nil;
    [URLStringReplacement release], URLStringReplacement = nil;
    [super dealloc];
}

@end
