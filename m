Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
In-Reply-To: <f37db85a-b0aa-b34a-7d5a-b1ab650f1683@yandex-team.ru> (Vladimir
 Sementsov-Ogievskiy's message of "Tue, 31 Jan 2023 11:33:22 +0300")
References: <20230130080608.2100-1-quintela@redhat.com>
 <f37db85a-b0aa-b34a-7d5a-b1ab650f1683@yandex-team.ru>
Reply-To: quintela@redhat.com
Date: Thu, 02 Feb 2023 11:12:45 +0100
Message-ID: <87v8kktlya.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [Virtio-fs] [PATCH v3] migration: Remove res_compatible
 parameter
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Cc: qemu-devel@nongnu.org, Jason Wang <jasowang@redhat.com>, qemu-arm@nongnu.org, Hanna Reitz <hreitz@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, Eric Blake <eblake@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, Fam Zheng <fam@euphon.net>, David Hildenbrand <david@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, John Snow <jsnow@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Eric Farman <farman@linux.ibm.com>, qemu-s390x@nongnu.org, Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Laurent Vivier <lvivier@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Gerd Hoffmann <kraxel@redhat.com>, Thomas Huth <thuth@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, Eduardo Habkost <eduardo@habkost.net>, Klaus Jensen <its@irrelevant.dk>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Laurent Vivier <laurent@vivier.eu>, Xiaojuan Yang <yangxiaojuan@loongson.cn>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Keith Busch <kbusch@kernel.org>, Thomas Huth <huth@tuxfamily.org>, Song Gao <gaosong@loongson.cn>, Richard Henderson <richard.henderson@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, qemu-trivial@nongnu.org, virtio-fs@redhat.com

Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru> wrote:
> On 1/30/23 11:06, Juan Quintela wrote:
>> It was only used for RAM, and in that case, it means that this amount
>> of data was sent for memory.  Just delete the field in all callers.
>
> Could you describe, why it's safe to change the behavior for RAM?

I will start for the change in migration.c

-    uint64_t pend_pre, pend_compat, pend_post;
+    uint64_t pend_pre, pend_post;
     bool in_postcopy = s->state == MIGRATION_STATUS_POSTCOPY_ACTIVE;
 
-    qemu_savevm_state_pending_estimate(&pend_pre, &pend_compat, &pend_post);
-    uint64_t pending_size = pend_pre + pend_compat + pend_post;

Here we add the three to pending_size, so it don't matter.

+    qemu_savevm_state_pending_estimate(&pend_pre, &pend_post);
+    uint64_t pending_size = pend_pre + pend_post;
 
-    trace_migrate_pending_estimate(pending_size,
-                                   pend_pre, pend_compat, pend_post);
+    trace_migrate_pending_estimate(pending_size, pend_pre, pend_post);

Trace, we don't care again.

-    if (pend_pre + pend_compat <= s->threshold_size) {

We do the test on pend_pre + pend_compat.
So, the only place where we are using pend_compat alone is on trace
messages.

I guess we can agree that changing trace messages don't matter.


-        qemu_savevm_state_pending_exact(&pend_pre, &pend_compat, &pend_post);
-        pending_size = pend_pre + pend_compat + pend_post;
-        trace_migrate_pending_exact(pending_size,
-                                    pend_pre, pend_compat, pend_post);
+    if (pend_pre <= s->threshold_size) {
+        qemu_savevm_state_pending_exact(&pend_pre, &pend_post);
+        pending_size = pend_pre + pend_post;
+        trace_migrate_pending_exact(pending_size, pend_pre, pend_post);


Ok, Now go to ram.c changes:

The only change that we do is that if we are on postcopy, we add the

@@ -3448,9 +3444,9 @@ static void ram_state_pending_exact(void *opaque,
 
     if (migrate_postcopy_ram()) {
         /* We can do postcopy, and all the data is postcopiable */
-        *res_compatible += remaining_size;
+        *res_postcopy += remaining_size;
     } else {
-        *res_precopy_only += remaining_size;
+        *res_precopy += remaining_size;
     }
 }

The only use of res_compatible was when we were on postocpy, nothing
else sets it.

But when we are on postcopy, we can send that pages trough postcopy, so
we add them there and if we are on precopy, res_compatible was already zero.

So I think that is ok, i.e. no behaviour change.

What do you think?

> Also, I think it would be a lot better to split the change for RAM
> (s/res_compatible/res_postcopy) in one patch, and then drop the
> totally unused res_compatible file in the second patch

Ok, will do for next version.

Later, Juan.

