Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60350 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725930AbgFCPJI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 3 Jun 2020 11:09:08 -0400
Received: by mail-ed1-f71.google.com with SMTP id a21so1307457edy.1
        for <xdp-newbies@vger.kernel.org>; Wed, 03 Jun 2020 08:09:04 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP_REDIRECT with xsks_map and dev_map
In-Reply-To: <CA+Jwd2wPcKWkfGa=TszqODbm2sGiyXszy5LRKozab0JrsSoGBQ@mail.gmail.com>
References: <CA+Jwd2y5Pjh+QMrH9vjBtHhvG2EC1MCfm-A2Pq2hjRPEvJ1J1Q@mail.gmail.com> <87d06hzvr8.fsf@toke.dk> <CA+Jwd2z4_tGfh9wS_CJQL36O_vYyv5knXkm6=A+UvNNtojEcrw@mail.gmail.com> <877dwpmp7f.fsf@toke.dk> <CA+Jwd2xnb8Nuc6Y2V=04fBa2bXfaMy1FPyK8CsFnOkqyxrtEwg@mail.gmail.com> <87lfl4l8zu.fsf@toke.dk> <20200603104833.GA14391@ranger.igk.intel.com> <87ftbcl86e.fsf@toke.dk> <20200603110726.GA55184@ranger.igk.intel.com> <CA+Jwd2wPcKWkfGa=TszqODbm2sGiyXszy5LRKozab0JrsSoGBQ@mail.gmail.com>
Date: Wed, 03 Jun 2020 17:09:01 +0200
Message-ID: <874krskwz6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: maharishi bhargava <bhargavamaharishi@gmail.com>, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: xdp-newbies@vger.kernel.org

maharishi bhargava <bhargavamaharishi@gmail.com> writes:

