Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0a-00169c01.pphosted.com ([67.231.148.124]:33048 "EHLO
        mx0b-00169c01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726484AbgD2O0y (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 29 Apr 2020 10:26:54 -0400
Received: from pps.filterd (m0048493.ppops.net [127.0.0.1])
        by mx0a-00169c01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TEPkKO023533
        for <xdp-newbies@vger.kernel.org>; Wed, 29 Apr 2020 07:26:53 -0700
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com [209.85.217.71])
        by mx0a-00169c01.pphosted.com with ESMTP id 30mm8q6xk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <xdp-newbies@vger.kernel.org>; Wed, 29 Apr 2020 07:26:53 -0700
Received: by mail-vs1-f71.google.com with SMTP id f19so552223vsr.0
        for <xdp-newbies@vger.kernel.org>; Wed, 29 Apr 2020 07:26:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAHQoOTZGdLYZ=qjF8+Rwi+E5y_st1u1CwMPiP65UHWpvRXvhZA@mail.gmail.com>
 <60973878-18e8-aca3-5b4b-26947dc5ded8@gmail.com> <CAHQoOTbYvk7A3YLyGjkCK4tt_5ryu+mK6TK84OcAXRqUrF16kg@mail.gmail.com>
 <CAC1LvL11nq7HHGHHwag91d3U2j3M_rBRc+xj1O1JxXUmhxXsBw@mail.gmail.com>
In-Reply-To: <CAC1LvL11nq7HHGHHwag91d3U2j3M_rBRc+xj1O1JxXUmhxXsBw@mail.gmail.com>
From: John McDowall <jmcdowall@paloaltonetworks.com>
Date: Wed, 29 Apr 2020 07:26:40 -0700
Message-ID: <CAHQoOTas3oo7FZy7v+QUO0SXM0ed3KrgQ=fUska1J0H0boLfNQ@mail.gmail.com>
Subject: Re: XDP Native mode with public cloud (GCP)
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: Zvi Effron <zeffron@riotgames.com>
Cc: David Ahern <dsahern@gmail.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Zvi,

Thanks, this looks promising, I will take a deeper look and see what I
can get working.

Really appreciate the pointer

Regards

John

On Tue, Apr 28, 2020 at 6:52 PM Zvi Effron <zeffron@riotgames.com> wrote:
>
> XDP just recently started supporting XDP. You will need their out-of-tree driver from https://github.com/amzn/amzn-drivers/. It does not support XDP_REDIRECT, and I don't think it supports AF_XDP, but it does support XDP_PASS, XDP_DROP, and XDP_TX.
>
> I have verified this today on a Fedora 31 based image, though it does require a few modifications to get the RPM to build.
>
> --Zvi
>
> On Tue, Apr 28, 2020 at 7:52 PM John McDowall <jmcdowall@paloaltonetworks.com> wrote:
>>
>> David,
>>
>> Thanks for the quick reply - I assumed that this was the answer. The
>> good news is that I see almost 8Gbps in xdpgeneric mode.
>>
>> Regards
>>
>> John
>>
>> On Tue, Apr 28, 2020 at 10:19 AM David Ahern <dsahern@gmail.com> wrote:
>> >
>> > On 4/28/20 11:11 AM, John McDowall wrote:
>> > > Hi,
>> > >
>> > > I am running the XDP redirect example on Google Cloud Platform using
>> > > the GCP provided Ubuntu 20.04 image as my host. The code works fine in
>> > > SKB_MODE (xdpgeneric). When I go to DRV_MODE I get the following error
>> > > message:   "libbpf: Kernel error message: virtio_net: XDP expects
>> > > header/data in single page, any_header_sg required".
>> >
>> > The most likely explanation is an old machine model for the VM.
>> >
>> > But that is just the first step. Once the VM model is updated to
>> > something modern, the cloud provider needs to enable multiqueue for the
>> > tap device with the number of queues = 2 * vcpus for each tap device.
>> > e.g., a 4 vcpu VM needs 8 queues per tap device that xdp is to be allowed.
>> >
>> > >
>> > > For all images on GCP that I have looked at the number of RX and TX
>> > > channels are set to 0 and the combined is the number of cores (ethtool
>> > > -l dev). My question is then, is there any way to run XDP native on
>> > > GCP images or do I need to try and create a custom image with re and
>> > > tx queues set?
>> > >
>> > > Second question, does anyone have experience running native XDP on AWS
>> > > and Azure?
>> > >
>> >
>> > last I looked AWS does not support XDP either. Never tried Azure.
