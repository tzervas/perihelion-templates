<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <!-- Add performance and security optimizations -->
  <xsl:template match="/domain">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()"/>
      
      <!-- Memory tuning -->
      <memtune>
        <hard_limit unit="KiB">0</hard_limit>
        <soft_limit unit="KiB">0</soft_limit>
        <swap_hard_limit unit="KiB">0</swap_hard_limit>
      </memtune>

      <!-- CPU tuning -->
      <cputune>
        <shares>1024</shares>
        <period>1000000</period>
        <quota>-1</quota>
      </cputune>

      <!-- Features -->
      <features>
        <acpi/>
        <apic/>
        <pae/>
        <vmport state="off"/>
        <kvm>
          <hidden state="on"/>
        </kvm>
      </features>

      <!-- Security -->
      <seclabel type="dynamic" model="selinux" relabel="yes"/>
      <seclabel type="dynamic" model="apparmor" relabel="yes"/>

      <!-- Power management -->
      <pm>
        <suspend-to-mem enabled="no"/>
        <suspend-to-disk enabled="no"/>
      </pm>
    </xsl:copy>
  </xsl:template>

  <!-- Optimize disk configuration -->
  <xsl:template match="/domain/devices/disk[@device='disk']">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()"/>
      <driver name="qemu" type="qcow2" cache="none" io="native" discard="unmap"/>
    </xsl:copy>
  </xsl:template>

  <!-- Optimize network configuration -->
  <xsl:template match="/domain/devices/interface[@type='network']">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()"/>
      <model type="virtio"/>
      <driver name="vhost" queues="4"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
