//
//  ZPNewVersionsFeatureCollectionViewController.m
//  ZPNewVersionsFeatureAnimation
//
//  Created by 赵鹏 on 2019/1/22.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 可以把UIScrollView控件看成一个具有上下两层的控件，上面一层是显示层，可以把它看成是一个窗户，作用是用来显示的、给用户看的，下面一层是内容层，是指UIScrollView控件的内容大小，如果内容层的大小大于显示层的大小的话，则UIScrollView控件会自动具有滚动功能，用来滚动显示内容层的内容。
 
 新版本特性界面从滚动效果来看应该使用UIScrollView控件。在项目中新特性界面往往会滚动展示很多张图片，如果一开始UIScrollView控件上就加载这么多UIImageView控件的话会很耗费系统的资源，可以借鉴UITableView控件的cell重用机制来处理这一问题。程序运行之后，来到本类，首先会加载UIScrollView控件，然后在加载此控件上的UIImageView控件之前，系统会先从存储UIImageView控件的缓存池中寻找有没有带有重用标识符的UIImageView控件，如果没有的话系统就要创建一个新的带有重用标识符的UIImageView控件，创建完了之后就会加载图片并显示到屏幕上，此时这个UIImageView控件可以看做有一个名为"visibleView"的指针指着它，并且它的contentOffsetX为0，X坐标也为0。当用户向左滑动此UIScrollView控件时，在下一张图片显示之前，系统又会向缓存池中寻找带有重用标识符的UIImageView控件，因为此时缓存池中没有任何东西，所以系统在没有找到之后就会创建一个新的带有重用标识符的UIImageView控件，创建完了之后把该UIImageView控件放到UIScrollView控件的即将显示的第二张图片的位置上，同样此时也可以把这个UIImageView控件看做有一个名为"reuseView"的指针指着它，并且它的contentOffsetX值为屏幕的宽度，X坐标值也为屏幕的宽度。当用户继续向左滑动的时候该图片会完全显示出来，当该图片完全显示出来以后要把"visibleView"指针指向这个新显示出来的UIImageView控件，并且它的contentOffsetX值会由原来的屏幕宽度变为0，X坐标值也由原来的屏幕宽度变为0。"visibleView"指针以前指向的那个UIImageView控件（现在已经不显示在屏幕上了）会被系统放入缓存池中。如果用户再向左滑动的话，系统会从缓存池中寻找带有标识符的UIImageView控件，所以系统就会把之前放进去的那个UIImageView控件再拿出来，并且让"reuseView"指针指着它，放到图片即将显示的位置上，此时它的contentOffsetX值为屏幕的宽度，X坐标值也为屏幕的宽度。综上所述，使用UIScrollView控件滚动显示多张图片的时候，实际上系统只需要创建两个UIImageView控件即可实现目的；
 因为UICollectionView控件继承于UIScrollView控件，所以当使用UICollectionView控件制作新版本特性界面时，和上述的UIScrollView控件一样也具有缓存池特性。当使用UICollectionView控件滚动显示多张图片的时候实际上系统只需要创建两个UIImageView控件即可实现目的。
 */
#import "ZPNewVersionsFeatureCollectionViewController.h"
#import "ZPNewVersionsFeatureCollectionViewCell.h"

#define kTotalPagesCount 4  //新版本特性页面总页数

@interface ZPNewVersionsFeatureCollectionViewController ()

@property (nonatomic, strong) UIImageView *guideImageView;
@property (nonatomic, strong) UIImageView *largeSloganImageView;
@property (nonatomic, strong) UIImageView *smallSloganImageView;
@property (nonatomic, assign) CGFloat lastContentOffsetX;

@end

@implementation ZPNewVersionsFeatureCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark ————— UICollectionView控件初始化方法 —————
- (instancetype)init
{
    //创建流水布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    /**
     设置item的尺寸：
     可以把item看做盛放UIImageView控件的容器，因为图片要显示到整个屏幕上，所以要设置item的大小为整个屏幕。
     */
    flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
    
    //设置item之间的水平距离
    flowLayout.minimumInteritemSpacing = 0;
    
    //设置item之间的垂直距离
    flowLayout.minimumLineSpacing = 0;
    
    /**
     设置滚动方向：
     把UICollectionView控件由原来的纵向滚动变为横向滚动。
     */
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return [super initWithCollectionViewLayout:flowLayout];
}

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //取消弹簧效果
    self.collectionView.bounces = NO;
    
    //取消横向滚动显示条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    //开启分页效果
    self.collectionView.pagingEnabled = YES;
    
    //注册item
    [self.collectionView registerClass:[ZPNewVersionsFeatureCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //添加子控件
    [self addSubview];
}

#pragma mark ————— UICollectionViewDataSource —————
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZPNewVersionsFeatureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *imageName = [NSString stringWithFormat:@"guide%ldBackground", indexPath.item + 1];
    cell.image = [UIImage imageNamed:imageName];
    
    //在新版本特性页面的最后一页上添加“立即体验”按钮
    [cell addImmediatelyExperienceBtnWithIndexPath:indexPath totalPagesCount:kTotalPagesCount];
    
    return cell;
}

#pragma mark ————— 添加子视图 —————
- (void)addSubview
{
    //添加视图中间的图片
    self.guideImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide1"]];
    
    self.guideImageView.center = self.view.center;
    
    [self.collectionView addSubview:self.guideImageView];
    
    //添加背景曲线的图片
    UIImageView *guideLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideLine"]];
    
    CGRect tempGuideLineImageViewFrame = guideLineImageView.frame;
    tempGuideLineImageViewFrame.origin.x = -170;
    tempGuideLineImageViewFrame.origin.y = 50;
    guideLineImageView.frame = tempGuideLineImageViewFrame;
    
    [self.collectionView addSubview:guideLineImageView];
    
    //添加大字宣传语
    self.largeSloganImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideLargeText1"]];
    
    CGPoint tempLargeSloganImageViewCenter = self.largeSloganImageView.center;
    tempLargeSloganImageViewCenter.x = self.view.center.x;
    tempLargeSloganImageViewCenter.y = self.view.frame.size.height * 0.7;
    self.largeSloganImageView.center = tempLargeSloganImageViewCenter;
    
    [self.collectionView addSubview:self.largeSloganImageView];
    
    //添加小字宣传语
    self.smallSloganImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideSmallText1"]];
    
    CGPoint tempSmallSloganImageViewCenter = self.smallSloganImageView.center;
    tempSmallSloganImageViewCenter.x = self.view.center.x;
    tempSmallSloganImageViewCenter.y = self.view.frame.size.height * 0.8;
    self.smallSloganImageView.center = tempSmallSloganImageViewCenter;
    
    [self.collectionView addSubview:self.smallSloganImageView];
}

