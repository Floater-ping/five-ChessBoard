//
//  TOCGraphicView.h
//  clubManager
//
//  Created by ZYP-MAC on 2017/8/17.
//  Copyright © 2017年 zyp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GameOverBlock)(NSString *winnerColor);

@interface TOCGraphicView : UIView
@property (copy, nonatomic) GameOverBlock  gameOverBlock;
- (void)clearnBoard;
@end
