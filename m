Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42714 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728154AbfLDSwX (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 4 Dec 2019 13:52:23 -0500
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Re: Trying the bpf trace a bpf xdp program
Date: Wed, 04 Dec 2019 19:52:17 +0100
Message-ID: <E08A0006-E254-492C-92AB-408B58E456C0@redhat.com>
In-Reply-To: <b8d80047-3bc1-5393-76a1-7517cb2b7280@fb.com>
References: <E53E0693-1C3A-4B47-B205-DC8E5DAF3619@redhat.com>
 <CAADnVQKkLtG-QCZwxx-Bpz8-goh-_mSTtUSzpb_oTv9a-qLizg@mail.gmail.com>
 <3AC9D2B7-9D2F-4286-80A2-1721B51B62CF@redhat.com>
 <CAADnVQJKSnoMVpQ3F86zBhFyo8WQ0vi65Z4QDtopLRrpK4yB8Q@mail.gmail.com>
 <4BBF99E4-9554-44F7-8505-D4B8416554C4@redhat.com>
 <d588c894-a4e0-8b99-72a9-4429b27091df@fb.com>
 <056E9F5E-4FDD-4636-A43A-EC98A06E84D3@redhat.com>
 <aa59532b-34a9-7887-f550-ef2859f0c9f1@fb.com>
 <B7E0062E-37ED-46E6-AE64-EE3E2A0294EA@redhat.com>
 <7062345a-1060-89f6-0c02-eef2fe0d835a@fb.com>
 <b8d80047-3bc1-5393-76a1-7517cb2b7280@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Yonghong Song <yhs@fb.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Xdp <xdp-newbies@vger.kernel.org>, bpf <bpf@vger.kernel.org>



On 4 Dec 2019, at 19:01, Yonghong Song wrote:

<SNIP>

>>> I’ve put my code on GitHub, maybe it’s just something stupid…
>
> Thanks for the test case. This indeed a kernel bug.
> The following change fixed the issue:
>
>
> -bash-4.4$ git diff
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index a0482e1c4a77..034ef81f935b 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9636,7 +9636,10 @@ static int check_attach_btf_id(struct
> bpf_verifier_env *env)
>                                  ret = -EINVAL;
>                                  goto out;
>                          }
> -                       addr = (long)
> tgt_prog->aux->func[subprog]->bpf_func;
> +                       if (subprog == 0)
> +                               addr = (long) tgt_prog->bpf_func;
> +                       else
> +                               addr = (long)
> tgt_prog->aux->func[subprog]->bpf_func;
>                  } else {
>                          addr = kallsyms_lookup_name(tname);
>                          if (!addr) {
> -bash-4.4$
>
> The reason is for a bpf program without any additional subprogram
> (callees), tgt_prog->aux->func is not populated and is a NULL pointer,
> so the access tgt_prog->aux->func[0]->bpf_func will segfault.
>
> With the above change, your test works properly.

Thanks for the quick response, and as you mention the test passes with 
the patch above.

I will continue my experiments later this week, and let you know if I 
run into any other problems.

Cheers,

Eelco
