{{/* initDirectories */}}

{{- define "gitea.initContainer.initDirectories" -}}
{{- $config := .Values.deployment.initDirectories -}}
- name: init-directories
  image: "{{ include "gitea.image.name" (list . $config.image) }}"
  imagePullPolicy: {{ $config.image.pullPolicy }}
  command:
    - "{{ .Values.initContainersScriptsVolumeMountPath }}/init_directory_structure.sh"
  env:
    - name: GITEA_APP_INI
      value: /data/gitea/conf/app.ini
    - name: GITEA_CUSTOM
      value: /data/gitea
    - name: GITEA_WORK_DIR
      value: /data
    - name: GITEA_TEMP
      value: /tmp/gitea
    {{- if .Values.deployment.gitea.env }}
    {{- toYaml .Values.deployment.gitea.env | nindent 4 }}
    {{- end }}
    {{- if .Values.secrets.gpg.enabled }}
    - name: GNUPGHOME
      valueFrom:
        secretKeyRef:
          name: {{ include "gitea.secret.gpg.name" . }}
          key: {{ include "gitea.secret.gpg.gpgHomeKey" . }}
    {{- end }}
    {{- with $config.env }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with $config.envFrom }}
  envFrom:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: init
      mountPath: {{ .Values.initContainersScriptsVolumeMountPath }}
    - name: temp
      mountPath: /tmp
    - name: data
      mountPath: /data
      {{- if .Values.persistence.subPath }}
      subPath: {{ .Values.persistence.subPath }}
      {{- end }}
    {{- include "gitea.init-additional-mounts" . | nindent 4 }}
    {{- with $config.volumeMounts }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with (include "gitea.containerSecurityContext" (list . (deepCopy ($config.securityContext | default .Values.deployment.gitea.securityContext))) | trim) }}
  securityContext:
    {{- . | nindent 4 }}
  {{- end }}
  resources:
    {{- toYaml ($config.resources | default .Values.initContainers.resources) | nindent 4 }}
{{- end }}

{{/* initAppIni */}}

{{- define "gitea.initContainer.initAppIni" -}}
{{- $config := .Values.deployment.initAppIni -}}
- name: init-app-ini
  image: "{{ include "gitea.image.name" (list . $config.image) }}"
  imagePullPolicy: {{ $config.image.pullPolicy }}
  {{- if .Values.gitea.extraEnvSourceFile }}
  command:
  - "/bin/bash"
  - "-c"
  args:
  - "test -f {{ .Values.gitea.extraEnvSourceFile }} && source {{ .Values.gitea.extraEnvSourceFile }} || { echo 'ERROR: Failed to source {{ .Values.gitea.extraEnvSourceFile }}'; exit 1; } && {{ .Values.initContainersScriptsVolumeMountPath }}/config_environment.sh"
  {{- else }}
  command:
  - "{{ .Values.initContainersScriptsVolumeMountPath }}/config_environment.sh"
  {{- end }}
  env:
    - name: GITEA_APP_INI
      value: /data/gitea/conf/app.ini
    - name: GITEA_CUSTOM
      value: /data/gitea
    - name: GITEA_WORK_DIR
      value: /data
    - name: GITEA_TEMP
      value: /tmp/gitea
    - name: TMP_EXISTING_ENVS_FILE
      value: /tmp/existing-envs
    - name: ENV_TO_INI_MOUNT_POINT
      value: /env-to-ini-mounts
    {{- if .Values.deployment.gitea.env }}
    {{- toYaml .Values.deployment.gitea.env | nindent 4 }}
    {{- end }}
    {{- if .Values.gitea.additionalConfigFromEnvs }}
    {{- tpl (toYaml .Values.gitea.additionalConfigFromEnvs) $ | nindent 4 }}
    {{- end }}
    {{- with $config.env }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with $config.envFrom }}
  envFrom:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: config
      mountPath: {{ .Values.initContainersScriptsVolumeMountPath }}
    - name: temp
      mountPath: /tmp
    - name: data
      mountPath: /data
      {{- if .Values.persistence.subPath }}
      subPath: {{ .Values.persistence.subPath }}
      {{- end }}
    - name: inline-config-sources
      mountPath: /env-to-ini-mounts/inlines/
    {{- range $idx, $value := .Values.gitea.additionalConfigSources }}
    - name: additional-config-sources-{{ $idx }}
      mountPath: "/env-to-ini-mounts/additionals/{{ $idx }}/"
    {{- end }}
    {{- include "gitea.init-additional-mounts" . | nindent 4 }}
    {{- with $config.volumeMounts }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with (include "gitea.containerSecurityContext" (list . (deepCopy ($config.securityContext | default .Values.deployment.gitea.securityContext))) | trim) }}
  securityContext:
    {{- . | nindent 4 }}
  {{- end }}
  resources:
    {{- toYaml ($config.resources | default .Values.initContainers.resources) | nindent 4 }}
{{- end }}

