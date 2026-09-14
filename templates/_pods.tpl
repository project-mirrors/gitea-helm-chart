---

{{/* annotations */}}

{{- define "gitea.pod.annotations" -}}

{{/* secret - admin */}}
{{- if and .Values.secrets.admin.enabled .Values.secrets.admin.addSHASumAnnotation }}
checksum/admin: {{ include "gitea.secret.checksum" (list . "admin") }}
{{- end }}

{{/* secret - config */}}
{{- if and .Values.secrets.config.enabled .Values.secrets.config.addSHASumAnnotation }}
checksum/config: {{ include "gitea.secret.checksum" (list . "config") }}
{{- end }}

{{/* secret - gpg */}}
{{- if and .Values.secrets.gpg.enabled .Values.secrets.gpg.addSHASumAnnotation }}
checksum/gpg: {{ include "gitea.secret.checksum" (list . "gpg") }}
{{- end }}

{{/* secret - init */}}
{{- if and .Values.secrets.init.enabled .Values.secrets.init.addSHASumAnnotation }}
checksum/init: {{ include "gitea.secret.checksum" (list . "init") }}
{{- end }}

{{/* secret - inlineConfig */}}
{{- if and .Values.secrets.inlineConfig.enabled .Values.secrets.inlineConfig.addSHASumAnnotation }}
checksum/inlineConfig: {{ include "gitea.secret.checksum" (list . "inlineConfig") }}
{{- end }}

{{/* secret - metrics */}}
{{- if and .Values.secrets.metrics.enabled .Values.secrets.metrics.addSHASumAnnotation }}
checksum/metrics: {{ include "gitea.secret.checksum" (list . "metrics") }}
{{- end }}

{{/* secret - ldap */}}
{{- range $idx, $value := .Values.gitea.ldap }}
checksum/ldap_{{ $idx }}: {{ include "gitea.ldap_settings" (list $idx $value) | sha256sum }}
{{- end }}

{{/* secret - oauth */}}
{{- range $idx, $value := .Values.gitea.oauth }}
checksum/oauth_{{ $idx }}: {{ include "gitea.oauth_settings" (list $idx $value) | sha256sum }}
{{- end }}

{{/* custom pod annotations */}}
{{- with .Values.gitea.podAnnotations }}
{{ toYaml . }}
{{- end }}

{{- end }}