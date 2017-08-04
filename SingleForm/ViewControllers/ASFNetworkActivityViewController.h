//
// Created by aironik on 03/08/2017.
// Copyright (c) 2017 aironik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class ASFOrder;


@interface ASFNetworkActivityViewController : UIViewController

@property (nonatomic, weak, nullable) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak, nullable) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong, readonly, nullable) ASFOrder *order;

- (void)sendOrder:(ASFOrder *)order;

- (void)handleResultData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error;

@end
