FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /app

# Copy only the project file and restore dependencies
COPY MyWebApp.csproj .
RUN dotnet restore

# Copy the entire project and build the application
COPY . ./

# Debugging information: List files to ensure correct files are copied
RUN ls -la

# Debugging information: Print the contents of bundleconfig.json
RUN cat bundleconfig.json

# Update BuildBundlerMinifier to version 3.2.449
RUN dotnet add package BuildBundlerMinifier --version 3.2.449

# Continue with the build process
RUN dotnet publish -c Release -o out -p:ProjectName=MyWebApp.csproj

FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app

COPY --from=build-env /app/out .

# Expose the port that your application listens on
EXPOSE 80

# Set the entry point for the application
ENTRYPOINT ["dotnet", "MyWebApp.dll", "--environment", "Production"]
