Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgD1RTH (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 Apr 2020 13:19:07 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4629C03C1AB
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Apr 2020 10:19:06 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id k12so17968618qtm.4
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Apr 2020 10:19:06 -0700 (PDT)
Subject: Re: XDP Native mode with public cloud (GCP)
References: <CAHQoOTZGdLYZ=qjF8+Rwi+E5y_st1u1CwMPiP65UHWpvRXvhZA@mail.gmail.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <60973878-18e8-aca3-5b4b-26947dc5ded8@gmail.com>
Date: Tue, 28 Apr 2020 11:19:03 -0600
MIME-Version: 1.0
In-Reply-To: <CAHQoOTZGdLYZ=qjF8+Rwi+E5y_st1u1CwMPiP65UHWpvRXvhZA@mail.gmail.com>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: John McDowall <jmcdowall@paloaltonetworks.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On 4/28/20 11:11 AM, John McDowall wrote:
> Hi,
> 
> I am running the XDP redirect example on Google Cloud Platform using
> the GCP provided Ubuntu 20.04 image as my host. The code works fine in
> SKB_MODE (xdpgeneric). When I go to DRV_MODE I get the following error
> message:   "libbpf: Kernel error message: virtio_net: XDP expects
> header/data in single page, any_header_sg required".

The most likely explanation is an old machine model for the VM.

But that is just the first step. Once the VM model is updated to
something modern, the cloud provider needs to enable multiqueue for the
tap device with the number of queues = 2 * vcpus for each tap device.
e.g., a 4 vcpu VM needs 8 queues per tap device that xdp is to be allowed.

> 
> For all images on GCP that I have looked at the number of RX and TX
> channels are set to 0 and the combined is the number of cores (ethtool
> -l dev). My question is then, is there any way to run XDP native on
> GCP images or do I need to try and create a custom image with re and
> tx queues set?
> 
> Second question, does anyone have experience running native XDP on AWS
> and Azure?
> 

last I looked AWS does not support XDP either. Never tried Azure.
