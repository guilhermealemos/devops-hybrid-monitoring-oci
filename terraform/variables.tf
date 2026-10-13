variable "tenancy_ocid" {
  type        = string
  description = "OCID do Tenancy da Oracle Cloud"
}

variable "user_ocid" {
  type        = string
  description = "OCID do Usuário da Oracle Cloud"
}

variable "fingerprint" {
  type        = string
  description = "Fingerprint da chave de API cadastrada na OCI"
}

variable "private_key_path" {
  type        = string
  description = "Caminho local para o arquivo .pem da chave privada"
  default     = "~/.oci/oci_api_key.pem"
}

variable "region" {
  type        = string
  description = "Região da OCI (ex: sa-saopaulo-1 ou us-ashburn-1)"
}

variable "compartment_ocid" {
  type        = string
  description = "OCID do Compartment onde os recursos serão criados (pode ser o mesmo do Tenancy)"
}

variable "ssh_public_key" {
  type        = string
  description = "Chave SSH pública para acessar a VM Compute criada"
}
