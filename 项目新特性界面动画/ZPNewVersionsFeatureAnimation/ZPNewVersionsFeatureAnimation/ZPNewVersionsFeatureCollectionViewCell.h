//
//  ZPNewVersionsFeatureCollectionViewCell.h
//  ZPNewVersionsFeatureAnimation
//
//  Created by 赵鹏 on 2019/1/23.
//  Copyright © 2019 赵鹏. All rights reserved.
//

//自定义UICollectionViewCell类。

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPNewVersionsFeatureCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

- (void)addImmediatelyExperienceBtnWithIndexPath:(NSIndexPath *)indexPath totalPagesCount:(int)totalPagesCount;

@end

NS_ASSUME_NONNULL_END
