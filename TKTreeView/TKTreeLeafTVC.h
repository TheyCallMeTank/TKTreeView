//
//  TKBaseTreeLeafTVC.h
//  TKTreeViewDemo
//
//  Created by 谭柯 on 16/5/9.
//  Copyright © 2016年 Tank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKTreeNode.h"

@interface TKTreeLeafTVC : UITableViewCell

@property (nonatomic, strong) TKTreeNode *node;

@property (nonatomic, assign) BOOL isShowTip;

@end
