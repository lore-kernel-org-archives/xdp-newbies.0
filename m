Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:60454 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbfDQNp6 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 17 Apr 2019 09:45:58 -0400
Subject: Re: XDP chain using tail calls
References: <CAM-scZOqYquo2X94K0x9FQc4iGwWODuLXKxhAatn5g2H6+ZhQA@mail.gmail.com>
 <87tvewrcel.fsf@toke.dk>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <db4365d4-31d7-6834-bd36-d71568026210@iogearbox.net>
Date: Wed, 17 Apr 2019 15:29:12 +0200
MIME-Version: 1.0
In-Reply-To: <87tvewrcel.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>, Radu Stoenescu <radu.stoe@gmail.com>, xdp-newbies@vger.kernel.org

On 04/17/2019 03:26 PM, Toke Høiland-Jørgensen wrote:
> Radu Stoenescu <radu.stoe@gmail.com> writes:
> 
>> Hello
>>
>> I was recently reading through the XDP documentation from Cilium[1]
>> and I couldn't really wrap my head around the tail cal section.
>>
>> Is there any tutorial/code example of using this feature with XDP?
> 
> Hmm, I'm not sure there are any current examples. But you make a good
> point, we should probably have one. We're building an interactive
> tutorial here: https://github.com/xdp-project/xdp-tutorial - please feel
> free to open an issue here requesting it to be added! :)

Wrt iproute2, there's some simple examples to start here:

  https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/tree/examples/bpf

If you need more elaborate ones, you might want to check out:

  https://github.com/cilium/cilium/tree/master/bpf

Cheers,
Daniel
