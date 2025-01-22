workspace "Онлайн открытие депозитов" "Диаграммы контекста и контейнеров" {
    model {
        client = person "Client" "Клиент" {
            description "Клиент банка, который работает через интернет-банк"
        }
        newClient = person "New Client" "Новый Клиент" {
            description "Новый клиент банка, который еще не имеет доступ в интернет-банк"
        }

        site = softwareSystem "Site" "Сайт" {

        }

        obs = softwareSystem "Online Banking System" "Интернет-банк" {
            container "Frontend" "Фронтенд" "ASP.NET MVC 4.5" {
                description "Отображает депозиты, принимает заявки."
            }
            container "Backend" "Бэкэнд" "C#" {
                description "Обрабатывает заявки и взаимодействует с АБС."
            }
        }

        cbs = softwareSystem "Core Banking System" "Автоматизированная Банковская Система (АБС)" {
            container "PL/SQL Procedures" "PL/SQL" {
                description "Обработка заявок и согласование ставок."
            }
        }

        ccs = softwareSystem "Call Center System" "Система кол-центра" {
            container "Frontend" "React.js" {
                description "Визуализация заявок для менеджеров."
            }
            container "Backend" "Java Spring Boot" {
                description "Обработка данных и отправка запросов в АБС."
            }
        }

        obs -> cbs "Сохраняет заявки на открытие депозита"
        client -> obs "Создает заявку на открытие депозита"
        site -> cbs "Создает заявку на открытие депозита"
        cbs -> ccs "Создает заявку на звонок клиенту"
        ccs -> cbs "Сохраняет согласованные с клиентом условия"
    }

    views {
        systemContext cbs {
            description "Контекстная диаграмма систем."
            include *
            autolayout lr
        }

        container cbs {
            description "Диаграмма контейнеров интернет-банка."
            include *
            autolayout lr
        }
    }
}