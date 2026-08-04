Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95AD459ADF
	for <virtio-fs@lists.linux.dev>; Tue,  4 Aug 2026 11:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785841508; cv=none; b=sbUSBHGwc0vQp3X/OiVBTLMN42rlZNiafok6TUb4ayPbB9DJujfCnPp8/l2rIDAAP2mLsifLzoPU5nc0IEjCnD92BUp2klq3fMHZ2ypcfHyc/ddF1Su9qx8DgpjavKSSyA/KUQexg6iZjTLqQvoUbFvZFc9okAM1zfoHl95+iLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785841508; c=relaxed/simple;
	bh=eV6BhAH7+JY+LKmu52ijxR37ul8FRzZdZBonFccFTAc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I44NYPDJzWgTnfBf7s6S5c+TXpMH31kNremR698aAoO9x79VctjZ7E8Uu3ZV/WeO5+Vy0Ljs+zhtEU9B8Ta6dfOeX3wWPdgFme9c/nIKEeuIqlbuE8j6/LSfCGT/2BL5MTc3CV98Fe4cjnyf6l6QbkhaksRk7HAOAW9bc5+LfFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PH6gVu4q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PH6gVu4q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785841501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZPso8bybjvlzpSiniMJSg48FKCs4+i7LpgHDKwGEwWY=;
	b=PH6gVu4qkLHrGcedf4ePjad0/JbP/cnmzZDePb8CkyRIiZlx5B68h3i0kwi9pmpMpDhK7y
	vJhYmpkpj9GZjWohEboKJFdhHHr1O5KEIr3ALyRRLpuNcinmCqiQlINVD+widdQH1jt9wm
	2mTZUFGZbFYjNfmbWehRqlLLWA+xhS4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-c-n7m8IbPH-ceE1xtE9klA-1; Tue, 04 Aug 2026 07:04:59 -0400
X-MC-Unique: c-n7m8IbPH-ceE1xtE9klA-1
X-Mimecast-MFC-AGG-ID: c-n7m8IbPH-ceE1xtE9klA_1785841499
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49808ea1b64so11585745e9.1
        for <virtio-fs@lists.linux.dev>; Tue, 04 Aug 2026 04:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785841498; x=1786446298;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZPso8bybjvlzpSiniMJSg48FKCs4+i7LpgHDKwGEwWY=;
        b=lkuft+b6yrvxFe6CgmYnZBc/HMAeduRhfKgQCEGbu9ELFr1RTnS2pIMq72NV5U1TvF
         m9jXwizqInmfE6Lhxze7grLOpAjXQMYV/0J1qL03ZWPJ4AeZtCR4jAtKvwa57/GYwe4v
         29+iQ+msafEbNLPRwsLvnKdu0+mJtZpG+dB4AiYE6zF/MJHNcJqT1xT67+KZpHDnjL70
         Y4zuiZ5I5YKF3gjE6pRqFDYt3E04CkrTQhifVY737doeTCLrE2okY1p9JekZ5EIeaWws
         TfFFnpMVheDMBDgkwcO/yAHMy/tbl8TauR9uks0dDJBRz9B8DW2SoDjMRwrLfcYYlGlD
         RZmg==
X-Forwarded-Encrypted: i=1; AHgh+RpcBPth3Vu8piQEQ4SKU/dC+TGVdOVo+x4LqzoRyAw+d/qLSsLZqkYUMBa0IzXHwLqUHf9A/vJH5Hc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxw6vsglIYPuAPMebRvCiFSA+Bwtnkc1lbIGQUYGxSNDcwtfNJk
	Xj+ZLgOGmh5KMcaN7yXPZ2S2DxkZ/ZKCBN0HZun0JNZkwkh7jcs63XkA9Rx3qVJwZjJ3arCpk+n
	BF3w54SHK1IXLk6npGTty+4GHQ9B4GGe7NNKoV9fmNpY7sx1SsQ98TaW2QIU8yw==
