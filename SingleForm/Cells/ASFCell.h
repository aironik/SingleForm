//
// Created by aironik on 03/08/2017.
// Copyright (c) 2017 aironik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol ASFCellObserver;


@interface ASFCell : UITableViewCell


@property (nonatomic, strong, nullable) NSDictionary *context;

@property (nonatomic, weak) NSObject<ASFCellObserver> *observer;

- (void)valueDidChanged:(NSString *)value;


@end