workspace "Онлайн открытие депозитов" "Диаграммы контекста и контейнеров" {
    !identifiers hierarchical

    model {
        client = person "Клиент" {
            description "Клиент банка, который работает через интернет-банк"
        }
        newClient = person "Новый Клиент" {
            description "Новый клиент банка, который еще не имеет доступ в интернет-банк"
        }
        mcs = person "Менеджер кол-центра" {
            description "Менеджер выполняющий обзвон клиентов"
        }
        mbo = person "Менеджер бэк-офиса" {
            description "Менеджер фиксирующий ставки по депозитам"
        }
        mfo = person "Менеджер фронт-офиса" {
            description "Менеджер работающий с клиентом в отделении"
        }

        site = softwareSystem "Site" "Сайт" {
            front = container "Frontend" "Фронтенд" "React.js" {
                description "Отображает депозиты, принимает заявки."
            }

            back = container "Backend" "Бэкэнд" "PHP" {
                description "Обрабатывает заявки и взаимодействует с АБС."
            }

            front -> back "REST API"
        }

        obs = softwareSystem "Online Banking System" "Интернет-банк" {
            front = container "Frontend" "Фронтенд" "ASP.NET MVC 4.5" {
                description "Отображает депозиты, принимает заявки."
            }

            back = container "Backend" "Бэкэнд" "C#" {
                description "Обрабатывает заявки и взаимодействует с АБС."
            }

            front -> back "REST API"
        }

        cbs = softwareSystem "Core Banking System" "Автоматизированная Банковская Система (АБС)" {
            db = container "DataBase" "Oracle" {
                description "Обработка заявок и согласование ставок. Основная логика работы системы реализована процедурами на PL-SQL."
            }
            client = container "Desktop client" "Delphi" {
                description "Десктопный клиент для работы с АБС"
            }
            deposits = container "Deposits Service" "C#" {
                description "Сервис интеграции для депозитов"
            }

            client -> db "PL/SQL"
            deposits -> db "PL/SQL"
        }

        ccs = softwareSystem "Call Center System" "Система кол-центра" {
            front = container "Frontend" "React.js" {
                description "Визуализация заявок для менеджеров."
            }
            back = container "Backend" "Java Spring Boot" {
                description "Обработка данных и отправка запросов в АБС."
            }
        }

        sms_gateway = softwareSystem "SMS Gateway" {
            description "SMS шлюз"
        }
        telecom = softwareSystem "Телеком оператор"

        client -> obs.front "Создает заявку на открытие депозита"
        newClient -> site.front "Создает заявку на открытие депозита"
        mbo -> cbs.client "Обрабатывает заявки на открытие депозита"
        mfo -> cbs.client "Идентифицирует клиента и открывает депозит"
        mcs -> ccs.front "Обрабатывает заявку на звонок клиенту"

        obs.back -> cbs.deposits "Сохраняет заявки на открытие депозита" "REST API"
        site.back -> cbs.deposits "Сохраняет заявку на открытие депозита" "REST API"
        cbs.deposits -> ccs.back "Создает заявку на звонок клиенту" "REST API"
        ccs.back -> cbs.deposits "Сохраняет согласованные с клиентом условия" "REST API"
        cbs.db -> sms_gateway "Отправляет SMS"
        sms_gateway -> telecom "Отправляет SMS"
    }

    views {
        theme default

        systemLandscape {
            include *
            autoLayout tb
        }

        container obs {
            include *
            autoLayout tb
        }

        container cbs {
            include *
            autoLayout tb
        }

        container site {
            include *
            autoLayout tb
        }
    }
}