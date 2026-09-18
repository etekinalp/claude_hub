export const meta = {
  name: 'find-todos',
  description: 'Fan out one agent per file in sample-modules/ to find TODO/FIXME markers, then report a consolidated list.',
}

const files = [
  'sample-modules/module-a.txt',
  'sample-modules/module-b.txt',
  'sample-modules/module-c.txt',
]

const findings = await pipeline(files, file =>
  agent(`Read ${file} and report any TODO or FIXME comments it contains, quoting them exactly. If there are none, say "none".`, { label: file }),
)

return findings.filter(Boolean)
