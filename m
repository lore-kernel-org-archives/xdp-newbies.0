Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58593 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfFCRjU (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 3 Jun 2019 13:39:20 -0400
Subject: Re: [PATCH][next] bpf: remove redundant assignment to err
References: <20190603170247.9951-1-colin.king@canonical.com>
 <20190603102140.70fee157@cakuba.netronome.com>
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <276525bd-dd79-052e-7663-9acc92621853@canonical.com>
Date: Mon, 3 Jun 2019 18:39:16 +0100
MIME-Version: 1.0
In-Reply-To: <20190603102140.70fee157@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S . Miller" <davem@davemloft.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On 03/06/2019 18:21, Jakub Kicinski wrote:
> On Mon,  3 Jun 2019 18:02:47 +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The variable err is assigned with the value -EINVAL that is never
>> read and it is re-assigned a new value later on.  The assignment is
>> redundant and can be removed.
>>
>> Addresses-Coverity: ("Unused value")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  kernel/bpf/devmap.c | 2 +-
>>  kernel/bpf/xskmap.c | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> index 5ae7cce5ef16..a76cc6412fc4 100644
>> --- a/kernel/bpf/devmap.c
>> +++ b/kernel/bpf/devmap.c
>> @@ -88,7 +88,7 @@ static u64 dev_map_bitmap_size(const union bpf_attr *attr)
>>  static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
>>  {
>>  	struct bpf_dtab *dtab;
>> -	int err = -EINVAL;
>> +	int err;
>>  	u64 cost;
> 
> Perhaps keep the variables ordered longest to shortest?

Is that a required coding standard?

> 
>>  	if (!capable(CAP_NET_ADMIN))
>> diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
>> index 22066c28ba61..26859c6c9491 100644
>> --- a/kernel/bpf/xskmap.c
>> +++ b/kernel/bpf/xskmap.c
>> @@ -17,7 +17,7 @@ struct xsk_map {
>>  
>>  static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
>>  {
>> -	int cpu, err = -EINVAL;
>> +	int cpu, err;
>>  	struct xsk_map *m;
>>  	u64 cost;
> 
> And here.
> 
