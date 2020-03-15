Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout2.mail.lrz.de ([129.187.255.138]:51585 "EHLO
        postout2.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbgCOP3y (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 15 Mar 2020 11:29:54 -0400
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
        by postout2.mail.lrz.de (Postfix) with ESMTP id 48gNf65gvWzyY6
        for <xdp-newbies@vger.kernel.org>; Sun, 15 Mar 2020 16:29:50 +0100 (CET)
Received: from postout2.mail.lrz.de ([127.0.0.1])
        by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id 4kl8mXh4Q5fL for <xdp-newbies@vger.kernel.org>;
        Sun, 15 Mar 2020 16:29:50 +0100 (CET)
Received: from BADWLRZ-SWMBB04.ads.mwn.de (BADWLRZ-SWMBB04.ads.mwn.de [IPv6:2001:4ca0:0:108::155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client CN "BADWLRZ-SWMBB04", Issuer "BADWLRZ-SWMBB04" (not verified))
        by postout2.mail.lrz.de (Postfix) with ESMTPS id 48gNf62CVzzyXm
        for <xdp-newbies@vger.kernel.org>; Sun, 15 Mar 2020 16:29:50 +0100 (CET)
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: AW: Shared Umem between processes
Date: Sun, 15 Mar 2020 15:29:49 +0000
Message-ID: <918ba455fdd2445a93fbec3b92bcc204@hm.edu>
References: <fd5e40efd5c1426cb4a5942682407ea2@hm.edu>
 <CAJ+HfNghFctg3L=3QdeoWyqDdj4wP4EKWjYyF01=SmCO5+=32g@mail.gmail.com>
 <a80ec2c07cb9493eafabb9decf479c60@hm.edu>
 <CAJ+HfNjiDCdaQm_PocHXC+gHABAO67b6H+f2pf+ZdHRu2uhMVA@mail.gmail.com>
 <69569dcbc4ce450eb5b2c1905bf11208@hm.edu>
 <CAJ+HfNi5sstcz20EGq2sak0RpYdBwVO5P+NLX8cALBuG_xsnHw@mail.gmail.com>
 <046ac5d67f6a447f98266eacaa2c25e5@hm.edu>
 <CAJ+HfNjNMhxzXTrwKjOZALO5=3UTgQz0ytyAMs5zoGB0HX29DA@mail.gmail.com>
 <87sgidon13.fsf@toke.dk>,<CAJ+HfNgRahagXKiiUCwZMO46cPL--OxXcE3HwpbWAyph9Cjy3Q@mail.gmail.com>,<1f9eeee0897f4cf9951374ae605b03a4@hm.edu>
In-Reply-To: <1f9eeee0897f4cf9951374ae605b03a4@hm.edu>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Xdp <xdp-newbies@vger.kernel.org>

I figured out that this was because I didn't synchronize the access to the =
umem between the AF-XDP sockets.
I am doing that now in a Round-Robin like fashion as described in `xdpsock_=
user.c`.

>On Thu, 12 Mar 2020 at 16:48, Gaul, Maximilian <maximilian.gaul@hm.edu>  w=
rote:

>I don't know if it is appropriate to ask a new question on the same topic =
in the same thread? In case it is not I will start a new one but I thought =
it would fit "my story on how to get shared umem working".
>
>I followed  https://github.com/xdp-project/bpf-next/blob/master/samples/bp=
f/xdpsock_user.c on how to implement shared umem and I think I got it worki=
ng to some extend.
>
>There are some problems though:
>
>I am processing two multicast streams arriving on the same RX-Queue on two=
 sockets (using shared umem) - each socket is running in its own thread (sa=
me process).
>What I noticed: Everything seems to work fine for about 1min or so (even t=
hough I am noticing some packet-loss for 530.000 pps) but after that, datar=
ate drops to only half and after one more minute to a fourth.
>
>My first thought on this was that the reserved umem frames by calling `xsk=
_ring_prod__reserve` are not freed properly (similiar to a memory leak) bec=
ause of that I decreased the size of the umem to a tenth hoping to see a de=
crease in packet rate even sooner  - and indeed I did!
>
>Basically what I do is to create a new thread for each socket and pass the=
 `xsk_socket_info`-struct accordingly. I then call `nanosleep` for 2.5ms in=
 a while-loop and process every frame that arrived:
>
>static void* rx_and_process(void *a) {
>
>=A0=A0=A0=A0=A0=A0=A0 struct pthread_arg *arg =3D (struct pthread_arg*)a;
>=A0=A0=A0=A0=A0=A0=A0 struct config *cfg =3D arg->cfg;
>=A0=A0=A0=A0=A0=A0=A0 struct pckt_idntfy_stats *pckt =3D arg->pckt_idntfy;
>=A0=A0=A0=A0=A0=A0=A0 struct xsk_socket_info *xsk_socket =3D arg->xsk_sock=
et;
>
>=A0=A0=A0=A0=A0=A0=A0 struct timespec spec;
>=A0=A0=A0=A0=A0=A0=A0 spec.tv_sec =3D 0;
>=A0=A0=A0=A0=A0=A0=A0 spec.tv_nsec =3D 2500 * 1000;
>
>=A0=A0=A0=A0=A0=A0=A0 struct timespec remaining;
>
>=A0=A0=A0=A0=A0=A0=A0 while(!global_exit) {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if(nanosleep(&spec, &remaini=
ng) < 0) {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nano=
sleep(&spec, &remaining);
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 handle_receive_packets(xsk_s=
ocket, fds);
>=A0=A0=A0=A0=A0=A0=A0 }
>
>=A0=A0=A0=A0=A0=A0=A0 return NULL;
>}
>
>`pckt_idntfy_stats` contains information about where the statistics about =
this multicast-stream should be placed in shared memory.
>
>Processing then happens like this:
>
>static void handle_receive_packets(struct xsk_socket_info *xsk_socket, str=
uct pollfd *fds) {
>=A0=A0=A0=A0=A0=A0=A0 unsigned int rcvd, i;
>=A0=A0=A0=A0=A0=A0=A0 uint32_t idx_rx =3D 0, idx_fq =3D 0;
>=A0=A0=A0=A0=A0=A0=A0 int ret;
>
>=A0=A0=A0=A0=A0=A0=A0 rcvd =3D xsk_ring_cons__peek(&xsk_socket->rx, INT32_=
MAX, &idx_rx);
>=A0=A0=A0=A0=A0=A0=A0 if (!rcvd) {
>=A0=A0=A0=A0=A0=A0=A0 /* no packets received, go to sleep */
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;
>=A0=A0=A0=A0=A0=A0=A0 }
>
>=A0=A0=A0=A0=A0=A0=A0 ret =3D xsk_ring_prod__reserve(&xsk_socket->umem->fq=
, rcvd, &idx_fq);
>=A0=A0=A0=A0=A0=A0=A0 if (ret < 0) {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, "Error: %s\n=
", strerror(-ret));
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;
>=A0=A0=A0=A0=A0=A0=A0 } else if(ret =3D=3D 0) {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printf("NO SPACE LEFT!\n");
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;
>=A0=A0=A0=A0=A0=A0=A0 } else if(ret !=3D rcvd) {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printf("RET !=3D RCVD\n");
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;
>=A0=A0=A0=A0=A0=A0=A0 }
>
>=A0=A0=A0=A0=A0=A0=A0 for (i =3D 0; i < rcvd; i++) {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint64_t addr =3D xsk_ring_c=
ons__rx_desc(&xsk_socket->rx, idx_rx)->addr;
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint32_t len =3D xsk_ring_co=
ns__rx_desc(&xsk_socket->rx, idx_rx++)->len;
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint64_t orig =3D xsk_umem__=
extract_addr(addr);
>
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 addr =3D xsk_umem__add_offse=
t_to_addr(addr);
>
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 process_packet(xsk_socket, a=
ddr, len);
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *xsk_ring_prod__fill_addr(&x=
sk_socket->umem->fq, idx_fq++) =3D orig;
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 xsk_socket->stats.rx_bytes +=
=3D len;
>=A0=A0=A0=A0=A0=A0=A0 }
>
>=A0=A0=A0=A0=A0=A0=A0 xsk_ring_prod__submit(&xsk_socket->umem->fq, rcvd);
>=A0=A0=A0=A0=A0=A0=A0 xsk_ring_cons__release(&xsk_socket->rx, rcvd);
>=A0=A0=A0=A0=A0=A0=A0 xsk_socket->stats.rx_packets +=3D rcvd;
>}
>
>I am sorry to post all this code here but maybe it helps?
>
>This is how I configured the umem (basically a 1:1 copy from `xdpsock_user=
.c`:
>
>static struct xsk_umem_info *configure_xsk_umem(void *buffer, uint64_t siz=
e) {
>
>=A0=A0=A0=A0=A0=A0=A0 struct xsk_umem_info *umem;
>=A0=A0=A0=A0=A0=A0=A0 struct xsk_umem_config cfg =3D {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .fill_size =3D XSK_RING_PROD=
__DEFAULT_NUM_DESCS,
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .comp_size =3D XSK_RING_CONS=
__DEFAULT_NUM_DESCS,
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .frame_size =3D FRAME_SIZE,
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .frame_headroom =3D XSK_UMEM=
__DEFAULT_FRAME_HEADROOM,
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .flags =3D 0
>=A0=A0=A0=A0=A0=A0=A0 };
>=A0=A0=A0=A0=A0=A0=A0 int ret;
>
>=A0=A0=A0=A0=A0=A0=A0 umem =3D calloc(1, sizeof(*umem));
>=A0=A0=A0=A0=A0=A0=A0 if (!umem) {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, "Error while=
 allocating umem: %s\n", strerror(errno));
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 exit(1);
>=A0=A0=A0=A0=A0=A0=A0 }
>
>=A0=A0=A0=A0=A0=A0=A0 ret =3D xsk_umem__create(&umem->umem, buffer, size, =
&umem->fq, &umem->cq, &cfg);
>=A0=A0=A0=A0=A0=A0=A0 if (ret) {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, "`xsk_umem__=
create` returned: %s\n", strerror(-ret));
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 exit(1);
>=A0=A0=A0=A0=A0=A0=A0 }
>
>=A0=A0=A0=A0=A0=A0=A0 umem->buffer =3D buffer;
>=A0=A0=A0=A0=A0=A0=A0 return umem;
>}
>
>and after that I call:
>
>static void xsk_populate_fill_ring(struct xsk_umem_info *umem) {
>=A0=A0=A0=A0=A0=A0=A0 int ret, i;
>=A0=A0=A0=A0=A0=A0=A0 uint32_t idx;
>
>=A0=A0=A0=A0=A0=A0=A0 ret =3D xsk_ring_prod__reserve(&umem->fq, XSK_RING_P=
ROD__DEFAULT_NUM_DESCS, &idx);
>=A0=A0=A0=A0=A0=A0=A0 if (ret !=3D XSK_RING_PROD__DEFAULT_NUM_DESCS) {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, "Failed to r=
eserve prod ring: %s\n", strerror(errno));
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 exit(1);
>=A0=A0=A0=A0=A0=A0=A0 }
>=A0=A0=A0=A0=A0=A0=A0 for (i =3D 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; =
i++) {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *xsk_ring_prod__fill_addr(&u=
mem->fq, idx++) =3D i * FRAME_SIZE;
>=A0=A0=A0=A0=A0=A0=A0 }
>=A0=A0=A0=A0=A0=A0=A0 xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFA=
ULT_NUM_DESCS);
>}
>
>And sockets are created this way:
>
>static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *=
umem, struct config *cfg, bool rx, bool tx) {
>=A0=A0=A0=A0=A0=A0=A0 struct xsk_socket_config xsk_socket_cfg;
>=A0=A0=A0=A0=A0=A0=A0=A0 struct xsk_socket_info *xsk;
>=A0=A0=A0=A0=A0=A0=A0 struct xsk_ring_cons *rxr;
>=A0=A0=A0=A0=A0=A0=A0 struct xsk_ring_prod *txr;
>=A0=A0=A0=A0=A0=A0=A0 int ret;
>
>=A0=A0=A0=A0=A0=A0=A0 xsk =3D calloc(1, sizeof(*xsk));
>=A0=A0=A0=A0=A0=A0=A0 if (!xsk) {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, "xsk `calloc=
` failed: %s\n", strerror(errno));
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 exit(1);
>=A0=A0=A0=A0=A0=A0=A0 }
>
>=A0=A0=A0=A0=A0=A0=A0 xsk->umem =3D umem;
>=A0=A0=A0=A0=A0=A0=A0 xsk_socket_cfg.rx_size =3D XSK_RING_CONS__DEFAULT_NU=
M_DESCS;
>=A0=A0=A0=A0=A0=A0=A0 xsk_socket_cfg.tx_size =3D XSK_RING_PROD__DEFAULT_NU=
M_DESCS;
>=A0=A0=A0=A0=A0=A0=A0 if (cfg->ip_addrs_len > 1) {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 xsk_socket_cfg.libbpf_flags =
=3D XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD;
>=A0=A0=A0=A0=A0=A0=A0 } else {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 xsk_socket_cfg.libbpf_flags =
=3D 0;
>=A0=A0=A0=A0=A0=A0=A0 }
>=A0=A0=A0=A0=A0=A0=A0 xsk_socket_cfg.xdp_flags =3D cfg->xdp_flags;
>=A0=A0=A0=A0=A0=A0=A0 xsk_socket_cfg.bind_flags =3D cfg->xsk_bind_flags;
>
>=A0=A0=A0=A0=A0=A0=A0 rxr =3D rx ? &xsk->rx : NULL;
>=A0=A0=A0=A0=A0=A0=A0 txr =3D tx ? &xsk->tx : NULL;
>=A0=A0=A0=A0=A0=A0=A0 ret =3D xsk_socket__create(&xsk->xsk, cfg->ifname_bu=
f, cfg->xsk_if_queue, umem->umem, rxr, txr, &xsk_socket_cfg);
>=A0=A0=A0=A0=A0=A0=A0 if (ret) {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, "`xsk_socket=
__create` returned error: %s\n", strerror(errno));
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 exit(-ret);
>=A0=A0=A0=A0=A0=A0=A0 }
>
>=A0=A0=A0=A0=A0=A0=A0 return xsk;
>}
>
>As far as I've seen from `xdpsock_user.c` there is no special handling req=
uired by the sockets who are using shared umem? What am I missing?
>
>Best regards
>
>Max   =20
