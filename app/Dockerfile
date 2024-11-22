FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

#RUN flutter build windows --release

#FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2019

WORKDIR /app
COPY --from=build /app/build/windows/runner/Release .

EXPOSE 8080
CMD ["dart", "/bin/server"]

#ENTRYPOINT ["SiteReady.exe"]