FROM python:3.10

# Install Playwright system dependencies
RUN apt-get update && apt-get install -y \
    libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 \
    libxfixes3 libxrandr2 libgbm1 libasound2 libpangocairo-1.0-0 \
    libpango-1.0-0 libcairo2 libatspi2.0-0 libgtk-3-0 \
    wget gnupg xvfb libxss1 libxtst6 libxshmfence1 fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Python requirements
COPY requirements.txt .
RUN pip install -r requirements.txt

# Install Playwright browsers
RUN python -m playwright install --with-deps

# Copy application code
COPY . .

# Expose Flask port
EXPOSE 5000

# Start server
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
