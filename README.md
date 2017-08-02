# Тестовое задание Тануки.

Одностраничное приложение для отправки заказа:
На странице должна присутствовать форма с полями:

* Имя (```data.sender.name```)
* Email (игнорируется)
* Телефон (```data.sender.phone```)
* Улица (```data.deliveryAddress.street```)
* Дом (```data.deliveryAddress.house```)
* Квартира (```data.deliveryAddress.apartment```)
* Способ оплаты (```data.paymentMethod```):
    * ```payment_encash``` - Нналичными;
    * ```payment_card_restaurant``` Картой курьеру
* Комментарий (```data.comments```)
* Кол-во персон (```data.persons```)
* Кол-во товаров (```data.orderItems[0].amount```)
* Кнопка отправить заказ

При нажатии кнопки отправить заказ должна происходить валидация полей:

1. E-mail
2. Телефон (формат: +7 (555) 555-55-55)
3. Способ оплаты (наличные, картой курьеру)
4. Кол-во персон (не больше 10)
5. Кол-во товаров (больше 0)

Если валидация не прошла, должен показываться алерт с соответствующей информацией и подсветкой полей которые не прошли валидацию.

Если валидация прошла успешно нужно сформировать и отправить POST запрос на адрес: https://dev.tanuki.ru/iphone/services/json/

После получения положительного ответа должны отобразиться номер заказа и введенная информация. Так же должна быть кнопка "Отправить другой заказ", которая будет возвращать к первому экрану.

При получении ответа с ошибкой нужно показать алерт с сообщением из ответа.

#### Пример запроса

```POST https://dev.tanuki.ru/iphone/services/json/ HTTP/1.1
Content-Type: application/x-www-form-urlencoded
User-Agent: Tanuki/Test_app

jsonData={
  "data" : {
    "deliveryType" : "deliveryTypeRegular", //значение не меняется
    "comments" : <КОММЕНТАРИЙ>,
    "orderItems" : [
      {
        "amount" : <КОЛ-ВО ТОВАРОВ>,
        "itemId" : "9", //значение не меняется
        "price" : 110, //значение не меняется
      }
    ],
    "persons" : <КОЛ-ВО ПЕРСОН>,
    "paymentMethod" : <СПОСОБ ОПЛАТЫ>, // (payment_encash - Наличными, payment_card_restaurant - Картой курьеру)
    "notificationType" : "СМС оповещение", //значение не меняется
    "deliveryAddress" : {
      "cityId" : "1", //значение не меняется
      "street" : <УЛИЦА>,
      "house" : <ДОМ>,
      "apartment" : <КВАРТИРА>
    },
    "sender" : {
      "name" : <ИМЯ>,
      "phone" : <ТЕЛЕФОН>
    }
  },
  "method" : {
    "name" : "makeOrder",
    "mode" : "getData",
    "mtime" : 0
  }, //значение не меняется
  "header" : {
    "version" : "9.9.9", //значение не меняется
    "userId" : <UDID>
  }
}
```

#### Пример положительного ответа

```
{
   "Response":{
      "method":"makeOrder",
      "Result":{
         "code":0,
         "message":"makeOrder"
      }
   },
   "ResponseBody":{
      "ValidationResults":{
         "Result":1
      },
      "OrderInfo":{
         "orderNumber":<НОМЕР ЗАКАЗА>,
         "messageTitle":<НОМЕР ЗАКАЗА>,
         "message":<СООБЩЕНИЕ>,
         "creationDate":<ДАТА СОЗДАНИЯ(unix timestamp)>
      }
   }
}
```

#### Пример ответа с ошибкой

```
{
   "Response":{
      "method":"makeOrder",
      "Result":{
         "code":0,
         "message":"makeOrder"
      }
   },
   "ResponseBody":{
      "ValidationResults":{
         "Result":0,
         "Errors":[
            {
               "Code":<ERROR CODE>,
               "Message":<ERROR MESSAGE>
            }
         ]
      }
   }
}
```

Макетов экранов нет. Оформление форм остается на Вас. Важно чтоб формы и алерты выглядели аккуратно.
