#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

# 1. Build image(https://hub.docker.com/_/microsoft-dotnet-core-sdk/)
FROM mcr.microsoft.com/dotnet/sdk:6.0.100-alpine3.14-amd64 AS build
WORKDIR /src

# Cache nuget restore
COPY ["src/WebApp/WebApp.csproj", "src/WebApp/"]
RUN dotnet restore "src/WebApp/WebApp.csproj"

# Copy sources and compile
COPY . .
WORKDIR "/src/src/WebApp"
RUN dotnet build "WebApp.csproj" -c Release -o /app/build
RUN dotnet publish "WebApp.csproj" -c Release -o /app/publish

# 2. Release image
FROM mcr.microsoft.com/dotnet/aspnet:6.0.0-alpine3.14-amd64 as release
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Copy content from Build image
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "WebApp.dll"]
