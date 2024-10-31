# Stage 1: Build the application
FROM dart:stable AS build

# Set the working directory inside the container
WORKDIR /app

# Copy only the pubspec.yaml files for server and shared
COPY server/pubspec.yaml server/
COPY shared/pubspec.yaml shared/

# Copy the shared package
COPY shared/ shared/

# Navigate to the server directory
WORKDIR /app/server

# Fetch dependencies (this will generate a new pubspec.lock inside Docker)
RUN dart pub get

# Copy the rest of the server source code
COPY server/ .

# Compile the Dart server application
RUN dart compile exe bin/server.dart -o bin/server

# Stage 2: Create a minimal runtime image
FROM scratch

# Set the working directory
WORKDIR /app/server

# Copy the compiled server from the build stage
COPY --from=build /app/server/bin/server /app/server/bin/server

# Expose the necessary port (adjust as needed)
EXPOSE 8080

# Define the entrypoint
ENTRYPOINT ["./bin/server"]
