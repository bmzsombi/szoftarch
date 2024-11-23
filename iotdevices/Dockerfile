# Use Python 3.9 or later
FROM python:3.9-slim

# Install required system packages
RUN apt-get update && apt-get install -y \
    python3-mysql.connector \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the simulator script
COPY device_simulator.py .

# Set environment variables with defaults
ENV DB_HOST=szoftarch-db \
    DB_PORT=3306 \
    DB_NAME=plant_care \
    DB_USER=user \
    DB_PASSWORD=teszt \
    DEVICE_ID=1 \
    INSTANCE_ID=1

# Command to run the simulator
ENTRYPOINT ["python", "device_simulator.py"]
CMD ["1"]  # Default device ID if none provided
