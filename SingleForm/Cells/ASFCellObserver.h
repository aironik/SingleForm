//
// Created by aironik on 03/08/2017.
// Copyright (c) 2017 aironik. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ASFCell;


@protocol ASFCellObserver<NSObject>

- (void)cell:(ASFCell *)cell didChangeValue:(NSString *)value context:(NSDictionary *)context;

@end