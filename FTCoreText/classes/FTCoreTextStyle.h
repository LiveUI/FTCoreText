//
//  FTCoreTextStyle.h
//  Deloitte
//
//  Created by Francesco Freezone <cescofry@gmail.com> on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface FTCoreTextStyle : NSObject <NSCopying> {
    NSString *name;
    NSString *appendedCharacter;
    UIFont *font;
    UIColor *color;
    BOOL isUnderLined;
    CTTextAlignment alignment;
	CGFloat maxLineHeight;
	CGFloat spaceBetweenParagraphs;
	CGFloat paragraphBodyLeftMargin;
	CGFloat bulletInset;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *appendedCharacter;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, assign, getter=isUnderLined) BOOL isUnderLined;
@property (nonatomic, assign) CTTextAlignment alignment;
@property (nonatomic, assign) CGFloat maxLineHeight;
@property (nonatomic, assign) CGFloat spaceBetweenParagraphs;
@property (nonatomic, assign) CGFloat paragraphBodyLeftMargin;
@property (nonatomic, assign) CGFloat bulletInset;

@end