> On Wed, Jun 3, 2020 at 4:41 PM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
>>
>> On Wed, Jun 03, 2020 at 01:07:05PM +0200, Toke Høiland-Jørgensen wrote:
>> > Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
>> >
>> > > On Wed, Jun 03, 2020 at 12:49:25PM +0200, Toke HÃƒÂ¸iland-JÃƒÂ¸rgensen wrote:
>> > >> maharishi bhargava <bhargavamaharishi@gmail.com> writes:
>> > >>
>> > >> > On Tue, Jun 2, 2020 at 9:31 PM Toke HÃƒÂ¸iland-JÃƒÂ¸rgensen <toke@redhat.com> wrote:
>> > >> >>
>> > >> >> maharishi bhargava <bhargavamaharishi@gmail.com> writes:
>> > >> >>
>> > >> >> > On Tue 2 Jun, 2020, 14:31 Toke HÃƒÂ¸iland-JÃƒÂ¸rgensen, <toke@redhat.com> wrote:
>> > >> >> >>
>> > >> >> >> maharishi bhargava <bhargavamaharishi@gmail.com> writes:
>> > >> >> >>
>> > >> >> >> > Hi, in my XDP program, I want to redirect some packets using AF_XDP
>> > >> >> >> > and redirect other packets directly from driver space.
>> > >> >> >> > Redirection through AF_XDP works fine, but redirection through dev map
>> > >> >> >> > stops after some packets are processed.
>> > >> >> >>
>> > >> >> >> Do you mean it stops even if you are *only* redirecting to a devmap, or
>> > >> >> >> if you are first redirecting a few packets to AF_XDP, then to devmap?
>> > >> >> >>
>> > >> >> >> Also, which driver(s) are the physical NICs you're redirecting to/from
>> > >> >> >> using, and which kernel version are you on?
>> > >> >> >>
>> > >> >> >> -Toke
>> > >> >> >
>> > >> >> >
>> > >> >> >
>> > >> >> > Currently, I'm trying to redirect packets only using devmap. But also
>> > >> >> > have code for redirection using AF_XDP(only when a given condition is
>> > >> >> > satisfied). A DPDK program is running in userspace which will receive
>> > >> >> > packets from AF_XDP.
>> > >> >>
>> > >> >> Right, so it's just devmap redirect that breaks. What do you mean
>> > >> >> 'redirection stops', exactly? How are you seeing this? Does xdp_monitor
>> > >> >> (from samples/bpf) report any exceptions?
>> > >> >>
>> > >> >> -Toke
>> > >> >>
>> > >> > So, In my setup, there are three systems, Let's Assume A, B, C. System
>> > >> > B is acting as a forwarder between A and C. So I can see the number of
>> > >> > packets received at system C. To be specific, only 1024 packets are
>> > >> > received. If I remove the xsks_map part from the code and don't run
>> > >> > DPDK in userspace. This problem does not occur. Also if I forward all
>> > >> > the packets using AF_XDP, there is no such issue.
>> > >>
>> > >> I thought you said you were seeing the problem when only redirecting to
>> > >> a devmap? So why does the xsk_map code impact this? I think you may have
>> > >> to share some code...
>> > >
>> > > Isn't the case here that either xsk_map or dev_map consumes the frame and
>> > > therefore the latter doesn't see it? so cloning might be needed here?
>> >
>> > Yeah, certainly you can't redirect *the same packet* to both xsk_map and
>> > devmap - but that wasn't what I understood was the use case here?
>>
>> Maybe the best would be if Maharishi shared the code as you requested :)
>>
>> >
>> > -Toke
>> >
> CODE:
> BPF MAPS:
>
>
> struct bpf_map_def SEC("maps") xsks_map = {
>     .type = BPF_MAP_TYPE_XSKMAP,
>     .key_size = sizeof(int),
>     .value_size = sizeof(int),
>     .max_entries = 64,  /* Assume netdev has no more than 64 queues */
> };
>
> struct bpf_map_def SEC("maps") tx_port = {
>     .type = BPF_MAP_TYPE_DEVMAP,
>     .key_size = sizeof(int),
>     .value_size = sizeof(int),
>     .max_entries = 1024,
> };
>
> struct Ingress_qos_lts_value{
>     struct bpf_spin_lock lock;
>     u64 timestamp;
> };
> struct bpf_map_def SEC("maps") Ingress_qos_lts = {
>     .type = BPF_MAP_TYPE_ARRAY,
>     .key_size = sizeof(u32),
>     .value_size = sizeof(struct Ingress_qos_lts_value),
>     .max_entries = 1025,
> };
> BPF_ANNOTATE_KV_PAIR(Ingress_qos_lts,u32,struct Ingress_qos_lts_value);
>
>
> SEC("prog")
> int ebpf_filter(struct xdp_md *ctx){
>     struct xdp_output xout;
>    xout.output_port = 1;
>     void* ebpf_packetStart = ((void*)(long)ctx->data);
>     void* ebpf_packetEnd = ((void*)(long)ctx->data_end);
>     u64 rate = 100;//100 Kbps
>     rate *= 1000*1000*100;//10 Gbps
>     u32 key = 1;//some key
>     u64 packet_length=(ebpf_packetEnd-ebpf_packetStart-42)*8;
>     packet_length *= 1000000000; //packet length * 10^9, to convert
> rate from second to nanosecond
>     struct Ingress_qos_lts_value* val;
>     val = bpf_map_lookup_elem(&Ingress_qos_lts, &key);
>     u64 now = bpf_ktime_get_ns();
>     u64 lts;
>     if (val) {
>         bpf_spin_lock(&val->lock);
>         lts = *(&val->timestamp)+(packet_length/rate);
>         if(now>lts){
>             lts = now;
>         }
>         *(&val->timestamp) = lts;
>         bpf_spin_unlock(&val->lock);
>                     // printk("Time : %x %x\n",lts,now);
>         if(lts>now){
>             return bpf_redirect_map(&xsks_map, ctx->rx_queue_index, 0);
>         }
>     }
>     return  bpf_redirect_map(&tx_port,xout.output_port,0);
> }
>
> So, Basically this code redirects the packet to some other interface
> or sends the packet to userspace based on the incoming packet rate.

Well, if you say it goes away when you remove the xsk code, the obvious
explanation would be that the packets are being redirected to userspace
instead? What does xdp_monitor say?

-Toke
