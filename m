Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from alln-iport-3.cisco.com ([173.37.142.90]:28435 "EHLO
        alln-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfLIB30 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Sun, 8 Dec 2019 20:29:26 -0500
From: "Francesco Ruta (fruta)" <fruta@cisco.com>
Subject: RE: bpf_csum_diff - R3 offset is outside of the packet
Date: Mon, 9 Dec 2019 01:22:16 +0000
Message-ID: <DM6PR11MB261860B14521DC3A3B6C91B1B4580@DM6PR11MB2618.namprd11.prod.outlook.com>
References: <BYAPR11MB26157ACA256993F0F15D65E7B45F0@BYAPR11MB2615.namprd11.prod.outlook.com>
 <BYAPR11MB261504C332D91F584F054345B45E0@BYAPR11MB2615.namprd11.prod.outlook.com>
 <CAGn_itw1=3+dH85NL-4NtdKgLnXPgCZe4xrjQRx_Tu3iwySaiQ@mail.gmail.com>
In-Reply-To: <CAGn_itw1=3+dH85NL-4NtdKgLnXPgCZe4xrjQRx_Tu3iwySaiQ@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
To: Anton Protopopov <aspsk2@gmail.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Anton,

Thank you for your suggestion. Albeit that would work for the example, it d=
oesn't seem to work for my original problem where the length of the buffer =
is computed dynamically.

Thank you again
Francesco

-----Original Message-----
From: Anton Protopopov <aspsk2@gmail.com>=20
Sent: Saturday, December 7, 2019 7:16 AM
To: Francesco Ruta (fruta) <fruta@cisco.com>
Cc: xdp-newbies@vger.kernel.org
Subject: Re: bpf_csum_diff - R3 offset is outside of the packet

Hi Francesco,

=D0=D4, 6 =C4=C5=CB. 2019 =C7. =D7 19:12, Francesco Ruta (fruta) <fruta@cis=
co.com>:
> Hello,
>
> I am trying to use bpf_csum_diff() to recompute a corrupted checksum in X=
DP; unfortunately, in this specific case, I am unable to just perform an in=
cremental update.
> I understand that the verifier will reject code that uses dynamic length,=
 but even the stripped-down test shown below is rejected.
> I tried directly in assembly adding extra range checks for the r3 registe=
r to placate the most phobic verifier to no avail.
> Is there any workaround -or any alternative?
> BR
> F.
>
> SEC("test")
> int intercept(struct xdp_md *ctx) {
>     void * data =3D (void*)(long)ctx->data;
>     void * dataEnd =3D (void*)(long)ctx->data_end;
>     void * dataPnt =3D data;
>     if (dataPnt >=3D dataEnd) {
>         return XDP_ABORTED;
>     }
>     __u32 dataLen =3D (__be32 *)dataEnd - (__be32 *)dataPnt;
>     if (dataLen > sizeof(__be32)){
>         (void)bpf_csum_diff(0, 0, (__be32 *)dataPnt, sizeof(__be32), 0);
>    }
>     return XDP_PASS;
> }
> char _license[] SEC("license") =3D "GPL";
>
> Prog section 'test' rejected: Permission denied (13)!
> - Type:         6
> - Instructions: 18 (0 over limit)
> - License:      GPL
>
> Verifier analysis:
>
> 0: (b7) r6 =3D 1
> 1: (61) r2 =3D *(u32 *)(r1 +4)
> 2: (61) r3 =3D *(u32 *)(r1 +0)
> 3: (3d) if r3 >=3D r2 goto pc+12
> R1=3Dctx(id=3D0,off=3D0,imm=3D0) R2=3Dpkt_end(id=3D0,off=3D0,imm=3D0)=20
> R3=3Dpkt(id=3D0,off=3D0,r=3D0,imm=3D0) R6=3Dinv1 R10=3Dfp0,call_-1
> 4: (1f) r2 -=3D r3
> 5: (18) r1 =3D 0x3fffffffc
> 7: (5f) r2 &=3D r1
> 8: (b7) r6 =3D 2
> 9: (b7) r1 =3D 17
> 10: (2d) if r1 > r2 goto pc+5
> R1=3Dinv17=20
> R2=3Dinv(id=3D0,umin_value=3D17,umax_value=3D17179869180,var_off=3D(0x0;=
=20
> 0x3fffffffc)) R3=3Dpkt(id=3D0,off=3D0,r=3D0,imm=3D0) R6=3Dinv2 R10=3Dfp0,=
call_-1
> 11: (b7) r1 =3D 0
> 12: (b7) r2 =3D 0
> 13: (b7) r4 =3D 4
> 14: (b7) r5 =3D 0
> 15: (85) call bpf_csum_diff#28
> invalid access to packet, off=3D0 size=3D4, R3(id=3D0,off=3D0,r=3D0)
> R3 offset is outside of the packet
>
> uname -sr
> Linux 5.0.0-1022-gke

You need to check pointer boundaries, try something like this:

SEC("test")
int intercept(struct xdp_md *ctx) {
    void * data =3D (void*)(long)ctx->data;
    void * data_end =3D (void*)(long)ctx->data_end;
    const int N =3D sizeof(__be32);

    if (data >=3D data_end)
        return XDP_ABORTED;

    if (data + N <=3D data_end) /* lets verifier to know that data[0,...,N-=
1] is valid */
        bpf_csum_diff(0, 0, data, N, 0);

    return XDP_PASS;
}
