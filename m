References: <20210609155551.44437-1-mreitz@redhat.com>
	<20210611191925.GA767764@redhat.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <ddc46d6a-70c0-5d5e-c704-514be7a3c014@redhat.com>
Date: Wed, 16 Jun 2021 15:41:36 +0200
MIME-Version: 1.0
In-Reply-To: <20210611191925.GA767764@redhat.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v2 0/9] virtiofsd: Allow using file handles
 instead of O_PATH FDs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On 11.06.21 21:19, Vivek Goyal wrote:
> On Wed, Jun 09, 2021 at 05:55:42PM +0200, Max Reitz wrote:
>> Hi,
>>
>> v1 cover letter for an overview:
>> https://listman.redhat.com/archives/virtio-fs/2021-June/msg00033.html
> Hi Max,
>
> What's the impact of these patches on performance? Just trying to
> get some idea what to expect. Performance remains more or less
> same or we expect a hit.
I definitely expect a hit if you just benchmark the right way. Having to 
open FDs all the time (for metadata operations) will have an impact 
(when you do lookups all the time, or open files and close them 
immediately). How much of an impact, that’s completely up to the 
filesystem’s open_by_handle_at() implementation, I presume.

I don’t expect it to be significant for real-world use cases, though. 
When really doing I/O, there should be absolutely no difference, because 
then we’re operating with these FUSE handles that have actual (non-path) 
FDs attached to them.

Max

