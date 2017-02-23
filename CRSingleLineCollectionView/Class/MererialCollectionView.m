//
//  MererialCollectionView.m
//  LK
//
//  Created by xuke on 2017/2/18.
//  Copyright © 2017年 KorzJ. All rights reserved.
//

#import "MererialCollectionView.h"
#import "PaletteViewCell.h"
#import "UIView+FrameExt.h"


#define RGBCOLOR(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGBFromHexadecimal(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]
#define G_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define G_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define G_COLOR_GRAY RGBCOLOR(142, 142, 142)

#define g_column 5////列数
#define g_line 4////行数

@interface MererialCollectionView ()

@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic, assign) CGPoint pointStart;
@property (nonatomic, assign) NSInteger countGes;///用于计算方向

@property (nonatomic, strong) NSMutableArray <PaletteViewCell *>*marrVisibleView;///静止时所有view
@property (nonatomic, strong) NSMutableArray <PaletteViewCell *>*marrCurrentMoving;///正在移动的区块
@property (nonatomic, strong) PaletteViewCell *viewMoving;///触发移动的区块

@property (nonatomic, strong) NSMutableArray *marrDataQueue;///未展示内容

@end

@implementation MererialCollectionView


#pragma mark - UserInteraction
- (void)clickRefresh:(UIButton *)sender
{
    //    NSInteger tag = sender.tag;
    self.arrData = nil;
}

- (void)gesureMove:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:sender.view];
    self.countGes ++;

    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            self.pointStart = point;
            self.countGes = 0;
            self.viewMoving = (PaletteViewCell *)sender.view;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            ////获得当前滚动方向
            if (self.countGes == 1)
            {
                if (ABS(point.x - self.pointStart.x) > ABS(point.y - self.pointStart.y))
                {
                    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                }
                else
                {
                    self.scrollDirection = UICollectionViewScrollDirectionVertical;
                }
            }
            ////开始移动
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
            {
//                sender.view.leftExt += ;
                [self moveLine:(point.x - self.pointStart.x)];
                
            }
            else if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
            {
//                sender.view.topExt += (point.y - self.pointStart.y);
                [self moveColumn:(point.y - self.pointStart.y)];
            }
        }
            break;
        default:
        {
            [self stopMoving];
            self.scrollDirection = -1;
            self.viewMoving = nil;
            self.marrCurrentMoving = nil;
        }
            break;
    }
}

#pragma mark - Operation

- (void)moveLine:(CGFloat)offsetX
{
    PaletteViewCell *viewFirst = self.marrCurrentMoving.firstObject;
    ////右移
    if (offsetX >= 0 && viewFirst.leftExt >= 0)
    {
        PaletteViewCell *imgView = [self imgViewForShow];
        imgView.topExt = viewFirst.topExt;
        imgView.leftExt = viewFirst.leftExt - imgView.widthExt;
        imgView.indexPath = [NSIndexPath indexPathForItem:viewFirst.indexPath.row - 1 inSection:viewFirst.indexPath.section];
        [self.marrCurrentMoving insertObject:imgView atIndex:0];
    }
    else
    {
        PaletteViewCell *viewLast = self.marrCurrentMoving.lastObject;
        ///左移
        if (viewLast.rightExt <= self.rightExt && offsetX <= 0)
        {
            PaletteViewCell *last = [self.marrCurrentMoving lastObject];
            
            PaletteViewCell *imgView = [self imgViewForShow];
            imgView.topExt = last.topExt;
            imgView.leftExt = last.rightExt;
            imgView.indexPath = [NSIndexPath indexPathForItem:last.indexPath.row + 1 inSection:last.indexPath.section];
            [self.marrCurrentMoving addObject:imgView];
        }
    }
    
//    if (viewFirst.leftExt == 0 || (viewFirst.leftExt > 0))
//    {
//        NSLog(@"viewFirst.leftExt == 0 %.2f %@",offsetX,NSStringFromCGRect(viewFirst.frame));
//        
//        PaletteViewCell *imgView = [self imgViewForShow];
//        imgView.topExt = viewFirst.topExt;
//        if (offsetX >= 0)
//        {
//            
//        }
//        else
//        {
//
//        }
//    }
//    else
//    {
//        NSLog(@"....%.2f",viewFirst.leftExt);
//    }
    
    [self.marrCurrentMoving enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        obj.leftExt += offsetX;
    }];
}

