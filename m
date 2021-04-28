DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=oVM+iCdaFxsIfPwq2nMLDZ6TqTYet379ZeoHbJGRbTQ=;
	b=xgecX1li+vZtq3cln0N6XPWA+P7KKlGO+QkJHeToGBYOk+pJGm7UzU6xHUtWnxUoUd
	k4SObdNEzxatSE1/axJ3GHwN9LyypcfNVyIiyyduihy/LYRAlkQ9kK09QkqhmtGDaquq
	ZKT8sZz/ERBbzZ8USiHw1BsnjPcRwSD8s47+G+R1CHXkx+Rnu6EWxm5pZre87qVZZdME
	Lg4qoLDGAKY2bs87DtmBn1Vghi97JwG+cuMHs7QBI4q6aynW9zyBY9rxnZ3NmxOujD5U
	Zr1x1W0WpgejANg2Szdhoe0QlIDP2pmNTJNK9HBrZA+0u0xsEWoPK/FMGt4Mzc0kx1Wm
	FvbQ==
MIME-Version: 1.0
References: <20210428190314.1865312-1-vgoyal@redhat.com>
In-Reply-To: <20210428190314.1865312-1-vgoyal@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Apr 2021 14:08:28 -0700
Message-ID: <CAPcyv4jYyYOXyZLv1Pz3Vy1U7B7BzNrp4TO1MzANkYOMA0u_4A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v6 0/3] dax: Fix missed wakeup in
	put_unlocked_entry()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, willy@infradead.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 28, 2021 at 12:03 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Hi,
>
> This is V6. Only change since V5 is that I changed order of WAKE_NEXT
> and WAKE_ALL in comments too.
>
> Vivek
>
> Vivek Goyal (3):
>   dax: Add an enum for specifying dax wakup mode
>   dax: Add a wakeup mode parameter to put_unlocked_entry()
>   dax: Wake up all waiters after invalidating dax entry

Thanks Vivek, looks good.

