FROM debian:stable-slim AS dependencies
RUN apt-get update
RUN apt-get upgrade --assume-yes
RUN apt-get install git gcc make liblzma-dev mtools syslinux --assume-yes

FROM dependencies AS sources
RUN git clone https://github.com/ipxe/ipxe.git

FROM sources AS build
WORKDIR /ipxe/src
COPY src/embed.ipxe .
RUN make bin-x86_64-efi/ipxe.usb EMBED=embed.ipxe

FROM scratch AS export-stage
COPY --from=build /ipxe/src/bin-x86_64-efi/ipxe.usb .
