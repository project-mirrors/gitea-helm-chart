---

{{/* labels */}}

{{- define "gitea.pod.labels" -}}
{{- include "gitea.labels" . }}
{{- if .Values.deployment.labels }}
{{ toYaml .Values.deployment.labels }}
{{- end }}
{{- end }}

{{- define "gitea.pod.selectorLabels" -}}
{{- include "gitea.selectorLabels" . }}
{{- if .Values.deployment.labels }}
{{ toYaml .Values.deployment.labels }}
{{- end }}
{{- end }}