Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it1-f170.google.com ([209.85.166.170]:36504 "EHLO
        mail-it1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfAMRqj (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 13 Jan 2019 12:46:39 -0500
Received: by mail-it1-f170.google.com with SMTP id c9so9399604itj.1
        for <xdp-newbies@vger.kernel.org>; Sun, 13 Jan 2019 09:46:38 -0800 (PST)
MIME-Version: 1.0
From: Pavel Popa <pashinho1990@gmail.com>
Date: Sun, 13 Jan 2019 18:46:26 +0100
Message-ID: <CAHOxX0y+aAcZjLBp-=N=ix1nw-PDnOVRS5LW_BpkTuRT5Az9tA@mail.gmail.com>
Subject: eBPF parsing of network protocol's optional headers
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi all,

I hope this might be a right place for asking this.
So, as per subj, I'm fighting (seems in vain) with the verifier for
parsing optional headers of a network tunneling protocol. The
following is the layout of the tunneling protocol's optional header:

struct somehdr_ext
{
    uint8_t len;            /* Length of the extension in 4-octet units */
    uint8_t content[];    /* Content of the extension */
}

The following is the interested code snippet:

int some_parser(struct xdp_md *ctx)
{
    void *data = (void *)(long)ctx->data;
    void *data_end = (void *)(long)ctx->data_end;
    struct somehdr_ext *ext = data + some_fixed_offset;

    if (ext + 2 > data_end)
        return -1;
    if (ext->len == 0)
        return -1;

    if (ext->content + (ext->len * 4) > data_end)  // hopefully make
the BPF verifier happy
        return -1;

    /* the verifier is happy with this */
    return ext->content[0];
    /* but not with this
     * ext->content[1]; // from 1 to ((ext->len * 4) - 1)
     * WHY???
     */
}

Specifically, the verifier complains about the following:
183: (71) r1 = *(u8 *)(r4 +0)
184: (07) r4 += 1
185: (67) r1 <<= 2
186: (bf) r2 = r4
187: (0f) r2 += r1
188: (2d) if r2 > r7 goto pc+29
 R0=map_value(id=0,off=0,ks=4,vs=32,imm=0)
 R1=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc))
R2=pkt(id=6,off=13,r=13,umin_value=12,umax_value=2307,var_off=(0x0;
0xfff)) R3=inv(id=0,umin_value=12,umax_value=1032,var_off=(0x0;
0x7fc)) R4=pkt(id=5,off=13,r=14,umin_value=12,umax_value=1287,var_off=(0x0;
0x7ff)) R5=inv(id=0,umax_value=255,var_off=(0x0; 0xff))
R6=ctx(id=0,off=0,imm=0) R7=pkt_end(id=0,off=0,imm=0)
R8=pkt(id=0,off=0,r=14,imm=0) R10=fp0,call_-1
189: (71) r1 = *(u8 *)(r4 +1)
invalid access to packet, off=14 size=1, R4(id=5,off=13,r=14)
R4 offset is outside of the packet

I understand what the verifier is afraid of with this message,
basically potentially dereferencing memory outside of the packet's
context [data, data_end] valid range. What I don't get is why this:
    if (ext->content + (ext->len * 4) > data_end)
        return -1;
doesn't make him happy for avoiding precisely the complaining message.
In fact, it seems to me that my attempt might be completely futile. Is
there any work around to this?

Thank you
