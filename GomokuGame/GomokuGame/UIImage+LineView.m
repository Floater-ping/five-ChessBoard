//
//  UIImage+LineView.m
//  clubManager
//
//  Created by ZYP-MAC on 2017/8/17.
//  Copyright © 2017年 zyp. All rights reserved.
//

#import "UIImage+LineView.h"

@implementation UIImage (LineView)
+ (UIImage *)onlyLineImage {
    UIImage *image;
    CGSize size = CGSizeMake(20, 100);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef content = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(content, 0.5);
    CGContextSetStrokeColorWithColor(content, [UIColor redColor].CGColor);
//    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//    CGFloat colors[] = {
//        1,1,1, 1.00,
//        1,1,0, 1.00,
//        1,0,0, 1.00,
//        1,0,1, 1.00,
//        0,1,1, 1.00,
//        0,1,0, 1.00,
//        0,0,1, 1.00,
//        0,0,0, 1.00,
//    };
//    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    
    
    CGContextMoveToPoint(content, size.width/2, 0);
    CGContextAddLineToPoint(content, size.width/2, 50);
    CGContextDrawPath(content, kCGPathStroke);
    CGContextSetStrokeColorWithColor(content, [UIColor yellowColor].CGColor);
    
    CGContextAddArc(content, size.width/2, 50, 3, 0, 2*M_PI, YES);
    CGContextSetFillColorWithColor(content, [UIColor blueColor].CGColor);
    CGContextDrawPath(content, kCGPathFillStroke);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    
    return image;
}


@end
