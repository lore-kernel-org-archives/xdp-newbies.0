Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36927 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfHNKUC (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 14 Aug 2019 06:20:02 -0400
Received: by mail-lj1-f194.google.com with SMTP id t14so2031899lji.4
        for <xdp-newbies@vger.kernel.org>; Wed, 14 Aug 2019 03:20:00 -0700 (PDT)
Date: Wed, 14 Aug 2019 13:19:57 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get
 __NR_mmap2
Message-ID: <20190814101955.GB4142@khorivan>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
 <05e5d15b-5ef9-b4dc-a76c-0d423fb2f15d@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <05e5d15b-5ef9-b4dc-a76c-0d423fb2f15d@fb.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Yonghong Song <yhs@fb.com>
Cc: "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>, "bjorn.topel@intel.com" <bjorn.topel@intel.com>, "davem@davemloft.net" <davem@davemloft.net>, "hawk@kernel.org" <hawk@kernel.org>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed, Aug 14, 2019 at 12:32:41AM +0000, Yonghong Song wrote:

Hi, Yonghong Song

>
>
>On 8/13/19 3:23 AM, Ivan Khoronzhuk wrote:
>> That's needed to get __NR_mmap2 when mmap2 syscall is used.
>
>It seems I did not have this issue on x64 machine e.g., Fedora 29.
>My glibc version is 2.28. gcc 8.2.1.

On 64 there is no the issue.

>
>What is your particular system glibc version?
>So needing kernel asm/unistd.h is because of older glibc on your
>system, or something else? Could you clarify?

It doesn't fix build issues, only runtime one on 32bits.

If no such inclusion -> no __NR_mmap2 definition - just mmap() is used ->
no problems on x64.

Is the inclusion -> no NR_mmap2 or is NR_mmap2 -> no problems on x64


-- 
Regards,
Ivan Khoronzhuk
