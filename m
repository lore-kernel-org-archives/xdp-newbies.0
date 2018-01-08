Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:47350 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757466AbeAHWEu (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jan 2018 17:04:50 -0500
Subject: Re: Generic XDP and veth
References: <88581FA1-DA7C-4329-8D62-185090FC820D@polito.it>
 <CALDO+SbMuv3shRwmo5o7AmKLoG13EboXsh5T1SBH+EsWyR_0QA@mail.gmail.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1b11a672-cfd2-ec22-3a1d-117bc1590241@iogearbox.net>
Date: Mon, 8 Jan 2018 23:04:48 +0100
MIME-Version: 1.0
In-Reply-To: <CALDO+SbMuv3shRwmo5o7AmKLoG13EboXsh5T1SBH+EsWyR_0QA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: William Tu <u9012063@gmail.com>, Matteo Bertrone <matteo.bertrone@polito.it>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On 01/08/2018 08:19 PM, William Tu wrote:
> Hi Matteo,
> 
> On Mon, Jan 8, 2018 at 7:33 AM, Matteo Bertrone
> <matteo.bertrone@polito.it> wrote:
>> Hello,
>>
>> while I was trying to forward packets using Generic XDP [1], I encountered the following problem:
>>
>> ARP and ICMP packets are forwarded correctly, and ping works fine.
>> It seems not all TCP packets are forwarded by XDP program, both netcat and iperf are not working for me.
>>
>> (Using same configuration as [1])
>> sudo ip netns exec ns2 nc -l 8080
>> sudo ip netns exec ns1 nc 10.1.1.22 8080
>>
>> sudo ip netns exec ns2 iperf3 -s
>> sudo ip netns exec ns1 iperf3 -c 10.1.1.22
>>
>> It seems such traffic is not processed by XDP program.
>> Using tcpdump on veth1 in root namespace I’m not able to see ARP and ICMP traffic (as expected) because forwarded by XDP program, but I’m able to see all the traffic it’s not forwarded.
>>
>> Is this behavior expected?
>> Did I miss something in veth configuration?
>>
> 
> I tested nc on my system and I saw the same issue. Using UDP (nc -u)
> works, but TCP doesn't.
> From the client side (ns1), tcpdump can see SYN packet at veth11 and
> veth1, but the packet didn't reach the BPF program attached at veth1.
> Somewhere in-between the SYN packet is dropped.  I guess it's related
> to some tcp offload settings? I will need to debug a bit on this.

See this one, which you're most likely hitting in TCP case:

static u32 netif_receive_generic_xdp(struct sk_buff *skb,
                                     struct bpf_prog *xdp_prog)
{
        struct netdev_rx_queue *rxqueue;
        u32 metalen, act = XDP_DROP;
        struct xdp_buff xdp;
        void *orig_data;
        int hlen, off;
        u32 mac_len;

        /* Reinjected packets coming from act_mirred or similar should
         * not get XDP generic processing.
         */
        if (skb_cloned(skb))
                return XDP_PASS;

        [...]
}

> Thanks
> William
> 
>> [1] https://github.com/torvalds/linux/blob/master/tools/testing/selftests/bpf/test_xdp_redirect.sh
