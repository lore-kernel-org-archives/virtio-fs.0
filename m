Return-Path: <hreitz@redhat.com>
Message-ID: <aca54f19-1c95-01b6-5c5d-bfcee7942c16@redhat.com>
Date: Wed, 15 Mar 2023 16:55:30 +0100
MIME-Version: 1.0
References: <20230313174833.28790-1-hreitz@redhat.com>
 <20230313174833.28790-2-hreitz@redhat.com> <20230315135844.GC6146@fedora>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20230315135844.GC6146@fedora>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [RFC 1/2] vhost-user: Add interface for virtio-fs
 migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, "Dr . David Alan Gilbert" <dgilbert@redhat.com>, Juan Quintela <quintela@redhat.com>

On 15.03.23 14:58, Stefan Hajnoczi wrote:
> On Mon, Mar 13, 2023 at 06:48:32PM +0100, Hanna Czenczek wrote:
>> Add a virtio-fs-specific vhost-user interface to facilitate migrating
>> back-end-internal state.  We plan to migrate the internal state simply
> Luckily the interface does not need to be virtiofs-specific since it
> only transfers opaque data. Any stateful device can use this for
> migration. Please make it generic both at the vhost-user protocol
> message level and at the QEMU vhost API level.

OK, sure.

>> as a binary blob after the streaming phase, so all we need is a way to
>> transfer such a blob from and to the back-end.  We do so by using a
>> dedicated area of shared memory through which the blob is transferred in
>> chunks.
> Keeping the migration data transfer separate from the vhost-user UNIX
> domain socket is a good idea since the amount of data could be large and
> may congest the UNIX domain socket. The shared memory interface solves
> this.
>
> Where I get lost is why it needs to be shared memory instead of simply
> an fd? On the source, the front-end could read the fd until EOF and
> transfer the opaque data. On the destination, the front-end could write
> to the fd and then close it. I think that would be simpler than the
> shared memory interface and could potentially support zero-copy via
> splice(2) (QEMU doesn't need to look at the data being transferred!).
>
> Here is an outline of an fd-based interface:
>
> - SET_DEVICE_STATE_FD: The front-end passes a file descriptor for
>    transferring device state.
>
>    The @direction argument:
>    - SAVE: the back-end transfers an outgoing device state over the fd.
>    - LOAD: the back-end transfers an incoming device state over the fd.
>
>    The @phase argument:
>    - STOPPED: the device is stopped.
>    - PRE_COPY: reserved for future use.
>    - POST_COPY: reserved for future use.
>
>    The back-end transfers data over the fd according to @direction and
>    @phase upon receiving the SET_DEVICE_STATE_FD message.
>
> There are loose ends like how the message interacts with the virtqueue
> enabled state, what happens if multiple SET_DEVICE_STATE_FD messages are
> sent, etc. I have ignored them for now.
>
> What I wanted to mention about the fd-based interface is:
>
> - It's just one message. The I/O activity happens via the fd and does
>    not involve GET_STATE/SET_STATE messages over the vhost-user domain
>    socket.
>
> - Buffer management is up to the front-end and back-end implementations
>    and a bit simpler than the shared memory interface.
>
> Did you choose the shared memory approach because it has certain
> advantages?

I simply chose it because I didn’t think of anything else. :)

Using just an FD for a pipe-like interface sounds perfect to me.  I 
expect that to make the code simpler and, as you point out, it’s just 
better in general.  Thanks!

>> This patch adds the following vhost operations (and implements them for
>> vhost-user):
>>
>> - FS_SET_STATE_FD: The front-end passes a dedicated shared memory area
>>    to the back-end.  This area will be used to transfer state via the
>>    other two operations.
>>    (After the transfer FS_SET_STATE_FD detaches the shared memory area
>>    again.)
>>
>> - FS_GET_STATE: The front-end asks the back-end to place a chunk of
>>    internal state into the shared memory area.
>>
>> - FS_SET_STATE: The front-end puts a chunk of internal state into the
>>    shared memory area, and asks the back-end to fetch it.
>>
>> On the source side, the back-end is expected to serialize its internal
>> state either when FS_SET_STATE_FD is invoked, or when FS_GET_STATE is
>> invoked the first time.  On subsequent FS_GET_STATE calls, it memcpy()s
>> parts of that serialized state into the shared memory area.
>>
>> On the destination side, the back-end is expected to collect the state
>> blob over all FS_SET_STATE calls, and then deserialize and apply it once
>> FS_SET_STATE_FD detaches the shared memory area.
> What is the rationale for waiting to receive the entire incoming state
> before parsing it rather than parsing it in a streaming fashion? Can
> this be left as an implementation detail of the vhost-user back-end so
> that there's freedom in choosing either approach?

The rationale was that when using the shared memory approach, you need 
to specify the offset into the state of the chunk that you’re currently 
transferring.  So to allow streaming, you’d need to make the front-end 
transfer the chunks in a streaming fashion, so that these offsets are 
continuously increasing.  Definitely possible, and reasonable, I just 
thought it’d be easier not to define it at this point and just state 
that decoding at the end is always safe.

When using a pipe/splicing, however, that won’t be a concern anymore, so 
yes, then we can definitely allow the back-end to decode its state while 
it’s still being received.

Hanna

