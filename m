Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f50.google.com ([209.85.128.50]:56114 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfBYJbs (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 25 Feb 2019 04:31:48 -0500
Received: by mail-wm1-f50.google.com with SMTP id q187so7327104wme.5
        for <xdp-newbies@vger.kernel.org>; Mon, 25 Feb 2019 01:31:47 -0800 (PST)
MIME-Version: 1.0
From: papito favaro <papito.favaro@gmail.com>
Date: Mon, 25 Feb 2019 10:31:35 +0100
Message-ID: <CAM2iwThehyFZnG6Ynp0nm0K18s157EEVG0LUiR==JTMMzTXWiA@mail.gmail.com>
Subject: Umem Ring Description layout
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi all,
I would like to keep the state of the ring (cache_prod, mask, size)
after the actual prod index.
i.e

X ring:

0        4                                          64
| prod  | cache_prod  | mask | size | ... |
| cons | cache_cons | mask | size | ... |
| begin of ring ...                                |

my issue is not to write in a memory region that i don't own. You see
any problems with this?

thank you for your time
