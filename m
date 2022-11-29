Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=lZqYt7DGSda3M+AU1nq/d6A2DRd8wn86Aq2Rs8xNEyI=;
 b=gfTlGLBmHJxhBTD5VRZOQLCDl7uk2++og36qk5Sg42xpBzsXWFmctYAZGjYZxz7ZPC
 UuTLL6zOu+qW5axzMa3ZevnrjqaHbVKeqnnOrqoV3mPW+5B+wBPDB1dK/SyT/0Xo54VF
 9PX6C//OPsVcWXsQ/IWeDMTvDA/9VN7d6Ypqog/xQD8ll/hZEUd8ym9uxD5wB3WXOSoa
 0l/e0D0J7a/2HM1pVyKoPcD/9JLazWWm3e1RPbZ6kUEVS3l7rx+Uha3Rsu4JEJ6R2Bvz
 DHZVH2iyTQcMucLgHneQjbIG2ePml64wWJRCKrucTkZ1DfoXj3Am/73KAHgQhUBqpyli
 PEQg==
MIME-Version: 1.0
References: <20221125143946.27717-1-mhartmay@linux.ibm.com>
 <Y4UCPQ0E2ZY15aEq@work-vm> <87wn7ef6cm.fsf@linux.ibm.com>
 <Y4XT/ZxuyU7F5h1n@work-vm>
 <1a94f96b-d9b6-44af-cedb-aa17eb1a3a84@de.ibm.com>
 <618edde1-31d8-9db8-48d9-137fe81b788b@de.ibm.com>
 <Y4XcByAJBWaCo0sP@work-vm>
In-Reply-To: <Y4XcByAJBWaCo0sP@work-vm>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 29 Nov 2022 07:04:22 -0500
Message-ID: <CAJSP0QWbQpysVn=oAQdvcq0WrBuPVf_MX4fbwobCLTS1AP_Ncg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Add `sigreturn` to the seccomp
 whitelist
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, Marc Hartmayer <mhartmay@linux.ibm.com>, qemu-devel@nongnu.org, qemu-s390x <qemu-s390x@nongnu.org>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, Sven Schnelle <svens@linux.ibm.com>, Stefan Liebler <stli@linux.ibm.com>

To find out:
# perf record -e signal:signal_deliver
...wait for QEMU shutdown...
^C
# perf script
qemu-system-x86_64 2319136 [001] 1062886.415312:
signal:signal_deliver: sig=2 errno=0 code=128 sa_handler=7fc6ccfbabc0
sa_flags=14000004

sig=2 is SIGINT. This is just an example, I didn't run virtiofsd.

