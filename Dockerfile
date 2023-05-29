FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5272

ENV ASPNETCORE_URLS=http://+:5272

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["davido.csproj", "./"]
RUN dotnet restore "davido.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "davido.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "davido.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "davido.dll"]
