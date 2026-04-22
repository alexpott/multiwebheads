FROM php:8.5-apache

# System libraries for PHP extensions + NFS client tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      # NFS
      nfs-common \
      rpcbind \
      # GD (jpeg, png, webp, freetype)
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libpng-dev \
      libwebp-dev \
      # MBstring
      libonig-dev \
      # intl
      libicu-dev \
      # zip
      libzip-dev \
      # xml / simplexml / dom (libxml2 is usually present but make it explicit)
      libxml2-dev \
      # exif (no extra lib needed but keep list readable)
      # ImageMagick for the imagick PECL extension
      libmagickwand-dev \
      imagemagick \
      # misc utilities
      procps \
      unzip \
      default-mysql-client \
 && rm -rf /var/lib/apt/lists/*

# Configure GD with all format support before installing it
RUN docker-php-ext-configure gd \
      --with-freetype \
      --with-jpeg \
      --with-webp

# Install core PHP extensions required/recommended by Drupal
RUN docker-php-ext-install -j"$(nproc)" \
      bcmath \
      exif \
      gd \
      intl \
      mbstring \
      mysqli \
      pdo_mysql \
      xml \
      zip

# APCu — user-space opcode/data cache used by Drupal's cache backends
RUN pecl install apcu \
 && docker-php-ext-enable apcu

# ImageMagick — higher-quality image processing than GD
RUN pecl install imagick \
 && docker-php-ext-enable imagick

# Recommended opcache settings for Drupal
RUN { \
      echo 'opcache.memory_consumption=256'; \
      echo 'opcache.interned_strings_buffer=16'; \
      echo 'opcache.max_accelerated_files=20000'; \
      echo 'opcache.revalidate_freq=0'; \
      echo 'opcache.validate_timestamps=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Enable apache modules.
RUN a2enmod rewrite

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
