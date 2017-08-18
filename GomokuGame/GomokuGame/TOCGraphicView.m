//
//  TOCGraphicView.m
//  clubManager
//
//  Created by ZYP-MAC on 2017/8/17.
//  Copyright © 2017年 zyp. All rights reserved.
//

#import "TOCGraphicView.h"

@interface TOCGraphicView ()
@property (strong, nonatomic) NSMutableArray *arrXM;
@property (strong, nonatomic) NSMutableArray *addPointArrM;
@property (strong, nonatomic) NSMutableArray *addBlackArrM;
@property (strong, nonatomic) NSMutableArray *addWhiteArrM;
@property (assign, nonatomic) BOOL isWhitePeople;

@end

@implementation TOCGraphicView
- (NSMutableArray *)arrXM {
    if (_arrXM == nil) {
        _arrXM = [NSMutableArray array];
    }
    return _arrXM;
}

- (NSMutableArray *)addPointArrM {
    if (!_addPointArrM) {
        _addPointArrM = [NSMutableArray array];
    }
    return _addPointArrM;
}


- (NSMutableArray *)addBlackArrM {
    if (!_addBlackArrM) {
        _addBlackArrM = [NSMutableArray array];
    }
    return _addBlackArrM;
}

- (NSMutableArray *)addWhiteArrM {
    
    if (_addWhiteArrM == nil) {
        _addWhiteArrM = [NSMutableArray array];
    }
    return _addWhiteArrM;
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    
    CGFloat startMargin = (self.frame.size.width - 30*10)/2;
    CGFloat marginX = 30;
    CGFloat addCount = startMargin;
    while (addCount <= self.frame.size.width) {
        CGContextMoveToPoint(context, startMargin ,addCount);
        CGContextAddLineToPoint (context, self.frame.size.width-startMargin*2, addCount);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextMoveToPoint(context, addCount ,startMargin*2);
        CGContextAddLineToPoint(context, addCount, self.frame.size.width-startMargin*2);
        CGContextDrawPath(context, kCGPathStroke);
        [self.arrXM addObject:@(addCount)];
        addCount += marginX;
    }
    
    if (self.isWhitePeople) {
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    }else {
        
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    }
    
    if (self.addPointArrM.count > 0) {
        self.isWhitePeople = !self.isWhitePeople;
    }else {
        
        return;
    }
    
    
    for (NSDictionary *dict in self.addWhiteArrM) {
        CGContextAddArc(context, [dict[@"pointX"] floatValue], [dict[@"pointY"] floatValue], 5, 0, 2*M_PI, YES);
        
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);//填充颜色
        
        CGContextDrawPath(context, kCGPathFillStroke);
        
    }
    
    for (NSDictionary *dict in self.addBlackArrM) {
        CGContextAddArc(context, [dict[@"pointX"] floatValue], [dict[@"pointY"] floatValue], 5, 0, 2*M_PI, YES);
        
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);//填充颜色
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        
        CGContextDrawPath(context, kCGPathFillStroke);
        
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *t =  touches.anyObject;
    if ([t.view isKindOfClass:[TOCGraphicView class]]) {
        CGPoint point = [t locationInView:self];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGFloat pointX = point.x;
        CGFloat pointY = point.y;
        
        CGFloat chaX = CGFLOAT_MAX;
        CGFloat minX = -1;
        CGFloat chaY = CGFLOAT_MAX;
        CGFloat minY = -1;
        for (int i = 0; i<self.arrXM.count; i++) {
            if (ABS([self.arrXM[i] floatValue] - pointX) < chaX) {
                chaX = ABS([self.arrXM[i] floatValue] - pointX);
                minX = [self.arrXM[i] floatValue];
            }
            
            if (ABS([self.arrXM[i] floatValue] - pointY) < chaY) {
                chaY = ABS([self.arrXM[i] floatValue] - pointY);
                minY = [self.arrXM[i] floatValue];
            }
        }
        
        if (minX == -1 || minY == -1) {
            return;
        }
        
        NSDictionary *pointDict = @{@"pointX":@(minX),@"pointY":@(minY)};
        if (![self.addPointArrM containsObject:pointDict]) {
            [self.addPointArrM addObject:pointDict];
            if (self.isWhitePeople) {
                [self.addWhiteArrM addObject:pointDict];
                if ([self checkWinWithArr:self.addWhiteArrM]) {
                    // 白棋赢了
                    if (self.gameOverBlock) {
                        self.gameOverBlock(@"白");
                    }
                }
            }else {
                
                [self.addBlackArrM addObject:pointDict];
                if ([self checkWinWithArr:self.addBlackArrM]) {
                    // 黑棋赢了
                    if (self.gameOverBlock) {
                        self.gameOverBlock(@"黑");
                    }
                }
            }
            [self setNeedsDisplay];
        }
        
    }
    
}

