{{/* vim: set filetype=mustache: */}}

{{/* annotations */}}

{{- define "gitea.ingress.annotations" -}}
{{- with .Values.ingress.annotations }}
{{- toYaml . -}}
{{- end }}
{{- end }}

{{/* labels */}}

{{- define "gitea.ingress.labels" -}}
{{ include "gitea.labels" . }}
{{- with .Values.ingress.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/* name */}}

{{- define "gitea.ingress.name" -}}
{{ include "gitea.fullname" . }}
{{- end }}