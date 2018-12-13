Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f53.google.com ([209.85.128.53]:35402 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbeLMUyu (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 13 Dec 2018 15:54:50 -0500
Received: by mail-wm1-f53.google.com with SMTP id c126so3789059wmh.0
        for <xdp-newbies@vger.kernel.org>; Thu, 13 Dec 2018 12:54:49 -0800 (PST)
MIME-Version: 1.0
From: Rafael Vargas <vargas@khomp.com>
Date: Thu, 13 Dec 2018 18:54:37 -0200
Message-ID: <CAEaYocZxBKoD72jrE3_YasxxYGfrh1nhkE7yBaXSwRWfe2f54w@mail.gmail.com>
Subject: Which interface is the program running...
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi all,

I've being doing some tests and could not find a way within the
program to know in which interface is the XDP program running.

I install the same program to several interfaces (with
bpf_set_link_xdp_fd), is there any way to do that?

Thanks,
Rafael Vargas
