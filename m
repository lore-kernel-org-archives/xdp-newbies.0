Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11682 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbfHPAHi (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 15 Aug 2019 20:07:38 -0400
From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v2 1/3] libbpf: use LFS (_FILE_OFFSET_BITS)
 instead of direct mmap2 syscall
Date: Fri, 16 Aug 2019 00:06:57 +0000
Message-ID: <7e323b73-8ed1-349f-4c08-49450854be0d@fb.com>
References: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
 <20190815121356.8848-2-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190815121356.8848-2-ivan.khoronzhuk@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9A6445D787AF145A235E478231C6746@namprd15.prod.outlook.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>, "bjorn.topel@intel.com" <bjorn.topel@intel.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "hawk@kernel.org" <hawk@kernel.org>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jlemon@flugsvamp.com" <jlemon@flugsvamp.com>, "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>



On 8/15/19 5:13 AM, Ivan Khoronzhuk wrote:
> Drop __NR_mmap2 fork in flavor of LFS, that is _FILE_OFFSET_BITS=64
> (glibc & bionic) / LARGEFILE64_SOURCE (for musl) decision. It allows
> mmap() to use 64bit offset that is passed to mmap2 syscall. As result
> pgoff is not truncated and no need to use direct access to mmap2 for
> 32 bits systems.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Acked-by: Yonghong Song <yhs@fb.com>