- (void)moveColumn:(CGFloat)offsetY
{
    PaletteViewCell *viewFirst = self.marrCurrentMoving.firstObject;
    ////下移
    if (offsetY >= 0 && viewFirst.topExt >= 0)
    {
        PaletteViewCell *imgView = [self imgViewForShow];
        imgView.topExt = viewFirst.topExt - imgView.heightExt;
        imgView.leftExt = viewFirst.leftExt;
        imgView.indexPath = [NSIndexPath indexPathForItem:viewFirst.indexPath.row inSection:viewFirst.indexPath.section - 1];
        [self.marrCurrentMoving insertObject:imgView atIndex:0];
    }
    else
    {
        PaletteViewCell *viewLast = self.marrCurrentMoving.lastObject;
        ///上移
        if (viewLast.rightExt <= self.rightExt && offsetY <= 0)
        {
            PaletteViewCell *last = [self.marrCurrentMoving lastObject];
            
            PaletteViewCell *imgView = [self imgViewForShow];
            imgView.topExt = last.bottomExt;
            imgView.leftExt = last.leftExt;
            imgView.indexPath = [NSIndexPath indexPathForItem:last.indexPath.row inSection:last.indexPath.section + 1];
            [self.marrCurrentMoving addObject:imgView];
        }
    }
    [self.marrCurrentMoving enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         obj.topExt += offsetY;
     }];
}

- (void)stopMoving
{
    ////停止移动
    if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal
       )
    {
        ////获取当前展示最左侧视图
        __block PaletteViewCell *view;
        __block NSInteger indexVisibleFirst = -1;
        [self.marrCurrentMoving enumerateObjectsUsingBlock:^(PaletteViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.rightExt > 0)
            {
                view = obj;
                indexVisibleFirst = idx;
                *stop = YES;
            }
        }];
        
        [self.marrVisibleView removeObjectsInRange:NSMakeRange(view.indexPath.section * g_column, g_column)];
        if (view && indexVisibleFirst > -1)
        {
            ////最左侧展示剩余不足一半 移到第下一个
            if (view.leftExt <= -view.widthExt/2)
            {
                [self moveLine:-(view.widthExt + view.leftExt)];
//                self.marrCurrentMoving = [[self.marrCurrentMoving subarrayWithRange:NSMakeRange(indexVisibleFirst + 1,g_column)]mutableCopy];
                [self subArrayWithRange:NSMakeRange(indexVisibleFirst + 1,g_column)];
            }
            else///展示大部分 保留
            {
                [self moveLine:-view.leftExt];
//                self.marrCurrentMoving = [[self.marrCurrentMoving subarrayWithRange:NSMakeRange(indexVisibleFirst, g_column)]mutableCopy];
                [self subArrayWithRange:NSMakeRange(indexVisibleFirst, g_column)];
            }
            
            ////重新编号
            [self.marrCurrentMoving enumerateObjectsUsingBlock:^(PaletteViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
            {
                obj.indexPath = [NSIndexPath indexPathForRow:idx
                                                   inSection:view.indexPath.section];
            }];
    
            [self.marrVisibleView insertObjects:self.marrCurrentMoving
                                      atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(view.indexPath.section * g_column, g_column)]];
        }
    }
    else if (self.scrollDirection == UICollectionViewScrollDirectionVertical
             )
    {
        ////获取当前展示顶部视图
        __block PaletteViewCell *view;
        __block NSInteger indexVisibleFirst = -1;
        [self.marrCurrentMoving enumerateObjectsUsingBlock:^(PaletteViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
            if (obj.bottomExt > 0)
            {
                view = obj;
                indexVisibleFirst = idx;
                *stop = YES;
            }
        }];
        
        ///移除
        NSMutableArray *marrNew = [NSMutableArray array];
        __block NSMutableArray *marrSub = [NSMutableArray array];
        [self.marrVisibleView enumerateObjectsUsingBlock:^(PaletteViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             [marrSub addObject:obj];
             if (marrSub.count == g_column)
             {
                 [marrSub removeObjectAtIndex:self.viewMoving.indexPath.row];
                 [marrNew addObject:marrSub];
                 marrSub = [NSMutableArray array];
             }
         }];
        
//        [self.marrVisibleView removeObjectsInRange:NSMakeRange(view.indexPath.section * 5, 5)];
        
        if (view && indexVisibleFirst > -1)
        {
            ////顶部展示剩余不足一半 移到第下一个
            if (view.topExt <= -view.heightExt/2)
            {
                [self moveColumn:-(view.heightExt + view.topExt)];
                
//                self.marrCurrentMoving = [[self.marrCurrentMoving subarrayWithRange:NSMakeRange(indexVisibleFirst + 1, g_column)]mutableCopy];
                [self subArrayWithRange:NSMakeRange(indexVisibleFirst + 1, g_column)];
            }
            else///展示大部分 保留
            {
                [self moveColumn:-view.topExt];
                
//                self.marrCurrentMoving = [[self.marrCurrentMoving subarrayWithRange:NSMakeRange(indexVisibleFirst, g_column)]mutableCopy];
                [self subArrayWithRange:NSMakeRange(indexVisibleFirst, g_column)];
            }
            
    
            self.marrVisibleView = [NSMutableArray array];
            [marrNew enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
            {
                NSMutableArray *marr = [obj mutableCopy];
                PaletteViewCell *cell = self.marrCurrentMoving[idx];
                cell.indexPath = [NSIndexPath indexPathForRow:view.indexPath.row inSection:idx];
                [marr insertObject:cell atIndex:self.viewMoving.indexPath.row];
                [self.marrVisibleView addObjectsFromArray:marr];
            }];
        }
    }
}

