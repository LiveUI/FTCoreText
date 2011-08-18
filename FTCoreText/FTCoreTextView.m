//
//  CPCoreTextView.m
//  FTLibrary
//
//  Created by Francesco on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTCoreTextView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import <regex.h>


@implementation FTCoreTextView

@synthesize text = _text;
@synthesize styles = _styles;
@synthesize markers = _markers;
@synthesize defaultStyle = _defaultStyle;
@synthesize processedString = _processedString;
@synthesize path = _path;

/*!
 * @abstract divide the text in different pages according to the tags <_page/> found
 *
 */

- (NSMutableArray *)divideTextInPages:(NSString *)string {
    NSMutableArray *result = [NSMutableArray array];
    int prevStart = 0;
    while (YES) {
        NSRange rangeStart = [string rangeOfString:@"<_page/>"];
        if (rangeStart.location != NSNotFound) {
            NSString *page = [string substringWithRange:NSMakeRange(prevStart, rangeStart.location)];
            [result addObject:page];
            string = [string stringByReplacingCharactersInRange:rangeStart withString:@""];
            prevStart = rangeStart.location;
        }
        else {
            NSString *page = [string substringWithRange:NSMakeRange(prevStart, (string.length - prevStart))];
            [result addObject:page];
            break;
        }
    }
    return result;
}

/*!
 * @abstract process the text before drawing.
 *
 */

- (void)processText {
    
    if (!_text || [_text length] == 0) return;
    _processedString = (NSMutableString *)_text;
    FTCoreTextStyle *style = [self.styles objectForKey:@"_default"];
    self.defaultStyle = style;
    
    NSString *regEx = @"<[a-zA-Z0-9]*( /){0,1}>";
       
    while (YES) {
        int length;
        NSRange rangeStart;
        NSRange rangeActive;
        FTCoreTextStyle *style;
        
        
        rangeStart = [_processedString rangeOfString:regEx options:NSRegularExpressionSearch];
        if (rangeStart.location == NSNotFound) return;
        NSString *key = [_processedString substringWithRange:NSMakeRange(rangeStart.location + 1, rangeStart.length - 2)];
       
        NSString *autoCloseKey = [key stringByReplacingOccurrencesOfString:@" /" withString:@""];
        BOOL isAutoClose = (![key isEqualToString:autoCloseKey]);
        
        style = [self.styles objectForKey:(isAutoClose)? autoCloseKey : key];

        
        NSString *append = @"";
        if (style != nil && style.appendedCharacter) {
            append = style.appendedCharacter;
        }
        
        if (isAutoClose) {
            [_processedString replaceCharactersInRange:rangeStart withString:append];
            rangeActive = NSMakeRange(rangeStart.location, [append length]);
        }
        else {
            [_processedString replaceCharactersInRange:rangeStart withString:@""];
            NSRange rangeEnd = [_processedString rangeOfString:[NSString stringWithFormat:@"</%@>", key]];
            [_processedString replaceCharactersInRange:rangeEnd withString:append];
            
            length = rangeEnd.location - rangeStart.location;
            rangeActive = NSMakeRange(rangeStart.location, length);
            
        }
        
        if (style == nil) {
            NSLog(@"Definition of style [%@] not found!", key);
            continue;
        }
        else {
            NSValue *rangeValue = [NSValue valueWithRange:rangeActive];
            NSDictionary *dict = [NSDictionary 
                                  dictionaryWithObjects:[NSArray arrayWithObjects:rangeValue, style, nil]                                                     
                                  forKeys:[NSArray arrayWithObjects:@"range", @"style", nil]];
            rangeValue = nil;
            [_markers addObject:dict];            
        }
    }
    
}

/*!
 * @abstract strip the text from all tags. Can be used to havea clear text for devices that do not support CoreText (iPhone >= 4.0 iPad >= 3.2)
 *
 */

+ (NSString *)stripTagsforString:(NSString *)string {
    FTCoreTextView *instance = [[FTCoreTextView alloc] initWithFrame:CGRectZero];
    [instance setText:string];
    [instance processText];
    NSString *result = [NSString stringWithString:instance.processedString];
    [instance release];
    return result;
}

