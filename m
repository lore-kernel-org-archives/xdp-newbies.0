Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7E74418
	for <xdp-newbies@vger.kernel.org>; Thu, 23 Nov 2023 02:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjXdLO4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E80C433C9;
	Thu, 23 Nov 2023 02:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700708041;
	bh=rRbIXqjq8DKBA6vW+7glleky65j8TQodsqrm6IeWtY0=;
	h=Date:From:To:Subject:From;
	b=DjXdLO4Z27l67N5bmU2TXlfOaJMjh6g6EUUKGucO9nNB8KDJPnNggqPjR3TFInaqo
	 EVDaQt85hSVypEUb8zwDzwqJL5JIhH9HQU+uwZllof2ZYE5cMlsQsGxjHna3JXZllt
	 c/LCcapVfjzuQkRWCpH0o7PFEMsZlD+viIWc1ORk=
Date: Wed, 22 Nov 2023 21:54:00 -0500
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: xdp-newbies@vger.kernel.org
Subject: PSA: this list has moved to new vger infra (no action required)
Message-ID: <20231122-ruddy-elephant-of-freedom-a32d19@nitro>
Precedence: bulk
X-Mailing-List: xdp-newbies@vger.kernel.org
List-Id: <xdp-newbies.vger.kernel.org>
List-Subscribe: <mailto:xdp-newbies+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:xdp-newbies+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello, all:

This list has been migrated to the new vger infrastructure. No action is
required on your part and there should be no change in how you interact with
this list.

This message acts as a verification test that the archives are properly
updating.

If something isn't working or looking right, please reach out to
helpdesk@kernel.org.

Best regards,
-K
