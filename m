Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:52614 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbfEUO4h (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 21 May 2019 10:56:37 -0400
Subject: Re: [PATCH bpf] samples/bpf: suppress compiler warning
References: <20190520214938.16889-1-mcroce@redhat.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f874efcb-f2a2-1d5f-7c43-cebdb828e465@iogearbox.net>
Date: Tue, 21 May 2019 16:56:34 +0200
MIME-Version: 1.0
In-Reply-To: <20190520214938.16889-1-mcroce@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Matteo Croce <mcroce@redhat.com>, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>

On 05/20/2019 11:49 PM, Matteo Croce wrote:
> GCC 9 fails to calculate the size of local constant strings and produces a
> false positive:
> 
> samples/bpf/task_fd_query_user.c: In function ‘test_debug_fs_uprobe’:
> samples/bpf/task_fd_query_user.c:242:67: warning: ‘%s’ directive output may be truncated writing up to 255 bytes into a region of size 215 [-Wformat-truncation=]
>   242 |  snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/events/%ss/%s/id",
>       |                                                                   ^~
>   243 |    event_type, event_alias);
>       |                ~~~~~~~~~~~
> samples/bpf/task_fd_query_user.c:242:2: note: ‘snprintf’ output between 45 and 300 bytes into a destination of size 256
>   242 |  snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/events/%ss/%s/id",
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   243 |    event_type, event_alias);
>       |    ~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Workaround this by lowering the buffer size to a reasonable value.
> Related GCC Bugzilla: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83431
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Applied, thanks!
