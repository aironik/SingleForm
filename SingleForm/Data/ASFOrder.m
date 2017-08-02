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
                        @"paymentMethod": @"",      // <СПОСОБ ОПЛАТЫ> (payment_encash - Наличными, payment_card_restaurant - Картой курьеру)
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
    return [self.data valueForKeyPath:keyPath];
}

- (void)setString:(NSString *)string forKeyPath:(NSString *)keyPath {
    [self.data setValue:string forKey:keyPath];
}

@end
