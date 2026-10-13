# 1. Virtual Cloud Network (VCN)
resource "oci_core_vcn" "monitoring_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "vcn-monitoring-prod"
  dns_label      = "monvcn"
}

# 2. Internet Gateway
resource "oci_core_internet_gateway" "monitoring_igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.monitoring_vcn.id
  display_name   = "igw-monitoring"
  enabled        = true
}

# 3. Tabela de Rotas
resource "oci_core_route_table" "monitoring_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.monitoring_vcn.id
  display_name   = "rt-monitoring-public"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.monitoring_igw.id
  }
}

# 4. Security List (Firewall)
resource "oci_core_security_list" "monitoring_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.monitoring_vcn.id
  display_name   = "sl-monitoring-public"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }

  # SSH (Porta 22)
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    stateless   = false
    description = "SSH Access"
    tcp_options {
      min = 22
      max = 22
    }
  }

  # HTTP (Porta 80)
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    stateless   = false
    description = "Web HTTP"
    tcp_options {
      min = 80
      max = 80
    }
  }

  # HTTPS (Porta 443)
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    stateless   = false
    description = "Web HTTPS"
    tcp_options {
      min = 443
      max = 443
    }
  }

  # Grafana (Porta 3000)
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    stateless   = false
    description = "Grafana Web"
    tcp_options {
      min = 3000
      max = 3000
    }
  }

  # Zabbix Trapper / Agentes (Porta 10051)
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    stateless   = false
    description = "Zabbix Server Trapper"
    tcp_options {
      min = 10051
      max = 10051
    }
  }

  # ICMP Ping
  ingress_security_rules {
    protocol    = "1"
    source      = "0.0.0.0/0"
    stateless   = false
    description = "ICMP Ping"
    icmp_options {
      type = 8
      code = 0
    }
  }
}

# 5. Subnet Pública
resource "oci_core_subnet" "monitoring_subnet" {
  cidr_block        = "10.0.1.0/24"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.monitoring_vcn.id
  display_name      = "subnet-monitoring-public"
  dns_label         = "submon"
  route_table_id    = oci_core_route_table.monitoring_rt.id
  security_list_ids = [oci_core_security_list.monitoring_sl.id]
}
