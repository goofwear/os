/*++

Copyright (c) 2015 Minoca Corp.

    This file is licensed under the terms of the GNU General Public License
    version 3. Alternative licensing terms are available. Contact
    info@minocacorp.com for details. See the LICENSE file at the root of this
    project for complete licensing information.

Module Name:

    mingen

Abstract:

    This module implements support for the Minoca build generator.

Author:

    Evan Green 3-Dec-2015

Environment:

    Any

--*/

from menv import application, mconfig;

function build() {
    var app;
    var base_sources;
    var build_app;
    var build_includes;
    var build_libs;
    var build_sources;
    var build_os = mconfig.build_os;
    var entries;
    var includes;
    var libs;
    var sources;
    var uos_sources;
    var win32_sources;

    base_sources = [
        "chkfuncs.c",
        "make.c",
        "mingen.c",
        "ninja.c",
        "path.c",
        "script.c"
    ];

    uos_sources = [
        "uos.c"
    ];

    win32_sources = [
        "ntos.c"
    ];

    sources = base_sources + uos_sources;
    build_sources = sources;
    if (build_os == "Windows") {
        build_sources = base_sources + win32_sources;
    }

    libs = [
        "apps/lib/chalk:chalk",
        "lib/yy:yy",
        "lib/rtl/rtlc:rtlc",
        "lib/rtl/base:basertl"
    ];

    build_libs = [
        "apps/lib/chalk:build_chalk",
        "lib/yy:build_yy",
        "lib/rtl/rtlc:build_rtlc",
        "lib/rtl/base:build_basertl"
    ];

    build_includes = [
        "$S/apps/lib/chalk"
    ];

    includes = build_includes + [
        "$S/apps/libc/include"
    ];

    app = {
        "label": "mingen",
        "inputs": sources + libs,
        "includes": includes
    };

    build_app = {
        "label": "build_mingen",
        "output": "mingen",
        "inputs": build_sources + build_libs,
        "includes": build_includes,
        "build": true,
        "prefix": "build"
    };

    entries = application(app);
    entries += application(build_app);
    return entries;
}

