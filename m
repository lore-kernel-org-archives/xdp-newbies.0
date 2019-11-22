Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44888 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbfKVT0c (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 22 Nov 2019 14:26:32 -0500
Received: by mail-oi1-f195.google.com with SMTP id s71so7459384oih.11
        for <xdp-newbies@vger.kernel.org>; Fri, 22 Nov 2019 11:26:32 -0800 (PST)
MIME-Version: 1.0
References: <CA+ZpPeySfq2H8RsPuJj0Y8dVkT5h09OHN=udtcxsvF_5_Tj+Lw@mail.gmail.com>
In-Reply-To: <CA+ZpPeySfq2H8RsPuJj0Y8dVkT5h09OHN=udtcxsvF_5_Tj+Lw@mail.gmail.com>
From: Joubert Berger <joubert@berger-family.org>
Date: Fri, 22 Nov 2019 14:26:21 -0500
Message-ID: <CA+ZpPeziZpoJuCcRUX6s0nAiB-UoWBfVfAVKc1LYgB7QcvDSbg@mail.gmail.com>
Subject: Re: XDP - Bridge - not redirecting all UDP
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: xdp-newbies@vger.kernel.org

I did some more investigation.

First, my setup:  Raspberry Pi (ARM7) running 64-bit SuSE
(4.12.14-lp151.28.25-default)
As mentioned before I have it setup as a bridge.  eth0 is using the
lan78xx driver and eth1 is using ax88179_178a driver.

I tried to simplify things, so use xdp-tutorial/basic01-xdp-pass and
changed xdp_prog_simple() to print the destination IP address:
int  xdp_prog_simple(struct xdp_md *ctx)
{
    void *data_end =3D (void*)(long) ctx->data_end;
    void *data =3D (void*)(long) ctx->data;
    struct ethhdr *eth =3D (struct ethhdr*) data;

    if (eth + 1 > data_end) {
        return XDP_PASS;
    }

    if (eth->h_proto !=3D bpf_htons(ETH_P_IP))
        return XDP_PASS;

    struct iphdr *iph =3D data + sizeof(struct ethhdr);
    if (iph + 1 > data_end)
        return XDP_PASS;

    if (iph->protocol !=3D IPPROTO_UDP)
        return XDP_PASS;

    bpf_printk("udp: dst port: %x proto=3D%d\n", bpf_ntohl(iph->daddr),
iph->protocol);

    return XDP_PASS;
}

Then wrote a small test tool to be able to send udp packets.  I have
it set to send 20 udp packets.
When I look at trace_pipe for the above print statement, I will see
less than 20 lines.

So, for some reason, I am not getting all the packets.  Any thoughts?
I am not sure where to go from here.

On Thu, Nov 21, 2019 at 3:42 PM Joubert Berger
<joubert@berger-family.org> wrote:
>
> I have been playing around with Ilya's xdpbridge sample.  In my case, wha=
t I am interested in is pushing all UDP traffic to userspace.  All other tr=
affic can flow through my box.  So, I setup something like this:
>
> eth0 --> br0 --> eth1
>
> I then capture all packets on eth0/eth1 and return XDP_PASS for all but  =
UDP packets.  These I redirect it to the user space application. There I se=
t the UDP checksum to zero, that way I know it hit my code and then send it=
 to "other" interface.
>
> The problem is that not *all* my UDP traffic has the checksum set to zero=
.  Anyone have any ideas why that might be the case?  Why is only some of t=
he UDP traffic being pushed to user space?
>
> --joubert
>
