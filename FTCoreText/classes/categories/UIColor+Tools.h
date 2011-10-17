//
//  UIColor+Tools.h
//  IGFrameworkProject
//
//  Created by Ondrej Rafaj on 7.6.10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIColor (Tools)

+ (UIColor *)colorWithRealRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (UIColor *)colorWithRealRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)randomColor;

+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;


@end
