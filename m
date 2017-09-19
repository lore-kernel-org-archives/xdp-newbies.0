Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:46980 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751614AbdISXLI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 19 Sep 2017 19:11:08 -0400
Received: by mail-wm0-f48.google.com with SMTP id i189so2720139wmf.1
        for <xdp-newbies@vger.kernel.org>; Tue, 19 Sep 2017 16:11:08 -0700 (PDT)
Subject: Re: [iovisor-dev] [PATCH RFC 3/4] New 32-bit register set
References: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com>
 <1505767641-40512-4-git-send-email-jiong.wang@netronome.com>
 <CAH3MdRVE-CCzVoaFg1tDtyFV7s9Q5nwbotHDs3je03OeX7M9MA@mail.gmail.com>
From: Jiong Wang <jiong.wang@netronome.com>
Message-ID: <a6541ae5-0da5-4959-c903-36eb749cc3e9@netronome.com>
Date: Wed, 20 Sep 2017 00:10:40 +0100
MIME-Version: 1.0
In-Reply-To: <CAH3MdRVE-CCzVoaFg1tDtyFV7s9Q5nwbotHDs3je03OeX7M9MA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------ECCEEAEAFE318F1250152B78"
Content-Language: en-GB
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Y Song <ys114321@gmail.com>
Cc: xdp-newbies@vger.kernel.org, LLVM Developers Mailing List <llvm-dev@lists.llvm.org>, oss-drivers@netronome.com, Tom Herbert via iovisor-dev <iovisor-dev@lists.iovisor.org>

This is a multi-part message in MIME format.
--------------ECCEEAEAFE318F1250152B78
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/09/2017 07:44, Y Song wrote:
> Hi, Jiong,
>
> Thanks for the patch! It is a great start to support 32bit register in BPF.
> In the past, I have studied a little bit to see whether 32bit register
> support may reduce
> the number of unnecessary shifts on x86_64 and improve the
> performance. Looking through
> a few bpf programs and it looks like the opportunity is not great, but
> still nice to have if we
> have this capability. As you mentioned, this definitely helped 32bit
> architecture!
>
> I am not an expert in LLVM tablegen. I briefly looked through the code
> change and it looks like
> correct. Hopefully some llvm-dev tablegen experts can comment on the
> implementation.
>
> Below I only have a couple of minor comments.

Yong Hong,

   Thanks for the review.

   I have addressed your comments and attached the updated patch.

   Do you want me to put this patch set on to llvm review website? I 
guess it is the
   formal review channel?

Regards,
Jiong


--------------ECCEEAEAFE318F1250152B78
Content-Type: text/plain; charset=UTF-8;
 name="patch3-v2.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="patch3-v2.patch"

