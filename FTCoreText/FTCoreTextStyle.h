//
//  FTCoreTextStyle.h
//  FTCoreText
//
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//abstracts from Apple's headers.
/*!
 @enum		FTCoreTextAlignement
 @abstract	These constants specify text alignment.
 
 @constant	FTCoreTextAlignementLeft
 Text is visually left-aligned.
 
 @constant	FTCoreTextAlignementRight
 Text is visually right-aligned.
 
 @constant	FTCoreTextAlignementCenter
 Text is visually center-aligned.
 
 @constant	FTCoreTextAlignementJustified
 Text is fully justified. The last line in a paragraph is
 naturally aligned.
 
 @constant	FTCoreTextAlignementNatural
 Use the natural alignment of the text's script.
 */


typedef void (^FTCoreTextCallbackBlock)(NSDictionary *info);


typedef NS_ENUM(NSInteger, FTCoreTextAlignement)  {
    FTCoreTextAlignementLeft = 0,
	FTCoreTextAlignementRight = 1,
	FTCoreTextAlignementCenter = 2,
	FTCoreTextAlignementJustified = 3,
	FTCoreTextAlignementNatural = 4
};


@interface FTCoreTextStyle : NSObject <NSCopying>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *appendedCharacter;
@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *color;
@property (nonatomic, getter=isUnderLined) BOOL underlined;
@property (nonatomic) FTCoreTextAlignement textAlignment;
@property (nonatomic) UIEdgeInsets paragraphInset;
@property (nonatomic) CGFloat leading;
@property (nonatomic) CGFloat maxLineHeight;
@property (nonatomic) CGFloat minLineHeight;

// For bullet styles only
@property (nonatomic) NSString *bulletCharacter;
@property (nonatomic) UIFont *bulletFont;
@property (nonatomic) UIColor *bulletColor;

// Called when the style is parsed for extra actions
@property (nonatomic, copy) FTCoreTextCallbackBlock block;

// If NO, the paragraph styling of the enclosing style is used. Default is YES.
@property (nonatomic, assign) BOOL applyParagraphStyling;

+ (id)styleWithName:(NSString *)name;


@end
