//
//  UIView+Layout.h
//
//  Created by Ondrej Rafaj on 21/12/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define UIViewAutoresizingFlexibleAllMargins                    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin

#define UIViewAutoresizingFlexibleVerticalMargins               UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin

#define UIViewAutoresizingFlexibleHorizontalMargins             UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin

@interface UIView (Layout)

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)xOrigin;
- (void)setXOrigin:(CGFloat)xOrigin;

- (CGFloat)yOrigin;
- (void)setYOrigin:(CGFloat)yOrigin;

- (void)moveXOriginBy:(CGFloat)value;
- (void)moveYOriginBy:(CGFloat)value;

- (void)changeWidthBy:(CGFloat)value;
- (void)changeHeightBy:(CGFloat)value;

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;
- (void)positionAtX:(CGFloat)xOrigin andY:(CGFloat)yOrigin;

- (CGSize)size;
- (void)setSize:(CGSize)size;
- (void)setWidth:(CGFloat)width andHeight:(CGFloat)height;

- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGFloat)right;
- (void)setRight:(CGFloat)right;

// Returns the center of the view in the view's coordinates system
- (CGPoint)boundsCenter;

- (void)setCenterIntegral:(CGPoint)center;

// Set the anchorPoint without moving the view
- (void)setAnchorPoint:(CGPoint)anchorPoint;
- (CGPoint)anchorPoint;

// Superview related
- (void)centerInSuperview;
- (void)centerVertically;
- (void)centerHorizontally;

- (void)makeMarginInSuperViewWithTopMargin:(CGFloat)topMargin leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin andBottomMargin:(CGFloat)bottomMargin;
- (void)makeMarginInSuperViewWithTopMargin:(CGFloat)topMargin andSideMargin:(CGFloat)sideMargin;
- (void)makeMarginInSuperView:(CGFloat)margin;
- (CGFloat)bottomMargin;
- (void)setBottomMargin:(CGFloat)bottomMargin;
- (CGFloat)rightMargin;
- (void)setRightMargin:(CGFloat)rightMargin;

// Autoresizing
- (void)setAutoresizingNone;
- (void)setAutoresizingBottomLeft;
- (void)setAutoresizingBottomRight;
- (void)setAutoresizingTopLeft;
- (void)setAutoresizingTopRight;
- (void)setAutoresizingTopCenter;
- (void)setAutoresizingCenter;
- (void)setAutoresizingCenterLeft;
- (void)setAutoresizingCenterRight;
- (void)setAutoresizingBottomCenter;
- (void)setAutoresizingWidth;
- (void)setAutoresizingHeight;
- (void)setAutoresizingWidthAndHeight;


@end
