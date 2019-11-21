Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:41847 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfKUVYU (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 21 Nov 2019 16:24:20 -0500
Received: from [10.5.0.3] ([37.201.193.25]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MCqWJ-1ifugy0epf-009kYj for
 <xdp-newbies@vger.kernel.org>; Thu, 21 Nov 2019 22:24:19 +0100
From: Christoph Kuhr <christoph.kuhr@web.de>
Subject: Access Hardware Timestamp in eBPF Program
Message-ID: <ce15150c-01e4-5621-0d13-ebe0f7cd2333@web.de>
Date: Thu, 21 Nov 2019 22:24:13 +0100
MIME-Version: 1.0
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
To: xdp-newbies@vger.kernel.org

Hi *,

in my program I use CMSGs to access hardware arrival timestamps of an
Intel I210 rx queue.

Is there a way to access such timestamps in a XDP eBPF program?

Best regards,
Christoph Kuhr
