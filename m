Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f53.google.com ([209.85.221.53]:43948 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbeHWWnf (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 23 Aug 2018 18:43:35 -0400
Received: by mail-wr1-f53.google.com with SMTP id k5-v6so5502716wre.10
        for <xdp-newbies@vger.kernel.org>; Thu, 23 Aug 2018 12:12:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAJL276BB6OudtAxQdSq_4c-cFCQ1JpKFAwJvjs0SK_fdksT8bA@mail.gmail.com>
 <20180823210111.5238ad38@cakuba.netronome.com>
In-Reply-To: <20180823210111.5238ad38@cakuba.netronome.com>
From: Justin Azoff <justin.azoff@gmail.com>
Date: Thu, 23 Aug 2018 15:12:16 -0400
Message-ID: <CAJL276BDYVTdMdJ0qoj0Y5Fs8sNzuXC77sMrdDvGBGj8CAh00A@mail.gmail.com>
Subject: Re: libbpf and persistent maps
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: jakub.kicinski@netronome.com
Cc: xdp-newbies@vger.kernel.org

On Thu, Aug 23, 2018 at 3:01 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
> Could bpf_map__reuse_fd() be of any help?  (Present in Linus's tree for
> now, will be there in upcoming -rc1.)  You'll need to
> bpf_object__open() and bpf_object__load() separately, and set the FDs
> between the two.

Yes!  I think that's exactly what I need.  I got it working for now by
just hacking up
libbpf.h but I will port things over to that.

-- 
- Justin
