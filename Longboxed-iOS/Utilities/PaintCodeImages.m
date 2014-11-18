//
//  PaintCodeImages.m
//  Longboxed-iOS
//
//  Created by Jay Hickey on 11/17/14.
//  Copyright (c) 2014 Jay Hickey. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//

#import "PaintCodeImages.h"


@implementation PaintCodeImages

#pragma mark Initialization

+ (void)initialize
{
}

#pragma mark Drawing Methods

+ (void)drawPlusWithColor: (UIColor*)color width: (CGFloat)width;
{

    //// Frames
    CGRect frame = CGRectMake(0, 0, width, width);


    //// Shape Drawing
    UIBezierPath* shapePath = UIBezierPath.bezierPath;
    [shapePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 1.00000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47883 * CGRectGetHeight(frame))];
    [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.52117 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47883 * CGRectGetHeight(frame))];
    [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.52117 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.00000 * CGRectGetHeight(frame))];
    [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48208 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.00000 * CGRectGetHeight(frame))];
    [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48208 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47883 * CGRectGetHeight(frame))];
    [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.00000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47883 * CGRectGetHeight(frame))];
    [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.00000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52117 * CGRectGetHeight(frame))];
    [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48208 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52117 * CGRectGetHeight(frame))];
    [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48208 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 1.00000 * CGRectGetHeight(frame))];
    [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.52117 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 1.00000 * CGRectGetHeight(frame))];
    [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.52117 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52117 * CGRectGetHeight(frame))];
    [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 1.00000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52117 * CGRectGetHeight(frame))];
    [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 1.00000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47883 * CGRectGetHeight(frame))];
    [shapePath closePath];
    shapePath.miterLimit = 4;

    shapePath.usesEvenOddFillRule = YES;

    [color setFill];
    [shapePath fill];
}

+ (void)drawArrowWithColor: (UIColor*)color width: (CGFloat)width;
{

    //// Frames
    CGRect frame = CGRectMake(0, 0, width, 28);

    //// Subframes
    CGRect page = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.01144 - 0.07) + 0.57, CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.03410 - 0.22) + 0.72, floor(CGRectGetWidth(frame) * 0.98675 + 0.16) - floor(CGRectGetWidth(frame) * 0.01144 - 0.07) - 0.23, floor(CGRectGetHeight(frame) * 0.90272 + 0.45) - floor(CGRectGetHeight(frame) * 0.03410 - 0.22) - 0.68);


    //// Page-
    {
        //// Rectangle- Drawing
        UIBezierPath* rectanglePath = UIBezierPath.bezierPath;
        [rectanglePath moveToPoint: CGPointMake(CGRectGetMinX(page) + 0.04331 * CGRectGetWidth(page), CGRectGetMinY(page) + 1.00000 * CGRectGetHeight(page))];
        [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(page) + 0.00000 * CGRectGetWidth(page), CGRectGetMinY(page) + 0.92029 * CGRectGetHeight(page))];
        [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(page) + 0.50000 * CGRectGetWidth(page), CGRectGetMinY(page) + 0.00000 * CGRectGetHeight(page))];
        [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(page) + 1.00000 * CGRectGetWidth(page), CGRectGetMinY(page) + 0.92029 * CGRectGetHeight(page))];
        [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(page) + 0.95770 * CGRectGetWidth(page), CGRectGetMinY(page) + 0.99814 * CGRectGetHeight(page))];
        [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(page) + 0.50101 * CGRectGetWidth(page), CGRectGetMinY(page) + 0.15756 * CGRectGetHeight(page))];
        [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(page) + 0.04331 * CGRectGetWidth(page), CGRectGetMinY(page) + 1.00000 * CGRectGetHeight(page))];
        [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(page) + 0.04331 * CGRectGetWidth(page), CGRectGetMinY(page) + 1.00000 * CGRectGetHeight(page))];
        [rectanglePath closePath];
        rectanglePath.miterLimit = 4;

        rectanglePath.usesEvenOddFillRule = YES;

        [color setFill];
        [rectanglePath fill];
    }
}

