Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40790 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393023AbfETRoP (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 20 May 2019 13:44:15 -0400
Received: by mail-lf1-f68.google.com with SMTP id h13so10978202lfc.7
        for <xdp-newbies@vger.kernel.org>; Mon, 20 May 2019 10:44:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190518004639.20648-1-mcroce@redhat.com> <20190518004639.20648-2-mcroce@redhat.com>
 <20190520165322.GH10244@mini-arch>
In-Reply-To: <20190520165322.GH10244@mini-arch>
From: Matteo Croce <mcroce@redhat.com>
Date: Mon, 20 May 2019 19:43:37 +0200
Message-ID: <CAGnkfhzEZokRWMtTdbHzy1JZVVEzEPuY2oWL-9LzjRVgG0Y05Q@mail.gmail.com>
Subject: Re: [PATCH 2/5] libbpf: add missing typedef
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Stanislav Fomichev <sdf@fomichev.me>
Cc: xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>

On Mon, May 20, 2019 at 6:53 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 05/18, Matteo Croce wrote:
> > Sync tools/include/linux/types.h with the UAPI one to fix this build error:
> >
> > make -C samples/bpf/../../tools/lib/bpf/ RM='rm -rf' LDFLAGS= srctree=samples/bpf/../../ O=
> >   HOSTCC  samples/bpf/sock_example
> > In file included from samples/bpf/sock_example.c:27:
> > /usr/include/linux/ip.h:102:2: error: unknown type name ‘__sum16’
> >   102 |  __sum16 check;
> >       |  ^~~~~~~
> > make[2]: *** [scripts/Makefile.host:92: samples/bpf/sock_example] Error 1
> > make[1]: *** [Makefile:1763: samples/bpf/] Error 2
> >
> > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > ---
> >  tools/include/linux/types.h | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/tools/include/linux/types.h b/tools/include/linux/types.h
> > index 154eb4e3ca7c..5266dbfee945 100644
> > --- a/tools/include/linux/types.h
> > +++ b/tools/include/linux/types.h
> > @@ -58,6 +58,9 @@ typedef __u32 __bitwise __be32;
> >  typedef __u64 __bitwise __le64;
> >  typedef __u64 __bitwise __be64;
> >
> > +typedef __u16 __bitwise __sum16;
> > +typedef __u32 __bitwise __wsum;
> If you do that, you should probably remove 'typedef __u16 __sum16;'
> from test_progs.h:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/tree/tools/testing/selftests/bpf/test_progs.h#n13
>
> > +
> >  typedef struct {
> >       int counter;
> >  } atomic_t;
> > --
> > 2.21.0
> >

Hi,

I see test_progs.h only included in tools/testing/selftests/bpf/prog_tests/*,
so maybe it's unreladed to my change in samples/bpf/.
Maybe in a different patchset.

Bye,
-- 
Matteo Croce
per aspera ad upstream
