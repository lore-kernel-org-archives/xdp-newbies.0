Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0a-00169c01.pphosted.com ([67.231.148.124]:52902 "EHLO
        mx0b-00169c01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726381AbgD2Awm (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 Apr 2020 20:52:42 -0400
Received: from pps.filterd (m0048493.ppops.net [127.0.0.1])
        by mx0a-00169c01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T0lZ6t014225
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Apr 2020 17:52:41 -0700
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com [209.85.222.70])
        by mx0a-00169c01.pphosted.com with ESMTP id 30mm8q4q99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Apr 2020 17:52:41 -0700
Received: by mail-ua1-f70.google.com with SMTP id 59so321372uaw.6
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Apr 2020 17:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAHQoOTZGdLYZ=qjF8+Rwi+E5y_st1u1CwMPiP65UHWpvRXvhZA@mail.gmail.com>
 <60973878-18e8-aca3-5b4b-26947dc5ded8@gmail.com>
In-Reply-To: <60973878-18e8-aca3-5b4b-26947dc5ded8@gmail.com>
From: John McDowall <jmcdowall@paloaltonetworks.com>
Date: Tue, 28 Apr 2020 17:52:28 -0700
Message-ID: <CAHQoOTbYvk7A3YLyGjkCK4tt_5ryu+mK6TK84OcAXRqUrF16kg@mail.gmail.com>
Subject: Re: XDP Native mode with public cloud (GCP)
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: David Ahern <dsahern@gmail.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

David,

Thanks for the quick reply - I assumed that this was the answer. The
good news is that I see almost 8Gbps in xdpgeneric mode.

Regards

John

On Tue, Apr 28, 2020 at 10:19 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 4/28/20 11:11 AM, John McDowall wrote:
> > Hi,
> >
> > I am running the XDP redirect example on Google Cloud Platform using
> > the GCP provided Ubuntu 20.04 image as my host. The code works fine in
> > SKB_MODE (xdpgeneric). When I go to DRV_MODE I get the following error
> > message:   "libbpf: Kernel error message: virtio_net: XDP expects
> > header/data in single page, any_header_sg required".
>
> The most likely explanation is an old machine model for the VM.
>
> But that is just the first step. Once the VM model is updated to
> something modern, the cloud provider needs to enable multiqueue for the
> tap device with the number of queues = 2 * vcpus for each tap device.
> e.g., a 4 vcpu VM needs 8 queues per tap device that xdp is to be allowed.
>
> >
> > For all images on GCP that I have looked at the number of RX and TX
> > channels are set to 0 and the combined is the number of cores (ethtool
> > -l dev). My question is then, is there any way to run XDP native on
> > GCP images or do I need to try and create a custom image with re and
> > tx queues set?
> >
> > Second question, does anyone have experience running native XDP on AWS
> > and Azure?
> >
>
> last I looked AWS does not support XDP either. Never tried Azure.
