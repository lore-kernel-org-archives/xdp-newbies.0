Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f170.google.com ([209.85.214.170]:37860 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbeLMU6l (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 13 Dec 2018 15:58:41 -0500
Received: by mail-pl1-f170.google.com with SMTP id b5so1621894plr.4
        for <xdp-newbies@vger.kernel.org>; Thu, 13 Dec 2018 12:58:41 -0800 (PST)
Subject: Re: Which interface is the program running...
References: <CAEaYocZxBKoD72jrE3_YasxxYGfrh1nhkE7yBaXSwRWfe2f54w@mail.gmail.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <810848dc-e8f6-783c-62f0-973f745b9866@gmail.com>
Date: Thu, 13 Dec 2018 13:58:38 -0700
MIME-Version: 1.0
In-Reply-To: <CAEaYocZxBKoD72jrE3_YasxxYGfrh1nhkE7yBaXSwRWfe2f54w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Rafael Vargas <vargas@khomp.com>, xdp-newbies@vger.kernel.org

On 12/13/18 1:54 PM, Rafael Vargas wrote:
> Hi all,
> 
> I've being doing some tests and could not find a way within the
> program to know in which interface is the XDP program running.
> 
> I install the same program to several interfaces (with
> bpf_set_link_xdp_fd), is there any way to do that?
> 

xdp_md is the context passed to XDP programs. xdp_md has:

        __u32 ingress_ifindex; /* rxq->dev->ifindex */
        __u32 rx_queue_index;  /* rxq->queue_index  */
