Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21674 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726261AbgA2O0h (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 29 Jan 2020 09:26:37 -0500
Date: Wed, 29 Jan 2020 15:26:24 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: Measuring/Debugging XDP Performance
Message-ID: <20200129152624.2d0dde2a@carbon>
In-Reply-To: <b1d478e6-555c-97da-f967-4f10f879f589@gflclan.com>
References: <6c3dc8ff-e2bd-a06e-d9f0-c5be0103d266@gflclan.com>
        <20200123141122.3783e298@carbon>
        <23ec64c0-e0d7-a60b-ecc4-6ca401dc4896@gflclan.com>
        <20200123213808.7a1f200b@carbon>
        <fdd597bf-7da9-f9bd-d97f-f1bd90f14281@gflclan.com>
        <b1d478e6-555c-97da-f967-4f10f879f589@gflclan.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Christian Deacon <gamemann@gflclan.com>
Cc: xdp-newbies@vger.kernel.org, brouer@redhat.com

On Tue, 28 Jan 2020 12:42:21 -0600
Christian Deacon <gamemann@gflclan.com> wrote:

> With that said, it appears my other POP servers that are using the 
> "virtio_net" NIC driver are using XDP generic according to the 'perf' 
> results as well (they're similar to the above). They're also on
> kernel 4.18.

First of all 'virtio_net' is tricky to get working with 'native-XDP',
because you need to disable a number of offloads.  This have gotten a
bit easier on newer kernels.

That said, it is important to understand that getting raw "fast" frames
into your "virtio_net" virtual netcard is a two-stage "rocket".   The
owner of the hardware box also need a native-XDP netcard that runs XDP
which XDP-redirect frames into your virtual NIC, else there is not
performance advantage.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
