{{/*
Expand the name of the chart.
*/}}
{{- define "devsecops-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "devsecops-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart label.
*/}}
{{- define "devsecops-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "devsecops-app.labels" -}}
helm.sh/chart: {{ include "devsecops-app.chart" . }}
{{ include "devsecops-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "devsecops-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "devsecops-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Service account name.
*/}}
{{- define "devsecops-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "devsecops-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
Iteration 1: trivial update
Iteration 2: trivial update
Iteration 3: trivial update
Iteration 4: trivial update
Iteration 5: trivial update
Iteration 6: trivial update
Iteration 7: trivial update
Iteration 8: trivial update
Iteration 9: trivial update
Iteration 10: trivial update
Iteration 11: trivial update
Iteration 12: trivial update
Iteration 13: trivial update
Iteration 14: trivial update
Iteration 15: trivial update
Iteration 16: trivial update
Iteration 17: trivial update
Iteration 18: trivial update
Iteration 19: trivial update
Iteration 20: trivial update
Iteration 21: trivial update
Iteration 22: trivial update
Iteration 23: trivial update
Iteration 24: trivial update
Iteration 25: trivial update
Iteration 26: trivial update
Iteration 27: trivial update
Iteration 28: trivial update
Iteration 29: trivial update
Iteration 30: trivial update
Iteration 31: trivial update
Iteration 32: trivial update
Iteration 33: trivial update
Iteration 34: trivial update
Iteration 35: trivial update
Iteration 36: trivial update
