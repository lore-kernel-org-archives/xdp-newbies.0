Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgFBSXd (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 2 Jun 2020 14:23:33 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527EBC08C5C0
        for <xdp-newbies@vger.kernel.org>; Tue,  2 Jun 2020 11:23:33 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id x1so13701234ejd.8
        for <xdp-newbies@vger.kernel.org>; Tue, 02 Jun 2020 11:23:33 -0700 (PDT)
MIME-Version: 1.0
References: <CA+Jwd2y5Pjh+QMrH9vjBtHhvG2EC1MCfm-A2Pq2hjRPEvJ1J1Q@mail.gmail.com>
 <87d06hzvr8.fsf@toke.dk> <CA+Jwd2z4_tGfh9wS_CJQL36O_vYyv5knXkm6=A+UvNNtojEcrw@mail.gmail.com>
 <877dwpmp7f.fsf@toke.dk>
In-Reply-To: <877dwpmp7f.fsf@toke.dk>
From: maharishi bhargava <bhargavamaharishi@gmail.com>
Date: Tue, 2 Jun 2020 23:53:19 +0530
Message-ID: <CA+Jwd2xnb8Nuc6Y2V=04fBa2bXfaMy1FPyK8CsFnOkqyxrtEwg@mail.gmail.com>
Subject: Re: XDP_REDIRECT with xsks_map and dev_map
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc: xdp-newbies@vger.kernel.org

On Tue, Jun 2, 2020 at 9:31 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
> maharishi bhargava <bhargavamaharishi@gmail.com> writes:
>
> > On Tue 2 Jun, 2020, 14:31 Toke Høiland-Jørgensen, <toke@redhat.com> wrote:
> >>
> >> maharishi bhargava <bhargavamaharishi@gmail.com> writes:
> >>
> >> > Hi, in my XDP program, I want to redirect some packets using AF_XDP
> >> > and redirect other packets directly from driver space.
> >> > Redirection through AF_XDP works fine, but redirection through dev map
> >> > stops after some packets are processed.
> >>
> >> Do you mean it stops even if you are *only* redirecting to a devmap, or
> >> if you are first redirecting a few packets to AF_XDP, then to devmap?
> >>
> >> Also, which driver(s) are the physical NICs you're redirecting to/from
> >> using, and which kernel version are you on?
> >>
> >> -Toke
> >
> >
> >
> > Currently, I'm trying to redirect packets only using devmap. But also
> > have code for redirection using AF_XDP(only when a given condition is
> > satisfied). A DPDK program is running in userspace which will receive
> > packets from AF_XDP.
>
> Right, so it's just devmap redirect that breaks. What do you mean
> 'redirection stops', exactly? How are you seeing this? Does xdp_monitor
> (from samples/bpf) report any exceptions?
>
> -Toke
>
So, In my setup, there are three systems, Let's Assume A, B, C. System
B is acting as a forwarder between A and C. So I can see the number of
packets received at system C. To be specific, only 1024 packets are
received. If I remove the xsks_map part from the code and don't run
DPDK in userspace. This problem does not occur. Also if I forward all
the packets using AF_XDP, there is no such issue.

- Maharishi
