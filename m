Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:56593 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbfHLQH7 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 12 Aug 2019 12:07:59 -0400
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH v2 2/2] Documentation: sphinx: Don't parse socket() as identifier reference
Date: Mon, 12 Aug 2019 18:07:05 +0200
Message-Id: <20190812160708.32172-2-j.neuschaefer@gmx.net>
In-Reply-To: <20190812160708.32172-1-j.neuschaefer@gmx.net>
References: <20190812160708.32172-1-j.neuschaefer@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: linux-doc@vger.kernel.org
Cc: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>, Jonathan Corbet <corbet@lwn.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

With the introduction of Documentation/sphinx/automarkup.py, socket() is
parsed as a reference to the in-kernel definition of socket. Sphinx then
decides that struct socket is a good match, which is usually not
intended, when the syscall is meant instead. This was observed in
Documentation/networking/af_xdp.rst.

Prevent socket() from being misinterpreted by adding it to the Skipfuncs
list in automarkup.py.

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
---

v2:
- block socket() in Documentation/sphinx/automarkup.py, as suggested by
  Jonathan Corbet

v1:
- https://lore.kernel.org/lkml/20190810121738.19587-1-j.neuschaefer@gmx.net/
---
 Documentation/sphinx/automarkup.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/sphinx/automarkup.py b/Documentation/sphinx/automarkup.py
index a8798369e8f7..5b6119ff69f4 100644
--- a/Documentation/sphinx/automarkup.py
+++ b/Documentation/sphinx/automarkup.py
@@ -26,7 +26,8 @@ RE_function = re.compile(r'([\w_][\w\d_]+\(\))')
 # just don't even try with these names.
 #
 Skipfuncs = [ 'open', 'close', 'read', 'write', 'fcntl', 'mmap',
-              'select', 'poll', 'fork', 'execve', 'clone', 'ioctl']
+              'select', 'poll', 'fork', 'execve', 'clone', 'ioctl',
+              'socket' ]

 #
 # Find all occurrences of function() and try to replace them with
--
2.20.1
