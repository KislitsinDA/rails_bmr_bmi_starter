# Rails BMR/BMI Backend (Dockerized)

Готовый шаблон тестового задания: управление пациентами и врачами, расчёт BMR и BMI, фильтрация и пагинация.
Проект сам **генерирует Rails API** внутри контейнера при первом запуске и накатывает весь нужный код.

## Быстрый старт

1) Установите Docker и Docker Compose.
2) Создайте `.env` (или используйте уже лежащий по умолчанию):
```
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=clinic_development
```
3) Запустите:
```
docker-compose up --build
```
После первого запуска приложение поднимется на `http://localhost:3000`.

### Полезные запросы

- Создать пациента:
```
POST http://localhost:3000/patients
{ "patient": { "first_name":"Ivan","last_name":"Ivanov","middle_name":"Ivanovich","birthday":"1990-01-01","gender":"male","height":180,"weight":80,"doctor_ids":[1] } }
```

- Список пациентов с фильтрами и пагинацией:
```
GET /patients?full_name=ivan&gender=male&start_age=25&end_age=40&limit=10&offset=0
```

- Рассчитать BMR:
```
POST /patients/:id/bmr_calculate?formula=mifflin
или
POST /patients/:id/bmr_calculate?formula=harris
```

- История BMR:
```
GET /patients/:id/bmr_history?limit=20&offset=0
```

- BMI через внешний API (есть локальный фоллбек):
```
GET /patients/:id/bmi
```

## Структура
- `docker-compose.yml` — сервисы `db` (Postgres) и `web` (Rails).
- `entrypoint.sh` — на первом запуске создаёт Rails API, модели/контроллеры/миграции, применяет наш код.
- `bootstrap/` — исходники, которые копируются внутрь приложения.

## Тесты
Проект устанавливает `rspec-rails`, вы можете дописать тесты и запускать их так:
```
docker compose exec web bundle exec rspec
```

## GitHub
Инициализируйте репозиторий и отправьте код:
```
git init
git add .
git commit -m "Initial commit: Rails BMR/BMI via Docker bootstrap"
git branch -M main
git remote add origin <YOUR_REPO_URL>
git push -u origin main
```
