
# Use an official Ubuntu runtime as the base image
FROM ubuntu:18.04

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install Python and pip
RUN apt-get update && apt-get install -y python3=3.6 python3-pip=9.0.1 \
    && rm -rf /var/lib/apt/lists/*

# Install any needed packages specified in requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Set the entry point to run the application
CMD ["python3", "app.py"]
