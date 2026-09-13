{{/* annotations */}}

{{- define "gitea.deployment.annotations" -}}
{{- with .Values.deployment.annotations }}
{{- toYaml . -}}
{{- end }}
{{- end }}

{{/* initContainers */}}

{{- define "gitea.deployment.initContainers" -}}
{{- $links := list "initAppIni" "initConfigureGPG" "initConfigureGitea" "initDirectories" }}
{{- range $index, $entry := .Values.deployment.initContainers }}
{{- if and (hasKey $entry "container") (hasKey $entry "link") }}
{{- fail (printf "deployment.initContainers[%d]: `container` and `link` are mutually exclusive" $index) }}
{{- else if hasKey $entry "container" }}
{{- list $entry.container | toYaml | nindent 0 }}
{{- else if hasKey $entry "link" }}
{{- if not (has $entry.link $links) }}
{{- fail (printf "deployment.initContainers[%d]: unknown link `%s`, expected one of: %s" $index $entry.link (join ", " $links)) }}
{{- end }}
{{- with include (printf "gitea.initContainer.%s" $entry.link) $ }}
{{- nindent 0 . }}
{{- end }}
{{- else }}
{{- fail (printf "deployment.initContainers[%d]: either `container` or `link` must be set" $index) }}
{{- end }}
{{- end }}
{{- end }}

{{/* labels */}}

{{- define "gitea.deployment.labels" -}}
{{ include "gitea.labels" . }}
{{- with .Values.deployment.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}