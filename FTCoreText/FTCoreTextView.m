//
//  CPCoreTextView.m
//  FTLibrary
//
//  Created by Francesco Freezone <cescofry@gmail.com> on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTCoreTextView.h"
#import <QuartzCore/QuartzCore.h>
#import <regex.h>

@interface FTCoreTextView ()

- (void)updateFramesetterIfNeeded;
- (void)processText;

@end

@implementation FTCoreTextView

@synthesize text = _text;
@synthesize styles = _styles;
@synthesize markers = _markers;
@synthesize defaultStyle = _defaultStyle;
@synthesize processedString = _processedString;
@synthesize path = _path;
@synthesize context = _context;
@synthesize uRLs = _URLs;
@synthesize images = _images;
@synthesize delegate = _delegate;



- (NSDictionary *)dataForPoint:(CGPoint)point {
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
    
    
    float inverter = [self suggestedSizeConstrainedToSize:self.frame.size].height;

    CTFrameRef ctframe = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), mainPath, NULL);
    
    CGPathRelease(mainPath);
    
    NSString *strippedString = [FTCoreTextView stripTagsforString:self.text];
    
    CFArrayRef lines = CTFrameGetLines(ctframe);
    CFIndex lineCount = CFArrayGetCount(lines);
    CGPoint origins[lineCount];
    
    if (lineCount == 0) return nil;
    
    CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), origins);
    
    inverter = origins[0].y;
    
    for(CFIndex idx = 0; idx < lineCount; idx++)
    {
        CTLineRef line = CFArrayGetValueAtIndex(lines, idx);
        CGRect lineBounds = CTLineGetImageBounds(line, self.context);
        if (CGRectIsEmpty(lineBounds)) continue;
        lineBounds.origin.y = ( inverter - origins[idx].y);
        
        if (CGRectContainsPoint(lineBounds, point)) {
            
            for (id runObj in (NSArray *)CTLineGetGlyphRuns(line)) {
                CTRunRef run = (CTRunRef)runObj;
                CGRect runBounds = CTRunGetImageBounds(run, self.context, CFRangeMake(0, 0));
                runBounds.origin.y = ( inverter - origins[idx].y);
                
                CFRange cfrange = CTRunGetStringRange(run);
                NSRange range = NSMakeRange(cfrange.location, cfrange.length);
                NSString *selectedText = [strippedString substringWithRange:range];
                
                if (CGRectContainsPoint(runBounds, point)) {
                    NSURL *url = [self.uRLs objectForKey:[NSNumber numberWithInt:range.location]];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:selectedText forKey:@"text"];
                    [dict setObject:[NSValue valueWithCGRect:lineBounds] forKey:@"frame"];
                    if (url) [dict setObject:url forKey:@"url"];
                    
                    /*
                     UILabel *lbl = [[UILabel alloc] initWithFrame:lineBounds];
                     [lbl setText:selectedText];
                     [lbl setFont:[UIFont systemFontOfSize:14]];
                     [lbl setBackgroundColor:[UIColor redColor]];
                     [self addSubview:lbl];
                     [lbl release];
                     */
                    
                    return dict;
                }
                
            }
 

        }

    }
    
    return nil;
}

- (void)updateFramesetterIfNeeded
{
    if (_changesMade) {
		_changesMade = NO;
		[self processText];
		
		if (!_processedString || [_processedString length] == 0) {
			if (_framesetter) {
				CFRelease(_framesetter);
				_framesetter = NULL;
			}
			return;
		}
		
		if (!_defaultStyle.name || [_defaultStyle.name length] == 0) {
			_defaultStyle.name = @"_default";
			_defaultStyle.font = [UIFont systemFontOfSize:14];
			_defaultStyle.color= [UIColor blackColor];
			NSLog(@"FTCoreTextView: _default style not found!");
		}
		
		NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_processedString];
		
		//set default attributeds
		
		NSRange stringRange = NSMakeRange(0, [_text length]);
		
		[string addAttribute:(id)kCTForegroundColorAttributeName
					   value:(id)_defaultStyle.color.CGColor
					   range:stringRange];
		
		CTFontRef ctFont = CTFontCreateWithName((CFStringRef)_defaultStyle.font.fontName, 
												_defaultStyle.font.pointSize, 
												NULL);
		
		[string addAttribute:(id)kCTFontAttributeName
					   value:(id)ctFont
					   range:stringRange];
		CFRelease(ctFont);

		CTTextAlignment alignment = (_defaultStyle.alignment)? _defaultStyle.alignment : kCTLeftTextAlignment;
		CGFloat maxLineHeight = _defaultStyle.maxLineHeight;
		CGFloat paragraphSpaceBefore = _defaultStyle.spaceBetweenParagraphs;
		
		CTParagraphStyleSetting settings[] = {
			{kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
			{kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight},
			{kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpaceBefore}
		};
		CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 3);
		[string addAttribute:(id)kCTParagraphStyleAttributeName
					   value:(id)paragraphStyle 
					   range:stringRange];
		CFRelease(paragraphStyle);

		
		//set markers attributes
		for (NSDictionary *dict in _markers) {
			NSRange aRange = [(NSValue *)[dict objectForKey:@"range"] rangeValue];
			FTCoreTextStyle *style = [dict objectForKey:@"style"];
			if ((aRange.location + aRange.length) > [_text length] ) continue;
			
			[string addAttribute:(id)kCTForegroundColorAttributeName
						   value:(id)style.color.CGColor
						   range:aRange];
            
			CTFontRef setCTFont = CTFontCreateWithName((CFStringRef)style.font.fontName, 
										  style.font.pointSize, 
										  NULL);
			
			[string addAttribute:(id)kCTFontAttributeName
						   value:(id)setCTFont
						   range:aRange];
            CFRelease(setCTFont);
            
            CTTextAlignment alignment = (style.alignment)? style.alignment : kCTLeftTextAlignment;
            CGFloat maxLineHeight = style.maxLineHeight;
			CGFloat paragraphSpaceBefore = style.spaceBetweenParagraphs;
			
            CTParagraphStyleSetting settings[] = {
                {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
				{kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight},
				{kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpaceBefore}
            };
            CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 3);
            [string addAttribute:(id)kCTParagraphStyleAttributeName
                           value:(id)paragraphStyle 
                           range:aRange];
			CFRelease(paragraphStyle);
            
		}
		// layout master 
		if (_framesetter != NULL) CFRelease(_framesetter);
		_framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
		[string release];
        
    }
}

