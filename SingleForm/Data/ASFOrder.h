//
// Created by aironik on 02/08/2017.
// Copyright (c) 2017 aironik. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ASFOrder : NSObject

// -valueForKeyPath: reserved for KVC (NSObject). So use other name.
/// @brief get data for keypath for specified JSON-value.
- (NSString *)stringForKeyPath:(NSString *)keyPath;

/// @brief set data for keypath for specified JSON-value.
/// If keypath does not represent valid data this method do nothing.
- (void)setString:(NSString *)string forKeyPath:(NSString *)keyPath;

/// @brief Return dictionary representation for serialize into JSON
- (NSDictionary *)dictionaryValue;

@end