Date: Tue, 21 Jan 2020 11:55:13 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200121115513.GF2929@work-vm>
References: <20200121073236.9067-1-yangx.jy@cn.fujitsu.com>
	<20200121100235.GA2929@work-vm> <5E26D634.6000905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5E26D634.6000905@cn.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd/passthrough_ll: Fix wrong output
 format in lo_setxattr()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc: virtio-fs@redhat.com

* Xiao Yang (yangx.jy@cn.fujitsu.com) wrote:
> On 2020/1/21 18:02, Dr. David Alan Gilbert wrote:
> > Thank you for the fix!  I think we need to mark fuse_log as being printf
> > format so hopefully it will spot more of these errors automatically.
> Hi Dave,
> 
> Do you perfer to write output to stdout rather than stderr? right?(e.g.
> replace vfprintf with vprintf?)

No, I think it's OK as is.

> BTW: Perhaps, log_func() needs to call g_free() after using
> g_strdup_printf().

No because the pointer is declared with g_autofree - it does the
free automatically.

Dave

> Thanks,
> Xiao Yang
> > Dave
> 
> 
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

