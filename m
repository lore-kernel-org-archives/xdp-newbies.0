Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:37183 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750793AbdGUF7z (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 21 Jul 2017 01:59:55 -0400
Received: from unknown (HELO cakuba.netronome.com) (kubakici@wp.pl@[75.53.12.129])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <xdp-newbies@vger.kernel.org>; 21 Jul 2017 07:53:13 +0200
Date: Thu, 20 Jul 2017 22:53:08 -0700
From: Jakub Kicinski <kubakici@wp.pl>
Subject: XDP/BPF C and python libraries?
Message-ID: <20170720225308.14e2ac14@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi!

I've been writing various cli programs and little tools to play with
XDP and maps lately (testing NFP map offload).  I have a simple CLI
for loading programs, setting XDP up and interacting with maps.  It's
based on libbpf from tools/ and the loader from samples/bpf.  I wonder
how do others perform basic map interactions?  Perhaps I'm approaching
the problem from the wrong side?  Is anyone working on command line
interface for simple update/dump/delete operations?

I think it's recommended to use bpffs, are there any tools for
interacting with it?

Are there any Python libraries which could take care of parsing ELF
files and poking maps?  My understanding is that BCC is not really the
tool for the job, because it's too high-level.  I don't want to compile
programs each time I want to load them.

On the kernel sources - I'm pretty sure this was discussed on netdev
but I forgot the conclusion :( - is it possible to move
samples/bpf/bpf_load.c in some form to libbpf?