QWNrZWQtYnk6IEpha3ViIEtpY2luc2tpIDxqYWt1Yi5raWNpbnNraUBuZXRyb25vbWUuY29t
PgpTaWduZWQtb2ZmLWJ5OiBKaW9uZyBXYW5nIDxqaW9uZy53YW5nQG5ldHJvbm9tZS5jb20+
CgpkaWZmIC0tZ2l0IGEvbGliL1RhcmdldC9CUEYvQlBGUmVnaXN0ZXJJbmZvLnRkIGIvbGli
L1RhcmdldC9CUEYvQlBGUmVnaXN0ZXJJbmZvLnRkCmluZGV4IGM4ZTI0ZjguLmRhMWQ2YjUg
MTAwNjQ0Ci0tLSBhL2xpYi9UYXJnZXQvQlBGL0JQRlJlZ2lzdGVySW5mby50ZAorKysgYi9s
aWIvVGFyZ2V0L0JQRi9CUEZSZWdpc3RlckluZm8udGQKQEAgLTExLDMxICsxMSw0MiBAQAog
Ly8gIERlY2xhcmF0aW9ucyB0aGF0IGRlc2NyaWJlIHRoZSBCUEYgcmVnaXN0ZXIgZmlsZQog
Ly89PT0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tPT09Ly8KIAorbGV0IE5hbWVzcGFjZSA9ICJCUEYiIGlu
IHsKKyAgZGVmIHN1Yl8zMiA6IFN1YlJlZ0luZGV4PDMyPjsKK30KKworY2xhc3MgV2k8Yml0
czwxNj4gRW5jLCBzdHJpbmcgbj4gOiBSZWdpc3RlcjxuPiB7CisgIGxldCBIV0VuY29kaW5n
ID0gRW5jOworICBsZXQgTmFtZXNwYWNlID0gIkJQRiI7Cit9CisKIC8vIFJlZ2lzdGVycyBh
cmUgaWRlbnRpZmllZCB3aXRoIDQtYml0IElEIG51bWJlcnMuCiAvLyBSaSAtIDY0LWJpdCBp
bnRlZ2VyIHJlZ2lzdGVycwotY2xhc3MgUmk8Yml0czwxNj4gRW5jLCBzdHJpbmcgbj4gOiBS
ZWdpc3RlcjxuPiB7Ci0gIGxldCBOYW1lc3BhY2UgPSAiQlBGIjsKK2NsYXNzIFJpPGJpdHM8
MTY+IEVuYywgc3RyaW5nIG4sIGxpc3Q8UmVnaXN0ZXI+IHN1YnJlZ3M+CisgIDogUmVnaXN0
ZXJXaXRoU3ViUmVnczxuLCBzdWJyZWdzPiB7CiAgIGxldCBIV0VuY29kaW5nID0gRW5jOwor
ICBsZXQgTmFtZXNwYWNlID0gIkJQRiI7CisgIGxldCBTdWJSZWdJbmRpY2VzID0gW3N1Yl8z
Ml07CiB9CiAKLS8vIEludGVnZXIgcmVnaXN0ZXJzCi1kZWYgUjAgOiBSaTwgMCwgInIwIj4s
IER3YXJmUmVnTnVtPFswXT47Ci1kZWYgUjEgOiBSaTwgMSwgInIxIj4sIER3YXJmUmVnTnVt
PFsxXT47Ci1kZWYgUjIgOiBSaTwgMiwgInIyIj4sIER3YXJmUmVnTnVtPFsyXT47Ci1kZWYg
UjMgOiBSaTwgMywgInIzIj4sIER3YXJmUmVnTnVtPFszXT47Ci1kZWYgUjQgOiBSaTwgNCwg
InI0Ij4sIER3YXJmUmVnTnVtPFs0XT47Ci1kZWYgUjUgOiBSaTwgNSwgInI1Ij4sIER3YXJm
UmVnTnVtPFs1XT47Ci1kZWYgUjYgOiBSaTwgNiwgInI2Ij4sIER3YXJmUmVnTnVtPFs2XT47
Ci1kZWYgUjcgOiBSaTwgNywgInI3Ij4sIER3YXJmUmVnTnVtPFs3XT47Ci1kZWYgUjggOiBS
aTwgOCwgInI4Ij4sIER3YXJmUmVnTnVtPFs4XT47Ci1kZWYgUjkgOiBSaTwgOSwgInI5Ij4s
IER3YXJmUmVnTnVtPFs5XT47Ci1kZWYgUjEwIDogUmk8MTAsICJyMTAiPiwgRHdhcmZSZWdO
dW08WzEwXT47Ci1kZWYgUjExIDogUmk8MTEsICJyMTEiPiwgRHdhcmZSZWdOdW08WzExXT47
Citmb3JlYWNoIEkgPSAwLTExIGluIHsKKyAgLy8gMzItYml0IEludGVnZXIgKGFsaWFzIHRv
IGxvdyBwYXJ0IG9mIDY0LWJpdCByZWdpc3RlcikuCisgIGRlZiBXI0kgIDogV2k8SSwgICJ3
IiNJPiwgIER3YXJmUmVnTnVtPFtJXT47CisgIC8vIDY0LWJpdCBJbnRlZ2VyIHJlZ2lzdGVy
cworICBkZWYgUiNJICA6IFJpPEksICAiciIjSSwgIFshY2FzdDxXaT4oIlciI0kpXT4sICBE
d2FyZlJlZ051bTxbSV0+OworfQogCiAvLyBSZWdpc3RlciBjbGFzc2VzLgotZGVmIEdQUiA6
IFJlZ2lzdGVyQ2xhc3M8IkJQRiIsIFtpNjRdLCA2NCwgKGFkZCBSMSwgUjIsIFIzLCBSNCwg
UjUsCi0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUjYsIFI3
LCBSOCwgUjksIC8vIGNhbGxlZSBzYXZlZAotICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIFIwLCAgLy8gcmV0dXJuIHZhbHVlCi0gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgUjExLCAvLyBzdGFjayBwdHIKLSAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBSMTAgIC8vIGZyYW1lIHB0cgot
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKT47CitkZWYgR1BS
MzIgOiBSZWdpc3RlckNsYXNzPCJCUEYiLCBbaTMyXSwgMzIsIChhZGQKKyAgKHNlcXVlbmNl
ICJXJXUiLCAxLCA5KSwKKyAgVzAsIC8vIFJldHVybiB2YWx1ZQorICBXMTEsIC8vIFN0YWNr
IFB0cgorICBXMTAgIC8vIEZyYW1lIFB0cgorKT47CisKK2RlZiBHUFIgOiBSZWdpc3RlckNs
YXNzPCJCUEYiLCBbaTY0XSwgNjQsIChhZGQKKyAgKHNlcXVlbmNlICJSJXUiLCAxLCA5KSwK
KyAgUjAsIC8vIFJldHVybiB2YWx1ZQorICBSMTEsIC8vIFN0YWNrIFB0cgorICBSMTAgIC8v
IEZyYW1lIFB0cgorKT47Cg==
--------------ECCEEAEAFE318F1250152B78--
