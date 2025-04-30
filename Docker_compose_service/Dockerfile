# Node.js 18 для сборки
FROM node:18-alpine

# Рабочая директория в /app
WORKDIR /app

# Копируем package.json
COPY package.json ./

# Провека установки node_modules
RUN if [ ! -d "node_modules" ]; then npm install; fi

# Копируем исходные файлы
COPY ./app/src ./src
COPY ./app/public ./public

# Собираем приложение
RUN npm run build

# Открываем порт 3000 для приложения
EXPOSE 3000

# Команда для запуска приложения
CMD ["npm", "start"]
