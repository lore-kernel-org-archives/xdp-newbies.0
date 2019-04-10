Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35626 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfDJCjQ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 9 Apr 2019 22:39:16 -0400
Received: by mail-pg1-f195.google.com with SMTP id g8so580814pgf.2
        for <xdp-newbies@vger.kernel.org>; Tue, 09 Apr 2019 19:39:16 -0700 (PDT)
Date: Tue, 9 Apr 2019 19:39:11 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH] net:bridge:always disable auto-tuning when the user
 specified MTU
Message-ID: <20190409193911.2d68a64d@shemminger-XPS-13-9360>
In-Reply-To: <20190410023208.25435-1-huangruiPPP@gmail.com>
References: <20190410023208.25435-1-huangruiPPP@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Huang Rui <huangruippp@gmail.com>
Cc: davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, jiri@mellanox.com, ecree@solarflare.com, idosch@mellanox.com, petrm@mellanox.com, alexander.h.duyck@intel.com, amritha.nambiar@intel.com, lirongqing@baidu.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com, bridge@lists.linux-foundation.org

On Wed, 10 Apr 2019 02:32:08 +0000
Huang Rui <huangruippp@gmail.com> wrote:

> For example.
> My purpose is to create a bridge br0 and join eth0 into br0.
> if we use this following way, the auto-tuning flag will not be disabled.
> 
> If eth0's mtu is 1200
> step 1.brctl addbr br0
> step 2.brctl addif br0 eth0
> step 3.ifconfig br0 mtu 1200
> step 4.ifconfig eth0 mtu 1500
> 
> Result:
> br0's MTU: 1500, eth0's MTU: 1500
> 
> Expected:
> br0's MTU: 1200, eth0's MTU: 1500
> 
> I have specified br0's MTU,  but auto-min policy works. So the MTU is
> not the result what we expected.
> As expected, if i have specified bridge's MTU, it will set the flag:
> BROPT_MTU_SET_BY_USER in net_bridge_opts disabled and auto-min/max
> policy will not work.But in this case, because the dev_set_mtu return
> early, the BROPT_MTU_SET_BY_USER flag will not be disabled and
> auto-min/max policy will still work.
> 
> Signed-off-by: Huang Rui <huangruiPPP@gmail.com>

A bridge like this going to drop frames.
A frame received with MTU of 1200 will get dropped.
The proper way to do this is to change MTU of both interfaces to match.
