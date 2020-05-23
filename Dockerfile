FROM magicxor/radstudio:10.1-delphi-net3.5-ltsc2019
SHELL ["powershell"]

COPY ClipboardTransform /build/app
WORKDIR /build/app
RUN msbuild /t:build ClipboardTransform.dproj;
