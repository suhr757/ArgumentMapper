FROM repo.something:10500/something/dotnet/core/sdk_2.2.105-alpine3.9:0.0.3 AS build

ARG NUGET_USERNAME
ARG NUGET_PASSWORD

WORKDIR /app
# copy csproj and restore as distinct layers
COPY docker/nuget.config .
RUN sed -i "s/{{username}}/${NUGET_USERNAME}/g" nuget.config
RUN sed -i "s/{{password}}/${NUGET_PASSWORD}/g" nuget.config
COPY src/*.sln .
COPY src/ArgumentMapper.Geocoder/*.csproj ./ArgumentMapper.Geocoder/
WORKDIR /app/ArgumentMapper.Api
RUN dotnet restore --configfile ../nuget.config
RUN dotnet publish -c Release -o out
#
#
FROM repo.something:10500/something/dotnet/core/aspnet_2.2.3-alpine3.9:0.0.3 AS runtime
WORKDIR /app
COPY --from=build /app/ArgumentMapper.Api/out ./
COPY docker/entrypoint.sh ./
RUN chmod 755 ./entrypoint.sh && sed -i 's/\r//g' ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
