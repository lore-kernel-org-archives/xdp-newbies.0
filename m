Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from m13-98.163.com ([220.181.13.98]:24464 "EHLO m13-98.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758951AbdKPQQZ (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 16 Nov 2017 11:16:25 -0500
Date: Fri, 17 Nov 2017 00:00:13 +0800 (CST)
From: nfel <nfel@163.com>
Subject: A problem about BPF_MAP_TYPE_PERCPU_ARRAY
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <77facb8e.ccfa.15fc58f25f9.Coremail.nfel@163.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: xdp-newbies@vger.kernel.org


Hello:

         I am trying to use Generic XDP to defense DDoS attack. So I write a very simple test program whose purpose is to drop the ICMP packet by check the source ip.

         Here is the XDP code:

==========

struct bpf_map_def SEC("maps") ip_from = {
    .type = BPF_MAP_TYPE_PERCPU_ARRAY,
    .key_size = sizeof(__u32),
    .value_size = sizeof(__u32),
    .max_entries = 1,
};

SEC("xdp_prog")
int ddos(struct xdp_md *ctx)
{
    void *data = (void *)(long)ctx->data;
    void *data_end = (void *)(long)ctx->data_end;
    struct ethhdr *eth = data;

    struct iphdr *iph = (void *)(eth + 1);
    if (iph + 1 > data_end)
        return XDP_DROP;

    if (iph->protocol != IPPROTO_ICMP)
        return XDP_PASS;
    
    __u32 idx = 0;
    __u32 *src = NULL;
    src = bpf_map_lookup_elem(&ip_from, &idx);
    if (src) {
        if (iph->saddr == *src)
            return XDP_DROP;
    }

    return XDP_PASS;
}

==========

And here is the userland:

==========

char *ip_src = "10.1.1.10";
__u32 i;
__u32 ipv4[nr_cpus];
__u32 idx = 0;

for (i = 0; i < nr_cpus; i++) {
    inet_pton(AF_INET, ip_src, &ipv4[i]);
}

bpf_map_update_elem(fd, &idx, ipv4, BPF_ANY);

==========

If I understand BPF_MAP_TYPE_PERCPU_ARRAY correctly, the program above will create map data for each possible cpu.

But it¡¯s strange that it runs well only when (nr_cpus == 1).

Did I miss something?

Thanks
Sincerely.
