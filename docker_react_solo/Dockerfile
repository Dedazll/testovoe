# Node.js 18 для сборки
FROM node:18-alpine as builder

# Рабочая директория в /app
WORKDIR /app

# Копируем package.json
COPY package.json ./

# Провека установки node_modules
RUN if [ ! -d "node_modules" ]; then npm install; fi

# Копируем исходные файлы из app/src в src/
# иначе react-scripts ругается на структуру если делать COPY . .
COPY ./app/src ./src
COPY ./app/public ./public

# Копируем конфиг nginx'a
COPY default.conf ./

# Собираем приложение
RUN npm run build

# Nginx для запуска
FROM nginx:alpine

# Копируем конфигурацию nginx из промежуточной сборки
COPY --from=builder /app/default.conf /etc/nginx/conf.d/default.conf

# Удаляем дефолтную страницу nginx
RUN rm -rf /usr/share/nginx/html/*

# Копируем собранное приложение из промежуточной сборки
COPY --from=builder /app/build /usr/share/nginx/html

# Добавляем healthcheck для проверки web'a
# проверяем только код ответа
HEALTHCHECK --interval=60s --timeout=3s \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Открываем порт 80 для nginx'a
EXPOSE 80

# Команда для запуска nginx'а в PID 1
# без фонового режима для жизни контейнера
CMD ["nginx", "-g", "daemon off;"]


# Команда для сборки:
# docker build -t react-app .

# Команда для запуска в solo:
# docker run -d -p 80:80 react-app

# Просмотр логов:
# docker logs < название/id контейнера>
