//
//  CPCoreTextView.h
//  FTLibrary
//
//  Created by Francesco on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

//     Special markers:
//     _default: It is the default applyed to the whole text. MArkups is not needed on the text
//     <_page/>: Will divide the text in different pages
 

#import <UIKit/UIKit.h>
#import "FTCoreTextStyle.h"


@interface FTCoreTextView : UIView {
    NSString *_text;
    NSMutableDictionary *_styles;
    @private
    NSMutableArray *_markers;
    FTCoreTextStyle *_defaultStyle;
    NSMutableString *_processedString;
    CGPathRef _path;
    
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

@end
