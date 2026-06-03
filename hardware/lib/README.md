# Custom KiCad libraries

Project-local symbols, footprints, and 3D models that aren't in KiCad's
default libraries.

Currently empty — all components use stock KiCad 10 libraries. Add files
here only if you draw a custom symbol/footprint, and reference them from
`openchess.kicad_pro` so they travel with the project.

Notable substitutions in use today (no custom lib needed yet):
- A3144 hall sensor → `Connector_Generic:Conn_01x03` (1=VCC, 2=GND, 3=OUT) + TO-92 footprint
