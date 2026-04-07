# BharatTesting Utilities - Vercel Dockerfile for Flutter Web Build

FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
ENV FLUTTER_VERSION=3.29.0
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
    | tar -xJ -C /opt \
    && flutter config --enable-web --no-analytics

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Build the app
RUN cd core && flutter pub get && cd ..
RUN cd app && flutter pub get
RUN cd app && dart run build_runner build --delete-conflicting-outputs
RUN cd app && flutter build web --release --web-renderer canvaskit --base-href /

# Output directory
FROM scratch AS export-stage
COPY --from=0 /app/app/build/web /