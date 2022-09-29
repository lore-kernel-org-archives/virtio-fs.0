Return-Path: <vgoyal@redhat.com>
Date: Thu, 29 Sep 2022 10:10:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YzWnPZ5Y6ivS8e1v@redhat.com>
References: <4362261a-c762-4666-84e2-03c9daa6c4d9@www.fastmail.com>
 <YzMmu3xfOtQwuFUx@redhat.com> <YzMrYAJQeSP2hDSs@redhat.com>
 <CAJh=p+5rQDBJJC8VNGL10KYgDeq-Hg5WK7avONCti03eJGH+ow@mail.gmail.com>
 <798fe353-9537-44fe-a76a-819e8c93abb5@www.fastmail.com>
 <YzNZnPiUqySu6sGh@fedora>
 <20220928083340.eyizwu6mm3cc3bxu@mhamilton>
 <YzSgeDdpHOw1hTM0@redhat.com>
 <b963f623-aa85-4285-9bfa-5fcb4744c354@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b963f623-aa85-4285-9bfa-5fcb4744c354@app.fastmail.com>
Subject: Re: [Virtio-fs] virtiofsd: Any reason why there's not an "openat2"
 sandbox mode?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Colin Walters <walters@verbum.org>
Cc: Sergio Lopez <slp@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Thu, Sep 29, 2022 at 10:04:36AM -0400, Colin Walters wrote:
> On Wed, Sep 28, 2022, at 3:28 PM, Vivek Goyal wrote:
> 
> > Sounds reasonable. In fact, we could probably do someting similar
> > for "landlock" as well. 
> 
> Thanks for the discussion all!  Can someone (vaguely) commit to look into this in say the next few months?  It's not *urgent*, we can live with the 9p flakes and problems short term, just trying to figure out if this needs to be on our medium-term radar or not.  Thanks!

Hi Colin,

What's your use case. How do you plan to use virtiofs.

Thanks
Vivek
