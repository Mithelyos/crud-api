# Stage 1: Builder stage
FROM python:3.10-slim as builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy only requirements to leverage docker's caching mechanism
COPY requirements.txt .

# Install dependencies to a temporary location
RUN pip install --user --no-cache-dir -r requirements.txt



# Stage 2: Runtime stage
FROM python:3.10-slim 

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the project content
COPY . .

# Copy the dependencies from the temp location
COPY --from=builder /root/.local /root/.local

# Set Flask-specific environment variables
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=500

# Update Path to 
ENV PATH="/root/.local/bin:$PATH"

EXPOSE 5000

# Default command to start the app
CMD ["flask", "run", "--host", "0.0.0.0", "--port", "5000"]
