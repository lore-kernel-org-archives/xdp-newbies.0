Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:42321 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751619AbdISXYL (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 19 Sep 2017 19:24:11 -0400
Message-ID: <59C1A719.90909@iogearbox.net>
Date: Wed, 20 Sep 2017 01:24:09 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: [PATCH RFC 0/4] Initial 32-bit eBPF encoding support
References: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com> <59C03AC5.3080109@iogearbox.net> <f7eb81db-a758-d49d-4c09-08a017b02e98@netronome.com>
In-Reply-To: <f7eb81db-a758-d49d-4c09-08a017b02e98@netronome.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jiong Wang <jiong.wang@netronome.com>
Cc: xdp-newbies@vger.kernel.org, llvm-dev@lists.llvm.org, iovisor-dev@lists.iovisor.org, oss-drivers@netronome.com, ys114321@gmail.com

On 09/20/2017 01:20 AM, Jiong Wang wrote:
> On 18/09/2017 22:29, Daniel Borkmann wrote:
[...]
>> Great to see work in this direction! Can we also enable to use / emit
>> all the 32bit BPF_ALU instructions whenever possible for the currently
>> available bpf targets while at it (which only use BPF_ALU64 right now)?
>
> Hi Daniel,
>
>     Thanks for the feedback.
>
>     I think we could also enable the use of all the 32bit BPF_ALU under currently
> available bpf targets.  As we now have 32bit register set support, we could make
> i32 type as legal type to prevent it be promoted into i64, then hook it up with i32
> ALU patterns, will look into this.

Great, thanks!
