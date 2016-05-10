//
//  TKTreeNode.m
//  TKTreeViewDemo
//
//  Created by 谭柯 on 16/5/9.
//  Copyright © 2016年 Tank. All rights reserved.
//

#import "TKTreeNode.h"

@implementation TKTreeNode

- (NSMutableArray *)childNodes{
    if (!_childNodes) {
        _childNodes = [NSMutableArray new];
    }
    return _childNodes;
}

+ (TKTreeNode *)nodeWithTitle:(NSString *)title id:(NSString *)id parentId:(NSString *)parentId leaf:(BOOL)leaf{
    TKTreeNode *node = [TKTreeNode new];
    
    node.title = title;
    node.id = id;
    node.parentId = parentId;
    node.isLeaf = leaf;
    
    return node;
}

@end
