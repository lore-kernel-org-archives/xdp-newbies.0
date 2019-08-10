Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52629 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfHJMS2 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 10 Aug 2019 08:18:28 -0400
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH] Documentation/networking/af_xdp: Inhibit reference to struct socket
Date: Sat, 10 Aug 2019 14:17:37 +0200
Message-Id: <20190810121738.19587-1-j.neuschaefer@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-doc@vger.kernel.org
Cc: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>, "David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org

With the recent change to auto-detect function names, Sphinx parses
socket() as a reference to the in-kernel definition of socket. It then
decides that struct socket is a good match, which was obviously not
intended in this case, because the text speaks about the syscall with
the same name.

Prevent socket() from being misinterpreted by wrapping it in ``inline
literal`` quotes.

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 Documentation/networking/af_xdp.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networkin=
g/af_xdp.rst
index eeedc2e826aa..54f179ee6c33 100644
=2D-- a/Documentation/networking/af_xdp.rst
+++ b/Documentation/networking/af_xdp.rst
@@ -20,7 +20,7 @@ bpf_redirect_map() function. AF_XDP sockets enable the p=
ossibility for
 XDP programs to redirect frames to a memory buffer in a user-space
 application.

-An AF_XDP socket (XSK) is created with the normal socket()
+An AF_XDP socket (XSK) is created with the normal ``socket()``
 syscall. Associated with each XSK are two rings: the RX ring and the
 TX ring. A socket can receive packets on the RX ring and it can send
 packets on the TX ring. These rings are registered and sized with the
=2D-
2.20.1
