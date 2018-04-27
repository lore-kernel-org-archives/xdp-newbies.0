Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:47416 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758105AbeD0NgY (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 27 Apr 2018 09:36:24 -0400
Subject: Re: egress packet filtering
References: <CAArOQ2UJDD-kA3O9h-MZTedhyRfXg4UC=QM-Hdw9tzPoe__ZvQ@mail.gmail.com>
From: Edward Cree <ecree@solarflare.com>
Message-ID: <fd4bc543-a590-ab95-145e-0b3a76e6b892@solarflare.com>
Date: Fri, 27 Apr 2018 14:36:18 +0100
MIME-Version: 1.0
In-Reply-To: <CAArOQ2UJDD-kA3O9h-MZTedhyRfXg4UC=QM-Hdw9tzPoe__ZvQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Bobby Powers <bobbypowers@gmail.com>, xdp-newbies@vger.kernel.org

On 27/04/18 14:31, Bobby Powers wrote:
> Does that sound about right?  Am I right in understanding that the
> main difference between using a BPF classifier/action and XDP filter
> is that performance of XDP filters is higher (because there is some
> amount of integration with the NIC/driver), and they only process
> ingress traffic?
The higher performance of XDP is because the processing, being done in
 the driver, happens earlier in the RX path (thus avoiding the bulk of
 network stack processing for packets that e.g. are only going to be
 dropped anyway).
But on TX, the analogous driver code would be the _last_ thing in the
 path, rather than the first, so in such a case the `tc` approach
 should probably perform better than an XDP analogue.

Apart from that, your understanding appears to be correct.

HTH,
-Ed
