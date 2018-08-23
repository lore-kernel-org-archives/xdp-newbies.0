Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36680 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbeHWI13 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 23 Aug 2018 04:27:29 -0400
Received: by mail-io0-f193.google.com with SMTP id q5-v6so105630iop.3
        for <xdp-newbies@vger.kernel.org>; Wed, 22 Aug 2018 21:59:39 -0700 (PDT)
MIME-Version: 1.0
From: IMBRIUS AGER <imbrius.ager@gmail.com>
Date: Wed, 22 Aug 2018 21:59:27 -0700
Message-ID: <CAHM1nT1S64aNE8RPtqr+FPDNOOW3hDon77keuKmnO=w8krEJRw@mail.gmail.com>
Subject: Failed to call bpf_l3_csum_replace() twice for IPIP tunnel
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

hello, I am trying to modify the src addr (both inner and outer) of IPIP tunnel.

this is the testing code:

=======================================

void *data = (void *)(long)skb->data;
void *data_end = (void *)(long)skb->data_end;

struct ethhdr *eth = data;
struct iphdr *ip_outer = (void *)(eth + 1);

if (ip_outer->ihl != 5 || ip_outer + 1 > data_end)
        return;

struct iphdr *ip_inner = (void *)(ip4_outer + 1);

if (ip_inner->ihl != 5 || ip_inner + 1 > data_end)
    return;

src = 0x11111111;

/* First I modify the inner ip */
bpf_l3_csum_replace(skb, IP4_CSUM_OFF + sizeof(struct iphdr),
ip_inner->saddr, src, sizeof(src));
bpf_skb_store_bytes(skb, IP4_SRC_OFF + sizeof(struct iphdr), &src,
sizeof(src), 0);

/* Second I modify the outer ip */
bpf_l3_csum_replace(skb, IP4_CSUM_OFF, ip_outer->saddr, src, sizeof(src));
bpf_skb_store_bytes(skb, IP4_SRC_OFF, &src, sizeof(src), 0);

========================================

I found that I could only modify one of the src addr (inner or outer).
If both, the kernel always rejected the code at the first
bpf_l3_csum_replace():

========================================

Prog section '__xxxxx' rejected: Permission denied (13)!
 - Type:         3
 - Instructions: 171 (0 over limit)
 - License:      GPL

.....

96: (85) call bpf_l3_csum_replace#10
97: (61) r4 = *(u32 *)(r7 +0)
 R0=inv(id=0) R6=ctx(id=0,off=0,imm=0)
R7=map_value(id=0,off=0,ks=4,vs=4,imm=0) R8=inv(id=0) R9=inv(id=0)
R10=fp0
98: (61) r3 = *(u32 *)(r9 +26)
R9 invalid mem access 'inv'

Error fetching program/map!
Unable to load program

========================================

I tried to validate the pointer again before the second modification.
But nothing good has happened.

if (ip_outer->ihl != 5 || ip_outer + 1 > data_end)
        return;
/* Second I modify the outer ip */
bpf_l3_csum_replace(skb, IP4_CSUM_OFF, ip_outer->saddr, src, sizeof(src));
bpf_skb_store_bytes(skb, IP4_SRC_OFF, &src, sizeof(src), 0);


Any idea?
Thanks very much
