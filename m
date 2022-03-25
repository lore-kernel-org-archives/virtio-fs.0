Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=sOUpY/EapMKYF+sT0H3JOqf2ZvI3rojAIIMf7SStj1A=; b=D
 Tm0rKLC7hHWQ8Lp7zxgkuQEIH0o3YfnpcDJ+NO23iISQD2XFi8IMJ4pXAiZjYbRv
 xjlajdAhxfcHelCri1P3U834dj1zYSGMjUARtqFMP+omGm6pzbbsly8BRUZ9GSc3
 Mj07kWzWZVqqb8bDtwF+Qam6TaYrWqYrkogEbShFwTnHhDwGbWpvmbaVBUFTXwcD
 Kc2gF/2q89aEy/PpN+c2bhfO3XyNr84GWNSykFeNWzAG/rAXOZ5kJT8pl0xBJrU0
 uU03I8UVW08yyOcb0Y4k6crVI1H/QRNmOv/5H7hQ7COmLsbOPfsgzlS/Urxz5/pi
 qA9RB6+RjPc/Akul9vYTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=sOUpY/EapMKYF+sT0H3JOqf2ZvI3r
 ojAIIMf7SStj1A=; b=SBVj526BXhBLBKuoeekRVr3y5zam02kB82ep3K7RhcP6A
 FJar8jDzGqHw7sra30Tva3fjQa9Gy5+zXDx0gG5EY1CEKwb3rcfi1lEKaC9PFYPq
 mW2rGFrHDjv7a+7bP0JKUCA2ijl38SEogw0D+Xr9Je/GRz+0ba++UbVa2sengCRw
 C5LrcU9DVuPewsy3Oo0P8g4lbW53xscb12atka8B4unAY8sw/rzdjLbirO+qWY4t
 PEF65BbMa8FA/hyTHf5i/woZJgKOXMgoxt8auR8oEjP2lEb4DVJQr0nima08mZyb
 BQAuHmT4P116N3DDnv8+JMAsKAV1Pvr0Fv0EIpkNw==
From: virtiofs-bot@sinrega.org
Message-Id: <13216.122032516062700427@us-mta-424.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 25 Mar 2022 20:06:49 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: [RFC] What are various modes
 to run virtiofsd and what options are needed
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hi All,

Recently I started looking into various sandboxing options we currently have and in what kind of circumstances these are useful. I feel that "user namespace" support requires more work. And then there are some gaps w.r.t when setgroups() should be called and when can it be avoided. Also, we might have to consider adding sandbox=pivot_root.

Before we make any changes, I think it is a good idea to have an understanding of what are the requirements. In what different modes people are looking to run virtiofsd. Because that will determine how should we design our options.

So here is a summary of what I am thinking.

There seem to be primarily two top level use cases.

A. Virtiofsd sets up namespaces and calls pivot_root()/chroot() to avoid break out of shared dir.
B. Caller setsup namespaces as needed and virtiofsd calls pivot_root()/chroot() to lock it down to a particular dir.

Setting up namespaces and all other stuff (pivot_root()/chroot()/setgroups()) is
tricky and there are bunch of dependencies. So for normal users I will expect that they will in general use option A, and leave it to virtiofsd. But some advanced users might resort to option B and in that case we should probably document best practices.

Now let us look at sub categories of above top level use cases.

Virtiofsd sets up sandboxing
=============================
A. virtiofsd is run as "root" (With CAP_SYS_ADMIN).
   This is the most widely used mode. --sandbox=NAMESPACE is implied. virtiosfd uses mount, pid and network namespaces. Calls pivot_root() to lock itself down to a dir. And it also calls setgroups() to drop supplementary group membership. I think this all works and we don't need to do anything.

B. virtiofsd is run as unprivileged user (single uid/gid mapping)
   This is the case where caller's uid is mapped 1:1 into user namespace. And inside VM user can access the files. --sandbox=NAMESPACE should be used. pivot_root() should be called. As of now no mappings are being setup. May be we
can set 1:1 mappings by default. And if somebody needs more complex mappings,
add an option later for that. 

C. virtiofsd is run as unprivileged user (multiple uid/gid mappings)

    This is the case where we want to run virtiofsd unprivileged and also want
    to be able to map mulitple uid/gids so that we can do arbitrary uid/gid
    switching. This is an important mode because this is the direction we are
    moving in and want to run virtiofsd unprivileged where possible.

    But there are no options to allow user to specify uid map or gid
    map to setup. I think we need to add new options say --uid-map or --gid-map
    so that caller can specify the mappings. And virtiofsd will use 
    newuidmap/newgidmap privileged binaries to setup those mappings.

    This should default to --sandbox=NAMESPACE and will call pivot_root() and
     setgroups() as well.

External tools setup virtiofsd sandboxing
==========================================
I am assuming that this just means that tools have setup namespaces as needed but virtiofsd still need to do pivot_root()/chroot() to lock itself into shared dir. As of now one of the examples recommended use of "chroot()". I am wondering why that is the case. Can't we add an option say --sandbox=pivot_root and still be able to call pivot_root(shared_dir). I think if this works, we should think of adding an option and suggest users use that.

Given sandboxing will be done by external tools, they don't have to use --sandbox=NAMESPACE. And --sandbox=chroot/pivot_root should be good.

What about setgroups(). If external tools are only mapping caller's uid/gid into user namespace (and not a range), then it is likely they don't have CAP_SETGID to being with. So setgroups() will not be allowed inside sandbox and virtiofsd will fail. 

May be we should add an option "--no-fail-setgroups". This will tell virtiofsd to try setgroups() but not fail. And document this can be used only if one uid/gid is mapped in user namespace. If multiple mappings are present, then caller must setup namespace using newuidmap/newgidmap and allow setgroups().

What about sandbox=NONE
========================
Well, this baffles. I would think that this probably should be a debug aid and nobody should be using it in practice. Are there any real use cases for this option?

Any comments are welcome. Just want to make sure that major use cases are covered here and then we can add appropriate options accordingly and document it.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/43

