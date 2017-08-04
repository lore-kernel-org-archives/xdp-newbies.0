Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34051 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752121AbdHDWUV (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 4 Aug 2017 18:20:21 -0400
Received: by mail-pf0-f174.google.com with SMTP id o86so12693749pfj.1
        for <xdp-newbies@vger.kernel.org>; Fri, 04 Aug 2017 15:20:21 -0700 (PDT)
Subject: Re: XDP/BPF C and python libraries?
References: <20170720225308.14e2ac14@cakuba.netronome.com>
 <5971D5D6.8010300@iogearbox.net>
 <20170721153743.31cd84a0@cakuba.netronome.com>
 <20170722002050.315717be@cakuba.netronome.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <e3f6bfa8-abee-4467-9647-4c6ab7e8232a@gmail.com>
Date: Fri, 4 Aug 2017 16:20:19 -0600
MIME-Version: 1.0
In-Reply-To: <20170722002050.315717be@cakuba.netronome.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <kubakici@wp.pl>, Daniel Borkmann <daniel@iogearbox.net>
Cc: xdp-newbies@vger.kernel.org, ast@fb.com, Martin KaFai Lau <kafai@fb.com>, Hannes Frederic Sowa <hannes@redhat.com>

On 7/22/17 1:20 AM, Jakub Kicinski wrote:
> I put together this very simple tool with iproute2-like syntax:
> 
> https://github.com/Netronome/bpf-tool
> 
> These are available subcommands:
> 

Looking to add my code that pretty-prints instructions, but having
trouble building the tool. What bpf headers should be installed? e.g.,
<bpf/bpf.h>. hunting and pecking now based on what is in the kernel tree.
