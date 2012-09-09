
ENV["TZ"] = "US/Pacific"

Sequel.database_timezone = :utc
Sequel.application_timezone = :local

