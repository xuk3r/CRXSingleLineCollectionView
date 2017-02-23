//
//  UIView+FrameExt.h
//  LaiYiVens
//
//  Created by Macmini2015 on 2016/11/22.
//  Copyright © 2016年 HYcompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameExt)

@property CGPoint originExt;
@property CGSize sizeExt;

@property (readonly, nonatomic) CGPoint bottomLeft;
@property (readonly, nonatomic) CGPoint bottomRight;
@property (readonly, nonatomic) CGPoint topRight;

@property (nonatomic, assign) CGFloat heightExt;
@property (nonatomic, assign) CGFloat widthExt;

@property (nonatomic, assign) CGFloat topExt;
@property (nonatomic, assign) CGFloat leftExt;

@property (nonatomic, assign) CGFloat bottomExt;
@property (nonatomic, assign) CGFloat rightExt;

@end
