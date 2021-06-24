DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
	h=from : to : cc : date :
	message-id : references : in-reply-to : content-type : content-id :
	content-transfer-encoding : mime-version : subject; s=pp1;
	bh=xqWLM5nqFop7TcYnR14ZyZBjij/6IPIhwc4dBdGvQC4=;
	b=MDguI9kaigN43lJ/gSgcl73F68p3t5Z44Ppc5nNhnrdqmlzaNj7cpbAVNcMN6eVyja6x
	941X0+zpDbcmRI/y91PwKOIAfLQTCuVNjPpryKAnHVNAGesyONq+i/nuT2FvrtsZTkr9
	rfiN3wU5nGFEAQzz0EXrt7bN+yroaTlY1gQWmrHPqVvSRROwZkZue6wmcZhwp/cTmIcS
	Ea5ydoTLUpLt+8yKvp2mZJgDkguCvCt/fv3RZpF4CaLxA8e8vSk1DqGD+82nmlamGfkL
	6CXyv5f4zXlhsK+dbyDs9XlLCicIhYxCU8b/B4kDzMCyWGM+GQdH0Il923IfAokaR+/2
	mQ==
From: Ameer Ghani <Ameer.Ghani@ibm.com>
Date: Thu, 24 Jun 2021 14:23:16 +0000
Message-ID: <D046F506-4DA1-4CBC-84ED-E48A15921F53@ibm.com>
References: <6CB1BF38-465E-44CB-B9C4-BB09258BAB1B@ibm.com>
	<20210622134529.GA1493988@redhat.com>
In-Reply-To: <20210622134529.GA1493988@redhat.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <5959752A50CAB8459DF48D1CC1162CB2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] virtiofsd: doesn't garant write access at users
 allowed by group permission
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>


﻿On 6/22/21, 8:46 AM, "Vivek Goyal" <vgoyal@redhat.com> wrote:

>    I guess its ok to set SECBIT_NO_SETUID_FIXUP and drop CAP_SETPCAP and
>    let virtiosd drop capabilities explicitly where need be.
>
>    If this becomes too painful or inefficient from performance point of view,
>    we probably will have to change it and set SECBIT_NO_SETUID_FIXUP only
>    during file creation path. (lo_create and lo_mknod).

I think I follow. Will proceed with permanent SECBIT_NO_SETUID_FIXUP, but I'll
also explore setting/dropping in places where it's explicitly needed.

>    I would think that don't ask user to opt-in for this behavior and just
>    implement it for everyone. Asking too many many questions will make
>    configuration more complex.

Understood.

>    Can you please also run xfstests and see if this patch introduces any
>    regressions. Just want to make sure there are no unintended side affects.
>
>    Please do submit a formal patch.

Will do!


