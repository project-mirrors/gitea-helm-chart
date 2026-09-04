{{/* annotations */}}

{{- define "gitea.deployment.annotations" -}}
{{- with .Values.deployment.annotations }}
{{- toYaml . -}}
{{- end }}
{{- end }}

{{/* labels */}}

{{- define "gitea.deployment.labels" -}}
{{ include "gitea.labels" . }}
{{- with .Values.deployment.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}