+ (void)drawLongboxedLogoWithColor: (UIColor*)color width: (CGFloat)width;
{

    //// Frames
    CGRect frame = CGRectMake(1, 1, width, width);

    //// Subframes
    CGRect group4 = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.01800 - 0.4) + 0.9, CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.01120 + 0.46) + 0.04, floor(CGRectGetWidth(frame) * 0.98957 + 0.02) - floor(CGRectGetWidth(frame) * 0.01800 - 0.4) - 0.42, floor(CGRectGetHeight(frame) * 0.99920 + 0.06) - floor(CGRectGetHeight(frame) * 0.01120 + 0.46) + 0.4);


    //// Group 4
    {
        //// Shape Drawing
        UIBezierPath* shapePath = UIBezierPath.bezierPath;
        [shapePath moveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.64654 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.45352 * CGRectGetHeight(group4))];
        [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.35495 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.45352 * CGRectGetHeight(group4))];
        [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.29855 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.50555 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.32340 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.45352 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.29855 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.47645 * CGRectGetHeight(group4))];
        [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.35495 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.55758 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.29855 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.53465 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.32340 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.55758 * CGRectGetHeight(group4))];
        [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.64654 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.55758 * CGRectGetHeight(group4))];
        [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.70294 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.50555 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.67809 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.55758 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.70294 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.53465 * CGRectGetHeight(group4))];
        [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.64654 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.45352 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.70294 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.47645 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.67809 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.45352 * CGRectGetHeight(group4))];
        [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.64654 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.45352 * CGRectGetHeight(group4))];
        [shapePath closePath];
        shapePath.miterLimit = 4;

        shapePath.usesEvenOddFillRule = YES;

        [color setFill];
        [shapePath fill];


        //// Shape 2 Drawing
        UIBezierPath* shape2Path = UIBezierPath.bezierPath;
        [shape2Path moveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.92352 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.00000 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.07553 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.00000 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.00000 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.06966 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.03346 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.00000 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.00000 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.03086 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.00000 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.25220 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.05927 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.32011 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.00000 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.28571 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.02486 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.31305 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.05927 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89242 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.17591 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 1.00000 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.05927 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.95150 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.11185 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 1.00000 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.82409 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 1.00000 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.94073 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89242 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.88815 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 1.00000 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.94073 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.95150 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.94073 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.32011 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 1.00000 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.25220 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.97419 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.31305 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 1.00000 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.28571 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 1.00000 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.06966 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.92352 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.00000 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.99904 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.03175 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.96558 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.00000 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.92352 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.00000 * CGRectGetHeight(group4))];
        [shape2Path closePath];
        [shape2Path moveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.11281 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.10406 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.88623 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.10406 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.88623 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.21693 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.11281 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.21693 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.11281 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.10406 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.11281 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.10406 * CGRectGetHeight(group4))];
        [shape2Path closePath];
        [shape2Path moveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.82409 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89594 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.17591 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89594 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.17208 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89242 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.17400 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89594 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.17208 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89418 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.17208 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.32187 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.82696 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.32187 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.82696 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89242 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.82409 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89594 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.82696 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89418 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.82600 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89594 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.82409 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89594 * CGRectGetHeight(group4))];
        [shape2Path closePath];
        shape2Path.miterLimit = 4;

        shape2Path.usesEvenOddFillRule = YES;

        [color setFill];
        [shape2Path fill];
    }
}

