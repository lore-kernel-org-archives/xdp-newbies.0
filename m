Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f169.google.com ([209.85.215.169]:43792 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389659AbfJRWKE (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 18 Oct 2019 18:10:04 -0400
Received: by mail-pg1-f169.google.com with SMTP id i32so4068299pgl.10
        for <xdp-newbies@vger.kernel.org>; Fri, 18 Oct 2019 15:10:04 -0700 (PDT)
MIME-Version: 1.0
From: Farid Zakaria <farid.m.zakaria@gmail.com>
Date: Fri, 18 Oct 2019 15:09:52 -0700
Message-ID: <CACCo2jk9rx3sf78RPFr39-JVZgaymsJVd6vg=WMKLmWfYZrNaA@mail.gmail.com>
Subject: sharing a simple ebpf code sample
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi,

I just wanted to share a code sample I put together which does
MPLSinIP encap/decap via clasct (not xdp).

https://github.com/fzakaria/ebpf-mpls-encap-decap

I know there's quite a few samples in the Linux source tree but I
found them lacking in terms of comments for someone new to the new
space.
(They were more geared at demonstrating a particular feature
specifically rather than simply instructional)

Learning & using ebpf for a project at work in a similar capacity
(encap/decap) has been a joy/fun to work with.

Cheers,
Farid Zakaria
