From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 17 Jun 2021 14:12:06 -0400
Message-Id: <20210617181213.1177835-2-vgoyal@redhat.com>
In-Reply-To: <20210617181213.1177835-1-vgoyal@redhat.com>
References: <20210617181213.1177835-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v6 1/8] linux-headers: Update linux headers to
	5.13.0-rc6
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, vgoyal@redhat.com, miklos@szeredi.hu

Update linux kernel headers for version 5.13.0-rc6

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.h   |  35 -
 include/standard-headers/drm/drm_fourcc.h     |  23 +-
 include/standard-headers/linux/ethtool.h      | 109 ++-
 include/standard-headers/linux/fuse.h         |  17 +-
 .../linux/input-event-codes.h                 |   1 +
 include/standard-headers/linux/input.h        |   2 +-
 include/standard-headers/linux/virtio_ids.h   |   2 +
 .../standard-headers/rdma/vmw_pvrdma-abi.h    |   7 +
 linux-headers/asm-generic/unistd.h            |  13 +-
 linux-headers/asm-mips/unistd_n32.h           | 751 +++++++--------
 linux-headers/asm-mips/unistd_n64.h           | 703 +++++++-------
 linux-headers/asm-mips/unistd_o32.h           | 843 ++++++++---------
 linux-headers/asm-powerpc/kvm.h               |   2 +
 linux-headers/asm-powerpc/unistd_32.h         | 856 +++++++++---------
 linux-headers/asm-powerpc/unistd_64.h         | 800 ++++++++--------
 linux-headers/asm-s390/unistd_32.h            |   4 +
 linux-headers/asm-s390/unistd_64.h            |   4 +
 linux-headers/asm-x86/kvm.h                   |   3 +
 linux-headers/asm-x86/unistd_32.h             |   4 +
 linux-headers/asm-x86/unistd_64.h             |   4 +
 linux-headers/asm-x86/unistd_x32.h            |   4 +
 linux-headers/linux/kvm.h                     | 131 ++-
 linux-headers/linux/userfaultfd.h             |  36 +-
 linux-headers/linux/vfio.h                    |  35 +
 24 files changed, 2343 insertions(+), 2046 deletions(-)

diff --git a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
index 1677208a41..94d41b202c 100644
--- a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
+++ b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
@@ -70,30 +70,6 @@ enum pvrdma_mtu {
 	PVRDMA_MTU_4096 = 5,
 };
 
