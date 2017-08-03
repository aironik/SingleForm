//
// Created by aironik on 03/08/2017.
// Copyright (c) 2017 aironik. All rights reserved.
//

#import "ASFCell.h"

#import "ASFCellObserver.h"


@implementation ASFCell


- (void)valueDidChanged:(NSString *)value {
    [self.observer cell:self didChangeValue:value context:self.context];
}


@end