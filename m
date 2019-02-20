Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it1-f169.google.com ([209.85.166.169]:36211 "EHLO
        mail-it1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfBTJIZ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 20 Feb 2019 04:08:25 -0500
Received: by mail-it1-f169.google.com with SMTP id h6so13827626itl.1
        for <xdp-newbies@vger.kernel.org>; Wed, 20 Feb 2019 01:08:25 -0800 (PST)
MIME-Version: 1.0
From: Pavel Popa <pashinho1990@gmail.com>
Date: Wed, 20 Feb 2019 10:08:13 +0100
Message-ID: <CAHOxX0w8JcbOuq2r8eVVH9ceGEo2sR6ZSpm3khVUBQ-RxVL1XQ@mail.gmail.com>
Subject: AF_XDP ring pairs handling
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi all,

I'd like to know a detail regarding the handling of AF_XDP's
<producer, consumer> ring pairs  (i.e <fill, rx>, <completion, tx>).
When writing in a producer ring the values {0, 1, 2, 3} exactly in
this order and updating the head pointer by += 4, will the consumer
ring will be populated with these values {0, 1, 2, 3} in exactly this
order?

Thanks
