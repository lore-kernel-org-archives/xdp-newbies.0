Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:35771 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdHET7I (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Sat, 5 Aug 2017 15:59:08 -0400
Received: by mail-pf0-f176.google.com with SMTP id t86so19748587pfe.2
        for <xdp-newbies@vger.kernel.org>; Sat, 05 Aug 2017 12:59:08 -0700 (PDT)
Subject: Re: XDP/BPF C and python libraries?
References: <20170720225308.14e2ac14@cakuba.netronome.com>
 <5971D5D6.8010300@iogearbox.net>
 <20170721153743.31cd84a0@cakuba.netronome.com>
 <20170722002050.315717be@cakuba.netronome.com>
 <e3f6bfa8-abee-4467-9647-4c6ab7e8232a@gmail.com>
 <20170805094058.42b2fe3e@cakuba>
From: David Ahern <dsahern@gmail.com>
Message-ID: <dab96175-f70c-bc60-bedf-8d66f2f23c30@gmail.com>
Date: Sat, 5 Aug 2017 13:59:01 -0600
MIME-Version: 1.0
In-Reply-To: <20170805094058.42b2fe3e@cakuba>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: Daniel Borkmann <daniel@iogearbox.net>, xdp-newbies@vger.kernel.org, ast@fb.com, Martin KaFai Lau <kafai@fb.com>, Hannes Frederic Sowa <hannes@redhat.com>

On 8/5/17 10:40 AM, Jakub Kicinski wrote:
> On Fri, 4 Aug 2017 16:20:19 -0600, David Ahern wrote:
>> On 7/22/17 1:20 AM, Jakub Kicinski wrote:
>>> I put together this very simple tool with iproute2-like syntax:
>>>
>>> https://github.com/Netronome/bpf-tool
>>>
>>> These are available subcommands:
>>>   
>>
>> Looking to add my code that pretty-prints instructions, but having
>> trouble building the tool. What bpf headers should be installed? e.g.,
>> <bpf/bpf.h>. hunting and pecking now based on what is in the kernel tree.
> 
> Hmm..  Did you run make install_headers?  I think my commit message
> diverged from what the Makefile does.  To keep things in line with
> tools/lib/traceevent/Makefile I made it a separate target.
> 
> I just tested on fresh Fedora 26 w/ net-next:

I'm on Debian jessie with net-next. I added EXTRA_CFLAGS to the Makefile
and pass in paths using it, so I have the tool compiled. make on jessie
was complaining about initializations as well.

And adding the pretty-print code was straightforward. I need to do some
cleanups before sending a patch.
