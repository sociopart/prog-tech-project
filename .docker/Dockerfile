# hace referencia a la imagen de ruby que voy a usar version 3.1.2
FROM ruby:3.1.2
# build essential es requerido para compilar paquetes debian y libpq-dev es para postgres
# node-js es nuestro javascript runtime
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
# configura las variables de entorno
ENV RAILS_ROOT /rails_app
# crea el directorio tmp/pids en la raiz (rails_app)
RUN mkdir -p $RAILS_ROOT/tmp/pids
# configura el directorio rails_app como directorio raiz
WORKDIR $RAILS_ROOT
# copia el script startup.sh desde  mi ubicación local a la carpeta opt del contenedor
COPY .docker/startup.sh /opt/startup.sh
# copia el arvhivo gemfile y gemfile.lock
COPY rufans/Gemfile Gemfile
COPY rufans/Gemfile.lock Gemfile.lock
# instalamos bundler en el contenedor
WORKDIR rufans
RUN gem install bundler
# ejecutar bundle install antes de copiar todo el proyecto al contenedor de esta forma
# las gemas instaladas son chacheadas y solo tendras que esperar un momento para ejecutar  bundle install de nuevo
# si el gemfile a cambiado (si agregas mas gemas)
RUN bundle install
# copy todos los archivos de mi aplicacion local a $RAILS_ROOT
COPY . .
