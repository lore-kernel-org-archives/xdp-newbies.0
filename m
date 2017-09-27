Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:42174 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752456AbdI0QkX (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 27 Sep 2017 12:40:23 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTP id 967B7A18B3
        for <xdp-newbies@vger.kernel.org>; Wed, 27 Sep 2017 16:31:49 +0000 (UTC)
Received: from pure.maildistiller.com (dispatch1.mdlocal [10.7.20.164])
        by dispatch1-us1.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTP id 31E5C6004F
        for <xdp-newbies@vger.kernel.org>; Wed, 27 Sep 2017 16:31:49 +0000 (UTC)
Received: from mx4-us1.ppe-hosted.com (filterqueue.mdlocal [10.7.20.246])
        by pure.maildistiller.com (Proofpoint Essentials ESMTP Server) with ESMTPS id 9CA871C0069
        for <xdp-newbies@vger.kernel.org>; Wed, 27 Sep 2017 16:31:48 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx4-us1.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id 6533960075
        for <xdp-newbies@vger.kernel.org>; Wed, 27 Sep 2017 16:31:48 +0000 (UTC)
From: Edward Cree <ecree@solarflare.com>
Subject: ANN: a different eBPF assembler
Message-ID: <f7dcba52-2696-aeac-891c-57cb9315c0eb@solarflare.com>
Date: Wed, 27 Sep 2017 17:31:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

In recent weeks I've been developing an eBPF assembler, implemented in Python.  It can be found at https://github.com/solarflarecom/ebpf_asm and it consumes an Intel-like syntax very different to that consumed by LLVM or emitted by the kernel verifier's disassembler.

To quote from the 'Rationale' section of the readme:

> It's great that you can write eBPF programs in C and then compile them with clang/LLVM. But clang's really rather big, and sometimes you don't have room for a gigantic toolchain — and your program is really small and simple. For such a case, writing the program directly in assembly is a feasible alternative.
>
> I chose the Intel syntax because my ability to read assembly code is directly proportional to how much it resembles Z80. If you dislike that as much as I dislike AT&T-syntax x86 assembly, this may not be the tool for you.
>
My personal use case for this was developing directed tests for a driver XDP implementation.  There may be others.

-Ed
