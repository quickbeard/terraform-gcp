variable "project_id" {
  type = string
}

variable "db_instance_name" {
  type = string
}

variable "db_tier" {
  type = string
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "db_ip_range" {
  type = string
}

variable "db_port" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_url" {
  type = string
}

variable "private_network" {
  type = string
}

variable "database_version" {
  description = "This is the db version we want to have"
  type        = string
  default     = "POSTGRES_14"
}

variable "zone" {
  description = "This is where our db instance should be deployed"
  type        = string
  default     = "us-central1-c"
}

variable "db_user_name" {
  description = "This is the username that we use for our database"
  type        = string
  default     = "postgres"
}

variable "max_locks_per_transaction" {
  description = "This parameter controls the average number of object locks allocated for each transaction"
  type        = number
  default     = 647
}

variable "retained_backups" {
  description = "Number of backups that we want to keep"
  type        = number
  default     = 7
}

# Max: 7 days
variable "transaction_log_retention_days" {
  description = "Number of transaction logs day that we want to keep"
  type        = number
  default     = 7
}

variable "point_in_time_recovery_enabled" {
  description = "This param will allow us to recover db in case of crash"
  type        = bool
  default     = false
}
