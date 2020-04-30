# Set the base image
FROM beevelop/ionic:next AS ionic

# Create app directory
WORKDIR /usr/src/app

# Copy package.json AND package-lock.json
COPY ./package*.json ./

# Install all dependencies
RUN npm ci

# Copy the rest of the code
COPY . .

# Build app w/ ionic
RUN npm run build:prod

FROM nginx:alpine
COPY --from=ionic /usr/src/app/www /usr/share/nginx/html
