#!/bin/sh
#
# If ROOT_URL is not set, default to https://appname.herokuapp.com.
#
echo "-----> Adding profile script to resolve ROOT_URL from heroku app name"
cat > "$APP_CHECKOUT_DIR"/.profile.d/root_url.sh <<EOF
  #!/bin/bash
    export MONGO_URL=\${MONGO_URL:-`ruby -e "require 'json'; puts JSON.parse(ENV['VCAP_SERVICES']).find { |key,value| value[0]['credentials']['url'].start_with? 'mongodb' }[1][0]['credentials']['url']"`}

  #if [ -z "\$ROOT_URL" ] && [ -n "\$HEROKU_APP_NAME" ] ; then
  #  export ROOT_URL="https://${HEROKU_APP_NAME}.herokuapp.com"
  #fi
EOF
