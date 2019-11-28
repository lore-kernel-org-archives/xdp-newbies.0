Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21872 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726587AbfK1RUK (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 28 Nov 2019 12:20:10 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE5D980183C
        for <xdp-newbies@vger.kernel.org>; Thu, 28 Nov 2019 17:20:05 +0000 (UTC)
Received: from [10.36.116.231] (ovpn-116-231.ams2.redhat.com [10.36.116.231])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6799260BE0
        for <xdp-newbies@vger.kernel.org>; Thu, 28 Nov 2019 17:20:05 +0000 (UTC)
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Trying the bpf trace a bpf xdp program
Date: Thu, 28 Nov 2019 18:20:03 +0100
Message-ID: <E53E0693-1C3A-4B47-B205-DC8E5DAF3619@redhat.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
To: Xdp <xdp-newbies@vger.kernel.org>

Trying out the BPF trace to trace a BPF program, but I=E2=80=99m already=20
getting stuck loading the object with the fexit  :(

I=E2=80=99ve loaded a simple pass program on my XDP interface:

```
bpftool prog list
137: xdp  name xdp_prog_simple  tag db89f03479f5c101  gpl
         loaded_at 2019-11-28T16:17:31+0000  uid 0
         xlated 208B  jited 143B  memlock 4096B
         btf_id 108
```

The trace I would like to attach is the following:

```
#define bpf_debug(fmt, ...)                         \
{                                                   \
   char __fmt[] =3D fmt;                               \
   bpf_trace_printk(__fmt, sizeof(__fmt),            \
                    ##__VA_ARGS__);                  \
}

BPF_TRACE_2("fexit/xdp_prog_simple", trace_on_exit,
              struct xdp_md *, ctx, int, ret)
{
   bpf_debug("Debug: %d [ifindex =3D %u, queue =3D  %u, ret =3D %d]\n",
             ctx->ingress_ifindex, ctx->rx_queue_index, ret);

   return 0;
}

char _license[] SEC("license") =3D "GPL";
```

Now I have a simple program trying to open the object file (modeled=20
after fexit_bpf2bpf.c):

```
   prog_fe =3D bpf_prog_get_fd_by_id(137);  //HERE YOU GET THE ID FROM=20
bpftool list
   if (prog_fd < 0) {
     printf("ERROR: Cant cat program fd, make sure hardcoded ID is ok,=20
and ran as root!\n");
     return 0;
   }

   DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts, .attach_prog_fd =3D=20
prog_fd, );

   obj =3D bpf_object__open_file("./xdp_sample_fentry_fexit_kern.o",=20
&opts);
   if (IS_ERR_OR_NULL(obj)) {
     perror("ERROR: Failed to open trace object file");
     return 0;
   }

   err =3D bpf_object__load(obj);
   if (err < 0) {
     perror("ERROR: Failed to load object file");
     return 0;
   }
```

The load fails:

```
libbpf: load bpf program failed: Argument list too long
libbpf: failed to load program 'fexit/xdp_prog_simple'
libbpf: failed to load object './xdp_sample_fentry_fexit_kern.o'
ERROR: Failed to load object file: Operation not permitted
```

I tried using more or fewer arguments to the=20
=E2=80=9Cfexit/xdp_prog_simple=E2=80=9D, but the same problem.
If I change the name to something like =E2=80=9Cfexit/foo=E2=80=9D it compl=
ains it=20
can not find foo in the program I try to attach too.

Any idea? this is with the latests bpd-next kernel=E2=80=A6

Cheers,

Eelco
