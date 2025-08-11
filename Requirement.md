по любым вопросам в тг https://t.me/+C-J9LQ7ayt84NDdi
задание отправлять в этот чат 

Бизнес-логика
UI: в ссылке фигма https://www.figma.com/design/14YHeEJNOiTvcyhYT4v5VF/Untitled?node-id=0-1&t=s5Iqve46KfIR6HpH-1


Мы создаём интерфейс для быстрого получения павербанка пользователем через веб-интерфейс. 
Сценарий:
Пользователь сканирует QR-код на станции.
Его перенаправляют в web-интерфейс.
Пользователь оплачивает (Apple Pay или карта).
После успешной оплаты срабатывает механизм выдачи павербанка .

User Flow
QR скан → Переход на web→ Экран оплаты → Подтверждение успешной оплаты → выдача павербанка


Архитектура
Создать проект, который содержит два экрана:
1. Экран оплаты (PaymentScreen):
Получает ID станции через deep link 
Предлагает пользователю оплатить аренду через Apple Pay или карту.
Отправляет запрос на создание аренды.
После успешной оплаты показывает лоадер, подтверждает выдачу павербанка.

2. Экран подтверждения (SuccessScreen):
Подтверждает пользователю, что павербанк выдан
и ссылка на приложение 


API-эндпоинты
Полное описание всех методов доступно в Swagger:
https://goldfish-app-3lf7u.ondigitalocean.app/swagger-ui/index.html#/

Ключевые эндпоинты:
/api/v1/auth/apple/generate-account - создать аккаунт
/api/v1/payments/generate-and-save-braintree-client-token - получить braintree токен
/api/v1/payments/add-payment-method - добавить payment метод
/api/v1/payments/subscription/create-subscription-transaction-v2?disableWelcomeDiscount=false&welcomeDiscount=10 - оформить подписку
 body: {
        'paymentToken': paymentToken,
        'thePlanId': ‘tss2’,
      },
/api/v1/payments/rent-power-bank - арендовать повербанк


Пример ID станции: RECH082203000350
(можно использовать как тестовый)

Функциональные требования
Flutter 3.10+

UI: в ссылке фигма https://www.figma.com/design/14YHeEJNOiTvcyhYT4v5VF/Untitled?node-id=0-1&t=s5Iqve46KfIR6HpH-1
