# Этап сборки: установка зависимостей
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Финальный образ: минимальный, non-root
FROM python:3.11-slim

# Создаем непривилегированного пользователя
RUN useradd -m -u 1000 appuser

WORKDIR /app

# Копируем установленные пакеты из builder
COPY --from=builder /root/.local /home/appuser/.local
COPY app.py .
COPY products.json .

# Настраиваем PATH для пользовательских пакетов
ENV PATH=/home/appuser/.local/bin:$PATH

# Переключаемся на непривилегированного пользователя
USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
