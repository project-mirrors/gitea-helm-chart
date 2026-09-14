{{/* vim: set filetype=mustache: */}}

{{/* annotations */}}

{{- define "gitea.persistentVolumeClaim.annotations" -}}
{{- with .Values.persistence.new.annotations }}
{{- toYaml . -}}
{{- end }}
{{- end }}

{{/* enabled */}}

{{- define "gitea.persistentVolumeClaim.enabled" -}}
{{- if and .Values.persistence.enabled (not .Values.persistence.existingPersistentVolumeClaim.enabled) -}}
true
{{- else -}}
false
{{- end }}
{{- end }}

{{/* labels */}}

{{- define "gitea.persistentVolumeClaim.labels" -}}
{{ include "gitea.labels" . }}
{{- with .Values.persistence.new.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/* name */}}

{{- define "gitea.persistentVolumeClaim.name" -}}
{{- if .Values.persistence.existingPersistentVolumeClaim.enabled -}}
{{ required "persistence.existingPersistentVolumeClaim.persistentVolumeClaimName is required when persistence.existingPersistentVolumeClaim.enabled is true" .Values.persistence.existingPersistentVolumeClaim.persistentVolumeClaimName }}
{{- else -}}
{{ include "gitea.fullname" . }}
{{- end }}
{{- end }}