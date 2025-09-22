{{/* vim: set filetype=mustache: */}}

{{/* annotations */}}

{{- define "gitea.networkPolicy.annotations" -}}
{{ include "gitea.annotations" . }}
{{- if .Values.networkPolicy.annotations }}
{{ toYaml .Values.networkPolicy.annotations }}
{{- end }}
{{- end }}

{{/* labels */}}

{{- define "gitea.networkPolicy.labels" -}}
{{ include "gitea.labels" . }}
{{- if .Values.networkPolicy.labels }}
{{ toYaml .Values.networkPolicy.labels }}
{{- end }}
{{- end }}
