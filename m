Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from fanzine.igalia.com ([91.117.99.155]:41739 "EHLO
        fanzine.igalia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbeKBCPo (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 1 Nov 2018 22:15:44 -0400
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
        by fanzine.igalia.com with esmtps
        (Cipher TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim)
        id 1gIGCz-0002fb-QC
        for <xdp-newbies@vger.kernel.org>; Thu, 01 Nov 2018 17:52:37 +0100
Received: from webmail.local.igalia.com ([192.168.10.121])
        by mail.igalia.com with esmtps
        (Cipher TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim)
        id 1gIGCx-00005h-Hg
        for <xdp-newbies@vger.kernel.org>; Thu, 01 Nov 2018 17:52:37 +0100
Received: from localhost ([127.0.0.1] helo=webmail.igalia.com)
        by webmail.local.igalia.com with esmtp (Exim 4.84_2)
        (envelope-from <kdjimeli@igalia.com>)
        id 1gIGCx-0003UV-Dv
        for xdp-newbies@vger.kernel.org; Thu, 01 Nov 2018 17:52:35 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Thu, 01 Nov 2018 17:52:35 +0100
From: Konrad Djimeli <kdjimeli@igalia.com>
Subject: AF_XDP socket (sock2)  unable to read, after writing with another
 AF_XDP socket (sock1)
Message-ID: <ad85176a72e82878a4073a4215aa5e3a@igalia.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hello,

I am working on developing a Snabb Switch app which uses Af_XDP sockets
and so far I have not found any AF_XDP sample example online, except for
the sample in the Linux Kernel source. I have tried modifying the
example, to create two sockets (sock1 and sock2) sharing a UMEM with
custom write_sock and read_sock functions. But when I do a write with
"sock1" I am unable to read the data with "sock2". Here is the code
https://github.com/djkonro/afxdp/blob/master/xdpsock/xdpsock_user.c ,
and I am new to working with AF_XDP sockets and I wish I could get some
pointers to what may be wrong with the program. 

Thanks,
Konrad
www.djimeli.me
