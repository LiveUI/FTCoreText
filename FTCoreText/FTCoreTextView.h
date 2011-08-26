//
//  CPCoreTextView.h
//  FTLibrary
//
//  Created by Francesco Freezone <cescofry@gmail.com> on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

//     Special markers:
//     _default: It is the default applyed to the whole text. MArkups is not needed on the text
//     _bullet: define styles for bullets. Respond to Markups <bullets />
 

#import <UIKit/UIKit.h>
#import "FTCoreTextStyle.h"
#import <CoreText/CoreText.h>

@interface FTCoreTextView : UIView {
    NSString *_text;
    NSMutableDictionary *_styles;
    @private
    NSMutableArray		*_markers;
    FTCoreTextStyle		*_defaultStyle;
    NSMutableString		*_processedString;
    CGPathRef			_path;
    CTFramesetterRef	_framesetter;
	BOOL				_changesMade;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSMutableDictionary *styles;
@property (nonatomic, retain) NSMutableArray *markers;
@property (nonatomic, assign) FTCoreTextStyle *defaultStyle;
@property (nonatomic, retain) NSMutableString *processedString;
@property (nonatomic, assign) CGPathRef path;

- (id)initWithFrame:(CGRect)frame;
- (void)addStyle:(FTCoreTextStyle *)style;
+ (NSString *)stripTagsforString:(NSString *)string;
+ (NSArray *)pagesFromText:(NSString *)string;

- (CGSize)suggestedSizeConstrainedToSize:(CGSize)size;

@end
