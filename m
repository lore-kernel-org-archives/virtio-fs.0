Return-Path: <vgoyal@redhat.com>
Date: Tue, 20 Sep 2022 13:58:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <Yyn/UUVAHwV+bMP7@redhat.com>
References: <20220818184618.2205172-1-yokada.996@gmail.com>
 <YwZiyXqPTlSadOOR@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwZiyXqPTlSadOOR@fedora>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: use g_date_time_get_microsecond
 to get subsecond
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Yusuke Okada <yokada.996@gmail.com>, "open list:virtiofs" <virtio-fs@redhat.com>, Yusuke Okada <okada.yusuke@jp.fujitsu.com>, qemu-devel@nongnu.org

On Wed, Aug 24, 2022 at 01:41:29PM -0400, Stefan Hajnoczi wrote:
> On Thu, Aug 18, 2022 at 02:46:19PM -0400, Yusuke Okada wrote:
> > From: Yusuke Okada <okada.yusuke@jp.fujitsu.com>
> > 
> > The "%f" specifier in g_date_time_format() is only available in glib
> > 2.65.2 or later. If combined with older glib, the function returns null
> > and the timestamp displayed as "(null)".
> > 
> > For backward compatibility, g_date_time_get_microsecond should be used
> > to retrieve subsecond.
> > 
> > In this patch the g_date_time_format() leaves subsecond field as "%06d"
> > and let next snprintf to format with g_date_time_get_microsecond.
> > 
> > Signed-off-by: Yusuke Okada <okada.yusuke@jp.fujitsu.com>
> > ---
> >  tools/virtiofsd/passthrough_ll.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> Thanks, applied to my block tree for QEMU 7.2:
> https://gitlab.com/stefanha/qemu/commits/block

Hi Stefan,

Wondering when do you plan to send it for merge. This seems like
a simple fix. Not sure why it does not qualify as a fix for
7.1 instead.

Thanks
Vivek
