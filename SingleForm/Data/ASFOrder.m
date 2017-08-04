//
// Created by aironik on 02/08/2017.
// Copyright (c) 2017 aironik. All rights reserved.
//

#import "ASFOrder.h"


@interface ASFOrder()

@property (nonatomic, strong, nonnull, readonly) NSDictionary *data;
@end


#pragma mark - Implementation

@implementation ASFOrder


@synthesize data = _data;


- (instancetype)init {
    if (self = [super init]) {
        _data = @{
                @"data": [@{
                        @"deliveryType": @"deliveryTypeRegular",
                        @"comments": @"",      // <КОММЕНТАРИЙ>
                        @"orderItems": @[
                                [@{
                                        @"amount": @"",     // <КОЛ-ВО ТОВАРОВ>,
                                        @"itemId": @"9",
                                        @"price": @110,
                                } mutableCopy]
                        ],
                        @"persons": @"",            // <КОЛ-ВО ПЕРСОН>,
                        @"paymentMethod": @"payment_encash",        // <СПОСОБ ОПЛАТЫ> (payment_encash - Наличными, payment_card_restaurant - Картой курьеру)
                        @"notificationType": @"СМС оповещение",
                        @"deliveryAddress": [@{
                                @"cityId": @"1",
                                @"street": @"",     // <УЛИЦА>,
                                @"house": @"",      // <ДОМ>,
                                @"apartment": @""   // <КВАРТИРА>
                        } mutableCopy],
                        @"sender": [@{
                                @"name": @"",       // <ИМЯ>,
                                @"phone": @""       // <ТЕЛЕФОН>
                        } mutableCopy]
                } mutableCopy],
                @"method": @{
                        @"name": @"makeOrder",
                        @"mode": @"getData",
                        @"mtime": @0
                },
                @"header": @{
                        @"version": @"9.9.9",
                        @"userId": [[NSUUID UUID] UUIDString]
                }
        };
    }
    return self;
}

- (NSString *)stringForKeyPath:(NSString *)keyPath {
    __block id data = self.data;
    NSArray *keyComponents = [keyPath componentsSeparatedByString:@"."];
    [keyComponents enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *key = obj;
        if ([key containsString:@"["]) {
            NSAssert(idx < keyComponents.count - 1, @"Last array doesn't support. TODO:");
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(^)(.+)(\\[)(\\d+)(\\]$)"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:NULL];
            NSArray<NSTextCheckingResult *> *r = [regex matchesInString:key options:NSMatchingAnchored range:NSMakeRange(0, key.length)];
            if (r.count == 1 && r[0].numberOfRanges == 6) {
                NSString *indexString = [key substringWithRange:[r[0] rangeAtIndex:4]];
                NSString *key2 = [key substringWithRange:[r[0] rangeAtIndex:2]];
                
                data = [data valueForKeyPath:key2];
                data = [data objectAtIndex:[indexString integerValue]];
            }
        }
        else {
            data = [data valueForKeyPath:key];
        }
    }];
    return data;
}

- (void)setString:(NSString *)string forKeyPath:(NSString *)keyPath {
    // TODO: get rid copy-past code
    __block id data = self.data;
    NSArray *keyComponents = (keyPath.length > 0 ? [keyPath componentsSeparatedByString:@"."] : nil);
    [keyComponents enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *key = obj;
        if ([key containsString:@"["]) {
            NSAssert(idx < keyComponents.count - 1, @"Last array doesn't support. TODO:");
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(^)(.+)(\\[)(\\d+)(\\]$)"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:NULL];
            NSArray<NSTextCheckingResult *> *r = [regex matchesInString:key options:NSMatchingAnchored range:NSMakeRange(0, key.length)];
            if (r.count == 1 && r[0].numberOfRanges == 6) {
                NSString *indexString = [key substringWithRange:[r[0] rangeAtIndex:4]];
                NSString *key2 = [key substringWithRange:[r[0] rangeAtIndex:2]];
                
                data = [data valueForKeyPath:key2];
                data = [data objectAtIndex:[indexString integerValue]];
            }
        }
        else {
            const BOOL isLast = (idx == keyComponents.count - 1);
            if (isLast) {
                [data setValue:string forKeyPath:key];
            }
            else {
                data = [data valueForKeyPath:key];
            }
        }
    }];
}

- (NSDictionary *)dictionaryValue {
    return self.data;
}

@end