X-Gm-Gg: AR+sD129PG05P7fMQaT7NAgefCFIMumiN3U9NS7koA2F95FBo1rIg4Q+N1D6wSWOe1e
	euGt3Dx8P3ATFYJJYW2jaWl7v3NqhcnOyeA46/oOmU4UQGENB0K8oUY4qxi69uvV+lXnzdswAdn
	VfV0EgT9eZP8+QIg6mCu+NZ+96s/KBSnSvMpJ7Lkt/N5t9L6kqO82s6cGaaoXofJC90Ly1H6++O
	3bZtOCsyLrxRYpAg2192F6kKed3eb1nAfMbRDXl+20qeqnXoWNqSnh0dxXNI4jv03ey9ZKRD+gS
	aj8iMB/qtTir8Yyp7q6Hbz7Ci682R0SjUsf3e48qWwG1JG5QnnmYjOJtHTeyoJp4Mo5/0NHZoAN
	FA4NNy67cHmc6eniIWbi2xu7MZEVYIVOnt0DftPjKFSPkJ4q9KEMhHzF5yBOjOIAR8ajGC8ffFk
	DcqXw/mN7pKlw/G2f5b32Y43LXHWsMcQ==
X-Received: by 2002:a05:600c:798:b0:495:58fe:88e5 with SMTP id 5b1f17b1804b1-49949fd988dmr60940585e9.2.1785841498604;
        Tue, 04 Aug 2026 04:04:58 -0700 (PDT)
X-Received: by 2002:a05:600c:798:b0:495:58fe:88e5 with SMTP id 5b1f17b1804b1-49949fd988dmr60939745e9.2.1785841498235;
        Tue, 04 Aug 2026 04:04:58 -0700 (PDT)
Received: from ?IPV6:2003:cf:d73d:54bb:1189:33b6:6950:ef97? (p200300cfd73d54bb118933b66950ef97.dip0.t-ipconnect.de. [2003:cf:d73d:54bb:1189:33b6:6950:ef97])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd456a6besm40240584f8f.22.2026.08.04.04.04.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 04:04:57 -0700 (PDT)
Message-ID: <c449898e-4159-4c30-ae5c-87af9c2645d5@redhat.com>
Date: Tue, 4 Aug 2026 13:04:55 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 06/15] util/iova-tree: g_tree_foreach wrapper
To: Connor Kite <connorkite@gmail.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 Haixu Cui <quic_haixcui@quicinc.com>, Raphael Norwitz <rnorwitz@nvidia.com>,
 Kevin Wolf <kwolf@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
 Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org,
 virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Alyssa Ross <hi@alyssa.is>,
 Demi Marie Obenour <demiobenour@gmail.com>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-6-6b97c439eb28@gmail.com>
 <f7776822-106c-47d0-ada9-fab75f68c76d@redhat.com>
 <CA+spn3rjAu5EcWBwG4NJmwqobdggJmZYVPrvn5Yq58Zyf0NEDA@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CA+spn3rjAu5EcWBwG4NJmwqobdggJmZYVPrvn5Yq58Zyf0NEDA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: njPeXnYGPeu4RRj4lrDuWYjrH06HkQbDXgn9S78ozzY_1785841499
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 03.08.26 23:13, Connor Kite wrote:
> On Mon, Aug 3, 2026 at 5:36 AM Hanna Czenczek <hreitz@redhat.com> wrote:
>>
>> Can you document roughly what the function looks like? Because the type
>> (`GTraverseFunc`) is not defined in qemu. I know it has a boolean as a
>> return type, and that one argument of it is going to be `gpointer data`,
>> but surely it will also take a tree element.
>>
>> Hanna
> I have updated the comment to describe the usage of GTraverseFunc as
> below:
>
> /**
> * iova_tree_foreach:
> *
> * @tree: the iova tree to traverse
> * @func: the function called at every node. A true return value ends traversal.
> *              Arguments:
> *                  gpointer key: key of current node
> *                  gpointer value: value of current node
> *                  gpointer data: data passed in at g_tree_foreach call
> *              Return: gboolean
> * @data: an argument passed to func
> *
> * Wrapper to call g_tree_foreach on the underlying g_tree. g_tree_foreach will
> * traverse through every node of the tree, barring an early return. At each
> * node, g_tree_foreach calls func with pointers to the node key, node value,
> * and a pointer to data passed in by the caller.
> *
> * Return: None
> */

Awesome, thanks!

Hanna

