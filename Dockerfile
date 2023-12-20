FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY SimpleWebAppMVC.csproj .
RUN dotnet restore "SimpleWebAppMVC.csproj"
COPY . .
RUN dotnet publish "SimpleWebAppMVC.csproj" -c Release -o /publish

FROM mcr.microsoft.com/dotnet/aspnet:7.0 as final
WORKDIR /app 
COPY --from=build /publish .

ENTRYPOINT [ "dotnet", "SimpleWebAppMVC.dll" ]