{{/* initConfigureGPG */}}

{{- define "gitea.initContainer.initConfigureGPG" -}}
{{- $config := .Values.deployment.initConfigureGPG -}}
{{- if .Values.secrets.gpg.enabled -}}
- name: configure-gpg
  image: "{{ include "gitea.image.name" (list . $config.image) }}"
  {{- if .Values.gitea.extraEnvSourceFile }}
  command:
  - "/bin/bash"
  - "-c"
  args:
  - "test -f {{ .Values.gitea.extraEnvSourceFile }} && source {{ .Values.gitea.extraEnvSourceFile }} || { echo 'ERROR: Failed to source {{ .Values.gitea.extraEnvSourceFile }}'; exit 1; } && {{ .Values.initContainersScriptsVolumeMountPath }}/configure_gpg_environment.sh"
  {{- else }}
  command:
  - "{{ .Values.initContainersScriptsVolumeMountPath }}/configure_gpg_environment.sh"
  {{- end }}
  imagePullPolicy: {{ $config.image.pullPolicy }}
  {{- with (include "gitea.commandInitContainerSecurityContext" (list . (deepCopy ($config.securityContext | default .Values.deployment.gitea.securityContext))) | trim) }}
  securityContext:
    {{- . | nindent 4 }}
  {{- end }}
  env:
    - name: GNUPGHOME
      valueFrom:
        secretKeyRef:
          name: {{ include "gitea.secret.gpg.name" . }}
          key: {{ include "gitea.secret.gpg.gpgHomeKey" . }}
    - name: TMP_RAW_GPG_KEY
      value: /raw/private.asc
    {{- with $config.env }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with $config.envFrom }}
  envFrom:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: init
      mountPath: {{ .Values.initContainersScriptsVolumeMountPath }}
    - name: data
      mountPath: /data
      {{- if .Values.persistence.subPath }}
      subPath: {{ .Values.persistence.subPath }}
      {{- end }}
    - name: gpg-private-key
      mountPath: /raw
      readOnly: true
    {{- if .Values.extraVolumeMounts }}
    {{- toYaml .Values.extraVolumeMounts | nindent 4 }}
    {{- end }}
    {{- with $config.volumeMounts }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  resources:
    {{- toYaml ($config.resources | default .Values.initContainers.resources) | nindent 4 }}
{{- end }}
{{- end }}

{{/* initConfigureGitea */}}

{{- define "gitea.initContainer.initConfigureGitea" -}}
{{- $config := .Values.deployment.initConfigureGitea -}}
- name: configure-gitea
  image: "{{ include "gitea.image.name" (list . $config.image) }}"
  {{- if .Values.gitea.extraEnvSourceFile }}
  command:
  - "/bin/bash"
  - "-c"
  args:
  - "test -f {{ .Values.gitea.extraEnvSourceFile }} && source {{ .Values.gitea.extraEnvSourceFile }} || { echo 'ERROR: Failed to source {{ .Values.gitea.extraEnvSourceFile }}'; exit 1; } && {{ .Values.initContainersScriptsVolumeMountPath }}/configure_gitea.sh"
  {{- else }}
  command:
  - "{{ .Values.initContainersScriptsVolumeMountPath }}/configure_gitea.sh"
  {{- end }}
  imagePullPolicy: {{ $config.image.pullPolicy }}
  {{- with (include "gitea.commandInitContainerSecurityContext" (list . (deepCopy ($config.securityContext | default .Values.deployment.gitea.securityContext))) | trim) }}
  securityContext:
    {{- . | nindent 4 }}
  {{- end }}
  env:
    - name: GITEA_APP_INI
      value: /data/gitea/conf/app.ini
    - name: GITEA_CUSTOM
      value: /data/gitea
    - name: GITEA_WORK_DIR
      value: /data
    - name: GITEA_TEMP
      value: /tmp/gitea
    {{- if $config.image.rootless }}
    - name: HOME
      value: /data/gitea/git
    {{- end }}
    {{- if .Values.gitea.ldap }}
    {{- range $idx, $value := .Values.gitea.ldap }}
    {{- if $value.existingSecret }}
    - name: GITEA_LDAP_BIND_DN_{{ $idx }}
      valueFrom:
        secretKeyRef:
          key:  bindDn
          name: {{ $value.existingSecret }}
    - name: GITEA_LDAP_PASSWORD_{{ $idx }}
      valueFrom:
        secretKeyRef:
          key:  bindPassword
          name: {{ $value.existingSecret }}
    {{- else }}
    - name: GITEA_LDAP_BIND_DN_{{ $idx }}
      value: {{ $value.bindDn | quote }}
    - name: GITEA_LDAP_PASSWORD_{{ $idx }}
      value: {{ $value.bindPassword | quote }}
    {{- end }}
    {{- end }}
    {{- end }}
    {{- if .Values.gitea.oauth }}
    {{- range $idx, $value := .Values.gitea.oauth }}
    {{- if $value.existingSecret }}
    - name: GITEA_OAUTH_KEY_{{ $idx }}
      valueFrom:
        secretKeyRef:
          key:  key
          name: {{ $value.existingSecret }}
    - name: GITEA_OAUTH_SECRET_{{ $idx }}
      valueFrom:
        secretKeyRef:
          key:  secret
          name: {{ $value.existingSecret }}
    {{- end }}
    {{- end }}
    {{- end }}
    {{- if .Values.secrets.admin.enabled }}
    - name: GITEA_ADMIN_USERNAME
      valueFrom:
        secretKeyRef:
          key: {{ include "gitea.secret.admin.usernameKey" . }}
          name: {{ include "gitea.secret.admin.name" . }}
    - name: GITEA_ADMIN_PASSWORD
      valueFrom:
        secretKeyRef:
          key: {{ include "gitea.secret.admin.passwordKey" . }}
          name: {{ include "gitea.secret.admin.name" . }}
    - name: GITEA_ADMIN_EMAIL
      valueFrom:
        secretKeyRef:
          key: {{ include "gitea.secret.admin.emailKey" . }}
          name: {{ include "gitea.secret.admin.name" . }}
    - name: GITEA_ADMIN_PASSWORD_MODE
      value: {{ include "gitea.secret.admin.passwordMode" $ }}
    {{- end }}
    {{- if .Values.deployment.gitea.env }}
    {{- toYaml .Values.deployment.gitea.env | nindent 4 }}
    {{- end }}
    {{- with $config.env }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with $config.envFrom }}
  envFrom:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: init
      mountPath: {{ .Values.initContainersScriptsVolumeMountPath }}
    - name: temp
      mountPath: /tmp
    - name: data
      mountPath: /data
      {{- if .Values.persistence.subPath }}
      subPath: {{ .Values.persistence.subPath }}
      {{- end }}
    {{- include "gitea.init-additional-mounts" . | nindent 4 }}
    {{- with $config.volumeMounts }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  resources:
    {{- toYaml ($config.resources | default .Values.initContainers.resources) | nindent 4 }}
{{- end }}
