{{/* vim: set filetype=mustache: */}}

{{/* names */}}

{{- define "gitea.secret.config.name" -}}
{{ include "gitea.fullname" . }}-config
{{- end }}

{{- define "gitea.secret.gpg.name" -}}
{{ default (printf "%s-gpg-key" (include "gitea.fullname" .)) .Values.signing.existingSecret }}
{{- end }}

{{- define "gitea.secret.init.name" -}}
{{ include "gitea.fullname" . }}-init
{{- end }}

{{- define "gitea.secret.inlineConfig.name" -}}
{{ include "gitea.fullname" . }}-inline-config
{{- end }}

{{- define "gitea.secret.metrics.name" -}}
{{ include "gitea.fullname" . }}-metrics
{{- end }}
