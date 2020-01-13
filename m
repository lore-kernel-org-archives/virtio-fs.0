From: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Date: Mon, 13 Jan 2020 07:55:07 +0000
Message-ID: <4dcf854ab5133f4bc77191bd3f49aa8e9a96c57d.camel@intel.com>
References: <20200110190347.GA3855@work-vm>
In-Reply-To: <20200110190347.GA3855@work-vm>
Content-Language: en-US
Content-ID: <15A67E48BA56684E9DB5D7A2E38CCAEC@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Changes in -dev branch
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "dgilbert@redhat.com" <dgilbert@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>

Hi Dave,

On Fri, 2020-01-10 at 19:03 +0000, Dr. David Alan Gilbert wrote:
> Hi,
>    I've just pushed a new version of the virtio-fs-dev branch in
>  https://gitlab.com/virtio-fs/qemu
>  
> some things to note:
> 
>   a) The old '-o vhost_user_socket' syntax has now been replaced
>      by the syntax matching qemu's standardised vhost-user interface
>      which is;
> 
>      ./virtiofsd --socket-path=/path/whereever

I was expecting that "./virtiofsd --socket-path /path/whereever" would
work too, but it doesn't. Is this the expected behavior?

Just asking cause it feels weird that we must add "=" here.

Thanks,
Sebastien

> 
>   b) It's got about 64 of the main patches reviewed by Daniel
> Berrangé
>      - about another 40 that need reviewing; please leap in
>      and review any patches on the qemu-devel thread for any patches
>      that are missing reviews.
> 
>   c) The set that I've just pushed has fixes for all the things
>      Daniel spotted; so there's a bunch of mostly minor changes.
> 
>   d) It's also got patches that were received on list since
>      mid December.
> 
> Dave
> 
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
> 
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

