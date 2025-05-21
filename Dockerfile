# Use the official Alpine image as a base
FROM node:20-alpine
# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Change ownership of the application directory
RUN chown -R appuser:appgroup /usr/src/app
RUN echo "AZURE_CLIENT_ID=037aa433-b922-4829-224d-98945ecd52fe\n// AZURE_CLIENT_SECRET=W4I8Q~2FXXNrvznED1uR2Rv-SYmGCE5kgBgXodq7" > /usr/src/app/azure-creds.txt

# Switch to the non-root user
USER appuser

# Expose the port the app runs on
EXPOSE 3000

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/ || exit 1

# Define the command to run the app
CMD ["node", "app.js"]

