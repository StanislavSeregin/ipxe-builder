FROM debian:stable-slim AS dependencies
RUN apt-get update
RUN apt-get upgrade --assume-yes
RUN apt-get install git gcc make liblzma-dev mtools syslinux --assume-yes

FROM dependencies AS sources
RUN git clone https://github.com/ipxe/ipxe.git

FROM sources AS build
WORKDIR /ipxe/src
COPY src/embed.ipxe .
COPY src/pic.png .

# Enable CONSOLE_CMD, IMAGE_PNG
RUN mv ./config/general.h ./config/general.h.back
RUN echo "#define CONSOLE_CMD\n" > ./config/general.h
RUN echo "#define IMAGE_PNG\n" >> ./config/general.h
RUN cat ./config/general.h.back >> ./config/general.h

# Enable CONSOLE_FRAMEBUFFER
RUN mv ./config/console.h ./config/console.h.back
RUN echo "#define CONSOLE_FRAMEBUFFER\n" > ./config/console.h
RUN cat ./config/console.h.back >> ./config/console.h

RUN make bin-x86_64-efi/ipxe.usb EMBED=embed.ipxe,pic.png -j8

FROM scratch AS export-stage
COPY --from=build /ipxe/src/bin-x86_64-efi/ipxe.usb .