+ (void)drawMagnifyingGlassWithColor: (UIColor*)color width: (CGFloat)width;
{

    //// Frames
    CGRect frame = CGRectMake(0, 0, width, width);

    //// Subframes
    CGRect group = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.02000 - 0.5) + 1, CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.02000 + 0.25) + 0.25, floor(CGRectGetWidth(frame) * 0.97546 - 0.27) - floor(CGRectGetWidth(frame) * 0.02000 - 0.5) - 0.23, floor(CGRectGetHeight(frame) * 0.99500 - 0.5) - floor(CGRectGetHeight(frame) * 0.02000 + 0.25) + 0.75);


    //// Group
    {
        //// Oval Drawing
        UIBezierPath* ovalPath = UIBezierPath.bezierPath;
        [ovalPath moveToPoint: CGPointMake(CGRectGetMinX(group) + 0.64395 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.63853 * CGRectGetHeight(group))];
        [ovalPath addCurveToPoint: CGPointMake(CGRectGetMinX(group) + 0.64395 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.15946 * CGRectGetHeight(group)) controlPoint1: CGPointMake(CGRectGetMinX(group) + 0.77739 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.50614 * CGRectGetHeight(group)) controlPoint2: CGPointMake(CGRectGetMinX(group) + 0.77739 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.29185 * CGRectGetHeight(group))];
        [ovalPath addCurveToPoint: CGPointMake(CGRectGetMinX(group) + 0.15882 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.15946 * CGRectGetHeight(group)) controlPoint1: CGPointMake(CGRectGetMinX(group) + 0.51007 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.02664 * CGRectGetHeight(group)) controlPoint2: CGPointMake(CGRectGetMinX(group) + 0.29270 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.02664 * CGRectGetHeight(group))];
        [ovalPath addCurveToPoint: CGPointMake(CGRectGetMinX(group) + 0.15882 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.63853 * CGRectGetHeight(group)) controlPoint1: CGPointMake(CGRectGetMinX(group) + 0.02538 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.29185 * CGRectGetHeight(group)) controlPoint2: CGPointMake(CGRectGetMinX(group) + 0.02538 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.50614 * CGRectGetHeight(group))];
        [ovalPath addCurveToPoint: CGPointMake(CGRectGetMinX(group) + 0.64395 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.63853 * CGRectGetHeight(group)) controlPoint1: CGPointMake(CGRectGetMinX(group) + 0.29270 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.77135 * CGRectGetHeight(group)) controlPoint2: CGPointMake(CGRectGetMinX(group) + 0.51007 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.77135 * CGRectGetHeight(group))];
        [ovalPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.68493 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.68141 * CGRectGetHeight(group))];
        [ovalPath addCurveToPoint: CGPointMake(CGRectGetMinX(group) + 0.11784 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.68141 * CGRectGetHeight(group)) controlPoint1: CGPointMake(CGRectGetMinX(group) + 0.52825 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.83685 * CGRectGetHeight(group)) controlPoint2: CGPointMake(CGRectGetMinX(group) + 0.27453 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.83685 * CGRectGetHeight(group))];
        [ovalPath addCurveToPoint: CGPointMake(CGRectGetMinX(group) + 0.11784 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.11658 * CGRectGetHeight(group)) controlPoint1: CGPointMake(CGRectGetMinX(group) + -0.03928 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.52553 * CGRectGetHeight(group)) controlPoint2: CGPointMake(CGRectGetMinX(group) + -0.03928 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.27246 * CGRectGetHeight(group))];
        [ovalPath addCurveToPoint: CGPointMake(CGRectGetMinX(group) + 0.68493 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.11658 * CGRectGetHeight(group)) controlPoint1: CGPointMake(CGRectGetMinX(group) + 0.27453 * CGRectGetWidth(group), CGRectGetMinY(group) + -0.03886 * CGRectGetHeight(group)) controlPoint2: CGPointMake(CGRectGetMinX(group) + 0.52825 * CGRectGetWidth(group), CGRectGetMinY(group) + -0.03886 * CGRectGetHeight(group))];
        [ovalPath addCurveToPoint: CGPointMake(CGRectGetMinX(group) + 0.68493 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.68141 * CGRectGetHeight(group)) controlPoint1: CGPointMake(CGRectGetMinX(group) + 0.84205 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.27246 * CGRectGetHeight(group)) controlPoint2: CGPointMake(CGRectGetMinX(group) + 0.84205 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.52553 * CGRectGetHeight(group))];
        [ovalPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.64395 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.63853 * CGRectGetHeight(group))];
        [ovalPath closePath];
        [color setFill];
        [ovalPath fill];


        //// Rectangle Drawing
        UIBezierPath* rectanglePath = UIBezierPath.bezierPath;
        [rectanglePath moveToPoint: CGPointMake(CGRectGetMinX(group) + 0.93848 * CGRectGetWidth(group), CGRectGetMinY(group) + 1.00000 * CGRectGetHeight(group))];
        [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 1.00000 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.93770 * CGRectGetHeight(group))];
        [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.71676 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.65086 * CGRectGetHeight(group))];
        [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.65523 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.71316 * CGRectGetHeight(group))];
        [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.93848 * CGRectGetWidth(group), CGRectGetMinY(group) + 1.00000 * CGRectGetHeight(group))];
        [rectanglePath closePath];
        [color setFill];
        [rectanglePath fill];
        [color setStroke];
        rectanglePath.lineWidth = 0.5;
        [rectanglePath stroke];
    }
}

