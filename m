Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f51.google.com ([209.85.128.51]:38776 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfB0KwC (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 27 Feb 2019 05:52:02 -0500
Received: by mail-wm1-f51.google.com with SMTP id v26so5110516wmh.3
        for <xdp-newbies@vger.kernel.org>; Wed, 27 Feb 2019 02:52:00 -0800 (PST)
MIME-Version: 1.0
From: Kal Cutter Conley <kal.conley@dectris.com>
Date: Wed, 27 Feb 2019 11:51:48 +0100
Message-ID: <CAHApi-=wjBn54NkO5tn2Vb5vn0_YSUewrUMJ3yF1e+emJdwGvg@mail.gmail.com>
Subject: XDP full jumbo frame support
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi,
We would love to adopt AF_XDP with ZC (with i40e), however, we are a
blocked by the lack of full jumbo frame support (8000-9000 bytes). I
would like to get a feel for the feasibility of implementing support
for this. Looking through the code it seems possible to support this
through huge pages without a huge amount of effort (i may be wrong).
The first thing that came to mind is something like:
(1) Add a page_size (or similar) field to the xdp_umem struct.
(2) During UMEM registration, check if the UMEM is only made up of
huge pages, if so, save the huge page size into the umem page_size
field instead of the default constant PAGE_SIZE value.
(3) Use the umem page size (for dma mapping etc.) instead of the fixed
standard PAGE_SIZE.

Would this be a feasible solution? At least from the user (space)
perspective, this seems like relatively straightforward change: when
allocating the umem buffer, they only need to call mmap with the
appropriate huge page flags if they want to receive packets >
PAGE_SIZE.

Thanks,
Kal
