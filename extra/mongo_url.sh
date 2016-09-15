#!/bin/sh
#
# If MONGO_URL is not specified, try the following in order:
#
# - MONGODB_URI: current default for mongolab addon
# - MONGOLAB_URI: old default for mongolab addon
# - MONGOHQ_URL: old default for mongohq addon
#
echo "-----> Adding profile script to resolve MONGO_URL from mongolab addon"
cat > "$APP_CHECKOUT_DIR"/.profile.d/mongo_url.sh <<EOF
  #!/bin/bash

  if [ -z \$MONGO_URL ] ; then
  echo "exporting MONGO_URL"

    export MONGO_URL=\${MONGO_URL:-`ruby -e "require 'json'; puts JSON.parse(ENV['VCAP_SERVICES']).find { |key,value| value[0]['credentials']['url'].start_with? 'mongodb' }[1][0]['credentials']['url']"`}

 #   export MONGO_URL=\${MONGODB_URI:-\${MONGOLAB_URI:-\$MONGOHQ_URL}}
  fi
  if [ -z \$MONGO_URL ] ; then
    echo "meteor-buildpack-horse: MONGO_URL missing, you must define it for meteor to work."
  fi
EOF
