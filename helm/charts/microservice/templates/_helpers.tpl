{{/*
Genera el nombre completo del release.
.Release.Name es el nombre que ArgoCD le da al deployment (ej: "frontend").
Si se define nameOverride en values, usa ese. Si no, usa el nombre del release.
*/}}
{{- define "microservice.fullname" -}}
{{- if .Values.nameOverride }}
{{- .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Labels estándar que van en TODOS los recursos.
Kubernetes recomienda estas labels para identificación y selección.
app.kubernetes.io/* son las labels "well-known" del ecosistema K8s.
*/}}
{{- define "microservice.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/name: {{ include "microservice.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels — subconjunto usado en spec.selector.matchLabels y Service.selector.
IMPORTANTE: Estas labels NO deben cambiar después del primer deploy.
Si cambian, Kubernetes rechaza el update del Deployment.
*/}}
{{- define "microservice.selectorLabels" -}}
app.kubernetes.io/name: {{ include "microservice.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Nombre del ServiceAccount a usar por el Pod.
- Si create=true: usa serviceAccount.name o fullname por defecto.
- Si create=false: usa serviceAccount.name o "default".
*/}}
{{- define "microservice.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "microservice.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}