/*!
 * @abstract get the supposed size of the drawn text
 *
 */

- (CGSize)suggestedSizeConstrainedToSize:(CGSize)size
{
	[self updateFramesetterIfNeeded];
	if (_framesetter == NULL) {
		return CGSizeZero;
	}
	CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(_framesetter, CFRangeMake(0, 0), NULL, size, NULL);
	suggestedSize = CGSizeMake(ceilf(suggestedSize.width), ceilf(suggestedSize.height));
    return suggestedSize;
}


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
	if (_defaultStyle == nil) {
		_defaultStyle = [FTCoreTextStyle new];
	}
    
    NSString *regEx = @"<[_a-zA-Z0-9]*( /){0,1}>";
    
    [self.uRLs removeAllObjects];
    [self.images removeAllObjects];
       
    while (YES) {
        int length;
        NSRange rangeStart;
        NSRange rangeActive;
        FTCoreTextStyle *style = nil;
        
        
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
        
        BOOL isURL = ([key isEqualToString:@"_link"]);
        if (isURL) {
            //replace active string with url text
            NSRange closeTagRange = [_processedString rangeOfString:[NSString stringWithFormat:@"</%@>", key]];
            NSRange urlRange = NSMakeRange((rangeStart.location + rangeStart.length), (closeTagRange.location - (rangeStart.location + rangeStart.length)));
            NSString *allUrlString = [_processedString substringWithRange:urlRange];
            NSRange pipeRange = [allUrlString rangeOfString:@"|"];
            NSString *urlString;
            NSString *replacementString;
            if (pipeRange.location != NSNotFound) {
                urlString = [allUrlString substringWithRange:NSMakeRange(0, pipeRange.location)];
                replacementString = [allUrlString stringByReplacingCharactersInRange:NSMakeRange(0, (pipeRange.location + 1)) withString:@""];
            }
            
            
            [_processedString replaceCharactersInRange:urlRange withString:replacementString];
            NSURL *url = [NSURL URLWithString:urlString];
            [self.uRLs setObject:url forKey:[NSNumber numberWithInt:rangeStart.location]];
            
        }
        
        
        BOOL isImage = ([key isEqualToString:@"_image"]);
        if (isImage) {
            //replace active string with emptySpace
            NSRange closeTagRange = [_processedString rangeOfString:[NSString stringWithFormat:@"</%@>", key]];
            NSRange imageRange = NSMakeRange((rangeStart.location + rangeStart.length), (closeTagRange.location - (rangeStart.location + rangeStart.length)));
            NSString *imageString = [_processedString substringWithRange:imageRange];
            UIImage *img = [UIImage imageNamed:imageString];

            if (img) {
                int skipLine = floorf(img.size.height / style.font.lineHeight);
                NSMutableString *lines = [NSMutableString string];
                for (int i = 0; i < skipLine; i++) {
                    [lines appendFormat:@"\n"];
                }
                
                [_processedString replaceCharactersInRange:imageRange withString:lines];
                [self.images setObject:img forKey:[NSNumber numberWithInt:rangeStart.location]];
            }
 
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



- (void)drawImages {
    
    
    
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
    
    float inverter = [self suggestedSizeConstrainedToSize:self.frame.size].height;
    
    CTFrameRef ctframe = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), mainPath, NULL);
    
    CGPathRelease(mainPath);

    
    CFArrayRef lines = CTFrameGetLines(ctframe);
    CFIndex lineCount = CFArrayGetCount(lines);
    CGPoint origins[lineCount];
    
    CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), origins);
    
    inverter = origins[0].y;
    NSArray *keys = [self.images allKeys];
    
    for(CFIndex idx = 0; idx < lineCount; idx++)
    {
        CTLineRef line = CFArrayGetValueAtIndex(lines, idx);
        CGRect lineBounds = CTLineGetImageBounds(line, self.context);
        lineBounds.origin.y = ( inverter - origins[idx].y);
        
        CFRange cfrange = CTLineGetStringRange(line);
        NSNumber *checkKey = [NSNumber numberWithInt:(cfrange.location - 1)];
        
        
        if ([keys containsObject:checkKey]) {
            
            CTTextAlignment alignment = [(FTCoreTextStyle *)[self.styles objectForKey:@"_image"] alignment];
            
            UIImage *img = [self.images objectForKey:checkKey];
            if (img) {
                int x = 0;
                if (alignment == kCTRightTextAlignment) x = (self.frame.size.width - img.size.width);
                if (alignment == kCTCenterTextAlignment) x = ((self.frame.size.width - img.size.width) / 2);
                
                CGRect frame = CGRectMake(x, lineBounds.origin.y, img.size.width, img.size.height);
                [img drawInRect:frame];

            }
        }
        
    }

}

