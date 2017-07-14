Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:44141 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbdGNJob (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 14 Jul 2017 05:44:31 -0400
Message-ID: <5968927B.2010108@iogearbox.net>
Date: Fri, 14 Jul 2017 11:44:27 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: XDP for Kernel by-pass?
References: <1667638588.29757437.1499974457843.JavaMail.zimbra@ulg.ac.be> <5967DBC3.5060509@iogearbox.net> <CAPWQB7Gb12L6FuP5LbVUXQLodzdv3j_T2FO57gCz17ZE1ktidQ@mail.gmail.com> <1702257840.29879018.1500021982749.JavaMail.zimbra@ulg.ac.be>
In-Reply-To: <1702257840.29879018.1500021982749.JavaMail.zimbra@ulg.ac.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: tom.barbette@ulg.ac.be
Cc: Joe Stringer <joe@ovn.org>, xdp-newbies@vger.kernel.org, john.fastabend@gmail.com

On 07/14/2017 10:46 AM, tom.barbette@ulg.ac.be wrote:
[...]
> Netmap hooks exactly where XDP does. We would just need a little shared-memory module that hooks in XDP and give all the raw packets to a userspace program.

There is work in progress for a faster AF_PACKET interface for RX/TX, which would
be a much better fit given AF_PACKET's purpose. Some RFC patches have been posted
here [1][2] some time ago.

  [1] http://patchwork.ozlabs.org/patch/720937/
  [2] http://patchwork.ozlabs.org/patch/720936/

> Tom
