Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout2.mail.lrz.de ([129.187.255.138]:58001 "EHLO
        postout2.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbgCSOPt (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 19 Mar 2020 10:15:49 -0400
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: AW: Why does my AF-XDP Socket lose packets whereas a generic linux
 socket doesn't?
Date: Thu, 19 Mar 2020 14:15:44 +0000
Message-ID: <bd692ff951cb41cfbd5397203f3a3ef0@hm.edu>
References: <27adfa9b069242a3a0d8e9ccd64e308a@hm.edu>,<20200316093819.65c24cdd@carbon>
In-Reply-To: <20200316093819.65c24cdd@carbon>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>, =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>

On Mon, 16 Mar 2020 09:38, <brouer@redhat.com> wrote:

>On Sun, 15 Mar 2020 15:36:13 +0000
>"Gaul, Maximilian" <maximilian.gaul@hm.edu> wrote:
>
>
>You say that you are sleeping for a specified time around 1 - 2ms.
>
>Have you considered if in the time your programs sleeps, if the
>RX-queue can be overflowed?
>
>You say at 390,000 pps drops happen.=A0 At this speed a packets arrive
>every 2.564 usec (1/390000*10^9 =3D 2564 ns =3D 2.564 usec).
>
>What NIC hardware/driver are you using?
>And what is the RX-queue size? (ethtool -g)
>On Intel's XL710 driver i40e, the default RX-ring size is 512.
>
>The "good-queue" effect is that a queue functions as a shock absorber,
>to handle that the OS/CPU is busy doing something else.=A0 If I have 512
>RX-queue slots, and packets arriving every 2.564 usec, then I must
>return and empty the queue (and re-fill slots) every 1.3 ms
>(512 * 2.564 usec =3D 1312.768 usec =3D 1.3127 ms).
>

Thank you so much for your answer Jesper!

regarding the size of the RX-Queue: it is 1024.
I am able to increase it up to 8192 but my tests are showing that the RX-Qu=
eue size doesn't change anything on the lost packet rate unless it is lower=
 than 512 (lost packets increase very minimally if set to 512 from 1024).
I also decreased the sleeping time of the process from 1ms to 500=B5s - thi=
s also didn't change anything.
I am using a *Mellanox Technologies MT27800 Family [ConnectX-5]*. I did som=
e further tests with the generic linux socket and it worked fine without an=
y packet loss (but of course I want to use the extended packet processing c=
apability by AF-XDP).
I am not sure but is it possible that some "side traffic" comes up to users=
pace (for example some ping-packages or IGMP-queries) thus messing up my RT=
P-Sequencenumber tracking? Even though I am filtering packets by whether th=
ey are all four: IP, UDP, have valid dest-ip and valid dest-port:

                            const struct pckt_idntfy_raw raw =3D {
                                .src_ip =3D 0, /*not used at the moment */
                                .dst_ip =3D iph->daddr,
                                .dst_port =3D udh->dest,
                                .pad =3D 0
                            };

                            const int *idx =3D bpf_map_lookup_elem(&xdp_pac=
ket_mapping, &raw);
                           =20
                            if(idx !=3D NULL) {
                                if (bpf_map_lookup_elem(&xsks_map, idx)) {
                                    return bpf_redirect_map(&xsks_map, *idx=
, 0);
                                }
                            }

Best regards

Max
