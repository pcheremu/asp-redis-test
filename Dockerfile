FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /app
# Configure Envrionment
#ENV ASPNETCORE_URLS http://+:5000
ENV ASPNETCORE_ENVIRONMENT "Development"
EXPOSE 5000
#ENV REDIS_CONNECTIONSTRING localhost:6379,

COPY AS.Redis.Connector/*.csproj ./
RUN dotnet restore

COPY AS.Redis.Connector/. ./
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:3.1
WORKDIR /app
COPY --from=build /app/out .

# Execute
ENTRYPOINT ["dotnet", "AS.Redis.Connector.dll"]

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /app
# Configure Envrionment
#ENV ASPNETCORE_URLS http://+:5000
ENV ASPNETCORE_ENVIRONMENT "Development"
EXPOSE 5000
#ENV REDIS_CONNECTIONSTRING localhost:6379,

COPY AS.Redis.Connector.Test/*.csproj ./
RUN dotnet restore

COPY AS.Redis.Connector.Test/. ./
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:3.1
WORKDIR /app
COPY --from=build /app/out .

# Execute
ENTRYPOINT ["dotnet", "AS.Redis.Connector.Test.dll"]
