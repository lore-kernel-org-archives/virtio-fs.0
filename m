Date: Thu, 6 Aug 2020 18:41:29 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200806174129.GK2711@work-vm>
References: <20200727161841.GA54539@redhat.com>
	<OSBPR01MB4582AB9CD2DB32A48A8BB13FE5480@OSBPR01MB4582.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSBPR01MB4582AB9CD2DB32A48A8BB13FE5480@OSBPR01MB4582.jpnprd01.prod.outlook.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Disable remote posix locks by
 default
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, 'Vivek Goyal' <vgoyal@redhat.com>

* misono.tomohiro@fujitsu.com (misono.tomohiro@fujitsu.com) wrote:
> > Right now we enable remote posix locks by default. That means when guest does a posix lock it sends request to server
> > (virtiofsd). But currently we only support non-blocking posix lock and return -EOPNOTSUPP for blocking version.
> > 
> > This means that existing applications which are doing blocking posix locks get -EOPNOTSUPP and fail. To avoid this,
> > people have been running virtiosd with option "-o no_posix_lock". For new users it is still a surprise and trial and error
> > takes them to this option.
> > 
> > Given posix lock implementation is not complete in virtiofsd, disable it by default. This means that posix locks will work
> > with-in applications in a guest but not across guests. Anyway we don't support sharing filesystem among different guests
> > yet in virtiofs so this should not lead to any kind of surprise or regression and will make life little easier for virtiofs users.
> > 
> > Reported-by: Aa Aa <jimbothom@yandex.com>
> > Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  tools/virtiofsd/passthrough_ll.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> We should update docs/tools/virtiofsd.rst as well. Given that:
>  Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Fixed up the doc.

Dave

> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

