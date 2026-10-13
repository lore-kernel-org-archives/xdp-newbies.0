Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4352224679C
	for <xdp-newbies@vger.kernel.org>; Tue, 13 Oct 2026 22:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929547; cv=pass; b=IYyyJqC2kb0qcuGu/ggD6FPFMVn/FUI5mImkrJT3khvfvOAVQlHVC0OBMQ+JBmFWiV/NbgvhU6ky6LQTceyXZ4Jy7ScABN/Lg7EeO/jKUjA3ip+dTdSlzj+TPnO0tyfL5joPjSWIglyPW536M04OYKZTOnjoShGs+rZOwgaRMxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929547; c=relaxed/simple;
	bh=pyKYzYCyh9ueYuZnX7v5fscC/rAj1BL903QgBzEMovM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=PJa8FhUygrneBvQhoHKap6sE2cp+EXsxF3BjUirAvx7EoQx/ZzsFth2YOoFTH8j9oIboCdO3VtJqWkMakIUxlO4NZmfoIG6amStl/QvTOWN9iYXH6QyfmHLNq3gilMdo2VMYyPWFSHV4S0pnRFnMcUJ45m6u8dkrTDmx8yYlnwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JagfcRNR; arc=pass smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JagfcRNR"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-3aae898c0afso3583831fa.1
        for <xdp-newbies@vger.kernel.org>; Tue, 13 Oct 2026 15:12:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791929544; cv=none;
        d=google.com; s=arc-20260327;
        b=rHyuXHBWcFw1ftkwnXnVrgWqoU9qSXIBVulam2saum9OcJ1mKDQldgdc348mGRiHW2
         4uRS2j6XGsz2ZP69+k/RU15Z+b/403Thev/RU+VVxk6Otyn3daK3YTibNh1/vszWicep
         rr88t0Xb4/DxNQbYZHZj+allRyzHHFYJ4MCljmi1yqmsSAWxkOWpSJhZ5LofLhKYMWUu
         Q/ePbOtvYrbm5bunX0ffJN3wlOQCzwaugWqjTqvXoDMj1SXzItBmsnRTRTj+x4zwVUt2
         S9M4wO9kiUGyOGKZrsSqhzXrbW3ZyFZJAecdPTc0nOue0Kpzg16VW6kr0Rpi6X9O1P2T
         FGng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=pyKYzYCyh9ueYuZnX7v5fscC/rAj1BL903QgBzEMovM=;
        fh=TgbYq5UfoE+cqa8MtroVnPnEXUEdTl+LI2AU+LrumBQ=;
        b=gaKWH45tiCsjq5pG/ULfFXC11IZa0MO2PUDWqerUC2C7ot1OeB1IusUGqU04wy72Gx
         5VjbUzRAlKEN06adMXpQFNO3fAyFJqJZqPbEQqZ3kKrtBcVnCoMcv9J0D3U+pGF+3TF9
         nk3INxu9rsgpoZiV6TloUCkaPRq6MqfYV+iDdwDLoxinpitb7HNlIcmiO1QkBe67DL07
         Q8rx3npWY/4pZ0dBA+0gp/N7gIiy/tmtG/vAdh8OijttMa4EZYSUGns3Kk/Yaua8Psen
         9ZSenymd/cElwn2gYGEdkUaSpYLVlKLHeEY45C/YuUri2rhKf6zDNkHjqxrsFb+781jh
         Jm2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791929544; x=1792534344; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=pyKYzYCyh9ueYuZnX7v5fscC/rAj1BL903QgBzEMovM=;
        b=JagfcRNRyBbeC0RFuE5+GumKAWSuPKh47bUyfSOLmgSboPKZt1dtNnlo6+k5mqH5us
         QH0FvINmFWoJ5fXEVv83urtwY5QVIDr2HO3zdf49ihs6v8Il8qRKEKczZXOvI1Ys6XqI
         /n1bd/g+i9QptPU4bP5UZ1EYQmzWFUxl4n5diNTBvIlKFOWxIqIFuWwYhiPdh8+YpaFz
         t+0LCb2eNkcZDForB+ZV1UWVQqlyj29zrJqBwFY3yfv7+cAAf8utMss5r456CBBZrzoK
         zA4V4zvafiPyww9jH2PJxJMtXpVUqk20L3GRjH86n5B5pHDVCZ32L3jjgS20k7dgllRp
         u62A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791929544; x=1792534344;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pyKYzYCyh9ueYuZnX7v5fscC/rAj1BL903QgBzEMovM=;
        b=pRvAphuVndQXcb2rsxMazQLl9bpirb+QCB/iA59LhSjbtowElz4dhFvxWwAlPsPEGV
         djaBB34682nYX5YTzLcTHKvvwISkL2OdPSQnMcZOwa3DU8AnQBHz9rxMmlevB6iFvtUX
         F0M6GqonRs9QHmOa/Ay/nV/NzN18+FkW12OtByxWeyaNPCSpPxH+/wSKdEJ1g0/igBSj
         9LyFVBEttRB11xUOKhUyiF2PdtAXAIUjdpnPNC+QjyepQPtJlqhSgppk2TzLWMq5w8Ha
         8OZYX+slLAtzQ+AQdF0Td0ca6uW9kh4KBDhx1RjF/YFOZ303sn/6+MJyUnTIEDolKwFU
         NEZw==
