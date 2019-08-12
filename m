Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41909 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfHLSNX (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 12 Aug 2019 14:13:23 -0400
Received: by mail-lj1-f193.google.com with SMTP id d24so99139517ljg.8
        for <xdp-newbies@vger.kernel.org>; Mon, 12 Aug 2019 11:13:21 -0700 (PDT)
MIME-Version: 1.0
From: Rafael Vargas <vargas@khomp.com>
Date: Mon, 12 Aug 2019 15:13:09 -0300
Message-ID: <CAEaYocZ3awg1aW=7Z7Ut_G64Ov9ZdyOAeYWNMdTBTf7scJM6EQ@mail.gmail.com>
Subject: libbpf expected backward compatibility
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi,
Reading the tools/lib/bpf/README.rst file, I could find what should be
the expected backward compatibility of the library with older kernels.

Should I be able to use a libbpf compiled from a kernel newer than the
one I will be running or vice-versa?

I've noticed that the following diff (part of
421ecf02c8e73e1d95e16e5e12aa19146561edba) makes the xsk_socket__create
function return errno 95 'Operation not supported' on older kernels
(5.1.0 in this particular case).


diff --git a/src/xsk.c b/src/xsk.c
index 7ef6293..bf15a80 100644
@@ -597,6 +599,16 @@ int xsk_socket__create(struct xsk_socket
**xsk_ptr, const char *ifname,
        }

        xsk->prog_fd = -1;
+
+       optlen = sizeof(opts);
+       err = getsockopt(xsk->fd, SOL_XDP, XDP_OPTIONS, &opts, &optlen);
+       if (err) {
+               err = -errno;
+               goto out_mmap_tx;
+       }
+
+       xsk->zc = opts.flags & XDP_OPTIONS_ZEROCOPY;

Should this really return Operation not supported or should it handle
this particular error and set the zc flag as false?

-- 
Rafael Vargas
