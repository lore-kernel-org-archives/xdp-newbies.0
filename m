Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:36896 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdGGG53 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 7 Jul 2017 02:57:29 -0400
Received: by mail-it0-f43.google.com with SMTP id m84so26777707ita.0
        for <xdp-newbies@vger.kernel.org>; Thu, 06 Jul 2017 23:57:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170706103613.70b5cecb@redhat.com>
References: <CAPF+HwVtau0R9tywwhuqpB_wXJp_RxfRD-s5KQr_Y-ofFWiSSA@mail.gmail.com>
 <d7a25483-b3ce-0635-c00a-11c94662138e@gmail.com> <CAPF+HwU8AmO82N986acfie5qp1hDm3skfG+46Tg1fwNP+C--uQ@mail.gmail.com>
 <f72ede56-eed2-502c-75c2-bc4296d709c9@gmail.com> <20170706103613.70b5cecb@redhat.com>
From: Donatas Abraitis <donatas.abraitis@gmail.com>
Date: Fri, 7 Jul 2017 09:57:27 +0300
Message-ID: <CAPF+HwWiJEiscRW0vt=J9mWqp8GOA0ZKJUXw99cixduR=C=bZg@mail.gmail.com>
Subject: Re: XDP for very newbies
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Jean-Philippe Menil <jpmenil@gmail.com>, xdp-newbies@vger.kernel.org

Awesome, I see better direction right now ;-)

On Thu, Jul 6, 2017 at 11:36 AM, Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Wed, 5 Jul 2017 21:31:32 +0200 Jean-Philippe Menil <jpmenil@gmail.com> wrote:
>
>> On 07/05/2017 09:23 PM, Donatas Abraitis wrote:
>> > Yeah, but I cannot find anything useful regarding generic XDP which is
>> > a new feature.
>> >
>> > On Wed, Jul 5, 2017 at 10:00 PM, Jean-Philippe Menil <jpmenil@gmail.com> wrote:
>> >> On 07/05/2017 08:36 PM, Donatas Abraitis wrote:
>> >>>
>> >>> Hi folks!
>> >>>
>> >>> I see some isolated examples about XDP, but cannot find any good
>> >>> tutorial in one place starting from theory to practical examples. Who
>> >>> can recommend something as a starting point?
>> >>>
>> >>> I would like to try Generic XDP or so.
>> >>>
>> >>
>> >> Hi Donatas,
>> >>
>> >> There is tons of stuff already referenced by Quentin:
>> >> https://qmonnet.github.io/whirl-offload/2016/09/01/dive-into-bpf/
>> >>
>> >> It's bpf oriented, but there is a lot of links/docs in the "About XDP"
>> >> section.
>> >>
>>
>> Hi,
>>
>> Take a look to the blogspot from Jesper:
>> http://prototype-kernel.readthedocs.io/en/latest/blogposts/xdp25_eval_generic_xdp_tx.html
>
> Thanks for mentioning this document.
>
> There is a general introduction to XDP here:
>  https://prototype-kernel.readthedocs.io/en/latest/networking/XDP/introduction.html
>
>
> I'm developing some practical examples to get people started using
> XDP and eBPF.  I've made an effort to detect common errors and tool
> chain setup issues, and give error messages with elaborate hints.
>
> They are placed in my github repo:
>  https://github.com/netoptimizer/prototype-kernel
>  https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/samples/bpf
>
> The generic XDP feature can be activated with cmdline option
> "--skb-mode" in (most of) my examples.
>
> The blacklist example were used in a tutorial session at NetDevConf 2.1:
>  http://netdevconf.org/2.1/session.html?gospodarek
>  Slides: http://netdevconf.org/2.1/slides/apr7/gospodarek-Netdev2.1-XDP-for-the-Rest-of-Us_Final.pdf
>  Video: https://youtu.be/iBkR4gvjxtE?t=2m1s
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer



-- 
Donatas
