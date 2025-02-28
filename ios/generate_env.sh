#!/bin/bash

# Load environment variables from .env file
if [ -f ../.env ]; then
    export $(grep -v '^#' ../.env | xargs)
fi

# Generate the xcconfig file
echo "// Auto-generated file - Do not modify" > GeneratedEnv.xcconfig
echo "GOOGLE_API_CLIENT_ID_URL_SCHEME=$GOOGLE_API_CLIENT_ID_URL_SCHEME" >> GeneratedEnv.xcconfig
