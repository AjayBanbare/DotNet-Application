# Use the official .NET Core SDK as a base image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env

# Set the working directory
WORKDIR /app

# Copy the .csproj files and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the entire project and build the application
COPY . ./

# Debugging information: List files to ensure correct files are copied
RUN ls -la

# Debugging information: Print the contents of bundleconfig.json
RUN cat bundleconfig.json

# Debugging information: Print the contents of other relevant files if needed
# RUN cat <filename>

# Continue with the build process
RUN dotnet publish -c Release -o out

# Build the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expose the port that your application listens on
EXPOSE 80

# Set the entry point for the application
ENTRYPOINT ["dotnet", "MyWebApp.dll"]
