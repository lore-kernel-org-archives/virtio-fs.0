DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=subject:to:references:from:autocrypt:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=z5gaaSNBXhOqQr9UWKOpjBgVGTT/d68Yf1ubZwxMqp0=;
	b=KaxqK7J8vVLSlv5zu3hezErTpjnQHUF9rn0/OWmmR4SY78Z+/Ikp3+e3GGoecZdSzC
	aHB+hAuNYiceAwQTMLgo7hm32sIdMVGDVuSDphPWhaqwbJEKm+9nqTW0ZXZFvGcNjBZ9
	IkAcYry9lWOiwjF4R9R7j/3iaArEVf5VE045mvy42FB1UH23wx4AYU3qCqrjMu+HtDkT
	OiP8YsoRjuQOijNTZpYlmQYp4rCjJ8Q37DvtAYtkRMARO5lSINOjcourgY8p0sxO+ubi
	kPG3m3/Rpxi6KCFjmO3q0+H6fOT0WWV5tmP8lK1Q38oQ1j4pZF2r3Urrfi6aSbM+iAeD
	NHPw==
References: <20200929185015.GG220516@redhat.com>
	<CAOQ4uxgMeWF_vitenBY6_N3Eu-ix92q8AO5ckDAF+SVxHTBXXw@mail.gmail.com>
	<CAJfpegtH0TruLCnG_YJ8aUBHh7k5sqN_wVEegvDPJOoDcmwLSQ@mail.gmail.com>
	<CAOQ4uxiity6zAW__Y+T=o+GHkzxo=fnVj+21Z8cRjdvFWbauRQ@mail.gmail.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <dfa0dbea-7046-0852-60c6-39bc24f24314@gmail.com>
Date: Thu, 1 Oct 2020 08:47:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxiity6zAW__Y+T=o+GHkzxo=fnVj+21Z8cRjdvFWbauRQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] Kudos: productivity boost using virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Though it's likely been written before:

Virtio-fs is a wonderful productivity boost in development environments
in which unrelated deadlocks, crashes and hard-lockups happen.   Why? 
Because the underlying file system is never corrupted (though individual
file contents may be, the file system itself is protected).   For
example, using btrfs' snapshot ability in the underlying file system and
comparing 'before and after' crashes creates a powerful debugging tool.

I suspect most folks involved in virtio-fs know this, but it's worth
putting in the record for new folks.

Harry




