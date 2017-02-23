//
//  PaletteViewCell.m
//  LK
//
//  Created by xuke on 2017/2/18.
//  Copyright © 2017年 KorzJ. All rights reserved.
//

#import "PaletteViewCell.h"

@implementation PaletteViewCell

- (UIImageView *)imgView
{
    if (!_imgView)
    {
        _imgView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_imgView];
    }
    return _imgView;
}
@end
