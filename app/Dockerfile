FROM dart:stable

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN flutter build windows --release

FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2019

WORKDIR /app
COPY --from=build /app/build/windows/runner/Release .

ENTRYPOINT ["SiteReady.exe"]