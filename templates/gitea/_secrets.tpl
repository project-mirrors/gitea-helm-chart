{{/* vim: set filetype=mustache: */}}

{{/* annotations */}}

{{- define "gitea.secret.admin.annotations" -}}
{{- with .Values.secrets.admin.new.annotations }}
{{- toYaml . -}}
{{- end }}
{{- end }}

{{- define "gitea.secret.config.annotations" -}}
{{- with .Values.secrets.config.new.annotations }}
{{- toYaml . -}}
{{- end }}
{{- end }}

{{- define "gitea.secret.gpg.annotations" -}}
{{- with .Values.secrets.gpg.new.annotations }}
{{- toYaml . -}}
{{- end }}
{{- end }}

{{- define "gitea.secret.init.annotations" -}}
{{- with .Values.secrets.init.new.annotations }}
{{- toYaml . -}}
{{- end }}
{{- end }}

{{- define "gitea.secret.inlineConfig.annotations" -}}
{{- with .Values.secrets.inlineConfig.new.annotations }}
{{- toYaml . -}}
{{- end }}
{{- end }}

{{- define "gitea.secret.metrics.annotations" -}}
{{- with .Values.secrets.metrics.new.annotations }}
{{- toYaml . -}}
{{- end }}
{{- end }}

{{/* checksums */}}

{{/*
SHA sum of a Secret, used to trigger a rollout whenever its content changes.
User-provided Secrets are looked up in the cluster, chart-managed ones are rendered, because the
cluster still holds their pre-upgrade state.
Arguments: (list $root $key)
*/}}
{{- define "gitea.secret.checksum" -}}
{{- $root := index . 0 -}}
{{- $key := index . 1 -}}
{{- if (index $root.Values.secrets $key).existingSecret.enabled -}}
{{- $namespace := $root.Values.namespace | default $root.Release.Namespace -}}
{{- $name := include (printf "gitea.secret.%s.name" $key) $root -}}
{{- lookup "v1" "Secret" $namespace $name | toYaml | sha256sum -}}
{{- else -}}
{{- include (printf "%s/gitea/secret_%s.yaml" $root.Template.BasePath $key) $root | sha256sum -}}
{{- end -}}
{{- end }}


{{/* labels */}}

{{- define "gitea.secret.admin.labels" -}}
{{ include "gitea.labels" . }}
{{- with .Values.secrets.admin.new.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{- define "gitea.secret.config.labels" -}}
{{ include "gitea.labels" . }}
{{- with .Values.secrets.config.new.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{- define "gitea.secret.gpg.labels" -}}
{{ include "gitea.labels" . }}
{{- with .Values.secrets.gpg.new.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{- define "gitea.secret.init.labels" -}}
{{ include "gitea.labels" . }}
{{- with .Values.secrets.init.new.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{- define "gitea.secret.inlineConfig.labels" -}}
{{ include "gitea.labels" . }}
{{- with .Values.secrets.inlineConfig.new.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{- define "gitea.secret.metrics.labels" -}}
{{ include "gitea.labels" . }}
{{- with .Values.secrets.metrics.new.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/* names */}}

{{- define "gitea.secret.admin.name" -}}
{{- if .Values.secrets.admin.existingSecret.enabled -}}
{{ required "`secrets.admin.existingSecret.secretName` must be set when `secrets.admin.existingSecret.enabled` is enabled" .Values.secrets.admin.existingSecret.secretName }}
{{- else -}}
{{ include "gitea.fullname" . }}-admin
{{- end -}}
{{- end }}

{{- define "gitea.secret.config.name" -}}
{{- if .Values.secrets.config.existingSecret.enabled -}}
{{ required "`secrets.config.existingSecret.secretName` must be set when `secrets.config.existingSecret.enabled` is enabled" .Values.secrets.config.existingSecret.secretName }}
{{- else -}}
{{ include "gitea.fullname" . }}-config
{{- end -}}
{{- end }}

{{- define "gitea.secret.gpg.name" -}}
{{- if .Values.secrets.gpg.existingSecret.enabled -}}
{{ required "`secrets.gpg.existingSecret.secretName` must be set when `secrets.gpg.existingSecret.enabled` is enabled" .Values.secrets.gpg.existingSecret.secretName }}
{{- else -}}
{{ include "gitea.fullname" . }}-gpg-key
{{- end -}}
{{- end }}

{{- define "gitea.secret.init.name" -}}
{{- if .Values.secrets.init.existingSecret.enabled -}}
{{ required "`secrets.init.existingSecret.secretName` must be set when `secrets.init.existingSecret.enabled` is enabled" .Values.secrets.init.existingSecret.secretName }}
{{- else -}}
{{ include "gitea.fullname" . }}-init
{{- end -}}
{{- end }}

{{- define "gitea.secret.inlineConfig.name" -}}
{{- if .Values.secrets.inlineConfig.existingSecret.enabled -}}
{{ required "`secrets.inlineConfig.existingSecret.secretName` must be set when `secrets.inlineConfig.existingSecret.enabled` is enabled" .Values.secrets.inlineConfig.existingSecret.secretName }}
{{- else -}}
{{ include "gitea.fullname" . }}-inline-config
{{- end -}}
{{- end }}

{{- define "gitea.secret.metrics.name" -}}
{{- if .Values.secrets.metrics.existingSecret.enabled -}}
{{ required "`secrets.metrics.existingSecret.secretName` must be set when `secrets.metrics.existingSecret.enabled` is enabled" .Values.secrets.metrics.existingSecret.secretName }}
{{- else -}}
{{ include "gitea.fullname" . }}-metrics
{{- end -}}
{{- end }}

{{/* keys */}}

{{- define "gitea.secret.admin.emailKey" -}}
{{- if .Values.secrets.admin.existingSecret.enabled -}}
{{ .Values.secrets.admin.existingSecret.emailKey }}
{{- else -}}
email
{{- end -}}
{{- end }}

{{- define "gitea.secret.admin.passwordKey" -}}
{{- if .Values.secrets.admin.existingSecret.enabled -}}
{{ .Values.secrets.admin.existingSecret.passwordKey }}
{{- else -}}
password
{{- end -}}
{{- end }}

{{- define "gitea.secret.admin.usernameKey" -}}
{{- if .Values.secrets.admin.existingSecret.enabled -}}
{{ .Values.secrets.admin.existingSecret.usernameKey }}
{{- else -}}
username
{{- end -}}
{{- end }}

{{- define "gitea.secret.gpg.gpgHomeKey" -}}
{{- if .Values.secrets.gpg.existingSecret.enabled -}}
{{ .Values.secrets.gpg.existingSecret.gpgHomeKey }}
{{- else -}}
gpgHome
{{- end -}}
{{- end }}

{{- define "gitea.secret.gpg.privateKeyKey" -}}
{{- if .Values.secrets.gpg.existingSecret.enabled -}}
{{ .Values.secrets.gpg.existingSecret.privateKeyKey }}
{{- else -}}
privateKey
{{- end -}}
{{- end }}

{{/* misc */}}

{{- define "gitea.secret.admin.passwordMode" -}}
{{- if has .Values.secrets.admin.passwordMode (tuple "keepUpdated" "initialOnlyNoReset" "initialOnlyRequireReset") -}}
{{ .Values.secrets.admin.passwordMode }}
{{- else -}}
{{ printf "`secrets.admin.passwordMode` must be set to one of 'keepUpdated', 'initialOnlyNoReset', or 'initialOnlyRequireReset'. Received: '%s'" .Values.secrets.admin.passwordMode | fail }}
{{- end -}}
{{- end }}
