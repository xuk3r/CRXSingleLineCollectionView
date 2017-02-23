//
//  UIView+FrameExt.m
//  LaiYiVens
//
//  Created by Macmini2015 on 2016/11/22.
//  Copyright © 2016年 HYcompany. All rights reserved.
//

#import "UIView+FrameExt.h"

@implementation UIView (FrameExt)

- (CGPoint) originExt
{
    return self.frame.origin;
}

- (void) setOriginExt: (CGPoint) aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}


// Retrieve and set the size
- (CGSize) sizeExt
{
    return self.frame.size;
}

- (void) setSizeExt: (CGSize) aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

// Query other frame locations
- (CGPoint) bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

// Retrieve and set height, width, top, bottom, left, right
- (CGFloat) heightExt
{
    return self.frame.size.height;
}

- (void) setHeightExt: (CGFloat) newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat) widthExt
{
    return self.frame.size.width;
}

- (void) setWidthExt: (CGFloat) newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat) topExt
{
    return self.frame.origin.y;
}

- (void) setTopExt: (CGFloat) newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}


- (CGFloat) leftExt
{
    return self.frame.origin.x;
}

- (void) setLeftExt: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) bottomExt
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottomExt: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) rightExt
{
    return self.frame.origin.x + self.frame.size.width;
}


@end
