//
//  TKTreeNode.h
//  TKTreeViewDemo
//
//  Created by 谭柯 on 16/5/9.
//  Copyright © 2016年 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

const static NSInteger TreeNodeOffset = 16;

@interface TKTreeNode : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, strong) NSMutableArray *childNodes;
@property (nonatomic, weak) TKTreeNode *parentNode;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger depth;
@property (nonatomic, assign) NSInteger sortId;

@property (nonatomic, strong) NSObject *dataObject;

@property (nonatomic, assign) BOOL isLeaf;
@property (nonatomic, assign) BOOL isExpand;

+ (TKTreeNode *)nodeWithTitle:(NSString *)title id:(NSString *)id parentId:(NSString *)parentId leaf:(BOOL)leaf;

@end
