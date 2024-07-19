{{- define "template.labels" }}
labels:
  app: {{ .name | default .name }}
  version: {{ .version | default "v1" }}
  {{- with .labels }}
  {{- range $key, $value := . }}
  {{ $key }}: {{ $value }}
  {{- end }}
  {{- end }}
{{- end }}

{{- define "template.annotations" }}
{{- with .annotations }}
annotations:
  {{- range $key, $value := . }}
  {{ $key }}: {{ $value | quote }}
  {{- end }}
{{- end }}
{{- end }}

{{- define "template.environment" }}
env:
  {{- range $key, $value := .configmap.env }}
  - name: {{ $key }}
    value: {{ $value | quote }}
  {{- end }}
  {{- range .envFromSecret }}
  - name: {{ .name }}
    valueFrom:
      secretKeyRef:
        name: {{ .secretKeyRef.name }}
        key: {{ .secretKeyRef.key }}
  {{- end }}
{{- end }}

{{- define "template.ports" }}
ports:
  {{- range .ports }}
  - containerPort: {{ .containerPort }}
    protocol: {{ .protocol | default "TCP" }}
  {{- end }}
{{- end }}

{{- define "template.securityContext" }}
securityContext:
  {{- if .runAsUser }}
  runAsUser: {{ .runAsUser }}
  {{- end }}
  {{- if .runAsGroup }}
  runAsGroup: {{ .runAsGroup }}
  {{- end }}
  {{- if .fsGroup }}
  fsGroup: {{ .fsGroup }}
  {{- end }}
  {{- if .readOnlyRootFilesystem }}
  readOnlyRootFilesystem: {{ .readOnlyRootFilesystem }}
  {{- end }}
{{- end }}

{{- define "template.startupProbe" }}
{{- if .probe.startup }}
startupProbe:
  httpGet:
    path: {{ .probe.startup.path }}
    port: {{ .probe.startup.port }}
  initialDelaySeconds: {{ .probe.startup.initialDelaySeconds }}
  periodSeconds: {{ .probe.startup.periodSeconds }}
{{- end }}
{{- end }}

{{- define "template.livenessProbe" }}
{{- if .probe.liveness }}
livenessProbe:
  httpGet:
    path: {{ .probe.liveness.path }}
    port: {{ $.containerPort }}
  initialDelaySeconds: {{ .probe.liveness.initialDelaySeconds }}
  periodSeconds: {{ .probe.liveness.periodSeconds }}
{{- end }}
{{- end }}

{{- define "template.readinessProbe" }}
{{- if .probe.readiness }}
readinessProbe:
  httpGet:
    path: {{ .probe.readiness.path }}
    port: {{ $.containerPort }}
  initialDelaySeconds: {{ .probe.readiness.initialDelaySeconds }}
  periodSeconds: {{ .probe.readiness.periodSeconds }}
{{- end }}
{{- end }}

{{- define "template.volumeMounts" }}
volumeMounts:
  {{- range .volumeMounts }}
  - name: {{ .name }}
    mountPath: {{ .mountPath }}
  {{- end }}
{{- end }}

{{- define "template.volumes" }}
volumes:
  {{- range .volumes }}
  {{- if .hostPath }}
  - name: {{ .name }}
    hostPath:
      path: {{ .hostPath.path }}
  {{- end }}
  {{- end }}
{{- end }}

{{- define "toYamlWithCustomLabels" -}}
{{- $root := . -}}
{{- range $key, $value := . -}}
{{ $key | replace "/" "_" | quote }}: {{ $value | quote }}
{{- end -}}
{{- end -}}
