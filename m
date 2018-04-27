Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:45988 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758357AbeD0NyP (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 27 Apr 2018 09:54:15 -0400
Subject: Re: egress packet filtering
References: <CAArOQ2UJDD-kA3O9h-MZTedhyRfXg4UC=QM-Hdw9tzPoe__ZvQ@mail.gmail.com>
 <fd4bc543-a590-ab95-145e-0b3a76e6b892@solarflare.com>
 <CAArOQ2X+VfNCejk8HwqfZ38Ed253EShshvXkL-=Ay_bd9ahPuQ@mail.gmail.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <73dc8184-d653-8730-8b2e-ebbf7c56502a@iogearbox.net>
Date: Fri, 27 Apr 2018 15:54:13 +0200
MIME-Version: 1.0
In-Reply-To: <CAArOQ2X+VfNCejk8HwqfZ38Ed253EShshvXkL-=Ay_bd9ahPuQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Bobby Powers <bobbypowers@gmail.com>, Edward Cree <ecree@solarflare.com>
Cc: xdp-newbies@vger.kernel.org

On 04/27/2018 03:41 PM, Bobby Powers wrote:
> On Fri, Apr 27, 2018 at 9:36 AM, Edward Cree <ecree@solarflare.com> wrote:
>> The higher performance of XDP is because the processing, being done in
>>  the driver, happens earlier in the RX path (thus avoiding the bulk of
>>  network stack processing for packets that e.g. are only going to be
>>  dropped anyway).
>> But on TX, the analogous driver code would be the _last_ thing in the
>>  path, rather than the first, so in such a case the `tc` approach
>>  should probably perform better than an XDP analogue.
> 
> Thanks, that is super useful for my mental model!
> 
> Does that mean it is possible (if slow) to use an XDP filter for TX?
> I attached a simple one based on the DDOS filter from here:
> 
> https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/samples/bpf
> 
> that just debug logged IPs + ports, and I only seemed to see incoming
> (and not outgoing) packets in the logs.  Is there a different/extra
> flag to pass to have an XDP filter run on TX?

Check out the extensive doc at http://cilium.readthedocs.io/en/latest/bpf/
there are XDP and tc program types described besides many other things.
What you propose to attach BPF to tc's clsact egress hook would be most
suitable for what you describe.

Thanks,
Daniel
