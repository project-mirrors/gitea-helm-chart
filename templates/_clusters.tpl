{{/* vim: set filetype=mustache: */}}

{{/* annotations */}}

{{- define "gitea.cluster.cloudnativePG.annotations" -}}
{{- with .Values.cloudnativePG.annotations }}
{{- toYaml . -}}
{{- end }}
{{- end }}

{{/* labels */}}

{{- define "gitea.cluster.cloudnativePG.labels" -}}
{{ include "gitea.labels" . }}
{{- with .Values.cloudnativePG.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/* names */}}

{{- define "gitea.cluster.cloudnativePG.name" -}}
{{ include "gitea.fullname" . }}-postgresql
{{- end }}
