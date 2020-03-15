Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout2.mail.lrz.de ([129.187.255.138]:49077 "EHLO
        postout2.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgCOPgR (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 15 Mar 2020 11:36:17 -0400
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
        by postout2.mail.lrz.de (Postfix) with ESMTP id 48gNnV2x0VzyTR
        for <xdp-newbies@vger.kernel.org>; Sun, 15 Mar 2020 16:36:14 +0100 (CET)
Received: from postout2.mail.lrz.de ([127.0.0.1])
        by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id pYDze45UKane for <xdp-newbies@vger.kernel.org>;
        Sun, 15 Mar 2020 16:36:13 +0100 (CET)
Received: from BADWLRZ-SWMBX03.ads.mwn.de (BADWLRZ-SWMBX03.ads.mwn.de [IPv6:2001:4ca0:0:108::159])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client CN "BADWLRZ-SWMBX03", Issuer "BADWLRZ-SWMBX03" (not verified))
        by postout2.mail.lrz.de (Postfix) with ESMTPS id 48gNnT6yLjzyTN
        for <xdp-newbies@vger.kernel.org>; Sun, 15 Mar 2020 16:36:13 +0100 (CET)
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: Why does my AF-XDP Socket lose packets whereas a generic linux socket
 doesn't?
Date: Sun, 15 Mar 2020 15:36:13 +0000
Message-ID: <27adfa9b069242a3a0d8e9ccd64e308a@hm.edu>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Xdp <xdp-newbies@vger.kernel.org>

I am comparing AF-XDP sockets vs Linux Sockets in terms of how many packets=
 they can process without packet-loss (packet-loss is defined as the RTP-se=
quence number of the current packet is not equal to the RTP-sequence number=
 of the previous packet `+ 1`).

I noticed that my AF-XDP socket program (I can't determine if this problem =
is related to the kernel program or the user-space program) is losing aroun=
d `~25` packets per second at around `390.000` packets per second whereas a=
n equivalent program with generic linux sockets doesn't lose any packets.

I implemented a so-called `distributor`-program which loads the XDP-kernel =
program once, sets up a generic linux socket and adds `setsockopt(IP_ADD_ME=
MBERSHIP)` to this generic socket for every multicast-address I pass to the=
 program via command line.
After this, the `distributor` loads the filedescriptor of a `BPF_MAP_TYPE_H=
ASH` placed in the XDP-kernel program and inserts routes for the traffic in=
 case a single AF-XDP socket needs to share its umem later on.

The XDP-kernel program then checks for each IPv4/UDP packet if there is an =
entry in that hash-map. This basically looks like this:

    const struct pckt_idntfy_raw raw =3D {
        .src_ip =3D 0, /* not used at the moment */
        .dst_ip =3D iph->daddr,
        .dst_port =3D udh->dest,
        .pad =3D 0
    };
   =20
    const int *idx =3D bpf_map_lookup_elem(&xdp_packet_mapping, &raw);

    if(idx !=3D NULL) {
        if (bpf_map_lookup_elem(&xsks_map, idx)) {
            bpf_printk("Found socket @ index: %d!\n", *idx);
            return bpf_redirect_map(&xsks_map, *idx, 0);
        } else {
            bpf_printk("Didn't find connected socket for index %d!\n", *idx=
);
        }
    }

In case `idx` exists this means that there is a socket sitting behind that =
index in the `BPF_MAP_TYPE_XSKMAP`.

After doing all that the `distributor` spawns a new process via `fork()` pa=
ssing all multicast-addresses (including destination port) which should be =
processed by that process (one process handles one RX-Queue). In case there=
 are not enough RX-Queues, some processes may receive multiple multicast-ad=
dresses. This then means that they are going to use `SHARED UMEM`.

I basically oriented my AF-XDP user-space program on this example code: htt=
ps://github.com/torvalds/linux/blob/master/samples/bpf/xdpsock_user.c

I am using the same `xsk_configure_umem`, `xsk_populate_fill_ring` and `xsk=
_configure_socket` functions.

Because I figured I don't need maximum latency for this application, I send=
 the process to sleep for a specified time (around `1 - 2ms`) after which i=
t loops through every AF-XDP socket (most of the time it is only one socket=
) and processes every received packet for that socket, verifying that no pa=
ckets have been missed:

=09while(!global_exit) {
=09    nanosleep(&spec, &remaining);

=09=09for(int i =3D 0; i < cfg.ip_addrs_len; i++) {
=09=09=09struct xsk_socket_info *socket =3D xsk_sockets[i];
=09=09=09if(atomic_exchange(&socket->stats_sync.lock, 1) =3D=3D 0) {
=09=09=09=09handle_receive_packets(socket);
=09=09=09=09atomic_fetch_xor(&socket->stats_sync.lock, 1); /* release socke=
t-lock */
=09=09=09}
=09=09}
=09}

In my opinion there is nothing too fancy about this but somehow I lose `~25=
` packets at around `390.000` packets even though my UMEM is close to 1GB o=
f RAM.

In comparison, my generic linux socket program looks like this (in short):

    int fd =3D socket(AF_INET, SOCK_RAW, IPPROTO_UDP);

    /* setting some socket options */

    struct sockaddr_in sin;
    memset(&sin, 0, sizeof(struct sockaddr_in));
    sin.sin_family =3D AF_INET;
    sin.sin_port =3D cfg->ip_addrs[0]->pckt.dst_port;
    inet_aton(cfg->ip_addrs[0]->pckt.dst_ip, &sin.sin_addr);
   =20
    if(bind(fd, (struct sockaddr*)&sin, sizeof(struct sockaddr)) < 0) {
        fprintf(stderr, "Error on binding socket: %s\n", strerror(errno));
        return - 1;
    }
   =20
    ioctl(fd, SIOCGIFADDR, &intf);

The `distributor`-program creates a new process for every given multicast-i=
p in case generic linux sockets are used (because there are no sophisticate=
d methods such as SHARED-UMEM in generic sockets I don't bother with multip=
le multicast-streams per process).
Later on I of course join the multicast membership:

    struct ip_mreqn mreq;
    memset(&mreq, 0, sizeof(struct ip_mreqn));
   =20
    const char *multicast_ip =3D cfg->ip_addrs[0]->pckt.dst_ip;

    if(inet_pton(AF_INET, multicast_ip, &mreq.imr_multiaddr.s_addr)) {
        /* Local interface address */
        memcpy(&mreq.imr_address, &cfg->ifaddr, sizeof(struct in_addr));
        mreq.imr_ifindex =3D cfg->ifindex;
       =20
        if(setsockopt(igmp_socket_fd, IPPROTO_IP, IP_ADD_MEMBERSHIP, &mreq,=
 sizeof(struct ip_mreqn)) < 0) {
            fprintf(stderr, "Failed to set `IP_ADD_MEMBERSHIP`: %s\n", stre=
rror(errno));
            return;
        } else {
            printf("Successfully added Membership for IP: %s\n", multicast_=
ip);
        }
    }

and start processing packets (not sleeping but in a `busy-loop` like fashio=
n):

    void read_packets_recvmsg_with_latency(struct config *cfg, struct stati=
stic *st, void *buff, const int igmp_socket_fd) {
        char ctrl[CMSG_SPACE(sizeof(struct timeval))];
   =20
        struct msghdr msg;
        struct iovec iov;
        msg.msg_control =3D (char*)ctrl;
        msg.msg_controllen =3D sizeof(ctrl);
        msg.msg_name =3D &cfg->ifaddr;
        msg.msg_namelen =3D sizeof(cfg->ifaddr);
   =20
        msg.msg_iov =3D &iov;
        msg.msg_iovlen =3D 1;
        iov.iov_base =3D buff;
        iov.iov_len =3D BUFFER_SIZE;
       =20
        struct timeval time_user, time_kernel;
        struct cmsghdr *cmsg =3D (struct cmsghdr*)&ctrl;
   =20
        const int64_t read_bytes =3D recvmsg(igmp_socket_fd, &msg, 0);
        if(read_bytes =3D=3D -1) {
            return;
        }
       =20
        gettimeofday(&time_user, NULL);
       =20
        if(cmsg->cmsg_level =3D=3D SOL_SOCKET && cmsg->cmsg_type =3D=3D SCM=
_TIMESTAMP) {
            memcpy(&time_kernel, CMSG_DATA(cmsg), sizeof(struct timeval));
        }
       =20
        if(verify_rtp(cfg, st, read_bytes, buff)) {
            const double timediff =3D (time_user.tv_sec - time_kernel.tv_se=
c) * 1000000 + (time_user.tv_usec - time_kernel.tv_usec);
            if(timediff > st->stats.latency_us) {
                st->stats.latency_us =3D timediff;
            }
        }
    }



    int main(...) {
        ....
        while(!is_global_exit) {
            read_packets_recvmsg_with_latency(&cfg, &st, buffer, igmp_socke=
t_fd);
        }
    }

That's pretty much it.

Please note that in the described use case where I start to lose packets I =
don't use `SHARED UMEM`, it's just a single RX-Queue receiving a single mul=
ticast-stream. In case I process a smaller multicast-stream of around `150.=
000 pps` - the AF-XDP solution doesn't lose any packets. But it is also the=
 other way around - for around `520.000 pps` on the same RX-Queue (using `S=
HARED UMEM`) I get a loss of `12.000 pps`.

Any ideas what I am missing?
