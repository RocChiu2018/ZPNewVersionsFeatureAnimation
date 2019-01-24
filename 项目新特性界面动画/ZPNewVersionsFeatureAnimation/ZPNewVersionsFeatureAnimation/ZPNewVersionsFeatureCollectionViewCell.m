//
//  ZPNewVersionsFeatureCollectionViewCell.m
//  ZPNewVersionsFeatureAnimation
//
//  Created by 赵鹏 on 2019/1/23.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPNewVersionsFeatureCollectionViewCell.h"
#import "ViewController.h"

@interface ZPNewVersionsFeatureCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *immediatelyExperienceBtn;  //立即体验按钮

@end

@implementation ZPNewVersionsFeatureCollectionViewCell

#pragma mark ————— 懒加载 —————
/**
 新版本特性页面中向左或者向右滑动的时候滚出屏幕的页面就会被系统销毁掉，所以上面的按钮也会被销毁掉，下一个页面出现在屏幕上的时候一开始按钮是不存在的所以会调用按钮的懒加载方法来创建新按钮。这就是每显示一个新页面系统都会调用按钮的懒加载方法来创建新按钮的原因。
 */
- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];

        [self.contentView addSubview:_imageView];
    }

    return _imageView;
}

- (UIButton *)immediatelyExperienceBtn
{
    if (_immediatelyExperienceBtn == nil)
    {
        _immediatelyExperienceBtn = [[UIButton alloc] init];
        [_immediatelyExperienceBtn setBackgroundImage:[UIImage imageNamed:@"guideStart"] forState:UIControlStateNormal];
        [_immediatelyExperienceBtn sizeToFit];
        _immediatelyExperienceBtn.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.9);
        [_immediatelyExperienceBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_immediatelyExperienceBtn];
    }
    
    return _immediatelyExperienceBtn;
}

#pragma mark ————— 设置背景图片 —————
- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
}

#pragma mark ————— 在新版本特性页面的最后一页上添加“立即体验”按钮 —————
- (void)addImmediatelyExperienceBtnWithIndexPath:(NSIndexPath *)indexPath totalPagesCount:(int)totalPagesCount
{
    NSLog(@"row = %ld", (long)indexPath.row);
    NSLog(@"pagesCount = %d", totalPagesCount);
    
    if (indexPath.row == totalPagesCount - 1)  //最后一页
    {
        self.immediatelyExperienceBtn.hidden = NO;
    }else
    {
        self.immediatelyExperienceBtn.hidden = YES;
    }
}

#pragma mark ————— 点击“立即体验”按钮 —————
- (void)clickBtn
{
    //点击“立即体验”按钮之后直接进入到核心页面中，而"ZPNewVersionsFeatureCollectionViewController"则被销毁。
    [UIApplication sharedApplication].keyWindow.rootViewController = [[ViewController alloc] init];
    
    //使用核心动画来实现动画
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.type = @"rippleffect";  //动画效果为慢慢消失
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
}

@end
