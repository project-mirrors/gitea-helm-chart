{{/* vim: set filetype=mustache: */}}

{{/* annotations */}}

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

{{/* labels */}}

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
{{ default (printf "%s-gpg-key" (include "gitea.fullname" .)) .Values.signing.existingSecret }}
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
