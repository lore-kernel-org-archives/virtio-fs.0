Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1663581330; x=1663667730; bh=Hrq6GaUgvsPF05mJgh/C0
 sJpIEeniFnVmEtPGCV8PXg=; b=OPg8D2YPFGtZBLyC1J3r4Yd/JPEAPrx2rXtx0
 m8dXbOjbchH+IDB3gLfzBo0wS66T13Wce2SlUQqLHv4/7Fh02NoVA1vjil6Sii9w
 k2HG+c5NxaqIS6bMSS2u4c4r0/dpXl9veMiWafcPoCvdD0huWM0hX/1h72zROfKb
 SUDfFgBUrDF5WgkAUNddi5sXFdW+YgTN8zZRA+d2DEHdNlcuBJ6K6nqhEtWd4MnM
 3JUMZWcWYRea5LCc2nXUX+wgNEZxL/z593m0Az9DASKfxqlnBoiFDqUb4eQrJndL
 C95PB+k6kPxHRPoYtDh9ItDDKwmJHzQLv3OckutEb16Qpr82w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1663581330; x=1663667730; bh=Hrq6GaUgvsPF05mJgh/C0sJpIEeniFnVmEt
 PGCV8PXg=; b=q83j+mg7NFcJ/h5crwzjcCZ8NCu2py54thO714O4k3l5OmevF28
 9pjlv3blNCq/E95btV+ExjUicxGAZD+/+7IU/Zl7CdiQbwEZahwXeIidW29n/qbd
 aeYbugANKrVcvRWr2+kVMvwiiLi40oUBTosQxOG0GleQPELIVUfTPzh3A+KyxRVE
 G6quammigdGtvg5B2fT24My8Ok/FJSurTeM36W06DiY/tzeFh3KGNBviCIAQkLS6
 T9bETtSS2TS5ga5pLIj+GLpcD2BMqFeKGKSAFJQHhh/BaMPLtY6onT48AGdSPyZB
 3RB0WC1jwC0I8N2QmYi3zZerMxI4x1AoFPQ==
From: virtiofs-bot@sinrega.org
Message-Id: <16869.122091905553100235@us-mta-167.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 19 Sep 2022 09:55:34 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: descript_utils: Remove
 unnecessary deref
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Removes a dereferencing expression which is covered by auto-deref.
The next version of clippy is going to complain about this kind of
unnecessary deref expressions.

Signed-off-by: German Maglione <gmaglione@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/138

