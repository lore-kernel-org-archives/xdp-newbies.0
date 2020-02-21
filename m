Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55980 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730626AbgBUI3H (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 21 Feb 2020 03:29:07 -0500
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Re: xdpsock poll syscall CPU 100%
Date: Fri, 21 Feb 2020 09:28:59 +0100
Message-ID: <28C7C59E-0ED6-4331-8547-952419F20D1F@redhat.com>
In-Reply-To: <CALDO+SZmCxtWCeqh93HO6vm1KHh_UGxMby+td2ba_o66ZT+MVQ@mail.gmail.com>
References: <CALDO+SZmCxtWCeqh93HO6vm1KHh_UGxMby+td2ba_o66ZT+MVQ@mail.gmail.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed; markup=markdown
Content-Transfer-Encoding: quoted-printable
To: William Tu <u9012063@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>



On 20 Feb 2020, at 23:49, William Tu wrote:

> Hi,
>
> I'm trying to save some CPU cycles when there is no packet arrives.
> I enable the poll syscall option of xdpsock, by doing
>
> $ ./xdpsock -r -p -S -i ens16
>  sock0@ens160:0 rxdrop xdp-skb poll()
>                 pps         pkts        1.00
> rx              0           0
> tx              0           0
>
> Since there is no packet coming, I though by calling poll()
> system call, the xdpsock process will be blocked and CPU utilization
> should be way under 100%. However, I'm still seeing 100%
> CPU utilization. Am I understanding this correctly?

Hi William, I can remember I saw this in the past two with this code. It=20
had something to do with the way xdpsock waits for the buffers to be=20
free=E2=80=99 ed by the kernel. What I can remember it had something to do=
=20
with the veth interfaces also.

I do remember that I fixed it in the tutorial for AF_XDP:=20
https://github.com/xdp-project/xdp-tutorial/blob/master/advanced03-AF_XDP/a=
f_xdp_user.c

Maybe you can see if you have the same problem with this example.

//Eelco


> Thanks,
> William
