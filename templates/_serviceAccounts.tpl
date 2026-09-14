{{/* vim: set filetype=mustache: */}}

{{/* annotations */}}

{{- define "gitea.serviceAccount.annotations" -}}
{{- with .Values.serviceAccount.new.annotations }}
{{- toYaml . -}}
{{- end }}
{{- end }}

{{/* enabled */}}

{{- define "gitea.serviceAccount.enabled" -}}
{{- if and .Values.serviceAccount.enabled (not .Values.serviceAccount.existingServiceAccount.enabled) -}}
true
{{- else -}}
false
{{- end }}
{{- end }}

{{/* labels */}}

{{- define "gitea.serviceAccount.labels" -}}
{{ include "gitea.labels" . }}
{{- with .Values.serviceAccount.new.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/* name */}}

{{- define "gitea.serviceAccount.name" -}}
{{- if .Values.serviceAccount.existingServiceAccount.enabled -}}
{{ required "serviceAccount.existingServiceAccount.existingServiceAccountName is required when serviceAccount.existingServiceAccount.enabled is true" .Values.serviceAccount.existingServiceAccount.existingServiceAccountName }}
{{- else -}}
{{ include "gitea.fullname" . }}
{{- end }}
{{- end }}
