Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41313 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726969AbfJGIgf (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 7 Oct 2019 04:36:35 -0400
Received: by mail-lj1-f199.google.com with SMTP id l13so3234229lji.7
        for <xdp-newbies@vger.kernel.org>; Mon, 07 Oct 2019 01:36:32 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: Unable to run eBPF program that uses maps
In-Reply-To: <CAM-scZMSvAE0jny0b__Da1j=krBB38J8w_H_12s=sy7T=F0spQ@mail.gmail.com>
References: <CAM-scZMSvAE0jny0b__Da1j=krBB38J8w_H_12s=sy7T=F0spQ@mail.gmail.com>
Date: Mon, 07 Oct 2019 10:36:28 +0200
Message-ID: <87k19hlzoz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Radu Stoenescu <radu.stoe@gmail.com>, xdp-newbies@vger.kernel.org

Radu Stoenescu <radu.stoe@gmail.com> writes:

> I'm running this Ubuntu: Linux anemie 5.0.0-31-generic #33~18.04.1-Ubuntu SMP
>
> I've cloned and compiled the Linux kernel - the same version and
> config as of my machine's.
>
> When trying to run the xdp_redirec_map sample program from samples/bpf I get:
>
> sudo ./xdp_redirect_map 2 1
> #=> failed to create map 0 (tx_port): 1 Operation not permitted
>
> I read that, on certain systems, the default limit of locked memory
> might pose problems, and I mitigated that as seen below:
>
> ulimit -a
>
> core file size          (blocks, -c) 0
> data seg size           (kbytes, -d) unlimited
> scheduling priority             (-e) 0
> file size               (blocks, -f) unlimited
> pending signals                 (-i) 31231
> max locked memory       (kbytes, -l) 1024

Is this run as your regular user? The limit will be reset in the sudo
environment that loads the program; so you'll need to set it as root (so
something like `sudo -i; ulimit -l 1024; ./xdp_redirect_map 2 1`)

-Toke
