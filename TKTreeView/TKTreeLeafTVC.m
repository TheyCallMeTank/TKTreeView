//
//  TKBaseTreeLeafTVC.m
//  TKTreeViewDemo
//
//  Created by 谭柯 on 16/5/9.
//  Copyright © 2016年 Tank. All rights reserved.
//

#import "TKTreeLeafTVC.h"
#import "Masonry.h"

@interface TKTreeLeafTVC()

@property (nonatomic, strong) UIView *tipView;

@end

@implementation TKTreeLeafTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    __weak __typeof(self) weakSelf = self;
    
    CGFloat tipWidth = 10;
    self.tipView = [UIView new];
    self.tipView.layer.cornerRadius = tipWidth/2;
    self.tipView.layer.masksToBounds = YES;
    self.tipView.backgroundColor = [UIColor blueColor];
    self.tipView.hidden = YES;
    [self addSubview:self.tipView];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_left).offset(8);
        make.width.equalTo(@(tipWidth));
        make.height.equalTo(@(tipWidth));
    }];
    
    return self;
}

- (void)setNode:(TKTreeNode *)node{
    _node = node;
    
    __weak __typeof(self) weakSelf = self;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(8 + self.node.depth*TreeNodeOffset);
    }];
}

- (void)setIsShowTip:(BOOL)isShowTip{
    _isShowTip = isShowTip;
    self.tipView.hidden = !isShowTip;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    __weak __typeof(self) weakSelf = self;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(8 + self.node.depth*TreeNodeOffset);
        make.top.right.bottom.equalTo(weakSelf);
    }];
}

@end
