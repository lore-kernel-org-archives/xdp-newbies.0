Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725778AbgDZQHX (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 26 Apr 2020 12:07:23 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC5DC061A0F
        for <xdp-newbies@vger.kernel.org>; Sun, 26 Apr 2020 09:07:23 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id t12so3314995oot.2
        for <xdp-newbies@vger.kernel.org>; Sun, 26 Apr 2020 09:07:23 -0700 (PDT)
MIME-Version: 1.0
From: Jesse DuMond <suttonshiredev@gmail.com>
Date: Sun, 26 Apr 2020 12:07:11 -0400
Message-ID: <CAJEJvEW31-O9x-0WsipVqSf-kPy8HnWnB6gG2jeQTH5WWm2iqw@mail.gmail.com>
Subject: Error creating a AF_XDP socket after deleting
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000002b810005a433cbab"
To: xdp-newbies@vger.kernel.org

--0000000000002b810005a433cbab
Content-Type: text/plain; charset="UTF-8"

Hi there,

I am writing some test code that tries  repeatedly to create a umem
and socket and then deletes them both. I'm using the libbpf function
xsk_umem__create/delete and xsk_socket__create/xsk_socket__delete. I
am getting an EBUSY from xsk_socket__create when trying to create a
socket after deleting a socket on the same interface and queue number.
The attached program reproduces the error.

I've traced the EBUSY error to this call to xdp_umem_assign_dev in the
kernel: https://github.com/torvalds/linux/blob/v5.3/net/xdp/xsk.c#L500
That call is made during the bind call in xsk_socket__create. As far
as I can tell this error is because the work of xdp_umem_clear_dev is
actually called asynchronously after xsk_socket__delete. Putting a
sleep between xsk_socket__delete and xsk_socket__create makes this
code succeed.

Am I trying to do something that is not supposed to be supported?

--0000000000002b810005a433cbab
Content-Type: text/x-csrc; charset="US-ASCII"; name="test.c"
Content-Disposition: attachment; filename="test.c"
Content-Transfer-Encoding: base64
Content-ID: <f_k9h8dw8g0>
X-Attachment-Id: f_k9h8dw8g0

LyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAgKi8KI2luY2x1ZGUgPGVycm5vLmg+
CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdHJpbmcu
aD4KI2luY2x1ZGUgPHN5cy9tbWFuLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KCiNpbmNsdWRlIDxi
cGYvbGliYnBmLmg+CiNpbmNsdWRlIDxicGYveHNrLmg+CiNpbmNsdWRlIDxicGYvYnBmLmg+Cgpp
bnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCnsKCXZvaWQgKmJ1ZnM7CglzdHJ1Y3QgeHNr
X3VtZW0gKnVtZW07CglzdHJ1Y3QgeHNrX3NvY2tldCAqc29ja2V0OwoJc3RydWN0IHhza19yaW5n
X3Byb2QgZnE7CglzdHJ1Y3QgeHNrX3JpbmdfY29ucyBjcTsKCXN0cnVjdCB4c2tfcmluZ19wcm9k
IHR4OwoJc3RydWN0IHhza19yaW5nX2NvbnMgcng7CglzdHJ1Y3QgeHNrX3VtZW1fY29uZmlnIHVj
ZmcgPSB7CgkJLmZpbGxfc2l6ZSA9IDQsCgkJLmNvbXBfc2l6ZSA9IDQsCgkJLmZyYW1lX3NpemUg
PSAyMDQ4LAoJCS5mcmFtZV9oZWFkcm9vbSA9IDAsCgkJLmZsYWdzID0gMAoJfTsKCXN0cnVjdCB4
c2tfc29ja2V0X2NvbmZpZyBzY2ZnID0gewoJCS5yeF9zaXplID0gNCwKCQkudHhfc2l6ZSA9IDQs
CgkJLmxpYmJwZl9mbGFncyA9IFhTS19MSUJCUEZfRkxBR1NfX0lOSElCSVRfUFJPR19MT0FELAoJ
CS5iaW5kX2ZsYWdzID0gMCwKCQkueGRwX2ZsYWdzID0gMAoJfTsKCWludCByZXQ7CgoJYnVmcyA9
IG1tYXAoTlVMTCwgNCAqIDIwNDgsCgkJICAgIFBST1RfUkVBRCB8IFBST1RfV1JJVEUsCgkJICAg
IE1BUF9QUklWQVRFIHwgTUFQX0FOT05ZTU9VUywgLTEsIDApOwoJaWYgKGJ1ZnMgPT0gTUFQX0ZB
SUxFRCkgewoJCXByaW50ZigiRVJST1I6IG1tYXAgZmFpbGVkXG4iKTsKCQlleGl0KEVYSVRfRkFJ
TFVSRSk7Cgl9CgoJcmV0ID0geHNrX3VtZW1fX2NyZWF0ZSgmdW1lbSwgYnVmcywgNCoyMDQ4LCAm
ZnEsICZjcSwgJnVjZmcpOwoJaWYgKHJldCkgewoJCXByaW50ZigiRVJST1I6IHhza191bWVtX19j
cmVhdGUgZmFpbGVkOiAlZCAoJXMpXG4iLCAtcmV0LCBzdHJlcnJvcigtcmV0KSk7CgkJZXhpdCgx
KTsKCX0KCgoJcmV0ID0geHNrX3NvY2tldF9fY3JlYXRlKCZzb2NrZXQsICJ0ZXN0IiwgMCwgdW1l
bSwgJnJ4LCAmdHgsICZzY2ZnKTsKCWlmIChyZXQpIHsKCQlwcmludGYoIkVSUk9SOiB4c2tfc29j
a2V0X19jcmVhdGUgZmFpbGVkOiAlZCAoJXMpXG4iLCByZXQsIHN0cmVycm9yKC1yZXQpKTsKCQll
eGl0KDEpOwoJfQoKCXhza19zb2NrZXRfX2RlbGV0ZShzb2NrZXQpOwoJeHNrX3VtZW1fX2RlbGV0
ZSh1bWVtKTsKCS8vc2xlZXAoMSk7CglyZXQgPSB4c2tfdW1lbV9fY3JlYXRlKCZ1bWVtLCBidWZz
LCA0KjIwNDgsICZmcSwgJmNxLCAmdWNmZyk7CglpZiAocmV0KSB7CgkJcHJpbnRmKCJFUlJPUjog
c2Vjb25kIHhza191bWVtX19jcmVhdGUgZmFpbGVkOiAlZCAoJXMpXG4iLCAtcmV0LCBzdHJlcnJv
cigtcmV0KSk7CgkJZXhpdCgxKTsKCX0KCgoJcmV0ID0geHNrX3NvY2tldF9fY3JlYXRlKCZzb2Nr
ZXQsICJ0ZXN0IiwgMCwgdW1lbSwgJnJ4LCAmdHgsICZzY2ZnKTsKCWlmIChyZXQpIHsKCQlwcmlu
dGYoIkVSUk9SOiBzZWNvbmQgeHNrX3NvY2tldF9fY3JlYXRlIGZhaWxlZDogJWQgKCVzKVxuIiwg
cmV0LCBzdHJlcnJvcigtcmV0KSk7CgkJZXhpdCgxKTsKCX0KCglyZXR1cm4gMDsKfQo=
--0000000000002b810005a433cbab--
