FROM mcr.microsoft.com/dotnet/framework/runtime:3.5-windowsservercore-ltsc2019
SHELL ["powershell"]

ADD https://www.7-zip.org/a/7z1900-x64.exe /temp/download/7z.exe
ADD http://altd.embarcadero.com/download/radstudio/10.1/delphicbuilder10_1.iso /temp/download/delphicbuilder10_1.iso

COPY DockerBuild/extract.ps1 /temp/download/extract.ps1
COPY DockerBuild/copy.ps1 /temp/download/copy.ps1
COPY DockerBuild/EnvOptions.proj /temp/download/EnvOptions.proj

RUN Set-ExecutionPolicy -ExecutionPolicy Unrestricted; \
    Start-Process -Wait -NoNewWindow -FilePath 'C:\temp\download\7z.exe' -ArgumentList '/S'; \
    Remove-Item /temp/download/7z.exe; \
    Start-Process -Wait -NoNewWindow -FilePath 'C:\Program Files\7-Zip\7z.exe' -ArgumentList 'x', '-oC:\temp\download\radstudio', '-r', 'C:\temp\download\delphicbuilder10_1.iso'; \
    Remove-Item /temp/download/delphicbuilder10_1.iso; \
    cd /temp/download/radstudio/Install; \
    /temp/download/extract.ps1; \
    cd /temp; \
    Remove-Item -Recurse -Force /temp/download/radstudio; \
    /temp/download/copy.ps1; \
    Remove-Item -Recurse -Force /temp/download;

COPY ClipboardTransform /temp/app
WORKDIR /temp/app

RUN $env:BDS = 'C:\Program Files (x86)\Embarcadero\Studio\18.0'; \
    $env:BDSBIN = 'C:\Program Files (x86)\Embarcadero\Studio\18.0\bin'; \
    $env:BDSCOMMONDIR = 'C:\Users\Public\Documents\Embarcadero\Studio\18.0'; \
    $env:BDSINCLUDE = 'C:\Program Files (x86)\Embarcadero\Studio\18.0\include'; \
    $env:BDSLIB = 'C:\Program Files (x86)\Embarcadero\Studio\18.0\lib'; \
    $env:FrameworkDir = 'C:\Windows\Microsoft.NET\Framework\v3.5'; \
    $env:FrameworkVersion = 'v3.5'; \
    $env:LANGDIR = 'EN'; \
    $env:Path = ($env:Path + ';' + $env:FrameworkDir + ';C:\Program Files (x86)\Embarcadero\Studio\18.0\bin;C:\Program Files (x86)\Embarcadero\Studio\18.0\bin64;C:\Users\Public\Documents\Embarcadero\InterBase\redist\InterBaseXE7\IDE_spoof'); \
    msbuild /t:build ClipboardTransform.dproj;
