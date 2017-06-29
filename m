Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:39264 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdF2AUC (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 28 Jun 2017 20:20:02 -0400
Message-ID: <595447AD.5040504@iogearbox.net>
Date: Thu, 29 Jun 2017 02:19:57 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: Cannot load eBPF program as XDP
References: <CAM7NYTh=TMc6uC_4dG=w5yAHMppLSgTgfgTY0Jzr-ipgs9SN-w@mail.gmail.com> <CAH3MdRX-wYpskfsjxv-jyM_zia+Va0nTv3FKGPZpnHZ6YnacsQ@mail.gmail.com> <CAM7NYTi=j4ZiPEk4c9CH9GqqLgynyLRsjdPgVd=TPM3QCUb_yw@mail.gmail.com> <59537132.2080603@iogearbox.net> <CAM7NYTjQFHSH8ytBLn-_7W_d=H166Ox-i+yXKg_hBj0Q=fSo1Q@mail.gmail.com>
In-Reply-To: <CAM7NYTjQFHSH8ytBLn-_7W_d=H166Ox-i+yXKg_hBj0Q=fSo1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "MD I. Islam" <tamim@csebuet.org>
Cc: Y Song <ys114321@gmail.com>, xdp-newbies@vger.kernel.org

On 06/29/2017 12:40 AM, MD I. Islam wrote:
> On Wed, Jun 28, 2017 at 5:04 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 06/28/2017 04:32 AM, MD I. Islam wrote:
>>> On Tue, Jun 27, 2017 at 10:05 PM, Y Song <ys114321@gmail.com> wrote:
>>>>
>>>> xdp meta data is different:
>>>>
>>>> struct xdp_md {
>>>>           __u32 data;
>>>>           __u32 data_end;
>>>> };
>>>>
>>>> All other fields available for skb metadata won't be available in XDP.
>>>> That is way
>>>> you get verification failure.
>>>
>>> Thanks for the quick reply! Now I'm trying xdp1_kern.c which uses
>>> xdp_md. Now I'm getting the error:
>>>
>>> Note: 8 bytes struct bpf_elf_map fixup performed due to size mismatch!
>>
>> This one is harmless, just telling you that the native bpf_elf_map
>> from iproute2 is different than the one you're loading, so it fixes
>> up the remaining 8 bytes automatically.
>>
>>> RTNETLINK answers: Operation not supported
>>
>> This one seems likely that the driver you're trying to attach this to
>> does not have XDP support. What's the driver you're using?
>
> Yes, I was using RTL8111 driver which doesn't support XDP. I will
> eventually use Netronome NIC which will hopefully work.
>
> I'm facing the same problem in Mininet. Is there a way to use XDP in
> Mininet? I am using Linux router in Mininet and I want to attach XDP
> programs to virtual interfaces.

You can use generic XDP, which will load also with drivers not
supporting XDP natively (the fallback to generic XDP is transparent).
It's part of 4.12 kernel.