- (void)clearnBoard {
    self.userInteractionEnabled = YES;
    [self.addWhiteArrM removeAllObjects];
    [self.addBlackArrM removeAllObjects];
    [self.addPointArrM removeAllObjects];
    [self setNeedsDisplay];
}

- (BOOL)checkWinWithArr:(NSArray *)addArr {
    return [self checkInOneHang:addArr] || [self checkInOneLie:addArr];
}


/// 判断是否在一行
- (BOOL)checkInOneHang:(NSArray *)addArr {
    return [self checkInOneHangOrLieWithArr:addArr andDictKey:@"pointY"];
}


- (BOOL)checkInOneLie:(NSArray *)addArr {
    return [self checkInOneHangOrLieWithArr:addArr andDictKey:@"pointX"];
    
}

- (BOOL)checkInOneHangOrLieWithArr:(NSArray *)addArr andDictKey:(NSString *)dictKey {
    if (addArr.count < 5) {
        return NO;
    }
    
    
    addArr = [addArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        return [obj1[dictKey] compare:obj2[dictKey]]; //降序
        
    }];
    
    /// 判断是不是在一列
    NSMutableArray *tempAddArrM = [NSMutableArray array];
    NSDictionary *tempDict = nil;
    
    NSString *otherKey = @"";
    if ([dictKey isEqualToString:@"pointY"]) {
        otherKey = @"pointX";
    }else {
        otherKey = @"pointY";
    }
    
    BOOL inOneHangOrLie = NO;
    
    for (int i = 0; i < addArr.count; i++) {
        NSDictionary *dict = addArr[i];
        if (i == 0) {
            
        }else {
            if ([tempDict[dictKey] isEqual:dict[dictKey]] && ABS([tempDict[otherKey] integerValue] - [dict[otherKey] integerValue]) == 30) {
                
            }else {
                if (tempAddArrM.count >= 5) {
                    inOneHangOrLie = YES;
                    break;
                }
                [tempAddArrM removeAllObjects];
            }
        }
        [tempAddArrM addObject:dict];
        tempDict = dict;
        
        if (i == addArr.count-1 && tempAddArrM.count >= 5) {
            inOneHangOrLie = YES;
            break;
        }
        
    }
    
    
    return inOneHangOrLie;
    
    /// 判断是不是在一行
    
    /// 判断是不是在同一对角线上
}
- (BOOL)checkInOneHangOrLieWithArr2:(NSArray *)addArr andDictKey:(NSString *)dictKey {
    if (addArr.count < 5) {
        return NO;
    }
    
    /// 接近的点
    addArr = [addArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        return [@([obj1[@"pointY"] floatValue] + [obj1[@"pointY"] floatValue]) compare:@([obj2[@"pointY"] floatValue] + [obj2[@"pointY"] floatValue])]; //降序
        
    }];
    
    /// 判断是不是在一列
    NSMutableArray *tempAddArrM = [NSMutableArray array];
    //    NSDictionary *tempDict = nil;
    
    
    BOOL inOneHangOrLie = NO;
    
    for (int i = 0; i < addArr.count; i++) {
        NSDictionary *firstPoint = addArr[i];
        for (int j = 0; j < addArr.count; j++) {
            NSDictionary *nextPoint = addArr[j];
            /// 计算斜率
            CGFloat y = [nextPoint[@"pointY"] floatValue] - [firstPoint[@"pointY"] floatValue];
            CGFloat x = [nextPoint[@"pointX"] floatValue] - [firstPoint[@"pointX"] floatValue];
            BOOL inLine = NO;
            if (x > 0) {
                if (ABS(y / x) == 1 || ABS(y / x) == 0 ) {
                    inLine = YES;
                }
                
            }else {
                // 在x轴
                inLine = YES;
            }
            
            if (inLine) {
            }else {
                if (tempAddArrM.count >= 5) {
                    inOneHangOrLie = YES;
                    break;
                }
                
            }
            
        }
        [tempAddArrM addObject:firstPoint];
        
        
        
        if (i == addArr.count-1 && tempAddArrM.count >= 5) {
            inOneHangOrLie = YES;
            break;
        }
        
        
    }
    
    
    return inOneHangOrLie;
}

@end
