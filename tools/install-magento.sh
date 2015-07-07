#!/bin/bash -xe

main() {
  install_magento
  validate
}

mysql() {
  command mysql --host=db_1 \
  --user="$DB_1_ENV_MYSQL_USER" \
  --password="$DB_1_ENV_MYSQL_PASSWORD" \
  --database="$DB_1_ENV_MYSQL_DATABASE" \
  "$@"
}

is_db_up() {
  local -i counter="$1"
  while (( counter-- > 0 )); do
    mysql -e 'SELECT 1\g' &> /dev/null && return
    sleep 1
  done
  return 1
}

install_magento() {
  local db_timeout=15 # Seconds to wait for db to come up
  cd /srv/magento/htdocs
  is_db_up "$db_timeout"
  if [[ ! -f app/etc/local.xml ]]; then
    php install.php \
    --admin_email "$MAGENTO_ADMIN_EMAIL" \
    --admin_firstname "$MAGENTO_ADMIN_LASTNAME" \
    --admin_lastname "$MAGENTO_ADMIN_LASTNAME" \
    --admin_password "$MAGENTO_ADMIN_PASSWORD" \
    --admin_username "$MAGENTO_ADMIN_USERNAME" \
    --db_host db_1 \
    --db_name "$DB_1_ENV_MYSQL_DATABASE" \
    --db_pass "$DB_1_ENV_MYSQL_PASSWORD" \
    --db_user "$DB_1_ENV_MYSQL_USER" \
    --default_currency "$MAGENTO_DEFAULT_CURRENCY" \
    --license_agreement_accepted yes \
    --locale "$MAGENTO_LOCALE" \
    --secure_base_url "http://${MAGENTO_HOST-example.com}/" \
    --skip_url_validation yes \
    --timezone "$MAGENTO_TIMEZONE" \
    --url "http://${MAGENTO_HOST-example.com}/" \
    --use_rewrites yes \
    --use_secure no \
    --use_secure_admin no
  fi

  mkdir -p media var/cache var/session var/full_page_cache
  chown -R :www-data media var
  chmod -R g+sw media var

  if [[ ! $MAGENTO_HOST ]]; then
    # No base url was specified, so disable redirecting to base url.
    magerun config:delete "web/unsecure/base_url"
    magerun config:delete "web/secure/base_url"
  fi

  # Enable Solr search engine
  magerun config:set "catalog/search/engine" "enterprise_search/engine"
  magerun config:set "catalog/search/solr_server_port" "$SOLR_PORT"
  magerun config:set "catalog/search/solr_server_hostname" "search_1"

  magerun cache:disable config
  magerun dev:log --on --global
  magerun dev:symlinks --on --global
  magerun index:reindex:all

  # if cd errors && [[ ! -f local.xml ]]; then
  #   ln -s local.xml.sample local.xml
  # fi
}

magerun() {
  n98-magerun --skip-root-check "$@"
}

validate() {
  cd /srv/magento/htdocs && magerun sys:check
}

main
