//
//  FTCoreTextView.h
//  FTCoreText
//
//  Created by Francesco Freezone <cescofry@gmail.com> on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

//     Special markers:
//     _default: It is the default applied to the whole text. Markups is not needed on the text
//     _page: Divide the text in pages. Respond to markup <_page/>
//     _bullet: define styles for bullets.
//     _image: define style for images. Respond to markup <_image>imageNameOnBundle.extension</_image>
//     _link: define style for links. Respond to markup <_link>link_target|link name</_link>

/*
 The source text has to contain every new line sequence '\n' required.
 */

#import <UIKit/UIKit.h>
#import "FTCoreTextStyle.h"

extern NSString * const FTCoreTextTagDefault;
extern NSString * const FTCoreTextTagImage;
extern NSString * const FTCoreTextTagBullet;
extern NSString * const FTCoreTextTagPage;
extern NSString * const FTCoreTextTagLink;

extern NSString * const FTCoreTextDataURL;

@protocol FTCoreTextViewDelegate;
@interface FTCoreTextView : UIView {
	
	NSMutableDictionary *_styles;
	BOOL				_changesMade;
}

@property (nonatomic, retain) NSString				*text;
@property (nonatomic, retain) NSString				*processedString;
@property (nonatomic, assign) CGPathRef				path;
@property (nonatomic, retain) NSMutableDictionary	*URLs;
@property (nonatomic, retain) NSMutableArray		*images;
@property (nonatomic, assign) id <FTCoreTextViewDelegate> delegate;
//shadow is not yet part of a style. It's applied on the whole view	
@property (nonatomic, retain) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;

- (id)initWithFrame:(CGRect)frame;

- (void)setStyles:(NSDictionary *)styles __deprecated;

- (void)addStyle:(FTCoreTextStyle *)style;
- (void)addStyles:(NSArray *)styles;

- (NSArray *)stylesArray __deprecated;
- (NSArray *)styles;

+ (NSString *)stripTagsForString:(NSString *)string;
+ (NSArray *)pagesFromText:(NSString *)string;

- (CGSize)suggestedSizeConstrainedToSize:(CGSize)size;
- (void)fitToSuggestedHeight;

@end

@protocol FTCoreTextViewDelegate <NSObject>
@optional
- (void)touchedData:(NSDictionary *)data inCoreTextView:(FTCoreTextView *)textView __deprecated;
- (void)coreTextView:(FTCoreTextView *)coreTextView receivedTouchOnData:(NSDictionary *)data;
@end

@interface NSString (FTCoreText)
//for a given 'string' and 'tag' return '<tag>string</tag>'
- (NSString *)stringByAppendingTagName:(NSString *)tagName;
@end