#pragma mark ————— UIScrollViewDelegate —————
/**
 用户用手指拖拽UIScrollView控件，使控件开始滚动，然后用户的手指离开控件，控件开始从正常滚动状态开始慢慢减速滚动直至最后停止滚动，在停止滚动那一刻会调用这个方法；
 在此方法中制作动画。
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //获取当前的contentOffset在X轴上的值
    CGFloat cutContentOffsetX = scrollView.contentOffset.x;
    
    //计算这次和上一次contentOffset在X轴上的差值
    CGFloat delta = cutContentOffsetX - self.lastContentOffsetX;
    
    /**
     1、用户向左侧滑动UICollectionView控件：
     假设屏幕的宽度为W。在滑动之前，假设scrollView的contentOffset.x值为0，在滑动之后，假设scrollView的contentOffset.x值为W，则滑动前后这个scrollView的contentOffset在X方向上的差值就为W。在滑动之前，下面代码的第二行中，等号右边的tempGuideImageViewFrame代表当前的guideImageView所处的位置，假设此时它的X值为0.3W，显示在屏幕之内，等号左边的tempGuideImageViewFrame代表guideImageView所处的一个过渡位置，经过计算，这个过渡位置的X值为2.3W（0.3W + 2W），处在屏幕之外。在滑动之后，上述的过渡点的X值仍为2.3W，依旧处在屏幕之外，下面的动画block内的代码中的第二行右边的tempGuideImageViewFrame代表上述的过渡点，左边的tempGuideImageViewFrame代表滑动完最新的guideImageView所处的位置，经过计算，它的X值为1.3W（2.3W - W ），这样就正好显示在了屏幕之内，从而完成了动画。
     2、用户向右侧滑动UICollectionView控件：
     假设屏幕的宽度依旧为W。在滑动之前，假设scrollView的contentOffset.x值为W，在滑动之后，假设scrollView的contentOffset.x值为0，则滑动前后这个scrollView的contentOffset在X方向上的差值就为-W。在滑动之前，下面代码的第二行中，等号右边的tempGuideImageViewFrame代表当前的guideImageView所处的位置，假设此时它的X值为1.3W，显示在屏幕之内，等号左边的tempGuideImageViewFrame代表guideImageView所处的一个过渡位置，经过计算，这个过渡位置的X值为-0.7W（1.3W - 2W），处在屏幕之外。在滑动之后，上述的过渡点的X值仍为-0.7W，依旧处在屏幕之外，下面的动画block内的代码中的第二行右边的tempGuideImageViewFrame代表上述的过渡点，左边的tempGuideImageViewFrame代表滑动完最新的guideImageView所处的位置，经过计算，它的X值为0.3W（-0.7W + W ），这样就正好显示在了屏幕之内，从而完成了动画。
     */
    
    //设置视图中间的图片的位置
    CGRect tempGuideImageViewFrame = self.guideImageView.frame;
    tempGuideImageViewFrame.origin.x = tempGuideImageViewFrame.origin.x + 2 * delta;
    self.guideImageView.frame = tempGuideImageViewFrame;
    
    //设置大字宣传语的位置
    CGRect tempLargeSloganImageViewFrame = self.largeSloganImageView.frame;
    tempLargeSloganImageViewFrame.origin.x = tempLargeSloganImageViewFrame.origin.x + 2 * delta;
    self.largeSloganImageView.frame = tempLargeSloganImageViewFrame;
    
    //设置小字宣传语的位置
    CGRect tempSmallSloganImageViewFrame = self.smallSloganImageView.frame;
    tempSmallSloganImageViewFrame.origin.x = tempSmallSloganImageViewFrame.origin.x + 2 * delta;
    self.smallSloganImageView.frame = tempSmallSloganImageViewFrame;
    
    //UIView封装的动画
    [UIView animateWithDuration:0.25 animations:^{
        //设置视图中间的图片的位置
        CGRect tempGuideImageViewFrame = self.guideImageView.frame;
        tempGuideImageViewFrame.origin.x = tempGuideImageViewFrame.origin.x - delta;
        self.guideImageView.frame = tempGuideImageViewFrame;
        
        //设置大字宣传语的位置
        CGRect tempLargeSloganImageViewFrame = self.largeSloganImageView.frame;
        tempLargeSloganImageViewFrame.origin.x = tempLargeSloganImageViewFrame.origin.x - delta;
        self.largeSloganImageView.frame = tempLargeSloganImageViewFrame;
        
        //设置小字宣传语的位置
        CGRect tempSmallSloganImageViewFrame = self.smallSloganImageView.frame;
        tempSmallSloganImageViewFrame.origin.x = tempSmallSloganImageViewFrame.origin.x - delta;
        self.smallSloganImageView.frame = tempSmallSloganImageViewFrame;
    }];
    
    //判断当前滚动到了第几页
    int page = cutContentOffsetX / self.view.bounds.size.width + 1;
    
    //根据页码修改视图中的内容
    self.guideImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d", page]];
    self.largeSloganImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guideLargeText%d", page]];
    self.smallSloganImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guideSmallText%d", page]];
    
    self.lastContentOffsetX = cutContentOffsetX;
}

@end