/*!
 * @abstract divide the text in different pages according to the tags <_page/> found
 *
 */

+ (NSArray *)pagesFromText:(NSString *)string {
    FTCoreTextView *instance = [[FTCoreTextView alloc] initWithFrame:CGRectZero];
    NSArray *result = [instance divideTextInPages:string];
    return (NSArray *)result;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _text = [[NSString alloc] init];
        _markers = [[NSMutableArray alloc] init];
        _processedString = [[NSMutableString alloc] init];
        _styles = [[NSMutableDictionary alloc] init];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


/*!
 * @abstract draw the actual coretext on the context
 *
 */

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [self processText];
    
    if (!_processedString || [_processedString length] == 0) return;
    
    
    if (!_defaultStyle.name || [_defaultStyle.name length] == 0) {
        _defaultStyle.name = @"_default";
        _defaultStyle.font = [UIFont systemFontOfSize:14];
        _defaultStyle.color= [UIColor blackColor];
        NSLog(@"FTCoreTextView: _default style not found!");
    }
    
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_processedString];
    
    //set default attributeds
    
	[string addAttribute:(id)kCTForegroundColorAttributeName
                   value:(id)_defaultStyle.color.CGColor
                   range:NSMakeRange(0, [_text length])];
    
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)_defaultStyle.font.fontName, 
                                            _defaultStyle.font.pointSize, 
                                            NULL);
    
    [string addAttribute:(id)kCTFontAttributeName
                   value:(id)ctFont
                   range:NSMakeRange(0, [_text length])];
    
    
    
    //set markers attributes
    
    for (NSDictionary *dict in _markers) {
        NSRange aRange = [(NSValue *)[dict objectForKey:@"range"] rangeValue];
        FTCoreTextStyle *style = [dict objectForKey:@"style"];
        if ((aRange.location + aRange.length) > [_text length] ) continue;
        
        
        
        [string addAttribute:(id)kCTForegroundColorAttributeName
                       value:(id)style.color.CGColor
                       range:aRange];
        ctFont = nil;
        ctFont = CTFontCreateWithName((CFStringRef)style.font.fontName, 
                                                style.font.pointSize, 
                                                NULL);
        
        [string addAttribute:(id)kCTFontAttributeName
                       value:(id)ctFont
                       range:aRange];
        
        
        
    }
    
    CFRelease(ctFont);
    
    
	// layout master
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    
    
	// left column form
	CGMutablePathRef mainPath = CGPathCreateMutable();
   	
    if (!_path) {
        CGPathAddRect(mainPath, NULL, 
                      CGRectMake(0, 0, 
                                 self.bounds.size.width,
                                 self.bounds.size.height));  
    }
    else {
        CGPathAddPath(mainPath, NULL, _path);
    }
    

    
	// left column frame
	CTFrameRef drawFrame = CTFramesetterCreateFrame(framesetter, 
                                                    CFRangeMake(0, 0),
                                                    mainPath, NULL);
    
    // flip the coordinate system
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
    
	// draw
	CTFrameDraw(drawFrame, context);
    
    
    
	// cleanup
	CFRelease(drawFrame);
	CGPathRelease(mainPath);
	CFRelease(framesetter);
	[string release];
}

#pragma mark --
#pragma mark custom setters

- (void)setText:(NSString *)text {
    [_text release];
    _text = [[text mutableCopy] retain];
    [self setNeedsDisplay];
}

- (void)addStyle:(FTCoreTextStyle *)style {
    [self.styles setValue:style forKey:style.name];
    [self setNeedsDisplay];
}

- (void)setStyles:(NSMutableDictionary *)styles {
    [_styles release];
    _styles = [[NSMutableDictionary dictionaryWithDictionary:styles] retain];
    [self setNeedsDisplay];
}

- (void)setPath:(CGPathRef)path {
    _path = path;
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [_text release];
    [_styles release];
    [_markers release];
    [_processedString release];
    [super dealloc];
}

@end
