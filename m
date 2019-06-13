Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-io1-f53.google.com ([209.85.166.53]:42115 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731635AbfFMMME (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 13 Jun 2019 08:12:04 -0400
Received: by mail-io1-f53.google.com with SMTP id u19so16279294ior.9
        for <xdp-newbies@vger.kernel.org>; Thu, 13 Jun 2019 05:12:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190613120659.10680-1-hdanton@sina.com>
In-Reply-To: <20190613120659.10680-1-hdanton@sina.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Thu, 13 Jun 2019 14:11:52 +0200
Message-ID: <CACT4Y+ZaoM4c739MM5KXH7K0_oeRsQ8F4Erptv8bjbx0JFuS-w@mail.gmail.com>
Subject: Re: memory leak in vhost_net_ioctl
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Hillf Danton <hdanton@sina.com>
Cc: Jason Wang <jasowang@redhat.com>, syzbot <syzbot+0789f0c7e45efd7bb643@syzkaller.appspotmail.com>, "ast@kernel.org" <ast@kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "davem@davemloft.net" <davem@davemloft.net>, "hawk@kernel.org" <hawk@kernel.org>, "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mst@redhat.com" <mst@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Thu, Jun 13, 2019 at 2:07 PM Hillf Danton <hdanton@sina.com> wrote:
>
>
> Hello Jason
>
> On Thu, 13 Jun 2019 17:10:39 +0800 Jason Wang wrote:
> >
> > This is basically a kfree(ubuf) after the second vhost_net_flush() in
> > vhost_net_release().
> >
> Fairly good catch.
>
> > Could you please post a formal patch?
> >
> I'd like very much to do that; but I wont, I am afraid, until I collect a
> Tested-by because of reproducer without a cutting edge.

You can easily collect Tested-by from syzbot for any bug with a reproducer ;)
https://github.com/google/syzkaller/blob/master/docs/syzbot.md#testing-patches
