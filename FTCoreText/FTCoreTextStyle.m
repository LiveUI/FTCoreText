//
//  FTCoreTextStyle.m
//  FTCoreText
//
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTCoreTextStyle.h"

@implementation FTCoreTextStyle

@synthesize name = _name;
@synthesize appendedCharacter = _appendedCharacter;
@synthesize font = _font;
@synthesize color = _color;
@synthesize underlined = _underlined;
@synthesize textAlignment = _textAlignment;
@synthesize paragraphInset = _paragraphInset;
@synthesize applyParagraphStyling = _applyParagraphStyling;
@synthesize bulletCharacter = _bulletCharacter;
@synthesize bulletFont = _bulletFont;
@synthesize bulletColor = _bulletColor;
@synthesize leading = _leading;
@synthesize maxLineHeight = _maxLineHeight;
@synthesize minLineHeight = _minLineHeight;
@synthesize block = _block;

- (id)init
{
	self = [super init];
	if (self) {
		_name = @"_default";
		_bulletCharacter = @"•";
		_appendedCharacter = @"";
		_font = [UIFont systemFontOfSize:12];
		_color = [UIColor blackColor];
		_underlined = NO;
		_textAlignment = FTCoreTextAlignementLeft;
		_maxLineHeight = 0;
		_minLineHeight = 0;
		_paragraphInset = UIEdgeInsetsZero;
		_applyParagraphStyling = YES;
		_leading = 0;
        _block = nil;
	}
	return self;
}

+ (id)styleWithName:(NSString *)name
{
    FTCoreTextStyle *style = [[FTCoreTextStyle alloc] init];
    [style setName:name];
    return style;
}

- (void)setSpaceBetweenParagraphs:(CGFloat)spaceBetweenParagraphs
{
	UIEdgeInsets edgeInset = _paragraphInset;
	edgeInset.bottom = spaceBetweenParagraphs;
	self.paragraphInset = edgeInset;
}

- (CGFloat)spaceBetweenParagraphs
{
	return _paragraphInset.bottom;
}

- (UIFont *)bulletFont
{
	if (_bulletFont == nil) {
		return _font;
	}
	return _bulletFont;
}

- (UIColor *)bulletColor
{
	if (_bulletColor == nil) {
		return _color;
	}
	return _bulletColor;
}

- (id)copyWithZone:(NSZone *)zone
{
	FTCoreTextStyle *style = [[FTCoreTextStyle allocWithZone:zone] init];
	style.name = [self.name copy];
	style.bulletCharacter = self.bulletCharacter;
    style.bulletColor = self.bulletColor;
	style.appendedCharacter = [self.appendedCharacter copy];
	style.font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize];
	style.color = self.color;
	style.underlined = self.isUnderLined;
    style.textAlignment = self.textAlignment;
	style.maxLineHeight = self.maxLineHeight;
	style.minLineHeight = self.minLineHeight;
	style.paragraphInset = self.paragraphInset;
	style.applyParagraphStyling = self.applyParagraphStyling;
	style.leading = self.leading;
	return style;
}

@end
