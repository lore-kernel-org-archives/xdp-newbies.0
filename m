Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44892 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726167AbgAWUiS (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 23 Jan 2020 15:38:18 -0500
Date: Thu, 23 Jan 2020 21:38:08 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: Measuring/Debugging XDP Performance
Message-ID: <20200123213808.7a1f200b@carbon>
In-Reply-To: <23ec64c0-e0d7-a60b-ecc4-6ca401dc4896@gflclan.com>
References: <6c3dc8ff-e2bd-a06e-d9f0-c5be0103d266@gflclan.com>
        <20200123141122.3783e298@carbon>
        <23ec64c0-e0d7-a60b-ecc4-6ca401dc4896@gflclan.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Christian Deacon <gamemann@gflclan.com>
Cc: xdp-newbies@vger.kernel.org, brouer@redhat.com

On Thu, 23 Jan 2020 11:22:31 -0600
Christian Deacon <gamemann@gflclan.com> wrote:

> Thank you for the information and I will try these commands tonight when 
> there is higher traffic load! The 'perf' command seems interesting.

Thanks for the perf output in the private email thread. From the output
I can clearly see the problem (some copy pasted below signature).  You
are using the driver igb which does not support XDP-native, and is thus
using generic-XDP.

This driver only have 192 bytes headroom, where 256 is needed.  Thus,
running XDP-generic will be slower than running the normal network
stack, as every packet will get reallocated and copied.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

     2.88%  swapper          [kernel.kallsyms]         [k] igb_poll
            |          
             --2.82%--igb_poll
                       |          
                        --2.45%--net_rx_action
                                  __softirqentry_text_start
                                  irq_exit



    0.71%  006  swapper          [kernel.kallsyms]         [k] page_frag_free
            |
            ---page_frag_free
               |          
                --0.68%--skb_free_head
                          pskb_expand_head
                          do_xdp_generic
                          netif_receive_skb_internal
                          napi_gro_receive
                          igb_clean_rx_irq
                          igb_poll
                          net_rx_action
