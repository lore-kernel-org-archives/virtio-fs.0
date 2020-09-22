Date: Tue, 22 Sep 2020 16:08:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200922200840.GF57620@redhat.com>
References: <20200916161737.38028-1-vgoyal@redhat.com>
	<20200916161737.38028-5-vgoyal@redhat.com>
	<CAJfpegsncAteUfTAHAttwyVQmhGoK7FCeO_z+xcB_4QkYZEzsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsncAteUfTAHAttwyVQmhGoK7FCeO_z+xcB_4QkYZEzsQ@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v2 4/6] fuse: Kill suid/sgid using ATTR_MODE
 if it is not truncate
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>

On Tue, Sep 22, 2020 at 03:56:47PM +0200, Miklos Szeredi wrote:
> On Wed, Sep 16, 2020 at 6:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > But if this is non-truncate setattr then server will not kill suid/sgid.
> > So continue to send ATTR_MODE to kill suid/sgid for non-truncate setattr,
> > even if ->handle_killpriv_v2 is enabled.
> 
> Sending ATTR_MODE doesn't make sense, since that is racy.   The
> refresh-recalculate makes the race window narrower, but it doesn't
> eliminate it.

Hi Miklos,

Agreed that it does not eliminate that race.

> 
> I think I suggested sending write synchronously if suid/sgid/caps are
> set.  Do you see a problem with this?

Sorry, I might have missed it. So you are saying that for the case of
->writeback_cache, force a synchronous WRITE if suid/sgid is set. But
this will only work if client sees the suid/sgid bits. If client B
set the suid/sgid which client A does not see then all the WRITEs
will be cached in client A and not clear suid/sgid bits.

Also another problem is that if client sees suid/sgid and we make
WRITE synchronous, client's suid/sgid attrs are still cached till
next refresh (both for ->writeback_cache and non writeback_cache
case). So server is clearing suid/sgid bits but client still
keeps them cached. I hope none of the code paths end up using
this stale value and refresh attrs before using suid/sgid.

Shall we refresh attrs after WRITE if suid/sgid is set and client
expects it to clear after WRITE finishes to solve this problem. Or
this is something which is actually not a real problem and I am
overdesigning.

Thanks
Vivek

> 
> Does this affect anything other than cached writes?
> 
> Thanks,
> Miklos
> 

