Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from m02.nii.ac.jp ([136.187.7.8]:46458 "EHLO m02.nii.ac.jp"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752558AbeDLRjg (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 12 Apr 2018 13:39:36 -0400
Received: from [192.168.60.3] (124.41.93.194 [124.41.93.194])
        by m02.nii.ac.jp (deepsmtpd.sk)
        with ESMTP id <96a86a6c-d927-03a6-dcc3-3e2b10706a9f@nii.ac.jp>
        for <xdp-newbies@vger.kernel.org>; Fri, 13 Apr 2018 02:39:27 +0900
Subject: Re: XDP_TX for virtio_net not working in recent kernel?
References: <47428621-2f24-3c8e-5d34-1d788a86a455@nii.ac.jp>
 <1d5849ae-a9ec-93af-e1b5-e7a368193c7a@iogearbox.net>
 <ce812367-596a-0354-f008-725225f65af4@redhat.com>
From: Kimitoshi Takahashi <ktaka@nii.ac.jp>
Message-ID: <96a86a6c-d927-03a6-dcc3-3e2b10706a9f@nii.ac.jp>
Date: Fri, 13 Apr 2018 02:39:27 +0900
MIME-Version: 1.0
In-Reply-To: <ce812367-596a-0354-f008-725225f65af4@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jason Wang <jasowang@redhat.com>, Daniel Borkmann <daniel@iogearbox.net>
Cc: xdp-newbies@vger.kernel.org, netdev@vger.kernel.org

Hello Jason,

The patch fixed the issue.
Thank you very much!


On 04/11/2018 10:50 AM, Jason Wang wrote:
> 
> I suspect a kick is missed in the XDP_TX case.
> 
> Could you please try the attached patch to see if it fixes the issue?
> 
> Thanks

-- 
Kimitoshi Takahashi
