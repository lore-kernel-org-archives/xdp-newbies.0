Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728156AbgD0QQm (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 27 Apr 2020 12:16:42 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70938C0610D5
        for <xdp-newbies@vger.kernel.org>; Mon, 27 Apr 2020 09:16:42 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id e20so27128408otk.12
        for <xdp-newbies@vger.kernel.org>; Mon, 27 Apr 2020 09:16:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAJEJvEW31-O9x-0WsipVqSf-kPy8HnWnB6gG2jeQTH5WWm2iqw@mail.gmail.com>
 <CAJ8uoz0mcu=6_Czw-Y=v-MgRcCRxspkPfFJ4SaQamE-6jCwfkQ@mail.gmail.com> <20200427065029.GA19189@ranger.igk.intel.com>
In-Reply-To: <20200427065029.GA19189@ranger.igk.intel.com>
From: Jesse DuMond <suttonshiredev@gmail.com>
Date: Mon, 27 Apr 2020 12:16:29 -0400
Message-ID: <CAJEJvEXPo8fuPurax-ur=XhVhTuNJUC2atfieqUVnpc4qFG=vQ@mail.gmail.com>
Subject: Re: Error creating a AF_XDP socket after deleting
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000005641cd05a4480a02"
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>, Xdp <xdp-newbies@vger.kernel.org>

--0000000000005641cd05a4480a02
Content-Type: text/plain; charset="UTF-8"

Hmm in the attached example the first retry after an EBUSY returns EINVAL.

On Mon, Apr 27, 2020 at 2:53 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Sun, Apr 26, 2020 at 08:38:03PM +0200, Magnus Karlsson wrote:
> > On Sun, Apr 26, 2020 at 6:08 PM Jesse DuMond <suttonshiredev@gmail.com> wrote:
> > >
> > > Hi there,
> > >
> > > I am writing some test code that tries  repeatedly to create a umem
> > > and socket and then deletes them both. I'm using the libbpf function
> > > xsk_umem__create/delete and xsk_socket__create/xsk_socket__delete. I
> > > am getting an EBUSY from xsk_socket__create when trying to create a
> > > socket after deleting a socket on the same interface and queue number.
> > > The attached program reproduces the error.
> > >
> > > I've traced the EBUSY error to this call to xdp_umem_assign_dev in the
> > > kernel: https://github.com/torvalds/linux/blob/v5.3/net/xdp/xsk.c#L500
> > > That call is made during the bind call in xsk_socket__create. As far
> > > as I can tell this error is because the work of xdp_umem_clear_dev is
> > > actually called asynchronously after xsk_socket__delete. Putting a
> > > sleep between xsk_socket__delete and xsk_socket__create makes this
> > > code succeed.
> > >
> > > Am I trying to do something that is not supposed to be supported?
> >
> > No, you are doing everything correctly. The tear down of a socket is
> > unfortunately asynchronous due to legacy reasons that are not true
> > anymore. We do have a item in the backlog to make this synchronous,
> > but have not gotten around to it yet. So sorry, we have to live with
> > this for a while more.
>
> For now I guess that in case of EBUSY the application can just repeat the
> call to xsk_socket__create?
>
> >
> > /Magnus

--0000000000005641cd05a4480a02
Content-Type: text/x-csrc; charset="US-ASCII"; name="test.c"
Content-Disposition: attachment; filename="test.c"
Content-Transfer-Encoding: base64
Content-ID: <f_k9ioofss0>
X-Attachment-Id: f_k9ioofss0

I2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+
CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPHN5cy9tbWFuLmg+CiNpbmNsdWRlIDx1bmlz
dGQuaD4KCiNpbmNsdWRlIDxicGYvbGliYnBmLmg+CiNpbmNsdWRlIDxicGYveHNrLmg+CiNpbmNs
dWRlIDxicGYvYnBmLmg+CgppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCnsKCXZvaWQg
KmJ1ZnM7CglzdHJ1Y3QgeHNrX3VtZW0gKnVtZW07CglzdHJ1Y3QgeHNrX3NvY2tldCAqc29ja2V0
OwoJc3RydWN0IHhza19yaW5nX3Byb2QgZnE7CglzdHJ1Y3QgeHNrX3JpbmdfY29ucyBjcTsKCXN0
cnVjdCB4c2tfcmluZ19wcm9kIHR4OwoJc3RydWN0IHhza19yaW5nX2NvbnMgcng7CglzdHJ1Y3Qg
eHNrX3VtZW1fY29uZmlnIHVjZmcgPSB7CgkJLmZpbGxfc2l6ZSA9IDQsCgkJLmNvbXBfc2l6ZSA9
IDQsCgkJLmZyYW1lX3NpemUgPSAyMDQ4LAoJCS5mcmFtZV9oZWFkcm9vbSA9IDAsCgkJLmZsYWdz
ID0gMAoJfTsKCXN0cnVjdCB4c2tfc29ja2V0X2NvbmZpZyBzY2ZnID0gewoJCS5yeF9zaXplID0g
NCwKCQkudHhfc2l6ZSA9IDQsCgkJLmxpYmJwZl9mbGFncyA9IFhTS19MSUJCUEZfRkxBR1NfX0lO
SElCSVRfUFJPR19MT0FELAoJCS5iaW5kX2ZsYWdzID0gMCwKCQkueGRwX2ZsYWdzID0gMAoJfTsK
CWludCByZXQ7CgoJYnVmcyA9IG1tYXAoTlVMTCwgNCAqIDIwNDgsCgkJICAgIFBST1RfUkVBRCB8
IFBST1RfV1JJVEUsCgkJICAgIE1BUF9QUklWQVRFIHwgTUFQX0FOT05ZTU9VUywgLTEsIDApOwoJ
aWYgKGJ1ZnMgPT0gTUFQX0ZBSUxFRCkgewoJCXByaW50ZigiRVJST1I6IG1tYXAgZmFpbGVkXG4i
KTsKCQlleGl0KEVYSVRfRkFJTFVSRSk7Cgl9CgoJcmV0ID0geHNrX3VtZW1fX2NyZWF0ZSgmdW1l
bSwgYnVmcywgNCoyMDQ4LCAmZnEsICZjcSwgJnVjZmcpOwoJaWYgKHJldCkgewoJCXByaW50Zigi
RVJST1I6IHhza191bWVtX19jcmVhdGUgZmFpbGVkOiAlZCAoJXMpXG4iLCAtcmV0LCBzdHJlcnJv
cigtcmV0KSk7CgkJZXhpdCgxKTsKCX0KCgoJcmV0ID0geHNrX3NvY2tldF9fY3JlYXRlKCZzb2Nr
ZXQsICJ0ZXN0IiwgMCwgdW1lbSwgJnJ4LCAmdHgsICZzY2ZnKTsKCWlmIChyZXQpIHsKCQlwcmlu
dGYoIkVSUk9SOiB4c2tfc29ja2V0X19jcmVhdGUgZmFpbGVkOiAlZCAoJXMpXG4iLCByZXQsIHN0
cmVycm9yKC1yZXQpKTsKCQlleGl0KDEpOwoJfQoKCXhza19zb2NrZXRfX2RlbGV0ZShzb2NrZXQp
OwoJeHNrX3VtZW1fX2RlbGV0ZSh1bWVtKTsKCS8vc2xlZXAoMSk7CglyZXQgPSB4c2tfdW1lbV9f
Y3JlYXRlKCZ1bWVtLCBidWZzLCA0KjIwNDgsICZmcSwgJmNxLCAmdWNmZyk7CglpZiAocmV0KSB7
CgkJcHJpbnRmKCJFUlJPUjogc2Vjb25kIHhza191bWVtX19jcmVhdGUgZmFpbGVkOiAlZCAoJXMp
XG4iLCAtcmV0LCBzdHJlcnJvcigtcmV0KSk7CgkJZXhpdCgxKTsKCX0KCgoJLy9UaGlzIHdpbGwg
ZmFpbAoJcmV0ID0geHNrX3NvY2tldF9fY3JlYXRlKCZzb2NrZXQsICJ0ZXN0IiwgMCwgdW1lbSwg
JnJ4LCAmdHgsICZzY2ZnKTsKCWlmIChyZXQgPT0gLUVCVVNZKSB7CgkJcmV0ID0geHNrX3NvY2tl
dF9fY3JlYXRlKCZzb2NrZXQsICJ0ZXN0IiwgMCwgdW1lbSwgJnJ4LCAmdHgsICZzY2ZnKTsKCQlp
ZiAocmV0KSB7CgkJCXByaW50ZigiRVJST1I6IHJldHJ5IHhza19zb2NrZXRfX2NyZWF0ZSBmYWls
ZWQ6ICVkICglcylcbiIsIHJldCwgc3RyZXJyb3IoLXJldCkpOwoJCQlleGl0KDEpOwoJCX0KCX0K
CglyZXR1cm4gMDsKfQo=
--0000000000005641cd05a4480a02--
