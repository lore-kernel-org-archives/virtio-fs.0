Date: Tue, 14 Jan 2020 12:28:31 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200114122831.GI2812@work-vm>
References: <20200113093735.4610-1-yangx.jy@cn.fujitsu.com>
	<20200114121457.GG2812@work-vm> <5E1DB369.1000903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5E1DB369.1000903@cn.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH 1/2] vitriofsd/passthrough_ll: Make
 fallocate() work
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
> On 2020/1/14 20:14, Dr. David Alan Gilbert 写wrote:
> > Thanks; I've merged the fh fix into Stefan's 'add fd_map to hide file
> > descriptors'
> > patch.
> > 
> > I'll merge the ifdef fix with your next fix and take it as a separate
> > patch.
> Hi Dave,
> 
> Thanks for your review and explanation.
> Do you mean that I don't need to send v2 patch?

Correct; I've merged together the patches you sent.
I'll push a new -dev just as soon as I've done a basic smoke test.

Dave

> Thanks,
> Xiao Yang
> > 
> > Dave
> 
> 
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

