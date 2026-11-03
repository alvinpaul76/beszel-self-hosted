{{- with secret "<project-id>" "<env-slug>" "/" -}}
{{- range . -}}
{{- if or (eq .Key "BESZEL_AGENT_KEY") (eq .Key "BESZEL_AGENT_TOKEN") -}}
{{ .Key }}={{ .Value }}
{{ end -}}
{{- end -}}
{{- end }}
# render-complete
