Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from fanzine.igalia.com ([91.117.99.155]:47533 "EHLO
        fanzine.igalia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbeKCAiR (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 2 Nov 2018 20:38:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 02 Nov 2018 16:30:46 +0100
From: Konrad Djimeli <kdjimeli@igalia.com>
Subject: Re: AF_XDP socket (sock2)  unable to read, after writing with another
 AF_XDP socket (sock1)
In-Reply-To: <ABE87697-2B6F-4F4B-BE08-2CBD84A88408@gmail.com>
References: <ad85176a72e82878a4073a4215aa5e3a@igalia.com>
 <ABE87697-2B6F-4F4B-BE08-2CBD84A88408@gmail.com>
Message-ID: <ec06809c048a180b4210ff6f6d2502be@igalia.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Marius Gerling <mariusgerling@gmail.com>
Cc: xdp-newbies@vger.kernel.org

On 2018-11-01 19:27, Marius Gerling wrote:
> Hello Konrad,
> 
> some things to think of while using AF_XDP.
> 
>  - Received data is forwarded to an AF_XDP socket with the
> bps_redirect_map call in the kernel part. You are sending the data to
> the first AF_XDP socket all the time.
>  - With AF_XDP one bypasses all the TCP/IP stack of the Linux kernel.
> This means that one needs to set the Ethernet, IP, UDP (or TCP)
> headers by themselves at the beginning of the packet. (I don’t exactly
> know if this is needed for the loopback adapter you are using)
> 
> You might want to have a look at other AF_XDP implementations. One is
> in my repo: https://github.com/gerl1ng/afxdp-packet-processor (folder
> server_afxdp). Some more information is given in the PDF in that repo.
> 
> Marius

Hello Marius,

Thanks for taking the time to  provide feedback and pointers. I am
currently going through your thesis and it is definitely helpful in
enabling me better understand XDP and AF_XDP.

Thanks
Konrad
