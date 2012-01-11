//
//  FTCoreTextStyle.h
//  FTCoreText
//
//  Created by Francesco Freezone <cescofry@gmail.com> on 20/07/2011.
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

enum
{
	FTCoreTextAlignementLeft = 0,
	FTCoreTextAlignementRight = 1,
	FTCoreTextAlignementCenter = 2,
	FTCoreTextAlignementJustified = 3,
	FTCoreTextAlignementNatural = 4
};
typedef uint8_t FTCoreTextAlignement;

@interface FTCoreTextStyle : NSObject <NSCopying>

@property (nonatomic, retain) NSString			*name;
@property (nonatomic, retain) NSString			*appendedCharacter;
@property (nonatomic, retain) UIFont			*font;
@property (nonatomic, retain) UIColor			*color;
@property (nonatomic, assign, getter=isUnderLined) BOOL underlined;
@property (nonatomic, assign) FTCoreTextAlignement textAlignment;
@property (nonatomic, assign) UIEdgeInsets		paragraphInset;
@property (nonatomic, assign) CGFloat			leading;
@property (nonatomic, assign) CGFloat			maxLineHeight;
@property (nonatomic, assign) CGFloat			minLineHeight;
//for bullet styles only
@property (nonatomic, retain) NSString			*bulletCharacter;
@property (nonatomic, retain) UIFont			*bulletFont;
@property (nonatomic, retain) UIColor			*bulletColor;

//if NO, the paragraph styling of the enclosing style is used. Default is YES.
@property (nonatomic, assign) BOOL applyParagraphStyling;

//deprecated
@property (nonatomic, assign) __deprecated CGFloat spaceBetweenParagraphs;

+ (id)styleWithName:(NSString *)name;

@end
