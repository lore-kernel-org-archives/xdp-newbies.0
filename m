Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from 1.mo173.mail-out.ovh.net ([178.33.111.180]:50679 "EHLO
        1.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727632AbfC0R1v (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 27 Mar 2019 13:27:51 -0400
Received: from player788.ha.ovh.net (unknown [10.109.159.152])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id A947BFAF94
        for <xdp-newbies@vger.kernel.org>; Wed, 27 Mar 2019 18:10:12 +0100 (CET)
Received: from simonbernard.eu (134.163-14-84.ripe.coltfrance.com [84.14.163.134])
        (Authenticated sender: contact@simonbernard.eu)
        by player788.ha.ovh.net (Postfix) with ESMTPSA id 5966E41B4164
        for <xdp-newbies@vger.kernel.org>; Wed, 27 Mar 2019 17:10:12 +0000 (UTC)
From: Simon Bernard <contact@simonbernard.eu>
Subject: Any good practice for bpf_helpers.h ?
Message-ID: <d16e652e-f9a7-62a4-4aab-87e067c92d6d@simonbernard.eu>
Date: Wed, 27 Mar 2019 18:10:10 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi,

There is something I didn't get so much about compiling a bpf object.

To compile my code for bpf, I need to include some headers from the 
kernel, which sounds OK.
On my debian, I understood this is something like this :
-I/lib/modules/4.19.0-0.bpo.2-amd64/build/include
-I/lib/modules/4.19.0-0.bpo.2-amd64/build/include/generated/uapi
(Please tell me if I should include more headers or if this is the 
minimal set)

But I also need to to include some bpf helpers headers, generally called 
as bpf_helpers.h or bpf_endian.h. I didn't find this files in my 
distribution and I see a lot of open source examples/projects where 
those files are provided in the project itself... But as I understand 
the function helpers available depend of the bpf version and so the 
kernel version itself.

So why this is not available in my system kernel header ?
Is it normal ? (all the distribution do that?)
"adding this kind of file to my src tree for compilation" is the right 
thing to do ? (That sounds not so good ...)

I would really appreciate some hints to better understand that !

Thx

Simon

(my code is available here : 
https://github.com/sbernard31/udploadbalancer/tree/bpf_only_without_logs)