/*!
 * @abstract Remove all the tags and return a clean text to be used in case Core Text is not supported (iOS 4.0 on)
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
	[instance release];
    return (NSArray *)result;
}


#pragma mark Initialization

- (void)doInit {
	// Initialization code
	_framesetter = NULL;
	_text = [[NSString alloc] init];
	_markers = [[NSMutableArray alloc] init];
	_processedString = [[NSMutableString alloc] init];
	_styles = [[NSMutableDictionary alloc] init];
	_URLs = [[NSMutableDictionary alloc] init];
    _images = [[NSMutableDictionary alloc] init];
	[self setBackgroundColor:[UIColor clearColor]];
	self.contentMode = UIViewContentModeRedraw;
	[self setUserInteractionEnabled:YES];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

#pragma mark Draw rect

/*!
 * @abstract draw the actual coretext on the context
 *
 */

- (void)drawRect:(CGRect)rect
{
	[self updateFramesetterIfNeeded];
	
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
    

    
	CTFrameRef drawFrame = CTFramesetterCreateFrame(_framesetter, 
                                                    CFRangeMake(0, 0),
                                                    mainPath, NULL);
    
    // flip coordinate system
    _context = UIGraphicsGetCurrentContext();
    CGContextClearRect(self.context, self.frame);
    
    //draw images
    [self drawImages];
    
    
	CGContextSetTextMatrix(self.context, CGAffineTransformIdentity);
	CGContextTranslateCTM(self.context, 0, self.bounds.size.height);
	CGContextScaleCTM(self.context, 1.0, -1.0);
	// draw
	CTFrameDraw(drawFrame, self.context);
    CGContextSaveGState(self.context);

	// cleanup
	CFRelease(drawFrame);
	CGPathRelease(mainPath);

}



#pragma mark --
#pragma mark custom setters

- (void)setText:(NSString *)text {
    [_text release];
    _text = [[text mutableCopy] retain];
	_changesMade = YES;
    if ([self superview]) [self setNeedsDisplay];
}

- (void)addStyle:(FTCoreTextStyle *)style {
    [self.styles setValue:style forKey:style.name];
	_changesMade = YES;
    if ([self superview]) [self setNeedsDisplay];
}

- (void)addStyles:(NSArray *)styles
{
	for (FTCoreTextStyle *style in styles) {
		[self.styles setValue:style forKey:style.name];
	}
	_changesMade = YES;
    if ([self superview]) [self setNeedsDisplay];
}

- (void)setStyles:(NSMutableDictionary *)styles {
    [_styles release];
    _styles = [[NSMutableDictionary dictionaryWithDictionary:styles] retain];
	_changesMade = YES;
    if ([self superview]) [self setNeedsDisplay];
}

- (void)setPath:(CGPathRef)path {
    _path = CGPathRetain(path);
	_changesMade = YES;
    if ([self superview]) [self setNeedsDisplay];
}

- (void)dealloc
{
	if (_framesetter) CFRelease(_framesetter);
    [_text release];
    [_styles release];
    [_markers release];
    [_processedString release];
	[_defaultStyle release];
    [_URLs release], _URLs = nil;
    [_images release], _images = nil;
    _delegate = nil;
    [super dealloc];
}

#pragma mark touches

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [(UITouch *)[touches anyObject] locationInView:self];
    NSDictionary *data = [self dataForPoint:point];
    
    if (data && self.delegate && [self.delegate respondsToSelector:@selector(touchedData:inCoreTextView:)]) {
        [self.delegate touchedData:data inCoreTextView:self];
    }
}

@end
