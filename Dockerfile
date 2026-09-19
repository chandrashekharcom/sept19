FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app


FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["sept19.csproj", "./"]
RUN dotnet restore "sept19.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "sept19.csproj" -c $configuration -o /app/build


FROM build AS publish
ARG configuration=Release
RUN dotnet publish "sept19.csproj" -c $configuration -o /app/publish /p:UseAppHost=false


FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "sept19.dll"]
