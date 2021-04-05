FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /app

# Configure Envrionment
ENV ASPNETCORE_ENVIRONMENT "Development"
EXPOSE 5000

COPY AS.Redis.Connector/*.csproj ./AS.Redis.Connector/
RUN dotnet restore AS.Redis.Connector/AS.Redis.Connector.csproj

COPY AS.Redis.Connector/. ./AS.Redis.Connector/
RUN dotnet publish AS.Redis.Connector/AS.Redis.Connector.csproj -c Release -o connector

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS run
WORKDIR /app
COPY --from=build /app/connector .

# Execute
ENTRYPOINT ["dotnet", "AS.Redis.Connector.dll"]



FROM build AS build1
WORKDIR /app

# Configure Envrionment
ENV ASPNETCORE_ENVIRONMENT "Development"
EXPOSE 5000

COPY AS.Redis.Connector.Test/*.csproj ./AS.Redis.Connector.Test/
RUN dotnet restore AS.Redis.Connector.Test/AS.Redis.Connector.Test.csproj

COPY AS.Redis.Connector.Test/. ./AS.Redis.Connector.Test/
RUN dotnet publish AS.Redis.Connector.Test/AS.Redis.Connector.Test.csproj -c Release -o test

FROM run AS run1
WORKDIR /app
COPY --from=build1 /app/test .

# Execute
ENTRYPOINT ["dotnet", "AS.Redis.Connector.Test.dll"]
