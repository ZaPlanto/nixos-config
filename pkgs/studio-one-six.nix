{
    stdenv,
    fetchurl,
    lib,
    dpkg,
    autoPatchelfHook,
    alsa-lib,
    avahi-compat,
    cairo,
    makeDesktopItem,
    cairomm,
    dbus,
    fontconfig,
    freetype,
    gcc,
    gdk-pixbuf,
    glib,
    glibc,
    glibmm,
    graphene,
    gtk4,
    gtkmm4,
    harfbuzz,
    icu72,
    pipewire,
    libjpeg8,
    libsecret,
    libsForQt5,
    libsigcxx,
    libstdcxx5,
    libunistring,
    libxkbcommon,
    openssl,
    pango,
    pangomm,
    stduuid,
    vulkan-headers,
    vulkan-loader,
    wayland,
}: stdenv.mkDerivation rec {
    pname = "studio-one-six";
    version = "6.5.1.96553";
    src = ./Studio_One.deb;

    nativeBuildInputs = [ 
        autoPatchelfHook
        dpkg
    ];

    desktop = makeDesktopItem { name = pname; desktopName = "Studio One Six"; comment = "Digital Audio Workstation (I'm watching you Alex)"; icon = "studioone"; exec = pname + " %F"; categories = ["Audio"];
        mimeTypes = [
            "application/x.presonus-soundset"
            "application/x.presonus-ioconfig+xml"
            "application/x.presonus-instrument"
            "application/x.presonus-trackpreset"
            "application/x.presonus-audioloop"
            "application/x.presonus-musicloop"
            "application/x.presonus-keyswitches+xml"
            "application/x.presonus-pitchlist+xml"
            "application/x.presonus-license"
            "application/x.presonus-quantize+xml"
            "application/x.presonus-click+xml"
            "application/x.presonus-pattern+xml"
            "application/x.presonus-studioonemacro"
            "application/x.presonus-studioonemacropage"
            "application/x.presonus-capture-session"
            "application/x.presonus-song"
            "application/x.presonus-songtemplate"
            "application/x.presonus-project"
            "application/x.presonus-projecttemplate"
            "application/x.presonus-show"
            "application/x.presonus-showtemplate"
            "application/x.ccl-preset"
            "application/x.ccl-multipreset"
            "application/x.ccl-install-package"
            "application/x.ccl-colorscheme+xml"
            "application/x.ccl-colorpalette+json"
            "application/x.ccl-keyscheme+xml"
            "application/x-kristal-project"
            "audio/vnd.presonus.multitrack"
            "application/vnd.bitwig.dawproject"
        ];
    };

    buildInputs = [
        alsa-lib
        avahi-compat
        cairo
        cairomm
        dbus
        fontconfig
        freetype
        gcc
        gdk-pixbuf
        glib
        glibc
        glibmm
        graphene
        gtk4
        gtkmm4
        (harfbuzz.override {
            withIcu = true;
        })
        icu72
        pipewire.jack # This is a bad way of doing things, but it works
        libjpeg8
        libsecret
        libsForQt5.knotifications
        libsForQt5.kwallet
        libsForQt5.full
        libsForQt5.qtdbusextended
        libsForQt5.qwt
        libsForQt5.qt5.wrapQtAppsHook
        libsigcxx
        libstdcxx5
        (libunistring.overrideAttrs rec {
            pname = "libunistring";
            version = "0.9.10";
            src = fetchurl {
                url = "mirror://gnu/libunistring/${pname}-${version}.tar.gz";
                sha256 = "sha256-qC5bMzM5qI6kYI5GNUeaHPsuAar7kl4SkLZXENQ/YQs=";
            };
        })
        libxkbcommon
        openssl
        pango
        pangomm
        stduuid
        vulkan-headers
        vulkan-loader
        wayland
    ];

    unpackCmd = "dpkg-deb -x $curSrc source";

    installPhase = ''
        mkdir -p $out/usr/local
        mkdir -p $out/bin
        mkdir -p $out/share/
        mv opt/PreSonus $out/usr/local # I hate that this is what works
        ln -s "$out/usr/local/PreSonus/Studio One 6/Studio One" $out/bin/studio-one-six
        cp -r $desktop/share/applications $out/share/
        mv usr/share/icons $out/share/icons
    '';

    meta = with lib; {
        description = "Studio One is a digital audio workstation (DAW) application, used to create, record, mix and master music and other audio, with functionality also available for video.";
        homepage = "https://www.presonus.com/products/Studio-One";
        sourceProvenance = with sourceTypes; [ binaryNativeCode ];
        platforms = platforms.linux;
    };
}
