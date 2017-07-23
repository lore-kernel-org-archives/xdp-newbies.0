Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:59597 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751839AbdGWXy3 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 23 Jul 2017 19:54:29 -0400
Date: Sun, 23 Jul 2017 16:54:20 -0700
From: Jakub Kicinski <kubakici@wp.pl>
Subject: Re: XDP/BPF C and python libraries?
Message-ID: <20170723165420.5916f2a2@cakuba.netronome.com>
In-Reply-To: <20170722002050.315717be@cakuba.netronome.com>
References: <20170720225308.14e2ac14@cakuba.netronome.com>
        <5971D5D6.8010300@iogearbox.net>
        <20170721153743.31cd84a0@cakuba.netronome.com>
        <20170722002050.315717be@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: xdp-newbies@vger.kernel.org, ast@fb.com, Martin KaFai Lau <kafai@fb.com>, Hannes Frederic Sowa <hannes@redhat.com>

On Sat, 22 Jul 2017 00:20:50 -0700, Jakub Kicinski wrote:
> One thing which is not clear to me is how to get the association
> between programs and maps?  Would we need to extend
> BPF_OBJ_GET_INFO_BY_FD to provide this info?

Another thing that I can't find a way of doing is telling whether BPF fs
file is representing a map or a program.  Is there a way to do this
today?
