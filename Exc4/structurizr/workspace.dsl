workspace "Передача ставок в кол-центры" "Диаграммы контекста и контейнеров" {
    !identifiers hierarchical

    model {
        mcs = person "Менеджер кол-центра" {
            description "Менеджер принимающий звонки клиентов"
        }
        mpcs = person "Менеджер партнерского кол-центра" {
            description "Менеджер принимающий звонки клиентов"
        }

        cbs = softwareSystem "Core Banking System" "Автоматизированная Банковская Система (АБС)" {
            db = container "DataBase" "Oracle" {
                description "Обработка заявок и согласование ставок. Основная логика работы системы реализована процедурами на PL-SQL."
            }
            deposits = container "Deposits Service" "C#" {
                description "Сервис интеграции для депозитов"
            }

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

        pccs = softwareSystem "Partner Call Center System" "Система партнёрского кол-центра"

        mpcs -> pccs "Обработка звонков клиентов"
        mcs -> ccs.front "Обработка звонков клиентов"

        cbs.deposits -> ccs.back "Автоматическая передача данных о ставках раз в день" "REST API"
        ccs.back -> cbs.deposits "Получение персональных ставок клиента" "REST API"
        cbs.deposits -> pccs "Автоматическая передача данных о ставках" "email"
    }

    views {
        theme default

        systemLandscape {
            include *
            autoLayout tb
        }

        container cbs {
            include *
            autoLayout tb
        }
    }
}