Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:59765 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdKUJWi (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 21 Nov 2017 04:22:38 -0500
Subject: Re: A problem about BPF_MAP_TYPE_PERCPU_ARRAY
References: <77facb8e.ccfa.15fc58f25f9.Coremail.nfel@163.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a085da2b-1067-0aa2-918f-054306676f93@iogearbox.net>
Date: Tue, 21 Nov 2017 10:22:35 +0100
MIME-Version: 1.0
In-Reply-To: <77facb8e.ccfa.15fc58f25f9.Coremail.nfel@163.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: nfel <nfel@163.com>
Cc: xdp-newbies@vger.kernel.org

On 11/16/2017 05:00 PM, nfel wrote:
> 
> Hello:
> 
>          I am trying to use Generic XDP to defense DDoS attack. So I write a very simple test program whose purpose is to drop the ICMP packet by check the source ip.
> 
>          Here is the XDP code:
> 
> ==========
> 
> struct bpf_map_def SEC("maps") ip_from = {
>     .type = BPF_MAP_TYPE_PERCPU_ARRAY,
>     .key_size = sizeof(__u32),
>     .value_size = sizeof(__u32),
>     .max_entries = 1,
> };
> 
> SEC("xdp_prog")
> int ddos(struct xdp_md *ctx)
> {
>     void *data = (void *)(long)ctx->data;
>     void *data_end = (void *)(long)ctx->data_end;
>     struct ethhdr *eth = data;
> 
>     struct iphdr *iph = (void *)(eth + 1);
>     if (iph + 1 > data_end)
>         return XDP_DROP;
> 
>     if (iph->protocol != IPPROTO_ICMP)
>         return XDP_PASS;
>     
>     __u32 idx = 0;
>     __u32 *src = NULL;
>     src = bpf_map_lookup_elem(&ip_from, &idx);
>     if (src) {
>         if (iph->saddr == *src)
>             return XDP_DROP;
>     }
> 
>     return XDP_PASS;
> }
> 
> ==========
> 
> And here is the userland:
> 
> ==========
> 
> char *ip_src = "10.1.1.10";
> __u32 i;
> __u32 ipv4[nr_cpus];
> __u32 idx = 0;
> 
> for (i = 0; i < nr_cpus; i++) {
>     inet_pton(AF_INET, ip_src, &ipv4[i]);
> }
> 
> bpf_map_update_elem(fd, &idx, ipv4, BPF_ANY);
> 
> ==========
> 
> If I understand BPF_MAP_TYPE_PERCPU_ARRAY correctly, the program above will create map data for each possible cpu.
> 
> But it¡¯s strange that it runs well only when (nr_cpus == 1).
> 
> Did I miss something?

Check out the test_arraymap_percpu() from [1] which uses macros
in [2] to make it easier to deal with types which are not multiple
of 8 byte. I think that is probably the issue you're running into.
Other option is to expand the __u32 into a struct of 8 byte size
that both user and kernel bits then use as well.

Cheers,
Daniel

  [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/bpf/test_maps.c
  [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/bpf/bpf_util.h
