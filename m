Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-eopbgr670066.outbound.protection.outlook.com ([40.107.67.66]:9729
        "EHLO CAN01-TO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726118AbfHARdk (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 1 Aug 2019 13:33:40 -0400
From: Brandon Cazander <brandon.cazander@multapplied.net>
Subject: Re: xdpgeneric, XDP_PASS, and bpf_xdp_adjust_head decapsulation
 dropping packets
Date: Thu, 1 Aug 2019 17:33:36 +0000
Message-ID: <20190801173324.GA660183@multapplied.net>
References: <20190731211211.GA87084@multapplied.net>
 <20190801101746.702431fc@carbon>
In-Reply-To: <20190801101746.702431fc@carbon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FB2932EFD844024F9D964A22DB3F44F2@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, David Miller <davem@davemloft.net>

Thank you very much for your prompt and detailed review of my report!
Some of these answers may be moot now that you have found the specific
commit that caused the issue.

On Thu, Aug 01, 2019 at 10:18:49AM +0200, Jesper Dangaard Brouer wrote:

> Are you sure you are using "xdpgeneric" mode?
> As virtio_net do have "native" XDP mode.

The program is loaded with XDP_FLAGS_SKB_MODE in this case. I'm having a
separate issue with "native" XDP on virtio_net that I'm working on but
it is more likely an issue with my code.

> Encapsulated packet starts at a funny offset, making it harder to follow.

Sorry about that. I should have made it easier.

> Looking at the code, I think the packet will be dropped earlier than
> the pskb_trim_rcsum() call, in the check if (skb->len < len).

I had the same suspicion but a probe in the corresponding drop showed no
results, and furthermore, the InTruncatedPkts SNMP counter was not
increasing.

> You only support IPv4 encapsulated packets?
>=20
> Do you handle ARP requests separately?

Sorry, I wanted a minimal example so this is stripped down.

> Can you test an earlier kernel, specifically before: commit
> 458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
> (Author: Stephen Hemminger)
>=20
> $ git describe --contains  458bf2f224f04
> v5.2-rc3~26^2~11^2
>=20
> I fear that this commit, which moved generic-XDP to a later call point,
> might cause this.  Because it could be that the SKB network_header
> update, is now done before calling XDP program (... still looking at
> code details).

You have already confirmed this but I can also confirm that a kernel
before commit 458bf2f224f0 works with no changes to my program.