- (NSMutableArray *)subArrayWithRange:(NSRange)range
{
    NSMutableArray *marrSuper = self.marrCurrentMoving;
    NSMutableArray *marr = [[marrSuper subarrayWithRange:range]mutableCopy];
    [marrSuper enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if (![marr containsObject:obj])
        {
            if ([obj isKindOfClass:[UIView class]])
            {
                UIView *view = obj;
                [view removeFromSuperview];
            }
        }
    }];
    self.marrCurrentMoving = marr;
    return marr;
}

#pragma mark - Setter

- (void)setArrData:(NSArray *)arrData
{
    _arrData = arrData;
    
    //    [self addCollectionView];
    //    return;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    ///展示数据
    CGFloat countLayout = g_column * g_line;
    //    1024*768
    CGFloat width = self.widthExt/g_column;
    CGFloat height = self.heightExt/g_line;
    self.marrVisibleView = [NSMutableArray array];
    for (int i = 0 ; i < countLayout; i ++)
    {
        PaletteViewCell *imgView = [self imgViewForShow];
        imgView.frame = CGRectMake(i%g_column * width , i / g_column * height, width, height);
        imgView.indexPath = [NSIndexPath indexPathForItem:i%g_column inSection:i / g_column];
        [self.marrVisibleView addObject:imgView];
    }
    
    ////重置按钮
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(G_SCREEN_WIDTH - 60, 100, 60, 60)];
//    [btn setTitle:@"123123" forState:UIControlStateNormal];
//    [btn setBackgroundColor:RGBCOLOR(30, 60, 90)];
//    [btn addTarget:self
//            action:@selector(clickRefresh:)
//  forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:btn];
}


#pragma mark - Getter

- (NSMutableArray *)marrDataQueue
{
    if (!_marrDataQueue || _marrDataQueue.count == 0)
    {
        _marrDataQueue = [NSMutableArray arrayWithArray:self.arrData];
    }
    return _marrDataQueue;
}


- (NSMutableArray *)marrCurrentMoving
{
    if (!_marrCurrentMoving)
    {
        if (self.viewMoving)
        {
            if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal
               )
            {
                __block NSMutableArray *marr = [NSMutableArray array];
                //                NSInteger index = [self.marrVisibleView indexOfObjectIdenticalTo:self.viewMoving];
                NSInteger index = self.viewMoving.indexPath.section;
                
                [self.marrVisibleView enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                 {
                     if (idx/g_column == index)
                     {
                         [marr addObject:obj];
                     }
                 }];
                _marrCurrentMoving = [marr mutableCopy];
            }
            else if (self.scrollDirection == UICollectionViewScrollDirectionVertical
                     )
            {
                __block NSMutableArray *marr = [NSMutableArray array];
                NSInteger index = self.viewMoving.indexPath.row;
                
                [self.marrVisibleView enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                 {
                     if (idx%g_column == index)
                     {
                         [marr addObject:obj];
                     }
                 }];
                _marrCurrentMoving = [marr mutableCopy];
            }
        }
    }
    return _marrCurrentMoving;
}

- (PaletteViewCell *)imgViewForShow
{
    CGFloat width = self.widthExt/g_column;
    CGFloat height = self.heightExt/g_line;
    
    PaletteViewCell *imgView = [[PaletteViewCell alloc]initWithFrame:CGRectMake(0, 0, width , height)];
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(gesureMove:)]];
    imgView.backgroundColor = RGBCOLOR(arc4random()%255, arc4random()%255, arc4random()%255);
    imgView.imgView.image = [UIImage imageNamed:self.marrDataQueue.firstObject];
    if (self.marrDataQueue.count > 0)
    {
        [self.marrDataQueue removeObjectAtIndex:0];
    }
    [self addSubview:imgView];
    return imgView;
}

@end
