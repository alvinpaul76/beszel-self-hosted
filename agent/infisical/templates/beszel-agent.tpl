{{- with secret "__INFISICAL_PROJECT_ID__" "__INFISICAL_ENV__" "/" -}}
{{- range . -}}
{{- if or (eq .Key "BESZEL_AGENT_KEY") (eq .Key "BESZEL_AGENT_TOKEN") -}}
{{ .Key }}={{ .Value }}
{{ end -}}
{{- end -}}
{{- end }}
# render-complete
