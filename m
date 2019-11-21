Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37017 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfKUXJi (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 21 Nov 2019 18:09:38 -0500
Date: Fri, 22 Nov 2019 00:16:36 +0100
From: Piotr Raczynski <piotr.raczynski@intel.com>
Subject: Re: Access Hardware Timestamp in eBPF Program
Message-ID: <20191121231636.GA5888@DEV.igk.intel.com>
References: <ce15150c-01e4-5621-0d13-ebe0f7cd2333@web.de>
MIME-Version: 1.0
In-Reply-To: <ce15150c-01e4-5621-0d13-ebe0f7cd2333@web.de>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
To: Christoph Kuhr <christoph.kuhr@web.de>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Thu, Nov 21, 2019 at 09:24:13PM +0000, Christoph Kuhr wrote:
> Hi *,
>=20
> in my program I use CMSGs to access hardware arrival timestamps of an
> Intel I210 rx queue.

Hi Christoph,

First of all I210 does not support native XDP. It still means that=20
you can use XDP but in so called generic mode which works for all net
devices. However it's not as quick as native implementation in the
driver, because it operates after skb is allocated.

Actually it's way slower, but it can still be much faster in many
cases than regular *sbk* path.
=20
> Is there a way to access such timestamps in a XDP eBPF program?

Unfortunately, as of now there is no universal way for XDP programs,
even in native mode, to access information taken from hardware,
e.g. from Rx descriptor. Technically it would be possible, but there
are no interfaces now that would allow common scheme for different
drivers. Right now it is possible to convey additional information
to xdp buff via data_meta field, but now it's strictly driver
specific and XDP programs has no direct information into what is
in the data_meta section.

Given that I210 would only work in generic mode, this would be
even more difficult since as I checked, with current implementation
when skb is *converted* back to xdp_buff it does not support passing
data_meta from skb to XDP.

>=20
> Best regards,
> Christoph Kuhr
