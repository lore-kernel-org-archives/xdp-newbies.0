Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22614 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726243AbgD0KDs (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 27 Apr 2020 06:03:48 -0400
Date: Mon, 27 Apr 2020 12:03:33 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: building eBPF
Message-ID: <20200427120333.7e6cedfc@carbon>
In-Reply-To: <20200427002027.GE488@gmail.com>
References: <20200425122225.GA455@gmail.com>
        <20200425145619.4405a50d@carbon>
        <20200427002027.GE488@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Sowmini Varadhan <sowmini05@gmail.com>
Cc: brouer@redhat.com, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>

On Sun, 26 Apr 2020 20:20:27 -0400
Sowmini Varadhan <sowmini05@gmail.com> wrote:

> With the latest iproute2 (built from master, 'ip -V' reports
> iproute2-ss200330) when I try to run tc_l2_redirect.sh
> I get errors like the following. What am I missing?

The iproute2 BPF-loader does not support BTF.  I think upstream agrees
that it would be too much work to add (and maintain) it, so the current
plan[1] is to convert iproute2 to use libbpf instead.

Also notice that BPF-map layout is not compatible with libbpf.  Thus,
yet another hint not to use iproute2 to load XDP programs. (Toke have
done some initial work with libbpf maps, that will allow us AFAIK to be
backward compatible when converting iproute2 to libbpf).

Why do you want to use 'tc' to load XDP?


The XDP-tutorial[2] shows how to use libbpf from your C-programs, and
XDP-tools[3] contains a xdp-loader that you can use instead.

[1] https://xdp-project.net/#Port-iproute2-to-libbpf
[2] https://github.com/xdp-project/xdp-tutorial
[3] https://github.com/xdp-project/xdp-tools/tree/master/xdp-loader


> (full transcript of output from run is in the run.out attachment)
> 
>   :
> + tc filter add dev ve2 ingress bpf da obj ./tc_l2_redirect_kern.o sec l2_to_iptun_ingress_forward
> 
> BTF debug data section '.BTF' rejected: Invalid argument (22)!
>  - Length:       3554

I actually think this is only a warning, and the program is actually
loaded...

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
