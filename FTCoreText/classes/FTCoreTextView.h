//
//  FTCoreTextView.h
//  FTCoreText
//
//  Created by Francesco Freezone <cescofry@gmail.com> on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

/*
 * The source text has to contain every new line sequence '\n' required.
 *
 * If you don't provide an attributed string when initializing the view, the -text property is parsed
 * to create the attributed string that will be drawn. You can cache the -attributedString property
 * (as long as you've set the -text property) for a later reuse therefore avoiding to parse again
 * the source text.
 *
 * If the -text property is nil though, adding new FTCoreTextStyles styles will have no effect.
 *
 */

#import <UIKit/UIKit.h>
#import "FTCoreTextStyle.h"

/* These constants are default tag names recognised by FTCoreTextView */

extern NSString * const FTCoreTextTagDefault;	//It is the default applied to the whole text. Markups is not needed on the source text
extern NSString * const FTCoreTextTagImage;		//Define style for images. Respond to markup <_image>imageNameInMainBundle.extension</_image> in the source text.
extern NSString * const FTCoreTextTagBullet;	//Define styles for bullets. Respond to markup <_bullet>Content indented with a bullet</_bullet>
extern NSString * const FTCoreTextTagPage;		//Divide the text in pages. Respond to markup <_page/>
extern NSString * const FTCoreTextTagLink;		//Define style for links. Respond to markup <_link>link URL|link replacement name</_link>

/* These constants are used in the dictionary argument of the delegate method -coreTextView:receivedTouchOnData: */

extern NSString * const FTCoreTextDataURL;
extern NSString * const FTCoreTextDataName;
extern NSString * const FTCoreTextDataFrame;
extern NSString * const FTCoreTextDataAttributes;

@protocol FTCoreTextViewDelegate;

@interface FTCoreTextView : UIView {
	
	NSMutableDictionary *_styles;
	NSMutableDictionary *_defaultsTags;
	struct {
        unsigned int textChangesMade:1;
        unsigned int updatedAttrString:1;
        unsigned int updatedFramesetter:1;
	} _coreTextViewFlags;
}

@property (nonatomic, retain) NSString				*text;
@property (nonatomic, retain) NSString				*processedString;
@property (nonatomic, readonly) NSAttributedString	*attributedString;
@property (nonatomic, assign) CGPathRef				path;
@property (nonatomic, retain) NSMutableDictionary	*URLs;
@property (nonatomic, retain) NSMutableArray		*images;
@property (nonatomic, assign) id <FTCoreTextViewDelegate> delegate;
//shadow is not yet part of a style. It's applied on the whole view	
@property (nonatomic, retain) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;

/* Using this method, you then have to set the -text property to get any result */
- (id)initWithFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame andAttributedString:(NSAttributedString *)attributedString;

/* Using one of the FTCoreTextTag constants defined you can change a default tag to a new one.
 * Example: you can call [coretTextView changeDefaultTag:FTCoreTextTagBullet toTag:@"li"] to
 * make the view regonize <li>...</li> tags as bullet points */
- (void)changeDefaultTag:(NSString *)coreTextTag toTag:(NSString *)newDefaultTag;

- (void)setStyles:(NSDictionary *)styles __deprecated;

- (void)addStyle:(FTCoreTextStyle *)style;
- (void)addStyles:(NSArray *)styles;

- (void)removeAllStyles;

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