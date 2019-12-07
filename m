Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:3246 "EHLO
        rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbfLGALc (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 6 Dec 2019 19:11:32 -0500
Received: from XCH-RCD-015.cisco.com (xch-rcd-015.cisco.com [173.37.102.25])
        by rcdn-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id xB70BVpl017878
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL)
        for <xdp-newbies@vger.kernel.org>; Sat, 7 Dec 2019 00:11:31 GMT
From: "Francesco Ruta (fruta)" <fruta@cisco.com>
Subject: bpf_csum_diff - R3 offset is outside of the packet
Date: Sat, 7 Dec 2019 00:11:29 +0000
Message-ID: <BYAPR11MB261504C332D91F584F054345B45E0@BYAPR11MB2615.namprd11.prod.outlook.com>
References: <BYAPR11MB26157ACA256993F0F15D65E7B45F0@BYAPR11MB2615.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB26157ACA256993F0F15D65E7B45F0@BYAPR11MB2615.namprd11.prod.outlook.com>
Content-Language: en-US
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Hello,

I am trying to use bpf_csum_diff() to recompute a corrupted checksum in XDP=
; unfortunately, in this specific case, I am unable to just perform an incr=
emental update.
I understand that the verifier will reject code that uses dynamic length, b=
ut even the stripped-down test shown below is rejected.
I tried directly in assembly adding extra range checks for the r3 register =
to placate the most phobic verifier to no avail.
Is there any workaround -or any alternative?
BR
F.

SEC("test")
int intercept(struct xdp_md *ctx) {
=A0=A0=A0 void * data =3D (void*)(long)ctx->data;
=A0=A0=A0 void * dataEnd =3D (void*)(long)ctx->data_end;
=A0=A0=A0 void * dataPnt =3D data;
=A0=A0=A0 if (dataPnt >=3D dataEnd) {
=A0=A0=A0=A0=A0=A0=A0 return XDP_ABORTED;
=A0=A0=A0 }
=A0=A0=A0 __u32 dataLen =3D (__be32 *)dataEnd - (__be32 *)dataPnt;
=A0=A0=A0 if (dataLen > sizeof(__be32)){
=A0=A0=A0=A0=A0=A0=A0 (void)bpf_csum_diff(0, 0, (__be32 *)dataPnt, sizeof(_=
_be32), 0);
=A0=A0 }
=A0=A0=A0 return XDP_PASS;
}
char _license[] SEC("license") =3D "GPL";

Prog section 'test' rejected: Permission denied (13)!
- Type:=A0=A0=A0=A0=A0=A0=A0=A0 6
- Instructions: 18 (0 over limit)
- License:=A0=A0=A0=A0=A0 GPL

Verifier analysis:

0: (b7) r6 =3D 1
1: (61) r2 =3D *(u32 *)(r1 +4)
2: (61) r3 =3D *(u32 *)(r1 +0)
3: (3d) if r3 >=3D r2 goto pc+12
R1=3Dctx(id=3D0,off=3D0,imm=3D0) R2=3Dpkt_end(id=3D0,off=3D0,imm=3D0) R3=3D=
pkt(id=3D0,off=3D0,r=3D0,imm=3D0) R6=3Dinv1 R10=3Dfp0,call_-1
4: (1f) r2 -=3D r3
5: (18) r1 =3D 0x3fffffffc
7: (5f) r2 &=3D r1
8: (b7) r6 =3D 2
9: (b7) r1 =3D 17
10: (2d) if r1 > r2 goto pc+5
R1=3Dinv17 R2=3Dinv(id=3D0,umin_value=3D17,umax_value=3D17179869180,var_off=
=3D(0x0; 0x3fffffffc)) R3=3Dpkt(id=3D0,off=3D0,r=3D0,imm=3D0) R6=3Dinv2 R10=
=3Dfp0,call_-1
11: (b7) r1 =3D 0
12: (b7) r2 =3D 0
13: (b7) r4 =3D 4
14: (b7) r5 =3D 0
15: (85) call bpf_csum_diff#28
invalid access to packet, off=3D0 size=3D4, R3(id=3D0,off=3D0,r=3D0)
R3 offset is outside of the packet

uname -sr
Linux 5.0.0-1022-gke
