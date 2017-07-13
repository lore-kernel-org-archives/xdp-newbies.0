Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:54618 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752587AbdGMToT (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 13 Jul 2017 15:44:19 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        by serv108.segi.ulg.ac.be (Postfix) with ESMTP id DB22C200A57C
        for <xdp-newbies@vger.kernel.org>; Thu, 13 Jul 2017 21:34:18 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id BC196129EAEB
        for <xdp-newbies@vger.kernel.org>; Thu, 13 Jul 2017 21:34:18 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id L_Gj5RAZgkIG for <xdp-newbies@vger.kernel.org>;
        Thu, 13 Jul 2017 21:34:18 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 98AB8129EAEA
        for <xdp-newbies@vger.kernel.org>; Thu, 13 Jul 2017 21:34:18 +0200 (CEST)
Date: Thu, 13 Jul 2017 21:34:17 +0200 (CEST)
From: tom.barbette@ulg.ac.be
Message-ID: <1667638588.29757437.1499974457843.JavaMail.zimbra@ulg.ac.be>
Subject: XDP for Kernel by-pass?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi all,

Can XDP be used for "skbuff bypass"? Like a rx_handler but closer to the driver? I'm not very familiar with eBPF, could it be used to pass the kernel to any kernel module or userspace application?

It looks to me that bpf_func in struct bpf_prog could be any function that we could use to deviate XDP and use it for that purpose. Correct?

Kernel app like Click or OVS could benefit from that as they don't use most skbuff facilities.

Thanks,

Tom
