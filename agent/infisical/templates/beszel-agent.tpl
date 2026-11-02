{{- with secret "42e78412-394c-41c2-b6e0-33bea6ac57e6" "cre8or-lab-main-production-server" "/" -}}
{{- range . -}}
{{- if or (eq .Key "BESZEL_AGENT_KEY") (eq .Key "BESZEL_AGENT_TOKEN") -}}
{{ .Key }}={{ .Value }}
{{ end -}}
{{- end -}}
{{- end }}
# render-complete
