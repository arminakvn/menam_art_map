# The image is based on the Debian Wheezy distribution.
FROM google/debian:wheezy

# Fetch and install Node.js
RUN apt-get update -y && apt-get install --no-install-recommends -y -q curl python build-essential git ca-certificates
RUN mkdir /nodejs && curl http://nodejs.org/dist/v0.10.29/node-v0.10.29-linux-x64.tar.gz | tar xvzf - -C /nodejs --strip-components=1


# Add Node.js installation to PATH, and set
# the current working directory to /app
# so future commands in this Dockerfile are easier to write
ENV PATH $PATH:/nodejs/bin
WORKDIR /app


# Copy the file package.json from your app's /app directory to the Docker
# image. (See note below regarding image caching and dependencies.)
ADD package.json /app/

# Run npm (node’s package manager) to install packages specified in
# package.json
RUN npm install

# Adds the rest of the application source. Since this is a node.js app
ADD . /app

# No further source transformations are performed.
# It is possible to install and run additional tooling such as CSS
# minifiers.

# Specify that npm start is the process that will run in the Docker container. The app should listen on port 8080.
ENTRYPOINT ["/nodejs/bin/npm", "start"]