X-Gm-Message-State: AFq9FYKIhBL9723itg8/TrRmYmsh6FOYdcfL5SwAfEreJCfz+tzUYPhr
	GVnVCWeelk62XYCzlIDibSvvANf0qv2iFLspJpWQd+Fw/pUrQ+dvqkB+sW1+BSSXr17FvfpLz/1
	r+hoEkoddlkLwe6Dq4XBrWUvCS7Uq2Sq+JHEN
X-Gm-Gg: AYBFou0CY7fMfrtgsJ0FfhmS5uqSJxdg5PrvuKmEcCfcXfb6iyTw1bJpX0VWhuwQf88
	HLNWAnRepwMRLF3E8sArj+TIFh2HrX3T8HPx9Fhuw5tpmEM6vI370r6c3WnJA7WYu+p9/0iJmhN
	cB05bIQetu60VRYIgnphodQha4S9XKxXXLLNSBjeBFFgqYycLUT073tU6VU2153xbLToYODXdrF
	IYhucawhO1299yJy5h0ibzSiTGwLLrPXINzxCv2DyKFIxejm8BItQw2jFXUxazQTvFsntkh9SqC
	DAjvfGy6QpkuzMiajhuc80+RclIJcVDxmQsgzhEh4AMzD1GYdvq8sy9F52dfVn313HWIR+z9Akl
	0W9T7uxKEUCA=
X-Received: by 2002:a2e:bc1b:0:b0:3a6:70bf:622e with SMTP id
 38308e7fff4ca-3a9c515cfa9mr32651021fa.4.1791929544092; Tue, 13 Oct 2026
 15:12:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: xdp-newbies@vger.kernel.org
List-Id: <xdp-newbies.vger.kernel.org>
List-Subscribe: <mailto:xdp-newbies+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:xdp-newbies+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Srinidhi Krishna <srinidhikrishna.mec@gmail.com>
Date: Wed, 14 Oct 2026 00:12:10 +0200
X-Gm-Features: AclHuK_bgZn-XLDkF5m1Sk_Pv-VVJ8UCqN7295UuAt2NfR0OjQptMFkdRbkvVgY
Message-ID: <CA+zECWyxVwCYyfbPJtT2fNWkxkLT+i+uyfrRPXtUE6re9BXfvA@mail.gmail.com>
Subject: Interested in contributing to xdp-project
To: xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I recently had the opportunity to work on Real-Time Test Bench which
introduced me to XDP. Since then I have been learning more about XDP
and am currently interested in contributing to xdp-tools.

I had gone through the
https://xdp-project.net/#outline-container-Important-medium-term-tasks
list and felt one of the issues in the BPF selftest could be a good
starting point.

Please let me know if this is something that still needs to be done,
else I would be interested in taking similar issues as a first step.


Best,
Srinidhi