-static inline int pvrdma_mtu_enum_to_int(enum pvrdma_mtu mtu)
-{
-	switch (mtu) {
-	case PVRDMA_MTU_256:	return  256;
-	case PVRDMA_MTU_512:	return  512;
-	case PVRDMA_MTU_1024:	return 1024;
-	case PVRDMA_MTU_2048:	return 2048;
-	case PVRDMA_MTU_4096:	return 4096;
-	default:		return   -1;
-	}
-}
-
-static inline enum pvrdma_mtu pvrdma_mtu_int_to_enum(int mtu)
-{
-	switch (mtu) {
-	case 256:	return PVRDMA_MTU_256;
-	case 512:	return PVRDMA_MTU_512;
-	case 1024:	return PVRDMA_MTU_1024;
-	case 2048:	return PVRDMA_MTU_2048;
-	case 4096:
-	default:	return PVRDMA_MTU_4096;
-	}
-}
-
 enum pvrdma_port_state {
 	PVRDMA_PORT_NOP			= 0,
 	PVRDMA_PORT_DOWN		= 1,
@@ -138,17 +114,6 @@ enum pvrdma_port_width {
 	PVRDMA_WIDTH_12X	= 8,
 };
 
-static inline int pvrdma_width_enum_to_int(enum pvrdma_port_width width)
-{
-	switch (width) {
-	case PVRDMA_WIDTH_1X:	return  1;
-	case PVRDMA_WIDTH_4X:	return  4;
-	case PVRDMA_WIDTH_8X:	return  8;
-	case PVRDMA_WIDTH_12X:	return 12;
-	default:		return -1;
-	}
-}
-
 enum pvrdma_port_speed {
 	PVRDMA_SPEED_SDR	= 1,
 	PVRDMA_SPEED_DDR	= 2,
diff --git a/include/standard-headers/drm/drm_fourcc.h b/include/standard-headers/drm/drm_fourcc.h
index c47e19810c..a61ae520c2 100644
--- a/include/standard-headers/drm/drm_fourcc.h
+++ b/include/standard-headers/drm/drm_fourcc.h
@@ -526,6 +526,25 @@ extern "C" {
  */
 #define I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS fourcc_mod_code(INTEL, 7)
 
+/*
+ * Intel Color Control Surface with Clear Color (CCS) for Gen-12 render
+ * compression.
+ *
+ * The main surface is Y-tiled and is at plane index 0 whereas CCS is linear
+ * and at index 1. The clear color is stored at index 2, and the pitch should
+ * be ignored. The clear color structure is 256 bits. The first 128 bits
+ * represents Raw Clear Color Red, Green, Blue and Alpha color each represented
+ * by 32 bits. The raw clear color is consumed by the 3d engine and generates
+ * the converted clear color of size 64 bits. The first 32 bits store the Lower
+ * Converted Clear Color value and the next 32 bits store the Higher Converted
+ * Clear Color value when applicable. The Converted Clear Color values are
+ * consumed by the DE. The last 64 bits are used to store Color Discard Enable
+ * and Depth Clear Value Valid which are ignored by the DE. A CCS cache line
+ * corresponds to an area of 4x1 tiles in the main surface. The main surface
+ * pitch is required to be a multiple of 4 tile widths.
+ */
+#define I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS_CC fourcc_mod_code(INTEL, 8)
+
 /*
  * Tiled, NV12MT, grouped in 64 (pixels) x 32 (lines) -sized macroblocks
  *
@@ -1035,9 +1054,9 @@ drm_fourcc_canonicalize_nvidia_format_mod(uint64_t modifier)
  * Not all combinations are valid, and different SoCs may support different
  * combinations of layout and options.
  */
-#define __fourcc_mod_amlogic_layout_mask 0xf
+#define __fourcc_mod_amlogic_layout_mask 0xff
 #define __fourcc_mod_amlogic_options_shift 8
-#define __fourcc_mod_amlogic_options_mask 0xf
+#define __fourcc_mod_amlogic_options_mask 0xff
 
 #define DRM_FORMAT_MOD_AMLOGIC_FBC(__layout, __options) \
 	fourcc_mod_code(AMLOGIC, \
diff --git a/include/standard-headers/linux/ethtool.h b/include/standard-headers/linux/ethtool.h
index 8bfd01d230..218d944a17 100644
--- a/include/standard-headers/linux/ethtool.h
+++ b/include/standard-headers/linux/ethtool.h
@@ -26,6 +26,14 @@
  * have the same layout for 32-bit and 64-bit userland.
  */
 
+/* Note on reserved space.
+ * Reserved fields must not be accessed directly by user space because
+ * they may be replaced by a different field in the future. They must
+ * be initialized to zero before making the request, e.g. via memset
+ * of the entire structure or implicitly by not being set in a structure
+ * initializer.
+ */
+
 /**
  * struct ethtool_cmd - DEPRECATED, link control and status
  * This structure is DEPRECATED, please use struct ethtool_link_settings.
@@ -67,6 +75,7 @@
  *	and other link features that the link partner advertised
  *	through autonegotiation; 0 if unknown or not applicable.
  *	Read-only.
+ * @reserved: Reserved for future use; see the note on reserved space.
  *
  * The link speed in Mbps is split between @speed and @speed_hi.  Use
  * the ethtool_cmd_speed() and ethtool_cmd_speed_set() functions to
@@ -155,6 +164,7 @@ static inline uint32_t ethtool_cmd_speed(const struct ethtool_cmd *ep)
  * @bus_info: Device bus address.  This should match the dev_name()
  *	string for the underlying bus device, if there is one.  May be
  *	an empty string.
+ * @reserved2: Reserved for future use; see the note on reserved space.
  * @n_priv_flags: Number of flags valid for %ETHTOOL_GPFLAGS and
  *	%ETHTOOL_SPFLAGS commands; also the number of strings in the
  *	%ETH_SS_PRIV_FLAGS set
@@ -356,6 +366,7 @@ struct ethtool_eeprom {
  * @tx_lpi_timer: Time in microseconds the interface delays prior to asserting
  *	its tx lpi (after reaching 'idle' state). Effective only when eee
  *	was negotiated and tx_lpi_enabled was set.
+ * @reserved: Reserved for future use; see the note on reserved space.
  */
 struct ethtool_eee {
 	uint32_t	cmd;
@@ -374,6 +385,7 @@ struct ethtool_eee {
  * @cmd: %ETHTOOL_GMODULEINFO
  * @type: Standard the module information conforms to %ETH_MODULE_SFF_xxxx
  * @eeprom_len: Length of the eeprom
+ * @reserved: Reserved for future use; see the note on reserved space.
  *
  * This structure is used to return the information to
  * properly size memory for a subsequent call to %ETHTOOL_GMODULEEEPROM.
@@ -579,9 +591,7 @@ struct ethtool_pauseparam {
 	uint32_t	tx_pause;
 };
 
-/**
- * enum ethtool_link_ext_state - link extended state
- */
+/* Link extended state */
 enum ethtool_link_ext_state {
 	ETHTOOL_LINK_EXT_STATE_AUTONEG,
 	ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
@@ -595,10 +605,7 @@ enum ethtool_link_ext_state {
 	ETHTOOL_LINK_EXT_STATE_OVERHEAT,
 };
 
-/**
- * enum ethtool_link_ext_substate_autoneg - more information in addition to
- * ETHTOOL_LINK_EXT_STATE_AUTONEG.
- */
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_AUTONEG. */
 enum ethtool_link_ext_substate_autoneg {
 	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED = 1,
 	ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED,
@@ -608,9 +615,7 @@ enum ethtool_link_ext_substate_autoneg {
 	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD,
 };
 
-/**
- * enum ethtool_link_ext_substate_link_training - more information in addition to
- * ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE.
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE.
  */
 enum ethtool_link_ext_substate_link_training {
 	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED = 1,
@@ -619,9 +624,7 @@ enum ethtool_link_ext_substate_link_training {
 	ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT,
 };
 
-/**
- * enum ethtool_link_ext_substate_logical_mismatch - more information in addition
- * to ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH.
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH.
  */
 enum ethtool_link_ext_substate_link_logical_mismatch {
 	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK = 1,
@@ -631,19 +634,14 @@ enum ethtool_link_ext_substate_link_logical_mismatch {
 	ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED,
 };
 
-/**
- * enum ethtool_link_ext_substate_bad_signal_integrity - more information in
- * addition to ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY.
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY.
  */
 enum ethtool_link_ext_substate_bad_signal_integrity {
 	ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS = 1,
 	ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
 };
 
-/**
- * enum ethtool_link_ext_substate_cable_issue - more information in
- * addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE.
- */
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE. */
 enum ethtool_link_ext_substate_cable_issue {
 	ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE = 1,
 	ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE,
@@ -661,6 +659,7 @@ enum ethtool_link_ext_substate_cable_issue {
  *	now deprecated
  * @ETH_SS_FEATURES: Device feature names
  * @ETH_SS_RSS_HASH_FUNCS: RSS hush function names
+ * @ETH_SS_TUNABLES: tunable names
  * @ETH_SS_PHY_STATS: Statistic names, for use with %ETHTOOL_GPHYSTATS
  * @ETH_SS_PHY_TUNABLES: PHY tunable names
  * @ETH_SS_LINK_MODES: link mode names
@@ -670,6 +669,13 @@ enum ethtool_link_ext_substate_cable_issue {
  * @ETH_SS_TS_TX_TYPES: timestamping Tx types
  * @ETH_SS_TS_RX_FILTERS: timestamping Rx filters
  * @ETH_SS_UDP_TUNNEL_TYPES: UDP tunnel types
+ * @ETH_SS_STATS_STD: standardized stats
+ * @ETH_SS_STATS_ETH_PHY: names of IEEE 802.3 PHY statistics
+ * @ETH_SS_STATS_ETH_MAC: names of IEEE 802.3 MAC statistics
+ * @ETH_SS_STATS_ETH_CTRL: names of IEEE 802.3 MAC Control statistics
+ * @ETH_SS_STATS_RMON: names of RMON statistics
+ *
+ * @ETH_SS_COUNT: number of defined string sets
  */
 enum ethtool_stringset {
 	ETH_SS_TEST		= 0,
@@ -688,6 +694,11 @@ enum ethtool_stringset {
 	ETH_SS_TS_TX_TYPES,
 	ETH_SS_TS_RX_FILTERS,
 	ETH_SS_UDP_TUNNEL_TYPES,
+	ETH_SS_STATS_STD,
+	ETH_SS_STATS_ETH_PHY,
+	ETH_SS_STATS_ETH_MAC,
+	ETH_SS_STATS_ETH_CTRL,
+	ETH_SS_STATS_RMON,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
@@ -715,6 +726,7 @@ struct ethtool_gstrings {
 /**
  * struct ethtool_sset_info - string set information
  * @cmd: Command number = %ETHTOOL_GSSET_INFO
+ * @reserved: Reserved for future use; see the note on reserved space.
  * @sset_mask: On entry, a bitmask of string sets to query, with bits
  *	numbered according to &enum ethtool_stringset.  On return, a
  *	bitmask of those string sets queried that are supported.
@@ -759,6 +771,7 @@ enum ethtool_test_flags {
  * @flags: A bitmask of flags from &enum ethtool_test_flags.  Some
  *	flags may be set by the user on entry; others may be set by
  *	the driver on return.
+ * @reserved: Reserved for future use; see the note on reserved space.
  * @len: On return, the number of test results
  * @data: Array of test results
  *
@@ -959,6 +972,7 @@ union ethtool_flow_union {
  * @vlan_etype: VLAN EtherType
  * @vlan_tci: VLAN tag control information
  * @data: user defined data
+ * @padding: Reserved for future use; see the note on reserved space.
  *
  * Note, @vlan_etype, @vlan_tci, and @data are only valid if %FLOW_EXT
  * is set in &struct ethtool_rx_flow_spec @flow_type.
@@ -1134,7 +1148,8 @@ struct ethtool_rxfh_indir {
  *	hardware hash key.
  * @hfunc: Defines the current RSS hash function used by HW (or to be set to).
  *	Valid values are one of the %ETH_RSS_HASH_*.
- * @rsvd:	Reserved for future extensions.
+ * @rsvd8: Reserved for future use; see the note on reserved space.
+ * @rsvd32: Reserved for future use; see the note on reserved space.
  * @rss_config: RX ring/queue index for each hash value i.e., indirection table
  *	of @indir_size uint32_t elements, followed by hash key of @key_size
  *	bytes.
@@ -1302,7 +1317,9 @@ struct ethtool_sfeatures {
  * @so_timestamping: bit mask of the sum of the supported SO_TIMESTAMPING flags
  * @phc_index: device index of the associated PHC, or -1 if there is none
  * @tx_types: bit mask of the supported hwtstamp_tx_types enumeration values
+ * @tx_reserved: Reserved for future use; see the note on reserved space.
  * @rx_filters: bit mask of the supported hwtstamp_rx_filters enumeration values
+ * @rx_reserved: Reserved for future use; see the note on reserved space.
  *
  * The bits in the 'tx_types' and 'rx_filters' fields correspond to
  * the 'hwtstamp_tx_types' and 'hwtstamp_rx_filters' enumeration values,
@@ -1376,15 +1393,33 @@ struct ethtool_per_queue_op {
 };
 
 /**
- * struct ethtool_fecparam - Ethernet forward error correction(fec) parameters
+ * struct ethtool_fecparam - Ethernet Forward Error Correction parameters
  * @cmd: Command number = %ETHTOOL_GFECPARAM or %ETHTOOL_SFECPARAM
- * @active_fec: FEC mode which is active on porte
- * @fec: Bitmask of supported/configured FEC modes
- * @rsvd: Reserved for future extensions. i.e FEC bypass feature.
+ * @active_fec: FEC mode which is active on the port, single bit set, GET only.
+ * @fec: Bitmask of configured FEC modes.
+ * @reserved: Reserved for future extensions, ignore on GET, write 0 for SET.
  *
- * Drivers should reject a non-zero setting of @autoneg when
- * autoneogotiation is disabled (or not supported) for the link.
+ * Note that @reserved was never validated on input and ethtool user space
+ * left it uninitialized when calling SET. Hence going forward it can only be
+ * used to return a value to userspace with GET.
+ *
+ * FEC modes supported by the device can be read via %ETHTOOL_GLINKSETTINGS.
+ * FEC settings are configured by link autonegotiation whenever it's enabled.
+ * With autoneg on %ETHTOOL_GFECPARAM can be used to read the current mode.
+ *
+ * When autoneg is disabled %ETHTOOL_SFECPARAM controls the FEC settings.
+ * It is recommended that drivers only accept a single bit set in @fec.
+ * When multiple bits are set in @fec drivers may pick mode in an implementation
+ * dependent way. Drivers should reject mixing %ETHTOOL_FEC_AUTO_BIT with other
+ * FEC modes, because it's unclear whether in this case other modes constrain
+ * AUTO or are independent choices.
+ * Drivers must reject SET requests if they support none of the requested modes.
+ *
+ * If device does not support FEC drivers may use %ETHTOOL_FEC_NONE instead
+ * of returning %EOPNOTSUPP from %ETHTOOL_GFECPARAM.
  *
+ * See enum ethtool_fec_config_bits for definition of valid bits for both
+ * @fec and @active_fec.
  */
 struct ethtool_fecparam {
 	uint32_t   cmd;
@@ -1396,11 +1431,16 @@ struct ethtool_fecparam {
 
 /**
  * enum ethtool_fec_config_bits - flags definition of ethtool_fec_configuration
- * @ETHTOOL_FEC_NONE: FEC mode configuration is not supported
- * @ETHTOOL_FEC_AUTO: Default/Best FEC mode provided by driver
- * @ETHTOOL_FEC_OFF: No FEC Mode
- * @ETHTOOL_FEC_RS: Reed-Solomon Forward Error Detection mode
- * @ETHTOOL_FEC_BASER: Base-R/Reed-Solomon Forward Error Detection mode
+ * @ETHTOOL_FEC_NONE_BIT: FEC mode configuration is not supported. Should not
+ *			be used together with other bits. GET only.
+ * @ETHTOOL_FEC_AUTO_BIT: Select default/best FEC mode automatically, usually
+ *			based link mode and SFP parameters read from module's
+ *			EEPROM. This bit does _not_ mean autonegotiation.
+ * @ETHTOOL_FEC_OFF_BIT: No FEC Mode
+ * @ETHTOOL_FEC_RS_BIT: Reed-Solomon FEC Mode
+ * @ETHTOOL_FEC_BASER_BIT: Base-R/Reed-Solomon FEC Mode
+ * @ETHTOOL_FEC_LLRS_BIT: Low Latency Reed Solomon FEC Mode (25G/50G Ethernet
+ *			Consortium)
  */
 enum ethtool_fec_config_bits {
 	ETHTOOL_FEC_NONE_BIT,
@@ -1958,6 +1998,11 @@ enum ethtool_reset_flags {
  *	autonegotiation; 0 if unknown or not applicable.  Read-only.
  * @transceiver: Used to distinguish different possible PHY types,
  *	reported consistently by PHYLIB.  Read-only.
+ * @master_slave_cfg: Master/slave port mode.
+ * @master_slave_state: Master/slave port state.
+ * @reserved: Reserved for future use; see the note on reserved space.
+ * @reserved1: Reserved for future use; see the note on reserved space.
+ * @link_mode_masks: Variable length bitmaps.
  *
  * If autonegotiation is disabled, the speed and @duplex represent the
  * fixed link mode and are writable if the driver supports multiple
diff --git a/include/standard-headers/linux/fuse.h b/include/standard-headers/linux/fuse.h
index 950d7edb7e..cce105bfba 100644
--- a/include/standard-headers/linux/fuse.h
+++ b/include/standard-headers/linux/fuse.h
@@ -179,6 +179,8 @@
  *  7.33
  *  - add FUSE_HANDLE_KILLPRIV_V2, FUSE_WRITE_KILL_SUIDGID, FATTR_KILL_SUIDGID
  *  - add FUSE_OPEN_KILL_SUIDGID
+ *  - extend fuse_setxattr_in, add FUSE_SETXATTR_EXT
+ *  - add FUSE_SETXATTR_ACL_KILL_SGID
  */
 
 #ifndef _LINUX_FUSE_H
@@ -326,6 +328,7 @@ struct fuse_file_lock {
  *			does not have CAP_FSETID. Additionally upon
  *			write/truncate sgid is killed only if file has group
  *			execute permission. (Same as Linux VFS behavior).
+ * FUSE_SETXATTR_EXT:	Server supports extended struct fuse_setxattr_in
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -356,6 +359,7 @@ struct fuse_file_lock {
 #define FUSE_MAP_ALIGNMENT	(1 << 26)
 #define FUSE_SUBMOUNTS		(1 << 27)
 #define FUSE_HANDLE_KILLPRIV_V2	(1 << 28)
+#define FUSE_SETXATTR_EXT	(1 << 29)
 
 /**
  * CUSE INIT request/reply flags
@@ -447,6 +451,12 @@ struct fuse_file_lock {
  */
 #define FUSE_OPEN_KILL_SUIDGID	(1 << 0)
 
+/**
+ * setxattr flags
+ * FUSE_SETXATTR_ACL_KILL_SGID: Clear SGID when system.posix_acl_access is set
+ */
+#define FUSE_SETXATTR_ACL_KILL_SGID	(1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP		= 1,
 	FUSE_FORGET		= 2,  /* no reply */
@@ -677,9 +687,13 @@ struct fuse_fsync_in {
 	uint32_t	padding;
 };
 
+#define FUSE_COMPAT_SETXATTR_IN_SIZE 8
+
 struct fuse_setxattr_in {
 	uint32_t	size;
 	uint32_t	flags;
+	uint32_t	setxattr_flags;
+	uint32_t	padding;
 };
 
 struct fuse_getxattr_in {
@@ -899,7 +913,8 @@ struct fuse_notify_retrieve_in {
 };
 
 /* Device ioctls: */
-#define FUSE_DEV_IOC_CLONE	_IOR(229, 0, uint32_t)
+#define FUSE_DEV_IOC_MAGIC		229
+#define FUSE_DEV_IOC_CLONE		_IOR(FUSE_DEV_IOC_MAGIC, 0, uint32_t)
 
 struct fuse_lseek_in {
 	uint64_t	fh;
diff --git a/include/standard-headers/linux/input-event-codes.h b/include/standard-headers/linux/input-event-codes.h
index c403b9cb0d..b5e86b40ab 100644
--- a/include/standard-headers/linux/input-event-codes.h
+++ b/include/standard-headers/linux/input-event-codes.h
@@ -611,6 +611,7 @@
 #define KEY_VOICECOMMAND		0x246	/* Listening Voice Command */
 #define KEY_ASSISTANT		0x247	/* AL Context-aware desktop assistant */
 #define KEY_KBD_LAYOUT_NEXT	0x248	/* AC Next Keyboard Layout Select */
+#define KEY_EMOJI_PICKER	0x249	/* Show/hide emoji picker (HUTRR101) */
 
 #define KEY_BRIGHTNESS_MIN		0x250	/* Set Brightness to Minimum */
 #define KEY_BRIGHTNESS_MAX		0x251	/* Set Brightness to Maximum */
diff --git a/include/standard-headers/linux/input.h b/include/standard-headers/linux/input.h
index f89c986190..7822c24178 100644
--- a/include/standard-headers/linux/input.h
+++ b/include/standard-headers/linux/input.h
@@ -81,7 +81,7 @@ struct input_id {
  * in units per radian.
  * When INPUT_PROP_ACCELEROMETER is set the resolution changes.
  * The main axes (ABS_X, ABS_Y, ABS_Z) are then reported in
- * in units per g (units/g) and in units per degree per second
+ * units per g (units/g) and in units per degree per second
  * (units/deg/s) for rotational axes (ABS_RX, ABS_RY, ABS_RZ).
  */
 struct input_absinfo {
diff --git a/include/standard-headers/linux/virtio_ids.h b/include/standard-headers/linux/virtio_ids.h
index bc1c0621f5..4fe842c3a3 100644
--- a/include/standard-headers/linux/virtio_ids.h
+++ b/include/standard-headers/linux/virtio_ids.h
@@ -51,8 +51,10 @@
 #define VIRTIO_ID_PSTORE		22 /* virtio pstore device */
 #define VIRTIO_ID_IOMMU			23 /* virtio IOMMU */
 #define VIRTIO_ID_MEM			24 /* virtio mem */
+#define VIRTIO_ID_SOUND			25 /* virtio sound */
 #define VIRTIO_ID_FS			26 /* virtio filesystem */
 #define VIRTIO_ID_PMEM			27 /* virtio pmem */
 #define VIRTIO_ID_MAC80211_HWSIM	29 /* virtio mac80211-hwsim */
+#define VIRTIO_ID_BT			40 /* virtio bluetooth */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
diff --git a/include/standard-headers/rdma/vmw_pvrdma-abi.h b/include/standard-headers/rdma/vmw_pvrdma-abi.h
index 0989426a3f..c30182a7ae 100644
--- a/include/standard-headers/rdma/vmw_pvrdma-abi.h
+++ b/include/standard-headers/rdma/vmw_pvrdma-abi.h
@@ -133,6 +133,13 @@ enum pvrdma_wc_flags {
 	PVRDMA_WC_FLAGS_MAX		= PVRDMA_WC_WITH_NETWORK_HDR_TYPE,
 };
 
+enum pvrdma_network_type {
+	PVRDMA_NETWORK_IB,
+	PVRDMA_NETWORK_ROCE_V1 = PVRDMA_NETWORK_IB,
+	PVRDMA_NETWORK_IPV4,
+	PVRDMA_NETWORK_IPV6
+};
+
 struct pvrdma_alloc_ucontext_resp {
 	uint32_t qp_tab_size;
 	uint32_t reserved;
diff --git a/linux-headers/asm-generic/unistd.h b/linux-headers/asm-generic/unistd.h
index 7287529177..6de5a7fc06 100644
--- a/linux-headers/asm-generic/unistd.h
+++ b/linux-headers/asm-generic/unistd.h
@@ -861,9 +861,20 @@ __SYSCALL(__NR_faccessat2, sys_faccessat2)
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
 #define __NR_epoll_pwait2 441
 __SC_COMP(__NR_epoll_pwait2, sys_epoll_pwait2, compat_sys_epoll_pwait2)
+#define __NR_mount_setattr 442
+__SYSCALL(__NR_mount_setattr, sys_mount_setattr)
+#define __NR_quotactl_path 443
+__SYSCALL(__NR_quotactl_path, sys_quotactl_path)
+
+#define __NR_landlock_create_ruleset 444
+__SYSCALL(__NR_landlock_create_ruleset, sys_landlock_create_ruleset)
+#define __NR_landlock_add_rule 445
+__SYSCALL(__NR_landlock_add_rule, sys_landlock_add_rule)
+#define __NR_landlock_restrict_self 446
+__SYSCALL(__NR_landlock_restrict_self, sys_landlock_restrict_self)
 
 #undef __NR_syscalls
-#define __NR_syscalls 442
+#define __NR_syscalls 447
 
 /*
  * 32 bit systems traditionally used different
diff --git a/linux-headers/asm-mips/unistd_n32.h b/linux-headers/asm-mips/unistd_n32.h
index 59e53b6e07..fce51fee09 100644
--- a/linux-headers/asm-mips/unistd_n32.h
+++ b/linux-headers/asm-mips/unistd_n32.h
@@ -1,376 +1,379 @@
-#ifndef _ASM_MIPS_UNISTD_N32_H
-#define _ASM_MIPS_UNISTD_N32_H
+#ifndef _ASM_UNISTD_N32_H
+#define _ASM_UNISTD_N32_H
 
-#define __NR_read	(__NR_Linux + 0)
-#define __NR_write	(__NR_Linux + 1)
-#define __NR_open	(__NR_Linux + 2)
-#define __NR_close	(__NR_Linux + 3)
-#define __NR_stat	(__NR_Linux + 4)
-#define __NR_fstat	(__NR_Linux + 5)
-#define __NR_lstat	(__NR_Linux + 6)
-#define __NR_poll	(__NR_Linux + 7)
-#define __NR_lseek	(__NR_Linux + 8)
-#define __NR_mmap	(__NR_Linux + 9)
-#define __NR_mprotect	(__NR_Linux + 10)
-#define __NR_munmap	(__NR_Linux + 11)
-#define __NR_brk	(__NR_Linux + 12)
-#define __NR_rt_sigaction	(__NR_Linux + 13)
-#define __NR_rt_sigprocmask	(__NR_Linux + 14)
-#define __NR_ioctl	(__NR_Linux + 15)
-#define __NR_pread64	(__NR_Linux + 16)
-#define __NR_pwrite64	(__NR_Linux + 17)
-#define __NR_readv	(__NR_Linux + 18)
-#define __NR_writev	(__NR_Linux + 19)
-#define __NR_access	(__NR_Linux + 20)
-#define __NR_pipe	(__NR_Linux + 21)
-#define __NR__newselect	(__NR_Linux + 22)
-#define __NR_sched_yield	(__NR_Linux + 23)
-#define __NR_mremap	(__NR_Linux + 24)
-#define __NR_msync	(__NR_Linux + 25)
-#define __NR_mincore	(__NR_Linux + 26)
-#define __NR_madvise	(__NR_Linux + 27)
-#define __NR_shmget	(__NR_Linux + 28)
-#define __NR_shmat	(__NR_Linux + 29)
-#define __NR_shmctl	(__NR_Linux + 30)
-#define __NR_dup	(__NR_Linux + 31)
-#define __NR_dup2	(__NR_Linux + 32)
-#define __NR_pause	(__NR_Linux + 33)
-#define __NR_nanosleep	(__NR_Linux + 34)
-#define __NR_getitimer	(__NR_Linux + 35)
-#define __NR_setitimer	(__NR_Linux + 36)
-#define __NR_alarm	(__NR_Linux + 37)
-#define __NR_getpid	(__NR_Linux + 38)
-#define __NR_sendfile	(__NR_Linux + 39)
-#define __NR_socket	(__NR_Linux + 40)
-#define __NR_connect	(__NR_Linux + 41)
-#define __NR_accept	(__NR_Linux + 42)
-#define __NR_sendto	(__NR_Linux + 43)
-#define __NR_recvfrom	(__NR_Linux + 44)
-#define __NR_sendmsg	(__NR_Linux + 45)
-#define __NR_recvmsg	(__NR_Linux + 46)
-#define __NR_shutdown	(__NR_Linux + 47)
-#define __NR_bind	(__NR_Linux + 48)
-#define __NR_listen	(__NR_Linux + 49)
-#define __NR_getsockname	(__NR_Linux + 50)
-#define __NR_getpeername	(__NR_Linux + 51)
-#define __NR_socketpair	(__NR_Linux + 52)
-#define __NR_setsockopt	(__NR_Linux + 53)
-#define __NR_getsockopt	(__NR_Linux + 54)
-#define __NR_clone	(__NR_Linux + 55)
-#define __NR_fork	(__NR_Linux + 56)
-#define __NR_execve	(__NR_Linux + 57)
-#define __NR_exit	(__NR_Linux + 58)
-#define __NR_wait4	(__NR_Linux + 59)
-#define __NR_kill	(__NR_Linux + 60)
-#define __NR_uname	(__NR_Linux + 61)
-#define __NR_semget	(__NR_Linux + 62)
-#define __NR_semop	(__NR_Linux + 63)
-#define __NR_semctl	(__NR_Linux + 64)
-#define __NR_shmdt	(__NR_Linux + 65)
-#define __NR_msgget	(__NR_Linux + 66)
-#define __NR_msgsnd	(__NR_Linux + 67)
-#define __NR_msgrcv	(__NR_Linux + 68)
-#define __NR_msgctl	(__NR_Linux + 69)
-#define __NR_fcntl	(__NR_Linux + 70)
-#define __NR_flock	(__NR_Linux + 71)
-#define __NR_fsync	(__NR_Linux + 72)
-#define __NR_fdatasync	(__NR_Linux + 73)
-#define __NR_truncate	(__NR_Linux + 74)
-#define __NR_ftruncate	(__NR_Linux + 75)
-#define __NR_getdents	(__NR_Linux + 76)
-#define __NR_getcwd	(__NR_Linux + 77)
-#define __NR_chdir	(__NR_Linux + 78)
-#define __NR_fchdir	(__NR_Linux + 79)
-#define __NR_rename	(__NR_Linux + 80)
-#define __NR_mkdir	(__NR_Linux + 81)
-#define __NR_rmdir	(__NR_Linux + 82)
-#define __NR_creat	(__NR_Linux + 83)
-#define __NR_link	(__NR_Linux + 84)
-#define __NR_unlink	(__NR_Linux + 85)
-#define __NR_symlink	(__NR_Linux + 86)
-#define __NR_readlink	(__NR_Linux + 87)
-#define __NR_chmod	(__NR_Linux + 88)
-#define __NR_fchmod	(__NR_Linux + 89)
-#define __NR_chown	(__NR_Linux + 90)
-#define __NR_fchown	(__NR_Linux + 91)
-#define __NR_lchown	(__NR_Linux + 92)
-#define __NR_umask	(__NR_Linux + 93)
-#define __NR_gettimeofday	(__NR_Linux + 94)
-#define __NR_getrlimit	(__NR_Linux + 95)
-#define __NR_getrusage	(__NR_Linux + 96)
-#define __NR_sysinfo	(__NR_Linux + 97)
-#define __NR_times	(__NR_Linux + 98)
-#define __NR_ptrace	(__NR_Linux + 99)
-#define __NR_getuid	(__NR_Linux + 100)
-#define __NR_syslog	(__NR_Linux + 101)
-#define __NR_getgid	(__NR_Linux + 102)
-#define __NR_setuid	(__NR_Linux + 103)
-#define __NR_setgid	(__NR_Linux + 104)
-#define __NR_geteuid	(__NR_Linux + 105)
-#define __NR_getegid	(__NR_Linux + 106)
-#define __NR_setpgid	(__NR_Linux + 107)
-#define __NR_getppid	(__NR_Linux + 108)
-#define __NR_getpgrp	(__NR_Linux + 109)
-#define __NR_setsid	(__NR_Linux + 110)
-#define __NR_setreuid	(__NR_Linux + 111)
-#define __NR_setregid	(__NR_Linux + 112)
-#define __NR_getgroups	(__NR_Linux + 113)
-#define __NR_setgroups	(__NR_Linux + 114)
-#define __NR_setresuid	(__NR_Linux + 115)
-#define __NR_getresuid	(__NR_Linux + 116)
-#define __NR_setresgid	(__NR_Linux + 117)
-#define __NR_getresgid	(__NR_Linux + 118)
-#define __NR_getpgid	(__NR_Linux + 119)
-#define __NR_setfsuid	(__NR_Linux + 120)
-#define __NR_setfsgid	(__NR_Linux + 121)
-#define __NR_getsid	(__NR_Linux + 122)
-#define __NR_capget	(__NR_Linux + 123)
-#define __NR_capset	(__NR_Linux + 124)
-#define __NR_rt_sigpending	(__NR_Linux + 125)
-#define __NR_rt_sigtimedwait	(__NR_Linux + 126)
-#define __NR_rt_sigqueueinfo	(__NR_Linux + 127)
-#define __NR_rt_sigsuspend	(__NR_Linux + 128)
-#define __NR_sigaltstack	(__NR_Linux + 129)
-#define __NR_utime	(__NR_Linux + 130)
-#define __NR_mknod	(__NR_Linux + 131)
-#define __NR_personality	(__NR_Linux + 132)
-#define __NR_ustat	(__NR_Linux + 133)
-#define __NR_statfs	(__NR_Linux + 134)
-#define __NR_fstatfs	(__NR_Linux + 135)
-#define __NR_sysfs	(__NR_Linux + 136)
-#define __NR_getpriority	(__NR_Linux + 137)
-#define __NR_setpriority	(__NR_Linux + 138)
-#define __NR_sched_setparam	(__NR_Linux + 139)
-#define __NR_sched_getparam	(__NR_Linux + 140)
-#define __NR_sched_setscheduler	(__NR_Linux + 141)
-#define __NR_sched_getscheduler	(__NR_Linux + 142)
-#define __NR_sched_get_priority_max	(__NR_Linux + 143)
-#define __NR_sched_get_priority_min	(__NR_Linux + 144)
-#define __NR_sched_rr_get_interval	(__NR_Linux + 145)
-#define __NR_mlock	(__NR_Linux + 146)
-#define __NR_munlock	(__NR_Linux + 147)
-#define __NR_mlockall	(__NR_Linux + 148)
-#define __NR_munlockall	(__NR_Linux + 149)
-#define __NR_vhangup	(__NR_Linux + 150)
-#define __NR_pivot_root	(__NR_Linux + 151)
-#define __NR__sysctl	(__NR_Linux + 152)
-#define __NR_prctl	(__NR_Linux + 153)
-#define __NR_adjtimex	(__NR_Linux + 154)
-#define __NR_setrlimit	(__NR_Linux + 155)
-#define __NR_chroot	(__NR_Linux + 156)
-#define __NR_sync	(__NR_Linux + 157)
-#define __NR_acct	(__NR_Linux + 158)
-#define __NR_settimeofday	(__NR_Linux + 159)
-#define __NR_mount	(__NR_Linux + 160)
-#define __NR_umount2	(__NR_Linux + 161)
-#define __NR_swapon	(__NR_Linux + 162)
-#define __NR_swapoff	(__NR_Linux + 163)
-#define __NR_reboot	(__NR_Linux + 164)
-#define __NR_sethostname	(__NR_Linux + 165)
-#define __NR_setdomainname	(__NR_Linux + 166)
-#define __NR_create_module	(__NR_Linux + 167)
-#define __NR_init_module	(__NR_Linux + 168)
-#define __NR_delete_module	(__NR_Linux + 169)
-#define __NR_get_kernel_syms	(__NR_Linux + 170)
-#define __NR_query_module	(__NR_Linux + 171)
-#define __NR_quotactl	(__NR_Linux + 172)
-#define __NR_nfsservctl	(__NR_Linux + 173)
-#define __NR_getpmsg	(__NR_Linux + 174)
-#define __NR_putpmsg	(__NR_Linux + 175)
-#define __NR_afs_syscall	(__NR_Linux + 176)
-#define __NR_reserved177	(__NR_Linux + 177)
-#define __NR_gettid	(__NR_Linux + 178)
-#define __NR_readahead	(__NR_Linux + 179)
-#define __NR_setxattr	(__NR_Linux + 180)
-#define __NR_lsetxattr	(__NR_Linux + 181)
-#define __NR_fsetxattr	(__NR_Linux + 182)
-#define __NR_getxattr	(__NR_Linux + 183)
-#define __NR_lgetxattr	(__NR_Linux + 184)
-#define __NR_fgetxattr	(__NR_Linux + 185)
-#define __NR_listxattr	(__NR_Linux + 186)
-#define __NR_llistxattr	(__NR_Linux + 187)
-#define __NR_flistxattr	(__NR_Linux + 188)
-#define __NR_removexattr	(__NR_Linux + 189)
-#define __NR_lremovexattr	(__NR_Linux + 190)
-#define __NR_fremovexattr	(__NR_Linux + 191)
-#define __NR_tkill	(__NR_Linux + 192)
-#define __NR_reserved193	(__NR_Linux + 193)
-#define __NR_futex	(__NR_Linux + 194)
-#define __NR_sched_setaffinity	(__NR_Linux + 195)
-#define __NR_sched_getaffinity	(__NR_Linux + 196)
-#define __NR_cacheflush	(__NR_Linux + 197)
-#define __NR_cachectl	(__NR_Linux + 198)
-#define __NR_sysmips	(__NR_Linux + 199)
-#define __NR_io_setup	(__NR_Linux + 200)
-#define __NR_io_destroy	(__NR_Linux + 201)
-#define __NR_io_getevents	(__NR_Linux + 202)
-#define __NR_io_submit	(__NR_Linux + 203)
-#define __NR_io_cancel	(__NR_Linux + 204)
-#define __NR_exit_group	(__NR_Linux + 205)
-#define __NR_lookup_dcookie	(__NR_Linux + 206)
-#define __NR_epoll_create	(__NR_Linux + 207)
-#define __NR_epoll_ctl	(__NR_Linux + 208)
-#define __NR_epoll_wait	(__NR_Linux + 209)
-#define __NR_remap_file_pages	(__NR_Linux + 210)
-#define __NR_rt_sigreturn	(__NR_Linux + 211)
-#define __NR_fcntl64	(__NR_Linux + 212)
-#define __NR_set_tid_address	(__NR_Linux + 213)
-#define __NR_restart_syscall	(__NR_Linux + 214)
-#define __NR_semtimedop	(__NR_Linux + 215)
-#define __NR_fadvise64	(__NR_Linux + 216)
-#define __NR_statfs64	(__NR_Linux + 217)
-#define __NR_fstatfs64	(__NR_Linux + 218)
-#define __NR_sendfile64	(__NR_Linux + 219)
-#define __NR_timer_create	(__NR_Linux + 220)
-#define __NR_timer_settime	(__NR_Linux + 221)
-#define __NR_timer_gettime	(__NR_Linux + 222)
-#define __NR_timer_getoverrun	(__NR_Linux + 223)
-#define __NR_timer_delete	(__NR_Linux + 224)
-#define __NR_clock_settime	(__NR_Linux + 225)
-#define __NR_clock_gettime	(__NR_Linux + 226)
-#define __NR_clock_getres	(__NR_Linux + 227)
-#define __NR_clock_nanosleep	(__NR_Linux + 228)
-#define __NR_tgkill	(__NR_Linux + 229)
-#define __NR_utimes	(__NR_Linux + 230)
-#define __NR_mbind	(__NR_Linux + 231)
-#define __NR_get_mempolicy	(__NR_Linux + 232)
-#define __NR_set_mempolicy	(__NR_Linux + 233)
-#define __NR_mq_open	(__NR_Linux + 234)
-#define __NR_mq_unlink	(__NR_Linux + 235)
-#define __NR_mq_timedsend	(__NR_Linux + 236)
-#define __NR_mq_timedreceive	(__NR_Linux + 237)
-#define __NR_mq_notify	(__NR_Linux + 238)
-#define __NR_mq_getsetattr	(__NR_Linux + 239)
-#define __NR_vserver	(__NR_Linux + 240)
-#define __NR_waitid	(__NR_Linux + 241)
-#define __NR_add_key	(__NR_Linux + 243)
-#define __NR_request_key	(__NR_Linux + 244)
-#define __NR_keyctl	(__NR_Linux + 245)
-#define __NR_set_thread_area	(__NR_Linux + 246)
-#define __NR_inotify_init	(__NR_Linux + 247)
-#define __NR_inotify_add_watch	(__NR_Linux + 248)
-#define __NR_inotify_rm_watch	(__NR_Linux + 249)
-#define __NR_migrate_pages	(__NR_Linux + 250)
-#define __NR_openat	(__NR_Linux + 251)
-#define __NR_mkdirat	(__NR_Linux + 252)
-#define __NR_mknodat	(__NR_Linux + 253)
-#define __NR_fchownat	(__NR_Linux + 254)
-#define __NR_futimesat	(__NR_Linux + 255)
-#define __NR_newfstatat	(__NR_Linux + 256)
-#define __NR_unlinkat	(__NR_Linux + 257)
-#define __NR_renameat	(__NR_Linux + 258)
-#define __NR_linkat	(__NR_Linux + 259)
-#define __NR_symlinkat	(__NR_Linux + 260)
-#define __NR_readlinkat	(__NR_Linux + 261)
-#define __NR_fchmodat	(__NR_Linux + 262)
-#define __NR_faccessat	(__NR_Linux + 263)
-#define __NR_pselect6	(__NR_Linux + 264)
-#define __NR_ppoll	(__NR_Linux + 265)
-#define __NR_unshare	(__NR_Linux + 266)
-#define __NR_splice	(__NR_Linux + 267)
-#define __NR_sync_file_range	(__NR_Linux + 268)
-#define __NR_tee	(__NR_Linux + 269)
-#define __NR_vmsplice	(__NR_Linux + 270)
-#define __NR_move_pages	(__NR_Linux + 271)
-#define __NR_set_robust_list	(__NR_Linux + 272)
-#define __NR_get_robust_list	(__NR_Linux + 273)
-#define __NR_kexec_load	(__NR_Linux + 274)
-#define __NR_getcpu	(__NR_Linux + 275)
-#define __NR_epoll_pwait	(__NR_Linux + 276)
-#define __NR_ioprio_set	(__NR_Linux + 277)
-#define __NR_ioprio_get	(__NR_Linux + 278)
-#define __NR_utimensat	(__NR_Linux + 279)
-#define __NR_signalfd	(__NR_Linux + 280)
-#define __NR_timerfd	(__NR_Linux + 281)
-#define __NR_eventfd	(__NR_Linux + 282)
-#define __NR_fallocate	(__NR_Linux + 283)
-#define __NR_timerfd_create	(__NR_Linux + 284)
-#define __NR_timerfd_gettime	(__NR_Linux + 285)
-#define __NR_timerfd_settime	(__NR_Linux + 286)
-#define __NR_signalfd4	(__NR_Linux + 287)
-#define __NR_eventfd2	(__NR_Linux + 288)
-#define __NR_epoll_create1	(__NR_Linux + 289)
-#define __NR_dup3	(__NR_Linux + 290)
-#define __NR_pipe2	(__NR_Linux + 291)
-#define __NR_inotify_init1	(__NR_Linux + 292)
-#define __NR_preadv	(__NR_Linux + 293)
-#define __NR_pwritev	(__NR_Linux + 294)
-#define __NR_rt_tgsigqueueinfo	(__NR_Linux + 295)
-#define __NR_perf_event_open	(__NR_Linux + 296)
-#define __NR_accept4	(__NR_Linux + 297)
-#define __NR_recvmmsg	(__NR_Linux + 298)
-#define __NR_getdents64	(__NR_Linux + 299)
-#define __NR_fanotify_init	(__NR_Linux + 300)
-#define __NR_fanotify_mark	(__NR_Linux + 301)
-#define __NR_prlimit64	(__NR_Linux + 302)
-#define __NR_name_to_handle_at	(__NR_Linux + 303)
-#define __NR_open_by_handle_at	(__NR_Linux + 304)
-#define __NR_clock_adjtime	(__NR_Linux + 305)
-#define __NR_syncfs	(__NR_Linux + 306)
-#define __NR_sendmmsg	(__NR_Linux + 307)
-#define __NR_setns	(__NR_Linux + 308)
-#define __NR_process_vm_readv	(__NR_Linux + 309)
-#define __NR_process_vm_writev	(__NR_Linux + 310)
-#define __NR_kcmp	(__NR_Linux + 311)
-#define __NR_finit_module	(__NR_Linux + 312)
-#define __NR_sched_setattr	(__NR_Linux + 313)
-#define __NR_sched_getattr	(__NR_Linux + 314)
-#define __NR_renameat2	(__NR_Linux + 315)
-#define __NR_seccomp	(__NR_Linux + 316)
-#define __NR_getrandom	(__NR_Linux + 317)
-#define __NR_memfd_create	(__NR_Linux + 318)
-#define __NR_bpf	(__NR_Linux + 319)
-#define __NR_execveat	(__NR_Linux + 320)
-#define __NR_userfaultfd	(__NR_Linux + 321)
-#define __NR_membarrier	(__NR_Linux + 322)
-#define __NR_mlock2	(__NR_Linux + 323)
-#define __NR_copy_file_range	(__NR_Linux + 324)
-#define __NR_preadv2	(__NR_Linux + 325)
-#define __NR_pwritev2	(__NR_Linux + 326)
-#define __NR_pkey_mprotect	(__NR_Linux + 327)
-#define __NR_pkey_alloc	(__NR_Linux + 328)
-#define __NR_pkey_free	(__NR_Linux + 329)
-#define __NR_statx	(__NR_Linux + 330)
-#define __NR_rseq	(__NR_Linux + 331)
-#define __NR_io_pgetevents	(__NR_Linux + 332)
-#define __NR_clock_gettime64	(__NR_Linux + 403)
-#define __NR_clock_settime64	(__NR_Linux + 404)
-#define __NR_clock_adjtime64	(__NR_Linux + 405)
-#define __NR_clock_getres_time64	(__NR_Linux + 406)
-#define __NR_clock_nanosleep_time64	(__NR_Linux + 407)
-#define __NR_timer_gettime64	(__NR_Linux + 408)
-#define __NR_timer_settime64	(__NR_Linux + 409)
-#define __NR_timerfd_gettime64	(__NR_Linux + 410)
-#define __NR_timerfd_settime64	(__NR_Linux + 411)
-#define __NR_utimensat_time64	(__NR_Linux + 412)
-#define __NR_pselect6_time64	(__NR_Linux + 413)
-#define __NR_ppoll_time64	(__NR_Linux + 414)
-#define __NR_io_pgetevents_time64	(__NR_Linux + 416)
-#define __NR_recvmmsg_time64	(__NR_Linux + 417)
-#define __NR_mq_timedsend_time64	(__NR_Linux + 418)
-#define __NR_mq_timedreceive_time64	(__NR_Linux + 419)
-#define __NR_semtimedop_time64	(__NR_Linux + 420)
-#define __NR_rt_sigtimedwait_time64	(__NR_Linux + 421)
-#define __NR_futex_time64	(__NR_Linux + 422)
-#define __NR_sched_rr_get_interval_time64	(__NR_Linux + 423)
-#define __NR_pidfd_send_signal	(__NR_Linux + 424)
-#define __NR_io_uring_setup	(__NR_Linux + 425)
-#define __NR_io_uring_enter	(__NR_Linux + 426)
-#define __NR_io_uring_register	(__NR_Linux + 427)
-#define __NR_open_tree	(__NR_Linux + 428)
-#define __NR_move_mount	(__NR_Linux + 429)
-#define __NR_fsopen	(__NR_Linux + 430)
-#define __NR_fsconfig	(__NR_Linux + 431)
-#define __NR_fsmount	(__NR_Linux + 432)
-#define __NR_fspick	(__NR_Linux + 433)
-#define __NR_pidfd_open	(__NR_Linux + 434)
-#define __NR_clone3	(__NR_Linux + 435)
-#define __NR_close_range	(__NR_Linux + 436)
-#define __NR_openat2	(__NR_Linux + 437)
-#define __NR_pidfd_getfd	(__NR_Linux + 438)
-#define __NR_faccessat2	(__NR_Linux + 439)
-#define __NR_process_madvise	(__NR_Linux + 440)
-#define __NR_epoll_pwait2	(__NR_Linux + 441)
+#define __NR_read (__NR_Linux + 0)
+#define __NR_write (__NR_Linux + 1)
+#define __NR_open (__NR_Linux + 2)
+#define __NR_close (__NR_Linux + 3)
+#define __NR_stat (__NR_Linux + 4)
+#define __NR_fstat (__NR_Linux + 5)
+#define __NR_lstat (__NR_Linux + 6)
+#define __NR_poll (__NR_Linux + 7)
+#define __NR_lseek (__NR_Linux + 8)
+#define __NR_mmap (__NR_Linux + 9)
+#define __NR_mprotect (__NR_Linux + 10)
+#define __NR_munmap (__NR_Linux + 11)
+#define __NR_brk (__NR_Linux + 12)
+#define __NR_rt_sigaction (__NR_Linux + 13)
+#define __NR_rt_sigprocmask (__NR_Linux + 14)
+#define __NR_ioctl (__NR_Linux + 15)
+#define __NR_pread64 (__NR_Linux + 16)
+#define __NR_pwrite64 (__NR_Linux + 17)
+#define __NR_readv (__NR_Linux + 18)
+#define __NR_writev (__NR_Linux + 19)
+#define __NR_access (__NR_Linux + 20)
+#define __NR_pipe (__NR_Linux + 21)
+#define __NR__newselect (__NR_Linux + 22)
+#define __NR_sched_yield (__NR_Linux + 23)
+#define __NR_mremap (__NR_Linux + 24)
+#define __NR_msync (__NR_Linux + 25)
+#define __NR_mincore (__NR_Linux + 26)
+#define __NR_madvise (__NR_Linux + 27)
+#define __NR_shmget (__NR_Linux + 28)
+#define __NR_shmat (__NR_Linux + 29)
+#define __NR_shmctl (__NR_Linux + 30)
+#define __NR_dup (__NR_Linux + 31)
+#define __NR_dup2 (__NR_Linux + 32)
+#define __NR_pause (__NR_Linux + 33)
+#define __NR_nanosleep (__NR_Linux + 34)
+#define __NR_getitimer (__NR_Linux + 35)
+#define __NR_setitimer (__NR_Linux + 36)
+#define __NR_alarm (__NR_Linux + 37)
+#define __NR_getpid (__NR_Linux + 38)
+#define __NR_sendfile (__NR_Linux + 39)
+#define __NR_socket (__NR_Linux + 40)
+#define __NR_connect (__NR_Linux + 41)
+#define __NR_accept (__NR_Linux + 42)
+#define __NR_sendto (__NR_Linux + 43)
+#define __NR_recvfrom (__NR_Linux + 44)
+#define __NR_sendmsg (__NR_Linux + 45)
+#define __NR_recvmsg (__NR_Linux + 46)
+#define __NR_shutdown (__NR_Linux + 47)
+#define __NR_bind (__NR_Linux + 48)
+#define __NR_listen (__NR_Linux + 49)
+#define __NR_getsockname (__NR_Linux + 50)
+#define __NR_getpeername (__NR_Linux + 51)
+#define __NR_socketpair (__NR_Linux + 52)
+#define __NR_setsockopt (__NR_Linux + 53)
+#define __NR_getsockopt (__NR_Linux + 54)
+#define __NR_clone (__NR_Linux + 55)
+#define __NR_fork (__NR_Linux + 56)
+#define __NR_execve (__NR_Linux + 57)
+#define __NR_exit (__NR_Linux + 58)
+#define __NR_wait4 (__NR_Linux + 59)
+#define __NR_kill (__NR_Linux + 60)
+#define __NR_uname (__NR_Linux + 61)
+#define __NR_semget (__NR_Linux + 62)
+#define __NR_semop (__NR_Linux + 63)
+#define __NR_semctl (__NR_Linux + 64)
+#define __NR_shmdt (__NR_Linux + 65)
+#define __NR_msgget (__NR_Linux + 66)
+#define __NR_msgsnd (__NR_Linux + 67)
+#define __NR_msgrcv (__NR_Linux + 68)
+#define __NR_msgctl (__NR_Linux + 69)
+#define __NR_fcntl (__NR_Linux + 70)
+#define __NR_flock (__NR_Linux + 71)
+#define __NR_fsync (__NR_Linux + 72)
+#define __NR_fdatasync (__NR_Linux + 73)
+#define __NR_truncate (__NR_Linux + 74)
+#define __NR_ftruncate (__NR_Linux + 75)
+#define __NR_getdents (__NR_Linux + 76)
+#define __NR_getcwd (__NR_Linux + 77)
+#define __NR_chdir (__NR_Linux + 78)
+#define __NR_fchdir (__NR_Linux + 79)
+#define __NR_rename (__NR_Linux + 80)
+#define __NR_mkdir (__NR_Linux + 81)
+#define __NR_rmdir (__NR_Linux + 82)
+#define __NR_creat (__NR_Linux + 83)
+#define __NR_link (__NR_Linux + 84)
+#define __NR_unlink (__NR_Linux + 85)
+#define __NR_symlink (__NR_Linux + 86)
+#define __NR_readlink (__NR_Linux + 87)
+#define __NR_chmod (__NR_Linux + 88)
+#define __NR_fchmod (__NR_Linux + 89)
+#define __NR_chown (__NR_Linux + 90)
+#define __NR_fchown (__NR_Linux + 91)
+#define __NR_lchown (__NR_Linux + 92)
+#define __NR_umask (__NR_Linux + 93)
+#define __NR_gettimeofday (__NR_Linux + 94)
+#define __NR_getrlimit (__NR_Linux + 95)
+#define __NR_getrusage (__NR_Linux + 96)
+#define __NR_sysinfo (__NR_Linux + 97)
+#define __NR_times (__NR_Linux + 98)
+#define __NR_ptrace (__NR_Linux + 99)
+#define __NR_getuid (__NR_Linux + 100)
+#define __NR_syslog (__NR_Linux + 101)
+#define __NR_getgid (__NR_Linux + 102)
+#define __NR_setuid (__NR_Linux + 103)
+#define __NR_setgid (__NR_Linux + 104)
+#define __NR_geteuid (__NR_Linux + 105)
+#define __NR_getegid (__NR_Linux + 106)
+#define __NR_setpgid (__NR_Linux + 107)
+#define __NR_getppid (__NR_Linux + 108)
+#define __NR_getpgrp (__NR_Linux + 109)
+#define __NR_setsid (__NR_Linux + 110)
+#define __NR_setreuid (__NR_Linux + 111)
+#define __NR_setregid (__NR_Linux + 112)
+#define __NR_getgroups (__NR_Linux + 113)
+#define __NR_setgroups (__NR_Linux + 114)
+#define __NR_setresuid (__NR_Linux + 115)
+#define __NR_getresuid (__NR_Linux + 116)
+#define __NR_setresgid (__NR_Linux + 117)
+#define __NR_getresgid (__NR_Linux + 118)
+#define __NR_getpgid (__NR_Linux + 119)
+#define __NR_setfsuid (__NR_Linux + 120)
+#define __NR_setfsgid (__NR_Linux + 121)
+#define __NR_getsid (__NR_Linux + 122)
+#define __NR_capget (__NR_Linux + 123)
+#define __NR_capset (__NR_Linux + 124)
+#define __NR_rt_sigpending (__NR_Linux + 125)
+#define __NR_rt_sigtimedwait (__NR_Linux + 126)
+#define __NR_rt_sigqueueinfo (__NR_Linux + 127)
+#define __NR_rt_sigsuspend (__NR_Linux + 128)
+#define __NR_sigaltstack (__NR_Linux + 129)
+#define __NR_utime (__NR_Linux + 130)
+#define __NR_mknod (__NR_Linux + 131)
+#define __NR_personality (__NR_Linux + 132)
+#define __NR_ustat (__NR_Linux + 133)
+#define __NR_statfs (__NR_Linux + 134)
+#define __NR_fstatfs (__NR_Linux + 135)
+#define __NR_sysfs (__NR_Linux + 136)
+#define __NR_getpriority (__NR_Linux + 137)
+#define __NR_setpriority (__NR_Linux + 138)
+#define __NR_sched_setparam (__NR_Linux + 139)
+#define __NR_sched_getparam (__NR_Linux + 140)
+#define __NR_sched_setscheduler (__NR_Linux + 141)
+#define __NR_sched_getscheduler (__NR_Linux + 142)
+#define __NR_sched_get_priority_max (__NR_Linux + 143)
+#define __NR_sched_get_priority_min (__NR_Linux + 144)
+#define __NR_sched_rr_get_interval (__NR_Linux + 145)
+#define __NR_mlock (__NR_Linux + 146)
+#define __NR_munlock (__NR_Linux + 147)
+#define __NR_mlockall (__NR_Linux + 148)
+#define __NR_munlockall (__NR_Linux + 149)
+#define __NR_vhangup (__NR_Linux + 150)
+#define __NR_pivot_root (__NR_Linux + 151)
+#define __NR__sysctl (__NR_Linux + 152)
+#define __NR_prctl (__NR_Linux + 153)
+#define __NR_adjtimex (__NR_Linux + 154)
+#define __NR_setrlimit (__NR_Linux + 155)
+#define __NR_chroot (__NR_Linux + 156)
+#define __NR_sync (__NR_Linux + 157)
+#define __NR_acct (__NR_Linux + 158)
+#define __NR_settimeofday (__NR_Linux + 159)
+#define __NR_mount (__NR_Linux + 160)
+#define __NR_umount2 (__NR_Linux + 161)
+#define __NR_swapon (__NR_Linux + 162)
+#define __NR_swapoff (__NR_Linux + 163)
+#define __NR_reboot (__NR_Linux + 164)
+#define __NR_sethostname (__NR_Linux + 165)
+#define __NR_setdomainname (__NR_Linux + 166)
+#define __NR_create_module (__NR_Linux + 167)
+#define __NR_init_module (__NR_Linux + 168)
+#define __NR_delete_module (__NR_Linux + 169)
+#define __NR_get_kernel_syms (__NR_Linux + 170)
+#define __NR_query_module (__NR_Linux + 171)
+#define __NR_quotactl (__NR_Linux + 172)
+#define __NR_nfsservctl (__NR_Linux + 173)
+#define __NR_getpmsg (__NR_Linux + 174)
+#define __NR_putpmsg (__NR_Linux + 175)
+#define __NR_afs_syscall (__NR_Linux + 176)
+#define __NR_reserved177 (__NR_Linux + 177)
+#define __NR_gettid (__NR_Linux + 178)
+#define __NR_readahead (__NR_Linux + 179)
+#define __NR_setxattr (__NR_Linux + 180)
+#define __NR_lsetxattr (__NR_Linux + 181)
+#define __NR_fsetxattr (__NR_Linux + 182)
+#define __NR_getxattr (__NR_Linux + 183)
+#define __NR_lgetxattr (__NR_Linux + 184)
+#define __NR_fgetxattr (__NR_Linux + 185)
+#define __NR_listxattr (__NR_Linux + 186)
+#define __NR_llistxattr (__NR_Linux + 187)
+#define __NR_flistxattr (__NR_Linux + 188)
+#define __NR_removexattr (__NR_Linux + 189)
+#define __NR_lremovexattr (__NR_Linux + 190)
+#define __NR_fremovexattr (__NR_Linux + 191)
+#define __NR_tkill (__NR_Linux + 192)
+#define __NR_reserved193 (__NR_Linux + 193)
+#define __NR_futex (__NR_Linux + 194)
+#define __NR_sched_setaffinity (__NR_Linux + 195)
+#define __NR_sched_getaffinity (__NR_Linux + 196)
+#define __NR_cacheflush (__NR_Linux + 197)
+#define __NR_cachectl (__NR_Linux + 198)
+#define __NR_sysmips (__NR_Linux + 199)
+#define __NR_io_setup (__NR_Linux + 200)
+#define __NR_io_destroy (__NR_Linux + 201)
+#define __NR_io_getevents (__NR_Linux + 202)
+#define __NR_io_submit (__NR_Linux + 203)
+#define __NR_io_cancel (__NR_Linux + 204)
+#define __NR_exit_group (__NR_Linux + 205)
+#define __NR_lookup_dcookie (__NR_Linux + 206)
+#define __NR_epoll_create (__NR_Linux + 207)
+#define __NR_epoll_ctl (__NR_Linux + 208)
+#define __NR_epoll_wait (__NR_Linux + 209)
+#define __NR_remap_file_pages (__NR_Linux + 210)
+#define __NR_rt_sigreturn (__NR_Linux + 211)
+#define __NR_fcntl64 (__NR_Linux + 212)
+#define __NR_set_tid_address (__NR_Linux + 213)
+#define __NR_restart_syscall (__NR_Linux + 214)
+#define __NR_semtimedop (__NR_Linux + 215)
+#define __NR_fadvise64 (__NR_Linux + 216)
+#define __NR_statfs64 (__NR_Linux + 217)
+#define __NR_fstatfs64 (__NR_Linux + 218)
+#define __NR_sendfile64 (__NR_Linux + 219)
+#define __NR_timer_create (__NR_Linux + 220)
+#define __NR_timer_settime (__NR_Linux + 221)
+#define __NR_timer_gettime (__NR_Linux + 222)
+#define __NR_timer_getoverrun (__NR_Linux + 223)
+#define __NR_timer_delete (__NR_Linux + 224)
+#define __NR_clock_settime (__NR_Linux + 225)
+#define __NR_clock_gettime (__NR_Linux + 226)
+#define __NR_clock_getres (__NR_Linux + 227)
+#define __NR_clock_nanosleep (__NR_Linux + 228)
+#define __NR_tgkill (__NR_Linux + 229)
+#define __NR_utimes (__NR_Linux + 230)
+#define __NR_mbind (__NR_Linux + 231)
+#define __NR_get_mempolicy (__NR_Linux + 232)
+#define __NR_set_mempolicy (__NR_Linux + 233)
+#define __NR_mq_open (__NR_Linux + 234)
+#define __NR_mq_unlink (__NR_Linux + 235)
+#define __NR_mq_timedsend (__NR_Linux + 236)
+#define __NR_mq_timedreceive (__NR_Linux + 237)
+#define __NR_mq_notify (__NR_Linux + 238)
+#define __NR_mq_getsetattr (__NR_Linux + 239)
+#define __NR_vserver (__NR_Linux + 240)
+#define __NR_waitid (__NR_Linux + 241)
+#define __NR_add_key (__NR_Linux + 243)
+#define __NR_request_key (__NR_Linux + 244)
+#define __NR_keyctl (__NR_Linux + 245)
+#define __NR_set_thread_area (__NR_Linux + 246)
+#define __NR_inotify_init (__NR_Linux + 247)
+#define __NR_inotify_add_watch (__NR_Linux + 248)
+#define __NR_inotify_rm_watch (__NR_Linux + 249)
+#define __NR_migrate_pages (__NR_Linux + 250)
+#define __NR_openat (__NR_Linux + 251)
+#define __NR_mkdirat (__NR_Linux + 252)
+#define __NR_mknodat (__NR_Linux + 253)
+#define __NR_fchownat (__NR_Linux + 254)
+#define __NR_futimesat (__NR_Linux + 255)
+#define __NR_newfstatat (__NR_Linux + 256)
+#define __NR_unlinkat (__NR_Linux + 257)
+#define __NR_renameat (__NR_Linux + 258)
+#define __NR_linkat (__NR_Linux + 259)
+#define __NR_symlinkat (__NR_Linux + 260)
+#define __NR_readlinkat (__NR_Linux + 261)
+#define __NR_fchmodat (__NR_Linux + 262)
+#define __NR_faccessat (__NR_Linux + 263)
+#define __NR_pselect6 (__NR_Linux + 264)
+#define __NR_ppoll (__NR_Linux + 265)
+#define __NR_unshare (__NR_Linux + 266)
+#define __NR_splice (__NR_Linux + 267)
+#define __NR_sync_file_range (__NR_Linux + 268)
+#define __NR_tee (__NR_Linux + 269)
+#define __NR_vmsplice (__NR_Linux + 270)
+#define __NR_move_pages (__NR_Linux + 271)
+#define __NR_set_robust_list (__NR_Linux + 272)
+#define __NR_get_robust_list (__NR_Linux + 273)
+#define __NR_kexec_load (__NR_Linux + 274)
+#define __NR_getcpu (__NR_Linux + 275)
+#define __NR_epoll_pwait (__NR_Linux + 276)
+#define __NR_ioprio_set (__NR_Linux + 277)
+#define __NR_ioprio_get (__NR_Linux + 278)
+#define __NR_utimensat (__NR_Linux + 279)
+#define __NR_signalfd (__NR_Linux + 280)
+#define __NR_timerfd (__NR_Linux + 281)
+#define __NR_eventfd (__NR_Linux + 282)
+#define __NR_fallocate (__NR_Linux + 283)
+#define __NR_timerfd_create (__NR_Linux + 284)
+#define __NR_timerfd_gettime (__NR_Linux + 285)
+#define __NR_timerfd_settime (__NR_Linux + 286)
+#define __NR_signalfd4 (__NR_Linux + 287)
+#define __NR_eventfd2 (__NR_Linux + 288)
+#define __NR_epoll_create1 (__NR_Linux + 289)
+#define __NR_dup3 (__NR_Linux + 290)
+#define __NR_pipe2 (__NR_Linux + 291)
+#define __NR_inotify_init1 (__NR_Linux + 292)
+#define __NR_preadv (__NR_Linux + 293)
+#define __NR_pwritev (__NR_Linux + 294)
+#define __NR_rt_tgsigqueueinfo (__NR_Linux + 295)
+#define __NR_perf_event_open (__NR_Linux + 296)
+#define __NR_accept4 (__NR_Linux + 297)
+#define __NR_recvmmsg (__NR_Linux + 298)
+#define __NR_getdents64 (__NR_Linux + 299)
+#define __NR_fanotify_init (__NR_Linux + 300)
+#define __NR_fanotify_mark (__NR_Linux + 301)
+#define __NR_prlimit64 (__NR_Linux + 302)
+#define __NR_name_to_handle_at (__NR_Linux + 303)
+#define __NR_open_by_handle_at (__NR_Linux + 304)
+#define __NR_clock_adjtime (__NR_Linux + 305)
+#define __NR_syncfs (__NR_Linux + 306)
+#define __NR_sendmmsg (__NR_Linux + 307)
+#define __NR_setns (__NR_Linux + 308)
+#define __NR_process_vm_readv (__NR_Linux + 309)
+#define __NR_process_vm_writev (__NR_Linux + 310)
+#define __NR_kcmp (__NR_Linux + 311)
+#define __NR_finit_module (__NR_Linux + 312)
+#define __NR_sched_setattr (__NR_Linux + 313)
+#define __NR_sched_getattr (__NR_Linux + 314)
+#define __NR_renameat2 (__NR_Linux + 315)
+#define __NR_seccomp (__NR_Linux + 316)
+#define __NR_getrandom (__NR_Linux + 317)
+#define __NR_memfd_create (__NR_Linux + 318)
+#define __NR_bpf (__NR_Linux + 319)
+#define __NR_execveat (__NR_Linux + 320)
+#define __NR_userfaultfd (__NR_Linux + 321)
+#define __NR_membarrier (__NR_Linux + 322)
+#define __NR_mlock2 (__NR_Linux + 323)
+#define __NR_copy_file_range (__NR_Linux + 324)
+#define __NR_preadv2 (__NR_Linux + 325)
+#define __NR_pwritev2 (__NR_Linux + 326)
+#define __NR_pkey_mprotect (__NR_Linux + 327)
+#define __NR_pkey_alloc (__NR_Linux + 328)
+#define __NR_pkey_free (__NR_Linux + 329)
+#define __NR_statx (__NR_Linux + 330)
+#define __NR_rseq (__NR_Linux + 331)
+#define __NR_io_pgetevents (__NR_Linux + 332)
+#define __NR_clock_gettime64 (__NR_Linux + 403)
+#define __NR_clock_settime64 (__NR_Linux + 404)
+#define __NR_clock_adjtime64 (__NR_Linux + 405)
+#define __NR_clock_getres_time64 (__NR_Linux + 406)
+#define __NR_clock_nanosleep_time64 (__NR_Linux + 407)
+#define __NR_timer_gettime64 (__NR_Linux + 408)
+#define __NR_timer_settime64 (__NR_Linux + 409)
+#define __NR_timerfd_gettime64 (__NR_Linux + 410)
+#define __NR_timerfd_settime64 (__NR_Linux + 411)
+#define __NR_utimensat_time64 (__NR_Linux + 412)
+#define __NR_pselect6_time64 (__NR_Linux + 413)
+#define __NR_ppoll_time64 (__NR_Linux + 414)
+#define __NR_io_pgetevents_time64 (__NR_Linux + 416)
+#define __NR_recvmmsg_time64 (__NR_Linux + 417)
+#define __NR_mq_timedsend_time64 (__NR_Linux + 418)
+#define __NR_mq_timedreceive_time64 (__NR_Linux + 419)
+#define __NR_semtimedop_time64 (__NR_Linux + 420)
+#define __NR_rt_sigtimedwait_time64 (__NR_Linux + 421)
+#define __NR_futex_time64 (__NR_Linux + 422)
+#define __NR_sched_rr_get_interval_time64 (__NR_Linux + 423)
+#define __NR_pidfd_send_signal (__NR_Linux + 424)
+#define __NR_io_uring_setup (__NR_Linux + 425)
+#define __NR_io_uring_enter (__NR_Linux + 426)
+#define __NR_io_uring_register (__NR_Linux + 427)
+#define __NR_open_tree (__NR_Linux + 428)
+#define __NR_move_mount (__NR_Linux + 429)
+#define __NR_fsopen (__NR_Linux + 430)
+#define __NR_fsconfig (__NR_Linux + 431)
+#define __NR_fsmount (__NR_Linux + 432)
+#define __NR_fspick (__NR_Linux + 433)
+#define __NR_pidfd_open (__NR_Linux + 434)
+#define __NR_clone3 (__NR_Linux + 435)
+#define __NR_close_range (__NR_Linux + 436)
+#define __NR_openat2 (__NR_Linux + 437)
+#define __NR_pidfd_getfd (__NR_Linux + 438)
+#define __NR_faccessat2 (__NR_Linux + 439)
+#define __NR_process_madvise (__NR_Linux + 440)
+#define __NR_epoll_pwait2 (__NR_Linux + 441)
+#define __NR_mount_setattr (__NR_Linux + 442)
+#define __NR_landlock_create_ruleset (__NR_Linux + 444)
+#define __NR_landlock_add_rule (__NR_Linux + 445)
+#define __NR_landlock_restrict_self (__NR_Linux + 446)
 
-
-#endif /* _ASM_MIPS_UNISTD_N32_H */
+#endif /* _ASM_UNISTD_N32_H */
diff --git a/linux-headers/asm-mips/unistd_n64.h b/linux-headers/asm-mips/unistd_n64.h
index 683558a7f8..0996001802 100644
--- a/linux-headers/asm-mips/unistd_n64.h
+++ b/linux-headers/asm-mips/unistd_n64.h
@@ -1,352 +1,355 @@
-#ifndef _ASM_MIPS_UNISTD_N64_H
-#define _ASM_MIPS_UNISTD_N64_H
+#ifndef _ASM_UNISTD_N64_H
+#define _ASM_UNISTD_N64_H
 
-#define __NR_read	(__NR_Linux + 0)
-#define __NR_write	(__NR_Linux + 1)
-#define __NR_open	(__NR_Linux + 2)
-#define __NR_close	(__NR_Linux + 3)
-#define __NR_stat	(__NR_Linux + 4)
-#define __NR_fstat	(__NR_Linux + 5)
-#define __NR_lstat	(__NR_Linux + 6)
-#define __NR_poll	(__NR_Linux + 7)
-#define __NR_lseek	(__NR_Linux + 8)
-#define __NR_mmap	(__NR_Linux + 9)
-#define __NR_mprotect	(__NR_Linux + 10)
-#define __NR_munmap	(__NR_Linux + 11)
-#define __NR_brk	(__NR_Linux + 12)
-#define __NR_rt_sigaction	(__NR_Linux + 13)
-#define __NR_rt_sigprocmask	(__NR_Linux + 14)
-#define __NR_ioctl	(__NR_Linux + 15)
-#define __NR_pread64	(__NR_Linux + 16)
-#define __NR_pwrite64	(__NR_Linux + 17)
-#define __NR_readv	(__NR_Linux + 18)
-#define __NR_writev	(__NR_Linux + 19)
-#define __NR_access	(__NR_Linux + 20)
-#define __NR_pipe	(__NR_Linux + 21)
-#define __NR__newselect	(__NR_Linux + 22)
-#define __NR_sched_yield	(__NR_Linux + 23)
-#define __NR_mremap	(__NR_Linux + 24)
-#define __NR_msync	(__NR_Linux + 25)
-#define __NR_mincore	(__NR_Linux + 26)
-#define __NR_madvise	(__NR_Linux + 27)
-#define __NR_shmget	(__NR_Linux + 28)
-#define __NR_shmat	(__NR_Linux + 29)
-#define __NR_shmctl	(__NR_Linux + 30)
-#define __NR_dup	(__NR_Linux + 31)
-#define __NR_dup2	(__NR_Linux + 32)
-#define __NR_pause	(__NR_Linux + 33)
-#define __NR_nanosleep	(__NR_Linux + 34)
-#define __NR_getitimer	(__NR_Linux + 35)
-#define __NR_setitimer	(__NR_Linux + 36)
-#define __NR_alarm	(__NR_Linux + 37)
-#define __NR_getpid	(__NR_Linux + 38)
-#define __NR_sendfile	(__NR_Linux + 39)
-#define __NR_socket	(__NR_Linux + 40)
-#define __NR_connect	(__NR_Linux + 41)
-#define __NR_accept	(__NR_Linux + 42)
-#define __NR_sendto	(__NR_Linux + 43)
-#define __NR_recvfrom	(__NR_Linux + 44)
-#define __NR_sendmsg	(__NR_Linux + 45)
-#define __NR_recvmsg	(__NR_Linux + 46)
-#define __NR_shutdown	(__NR_Linux + 47)
-#define __NR_bind	(__NR_Linux + 48)
-#define __NR_listen	(__NR_Linux + 49)
-#define __NR_getsockname	(__NR_Linux + 50)
-#define __NR_getpeername	(__NR_Linux + 51)
-#define __NR_socketpair	(__NR_Linux + 52)
-#define __NR_setsockopt	(__NR_Linux + 53)
-#define __NR_getsockopt	(__NR_Linux + 54)
-#define __NR_clone	(__NR_Linux + 55)
-#define __NR_fork	(__NR_Linux + 56)
-#define __NR_execve	(__NR_Linux + 57)
-#define __NR_exit	(__NR_Linux + 58)
-#define __NR_wait4	(__NR_Linux + 59)
-#define __NR_kill	(__NR_Linux + 60)
-#define __NR_uname	(__NR_Linux + 61)
-#define __NR_semget	(__NR_Linux + 62)
-#define __NR_semop	(__NR_Linux + 63)
-#define __NR_semctl	(__NR_Linux + 64)
-#define __NR_shmdt	(__NR_Linux + 65)
-#define __NR_msgget	(__NR_Linux + 66)
-#define __NR_msgsnd	(__NR_Linux + 67)
-#define __NR_msgrcv	(__NR_Linux + 68)
-#define __NR_msgctl	(__NR_Linux + 69)
-#define __NR_fcntl	(__NR_Linux + 70)
-#define __NR_flock	(__NR_Linux + 71)
-#define __NR_fsync	(__NR_Linux + 72)
-#define __NR_fdatasync	(__NR_Linux + 73)
-#define __NR_truncate	(__NR_Linux + 74)
-#define __NR_ftruncate	(__NR_Linux + 75)
-#define __NR_getdents	(__NR_Linux + 76)
-#define __NR_getcwd	(__NR_Linux + 77)
-#define __NR_chdir	(__NR_Linux + 78)
-#define __NR_fchdir	(__NR_Linux + 79)
-#define __NR_rename	(__NR_Linux + 80)
-#define __NR_mkdir	(__NR_Linux + 81)
-#define __NR_rmdir	(__NR_Linux + 82)
-#define __NR_creat	(__NR_Linux + 83)
-#define __NR_link	(__NR_Linux + 84)
-#define __NR_unlink	(__NR_Linux + 85)
-#define __NR_symlink	(__NR_Linux + 86)
-#define __NR_readlink	(__NR_Linux + 87)
-#define __NR_chmod	(__NR_Linux + 88)
-#define __NR_fchmod	(__NR_Linux + 89)
-#define __NR_chown	(__NR_Linux + 90)
-#define __NR_fchown	(__NR_Linux + 91)
-#define __NR_lchown	(__NR_Linux + 92)
-#define __NR_umask	(__NR_Linux + 93)
-#define __NR_gettimeofday	(__NR_Linux + 94)
-#define __NR_getrlimit	(__NR_Linux + 95)
-#define __NR_getrusage	(__NR_Linux + 96)
-#define __NR_sysinfo	(__NR_Linux + 97)
-#define __NR_times	(__NR_Linux + 98)
-#define __NR_ptrace	(__NR_Linux + 99)
-#define __NR_getuid	(__NR_Linux + 100)
-#define __NR_syslog	(__NR_Linux + 101)
-#define __NR_getgid	(__NR_Linux + 102)
-#define __NR_setuid	(__NR_Linux + 103)
-#define __NR_setgid	(__NR_Linux + 104)
-#define __NR_geteuid	(__NR_Linux + 105)
-#define __NR_getegid	(__NR_Linux + 106)
-#define __NR_setpgid	(__NR_Linux + 107)
-#define __NR_getppid	(__NR_Linux + 108)
-#define __NR_getpgrp	(__NR_Linux + 109)
-#define __NR_setsid	(__NR_Linux + 110)
-#define __NR_setreuid	(__NR_Linux + 111)
-#define __NR_setregid	(__NR_Linux + 112)
-#define __NR_getgroups	(__NR_Linux + 113)
-#define __NR_setgroups	(__NR_Linux + 114)
-#define __NR_setresuid	(__NR_Linux + 115)
-#define __NR_getresuid	(__NR_Linux + 116)
-#define __NR_setresgid	(__NR_Linux + 117)
-#define __NR_getresgid	(__NR_Linux + 118)
-#define __NR_getpgid	(__NR_Linux + 119)
-#define __NR_setfsuid	(__NR_Linux + 120)
-#define __NR_setfsgid	(__NR_Linux + 121)
-#define __NR_getsid	(__NR_Linux + 122)
-#define __NR_capget	(__NR_Linux + 123)
-#define __NR_capset	(__NR_Linux + 124)
-#define __NR_rt_sigpending	(__NR_Linux + 125)
-#define __NR_rt_sigtimedwait	(__NR_Linux + 126)
-#define __NR_rt_sigqueueinfo	(__NR_Linux + 127)
-#define __NR_rt_sigsuspend	(__NR_Linux + 128)
-#define __NR_sigaltstack	(__NR_Linux + 129)
-#define __NR_utime	(__NR_Linux + 130)
-#define __NR_mknod	(__NR_Linux + 131)
-#define __NR_personality	(__NR_Linux + 132)
-#define __NR_ustat	(__NR_Linux + 133)
-#define __NR_statfs	(__NR_Linux + 134)
-#define __NR_fstatfs	(__NR_Linux + 135)
-#define __NR_sysfs	(__NR_Linux + 136)
-#define __NR_getpriority	(__NR_Linux + 137)
-#define __NR_setpriority	(__NR_Linux + 138)
-#define __NR_sched_setparam	(__NR_Linux + 139)
-#define __NR_sched_getparam	(__NR_Linux + 140)
-#define __NR_sched_setscheduler	(__NR_Linux + 141)
-#define __NR_sched_getscheduler	(__NR_Linux + 142)
-#define __NR_sched_get_priority_max	(__NR_Linux + 143)
-#define __NR_sched_get_priority_min	(__NR_Linux + 144)
-#define __NR_sched_rr_get_interval	(__NR_Linux + 145)
-#define __NR_mlock	(__NR_Linux + 146)
-#define __NR_munlock	(__NR_Linux + 147)
-#define __NR_mlockall	(__NR_Linux + 148)
-#define __NR_munlockall	(__NR_Linux + 149)
-#define __NR_vhangup	(__NR_Linux + 150)
-#define __NR_pivot_root	(__NR_Linux + 151)
-#define __NR__sysctl	(__NR_Linux + 152)
-#define __NR_prctl	(__NR_Linux + 153)
-#define __NR_adjtimex	(__NR_Linux + 154)
-#define __NR_setrlimit	(__NR_Linux + 155)
-#define __NR_chroot	(__NR_Linux + 156)
-#define __NR_sync	(__NR_Linux + 157)
-#define __NR_acct	(__NR_Linux + 158)
-#define __NR_settimeofday	(__NR_Linux + 159)
-#define __NR_mount	(__NR_Linux + 160)
-#define __NR_umount2	(__NR_Linux + 161)
-#define __NR_swapon	(__NR_Linux + 162)
-#define __NR_swapoff	(__NR_Linux + 163)
-#define __NR_reboot	(__NR_Linux + 164)
-#define __NR_sethostname	(__NR_Linux + 165)
-#define __NR_setdomainname	(__NR_Linux + 166)
-#define __NR_create_module	(__NR_Linux + 167)
-#define __NR_init_module	(__NR_Linux + 168)
-#define __NR_delete_module	(__NR_Linux + 169)
-#define __NR_get_kernel_syms	(__NR_Linux + 170)
-#define __NR_query_module	(__NR_Linux + 171)
-#define __NR_quotactl	(__NR_Linux + 172)
-#define __NR_nfsservctl	(__NR_Linux + 173)
-#define __NR_getpmsg	(__NR_Linux + 174)
-#define __NR_putpmsg	(__NR_Linux + 175)
-#define __NR_afs_syscall	(__NR_Linux + 176)
-#define __NR_reserved177	(__NR_Linux + 177)
-#define __NR_gettid	(__NR_Linux + 178)
-#define __NR_readahead	(__NR_Linux + 179)
-#define __NR_setxattr	(__NR_Linux + 180)
-#define __NR_lsetxattr	(__NR_Linux + 181)
-#define __NR_fsetxattr	(__NR_Linux + 182)
-#define __NR_getxattr	(__NR_Linux + 183)
-#define __NR_lgetxattr	(__NR_Linux + 184)
-#define __NR_fgetxattr	(__NR_Linux + 185)
-#define __NR_listxattr	(__NR_Linux + 186)
-#define __NR_llistxattr	(__NR_Linux + 187)
-#define __NR_flistxattr	(__NR_Linux + 188)
-#define __NR_removexattr	(__NR_Linux + 189)
-#define __NR_lremovexattr	(__NR_Linux + 190)
-#define __NR_fremovexattr	(__NR_Linux + 191)
-#define __NR_tkill	(__NR_Linux + 192)
-#define __NR_reserved193	(__NR_Linux + 193)
-#define __NR_futex	(__NR_Linux + 194)
-#define __NR_sched_setaffinity	(__NR_Linux + 195)
-#define __NR_sched_getaffinity	(__NR_Linux + 196)
-#define __NR_cacheflush	(__NR_Linux + 197)
-#define __NR_cachectl	(__NR_Linux + 198)
-#define __NR_sysmips	(__NR_Linux + 199)
-#define __NR_io_setup	(__NR_Linux + 200)
-#define __NR_io_destroy	(__NR_Linux + 201)
-#define __NR_io_getevents	(__NR_Linux + 202)
-#define __NR_io_submit	(__NR_Linux + 203)
-#define __NR_io_cancel	(__NR_Linux + 204)
-#define __NR_exit_group	(__NR_Linux + 205)
-#define __NR_lookup_dcookie	(__NR_Linux + 206)
-#define __NR_epoll_create	(__NR_Linux + 207)
-#define __NR_epoll_ctl	(__NR_Linux + 208)
-#define __NR_epoll_wait	(__NR_Linux + 209)
-#define __NR_remap_file_pages	(__NR_Linux + 210)
-#define __NR_rt_sigreturn	(__NR_Linux + 211)
-#define __NR_set_tid_address	(__NR_Linux + 212)
-#define __NR_restart_syscall	(__NR_Linux + 213)
-#define __NR_semtimedop	(__NR_Linux + 214)
-#define __NR_fadvise64	(__NR_Linux + 215)
-#define __NR_timer_create	(__NR_Linux + 216)
-#define __NR_timer_settime	(__NR_Linux + 217)
-#define __NR_timer_gettime	(__NR_Linux + 218)
-#define __NR_timer_getoverrun	(__NR_Linux + 219)
-#define __NR_timer_delete	(__NR_Linux + 220)
-#define __NR_clock_settime	(__NR_Linux + 221)
-#define __NR_clock_gettime	(__NR_Linux + 222)
-#define __NR_clock_getres	(__NR_Linux + 223)
-#define __NR_clock_nanosleep	(__NR_Linux + 224)
-#define __NR_tgkill	(__NR_Linux + 225)
-#define __NR_utimes	(__NR_Linux + 226)
-#define __NR_mbind	(__NR_Linux + 227)
-#define __NR_get_mempolicy	(__NR_Linux + 228)
-#define __NR_set_mempolicy	(__NR_Linux + 229)
-#define __NR_mq_open	(__NR_Linux + 230)
-#define __NR_mq_unlink	(__NR_Linux + 231)
-#define __NR_mq_timedsend	(__NR_Linux + 232)
-#define __NR_mq_timedreceive	(__NR_Linux + 233)
-#define __NR_mq_notify	(__NR_Linux + 234)
-#define __NR_mq_getsetattr	(__NR_Linux + 235)
-#define __NR_vserver	(__NR_Linux + 236)
-#define __NR_waitid	(__NR_Linux + 237)
-#define __NR_add_key	(__NR_Linux + 239)
-#define __NR_request_key	(__NR_Linux + 240)
-#define __NR_keyctl	(__NR_Linux + 241)
-#define __NR_set_thread_area	(__NR_Linux + 242)
-#define __NR_inotify_init	(__NR_Linux + 243)
-#define __NR_inotify_add_watch	(__NR_Linux + 244)
-#define __NR_inotify_rm_watch	(__NR_Linux + 245)
-#define __NR_migrate_pages	(__NR_Linux + 246)
-#define __NR_openat	(__NR_Linux + 247)
-#define __NR_mkdirat	(__NR_Linux + 248)
-#define __NR_mknodat	(__NR_Linux + 249)
-#define __NR_fchownat	(__NR_Linux + 250)
-#define __NR_futimesat	(__NR_Linux + 251)
-#define __NR_newfstatat	(__NR_Linux + 252)
-#define __NR_unlinkat	(__NR_Linux + 253)
-#define __NR_renameat	(__NR_Linux + 254)
-#define __NR_linkat	(__NR_Linux + 255)
-#define __NR_symlinkat	(__NR_Linux + 256)
-#define __NR_readlinkat	(__NR_Linux + 257)
-#define __NR_fchmodat	(__NR_Linux + 258)
-#define __NR_faccessat	(__NR_Linux + 259)
-#define __NR_pselect6	(__NR_Linux + 260)
-#define __NR_ppoll	(__NR_Linux + 261)
-#define __NR_unshare	(__NR_Linux + 262)
-#define __NR_splice	(__NR_Linux + 263)
-#define __NR_sync_file_range	(__NR_Linux + 264)
-#define __NR_tee	(__NR_Linux + 265)
-#define __NR_vmsplice	(__NR_Linux + 266)
-#define __NR_move_pages	(__NR_Linux + 267)
-#define __NR_set_robust_list	(__NR_Linux + 268)
-#define __NR_get_robust_list	(__NR_Linux + 269)
-#define __NR_kexec_load	(__NR_Linux + 270)
-#define __NR_getcpu	(__NR_Linux + 271)
-#define __NR_epoll_pwait	(__NR_Linux + 272)
-#define __NR_ioprio_set	(__NR_Linux + 273)
-#define __NR_ioprio_get	(__NR_Linux + 274)
-#define __NR_utimensat	(__NR_Linux + 275)
-#define __NR_signalfd	(__NR_Linux + 276)
-#define __NR_timerfd	(__NR_Linux + 277)
-#define __NR_eventfd	(__NR_Linux + 278)
-#define __NR_fallocate	(__NR_Linux + 279)
-#define __NR_timerfd_create	(__NR_Linux + 280)
-#define __NR_timerfd_gettime	(__NR_Linux + 281)
-#define __NR_timerfd_settime	(__NR_Linux + 282)
-#define __NR_signalfd4	(__NR_Linux + 283)
-#define __NR_eventfd2	(__NR_Linux + 284)
-#define __NR_epoll_create1	(__NR_Linux + 285)
-#define __NR_dup3	(__NR_Linux + 286)
-#define __NR_pipe2	(__NR_Linux + 287)
-#define __NR_inotify_init1	(__NR_Linux + 288)
-#define __NR_preadv	(__NR_Linux + 289)
-#define __NR_pwritev	(__NR_Linux + 290)
-#define __NR_rt_tgsigqueueinfo	(__NR_Linux + 291)
-#define __NR_perf_event_open	(__NR_Linux + 292)
-#define __NR_accept4	(__NR_Linux + 293)
-#define __NR_recvmmsg	(__NR_Linux + 294)
-#define __NR_fanotify_init	(__NR_Linux + 295)
-#define __NR_fanotify_mark	(__NR_Linux + 296)
-#define __NR_prlimit64	(__NR_Linux + 297)
-#define __NR_name_to_handle_at	(__NR_Linux + 298)
-#define __NR_open_by_handle_at	(__NR_Linux + 299)
-#define __NR_clock_adjtime	(__NR_Linux + 300)
-#define __NR_syncfs	(__NR_Linux + 301)
-#define __NR_sendmmsg	(__NR_Linux + 302)
-#define __NR_setns	(__NR_Linux + 303)
-#define __NR_process_vm_readv	(__NR_Linux + 304)
-#define __NR_process_vm_writev	(__NR_Linux + 305)
-#define __NR_kcmp	(__NR_Linux + 306)
-#define __NR_finit_module	(__NR_Linux + 307)
-#define __NR_getdents64	(__NR_Linux + 308)
-#define __NR_sched_setattr	(__NR_Linux + 309)
-#define __NR_sched_getattr	(__NR_Linux + 310)
-#define __NR_renameat2	(__NR_Linux + 311)
-#define __NR_seccomp	(__NR_Linux + 312)
-#define __NR_getrandom	(__NR_Linux + 313)
-#define __NR_memfd_create	(__NR_Linux + 314)
-#define __NR_bpf	(__NR_Linux + 315)
-#define __NR_execveat	(__NR_Linux + 316)
-#define __NR_userfaultfd	(__NR_Linux + 317)
-#define __NR_membarrier	(__NR_Linux + 318)
-#define __NR_mlock2	(__NR_Linux + 319)
-#define __NR_copy_file_range	(__NR_Linux + 320)
-#define __NR_preadv2	(__NR_Linux + 321)
-#define __NR_pwritev2	(__NR_Linux + 322)
-#define __NR_pkey_mprotect	(__NR_Linux + 323)
-#define __NR_pkey_alloc	(__NR_Linux + 324)
-#define __NR_pkey_free	(__NR_Linux + 325)
-#define __NR_statx	(__NR_Linux + 326)
-#define __NR_rseq	(__NR_Linux + 327)
-#define __NR_io_pgetevents	(__NR_Linux + 328)
-#define __NR_pidfd_send_signal	(__NR_Linux + 424)
-#define __NR_io_uring_setup	(__NR_Linux + 425)
-#define __NR_io_uring_enter	(__NR_Linux + 426)
-#define __NR_io_uring_register	(__NR_Linux + 427)
-#define __NR_open_tree	(__NR_Linux + 428)
-#define __NR_move_mount	(__NR_Linux + 429)
-#define __NR_fsopen	(__NR_Linux + 430)
-#define __NR_fsconfig	(__NR_Linux + 431)
-#define __NR_fsmount	(__NR_Linux + 432)
-#define __NR_fspick	(__NR_Linux + 433)
-#define __NR_pidfd_open	(__NR_Linux + 434)
-#define __NR_clone3	(__NR_Linux + 435)
-#define __NR_close_range	(__NR_Linux + 436)
-#define __NR_openat2	(__NR_Linux + 437)
-#define __NR_pidfd_getfd	(__NR_Linux + 438)
-#define __NR_faccessat2	(__NR_Linux + 439)
-#define __NR_process_madvise	(__NR_Linux + 440)
-#define __NR_epoll_pwait2	(__NR_Linux + 441)
+#define __NR_read (__NR_Linux + 0)
+#define __NR_write (__NR_Linux + 1)
+#define __NR_open (__NR_Linux + 2)
+#define __NR_close (__NR_Linux + 3)
+#define __NR_stat (__NR_Linux + 4)
+#define __NR_fstat (__NR_Linux + 5)
+#define __NR_lstat (__NR_Linux + 6)
+#define __NR_poll (__NR_Linux + 7)
+#define __NR_lseek (__NR_Linux + 8)
+#define __NR_mmap (__NR_Linux + 9)
+#define __NR_mprotect (__NR_Linux + 10)
+#define __NR_munmap (__NR_Linux + 11)
+#define __NR_brk (__NR_Linux + 12)
+#define __NR_rt_sigaction (__NR_Linux + 13)
+#define __NR_rt_sigprocmask (__NR_Linux + 14)
+#define __NR_ioctl (__NR_Linux + 15)
+#define __NR_pread64 (__NR_Linux + 16)
+#define __NR_pwrite64 (__NR_Linux + 17)
+#define __NR_readv (__NR_Linux + 18)
+#define __NR_writev (__NR_Linux + 19)
+#define __NR_access (__NR_Linux + 20)
+#define __NR_pipe (__NR_Linux + 21)
+#define __NR__newselect (__NR_Linux + 22)
+#define __NR_sched_yield (__NR_Linux + 23)
+#define __NR_mremap (__NR_Linux + 24)
+#define __NR_msync (__NR_Linux + 25)
+#define __NR_mincore (__NR_Linux + 26)
+#define __NR_madvise (__NR_Linux + 27)
+#define __NR_shmget (__NR_Linux + 28)
+#define __NR_shmat (__NR_Linux + 29)
+#define __NR_shmctl (__NR_Linux + 30)
+#define __NR_dup (__NR_Linux + 31)
+#define __NR_dup2 (__NR_Linux + 32)
+#define __NR_pause (__NR_Linux + 33)
+#define __NR_nanosleep (__NR_Linux + 34)
+#define __NR_getitimer (__NR_Linux + 35)
+#define __NR_setitimer (__NR_Linux + 36)
+#define __NR_alarm (__NR_Linux + 37)
+#define __NR_getpid (__NR_Linux + 38)
+#define __NR_sendfile (__NR_Linux + 39)
+#define __NR_socket (__NR_Linux + 40)
+#define __NR_connect (__NR_Linux + 41)
+#define __NR_accept (__NR_Linux + 42)
+#define __NR_sendto (__NR_Linux + 43)
+#define __NR_recvfrom (__NR_Linux + 44)
+#define __NR_sendmsg (__NR_Linux + 45)
+#define __NR_recvmsg (__NR_Linux + 46)
+#define __NR_shutdown (__NR_Linux + 47)
+#define __NR_bind (__NR_Linux + 48)
+#define __NR_listen (__NR_Linux + 49)
+#define __NR_getsockname (__NR_Linux + 50)
+#define __NR_getpeername (__NR_Linux + 51)
+#define __NR_socketpair (__NR_Linux + 52)
+#define __NR_setsockopt (__NR_Linux + 53)
+#define __NR_getsockopt (__NR_Linux + 54)
+#define __NR_clone (__NR_Linux + 55)
+#define __NR_fork (__NR_Linux + 56)
+#define __NR_execve (__NR_Linux + 57)
+#define __NR_exit (__NR_Linux + 58)
+#define __NR_wait4 (__NR_Linux + 59)
+#define __NR_kill (__NR_Linux + 60)
+#define __NR_uname (__NR_Linux + 61)
+#define __NR_semget (__NR_Linux + 62)
+#define __NR_semop (__NR_Linux + 63)
+#define __NR_semctl (__NR_Linux + 64)
+#define __NR_shmdt (__NR_Linux + 65)
+#define __NR_msgget (__NR_Linux + 66)
+#define __NR_msgsnd (__NR_Linux + 67)
+#define __NR_msgrcv (__NR_Linux + 68)
+#define __NR_msgctl (__NR_Linux + 69)
+#define __NR_fcntl (__NR_Linux + 70)
+#define __NR_flock (__NR_Linux + 71)
+#define __NR_fsync (__NR_Linux + 72)
+#define __NR_fdatasync (__NR_Linux + 73)
+#define __NR_truncate (__NR_Linux + 74)
+#define __NR_ftruncate (__NR_Linux + 75)
+#define __NR_getdents (__NR_Linux + 76)
+#define __NR_getcwd (__NR_Linux + 77)
+#define __NR_chdir (__NR_Linux + 78)
+#define __NR_fchdir (__NR_Linux + 79)
+#define __NR_rename (__NR_Linux + 80)
+#define __NR_mkdir (__NR_Linux + 81)
+#define __NR_rmdir (__NR_Linux + 82)
+#define __NR_creat (__NR_Linux + 83)
+#define __NR_link (__NR_Linux + 84)
+#define __NR_unlink (__NR_Linux + 85)
+#define __NR_symlink (__NR_Linux + 86)
+#define __NR_readlink (__NR_Linux + 87)
+#define __NR_chmod (__NR_Linux + 88)
+#define __NR_fchmod (__NR_Linux + 89)
+#define __NR_chown (__NR_Linux + 90)
+#define __NR_fchown (__NR_Linux + 91)
+#define __NR_lchown (__NR_Linux + 92)
+#define __NR_umask (__NR_Linux + 93)
+#define __NR_gettimeofday (__NR_Linux + 94)
+#define __NR_getrlimit (__NR_Linux + 95)
+#define __NR_getrusage (__NR_Linux + 96)
+#define __NR_sysinfo (__NR_Linux + 97)
+#define __NR_times (__NR_Linux + 98)
+#define __NR_ptrace (__NR_Linux + 99)
+#define __NR_getuid (__NR_Linux + 100)
+#define __NR_syslog (__NR_Linux + 101)
+#define __NR_getgid (__NR_Linux + 102)
+#define __NR_setuid (__NR_Linux + 103)
+#define __NR_setgid (__NR_Linux + 104)
+#define __NR_geteuid (__NR_Linux + 105)
+#define __NR_getegid (__NR_Linux + 106)
+#define __NR_setpgid (__NR_Linux + 107)
+#define __NR_getppid (__NR_Linux + 108)
+#define __NR_getpgrp (__NR_Linux + 109)
+#define __NR_setsid (__NR_Linux + 110)
+#define __NR_setreuid (__NR_Linux + 111)
+#define __NR_setregid (__NR_Linux + 112)
+#define __NR_getgroups (__NR_Linux + 113)
+#define __NR_setgroups (__NR_Linux + 114)
+#define __NR_setresuid (__NR_Linux + 115)
+#define __NR_getresuid (__NR_Linux + 116)
+#define __NR_setresgid (__NR_Linux + 117)
+#define __NR_getresgid (__NR_Linux + 118)
+#define __NR_getpgid (__NR_Linux + 119)
+#define __NR_setfsuid (__NR_Linux + 120)
+#define __NR_setfsgid (__NR_Linux + 121)
+#define __NR_getsid (__NR_Linux + 122)
+#define __NR_capget (__NR_Linux + 123)
+#define __NR_capset (__NR_Linux + 124)
+#define __NR_rt_sigpending (__NR_Linux + 125)
+#define __NR_rt_sigtimedwait (__NR_Linux + 126)
+#define __NR_rt_sigqueueinfo (__NR_Linux + 127)
+#define __NR_rt_sigsuspend (__NR_Linux + 128)
+#define __NR_sigaltstack (__NR_Linux + 129)
+#define __NR_utime (__NR_Linux + 130)
+#define __NR_mknod (__NR_Linux + 131)
+#define __NR_personality (__NR_Linux + 132)
+#define __NR_ustat (__NR_Linux + 133)
+#define __NR_statfs (__NR_Linux + 134)
+#define __NR_fstatfs (__NR_Linux + 135)
+#define __NR_sysfs (__NR_Linux + 136)
+#define __NR_getpriority (__NR_Linux + 137)
+#define __NR_setpriority (__NR_Linux + 138)
+#define __NR_sched_setparam (__NR_Linux + 139)
+#define __NR_sched_getparam (__NR_Linux + 140)
+#define __NR_sched_setscheduler (__NR_Linux + 141)
+#define __NR_sched_getscheduler (__NR_Linux + 142)
+#define __NR_sched_get_priority_max (__NR_Linux + 143)
+#define __NR_sched_get_priority_min (__NR_Linux + 144)
+#define __NR_sched_rr_get_interval (__NR_Linux + 145)
+#define __NR_mlock (__NR_Linux + 146)
+#define __NR_munlock (__NR_Linux + 147)
+#define __NR_mlockall (__NR_Linux + 148)
+#define __NR_munlockall (__NR_Linux + 149)
+#define __NR_vhangup (__NR_Linux + 150)
+#define __NR_pivot_root (__NR_Linux + 151)
+#define __NR__sysctl (__NR_Linux + 152)
+#define __NR_prctl (__NR_Linux + 153)
+#define __NR_adjtimex (__NR_Linux + 154)
+#define __NR_setrlimit (__NR_Linux + 155)
+#define __NR_chroot (__NR_Linux + 156)
+#define __NR_sync (__NR_Linux + 157)
+#define __NR_acct (__NR_Linux + 158)
+#define __NR_settimeofday (__NR_Linux + 159)
+#define __NR_mount (__NR_Linux + 160)
+#define __NR_umount2 (__NR_Linux + 161)
+#define __NR_swapon (__NR_Linux + 162)
+#define __NR_swapoff (__NR_Linux + 163)
+#define __NR_reboot (__NR_Linux + 164)
+#define __NR_sethostname (__NR_Linux + 165)
+#define __NR_setdomainname (__NR_Linux + 166)
+#define __NR_create_module (__NR_Linux + 167)
+#define __NR_init_module (__NR_Linux + 168)
+#define __NR_delete_module (__NR_Linux + 169)
+#define __NR_get_kernel_syms (__NR_Linux + 170)
+#define __NR_query_module (__NR_Linux + 171)
+#define __NR_quotactl (__NR_Linux + 172)
+#define __NR_nfsservctl (__NR_Linux + 173)
+#define __NR_getpmsg (__NR_Linux + 174)
+#define __NR_putpmsg (__NR_Linux + 175)
+#define __NR_afs_syscall (__NR_Linux + 176)
+#define __NR_reserved177 (__NR_Linux + 177)
+#define __NR_gettid (__NR_Linux + 178)
+#define __NR_readahead (__NR_Linux + 179)
+#define __NR_setxattr (__NR_Linux + 180)
+#define __NR_lsetxattr (__NR_Linux + 181)
+#define __NR_fsetxattr (__NR_Linux + 182)
+#define __NR_getxattr (__NR_Linux + 183)
+#define __NR_lgetxattr (__NR_Linux + 184)
+#define __NR_fgetxattr (__NR_Linux + 185)
+#define __NR_listxattr (__NR_Linux + 186)
+#define __NR_llistxattr (__NR_Linux + 187)
+#define __NR_flistxattr (__NR_Linux + 188)
+#define __NR_removexattr (__NR_Linux + 189)
+#define __NR_lremovexattr (__NR_Linux + 190)
+#define __NR_fremovexattr (__NR_Linux + 191)
+#define __NR_tkill (__NR_Linux + 192)
+#define __NR_reserved193 (__NR_Linux + 193)
+#define __NR_futex (__NR_Linux + 194)
+#define __NR_sched_setaffinity (__NR_Linux + 195)
+#define __NR_sched_getaffinity (__NR_Linux + 196)
+#define __NR_cacheflush (__NR_Linux + 197)
+#define __NR_cachectl (__NR_Linux + 198)
+#define __NR_sysmips (__NR_Linux + 199)
+#define __NR_io_setup (__NR_Linux + 200)
+#define __NR_io_destroy (__NR_Linux + 201)
+#define __NR_io_getevents (__NR_Linux + 202)
+#define __NR_io_submit (__NR_Linux + 203)
+#define __NR_io_cancel (__NR_Linux + 204)
+#define __NR_exit_group (__NR_Linux + 205)
+#define __NR_lookup_dcookie (__NR_Linux + 206)
+#define __NR_epoll_create (__NR_Linux + 207)
+#define __NR_epoll_ctl (__NR_Linux + 208)
+#define __NR_epoll_wait (__NR_Linux + 209)
+#define __NR_remap_file_pages (__NR_Linux + 210)
+#define __NR_rt_sigreturn (__NR_Linux + 211)
+#define __NR_set_tid_address (__NR_Linux + 212)
+#define __NR_restart_syscall (__NR_Linux + 213)
+#define __NR_semtimedop (__NR_Linux + 214)
+#define __NR_fadvise64 (__NR_Linux + 215)
+#define __NR_timer_create (__NR_Linux + 216)
+#define __NR_timer_settime (__NR_Linux + 217)
+#define __NR_timer_gettime (__NR_Linux + 218)
+#define __NR_timer_getoverrun (__NR_Linux + 219)
+#define __NR_timer_delete (__NR_Linux + 220)
+#define __NR_clock_settime (__NR_Linux + 221)
+#define __NR_clock_gettime (__NR_Linux + 222)
+#define __NR_clock_getres (__NR_Linux + 223)
+#define __NR_clock_nanosleep (__NR_Linux + 224)
+#define __NR_tgkill (__NR_Linux + 225)
+#define __NR_utimes (__NR_Linux + 226)
+#define __NR_mbind (__NR_Linux + 227)
+#define __NR_get_mempolicy (__NR_Linux + 228)
+#define __NR_set_mempolicy (__NR_Linux + 229)
+#define __NR_mq_open (__NR_Linux + 230)
+#define __NR_mq_unlink (__NR_Linux + 231)
+#define __NR_mq_timedsend (__NR_Linux + 232)
+#define __NR_mq_timedreceive (__NR_Linux + 233)
+#define __NR_mq_notify (__NR_Linux + 234)
+#define __NR_mq_getsetattr (__NR_Linux + 235)
+#define __NR_vserver (__NR_Linux + 236)
+#define __NR_waitid (__NR_Linux + 237)
+#define __NR_add_key (__NR_Linux + 239)
+#define __NR_request_key (__NR_Linux + 240)
+#define __NR_keyctl (__NR_Linux + 241)
+#define __NR_set_thread_area (__NR_Linux + 242)
+#define __NR_inotify_init (__NR_Linux + 243)
+#define __NR_inotify_add_watch (__NR_Linux + 244)
+#define __NR_inotify_rm_watch (__NR_Linux + 245)
+#define __NR_migrate_pages (__NR_Linux + 246)
+#define __NR_openat (__NR_Linux + 247)
+#define __NR_mkdirat (__NR_Linux + 248)
+#define __NR_mknodat (__NR_Linux + 249)
+#define __NR_fchownat (__NR_Linux + 250)
+#define __NR_futimesat (__NR_Linux + 251)
+#define __NR_newfstatat (__NR_Linux + 252)
+#define __NR_unlinkat (__NR_Linux + 253)
+#define __NR_renameat (__NR_Linux + 254)
+#define __NR_linkat (__NR_Linux + 255)
+#define __NR_symlinkat (__NR_Linux + 256)
+#define __NR_readlinkat (__NR_Linux + 257)
+#define __NR_fchmodat (__NR_Linux + 258)
+#define __NR_faccessat (__NR_Linux + 259)
+#define __NR_pselect6 (__NR_Linux + 260)
+#define __NR_ppoll (__NR_Linux + 261)
+#define __NR_unshare (__NR_Linux + 262)
+#define __NR_splice (__NR_Linux + 263)
+#define __NR_sync_file_range (__NR_Linux + 264)
+#define __NR_tee (__NR_Linux + 265)
+#define __NR_vmsplice (__NR_Linux + 266)
+#define __NR_move_pages (__NR_Linux + 267)
+#define __NR_set_robust_list (__NR_Linux + 268)
+#define __NR_get_robust_list (__NR_Linux + 269)
+#define __NR_kexec_load (__NR_Linux + 270)
+#define __NR_getcpu (__NR_Linux + 271)
+#define __NR_epoll_pwait (__NR_Linux + 272)
+#define __NR_ioprio_set (__NR_Linux + 273)
+#define __NR_ioprio_get (__NR_Linux + 274)
+#define __NR_utimensat (__NR_Linux + 275)
+#define __NR_signalfd (__NR_Linux + 276)
+#define __NR_timerfd (__NR_Linux + 277)
+#define __NR_eventfd (__NR_Linux + 278)
+#define __NR_fallocate (__NR_Linux + 279)
+#define __NR_timerfd_create (__NR_Linux + 280)
+#define __NR_timerfd_gettime (__NR_Linux + 281)
+#define __NR_timerfd_settime (__NR_Linux + 282)
+#define __NR_signalfd4 (__NR_Linux + 283)
+#define __NR_eventfd2 (__NR_Linux + 284)
+#define __NR_epoll_create1 (__NR_Linux + 285)
+#define __NR_dup3 (__NR_Linux + 286)
+#define __NR_pipe2 (__NR_Linux + 287)
+#define __NR_inotify_init1 (__NR_Linux + 288)
+#define __NR_preadv (__NR_Linux + 289)
+#define __NR_pwritev (__NR_Linux + 290)
+#define __NR_rt_tgsigqueueinfo (__NR_Linux + 291)
+#define __NR_perf_event_open (__NR_Linux + 292)
+#define __NR_accept4 (__NR_Linux + 293)
+#define __NR_recvmmsg (__NR_Linux + 294)
+#define __NR_fanotify_init (__NR_Linux + 295)
+#define __NR_fanotify_mark (__NR_Linux + 296)
+#define __NR_prlimit64 (__NR_Linux + 297)
+#define __NR_name_to_handle_at (__NR_Linux + 298)
+#define __NR_open_by_handle_at (__NR_Linux + 299)
+#define __NR_clock_adjtime (__NR_Linux + 300)
+#define __NR_syncfs (__NR_Linux + 301)
+#define __NR_sendmmsg (__NR_Linux + 302)
+#define __NR_setns (__NR_Linux + 303)
+#define __NR_process_vm_readv (__NR_Linux + 304)
+#define __NR_process_vm_writev (__NR_Linux + 305)
+#define __NR_kcmp (__NR_Linux + 306)
+#define __NR_finit_module (__NR_Linux + 307)
+#define __NR_getdents64 (__NR_Linux + 308)
+#define __NR_sched_setattr (__NR_Linux + 309)
+#define __NR_sched_getattr (__NR_Linux + 310)
+#define __NR_renameat2 (__NR_Linux + 311)
+#define __NR_seccomp (__NR_Linux + 312)
+#define __NR_getrandom (__NR_Linux + 313)
+#define __NR_memfd_create (__NR_Linux + 314)
+#define __NR_bpf (__NR_Linux + 315)
+#define __NR_execveat (__NR_Linux + 316)
+#define __NR_userfaultfd (__NR_Linux + 317)
+#define __NR_membarrier (__NR_Linux + 318)
+#define __NR_mlock2 (__NR_Linux + 319)
+#define __NR_copy_file_range (__NR_Linux + 320)
+#define __NR_preadv2 (__NR_Linux + 321)
+#define __NR_pwritev2 (__NR_Linux + 322)
+#define __NR_pkey_mprotect (__NR_Linux + 323)
+#define __NR_pkey_alloc (__NR_Linux + 324)
+#define __NR_pkey_free (__NR_Linux + 325)
+#define __NR_statx (__NR_Linux + 326)
+#define __NR_rseq (__NR_Linux + 327)
+#define __NR_io_pgetevents (__NR_Linux + 328)
+#define __NR_pidfd_send_signal (__NR_Linux + 424)
+#define __NR_io_uring_setup (__NR_Linux + 425)
+#define __NR_io_uring_enter (__NR_Linux + 426)
+#define __NR_io_uring_register (__NR_Linux + 427)
+#define __NR_open_tree (__NR_Linux + 428)
+#define __NR_move_mount (__NR_Linux + 429)
+#define __NR_fsopen (__NR_Linux + 430)
+#define __NR_fsconfig (__NR_Linux + 431)
+#define __NR_fsmount (__NR_Linux + 432)
+#define __NR_fspick (__NR_Linux + 433)
+#define __NR_pidfd_open (__NR_Linux + 434)
+#define __NR_clone3 (__NR_Linux + 435)
+#define __NR_close_range (__NR_Linux + 436)
+#define __NR_openat2 (__NR_Linux + 437)
+#define __NR_pidfd_getfd (__NR_Linux + 438)
+#define __NR_faccessat2 (__NR_Linux + 439)
+#define __NR_process_madvise (__NR_Linux + 440)
+#define __NR_epoll_pwait2 (__NR_Linux + 441)
+#define __NR_mount_setattr (__NR_Linux + 442)
+#define __NR_landlock_create_ruleset (__NR_Linux + 444)
+#define __NR_landlock_add_rule (__NR_Linux + 445)
+#define __NR_landlock_restrict_self (__NR_Linux + 446)
 
-
-#endif /* _ASM_MIPS_UNISTD_N64_H */
+#endif /* _ASM_UNISTD_N64_H */
diff --git a/linux-headers/asm-mips/unistd_o32.h b/linux-headers/asm-mips/unistd_o32.h
index ca6a7e5c0b..954303ad69 100644
--- a/linux-headers/asm-mips/unistd_o32.h
+++ b/linux-headers/asm-mips/unistd_o32.h
@@ -1,422 +1,425 @@
-#ifndef _ASM_MIPS_UNISTD_O32_H
-#define _ASM_MIPS_UNISTD_O32_H
+#ifndef _ASM_UNISTD_O32_H
+#define _ASM_UNISTD_O32_H
 
-#define __NR_syscall	(__NR_Linux + 0)
-#define __NR_exit	(__NR_Linux + 1)
-#define __NR_fork	(__NR_Linux + 2)
-#define __NR_read	(__NR_Linux + 3)
-#define __NR_write	(__NR_Linux + 4)
-#define __NR_open	(__NR_Linux + 5)
-#define __NR_close	(__NR_Linux + 6)
-#define __NR_waitpid	(__NR_Linux + 7)
-#define __NR_creat	(__NR_Linux + 8)
-#define __NR_link	(__NR_Linux + 9)
-#define __NR_unlink	(__NR_Linux + 10)
-#define __NR_execve	(__NR_Linux + 11)
-#define __NR_chdir	(__NR_Linux + 12)
-#define __NR_time	(__NR_Linux + 13)
-#define __NR_mknod	(__NR_Linux + 14)
-#define __NR_chmod	(__NR_Linux + 15)
-#define __NR_lchown	(__NR_Linux + 16)
-#define __NR_break	(__NR_Linux + 17)
-#define __NR_unused18	(__NR_Linux + 18)
-#define __NR_lseek	(__NR_Linux + 19)
-#define __NR_getpid	(__NR_Linux + 20)
-#define __NR_mount	(__NR_Linux + 21)
-#define __NR_umount	(__NR_Linux + 22)
-#define __NR_setuid	(__NR_Linux + 23)
-#define __NR_getuid	(__NR_Linux + 24)
-#define __NR_stime	(__NR_Linux + 25)
-#define __NR_ptrace	(__NR_Linux + 26)
-#define __NR_alarm	(__NR_Linux + 27)
-#define __NR_unused28	(__NR_Linux + 28)
-#define __NR_pause	(__NR_Linux + 29)
-#define __NR_utime	(__NR_Linux + 30)
-#define __NR_stty	(__NR_Linux + 31)
-#define __NR_gtty	(__NR_Linux + 32)
-#define __NR_access	(__NR_Linux + 33)
-#define __NR_nice	(__NR_Linux + 34)
-#define __NR_ftime	(__NR_Linux + 35)
-#define __NR_sync	(__NR_Linux + 36)
-#define __NR_kill	(__NR_Linux + 37)
-#define __NR_rename	(__NR_Linux + 38)
-#define __NR_mkdir	(__NR_Linux + 39)
-#define __NR_rmdir	(__NR_Linux + 40)
-#define __NR_dup	(__NR_Linux + 41)
-#define __NR_pipe	(__NR_Linux + 42)
-#define __NR_times	(__NR_Linux + 43)
-#define __NR_prof	(__NR_Linux + 44)
-#define __NR_brk	(__NR_Linux + 45)
-#define __NR_setgid	(__NR_Linux + 46)
-#define __NR_getgid	(__NR_Linux + 47)
-#define __NR_signal	(__NR_Linux + 48)
-#define __NR_geteuid	(__NR_Linux + 49)
-#define __NR_getegid	(__NR_Linux + 50)
-#define __NR_acct	(__NR_Linux + 51)
-#define __NR_umount2	(__NR_Linux + 52)
-#define __NR_lock	(__NR_Linux + 53)
-#define __NR_ioctl	(__NR_Linux + 54)
-#define __NR_fcntl	(__NR_Linux + 55)
-#define __NR_mpx	(__NR_Linux + 56)
-#define __NR_setpgid	(__NR_Linux + 57)
-#define __NR_ulimit	(__NR_Linux + 58)
-#define __NR_unused59	(__NR_Linux + 59)
-#define __NR_umask	(__NR_Linux + 60)
-#define __NR_chroot	(__NR_Linux + 61)
-#define __NR_ustat	(__NR_Linux + 62)
-#define __NR_dup2	(__NR_Linux + 63)
-#define __NR_getppid	(__NR_Linux + 64)
-#define __NR_getpgrp	(__NR_Linux + 65)
-#define __NR_setsid	(__NR_Linux + 66)
-#define __NR_sigaction	(__NR_Linux + 67)
-#define __NR_sgetmask	(__NR_Linux + 68)
-#define __NR_ssetmask	(__NR_Linux + 69)
-#define __NR_setreuid	(__NR_Linux + 70)
-#define __NR_setregid	(__NR_Linux + 71)
-#define __NR_sigsuspend	(__NR_Linux + 72)
-#define __NR_sigpending	(__NR_Linux + 73)
-#define __NR_sethostname	(__NR_Linux + 74)
-#define __NR_setrlimit	(__NR_Linux + 75)
-#define __NR_getrlimit	(__NR_Linux + 76)
-#define __NR_getrusage	(__NR_Linux + 77)
-#define __NR_gettimeofday	(__NR_Linux + 78)
-#define __NR_settimeofday	(__NR_Linux + 79)
-#define __NR_getgroups	(__NR_Linux + 80)
-#define __NR_setgroups	(__NR_Linux + 81)
-#define __NR_reserved82	(__NR_Linux + 82)
-#define __NR_symlink	(__NR_Linux + 83)
-#define __NR_unused84	(__NR_Linux + 84)
-#define __NR_readlink	(__NR_Linux + 85)
-#define __NR_uselib	(__NR_Linux + 86)
-#define __NR_swapon	(__NR_Linux + 87)
-#define __NR_reboot	(__NR_Linux + 88)
-#define __NR_readdir	(__NR_Linux + 89)
-#define __NR_mmap	(__NR_Linux + 90)
-#define __NR_munmap	(__NR_Linux + 91)
-#define __NR_truncate	(__NR_Linux + 92)
-#define __NR_ftruncate	(__NR_Linux + 93)
-#define __NR_fchmod	(__NR_Linux + 94)
-#define __NR_fchown	(__NR_Linux + 95)
-#define __NR_getpriority	(__NR_Linux + 96)
-#define __NR_setpriority	(__NR_Linux + 97)
-#define __NR_profil	(__NR_Linux + 98)
-#define __NR_statfs	(__NR_Linux + 99)
-#define __NR_fstatfs	(__NR_Linux + 100)
-#define __NR_ioperm	(__NR_Linux + 101)
-#define __NR_socketcall	(__NR_Linux + 102)
-#define __NR_syslog	(__NR_Linux + 103)
-#define __NR_setitimer	(__NR_Linux + 104)
-#define __NR_getitimer	(__NR_Linux + 105)
-#define __NR_stat	(__NR_Linux + 106)
-#define __NR_lstat	(__NR_Linux + 107)
-#define __NR_fstat	(__NR_Linux + 108)
-#define __NR_unused109	(__NR_Linux + 109)
-#define __NR_iopl	(__NR_Linux + 110)
-#define __NR_vhangup	(__NR_Linux + 111)
-#define __NR_idle	(__NR_Linux + 112)
-#define __NR_vm86	(__NR_Linux + 113)
-#define __NR_wait4	(__NR_Linux + 114)
-#define __NR_swapoff	(__NR_Linux + 115)
-#define __NR_sysinfo	(__NR_Linux + 116)
-#define __NR_ipc	(__NR_Linux + 117)
-#define __NR_fsync	(__NR_Linux + 118)
-#define __NR_sigreturn	(__NR_Linux + 119)
-#define __NR_clone	(__NR_Linux + 120)
-#define __NR_setdomainname	(__NR_Linux + 121)
-#define __NR_uname	(__NR_Linux + 122)
-#define __NR_modify_ldt	(__NR_Linux + 123)
-#define __NR_adjtimex	(__NR_Linux + 124)
-#define __NR_mprotect	(__NR_Linux + 125)
-#define __NR_sigprocmask	(__NR_Linux + 126)
-#define __NR_create_module	(__NR_Linux + 127)
-#define __NR_init_module	(__NR_Linux + 128)
-#define __NR_delete_module	(__NR_Linux + 129)
-#define __NR_get_kernel_syms	(__NR_Linux + 130)
-#define __NR_quotactl	(__NR_Linux + 131)
-#define __NR_getpgid	(__NR_Linux + 132)
-#define __NR_fchdir	(__NR_Linux + 133)
-#define __NR_bdflush	(__NR_Linux + 134)
-#define __NR_sysfs	(__NR_Linux + 135)
-#define __NR_personality	(__NR_Linux + 136)
-#define __NR_afs_syscall	(__NR_Linux + 137)
-#define __NR_setfsuid	(__NR_Linux + 138)
-#define __NR_setfsgid	(__NR_Linux + 139)
-#define __NR__llseek	(__NR_Linux + 140)
-#define __NR_getdents	(__NR_Linux + 141)
-#define __NR__newselect	(__NR_Linux + 142)
-#define __NR_flock	(__NR_Linux + 143)
-#define __NR_msync	(__NR_Linux + 144)
-#define __NR_readv	(__NR_Linux + 145)
-#define __NR_writev	(__NR_Linux + 146)
-#define __NR_cacheflush	(__NR_Linux + 147)
-#define __NR_cachectl	(__NR_Linux + 148)
-#define __NR_sysmips	(__NR_Linux + 149)
-#define __NR_unused150	(__NR_Linux + 150)
-#define __NR_getsid	(__NR_Linux + 151)
-#define __NR_fdatasync	(__NR_Linux + 152)
-#define __NR__sysctl	(__NR_Linux + 153)
-#define __NR_mlock	(__NR_Linux + 154)
-#define __NR_munlock	(__NR_Linux + 155)
-#define __NR_mlockall	(__NR_Linux + 156)
-#define __NR_munlockall	(__NR_Linux + 157)
-#define __NR_sched_setparam	(__NR_Linux + 158)
-#define __NR_sched_getparam	(__NR_Linux + 159)
-#define __NR_sched_setscheduler	(__NR_Linux + 160)
-#define __NR_sched_getscheduler	(__NR_Linux + 161)
-#define __NR_sched_yield	(__NR_Linux + 162)
-#define __NR_sched_get_priority_max	(__NR_Linux + 163)
-#define __NR_sched_get_priority_min	(__NR_Linux + 164)
-#define __NR_sched_rr_get_interval	(__NR_Linux + 165)
-#define __NR_nanosleep	(__NR_Linux + 166)
-#define __NR_mremap	(__NR_Linux + 167)
-#define __NR_accept	(__NR_Linux + 168)
-#define __NR_bind	(__NR_Linux + 169)
-#define __NR_connect	(__NR_Linux + 170)
-#define __NR_getpeername	(__NR_Linux + 171)
-#define __NR_getsockname	(__NR_Linux + 172)
-#define __NR_getsockopt	(__NR_Linux + 173)
-#define __NR_listen	(__NR_Linux + 174)
-#define __NR_recv	(__NR_Linux + 175)
-#define __NR_recvfrom	(__NR_Linux + 176)
-#define __NR_recvmsg	(__NR_Linux + 177)
-#define __NR_send	(__NR_Linux + 178)
-#define __NR_sendmsg	(__NR_Linux + 179)
-#define __NR_sendto	(__NR_Linux + 180)
-#define __NR_setsockopt	(__NR_Linux + 181)
-#define __NR_shutdown	(__NR_Linux + 182)
-#define __NR_socket	(__NR_Linux + 183)
-#define __NR_socketpair	(__NR_Linux + 184)
-#define __NR_setresuid	(__NR_Linux + 185)
-#define __NR_getresuid	(__NR_Linux + 186)
-#define __NR_query_module	(__NR_Linux + 187)
-#define __NR_poll	(__NR_Linux + 188)
-#define __NR_nfsservctl	(__NR_Linux + 189)
-#define __NR_setresgid	(__NR_Linux + 190)
-#define __NR_getresgid	(__NR_Linux + 191)
-#define __NR_prctl	(__NR_Linux + 192)
-#define __NR_rt_sigreturn	(__NR_Linux + 193)
-#define __NR_rt_sigaction	(__NR_Linux + 194)
-#define __NR_rt_sigprocmask	(__NR_Linux + 195)
-#define __NR_rt_sigpending	(__NR_Linux + 196)
-#define __NR_rt_sigtimedwait	(__NR_Linux + 197)
-#define __NR_rt_sigqueueinfo	(__NR_Linux + 198)
-#define __NR_rt_sigsuspend	(__NR_Linux + 199)
-#define __NR_pread64	(__NR_Linux + 200)
-#define __NR_pwrite64	(__NR_Linux + 201)
-#define __NR_chown	(__NR_Linux + 202)
-#define __NR_getcwd	(__NR_Linux + 203)
-#define __NR_capget	(__NR_Linux + 204)
-#define __NR_capset	(__NR_Linux + 205)
-#define __NR_sigaltstack	(__NR_Linux + 206)
-#define __NR_sendfile	(__NR_Linux + 207)
-#define __NR_getpmsg	(__NR_Linux + 208)
-#define __NR_putpmsg	(__NR_Linux + 209)
-#define __NR_mmap2	(__NR_Linux + 210)
-#define __NR_truncate64	(__NR_Linux + 211)
-#define __NR_ftruncate64	(__NR_Linux + 212)
-#define __NR_stat64	(__NR_Linux + 213)
-#define __NR_lstat64	(__NR_Linux + 214)
-#define __NR_fstat64	(__NR_Linux + 215)
-#define __NR_pivot_root	(__NR_Linux + 216)
-#define __NR_mincore	(__NR_Linux + 217)
-#define __NR_madvise	(__NR_Linux + 218)
-#define __NR_getdents64	(__NR_Linux + 219)
-#define __NR_fcntl64	(__NR_Linux + 220)
-#define __NR_reserved221	(__NR_Linux + 221)
-#define __NR_gettid	(__NR_Linux + 222)
-#define __NR_readahead	(__NR_Linux + 223)
-#define __NR_setxattr	(__NR_Linux + 224)
-#define __NR_lsetxattr	(__NR_Linux + 225)
-#define __NR_fsetxattr	(__NR_Linux + 226)
-#define __NR_getxattr	(__NR_Linux + 227)
-#define __NR_lgetxattr	(__NR_Linux + 228)
-#define __NR_fgetxattr	(__NR_Linux + 229)
-#define __NR_listxattr	(__NR_Linux + 230)
-#define __NR_llistxattr	(__NR_Linux + 231)
-#define __NR_flistxattr	(__NR_Linux + 232)
-#define __NR_removexattr	(__NR_Linux + 233)
-#define __NR_lremovexattr	(__NR_Linux + 234)
-#define __NR_fremovexattr	(__NR_Linux + 235)
-#define __NR_tkill	(__NR_Linux + 236)
-#define __NR_sendfile64	(__NR_Linux + 237)
-#define __NR_futex	(__NR_Linux + 238)
-#define __NR_sched_setaffinity	(__NR_Linux + 239)
-#define __NR_sched_getaffinity	(__NR_Linux + 240)
-#define __NR_io_setup	(__NR_Linux + 241)
-#define __NR_io_destroy	(__NR_Linux + 242)
-#define __NR_io_getevents	(__NR_Linux + 243)
-#define __NR_io_submit	(__NR_Linux + 244)
-#define __NR_io_cancel	(__NR_Linux + 245)
-#define __NR_exit_group	(__NR_Linux + 246)
-#define __NR_lookup_dcookie	(__NR_Linux + 247)
-#define __NR_epoll_create	(__NR_Linux + 248)
-#define __NR_epoll_ctl	(__NR_Linux + 249)
-#define __NR_epoll_wait	(__NR_Linux + 250)
-#define __NR_remap_file_pages	(__NR_Linux + 251)
-#define __NR_set_tid_address	(__NR_Linux + 252)
-#define __NR_restart_syscall	(__NR_Linux + 253)
-#define __NR_fadvise64	(__NR_Linux + 254)
-#define __NR_statfs64	(__NR_Linux + 255)
-#define __NR_fstatfs64	(__NR_Linux + 256)
-#define __NR_timer_create	(__NR_Linux + 257)
-#define __NR_timer_settime	(__NR_Linux + 258)
-#define __NR_timer_gettime	(__NR_Linux + 259)
-#define __NR_timer_getoverrun	(__NR_Linux + 260)
-#define __NR_timer_delete	(__NR_Linux + 261)
-#define __NR_clock_settime	(__NR_Linux + 262)
-#define __NR_clock_gettime	(__NR_Linux + 263)
-#define __NR_clock_getres	(__NR_Linux + 264)
-#define __NR_clock_nanosleep	(__NR_Linux + 265)
-#define __NR_tgkill	(__NR_Linux + 266)
-#define __NR_utimes	(__NR_Linux + 267)
-#define __NR_mbind	(__NR_Linux + 268)
-#define __NR_get_mempolicy	(__NR_Linux + 269)
-#define __NR_set_mempolicy	(__NR_Linux + 270)
-#define __NR_mq_open	(__NR_Linux + 271)
-#define __NR_mq_unlink	(__NR_Linux + 272)
-#define __NR_mq_timedsend	(__NR_Linux + 273)
-#define __NR_mq_timedreceive	(__NR_Linux + 274)
-#define __NR_mq_notify	(__NR_Linux + 275)
-#define __NR_mq_getsetattr	(__NR_Linux + 276)
-#define __NR_vserver	(__NR_Linux + 277)
-#define __NR_waitid	(__NR_Linux + 278)
-#define __NR_add_key	(__NR_Linux + 280)
-#define __NR_request_key	(__NR_Linux + 281)
-#define __NR_keyctl	(__NR_Linux + 282)
-#define __NR_set_thread_area	(__NR_Linux + 283)
-#define __NR_inotify_init	(__NR_Linux + 284)
-#define __NR_inotify_add_watch	(__NR_Linux + 285)
-#define __NR_inotify_rm_watch	(__NR_Linux + 286)
-#define __NR_migrate_pages	(__NR_Linux + 287)
-#define __NR_openat	(__NR_Linux + 288)
-#define __NR_mkdirat	(__NR_Linux + 289)
-#define __NR_mknodat	(__NR_Linux + 290)
-#define __NR_fchownat	(__NR_Linux + 291)
-#define __NR_futimesat	(__NR_Linux + 292)
-#define __NR_fstatat64	(__NR_Linux + 293)
-#define __NR_unlinkat	(__NR_Linux + 294)
-#define __NR_renameat	(__NR_Linux + 295)
-#define __NR_linkat	(__NR_Linux + 296)
-#define __NR_symlinkat	(__NR_Linux + 297)
-#define __NR_readlinkat	(__NR_Linux + 298)
-#define __NR_fchmodat	(__NR_Linux + 299)
-#define __NR_faccessat	(__NR_Linux + 300)
-#define __NR_pselect6	(__NR_Linux + 301)
-#define __NR_ppoll	(__NR_Linux + 302)
-#define __NR_unshare	(__NR_Linux + 303)
-#define __NR_splice	(__NR_Linux + 304)
-#define __NR_sync_file_range	(__NR_Linux + 305)
-#define __NR_tee	(__NR_Linux + 306)
-#define __NR_vmsplice	(__NR_Linux + 307)
-#define __NR_move_pages	(__NR_Linux + 308)
-#define __NR_set_robust_list	(__NR_Linux + 309)
-#define __NR_get_robust_list	(__NR_Linux + 310)
-#define __NR_kexec_load	(__NR_Linux + 311)
-#define __NR_getcpu	(__NR_Linux + 312)
-#define __NR_epoll_pwait	(__NR_Linux + 313)
-#define __NR_ioprio_set	(__NR_Linux + 314)
-#define __NR_ioprio_get	(__NR_Linux + 315)
-#define __NR_utimensat	(__NR_Linux + 316)
-#define __NR_signalfd	(__NR_Linux + 317)
-#define __NR_timerfd	(__NR_Linux + 318)
-#define __NR_eventfd	(__NR_Linux + 319)
-#define __NR_fallocate	(__NR_Linux + 320)
-#define __NR_timerfd_create	(__NR_Linux + 321)
-#define __NR_timerfd_gettime	(__NR_Linux + 322)
-#define __NR_timerfd_settime	(__NR_Linux + 323)
-#define __NR_signalfd4	(__NR_Linux + 324)
-#define __NR_eventfd2	(__NR_Linux + 325)
-#define __NR_epoll_create1	(__NR_Linux + 326)
-#define __NR_dup3	(__NR_Linux + 327)
-#define __NR_pipe2	(__NR_Linux + 328)
-#define __NR_inotify_init1	(__NR_Linux + 329)
-#define __NR_preadv	(__NR_Linux + 330)
-#define __NR_pwritev	(__NR_Linux + 331)
-#define __NR_rt_tgsigqueueinfo	(__NR_Linux + 332)
-#define __NR_perf_event_open	(__NR_Linux + 333)
-#define __NR_accept4	(__NR_Linux + 334)
-#define __NR_recvmmsg	(__NR_Linux + 335)
-#define __NR_fanotify_init	(__NR_Linux + 336)
-#define __NR_fanotify_mark	(__NR_Linux + 337)
-#define __NR_prlimit64	(__NR_Linux + 338)
-#define __NR_name_to_handle_at	(__NR_Linux + 339)
-#define __NR_open_by_handle_at	(__NR_Linux + 340)
-#define __NR_clock_adjtime	(__NR_Linux + 341)
-#define __NR_syncfs	(__NR_Linux + 342)
-#define __NR_sendmmsg	(__NR_Linux + 343)
-#define __NR_setns	(__NR_Linux + 344)
-#define __NR_process_vm_readv	(__NR_Linux + 345)
-#define __NR_process_vm_writev	(__NR_Linux + 346)
-#define __NR_kcmp	(__NR_Linux + 347)
-#define __NR_finit_module	(__NR_Linux + 348)
-#define __NR_sched_setattr	(__NR_Linux + 349)
-#define __NR_sched_getattr	(__NR_Linux + 350)
-#define __NR_renameat2	(__NR_Linux + 351)
-#define __NR_seccomp	(__NR_Linux + 352)
-#define __NR_getrandom	(__NR_Linux + 353)
-#define __NR_memfd_create	(__NR_Linux + 354)
-#define __NR_bpf	(__NR_Linux + 355)
-#define __NR_execveat	(__NR_Linux + 356)
-#define __NR_userfaultfd	(__NR_Linux + 357)
-#define __NR_membarrier	(__NR_Linux + 358)
-#define __NR_mlock2	(__NR_Linux + 359)
-#define __NR_copy_file_range	(__NR_Linux + 360)
-#define __NR_preadv2	(__NR_Linux + 361)
-#define __NR_pwritev2	(__NR_Linux + 362)
-#define __NR_pkey_mprotect	(__NR_Linux + 363)
-#define __NR_pkey_alloc	(__NR_Linux + 364)
-#define __NR_pkey_free	(__NR_Linux + 365)
-#define __NR_statx	(__NR_Linux + 366)
-#define __NR_rseq	(__NR_Linux + 367)
-#define __NR_io_pgetevents	(__NR_Linux + 368)
-#define __NR_semget	(__NR_Linux + 393)
-#define __NR_semctl	(__NR_Linux + 394)
-#define __NR_shmget	(__NR_Linux + 395)
-#define __NR_shmctl	(__NR_Linux + 396)
-#define __NR_shmat	(__NR_Linux + 397)
-#define __NR_shmdt	(__NR_Linux + 398)
-#define __NR_msgget	(__NR_Linux + 399)
-#define __NR_msgsnd	(__NR_Linux + 400)
-#define __NR_msgrcv	(__NR_Linux + 401)
-#define __NR_msgctl	(__NR_Linux + 402)
-#define __NR_clock_gettime64	(__NR_Linux + 403)
-#define __NR_clock_settime64	(__NR_Linux + 404)
-#define __NR_clock_adjtime64	(__NR_Linux + 405)
-#define __NR_clock_getres_time64	(__NR_Linux + 406)
-#define __NR_clock_nanosleep_time64	(__NR_Linux + 407)
-#define __NR_timer_gettime64	(__NR_Linux + 408)
-#define __NR_timer_settime64	(__NR_Linux + 409)
-#define __NR_timerfd_gettime64	(__NR_Linux + 410)
-#define __NR_timerfd_settime64	(__NR_Linux + 411)
-#define __NR_utimensat_time64	(__NR_Linux + 412)
-#define __NR_pselect6_time64	(__NR_Linux + 413)
-#define __NR_ppoll_time64	(__NR_Linux + 414)
-#define __NR_io_pgetevents_time64	(__NR_Linux + 416)
-#define __NR_recvmmsg_time64	(__NR_Linux + 417)
-#define __NR_mq_timedsend_time64	(__NR_Linux + 418)
-#define __NR_mq_timedreceive_time64	(__NR_Linux + 419)
-#define __NR_semtimedop_time64	(__NR_Linux + 420)
-#define __NR_rt_sigtimedwait_time64	(__NR_Linux + 421)
-#define __NR_futex_time64	(__NR_Linux + 422)
-#define __NR_sched_rr_get_interval_time64	(__NR_Linux + 423)
-#define __NR_pidfd_send_signal	(__NR_Linux + 424)
-#define __NR_io_uring_setup	(__NR_Linux + 425)
-#define __NR_io_uring_enter	(__NR_Linux + 426)
-#define __NR_io_uring_register	(__NR_Linux + 427)
-#define __NR_open_tree	(__NR_Linux + 428)
-#define __NR_move_mount	(__NR_Linux + 429)
-#define __NR_fsopen	(__NR_Linux + 430)
-#define __NR_fsconfig	(__NR_Linux + 431)
-#define __NR_fsmount	(__NR_Linux + 432)
-#define __NR_fspick	(__NR_Linux + 433)
-#define __NR_pidfd_open	(__NR_Linux + 434)
-#define __NR_clone3	(__NR_Linux + 435)
-#define __NR_close_range	(__NR_Linux + 436)
-#define __NR_openat2	(__NR_Linux + 437)
-#define __NR_pidfd_getfd	(__NR_Linux + 438)
-#define __NR_faccessat2	(__NR_Linux + 439)
-#define __NR_process_madvise	(__NR_Linux + 440)
-#define __NR_epoll_pwait2	(__NR_Linux + 441)
+#define __NR_syscall (__NR_Linux + 0)
+#define __NR_exit (__NR_Linux + 1)
+#define __NR_fork (__NR_Linux + 2)
+#define __NR_read (__NR_Linux + 3)
+#define __NR_write (__NR_Linux + 4)
+#define __NR_open (__NR_Linux + 5)
+#define __NR_close (__NR_Linux + 6)
+#define __NR_waitpid (__NR_Linux + 7)
+#define __NR_creat (__NR_Linux + 8)
+#define __NR_link (__NR_Linux + 9)
+#define __NR_unlink (__NR_Linux + 10)
+#define __NR_execve (__NR_Linux + 11)
+#define __NR_chdir (__NR_Linux + 12)
+#define __NR_time (__NR_Linux + 13)
+#define __NR_mknod (__NR_Linux + 14)
+#define __NR_chmod (__NR_Linux + 15)
+#define __NR_lchown (__NR_Linux + 16)
+#define __NR_break (__NR_Linux + 17)
+#define __NR_unused18 (__NR_Linux + 18)
+#define __NR_lseek (__NR_Linux + 19)
+#define __NR_getpid (__NR_Linux + 20)
+#define __NR_mount (__NR_Linux + 21)
+#define __NR_umount (__NR_Linux + 22)
+#define __NR_setuid (__NR_Linux + 23)
+#define __NR_getuid (__NR_Linux + 24)
+#define __NR_stime (__NR_Linux + 25)
+#define __NR_ptrace (__NR_Linux + 26)
+#define __NR_alarm (__NR_Linux + 27)
+#define __NR_unused28 (__NR_Linux + 28)
+#define __NR_pause (__NR_Linux + 29)
+#define __NR_utime (__NR_Linux + 30)
+#define __NR_stty (__NR_Linux + 31)
+#define __NR_gtty (__NR_Linux + 32)
+#define __NR_access (__NR_Linux + 33)
+#define __NR_nice (__NR_Linux + 34)
+#define __NR_ftime (__NR_Linux + 35)
+#define __NR_sync (__NR_Linux + 36)
+#define __NR_kill (__NR_Linux + 37)
+#define __NR_rename (__NR_Linux + 38)
+#define __NR_mkdir (__NR_Linux + 39)
+#define __NR_rmdir (__NR_Linux + 40)
+#define __NR_dup (__NR_Linux + 41)
+#define __NR_pipe (__NR_Linux + 42)
+#define __NR_times (__NR_Linux + 43)
+#define __NR_prof (__NR_Linux + 44)
+#define __NR_brk (__NR_Linux + 45)
+#define __NR_setgid (__NR_Linux + 46)
+#define __NR_getgid (__NR_Linux + 47)
+#define __NR_signal (__NR_Linux + 48)
+#define __NR_geteuid (__NR_Linux + 49)
+#define __NR_getegid (__NR_Linux + 50)
+#define __NR_acct (__NR_Linux + 51)
+#define __NR_umount2 (__NR_Linux + 52)
+#define __NR_lock (__NR_Linux + 53)
+#define __NR_ioctl (__NR_Linux + 54)
+#define __NR_fcntl (__NR_Linux + 55)
+#define __NR_mpx (__NR_Linux + 56)
+#define __NR_setpgid (__NR_Linux + 57)
+#define __NR_ulimit (__NR_Linux + 58)
+#define __NR_unused59 (__NR_Linux + 59)
+#define __NR_umask (__NR_Linux + 60)
+#define __NR_chroot (__NR_Linux + 61)
+#define __NR_ustat (__NR_Linux + 62)
+#define __NR_dup2 (__NR_Linux + 63)
+#define __NR_getppid (__NR_Linux + 64)
+#define __NR_getpgrp (__NR_Linux + 65)
+#define __NR_setsid (__NR_Linux + 66)
+#define __NR_sigaction (__NR_Linux + 67)
+#define __NR_sgetmask (__NR_Linux + 68)
+#define __NR_ssetmask (__NR_Linux + 69)
+#define __NR_setreuid (__NR_Linux + 70)
+#define __NR_setregid (__NR_Linux + 71)
+#define __NR_sigsuspend (__NR_Linux + 72)
+#define __NR_sigpending (__NR_Linux + 73)
+#define __NR_sethostname (__NR_Linux + 74)
+#define __NR_setrlimit (__NR_Linux + 75)
+#define __NR_getrlimit (__NR_Linux + 76)
+#define __NR_getrusage (__NR_Linux + 77)
+#define __NR_gettimeofday (__NR_Linux + 78)
+#define __NR_settimeofday (__NR_Linux + 79)
+#define __NR_getgroups (__NR_Linux + 80)
+#define __NR_setgroups (__NR_Linux + 81)
+#define __NR_reserved82 (__NR_Linux + 82)
+#define __NR_symlink (__NR_Linux + 83)
+#define __NR_unused84 (__NR_Linux + 84)
+#define __NR_readlink (__NR_Linux + 85)
+#define __NR_uselib (__NR_Linux + 86)
+#define __NR_swapon (__NR_Linux + 87)
+#define __NR_reboot (__NR_Linux + 88)
+#define __NR_readdir (__NR_Linux + 89)
+#define __NR_mmap (__NR_Linux + 90)
+#define __NR_munmap (__NR_Linux + 91)
+#define __NR_truncate (__NR_Linux + 92)
+#define __NR_ftruncate (__NR_Linux + 93)
+#define __NR_fchmod (__NR_Linux + 94)
+#define __NR_fchown (__NR_Linux + 95)
+#define __NR_getpriority (__NR_Linux + 96)
+#define __NR_setpriority (__NR_Linux + 97)
+#define __NR_profil (__NR_Linux + 98)
+#define __NR_statfs (__NR_Linux + 99)
+#define __NR_fstatfs (__NR_Linux + 100)
+#define __NR_ioperm (__NR_Linux + 101)
+#define __NR_socketcall (__NR_Linux + 102)
+#define __NR_syslog (__NR_Linux + 103)
+#define __NR_setitimer (__NR_Linux + 104)
+#define __NR_getitimer (__NR_Linux + 105)
+#define __NR_stat (__NR_Linux + 106)
+#define __NR_lstat (__NR_Linux + 107)
+#define __NR_fstat (__NR_Linux + 108)
+#define __NR_unused109 (__NR_Linux + 109)
+#define __NR_iopl (__NR_Linux + 110)
+#define __NR_vhangup (__NR_Linux + 111)
+#define __NR_idle (__NR_Linux + 112)
+#define __NR_vm86 (__NR_Linux + 113)
+#define __NR_wait4 (__NR_Linux + 114)
+#define __NR_swapoff (__NR_Linux + 115)
+#define __NR_sysinfo (__NR_Linux + 116)
+#define __NR_ipc (__NR_Linux + 117)
+#define __NR_fsync (__NR_Linux + 118)
+#define __NR_sigreturn (__NR_Linux + 119)
+#define __NR_clone (__NR_Linux + 120)
+#define __NR_setdomainname (__NR_Linux + 121)
+#define __NR_uname (__NR_Linux + 122)
+#define __NR_modify_ldt (__NR_Linux + 123)
+#define __NR_adjtimex (__NR_Linux + 124)
+#define __NR_mprotect (__NR_Linux + 125)
+#define __NR_sigprocmask (__NR_Linux + 126)
+#define __NR_create_module (__NR_Linux + 127)
+#define __NR_init_module (__NR_Linux + 128)
+#define __NR_delete_module (__NR_Linux + 129)
+#define __NR_get_kernel_syms (__NR_Linux + 130)
+#define __NR_quotactl (__NR_Linux + 131)
+#define __NR_getpgid (__NR_Linux + 132)
+#define __NR_fchdir (__NR_Linux + 133)
+#define __NR_bdflush (__NR_Linux + 134)
+#define __NR_sysfs (__NR_Linux + 135)
+#define __NR_personality (__NR_Linux + 136)
+#define __NR_afs_syscall (__NR_Linux + 137)
+#define __NR_setfsuid (__NR_Linux + 138)
+#define __NR_setfsgid (__NR_Linux + 139)
+#define __NR__llseek (__NR_Linux + 140)
+#define __NR_getdents (__NR_Linux + 141)
+#define __NR__newselect (__NR_Linux + 142)
+#define __NR_flock (__NR_Linux + 143)
+#define __NR_msync (__NR_Linux + 144)
+#define __NR_readv (__NR_Linux + 145)
+#define __NR_writev (__NR_Linux + 146)
+#define __NR_cacheflush (__NR_Linux + 147)
+#define __NR_cachectl (__NR_Linux + 148)
+#define __NR_sysmips (__NR_Linux + 149)
+#define __NR_unused150 (__NR_Linux + 150)
+#define __NR_getsid (__NR_Linux + 151)
+#define __NR_fdatasync (__NR_Linux + 152)
+#define __NR__sysctl (__NR_Linux + 153)
+#define __NR_mlock (__NR_Linux + 154)
+#define __NR_munlock (__NR_Linux + 155)
+#define __NR_mlockall (__NR_Linux + 156)
+#define __NR_munlockall (__NR_Linux + 157)
+#define __NR_sched_setparam (__NR_Linux + 158)
+#define __NR_sched_getparam (__NR_Linux + 159)
+#define __NR_sched_setscheduler (__NR_Linux + 160)
+#define __NR_sched_getscheduler (__NR_Linux + 161)
+#define __NR_sched_yield (__NR_Linux + 162)
+#define __NR_sched_get_priority_max (__NR_Linux + 163)
+#define __NR_sched_get_priority_min (__NR_Linux + 164)
+#define __NR_sched_rr_get_interval (__NR_Linux + 165)
+#define __NR_nanosleep (__NR_Linux + 166)
+#define __NR_mremap (__NR_Linux + 167)
+#define __NR_accept (__NR_Linux + 168)
+#define __NR_bind (__NR_Linux + 169)
+#define __NR_connect (__NR_Linux + 170)
+#define __NR_getpeername (__NR_Linux + 171)
+#define __NR_getsockname (__NR_Linux + 172)
+#define __NR_getsockopt (__NR_Linux + 173)
+#define __NR_listen (__NR_Linux + 174)
+#define __NR_recv (__NR_Linux + 175)
+#define __NR_recvfrom (__NR_Linux + 176)
+#define __NR_recvmsg (__NR_Linux + 177)
+#define __NR_send (__NR_Linux + 178)
+#define __NR_sendmsg (__NR_Linux + 179)
+#define __NR_sendto (__NR_Linux + 180)
+#define __NR_setsockopt (__NR_Linux + 181)
+#define __NR_shutdown (__NR_Linux + 182)
+#define __NR_socket (__NR_Linux + 183)
+#define __NR_socketpair (__NR_Linux + 184)
+#define __NR_setresuid (__NR_Linux + 185)
+#define __NR_getresuid (__NR_Linux + 186)
+#define __NR_query_module (__NR_Linux + 187)
+#define __NR_poll (__NR_Linux + 188)
+#define __NR_nfsservctl (__NR_Linux + 189)
+#define __NR_setresgid (__NR_Linux + 190)
+#define __NR_getresgid (__NR_Linux + 191)
+#define __NR_prctl (__NR_Linux + 192)
+#define __NR_rt_sigreturn (__NR_Linux + 193)
+#define __NR_rt_sigaction (__NR_Linux + 194)
+#define __NR_rt_sigprocmask (__NR_Linux + 195)
+#define __NR_rt_sigpending (__NR_Linux + 196)
+#define __NR_rt_sigtimedwait (__NR_Linux + 197)
+#define __NR_rt_sigqueueinfo (__NR_Linux + 198)
+#define __NR_rt_sigsuspend (__NR_Linux + 199)
+#define __NR_pread64 (__NR_Linux + 200)
+#define __NR_pwrite64 (__NR_Linux + 201)
+#define __NR_chown (__NR_Linux + 202)
+#define __NR_getcwd (__NR_Linux + 203)
+#define __NR_capget (__NR_Linux + 204)
+#define __NR_capset (__NR_Linux + 205)
+#define __NR_sigaltstack (__NR_Linux + 206)
+#define __NR_sendfile (__NR_Linux + 207)
+#define __NR_getpmsg (__NR_Linux + 208)
+#define __NR_putpmsg (__NR_Linux + 209)
+#define __NR_mmap2 (__NR_Linux + 210)
+#define __NR_truncate64 (__NR_Linux + 211)
+#define __NR_ftruncate64 (__NR_Linux + 212)
+#define __NR_stat64 (__NR_Linux + 213)
+#define __NR_lstat64 (__NR_Linux + 214)
+#define __NR_fstat64 (__NR_Linux + 215)
+#define __NR_pivot_root (__NR_Linux + 216)
+#define __NR_mincore (__NR_Linux + 217)
+#define __NR_madvise (__NR_Linux + 218)
+#define __NR_getdents64 (__NR_Linux + 219)
+#define __NR_fcntl64 (__NR_Linux + 220)
+#define __NR_reserved221 (__NR_Linux + 221)
+#define __NR_gettid (__NR_Linux + 222)
+#define __NR_readahead (__NR_Linux + 223)
+#define __NR_setxattr (__NR_Linux + 224)
+#define __NR_lsetxattr (__NR_Linux + 225)
+#define __NR_fsetxattr (__NR_Linux + 226)
+#define __NR_getxattr (__NR_Linux + 227)
+#define __NR_lgetxattr (__NR_Linux + 228)
+#define __NR_fgetxattr (__NR_Linux + 229)
+#define __NR_listxattr (__NR_Linux + 230)
+#define __NR_llistxattr (__NR_Linux + 231)
+#define __NR_flistxattr (__NR_Linux + 232)
+#define __NR_removexattr (__NR_Linux + 233)
+#define __NR_lremovexattr (__NR_Linux + 234)
+#define __NR_fremovexattr (__NR_Linux + 235)
+#define __NR_tkill (__NR_Linux + 236)
+#define __NR_sendfile64 (__NR_Linux + 237)
+#define __NR_futex (__NR_Linux + 238)
+#define __NR_sched_setaffinity (__NR_Linux + 239)
+#define __NR_sched_getaffinity (__NR_Linux + 240)
+#define __NR_io_setup (__NR_Linux + 241)
+#define __NR_io_destroy (__NR_Linux + 242)
+#define __NR_io_getevents (__NR_Linux + 243)
+#define __NR_io_submit (__NR_Linux + 244)
+#define __NR_io_cancel (__NR_Linux + 245)
+#define __NR_exit_group (__NR_Linux + 246)
+#define __NR_lookup_dcookie (__NR_Linux + 247)
+#define __NR_epoll_create (__NR_Linux + 248)
+#define __NR_epoll_ctl (__NR_Linux + 249)
+#define __NR_epoll_wait (__NR_Linux + 250)
+#define __NR_remap_file_pages (__NR_Linux + 251)
+#define __NR_set_tid_address (__NR_Linux + 252)
+#define __NR_restart_syscall (__NR_Linux + 253)
+#define __NR_fadvise64 (__NR_Linux + 254)
+#define __NR_statfs64 (__NR_Linux + 255)
+#define __NR_fstatfs64 (__NR_Linux + 256)
+#define __NR_timer_create (__NR_Linux + 257)
+#define __NR_timer_settime (__NR_Linux + 258)
+#define __NR_timer_gettime (__NR_Linux + 259)
+#define __NR_timer_getoverrun (__NR_Linux + 260)
+#define __NR_timer_delete (__NR_Linux + 261)
+#define __NR_clock_settime (__NR_Linux + 262)
+#define __NR_clock_gettime (__NR_Linux + 263)
+#define __NR_clock_getres (__NR_Linux + 264)
+#define __NR_clock_nanosleep (__NR_Linux + 265)
+#define __NR_tgkill (__NR_Linux + 266)
+#define __NR_utimes (__NR_Linux + 267)
+#define __NR_mbind (__NR_Linux + 268)
+#define __NR_get_mempolicy (__NR_Linux + 269)
+#define __NR_set_mempolicy (__NR_Linux + 270)
+#define __NR_mq_open (__NR_Linux + 271)
+#define __NR_mq_unlink (__NR_Linux + 272)
+#define __NR_mq_timedsend (__NR_Linux + 273)
+#define __NR_mq_timedreceive (__NR_Linux + 274)
+#define __NR_mq_notify (__NR_Linux + 275)
+#define __NR_mq_getsetattr (__NR_Linux + 276)
+#define __NR_vserver (__NR_Linux + 277)
+#define __NR_waitid (__NR_Linux + 278)
+#define __NR_add_key (__NR_Linux + 280)
+#define __NR_request_key (__NR_Linux + 281)
+#define __NR_keyctl (__NR_Linux + 282)
+#define __NR_set_thread_area (__NR_Linux + 283)
+#define __NR_inotify_init (__NR_Linux + 284)
+#define __NR_inotify_add_watch (__NR_Linux + 285)
+#define __NR_inotify_rm_watch (__NR_Linux + 286)
+#define __NR_migrate_pages (__NR_Linux + 287)
+#define __NR_openat (__NR_Linux + 288)
+#define __NR_mkdirat (__NR_Linux + 289)
+#define __NR_mknodat (__NR_Linux + 290)
+#define __NR_fchownat (__NR_Linux + 291)
+#define __NR_futimesat (__NR_Linux + 292)
+#define __NR_fstatat64 (__NR_Linux + 293)
+#define __NR_unlinkat (__NR_Linux + 294)
+#define __NR_renameat (__NR_Linux + 295)
+#define __NR_linkat (__NR_Linux + 296)
+#define __NR_symlinkat (__NR_Linux + 297)
+#define __NR_readlinkat (__NR_Linux + 298)
+#define __NR_fchmodat (__NR_Linux + 299)
+#define __NR_faccessat (__NR_Linux + 300)
+#define __NR_pselect6 (__NR_Linux + 301)
+#define __NR_ppoll (__NR_Linux + 302)
+#define __NR_unshare (__NR_Linux + 303)
+#define __NR_splice (__NR_Linux + 304)
+#define __NR_sync_file_range (__NR_Linux + 305)
+#define __NR_tee (__NR_Linux + 306)
+#define __NR_vmsplice (__NR_Linux + 307)
+#define __NR_move_pages (__NR_Linux + 308)
+#define __NR_set_robust_list (__NR_Linux + 309)
+#define __NR_get_robust_list (__NR_Linux + 310)
+#define __NR_kexec_load (__NR_Linux + 311)
+#define __NR_getcpu (__NR_Linux + 312)
+#define __NR_epoll_pwait (__NR_Linux + 313)
+#define __NR_ioprio_set (__NR_Linux + 314)
+#define __NR_ioprio_get (__NR_Linux + 315)
+#define __NR_utimensat (__NR_Linux + 316)
+#define __NR_signalfd (__NR_Linux + 317)
+#define __NR_timerfd (__NR_Linux + 318)
+#define __NR_eventfd (__NR_Linux + 319)
+#define __NR_fallocate (__NR_Linux + 320)
+#define __NR_timerfd_create (__NR_Linux + 321)
+#define __NR_timerfd_gettime (__NR_Linux + 322)
+#define __NR_timerfd_settime (__NR_Linux + 323)
+#define __NR_signalfd4 (__NR_Linux + 324)
+#define __NR_eventfd2 (__NR_Linux + 325)
+#define __NR_epoll_create1 (__NR_Linux + 326)
+#define __NR_dup3 (__NR_Linux + 327)
+#define __NR_pipe2 (__NR_Linux + 328)
+#define __NR_inotify_init1 (__NR_Linux + 329)
+#define __NR_preadv (__NR_Linux + 330)
+#define __NR_pwritev (__NR_Linux + 331)
+#define __NR_rt_tgsigqueueinfo (__NR_Linux + 332)
+#define __NR_perf_event_open (__NR_Linux + 333)
+#define __NR_accept4 (__NR_Linux + 334)
+#define __NR_recvmmsg (__NR_Linux + 335)
+#define __NR_fanotify_init (__NR_Linux + 336)
+#define __NR_fanotify_mark (__NR_Linux + 337)
+#define __NR_prlimit64 (__NR_Linux + 338)
+#define __NR_name_to_handle_at (__NR_Linux + 339)
+#define __NR_open_by_handle_at (__NR_Linux + 340)
+#define __NR_clock_adjtime (__NR_Linux + 341)
+#define __NR_syncfs (__NR_Linux + 342)
+#define __NR_sendmmsg (__NR_Linux + 343)
+#define __NR_setns (__NR_Linux + 344)
+#define __NR_process_vm_readv (__NR_Linux + 345)
+#define __NR_process_vm_writev (__NR_Linux + 346)
+#define __NR_kcmp (__NR_Linux + 347)
+#define __NR_finit_module (__NR_Linux + 348)
+#define __NR_sched_setattr (__NR_Linux + 349)
+#define __NR_sched_getattr (__NR_Linux + 350)
+#define __NR_renameat2 (__NR_Linux + 351)
+#define __NR_seccomp (__NR_Linux + 352)
+#define __NR_getrandom (__NR_Linux + 353)
+#define __NR_memfd_create (__NR_Linux + 354)
+#define __NR_bpf (__NR_Linux + 355)
+#define __NR_execveat (__NR_Linux + 356)
+#define __NR_userfaultfd (__NR_Linux + 357)
+#define __NR_membarrier (__NR_Linux + 358)
+#define __NR_mlock2 (__NR_Linux + 359)
+#define __NR_copy_file_range (__NR_Linux + 360)
+#define __NR_preadv2 (__NR_Linux + 361)
+#define __NR_pwritev2 (__NR_Linux + 362)
+#define __NR_pkey_mprotect (__NR_Linux + 363)
+#define __NR_pkey_alloc (__NR_Linux + 364)
+#define __NR_pkey_free (__NR_Linux + 365)
+#define __NR_statx (__NR_Linux + 366)
+#define __NR_rseq (__NR_Linux + 367)
+#define __NR_io_pgetevents (__NR_Linux + 368)
+#define __NR_semget (__NR_Linux + 393)
+#define __NR_semctl (__NR_Linux + 394)
+#define __NR_shmget (__NR_Linux + 395)
+#define __NR_shmctl (__NR_Linux + 396)
+#define __NR_shmat (__NR_Linux + 397)
+#define __NR_shmdt (__NR_Linux + 398)
+#define __NR_msgget (__NR_Linux + 399)
+#define __NR_msgsnd (__NR_Linux + 400)
+#define __NR_msgrcv (__NR_Linux + 401)
+#define __NR_msgctl (__NR_Linux + 402)
+#define __NR_clock_gettime64 (__NR_Linux + 403)
+#define __NR_clock_settime64 (__NR_Linux + 404)
+#define __NR_clock_adjtime64 (__NR_Linux + 405)
+#define __NR_clock_getres_time64 (__NR_Linux + 406)
+#define __NR_clock_nanosleep_time64 (__NR_Linux + 407)
+#define __NR_timer_gettime64 (__NR_Linux + 408)
+#define __NR_timer_settime64 (__NR_Linux + 409)
+#define __NR_timerfd_gettime64 (__NR_Linux + 410)
+#define __NR_timerfd_settime64 (__NR_Linux + 411)
+#define __NR_utimensat_time64 (__NR_Linux + 412)
+#define __NR_pselect6_time64 (__NR_Linux + 413)
+#define __NR_ppoll_time64 (__NR_Linux + 414)
+#define __NR_io_pgetevents_time64 (__NR_Linux + 416)
+#define __NR_recvmmsg_time64 (__NR_Linux + 417)
+#define __NR_mq_timedsend_time64 (__NR_Linux + 418)
+#define __NR_mq_timedreceive_time64 (__NR_Linux + 419)
+#define __NR_semtimedop_time64 (__NR_Linux + 420)
+#define __NR_rt_sigtimedwait_time64 (__NR_Linux + 421)
+#define __NR_futex_time64 (__NR_Linux + 422)
+#define __NR_sched_rr_get_interval_time64 (__NR_Linux + 423)
+#define __NR_pidfd_send_signal (__NR_Linux + 424)
+#define __NR_io_uring_setup (__NR_Linux + 425)
+#define __NR_io_uring_enter (__NR_Linux + 426)
+#define __NR_io_uring_register (__NR_Linux + 427)
+#define __NR_open_tree (__NR_Linux + 428)
+#define __NR_move_mount (__NR_Linux + 429)
+#define __NR_fsopen (__NR_Linux + 430)
+#define __NR_fsconfig (__NR_Linux + 431)
+#define __NR_fsmount (__NR_Linux + 432)
+#define __NR_fspick (__NR_Linux + 433)
+#define __NR_pidfd_open (__NR_Linux + 434)
+#define __NR_clone3 (__NR_Linux + 435)
+#define __NR_close_range (__NR_Linux + 436)
+#define __NR_openat2 (__NR_Linux + 437)
+#define __NR_pidfd_getfd (__NR_Linux + 438)
+#define __NR_faccessat2 (__NR_Linux + 439)
+#define __NR_process_madvise (__NR_Linux + 440)
+#define __NR_epoll_pwait2 (__NR_Linux + 441)
+#define __NR_mount_setattr (__NR_Linux + 442)
+#define __NR_landlock_create_ruleset (__NR_Linux + 444)
+#define __NR_landlock_add_rule (__NR_Linux + 445)
+#define __NR_landlock_restrict_self (__NR_Linux + 446)
 
-
-#endif /* _ASM_MIPS_UNISTD_O32_H */
+#endif /* _ASM_UNISTD_O32_H */
diff --git a/linux-headers/asm-powerpc/kvm.h b/linux-headers/asm-powerpc/kvm.h
index c3af3f324c..9f18fa090f 100644
--- a/linux-headers/asm-powerpc/kvm.h
+++ b/linux-headers/asm-powerpc/kvm.h
@@ -644,6 +644,8 @@ struct kvm_ppc_cpu_char {
 #define KVM_REG_PPC_MMCR3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc1)
 #define KVM_REG_PPC_SIER2	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc2)
 #define KVM_REG_PPC_SIER3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc3)
+#define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
+#define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
 
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs
diff --git a/linux-headers/asm-powerpc/unistd_32.h b/linux-headers/asm-powerpc/unistd_32.h
index 4624c90043..9155778c19 100644
--- a/linux-headers/asm-powerpc/unistd_32.h
+++ b/linux-headers/asm-powerpc/unistd_32.h
@@ -1,429 +1,433 @@
-#ifndef _ASM_POWERPC_UNISTD_32_H
-#define _ASM_POWERPC_UNISTD_32_H
+#ifndef _ASM_UNISTD_32_H
+#define _ASM_UNISTD_32_H
 
-#define __NR_restart_syscall	0
-#define __NR_exit	1
-#define __NR_fork	2
-#define __NR_read	3
-#define __NR_write	4
-#define __NR_open	5
-#define __NR_close	6
-#define __NR_waitpid	7
-#define __NR_creat	8
-#define __NR_link	9
-#define __NR_unlink	10
-#define __NR_execve	11
-#define __NR_chdir	12
-#define __NR_time	13
-#define __NR_mknod	14
-#define __NR_chmod	15
-#define __NR_lchown	16
-#define __NR_break	17
-#define __NR_oldstat	18
-#define __NR_lseek	19
-#define __NR_getpid	20
-#define __NR_mount	21
-#define __NR_umount	22
-#define __NR_setuid	23
-#define __NR_getuid	24
-#define __NR_stime	25
-#define __NR_ptrace	26
-#define __NR_alarm	27
-#define __NR_oldfstat	28
-#define __NR_pause	29
-#define __NR_utime	30
-#define __NR_stty	31
-#define __NR_gtty	32
-#define __NR_access	33
-#define __NR_nice	34
-#define __NR_ftime	35
-#define __NR_sync	36
-#define __NR_kill	37
-#define __NR_rename	38
-#define __NR_mkdir	39
-#define __NR_rmdir	40
-#define __NR_dup	41
-#define __NR_pipe	42
-#define __NR_times	43
-#define __NR_prof	44
-#define __NR_brk	45
-#define __NR_setgid	46
-#define __NR_getgid	47
-#define __NR_signal	48
-#define __NR_geteuid	49
-#define __NR_getegid	50
-#define __NR_acct	51
-#define __NR_umount2	52
-#define __NR_lock	53
-#define __NR_ioctl	54
-#define __NR_fcntl	55
-#define __NR_mpx	56
-#define __NR_setpgid	57
-#define __NR_ulimit	58
-#define __NR_oldolduname	59
-#define __NR_umask	60
-#define __NR_chroot	61
-#define __NR_ustat	62
-#define __NR_dup2	63
-#define __NR_getppid	64
-#define __NR_getpgrp	65
-#define __NR_setsid	66
-#define __NR_sigaction	67
-#define __NR_sgetmask	68
-#define __NR_ssetmask	69
-#define __NR_setreuid	70
-#define __NR_setregid	71
-#define __NR_sigsuspend	72
-#define __NR_sigpending	73
-#define __NR_sethostname	74
-#define __NR_setrlimit	75
-#define __NR_getrlimit	76
-#define __NR_getrusage	77
-#define __NR_gettimeofday	78
-#define __NR_settimeofday	79
-#define __NR_getgroups	80
-#define __NR_setgroups	81
-#define __NR_select	82
-#define __NR_symlink	83
-#define __NR_oldlstat	84
-#define __NR_readlink	85
-#define __NR_uselib	86
-#define __NR_swapon	87
-#define __NR_reboot	88
-#define __NR_readdir	89
-#define __NR_mmap	90
-#define __NR_munmap	91
-#define __NR_truncate	92
-#define __NR_ftruncate	93
-#define __NR_fchmod	94
-#define __NR_fchown	95
-#define __NR_getpriority	96
-#define __NR_setpriority	97
-#define __NR_profil	98
-#define __NR_statfs	99
-#define __NR_fstatfs	100
-#define __NR_ioperm	101
-#define __NR_socketcall	102
-#define __NR_syslog	103
-#define __NR_setitimer	104
-#define __NR_getitimer	105
-#define __NR_stat	106
-#define __NR_lstat	107
-#define __NR_fstat	108
-#define __NR_olduname	109
-#define __NR_iopl	110
-#define __NR_vhangup	111
-#define __NR_idle	112
-#define __NR_vm86	113
-#define __NR_wait4	114
-#define __NR_swapoff	115
-#define __NR_sysinfo	116
-#define __NR_ipc	117
-#define __NR_fsync	118
-#define __NR_sigreturn	119
-#define __NR_clone	120
-#define __NR_setdomainname	121
-#define __NR_uname	122
-#define __NR_modify_ldt	123
-#define __NR_adjtimex	124
-#define __NR_mprotect	125
-#define __NR_sigprocmask	126
-#define __NR_create_module	127
-#define __NR_init_module	128
-#define __NR_delete_module	129
-#define __NR_get_kernel_syms	130
-#define __NR_quotactl	131
-#define __NR_getpgid	132
-#define __NR_fchdir	133
-#define __NR_bdflush	134
-#define __NR_sysfs	135
-#define __NR_personality	136
-#define __NR_afs_syscall	137
-#define __NR_setfsuid	138
-#define __NR_setfsgid	139
-#define __NR__llseek	140
-#define __NR_getdents	141
-#define __NR__newselect	142
-#define __NR_flock	143
-#define __NR_msync	144
-#define __NR_readv	145
-#define __NR_writev	146
-#define __NR_getsid	147
-#define __NR_fdatasync	148
-#define __NR__sysctl	149
-#define __NR_mlock	150
-#define __NR_munlock	151
-#define __NR_mlockall	152
-#define __NR_munlockall	153
-#define __NR_sched_setparam	154
-#define __NR_sched_getparam	155
-#define __NR_sched_setscheduler	156
-#define __NR_sched_getscheduler	157
-#define __NR_sched_yield	158
-#define __NR_sched_get_priority_max	159
-#define __NR_sched_get_priority_min	160
-#define __NR_sched_rr_get_interval	161
-#define __NR_nanosleep	162
-#define __NR_mremap	163
-#define __NR_setresuid	164
-#define __NR_getresuid	165
-#define __NR_query_module	166
-#define __NR_poll	167
-#define __NR_nfsservctl	168
-#define __NR_setresgid	169
-#define __NR_getresgid	170
-#define __NR_prctl	171
-#define __NR_rt_sigreturn	172
-#define __NR_rt_sigaction	173
-#define __NR_rt_sigprocmask	174
-#define __NR_rt_sigpending	175
-#define __NR_rt_sigtimedwait	176
-#define __NR_rt_sigqueueinfo	177
-#define __NR_rt_sigsuspend	178
-#define __NR_pread64	179
-#define __NR_pwrite64	180
-#define __NR_chown	181
-#define __NR_getcwd	182
-#define __NR_capget	183
-#define __NR_capset	184
-#define __NR_sigaltstack	185
-#define __NR_sendfile	186
-#define __NR_getpmsg	187
-#define __NR_putpmsg	188
-#define __NR_vfork	189
-#define __NR_ugetrlimit	190
-#define __NR_readahead	191
-#define __NR_mmap2	192
-#define __NR_truncate64	193
-#define __NR_ftruncate64	194
-#define __NR_stat64	195
-#define __NR_lstat64	196
-#define __NR_fstat64	197
-#define __NR_pciconfig_read	198
-#define __NR_pciconfig_write	199
-#define __NR_pciconfig_iobase	200
-#define __NR_multiplexer	201
-#define __NR_getdents64	202
-#define __NR_pivot_root	203
-#define __NR_fcntl64	204
-#define __NR_madvise	205
-#define __NR_mincore	206
-#define __NR_gettid	207
-#define __NR_tkill	208
-#define __NR_setxattr	209
-#define __NR_lsetxattr	210
-#define __NR_fsetxattr	211
-#define __NR_getxattr	212
-#define __NR_lgetxattr	213
-#define __NR_fgetxattr	214
-#define __NR_listxattr	215
-#define __NR_llistxattr	216
-#define __NR_flistxattr	217
-#define __NR_removexattr	218
-#define __NR_lremovexattr	219
-#define __NR_fremovexattr	220
-#define __NR_futex	221
-#define __NR_sched_setaffinity	222
-#define __NR_sched_getaffinity	223
-#define __NR_tuxcall	225
-#define __NR_sendfile64	226
-#define __NR_io_setup	227
-#define __NR_io_destroy	228
-#define __NR_io_getevents	229
-#define __NR_io_submit	230
-#define __NR_io_cancel	231
-#define __NR_set_tid_address	232
-#define __NR_fadvise64	233
-#define __NR_exit_group	234
-#define __NR_lookup_dcookie	235
-#define __NR_epoll_create	236
-#define __NR_epoll_ctl	237
-#define __NR_epoll_wait	238
-#define __NR_remap_file_pages	239
-#define __NR_timer_create	240
-#define __NR_timer_settime	241
-#define __NR_timer_gettime	242
-#define __NR_timer_getoverrun	243
-#define __NR_timer_delete	244
-#define __NR_clock_settime	245
-#define __NR_clock_gettime	246
-#define __NR_clock_getres	247
-#define __NR_clock_nanosleep	248
-#define __NR_swapcontext	249
-#define __NR_tgkill	250
-#define __NR_utimes	251
-#define __NR_statfs64	252
-#define __NR_fstatfs64	253
-#define __NR_fadvise64_64	254
-#define __NR_rtas	255
-#define __NR_sys_debug_setcontext	256
-#define __NR_migrate_pages	258
-#define __NR_mbind	259
-#define __NR_get_mempolicy	260
-#define __NR_set_mempolicy	261
-#define __NR_mq_open	262
-#define __NR_mq_unlink	263
-#define __NR_mq_timedsend	264
-#define __NR_mq_timedreceive	265
-#define __NR_mq_notify	266
-#define __NR_mq_getsetattr	267
-#define __NR_kexec_load	268
-#define __NR_add_key	269
-#define __NR_request_key	270
-#define __NR_keyctl	271
-#define __NR_waitid	272
-#define __NR_ioprio_set	273
-#define __NR_ioprio_get	274
-#define __NR_inotify_init	275
-#define __NR_inotify_add_watch	276
-#define __NR_inotify_rm_watch	277
-#define __NR_spu_run	278
-#define __NR_spu_create	279
-#define __NR_pselect6	280
-#define __NR_ppoll	281
-#define __NR_unshare	282
-#define __NR_splice	283
-#define __NR_tee	284
-#define __NR_vmsplice	285
-#define __NR_openat	286
-#define __NR_mkdirat	287
-#define __NR_mknodat	288
-#define __NR_fchownat	289
-#define __NR_futimesat	290
-#define __NR_fstatat64	291
-#define __NR_unlinkat	292
-#define __NR_renameat	293
-#define __NR_linkat	294
-#define __NR_symlinkat	295
-#define __NR_readlinkat	296
-#define __NR_fchmodat	297
-#define __NR_faccessat	298
-#define __NR_get_robust_list	299
-#define __NR_set_robust_list	300
-#define __NR_move_pages	301
-#define __NR_getcpu	302
-#define __NR_epoll_pwait	303
-#define __NR_utimensat	304
-#define __NR_signalfd	305
-#define __NR_timerfd_create	306
-#define __NR_eventfd	307
-#define __NR_sync_file_range2	308
-#define __NR_fallocate	309
-#define __NR_subpage_prot	310
-#define __NR_timerfd_settime	311
-#define __NR_timerfd_gettime	312
-#define __NR_signalfd4	313
-#define __NR_eventfd2	314
-#define __NR_epoll_create1	315
-#define __NR_dup3	316
-#define __NR_pipe2	317
-#define __NR_inotify_init1	318
-#define __NR_perf_event_open	319
-#define __NR_preadv	320
-#define __NR_pwritev	321
-#define __NR_rt_tgsigqueueinfo	322
-#define __NR_fanotify_init	323
-#define __NR_fanotify_mark	324
-#define __NR_prlimit64	325
-#define __NR_socket	326
-#define __NR_bind	327
-#define __NR_connect	328
-#define __NR_listen	329
-#define __NR_accept	330
-#define __NR_getsockname	331
-#define __NR_getpeername	332
-#define __NR_socketpair	333
-#define __NR_send	334
-#define __NR_sendto	335
-#define __NR_recv	336
-#define __NR_recvfrom	337
-#define __NR_shutdown	338
-#define __NR_setsockopt	339
-#define __NR_getsockopt	340
-#define __NR_sendmsg	341
-#define __NR_recvmsg	342
-#define __NR_recvmmsg	343
-#define __NR_accept4	344
-#define __NR_name_to_handle_at	345
-#define __NR_open_by_handle_at	346
-#define __NR_clock_adjtime	347
-#define __NR_syncfs	348
-#define __NR_sendmmsg	349
-#define __NR_setns	350
-#define __NR_process_vm_readv	351
-#define __NR_process_vm_writev	352
-#define __NR_finit_module	353
-#define __NR_kcmp	354
-#define __NR_sched_setattr	355
-#define __NR_sched_getattr	356
-#define __NR_renameat2	357
-#define __NR_seccomp	358
-#define __NR_getrandom	359
-#define __NR_memfd_create	360
-#define __NR_bpf	361
-#define __NR_execveat	362
-#define __NR_switch_endian	363
-#define __NR_userfaultfd	364
-#define __NR_membarrier	365
-#define __NR_mlock2	378
-#define __NR_copy_file_range	379
-#define __NR_preadv2	380
-#define __NR_pwritev2	381
-#define __NR_kexec_file_load	382
-#define __NR_statx	383
-#define __NR_pkey_alloc	384
-#define __NR_pkey_free	385
-#define __NR_pkey_mprotect	386
-#define __NR_rseq	387
-#define __NR_io_pgetevents	388
-#define __NR_semget	393
-#define __NR_semctl	394
-#define __NR_shmget	395
-#define __NR_shmctl	396
-#define __NR_shmat	397
-#define __NR_shmdt	398
-#define __NR_msgget	399
-#define __NR_msgsnd	400
-#define __NR_msgrcv	401
-#define __NR_msgctl	402
-#define __NR_clock_gettime64	403
-#define __NR_clock_settime64	404
-#define __NR_clock_adjtime64	405
-#define __NR_clock_getres_time64	406
-#define __NR_clock_nanosleep_time64	407
-#define __NR_timer_gettime64	408
-#define __NR_timer_settime64	409
-#define __NR_timerfd_gettime64	410
-#define __NR_timerfd_settime64	411
-#define __NR_utimensat_time64	412
-#define __NR_pselect6_time64	413
-#define __NR_ppoll_time64	414
-#define __NR_io_pgetevents_time64	416
-#define __NR_recvmmsg_time64	417
-#define __NR_mq_timedsend_time64	418
-#define __NR_mq_timedreceive_time64	419
-#define __NR_semtimedop_time64	420
-#define __NR_rt_sigtimedwait_time64	421
-#define __NR_futex_time64	422
-#define __NR_sched_rr_get_interval_time64	423
-#define __NR_pidfd_send_signal	424
-#define __NR_io_uring_setup	425
-#define __NR_io_uring_enter	426
-#define __NR_io_uring_register	427
-#define __NR_open_tree	428
-#define __NR_move_mount	429
-#define __NR_fsopen	430
-#define __NR_fsconfig	431
-#define __NR_fsmount	432
-#define __NR_fspick	433
-#define __NR_pidfd_open	434
-#define __NR_clone3	435
-#define __NR_close_range	436
-#define __NR_openat2	437
-#define __NR_pidfd_getfd	438
-#define __NR_faccessat2	439
-#define __NR_process_madvise	440
-#define __NR_epoll_pwait2	441
+#define __NR_restart_syscall 0
+#define __NR_exit 1
+#define __NR_fork 2
+#define __NR_read 3
+#define __NR_write 4
+#define __NR_open 5
+#define __NR_close 6
+#define __NR_waitpid 7
+#define __NR_creat 8
+#define __NR_link 9
+#define __NR_unlink 10
+#define __NR_execve 11
+#define __NR_chdir 12
+#define __NR_time 13
+#define __NR_mknod 14
+#define __NR_chmod 15
+#define __NR_lchown 16
+#define __NR_break 17
+#define __NR_oldstat 18
+#define __NR_lseek 19
+#define __NR_getpid 20
+#define __NR_mount 21
+#define __NR_umount 22
+#define __NR_setuid 23
+#define __NR_getuid 24
+#define __NR_stime 25
+#define __NR_ptrace 26
+#define __NR_alarm 27
+#define __NR_oldfstat 28
+#define __NR_pause 29
+#define __NR_utime 30
+#define __NR_stty 31
+#define __NR_gtty 32
+#define __NR_access 33
+#define __NR_nice 34
+#define __NR_ftime 35
+#define __NR_sync 36
+#define __NR_kill 37
+#define __NR_rename 38
+#define __NR_mkdir 39
+#define __NR_rmdir 40
+#define __NR_dup 41
+#define __NR_pipe 42
+#define __NR_times 43
+#define __NR_prof 44
+#define __NR_brk 45
+#define __NR_setgid 46
+#define __NR_getgid 47
+#define __NR_signal 48
+#define __NR_geteuid 49
+#define __NR_getegid 50
+#define __NR_acct 51
+#define __NR_umount2 52
+#define __NR_lock 53
+#define __NR_ioctl 54
+#define __NR_fcntl 55
+#define __NR_mpx 56
+#define __NR_setpgid 57
+#define __NR_ulimit 58
+#define __NR_oldolduname 59
+#define __NR_umask 60
+#define __NR_chroot 61
+#define __NR_ustat 62
+#define __NR_dup2 63
+#define __NR_getppid 64
+#define __NR_getpgrp 65
+#define __NR_setsid 66
+#define __NR_sigaction 67
+#define __NR_sgetmask 68
+#define __NR_ssetmask 69
+#define __NR_setreuid 70
+#define __NR_setregid 71
+#define __NR_sigsuspend 72
+#define __NR_sigpending 73
+#define __NR_sethostname 74
+#define __NR_setrlimit 75
+#define __NR_getrlimit 76
+#define __NR_getrusage 77
+#define __NR_gettimeofday 78
+#define __NR_settimeofday 79
+#define __NR_getgroups 80
+#define __NR_setgroups 81
+#define __NR_select 82
+#define __NR_symlink 83
+#define __NR_oldlstat 84
+#define __NR_readlink 85
+#define __NR_uselib 86
+#define __NR_swapon 87
+#define __NR_reboot 88
+#define __NR_readdir 89
+#define __NR_mmap 90
+#define __NR_munmap 91
+#define __NR_truncate 92
+#define __NR_ftruncate 93
+#define __NR_fchmod 94
+#define __NR_fchown 95
+#define __NR_getpriority 96
+#define __NR_setpriority 97
+#define __NR_profil 98
+#define __NR_statfs 99
+#define __NR_fstatfs 100
+#define __NR_ioperm 101
+#define __NR_socketcall 102
+#define __NR_syslog 103
+#define __NR_setitimer 104
+#define __NR_getitimer 105
+#define __NR_stat 106
+#define __NR_lstat 107
+#define __NR_fstat 108
+#define __NR_olduname 109
+#define __NR_iopl 110
+#define __NR_vhangup 111
+#define __NR_idle 112
+#define __NR_vm86 113
+#define __NR_wait4 114
+#define __NR_swapoff 115
+#define __NR_sysinfo 116
+#define __NR_ipc 117
+#define __NR_fsync 118
+#define __NR_sigreturn 119
+#define __NR_clone 120
+#define __NR_setdomainname 121
+#define __NR_uname 122
+#define __NR_modify_ldt 123
+#define __NR_adjtimex 124
+#define __NR_mprotect 125
+#define __NR_sigprocmask 126
+#define __NR_create_module 127
+#define __NR_init_module 128
+#define __NR_delete_module 129
+#define __NR_get_kernel_syms 130
+#define __NR_quotactl 131
+#define __NR_getpgid 132
+#define __NR_fchdir 133
+#define __NR_bdflush 134
+#define __NR_sysfs 135
+#define __NR_personality 136
+#define __NR_afs_syscall 137
+#define __NR_setfsuid 138
+#define __NR_setfsgid 139
+#define __NR__llseek 140
+#define __NR_getdents 141
+#define __NR__newselect 142
+#define __NR_flock 143
+#define __NR_msync 144
+#define __NR_readv 145
+#define __NR_writev 146
+#define __NR_getsid 147
+#define __NR_fdatasync 148
+#define __NR__sysctl 149
+#define __NR_mlock 150
+#define __NR_munlock 151
+#define __NR_mlockall 152
+#define __NR_munlockall 153
+#define __NR_sched_setparam 154
+#define __NR_sched_getparam 155
+#define __NR_sched_setscheduler 156
+#define __NR_sched_getscheduler 157
+#define __NR_sched_yield 158
+#define __NR_sched_get_priority_max 159
+#define __NR_sched_get_priority_min 160
+#define __NR_sched_rr_get_interval 161
+#define __NR_nanosleep 162
+#define __NR_mremap 163
+#define __NR_setresuid 164
+#define __NR_getresuid 165
+#define __NR_query_module 166
+#define __NR_poll 167
+#define __NR_nfsservctl 168
+#define __NR_setresgid 169
+#define __NR_getresgid 170
+#define __NR_prctl 171
+#define __NR_rt_sigreturn 172
+#define __NR_rt_sigaction 173
+#define __NR_rt_sigprocmask 174
+#define __NR_rt_sigpending 175
+#define __NR_rt_sigtimedwait 176
+#define __NR_rt_sigqueueinfo 177
+#define __NR_rt_sigsuspend 178
+#define __NR_pread64 179
+#define __NR_pwrite64 180
+#define __NR_chown 181
+#define __NR_getcwd 182
+#define __NR_capget 183
+#define __NR_capset 184
+#define __NR_sigaltstack 185
+#define __NR_sendfile 186
+#define __NR_getpmsg 187
+#define __NR_putpmsg 188
+#define __NR_vfork 189
+#define __NR_ugetrlimit 190
+#define __NR_readahead 191
+#define __NR_mmap2 192
+#define __NR_truncate64 193
+#define __NR_ftruncate64 194
+#define __NR_stat64 195
+#define __NR_lstat64 196
+#define __NR_fstat64 197
+#define __NR_pciconfig_read 198
+#define __NR_pciconfig_write 199
+#define __NR_pciconfig_iobase 200
+#define __NR_multiplexer 201
+#define __NR_getdents64 202
+#define __NR_pivot_root 203
+#define __NR_fcntl64 204
+#define __NR_madvise 205
+#define __NR_mincore 206
+#define __NR_gettid 207
+#define __NR_tkill 208
+#define __NR_setxattr 209
+#define __NR_lsetxattr 210
+#define __NR_fsetxattr 211
+#define __NR_getxattr 212
+#define __NR_lgetxattr 213
+#define __NR_fgetxattr 214
+#define __NR_listxattr 215
+#define __NR_llistxattr 216
+#define __NR_flistxattr 217
+#define __NR_removexattr 218
+#define __NR_lremovexattr 219
+#define __NR_fremovexattr 220
+#define __NR_futex 221
+#define __NR_sched_setaffinity 222
+#define __NR_sched_getaffinity 223
+#define __NR_tuxcall 225
+#define __NR_sendfile64 226
+#define __NR_io_setup 227
+#define __NR_io_destroy 228
+#define __NR_io_getevents 229
+#define __NR_io_submit 230
+#define __NR_io_cancel 231
+#define __NR_set_tid_address 232
+#define __NR_fadvise64 233
+#define __NR_exit_group 234
+#define __NR_lookup_dcookie 235
+#define __NR_epoll_create 236
+#define __NR_epoll_ctl 237
+#define __NR_epoll_wait 238
+#define __NR_remap_file_pages 239
+#define __NR_timer_create 240
+#define __NR_timer_settime 241
+#define __NR_timer_gettime 242
+#define __NR_timer_getoverrun 243
+#define __NR_timer_delete 244
+#define __NR_clock_settime 245
+#define __NR_clock_gettime 246
+#define __NR_clock_getres 247
+#define __NR_clock_nanosleep 248
+#define __NR_swapcontext 249
+#define __NR_tgkill 250
+#define __NR_utimes 251
+#define __NR_statfs64 252
+#define __NR_fstatfs64 253
+#define __NR_fadvise64_64 254
+#define __NR_rtas 255
+#define __NR_sys_debug_setcontext 256
+#define __NR_migrate_pages 258
+#define __NR_mbind 259
+#define __NR_get_mempolicy 260
+#define __NR_set_mempolicy 261
+#define __NR_mq_open 262
+#define __NR_mq_unlink 263
+#define __NR_mq_timedsend 264
+#define __NR_mq_timedreceive 265
+#define __NR_mq_notify 266
+#define __NR_mq_getsetattr 267
+#define __NR_kexec_load 268
+#define __NR_add_key 269
+#define __NR_request_key 270
+#define __NR_keyctl 271
+#define __NR_waitid 272
+#define __NR_ioprio_set 273
+#define __NR_ioprio_get 274
+#define __NR_inotify_init 275
+#define __NR_inotify_add_watch 276
+#define __NR_inotify_rm_watch 277
+#define __NR_spu_run 278
+#define __NR_spu_create 279
+#define __NR_pselect6 280
+#define __NR_ppoll 281
+#define __NR_unshare 282
+#define __NR_splice 283
+#define __NR_tee 284
+#define __NR_vmsplice 285
+#define __NR_openat 286
+#define __NR_mkdirat 287
+#define __NR_mknodat 288
+#define __NR_fchownat 289
+#define __NR_futimesat 290
+#define __NR_fstatat64 291
+#define __NR_unlinkat 292
+#define __NR_renameat 293
+#define __NR_linkat 294
+#define __NR_symlinkat 295
+#define __NR_readlinkat 296
+#define __NR_fchmodat 297
+#define __NR_faccessat 298
+#define __NR_get_robust_list 299
+#define __NR_set_robust_list 300
+#define __NR_move_pages 301
+#define __NR_getcpu 302
+#define __NR_epoll_pwait 303
+#define __NR_utimensat 304
+#define __NR_signalfd 305
+#define __NR_timerfd_create 306
+#define __NR_eventfd 307
+#define __NR_sync_file_range2 308
+#define __NR_fallocate 309
+#define __NR_subpage_prot 310
+#define __NR_timerfd_settime 311
+#define __NR_timerfd_gettime 312
+#define __NR_signalfd4 313
+#define __NR_eventfd2 314
+#define __NR_epoll_create1 315
+#define __NR_dup3 316
+#define __NR_pipe2 317
+#define __NR_inotify_init1 318
+#define __NR_perf_event_open 319
+#define __NR_preadv 320
+#define __NR_pwritev 321
+#define __NR_rt_tgsigqueueinfo 322
+#define __NR_fanotify_init 323
+#define __NR_fanotify_mark 324
+#define __NR_prlimit64 325
+#define __NR_socket 326
+#define __NR_bind 327
+#define __NR_connect 328
+#define __NR_listen 329
+#define __NR_accept 330
+#define __NR_getsockname 331
+#define __NR_getpeername 332
+#define __NR_socketpair 333
+#define __NR_send 334
+#define __NR_sendto 335
+#define __NR_recv 336
+#define __NR_recvfrom 337
+#define __NR_shutdown 338
+#define __NR_setsockopt 339
+#define __NR_getsockopt 340
+#define __NR_sendmsg 341
+#define __NR_recvmsg 342
+#define __NR_recvmmsg 343
+#define __NR_accept4 344
+#define __NR_name_to_handle_at 345
+#define __NR_open_by_handle_at 346
+#define __NR_clock_adjtime 347
+#define __NR_syncfs 348
+#define __NR_sendmmsg 349
+#define __NR_setns 350
+#define __NR_process_vm_readv 351
+#define __NR_process_vm_writev 352
+#define __NR_finit_module 353
+#define __NR_kcmp 354
+#define __NR_sched_setattr 355
+#define __NR_sched_getattr 356
+#define __NR_renameat2 357
+#define __NR_seccomp 358
+#define __NR_getrandom 359
+#define __NR_memfd_create 360
+#define __NR_bpf 361
+#define __NR_execveat 362
+#define __NR_switch_endian 363
+#define __NR_userfaultfd 364
+#define __NR_membarrier 365
+#define __NR_mlock2 378
+#define __NR_copy_file_range 379
+#define __NR_preadv2 380
+#define __NR_pwritev2 381
+#define __NR_kexec_file_load 382
+#define __NR_statx 383
+#define __NR_pkey_alloc 384
+#define __NR_pkey_free 385
+#define __NR_pkey_mprotect 386
+#define __NR_rseq 387
+#define __NR_io_pgetevents 388
+#define __NR_semget 393
+#define __NR_semctl 394
+#define __NR_shmget 395
+#define __NR_shmctl 396
+#define __NR_shmat 397
+#define __NR_shmdt 398
+#define __NR_msgget 399
+#define __NR_msgsnd 400
+#define __NR_msgrcv 401
+#define __NR_msgctl 402
+#define __NR_clock_gettime64 403
+#define __NR_clock_settime64 404
+#define __NR_clock_adjtime64 405
+#define __NR_clock_getres_time64 406
+#define __NR_clock_nanosleep_time64 407
+#define __NR_timer_gettime64 408
+#define __NR_timer_settime64 409
+#define __NR_timerfd_gettime64 410
+#define __NR_timerfd_settime64 411
+#define __NR_utimensat_time64 412
+#define __NR_pselect6_time64 413
+#define __NR_ppoll_time64 414
+#define __NR_io_pgetevents_time64 416
+#define __NR_recvmmsg_time64 417
+#define __NR_mq_timedsend_time64 418
+#define __NR_mq_timedreceive_time64 419
+#define __NR_semtimedop_time64 420
+#define __NR_rt_sigtimedwait_time64 421
+#define __NR_futex_time64 422
+#define __NR_sched_rr_get_interval_time64 423
+#define __NR_pidfd_send_signal 424
+#define __NR_io_uring_setup 425
+#define __NR_io_uring_enter 426
+#define __NR_io_uring_register 427
+#define __NR_open_tree 428
+#define __NR_move_mount 429
+#define __NR_fsopen 430
+#define __NR_fsconfig 431
+#define __NR_fsmount 432
+#define __NR_fspick 433
+#define __NR_pidfd_open 434
+#define __NR_clone3 435
+#define __NR_close_range 436
+#define __NR_openat2 437
+#define __NR_pidfd_getfd 438
+#define __NR_faccessat2 439
+#define __NR_process_madvise 440
+#define __NR_epoll_pwait2 441
+#define __NR_mount_setattr 442
+#define __NR_landlock_create_ruleset 444
+#define __NR_landlock_add_rule 445
+#define __NR_landlock_restrict_self 446
 
 
-#endif /* _ASM_POWERPC_UNISTD_32_H */
+#endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-powerpc/unistd_64.h b/linux-headers/asm-powerpc/unistd_64.h
index 7e851b30bb..3cefa88932 100644
--- a/linux-headers/asm-powerpc/unistd_64.h
+++ b/linux-headers/asm-powerpc/unistd_64.h
@@ -1,401 +1,405 @@
-#ifndef _ASM_POWERPC_UNISTD_64_H
-#define _ASM_POWERPC_UNISTD_64_H
+#ifndef _ASM_UNISTD_64_H
+#define _ASM_UNISTD_64_H
 
-#define __NR_restart_syscall	0
-#define __NR_exit	1
-#define __NR_fork	2
-#define __NR_read	3
-#define __NR_write	4
-#define __NR_open	5
-#define __NR_close	6
-#define __NR_waitpid	7
-#define __NR_creat	8
-#define __NR_link	9
-#define __NR_unlink	10
-#define __NR_execve	11
-#define __NR_chdir	12
-#define __NR_time	13
-#define __NR_mknod	14
-#define __NR_chmod	15
-#define __NR_lchown	16
-#define __NR_break	17
-#define __NR_oldstat	18
-#define __NR_lseek	19
-#define __NR_getpid	20
-#define __NR_mount	21
-#define __NR_umount	22
-#define __NR_setuid	23
-#define __NR_getuid	24
-#define __NR_stime	25
-#define __NR_ptrace	26
-#define __NR_alarm	27
-#define __NR_oldfstat	28
-#define __NR_pause	29
-#define __NR_utime	30
-#define __NR_stty	31
-#define __NR_gtty	32
-#define __NR_access	33
-#define __NR_nice	34
-#define __NR_ftime	35
-#define __NR_sync	36
-#define __NR_kill	37
-#define __NR_rename	38
-#define __NR_mkdir	39
-#define __NR_rmdir	40
-#define __NR_dup	41
-#define __NR_pipe	42
-#define __NR_times	43
-#define __NR_prof	44
-#define __NR_brk	45
-#define __NR_setgid	46
-#define __NR_getgid	47
-#define __NR_signal	48
-#define __NR_geteuid	49
-#define __NR_getegid	50
-#define __NR_acct	51
-#define __NR_umount2	52
-#define __NR_lock	53
-#define __NR_ioctl	54
-#define __NR_fcntl	55
-#define __NR_mpx	56
-#define __NR_setpgid	57
-#define __NR_ulimit	58
-#define __NR_oldolduname	59
-#define __NR_umask	60
-#define __NR_chroot	61
-#define __NR_ustat	62
-#define __NR_dup2	63
-#define __NR_getppid	64
-#define __NR_getpgrp	65
-#define __NR_setsid	66
-#define __NR_sigaction	67
-#define __NR_sgetmask	68
-#define __NR_ssetmask	69
-#define __NR_setreuid	70
-#define __NR_setregid	71
-#define __NR_sigsuspend	72
-#define __NR_sigpending	73
-#define __NR_sethostname	74
-#define __NR_setrlimit	75
-#define __NR_getrlimit	76
-#define __NR_getrusage	77
-#define __NR_gettimeofday	78
-#define __NR_settimeofday	79
-#define __NR_getgroups	80
-#define __NR_setgroups	81
-#define __NR_select	82
-#define __NR_symlink	83
-#define __NR_oldlstat	84
-#define __NR_readlink	85
-#define __NR_uselib	86
-#define __NR_swapon	87
-#define __NR_reboot	88
-#define __NR_readdir	89
-#define __NR_mmap	90
-#define __NR_munmap	91
-#define __NR_truncate	92
-#define __NR_ftruncate	93
-#define __NR_fchmod	94
-#define __NR_fchown	95
-#define __NR_getpriority	96
-#define __NR_setpriority	97
-#define __NR_profil	98
-#define __NR_statfs	99
-#define __NR_fstatfs	100
-#define __NR_ioperm	101
-#define __NR_socketcall	102
-#define __NR_syslog	103
-#define __NR_setitimer	104
-#define __NR_getitimer	105
-#define __NR_stat	106
-#define __NR_lstat	107
-#define __NR_fstat	108
-#define __NR_olduname	109
-#define __NR_iopl	110
-#define __NR_vhangup	111
-#define __NR_idle	112
-#define __NR_vm86	113
-#define __NR_wait4	114
-#define __NR_swapoff	115
-#define __NR_sysinfo	116
-#define __NR_ipc	117
-#define __NR_fsync	118
-#define __NR_sigreturn	119
-#define __NR_clone	120
-#define __NR_setdomainname	121
-#define __NR_uname	122
-#define __NR_modify_ldt	123
-#define __NR_adjtimex	124
-#define __NR_mprotect	125
-#define __NR_sigprocmask	126
-#define __NR_create_module	127
-#define __NR_init_module	128
-#define __NR_delete_module	129
-#define __NR_get_kernel_syms	130
-#define __NR_quotactl	131
-#define __NR_getpgid	132
-#define __NR_fchdir	133
-#define __NR_bdflush	134
-#define __NR_sysfs	135
-#define __NR_personality	136
-#define __NR_afs_syscall	137
-#define __NR_setfsuid	138
-#define __NR_setfsgid	139
-#define __NR__llseek	140
-#define __NR_getdents	141
-#define __NR__newselect	142
-#define __NR_flock	143
-#define __NR_msync	144
-#define __NR_readv	145
-#define __NR_writev	146
-#define __NR_getsid	147
-#define __NR_fdatasync	148
-#define __NR__sysctl	149
-#define __NR_mlock	150
-#define __NR_munlock	151
-#define __NR_mlockall	152
-#define __NR_munlockall	153
-#define __NR_sched_setparam	154
-#define __NR_sched_getparam	155
-#define __NR_sched_setscheduler	156
-#define __NR_sched_getscheduler	157
-#define __NR_sched_yield	158
-#define __NR_sched_get_priority_max	159
-#define __NR_sched_get_priority_min	160
-#define __NR_sched_rr_get_interval	161
-#define __NR_nanosleep	162
-#define __NR_mremap	163
-#define __NR_setresuid	164
-#define __NR_getresuid	165
-#define __NR_query_module	166
-#define __NR_poll	167
-#define __NR_nfsservctl	168
-#define __NR_setresgid	169
-#define __NR_getresgid	170
-#define __NR_prctl	171
-#define __NR_rt_sigreturn	172
-#define __NR_rt_sigaction	173
-#define __NR_rt_sigprocmask	174
-#define __NR_rt_sigpending	175
-#define __NR_rt_sigtimedwait	176
-#define __NR_rt_sigqueueinfo	177
-#define __NR_rt_sigsuspend	178
-#define __NR_pread64	179
-#define __NR_pwrite64	180
-#define __NR_chown	181
-#define __NR_getcwd	182
-#define __NR_capget	183
-#define __NR_capset	184
-#define __NR_sigaltstack	185
-#define __NR_sendfile	186
-#define __NR_getpmsg	187
-#define __NR_putpmsg	188
-#define __NR_vfork	189
-#define __NR_ugetrlimit	190
-#define __NR_readahead	191
-#define __NR_pciconfig_read	198
-#define __NR_pciconfig_write	199
-#define __NR_pciconfig_iobase	200
-#define __NR_multiplexer	201
-#define __NR_getdents64	202
-#define __NR_pivot_root	203
-#define __NR_madvise	205
-#define __NR_mincore	206
-#define __NR_gettid	207
-#define __NR_tkill	208
-#define __NR_setxattr	209
-#define __NR_lsetxattr	210
-#define __NR_fsetxattr	211
-#define __NR_getxattr	212
-#define __NR_lgetxattr	213
-#define __NR_fgetxattr	214
-#define __NR_listxattr	215
-#define __NR_llistxattr	216
-#define __NR_flistxattr	217
-#define __NR_removexattr	218
-#define __NR_lremovexattr	219
-#define __NR_fremovexattr	220
-#define __NR_futex	221
-#define __NR_sched_setaffinity	222
-#define __NR_sched_getaffinity	223
-#define __NR_tuxcall	225
-#define __NR_io_setup	227
-#define __NR_io_destroy	228
-#define __NR_io_getevents	229
-#define __NR_io_submit	230
-#define __NR_io_cancel	231
-#define __NR_set_tid_address	232
-#define __NR_fadvise64	233
-#define __NR_exit_group	234
-#define __NR_lookup_dcookie	235
-#define __NR_epoll_create	236
-#define __NR_epoll_ctl	237
-#define __NR_epoll_wait	238
-#define __NR_remap_file_pages	239
-#define __NR_timer_create	240
-#define __NR_timer_settime	241
-#define __NR_timer_gettime	242
-#define __NR_timer_getoverrun	243
-#define __NR_timer_delete	244
-#define __NR_clock_settime	245
-#define __NR_clock_gettime	246
-#define __NR_clock_getres	247
-#define __NR_clock_nanosleep	248
-#define __NR_swapcontext	249
-#define __NR_tgkill	250
-#define __NR_utimes	251
-#define __NR_statfs64	252
-#define __NR_fstatfs64	253
-#define __NR_rtas	255
-#define __NR_sys_debug_setcontext	256
-#define __NR_migrate_pages	258
-#define __NR_mbind	259
-#define __NR_get_mempolicy	260
-#define __NR_set_mempolicy	261
-#define __NR_mq_open	262
-#define __NR_mq_unlink	263
-#define __NR_mq_timedsend	264
-#define __NR_mq_timedreceive	265
-#define __NR_mq_notify	266
-#define __NR_mq_getsetattr	267
-#define __NR_kexec_load	268
-#define __NR_add_key	269
-#define __NR_request_key	270
-#define __NR_keyctl	271
-#define __NR_waitid	272
-#define __NR_ioprio_set	273
-#define __NR_ioprio_get	274
-#define __NR_inotify_init	275
-#define __NR_inotify_add_watch	276
-#define __NR_inotify_rm_watch	277
-#define __NR_spu_run	278
-#define __NR_spu_create	279
-#define __NR_pselect6	280
-#define __NR_ppoll	281
-#define __NR_unshare	282
-#define __NR_splice	283
-#define __NR_tee	284
-#define __NR_vmsplice	285
-#define __NR_openat	286
-#define __NR_mkdirat	287
-#define __NR_mknodat	288
-#define __NR_fchownat	289
-#define __NR_futimesat	290
-#define __NR_newfstatat	291
-#define __NR_unlinkat	292
-#define __NR_renameat	293
-#define __NR_linkat	294
-#define __NR_symlinkat	295
-#define __NR_readlinkat	296
-#define __NR_fchmodat	297
-#define __NR_faccessat	298
-#define __NR_get_robust_list	299
-#define __NR_set_robust_list	300
-#define __NR_move_pages	301
-#define __NR_getcpu	302
-#define __NR_epoll_pwait	303
-#define __NR_utimensat	304
-#define __NR_signalfd	305
-#define __NR_timerfd_create	306
-#define __NR_eventfd	307
-#define __NR_sync_file_range2	308
-#define __NR_fallocate	309
-#define __NR_subpage_prot	310
-#define __NR_timerfd_settime	311
-#define __NR_timerfd_gettime	312
-#define __NR_signalfd4	313
-#define __NR_eventfd2	314
-#define __NR_epoll_create1	315
-#define __NR_dup3	316
-#define __NR_pipe2	317
-#define __NR_inotify_init1	318
-#define __NR_perf_event_open	319
-#define __NR_preadv	320
-#define __NR_pwritev	321
-#define __NR_rt_tgsigqueueinfo	322
-#define __NR_fanotify_init	323
-#define __NR_fanotify_mark	324
-#define __NR_prlimit64	325
-#define __NR_socket	326
-#define __NR_bind	327
-#define __NR_connect	328
-#define __NR_listen	329
-#define __NR_accept	330
-#define __NR_getsockname	331
-#define __NR_getpeername	332
-#define __NR_socketpair	333
-#define __NR_send	334
-#define __NR_sendto	335
-#define __NR_recv	336
-#define __NR_recvfrom	337
-#define __NR_shutdown	338
-#define __NR_setsockopt	339
-#define __NR_getsockopt	340
-#define __NR_sendmsg	341
-#define __NR_recvmsg	342
-#define __NR_recvmmsg	343
-#define __NR_accept4	344
-#define __NR_name_to_handle_at	345
-#define __NR_open_by_handle_at	346
-#define __NR_clock_adjtime	347
-#define __NR_syncfs	348
-#define __NR_sendmmsg	349
-#define __NR_setns	350
-#define __NR_process_vm_readv	351
-#define __NR_process_vm_writev	352
-#define __NR_finit_module	353
-#define __NR_kcmp	354
-#define __NR_sched_setattr	355
-#define __NR_sched_getattr	356
-#define __NR_renameat2	357
-#define __NR_seccomp	358
-#define __NR_getrandom	359
-#define __NR_memfd_create	360
-#define __NR_bpf	361
-#define __NR_execveat	362
-#define __NR_switch_endian	363
-#define __NR_userfaultfd	364
-#define __NR_membarrier	365
-#define __NR_mlock2	378
-#define __NR_copy_file_range	379
-#define __NR_preadv2	380
-#define __NR_pwritev2	381
-#define __NR_kexec_file_load	382
-#define __NR_statx	383
-#define __NR_pkey_alloc	384
-#define __NR_pkey_free	385
-#define __NR_pkey_mprotect	386
-#define __NR_rseq	387
-#define __NR_io_pgetevents	388
-#define __NR_semtimedop	392
-#define __NR_semget	393
-#define __NR_semctl	394
-#define __NR_shmget	395
-#define __NR_shmctl	396
-#define __NR_shmat	397
-#define __NR_shmdt	398
-#define __NR_msgget	399
-#define __NR_msgsnd	400
-#define __NR_msgrcv	401
-#define __NR_msgctl	402
-#define __NR_pidfd_send_signal	424
-#define __NR_io_uring_setup	425
-#define __NR_io_uring_enter	426
-#define __NR_io_uring_register	427
-#define __NR_open_tree	428
-#define __NR_move_mount	429
-#define __NR_fsopen	430
-#define __NR_fsconfig	431
-#define __NR_fsmount	432
-#define __NR_fspick	433
-#define __NR_pidfd_open	434
-#define __NR_clone3	435
-#define __NR_close_range	436
-#define __NR_openat2	437
-#define __NR_pidfd_getfd	438
-#define __NR_faccessat2	439
-#define __NR_process_madvise	440
-#define __NR_epoll_pwait2	441
+#define __NR_restart_syscall 0
+#define __NR_exit 1
+#define __NR_fork 2
+#define __NR_read 3
+#define __NR_write 4
+#define __NR_open 5
+#define __NR_close 6
+#define __NR_waitpid 7
+#define __NR_creat 8
+#define __NR_link 9
+#define __NR_unlink 10
+#define __NR_execve 11
+#define __NR_chdir 12
+#define __NR_time 13
+#define __NR_mknod 14
+#define __NR_chmod 15
+#define __NR_lchown 16
+#define __NR_break 17
+#define __NR_oldstat 18
+#define __NR_lseek 19
+#define __NR_getpid 20
+#define __NR_mount 21
+#define __NR_umount 22
+#define __NR_setuid 23
+#define __NR_getuid 24
+#define __NR_stime 25
+#define __NR_ptrace 26
+#define __NR_alarm 27
+#define __NR_oldfstat 28
+#define __NR_pause 29
+#define __NR_utime 30
+#define __NR_stty 31
+#define __NR_gtty 32
+#define __NR_access 33
+#define __NR_nice 34
+#define __NR_ftime 35
+#define __NR_sync 36
+#define __NR_kill 37
+#define __NR_rename 38
+#define __NR_mkdir 39
+#define __NR_rmdir 40
+#define __NR_dup 41
+#define __NR_pipe 42
+#define __NR_times 43
+#define __NR_prof 44
+#define __NR_brk 45
+#define __NR_setgid 46
+#define __NR_getgid 47
+#define __NR_signal 48
+#define __NR_geteuid 49
+#define __NR_getegid 50
+#define __NR_acct 51
+#define __NR_umount2 52
+#define __NR_lock 53
+#define __NR_ioctl 54
+#define __NR_fcntl 55
+#define __NR_mpx 56
+#define __NR_setpgid 57
+#define __NR_ulimit 58
+#define __NR_oldolduname 59
+#define __NR_umask 60
+#define __NR_chroot 61
+#define __NR_ustat 62
+#define __NR_dup2 63
+#define __NR_getppid 64
+#define __NR_getpgrp 65
+#define __NR_setsid 66
+#define __NR_sigaction 67
+#define __NR_sgetmask 68
+#define __NR_ssetmask 69
+#define __NR_setreuid 70
+#define __NR_setregid 71
+#define __NR_sigsuspend 72
+#define __NR_sigpending 73
+#define __NR_sethostname 74
+#define __NR_setrlimit 75
+#define __NR_getrlimit 76
+#define __NR_getrusage 77
+#define __NR_gettimeofday 78
+#define __NR_settimeofday 79
+#define __NR_getgroups 80
+#define __NR_setgroups 81
+#define __NR_select 82
+#define __NR_symlink 83
+#define __NR_oldlstat 84
+#define __NR_readlink 85
+#define __NR_uselib 86
+#define __NR_swapon 87
+#define __NR_reboot 88
+#define __NR_readdir 89
+#define __NR_mmap 90
+#define __NR_munmap 91
+#define __NR_truncate 92
+#define __NR_ftruncate 93
+#define __NR_fchmod 94
+#define __NR_fchown 95
+#define __NR_getpriority 96
+#define __NR_setpriority 97
+#define __NR_profil 98
+#define __NR_statfs 99
+#define __NR_fstatfs 100
+#define __NR_ioperm 101
+#define __NR_socketcall 102
+#define __NR_syslog 103
+#define __NR_setitimer 104
+#define __NR_getitimer 105
+#define __NR_stat 106
+#define __NR_lstat 107
+#define __NR_fstat 108
+#define __NR_olduname 109
+#define __NR_iopl 110
+#define __NR_vhangup 111
+#define __NR_idle 112
+#define __NR_vm86 113
+#define __NR_wait4 114
+#define __NR_swapoff 115
+#define __NR_sysinfo 116
+#define __NR_ipc 117
+#define __NR_fsync 118
+#define __NR_sigreturn 119
+#define __NR_clone 120
+#define __NR_setdomainname 121
+#define __NR_uname 122
+#define __NR_modify_ldt 123
+#define __NR_adjtimex 124
+#define __NR_mprotect 125
+#define __NR_sigprocmask 126
+#define __NR_create_module 127
+#define __NR_init_module 128
+#define __NR_delete_module 129
+#define __NR_get_kernel_syms 130
+#define __NR_quotactl 131
+#define __NR_getpgid 132
+#define __NR_fchdir 133
+#define __NR_bdflush 134
+#define __NR_sysfs 135
+#define __NR_personality 136
+#define __NR_afs_syscall 137
+#define __NR_setfsuid 138
+#define __NR_setfsgid 139
+#define __NR__llseek 140
+#define __NR_getdents 141
+#define __NR__newselect 142
+#define __NR_flock 143
+#define __NR_msync 144
+#define __NR_readv 145
+#define __NR_writev 146
+#define __NR_getsid 147
+#define __NR_fdatasync 148
+#define __NR__sysctl 149
+#define __NR_mlock 150
+#define __NR_munlock 151
+#define __NR_mlockall 152
+#define __NR_munlockall 153
+#define __NR_sched_setparam 154
+#define __NR_sched_getparam 155
+#define __NR_sched_setscheduler 156
+#define __NR_sched_getscheduler 157
+#define __NR_sched_yield 158
+#define __NR_sched_get_priority_max 159
+#define __NR_sched_get_priority_min 160
+#define __NR_sched_rr_get_interval 161
+#define __NR_nanosleep 162
+#define __NR_mremap 163
+#define __NR_setresuid 164
+#define __NR_getresuid 165
+#define __NR_query_module 166
+#define __NR_poll 167
+#define __NR_nfsservctl 168
+#define __NR_setresgid 169
+#define __NR_getresgid 170
+#define __NR_prctl 171
+#define __NR_rt_sigreturn 172
+#define __NR_rt_sigaction 173
+#define __NR_rt_sigprocmask 174
+#define __NR_rt_sigpending 175
+#define __NR_rt_sigtimedwait 176
+#define __NR_rt_sigqueueinfo 177
+#define __NR_rt_sigsuspend 178
+#define __NR_pread64 179
+#define __NR_pwrite64 180
+#define __NR_chown 181
+#define __NR_getcwd 182
+#define __NR_capget 183
+#define __NR_capset 184
+#define __NR_sigaltstack 185
+#define __NR_sendfile 186
+#define __NR_getpmsg 187
+#define __NR_putpmsg 188
+#define __NR_vfork 189
+#define __NR_ugetrlimit 190
+#define __NR_readahead 191
+#define __NR_pciconfig_read 198
+#define __NR_pciconfig_write 199
+#define __NR_pciconfig_iobase 200
+#define __NR_multiplexer 201
+#define __NR_getdents64 202
+#define __NR_pivot_root 203
+#define __NR_madvise 205
+#define __NR_mincore 206
+#define __NR_gettid 207
+#define __NR_tkill 208
+#define __NR_setxattr 209
+#define __NR_lsetxattr 210
+#define __NR_fsetxattr 211
+#define __NR_getxattr 212
+#define __NR_lgetxattr 213
+#define __NR_fgetxattr 214
+#define __NR_listxattr 215
+#define __NR_llistxattr 216
+#define __NR_flistxattr 217
+#define __NR_removexattr 218
+#define __NR_lremovexattr 219
+#define __NR_fremovexattr 220
+#define __NR_futex 221
+#define __NR_sched_setaffinity 222
+#define __NR_sched_getaffinity 223
+#define __NR_tuxcall 225
+#define __NR_io_setup 227
+#define __NR_io_destroy 228
+#define __NR_io_getevents 229
+#define __NR_io_submit 230
+#define __NR_io_cancel 231
+#define __NR_set_tid_address 232
+#define __NR_fadvise64 233
+#define __NR_exit_group 234
+#define __NR_lookup_dcookie 235
+#define __NR_epoll_create 236
+#define __NR_epoll_ctl 237
+#define __NR_epoll_wait 238
+#define __NR_remap_file_pages 239
+#define __NR_timer_create 240
+#define __NR_timer_settime 241
+#define __NR_timer_gettime 242
+#define __NR_timer_getoverrun 243
+#define __NR_timer_delete 244
+#define __NR_clock_settime 245
+#define __NR_clock_gettime 246
+#define __NR_clock_getres 247
+#define __NR_clock_nanosleep 248
+#define __NR_swapcontext 249
+#define __NR_tgkill 250
+#define __NR_utimes 251
+#define __NR_statfs64 252
+#define __NR_fstatfs64 253
+#define __NR_rtas 255
+#define __NR_sys_debug_setcontext 256
+#define __NR_migrate_pages 258
+#define __NR_mbind 259
+#define __NR_get_mempolicy 260
+#define __NR_set_mempolicy 261
+#define __NR_mq_open 262
+#define __NR_mq_unlink 263
+#define __NR_mq_timedsend 264
+#define __NR_mq_timedreceive 265
+#define __NR_mq_notify 266
+#define __NR_mq_getsetattr 267
+#define __NR_kexec_load 268
+#define __NR_add_key 269
+#define __NR_request_key 270
+#define __NR_keyctl 271
+#define __NR_waitid 272
+#define __NR_ioprio_set 273
+#define __NR_ioprio_get 274
+#define __NR_inotify_init 275
+#define __NR_inotify_add_watch 276
+#define __NR_inotify_rm_watch 277
+#define __NR_spu_run 278
+#define __NR_spu_create 279
+#define __NR_pselect6 280
+#define __NR_ppoll 281
+#define __NR_unshare 282
+#define __NR_splice 283
+#define __NR_tee 284
+#define __NR_vmsplice 285
+#define __NR_openat 286
+#define __NR_mkdirat 287
+#define __NR_mknodat 288
+#define __NR_fchownat 289
+#define __NR_futimesat 290
+#define __NR_newfstatat 291
+#define __NR_unlinkat 292
+#define __NR_renameat 293
+#define __NR_linkat 294
+#define __NR_symlinkat 295
+#define __NR_readlinkat 296
+#define __NR_fchmodat 297
+#define __NR_faccessat 298
+#define __NR_get_robust_list 299
+#define __NR_set_robust_list 300
+#define __NR_move_pages 301
+#define __NR_getcpu 302
+#define __NR_epoll_pwait 303
+#define __NR_utimensat 304
+#define __NR_signalfd 305
+#define __NR_timerfd_create 306
+#define __NR_eventfd 307
+#define __NR_sync_file_range2 308
+#define __NR_fallocate 309
+#define __NR_subpage_prot 310
+#define __NR_timerfd_settime 311
+#define __NR_timerfd_gettime 312
+#define __NR_signalfd4 313
+#define __NR_eventfd2 314
+#define __NR_epoll_create1 315
+#define __NR_dup3 316
+#define __NR_pipe2 317
+#define __NR_inotify_init1 318
+#define __NR_perf_event_open 319
+#define __NR_preadv 320
+#define __NR_pwritev 321
+#define __NR_rt_tgsigqueueinfo 322
+#define __NR_fanotify_init 323
+#define __NR_fanotify_mark 324
+#define __NR_prlimit64 325
+#define __NR_socket 326
+#define __NR_bind 327
+#define __NR_connect 328
+#define __NR_listen 329
+#define __NR_accept 330
+#define __NR_getsockname 331
+#define __NR_getpeername 332
+#define __NR_socketpair 333
+#define __NR_send 334
+#define __NR_sendto 335
+#define __NR_recv 336
+#define __NR_recvfrom 337
+#define __NR_shutdown 338
+#define __NR_setsockopt 339
+#define __NR_getsockopt 340
+#define __NR_sendmsg 341
+#define __NR_recvmsg 342
+#define __NR_recvmmsg 343
+#define __NR_accept4 344
+#define __NR_name_to_handle_at 345
+#define __NR_open_by_handle_at 346
+#define __NR_clock_adjtime 347
+#define __NR_syncfs 348
+#define __NR_sendmmsg 349
+#define __NR_setns 350
+#define __NR_process_vm_readv 351
+#define __NR_process_vm_writev 352
+#define __NR_finit_module 353
+#define __NR_kcmp 354
+#define __NR_sched_setattr 355
+#define __NR_sched_getattr 356
+#define __NR_renameat2 357
+#define __NR_seccomp 358
+#define __NR_getrandom 359
+#define __NR_memfd_create 360
+#define __NR_bpf 361
+#define __NR_execveat 362
+#define __NR_switch_endian 363
+#define __NR_userfaultfd 364
+#define __NR_membarrier 365
+#define __NR_mlock2 378
+#define __NR_copy_file_range 379
+#define __NR_preadv2 380
+#define __NR_pwritev2 381
+#define __NR_kexec_file_load 382
+#define __NR_statx 383
+#define __NR_pkey_alloc 384
+#define __NR_pkey_free 385
+#define __NR_pkey_mprotect 386
+#define __NR_rseq 387
+#define __NR_io_pgetevents 388
+#define __NR_semtimedop 392
+#define __NR_semget 393
+#define __NR_semctl 394
+#define __NR_shmget 395
+#define __NR_shmctl 396
+#define __NR_shmat 397
+#define __NR_shmdt 398
+#define __NR_msgget 399
+#define __NR_msgsnd 400
+#define __NR_msgrcv 401
+#define __NR_msgctl 402
+#define __NR_pidfd_send_signal 424
+#define __NR_io_uring_setup 425
+#define __NR_io_uring_enter 426
+#define __NR_io_uring_register 427
+#define __NR_open_tree 428
+#define __NR_move_mount 429
+#define __NR_fsopen 430
+#define __NR_fsconfig 431
+#define __NR_fsmount 432
+#define __NR_fspick 433
+#define __NR_pidfd_open 434
+#define __NR_clone3 435
+#define __NR_close_range 436
+#define __NR_openat2 437
+#define __NR_pidfd_getfd 438
+#define __NR_faccessat2 439
+#define __NR_process_madvise 440
+#define __NR_epoll_pwait2 441
+#define __NR_mount_setattr 442
+#define __NR_landlock_create_ruleset 444
+#define __NR_landlock_add_rule 445
+#define __NR_landlock_restrict_self 446
 
 
-#endif /* _ASM_POWERPC_UNISTD_64_H */
+#endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-s390/unistd_32.h b/linux-headers/asm-s390/unistd_32.h
index c94d2c3a22..e8cd34334f 100644
--- a/linux-headers/asm-s390/unistd_32.h
+++ b/linux-headers/asm-s390/unistd_32.h
@@ -414,5 +414,9 @@
 #define __NR_faccessat2 439
 #define __NR_process_madvise 440
 #define __NR_epoll_pwait2 441
+#define __NR_mount_setattr 442
+#define __NR_landlock_create_ruleset 444
+#define __NR_landlock_add_rule 445
+#define __NR_landlock_restrict_self 446
 
 #endif /* _ASM_S390_UNISTD_32_H */
diff --git a/linux-headers/asm-s390/unistd_64.h b/linux-headers/asm-s390/unistd_64.h
index 984a06b7eb..86830e1e83 100644
--- a/linux-headers/asm-s390/unistd_64.h
+++ b/linux-headers/asm-s390/unistd_64.h
@@ -362,5 +362,9 @@
 #define __NR_faccessat2 439
 #define __NR_process_madvise 440
 #define __NR_epoll_pwait2 441
+#define __NR_mount_setattr 442
+#define __NR_landlock_create_ruleset 444
+#define __NR_landlock_add_rule 445
+#define __NR_landlock_restrict_self 446
 
 #endif /* _ASM_S390_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 8e76d3701d..0662f644aa 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -112,6 +112,7 @@ struct kvm_ioapic_state {
 #define KVM_NR_IRQCHIPS          3
 
 #define KVM_RUN_X86_SMM		 (1 << 0)
+#define KVM_RUN_X86_BUS_LOCK     (1 << 1)
 
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
@@ -436,6 +437,8 @@ struct kvm_vmx_nested_state_hdr {
 		__u16 flags;
 	} smm;
 
+	__u16 pad;
+
 	__u32 flags;
 	__u64 preemption_timer_deadline;
 };
diff --git a/linux-headers/asm-x86/unistd_32.h b/linux-headers/asm-x86/unistd_32.h
index 18fb99dfa2..8f6ac8c19f 100644
--- a/linux-headers/asm-x86/unistd_32.h
+++ b/linux-headers/asm-x86/unistd_32.h
@@ -432,6 +432,10 @@
 #define __NR_faccessat2 439
 #define __NR_process_madvise 440
 #define __NR_epoll_pwait2 441
+#define __NR_mount_setattr 442
+#define __NR_landlock_create_ruleset 444
+#define __NR_landlock_add_rule 445
+#define __NR_landlock_restrict_self 446
 
 
 #endif /* _ASM_X86_UNISTD_32_H */
diff --git a/linux-headers/asm-x86/unistd_64.h b/linux-headers/asm-x86/unistd_64.h
index bde959328d..bb187a9268 100644
--- a/linux-headers/asm-x86/unistd_64.h
+++ b/linux-headers/asm-x86/unistd_64.h
@@ -354,6 +354,10 @@
 #define __NR_faccessat2 439
 #define __NR_process_madvise 440
 #define __NR_epoll_pwait2 441
+#define __NR_mount_setattr 442
+#define __NR_landlock_create_ruleset 444
+#define __NR_landlock_add_rule 445
+#define __NR_landlock_restrict_self 446
 
 
 #endif /* _ASM_X86_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/unistd_x32.h b/linux-headers/asm-x86/unistd_x32.h
index 4ff6b17d3b..4edd0103ac 100644
--- a/linux-headers/asm-x86/unistd_x32.h
+++ b/linux-headers/asm-x86/unistd_x32.h
@@ -307,6 +307,10 @@
 #define __NR_faccessat2 (__X32_SYSCALL_BIT + 439)
 #define __NR_process_madvise (__X32_SYSCALL_BIT + 440)
 #define __NR_epoll_pwait2 (__X32_SYSCALL_BIT + 441)
+#define __NR_mount_setattr (__X32_SYSCALL_BIT + 442)
+#define __NR_landlock_create_ruleset (__X32_SYSCALL_BIT + 444)
+#define __NR_landlock_add_rule (__X32_SYSCALL_BIT + 445)
+#define __NR_landlock_restrict_self (__X32_SYSCALL_BIT + 446)
 #define __NR_rt_sigaction (__X32_SYSCALL_BIT + 512)
 #define __NR_rt_sigreturn (__X32_SYSCALL_BIT + 513)
 #define __NR_ioctl (__X32_SYSCALL_BIT + 514)
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 897f831374..20d6a263bb 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -8,6 +8,7 @@
  * Note: you must update KVM_API_VERSION if you change this interface.
  */
 
+#include <linux/const.h>
 #include <linux/types.h>
 
 #include <linux/ioctl.h>
@@ -216,6 +217,20 @@ struct kvm_hyperv_exit {
 	} u;
 };
 
+struct kvm_xen_exit {
+#define KVM_EXIT_XEN_HCALL          1
+	__u32 type;
+	union {
+		struct {
+			__u32 longmode;
+			__u32 cpl;
+			__u64 input;
+			__u64 result;
+			__u64 params[6];
+		} hcall;
+	} u;
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -251,6 +266,9 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_X86_RDMSR        29
 #define KVM_EXIT_X86_WRMSR        30
 #define KVM_EXIT_DIRTY_RING_FULL  31
+#define KVM_EXIT_AP_RESET_HOLD    32
+#define KVM_EXIT_X86_BUS_LOCK     33
+#define KVM_EXIT_XEN              34
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -427,6 +445,8 @@ struct kvm_run {
 			__u32 index; /* kernel -> user */
 			__u64 data; /* kernel <-> user */
 		} msr;
+		/* KVM_EXIT_XEN */
+		struct kvm_xen_exit xen;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -573,6 +593,7 @@ struct kvm_vapic_addr {
 #define KVM_MP_STATE_CHECK_STOP        6
 #define KVM_MP_STATE_OPERATING         7
 #define KVM_MP_STATE_LOAD              8
+#define KVM_MP_STATE_AP_RESET_HOLD     9
 
 struct kvm_mp_state {
 	__u32 mp_state;
@@ -1056,6 +1077,12 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
 #define KVM_CAP_SYS_HYPERV_CPUID 191
 #define KVM_CAP_DIRTY_LOG_RING 192
+#define KVM_CAP_X86_BUS_LOCK_EXIT 193
+#define KVM_CAP_PPC_DAWR1 194
+#define KVM_CAP_SET_GUEST_DEBUG2 195
+#define KVM_CAP_SGX_ATTRIBUTE 196
+#define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
+#define KVM_CAP_PTP_KVM 198
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1129,6 +1156,11 @@ struct kvm_x86_mce {
 #endif
 
 #ifdef KVM_CAP_XEN_HVM
+#define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
+#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
+
 struct kvm_xen_hvm_config {
 	__u32 flags;
 	__u32 msr;
@@ -1563,6 +1595,57 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_DIRTY_LOG_RING */
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
+/* Per-VM Xen attributes */
+#define KVM_XEN_HVM_GET_ATTR	_IOWR(KVMIO, 0xc8, struct kvm_xen_hvm_attr)
+#define KVM_XEN_HVM_SET_ATTR	_IOW(KVMIO,  0xc9, struct kvm_xen_hvm_attr)
+
+struct kvm_xen_hvm_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u8 long_mode;
+		__u8 vector;
+		struct {
+			__u64 gfn;
+		} shared_info;
+		__u64 pad[8];
+	} u;
+};
+
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
+#define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
+#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
+
+/* Per-vCPU Xen attributes */
+#define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
+#define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
+
+struct kvm_xen_vcpu_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u64 gpa;
+		__u64 pad[8];
+		struct {
+			__u64 state;
+			__u64 state_entry_time;
+			__u64 time_running;
+			__u64 time_runnable;
+			__u64 time_blocked;
+			__u64 time_offline;
+		} runstate;
+	} u;
+};
+
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO	0x1
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR	0x2
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT	0x3
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
@@ -1593,6 +1676,8 @@ enum sev_cmd_id {
 	KVM_SEV_CERT_EXPORT,
 	/* Attestation report */
 	KVM_SEV_GET_ATTESTATION_REPORT,
+	/* Guest Migration Extension */
+	KVM_SEV_SEND_CANCEL,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1651,6 +1736,45 @@ struct kvm_sev_attestation_report {
 	__u32 len;
 };
 
+struct kvm_sev_send_start {
+	__u32 policy;
+	__u64 pdh_cert_uaddr;
+	__u32 pdh_cert_len;
+	__u64 plat_certs_uaddr;
+	__u32 plat_certs_len;
+	__u64 amd_certs_uaddr;
+	__u32 amd_certs_len;
+	__u64 session_uaddr;
+	__u32 session_len;
+};
+
+struct kvm_sev_send_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+};
+
+struct kvm_sev_receive_start {
+	__u32 handle;
+	__u32 policy;
+	__u64 pdh_uaddr;
+	__u32 pdh_len;
+	__u64 session_uaddr;
+	__u32 session_len;
+};
+
+struct kvm_sev_receive_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
@@ -1756,8 +1880,8 @@ struct kvm_hyperv_eventfd {
  * conversion after harvesting an entry.  Also, it must not skip any
  * dirty bits, so that dirty bits are always harvested in sequence.
  */
-#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
-#define KVM_DIRTY_GFN_F_RESET           BIT(1)
+#define KVM_DIRTY_GFN_F_DIRTY           _BITUL(0)
+#define KVM_DIRTY_GFN_F_RESET           _BITUL(1)
 #define KVM_DIRTY_GFN_F_MASK            0x3
 
 /*
@@ -1772,4 +1896,7 @@ struct kvm_dirty_gfn {
 	__u64 offset;
 };
 
+#define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
+#define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
+
 #endif /* __LINUX_KVM_H */
diff --git a/linux-headers/linux/userfaultfd.h b/linux-headers/linux/userfaultfd.h
index 1ba9a9feeb..b9ac97b70f 100644
--- a/linux-headers/linux/userfaultfd.h
+++ b/linux-headers/linux/userfaultfd.h
@@ -19,15 +19,19 @@
  * means the userland is reading).
  */
 #define UFFD_API ((__u64)0xAA)
+#define UFFD_API_REGISTER_MODES (UFFDIO_REGISTER_MODE_MISSING |	\
+				 UFFDIO_REGISTER_MODE_WP |	\
+				 UFFDIO_REGISTER_MODE_MINOR)
 #define UFFD_API_FEATURES (UFFD_FEATURE_PAGEFAULT_FLAG_WP |	\
 			   UFFD_FEATURE_EVENT_FORK |		\
 			   UFFD_FEATURE_EVENT_REMAP |		\
-			   UFFD_FEATURE_EVENT_REMOVE |	\
+			   UFFD_FEATURE_EVENT_REMOVE |		\
 			   UFFD_FEATURE_EVENT_UNMAP |		\
 			   UFFD_FEATURE_MISSING_HUGETLBFS |	\
 			   UFFD_FEATURE_MISSING_SHMEM |		\
 			   UFFD_FEATURE_SIGBUS |		\
-			   UFFD_FEATURE_THREAD_ID)
+			   UFFD_FEATURE_THREAD_ID |		\
+			   UFFD_FEATURE_MINOR_HUGETLBFS)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -36,10 +40,12 @@
 	((__u64)1 << _UFFDIO_WAKE |		\
 	 (__u64)1 << _UFFDIO_COPY |		\
 	 (__u64)1 << _UFFDIO_ZEROPAGE |		\
-	 (__u64)1 << _UFFDIO_WRITEPROTECT)
+	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
+	 (__u64)1 << _UFFDIO_CONTINUE)
 #define UFFD_API_RANGE_IOCTLS_BASIC		\
 	((__u64)1 << _UFFDIO_WAKE |		\
-	 (__u64)1 << _UFFDIO_COPY)
+	 (__u64)1 << _UFFDIO_COPY |		\
+	 (__u64)1 << _UFFDIO_CONTINUE)
 
 /*
  * Valid ioctl command number range with this API is from 0x00 to
@@ -55,6 +61,7 @@
 #define _UFFDIO_COPY			(0x03)
 #define _UFFDIO_ZEROPAGE		(0x04)
 #define _UFFDIO_WRITEPROTECT		(0x06)
+#define _UFFDIO_CONTINUE		(0x07)
 #define _UFFDIO_API			(0x3F)
 
 /* userfaultfd ioctl ids */
@@ -73,6 +80,8 @@
 				      struct uffdio_zeropage)
 #define UFFDIO_WRITEPROTECT	_IOWR(UFFDIO, _UFFDIO_WRITEPROTECT, \
 				      struct uffdio_writeprotect)
+#define UFFDIO_CONTINUE		_IOR(UFFDIO, _UFFDIO_CONTINUE,	\
+				     struct uffdio_continue)
 
 /* read() structure */
 struct uffd_msg {
@@ -127,6 +136,7 @@ struct uffd_msg {
 /* flags for UFFD_EVENT_PAGEFAULT */
 #define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
 #define UFFD_PAGEFAULT_FLAG_WP		(1<<1)	/* If reason is VM_UFFD_WP */
+#define UFFD_PAGEFAULT_FLAG_MINOR	(1<<2)	/* If reason is VM_UFFD_MINOR */
 
 struct uffdio_api {
 	/* userland asks for an API number and the features to enable */
@@ -171,6 +181,10 @@ struct uffdio_api {
 	 *
 	 * UFFD_FEATURE_THREAD_ID pid of the page faulted task_struct will
 	 * be returned, if feature is not requested 0 will be returned.
+	 *
+	 * UFFD_FEATURE_MINOR_HUGETLBFS indicates that minor faults
+	 * can be intercepted (via REGISTER_MODE_MINOR) for
+	 * hugetlbfs-backed pages.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -181,6 +195,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_EVENT_UNMAP		(1<<6)
 #define UFFD_FEATURE_SIGBUS			(1<<7)
 #define UFFD_FEATURE_THREAD_ID			(1<<8)
+#define UFFD_FEATURE_MINOR_HUGETLBFS		(1<<9)
 	__u64 features;
 
 	__u64 ioctls;
@@ -195,6 +210,7 @@ struct uffdio_register {
 	struct uffdio_range range;
 #define UFFDIO_REGISTER_MODE_MISSING	((__u64)1<<0)
 #define UFFDIO_REGISTER_MODE_WP		((__u64)1<<1)
+#define UFFDIO_REGISTER_MODE_MINOR	((__u64)1<<2)
 	__u64 mode;
 
 	/*
@@ -257,6 +273,18 @@ struct uffdio_writeprotect {
 	__u64 mode;
 };
 
+struct uffdio_continue {
+	struct uffdio_range range;
+#define UFFDIO_CONTINUE_MODE_DONTWAKE		((__u64)1<<0)
+	__u64 mode;
+
+	/*
+	 * Fields below here are written by the ioctl and must be at the end:
+	 * the copy_from_user will not read past here.
+	 */
+	__s64 mapped;
+};
+
 /*
  * Flags for the userfaultfd(2) system call itself.
  */
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index 609099e455..e680594f27 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -46,6 +46,12 @@
  */
 #define VFIO_NOIOMMU_IOMMU		8
 
+/* Supports VFIO_DMA_UNMAP_FLAG_ALL */
+#define VFIO_UNMAP_ALL			9
+
+/* Supports the vaddr flag for DMA map and unmap */
+#define VFIO_UPDATE_VADDR		10
+
 /*
  * The IOCTL interface is designed for extensibility by embedding the
  * structure length (argsz) and flags into structures passed between
@@ -329,6 +335,8 @@ struct vfio_region_info_cap_type {
 /* 10de vendor PCI sub-types */
 /*
  * NVIDIA GPU NVlink2 RAM is coherent RAM mapped onto the host address space.
+ *
+ * Deprecated, region no longer provided
  */
 #define VFIO_REGION_SUBTYPE_NVIDIA_NVLINK2_RAM	(1)
 
@@ -336,6 +344,8 @@ struct vfio_region_info_cap_type {
 /*
  * IBM NPU NVlink2 ATSD (Address Translation Shootdown) register of NPU
  * to do TLB invalidation on a GPU.
+ *
+ * Deprecated, region no longer provided
  */
 #define VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD	(1)
 
@@ -635,6 +645,8 @@ struct vfio_device_migration_info {
  * Capability with compressed real address (aka SSA - small system address)
  * where GPU RAM is mapped on a system bus. Used by a GPU for DMA routing
  * and by the userspace to associate a NVLink bridge with a GPU.
+ *
+ * Deprecated, capability no longer provided
  */
 #define VFIO_REGION_INFO_CAP_NVLINK2_SSATGT	4
 
@@ -649,6 +661,8 @@ struct vfio_region_info_cap_nvlink2_ssatgt {
  * property in the device tree. The value is fixed in the hardware
  * and failing to provide the correct value results in the link
  * not working with no indication from the driver why.
+ *
+ * Deprecated, capability no longer provided
  */
 #define VFIO_REGION_INFO_CAP_NVLINK2_LNKSPD	5
 
@@ -1074,12 +1088,22 @@ struct vfio_iommu_type1_info_dma_avail {
  *
  * Map process virtual addresses to IO virtual addresses using the
  * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
+ *
+ * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova, and
+ * unblock translation of host virtual addresses in the iova range.  The vaddr
+ * must have previously been invalidated with VFIO_DMA_UNMAP_FLAG_VADDR.  To
+ * maintain memory consistency within the user application, the updated vaddr
+ * must address the same memory object as originally mapped.  Failure to do so
+ * will result in user memory corruption and/or device misbehavior.  iova and
+ * size must match those in the original MAP_DMA call.  Protection is not
+ * changed, and the READ & WRITE flags must be 0.
  */
 struct vfio_iommu_type1_dma_map {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
 #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
+#define VFIO_DMA_MAP_FLAG_VADDR (1 << 2)
 	__u64	vaddr;				/* Process virtual address */
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
@@ -1102,6 +1126,7 @@ struct vfio_bitmap {
  * field.  No guarantee is made to the user that arbitrary unmaps of iova
  * or size different from those used in the original mapping call will
  * succeed.
+ *
  * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get the dirty bitmap
  * before unmapping IO virtual addresses. When this flag is set, the user must
  * provide a struct vfio_bitmap in data[]. User must provide zero-allocated
@@ -1111,11 +1136,21 @@ struct vfio_bitmap {
  * indicates that the page at that offset from iova is dirty. A Bitmap of the
  * pages in the range of unmapped size is returned in the user-provided
  * vfio_bitmap.data.
+ *
+ * If flags & VFIO_DMA_UNMAP_FLAG_ALL, unmap all addresses.  iova and size
+ * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
+ *
+ * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
+ * virtual addresses in the iova range.  Tasks that attempt to translate an
+ * iova's vaddr will block.  DMA to already-mapped pages continues.  This
+ * cannot be combined with the get-dirty-bitmap flag.
  */
 struct vfio_iommu_type1_dma_unmap {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
+#define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
+#define VFIO_DMA_UNMAP_FLAG_VADDR	     (1 << 2)
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
 	__u8    data[];
-- 
2.25.4

