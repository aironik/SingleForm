//
// Created by aironik on 03/08/2017.
// Copyright (c) 2017 aironik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ASFOptionsViewController : UITableViewController

@property (nonatomic, strong, nullable) NSArray<NSDictionary<NSString *, NSString *> *> *options;
@property (nonatomic, copy, nullable) NSString *currentValue;
@property(nonatomic, copy) void (^selectAction)(NSString *);

@end