+ (void)drawDefaultCoverWithColor: (UIColor*)color background: (UIColor*)background width: (CGFloat)width height: (CGFloat)height;
{

    //// Frames
    CGRect frame = CGRectMake(1, 1, width, height);

    //// Subframes
    CGRect group4 = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.08000 + 0.5), CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.22667 - 0.1) + 0.6, floor(CGRectGetWidth(frame) * 0.89157 - 0.08) - floor(CGRectGetWidth(frame) * 0.08000 + 0.5) + 0.58, floor(CGRectGetHeight(frame) * 0.77867 + 0.5) - floor(CGRectGetHeight(frame) * 0.22667 - 0.1) - 0.6);


    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) - 1, CGRectGetMinY(frame), floor((CGRectGetWidth(frame) + 1) * 1.00000 + 0.5), floor((CGRectGetHeight(frame)) * 1.00000 + 0.5))];
    [background setFill];
    [rectanglePath fill];


    //// Group 4
    {
        //// Shape Drawing
        UIBezierPath* shapePath = UIBezierPath.bezierPath;
        [shapePath moveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.64654 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.45352 * CGRectGetHeight(group4))];
        [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.35495 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.45352 * CGRectGetHeight(group4))];
        [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.29855 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.50555 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.32340 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.45352 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.29855 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.47645 * CGRectGetHeight(group4))];
        [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.35495 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.55758 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.29855 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.53465 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.32340 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.55758 * CGRectGetHeight(group4))];
        [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.64654 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.55758 * CGRectGetHeight(group4))];
        [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.70294 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.50555 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.67809 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.55758 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.70294 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.53465 * CGRectGetHeight(group4))];
        [shapePath addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.64654 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.45352 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.70294 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.47645 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.67809 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.45352 * CGRectGetHeight(group4))];
        [shapePath addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.64654 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.45352 * CGRectGetHeight(group4))];
        [shapePath closePath];
        shapePath.miterLimit = 4;

        shapePath.usesEvenOddFillRule = YES;

        [color setFill];
        [shapePath fill];


        //// Shape 2 Drawing
        UIBezierPath* shape2Path = UIBezierPath.bezierPath;
        [shape2Path moveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.92352 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.00000 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.07553 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.00000 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.00000 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.06966 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.03346 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.00000 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.00000 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.03086 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.00000 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.25220 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.05927 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.32011 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.00000 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.28571 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.02486 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.31305 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.05927 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89242 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.17591 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 1.00000 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.05927 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.95150 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.11185 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 1.00000 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.82409 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 1.00000 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.94073 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89242 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.88815 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 1.00000 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.94073 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.95150 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.94073 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.32011 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 1.00000 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.25220 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.97419 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.31305 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 1.00000 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.28571 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 1.00000 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.06966 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.92352 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.00000 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.99904 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.03175 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.96558 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.00000 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.92352 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.00000 * CGRectGetHeight(group4))];
        [shape2Path closePath];
        [shape2Path moveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.11281 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.10406 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.88623 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.10406 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.88623 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.21693 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.11281 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.21693 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.11281 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.10406 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.11281 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.10406 * CGRectGetHeight(group4))];
        [shape2Path closePath];
        [shape2Path moveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.82409 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89594 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.17591 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89594 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.17208 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89242 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.17400 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89594 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.17208 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89418 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.17208 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.32187 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.82696 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.32187 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.82696 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89242 * CGRectGetHeight(group4))];
        [shape2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group4) + 0.82409 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89594 * CGRectGetHeight(group4)) controlPoint1: CGPointMake(CGRectGetMinX(group4) + 0.82696 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89418 * CGRectGetHeight(group4)) controlPoint2: CGPointMake(CGRectGetMinX(group4) + 0.82600 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89594 * CGRectGetHeight(group4))];
        [shape2Path addLineToPoint: CGPointMake(CGRectGetMinX(group4) + 0.82409 * CGRectGetWidth(group4), CGRectGetMinY(group4) + 0.89594 * CGRectGetHeight(group4))];
        [shape2Path closePath];
        shape2Path.miterLimit = 4;

        shape2Path.usesEvenOddFillRule = YES;

        [color setFill];
        [shape2Path fill];
    }
}

#pragma mark Generated Images

+ (UIImage*)imageOfPlusWithColor: (UIColor*)color width: (CGFloat)width;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 0.0f);
    [PaintCodeImages drawPlusWithColor: color width: width];
    UIImage* imageOfPlus = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageOfPlus;
}

+ (UIImage*)imageOfArrowWithColor: (UIColor*)color width: (CGFloat)width;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 0.0f);
    [PaintCodeImages drawArrowWithColor: color width: width];
    UIImage* imageOfArrow = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageOfArrow;
}

+ (UIImage*)imageOfLongboxedLogoWithColor: (UIColor*)color width: (CGFloat)width;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 0.0f);
    [PaintCodeImages drawLongboxedLogoWithColor: color width: width];
    UIImage* imageOfLongboxedLogo = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageOfLongboxedLogo;
}

+ (UIImage*)imageOfMagnifyingGlassWithColor: (UIColor*)color width: (CGFloat)width;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 0.0f);
    [PaintCodeImages drawMagnifyingGlassWithColor: color width: width];
    UIImage* imageOfMagnifyingGlass = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageOfMagnifyingGlass;
}

+ (UIImage*)imageOfDefaultCoverWithColor: (UIColor*)color background: (UIColor*)background width: (CGFloat)width height: (CGFloat)height;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0f);
    [PaintCodeImages drawDefaultCoverWithColor: color background: background width: width height: height];
    UIImage* imageOfDefaultCover = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageOfDefaultCover;
}

@end
