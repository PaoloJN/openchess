	(symbol
		(lib_id "openchess:A3144")
		(at 60.96 276.86 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110001-0000-4000-8000-000000000001")
		(property "Reference" "U1"
			(at 63.5 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 63.5 281.94 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 60.96 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba1103eb-0000-4000-8000-0000000003eb")
		)
		(pin "2"
			(uuid "ba1103ec-0000-4000-8000-0000000003ec")
		)
		(pin "3"
			(uuid "ba1103ed-0000-4000-8000-0000000003ed")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U1") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 55.88 274.32) (xy 50.8 274.32))
		(stroke (width 0) (type default))
		(uuid "ba111389-0000-4000-8000-000000001389")
	)
	(label "CA_PWR"
		(at 50.8 274.32 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11138a-0000-4000-8000-00000000138a")
	)
	(wire
		(pts (xy 55.88 279.4) (xy 50.8 279.4))
		(stroke (width 0) (type default))
		(uuid "ba11138b-0000-4000-8000-00000000138b")
	)
	(label "S0"
		(at 50.8 279.4 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11138c-0000-4000-8000-00000000138c")
	)
	(symbol
		(lib_id "power:GND")
		(at 55.88 276.86 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b59-0000-4000-8000-000000001b59")
		(property "Reference" "#PWR_H1"
			(at 53.34 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 53.34 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 55.88 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c21-0000-4000-8000-000000001c21")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H1") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 60.96 248.92 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110002-0000-4000-8000-000000000002")
		(property "Reference" "U2"
			(at 63.5 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 63.5 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 60.96 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba1103ee-0000-4000-8000-0000000003ee")
		)
		(pin "2"
			(uuid "ba1103ef-0000-4000-8000-0000000003ef")
		)
		(pin "3"
			(uuid "ba1103f0-0000-4000-8000-0000000003f0")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U2") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 55.88 246.38) (xy 50.8 246.38))
		(stroke (width 0) (type default))
		(uuid "ba11138d-0000-4000-8000-00000000138d")
	)
	(label "CA_PWR"
		(at 50.8 246.38 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11138e-0000-4000-8000-00000000138e")
	)
	(wire
		(pts (xy 55.88 251.46) (xy 50.8 251.46))
		(stroke (width 0) (type default))
		(uuid "ba11138f-0000-4000-8000-00000000138f")
	)
	(label "S1"
		(at 50.8 251.46 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111390-0000-4000-8000-000000001390")
	)
	(symbol
		(lib_id "power:GND")
		(at 55.88 248.92 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b5a-0000-4000-8000-000000001b5a")
		(property "Reference" "#PWR_H2"
			(at 53.34 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 53.34 251.46 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 55.88 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c22-0000-4000-8000-000000001c22")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H2") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 60.96 220.98 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110003-0000-4000-8000-000000000003")
		(property "Reference" "U3"
			(at 63.5 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 63.5 226.06 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 60.96 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba1103f1-0000-4000-8000-0000000003f1")
		)
		(pin "2"
			(uuid "ba1103f2-0000-4000-8000-0000000003f2")
		)
		(pin "3"
			(uuid "ba1103f3-0000-4000-8000-0000000003f3")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U3") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 55.88 218.44) (xy 50.8 218.44))
		(stroke (width 0) (type default))
		(uuid "ba111391-0000-4000-8000-000000001391")
	)
	(label "CA_PWR"
		(at 50.8 218.44 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111392-0000-4000-8000-000000001392")
	)
	(wire
		(pts (xy 55.88 223.52) (xy 50.8 223.52))
		(stroke (width 0) (type default))
		(uuid "ba111393-0000-4000-8000-000000001393")
	)
	(label "S2"
		(at 50.8 223.52 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111394-0000-4000-8000-000000001394")
	)
	(symbol
		(lib_id "power:GND")
		(at 55.88 220.98 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b5b-0000-4000-8000-000000001b5b")
		(property "Reference" "#PWR_H3"
			(at 53.34 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 53.34 223.52 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 55.88 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c23-0000-4000-8000-000000001c23")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H3") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 60.96 193.04 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110004-0000-4000-8000-000000000004")
		(property "Reference" "U4"
			(at 63.5 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 63.5 198.12 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 60.96 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba1103f4-0000-4000-8000-0000000003f4")
		)
		(pin "2"
			(uuid "ba1103f5-0000-4000-8000-0000000003f5")
		)
		(pin "3"
			(uuid "ba1103f6-0000-4000-8000-0000000003f6")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U4") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 55.88 190.5) (xy 50.8 190.5))
		(stroke (width 0) (type default))
		(uuid "ba111395-0000-4000-8000-000000001395")
	)
	(label "CA_PWR"
		(at 50.8 190.5 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111396-0000-4000-8000-000000001396")
	)
	(wire
		(pts (xy 55.88 195.58) (xy 50.8 195.58))
		(stroke (width 0) (type default))
		(uuid "ba111397-0000-4000-8000-000000001397")
	)
	(label "S3"
		(at 50.8 195.58 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111398-0000-4000-8000-000000001398")
	)
	(symbol
		(lib_id "power:GND")
		(at 55.88 193.04 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b5c-0000-4000-8000-000000001b5c")
		(property "Reference" "#PWR_H4"
			(at 53.34 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 53.34 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 55.88 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c24-0000-4000-8000-000000001c24")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H4") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 60.96 165.1 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110005-0000-4000-8000-000000000005")
		(property "Reference" "U5"
			(at 63.5 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 63.5 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 60.96 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba1103f7-0000-4000-8000-0000000003f7")
		)
		(pin "2"
			(uuid "ba1103f8-0000-4000-8000-0000000003f8")
		)
		(pin "3"
			(uuid "ba1103f9-0000-4000-8000-0000000003f9")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U5") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 55.88 162.56) (xy 50.8 162.56))
		(stroke (width 0) (type default))
		(uuid "ba111399-0000-4000-8000-000000001399")
	)
	(label "CA_PWR"
		(at 50.8 162.56 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11139a-0000-4000-8000-00000000139a")
	)
	(wire
		(pts (xy 55.88 167.64) (xy 50.8 167.64))
		(stroke (width 0) (type default))
		(uuid "ba11139b-0000-4000-8000-00000000139b")
	)
	(label "S4"
		(at 50.8 167.64 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11139c-0000-4000-8000-00000000139c")
	)
	(symbol
		(lib_id "power:GND")
		(at 55.88 165.1 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b5d-0000-4000-8000-000000001b5d")
		(property "Reference" "#PWR_H5"
			(at 53.34 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 53.34 167.64 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 55.88 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c25-0000-4000-8000-000000001c25")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H5") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 60.96 137.16 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110006-0000-4000-8000-000000000006")
		(property "Reference" "U6"
			(at 63.5 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 63.5 142.24 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 60.96 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba1103fa-0000-4000-8000-0000000003fa")
		)
		(pin "2"
			(uuid "ba1103fb-0000-4000-8000-0000000003fb")
		)
		(pin "3"
			(uuid "ba1103fc-0000-4000-8000-0000000003fc")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U6") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 55.88 134.62) (xy 50.8 134.62))
		(stroke (width 0) (type default))
		(uuid "ba11139d-0000-4000-8000-00000000139d")
	)
	(label "CA_PWR"
		(at 50.8 134.62 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11139e-0000-4000-8000-00000000139e")
	)
	(wire
		(pts (xy 55.88 139.7) (xy 50.8 139.7))
		(stroke (width 0) (type default))
		(uuid "ba11139f-0000-4000-8000-00000000139f")
	)
	(label "S5"
		(at 50.8 139.7 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113a0-0000-4000-8000-0000000013a0")
	)
	(symbol
		(lib_id "power:GND")
		(at 55.88 137.16 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b5e-0000-4000-8000-000000001b5e")
		(property "Reference" "#PWR_H6"
			(at 53.34 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 53.34 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 55.88 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c26-0000-4000-8000-000000001c26")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H6") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 60.96 109.22 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110007-0000-4000-8000-000000000007")
		(property "Reference" "U7"
			(at 63.5 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 63.5 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 60.96 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba1103fd-0000-4000-8000-0000000003fd")
		)
		(pin "2"
			(uuid "ba1103fe-0000-4000-8000-0000000003fe")
		)
		(pin "3"
			(uuid "ba1103ff-0000-4000-8000-0000000003ff")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U7") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 55.88 106.68) (xy 50.8 106.68))
		(stroke (width 0) (type default))
		(uuid "ba1113a1-0000-4000-8000-0000000013a1")
	)
	(label "CA_PWR"
		(at 50.8 106.68 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113a2-0000-4000-8000-0000000013a2")
	)
	(wire
		(pts (xy 55.88 111.76) (xy 50.8 111.76))
		(stroke (width 0) (type default))
		(uuid "ba1113a3-0000-4000-8000-0000000013a3")
	)
	(label "S6"
		(at 50.8 111.76 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113a4-0000-4000-8000-0000000013a4")
	)
	(symbol
		(lib_id "power:GND")
		(at 55.88 109.22 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b5f-0000-4000-8000-000000001b5f")
		(property "Reference" "#PWR_H7"
			(at 53.34 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 53.34 111.76 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 55.88 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c27-0000-4000-8000-000000001c27")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H7") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 60.96 81.28 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110008-0000-4000-8000-000000000008")
		(property "Reference" "U8"
			(at 63.5 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 63.5 86.36 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 60.96 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110400-0000-4000-8000-000000000400")
		)
		(pin "2"
			(uuid "ba110401-0000-4000-8000-000000000401")
		)
		(pin "3"
			(uuid "ba110402-0000-4000-8000-000000000402")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U8") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 55.88 78.74) (xy 50.8 78.74))
		(stroke (width 0) (type default))
		(uuid "ba1113a5-0000-4000-8000-0000000013a5")
	)
	(label "CA_PWR"
		(at 50.8 78.74 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113a6-0000-4000-8000-0000000013a6")
	)
	(wire
		(pts (xy 55.88 83.82) (xy 50.8 83.82))
		(stroke (width 0) (type default))
		(uuid "ba1113a7-0000-4000-8000-0000000013a7")
	)
	(label "S7"
		(at 50.8 83.82 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113a8-0000-4000-8000-0000000013a8")
	)
	(symbol
		(lib_id "power:GND")
		(at 55.88 81.28 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b60-0000-4000-8000-000000001b60")
		(property "Reference" "#PWR_H8"
			(at 53.34 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 53.34 83.82 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 55.88 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c28-0000-4000-8000-000000001c28")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H8") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 91.44 276.86 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110009-0000-4000-8000-000000000009")
		(property "Reference" "U9"
			(at 93.98 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 93.98 281.94 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 91.44 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110403-0000-4000-8000-000000000403")
		)
		(pin "2"
			(uuid "ba110404-0000-4000-8000-000000000404")
		)
		(pin "3"
			(uuid "ba110405-0000-4000-8000-000000000405")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U9") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 86.36 274.32) (xy 81.28 274.32))
		(stroke (width 0) (type default))
		(uuid "ba1113a9-0000-4000-8000-0000000013a9")
	)
	(label "CB_PWR"
		(at 81.28 274.32 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113aa-0000-4000-8000-0000000013aa")
	)
	(wire
		(pts (xy 86.36 279.4) (xy 81.28 279.4))
		(stroke (width 0) (type default))
		(uuid "ba1113ab-0000-4000-8000-0000000013ab")
	)
	(label "S0"
		(at 81.28 279.4 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113ac-0000-4000-8000-0000000013ac")
	)
	(symbol
		(lib_id "power:GND")
		(at 86.36 276.86 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b61-0000-4000-8000-000000001b61")
		(property "Reference" "#PWR_H9"
			(at 83.82 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 83.82 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 86.36 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c29-0000-4000-8000-000000001c29")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H9") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 91.44 248.92 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11000a-0000-4000-8000-00000000000a")
		(property "Reference" "U10"
			(at 93.98 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 93.98 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 91.44 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110406-0000-4000-8000-000000000406")
		)
		(pin "2"
			(uuid "ba110407-0000-4000-8000-000000000407")
		)
		(pin "3"
			(uuid "ba110408-0000-4000-8000-000000000408")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U10") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 86.36 246.38) (xy 81.28 246.38))
		(stroke (width 0) (type default))
		(uuid "ba1113ad-0000-4000-8000-0000000013ad")
	)
	(label "CB_PWR"
		(at 81.28 246.38 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113ae-0000-4000-8000-0000000013ae")
	)
	(wire
		(pts (xy 86.36 251.46) (xy 81.28 251.46))
		(stroke (width 0) (type default))
		(uuid "ba1113af-0000-4000-8000-0000000013af")
	)
	(label "S1"
		(at 81.28 251.46 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113b0-0000-4000-8000-0000000013b0")
	)
	(symbol
		(lib_id "power:GND")
		(at 86.36 248.92 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b62-0000-4000-8000-000000001b62")
		(property "Reference" "#PWR_H10"
			(at 83.82 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 83.82 251.46 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 86.36 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c2a-0000-4000-8000-000000001c2a")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H10") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 91.44 220.98 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11000b-0000-4000-8000-00000000000b")
		(property "Reference" "U11"
			(at 93.98 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 93.98 226.06 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 91.44 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110409-0000-4000-8000-000000000409")
		)
		(pin "2"
			(uuid "ba11040a-0000-4000-8000-00000000040a")
		)
		(pin "3"
			(uuid "ba11040b-0000-4000-8000-00000000040b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U11") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 86.36 218.44) (xy 81.28 218.44))
		(stroke (width 0) (type default))
		(uuid "ba1113b1-0000-4000-8000-0000000013b1")
	)
	(label "CB_PWR"
		(at 81.28 218.44 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113b2-0000-4000-8000-0000000013b2")
	)
	(wire
		(pts (xy 86.36 223.52) (xy 81.28 223.52))
		(stroke (width 0) (type default))
		(uuid "ba1113b3-0000-4000-8000-0000000013b3")
	)
	(label "S2"
		(at 81.28 223.52 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113b4-0000-4000-8000-0000000013b4")
	)
	(symbol
		(lib_id "power:GND")
		(at 86.36 220.98 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b63-0000-4000-8000-000000001b63")
		(property "Reference" "#PWR_H11"
			(at 83.82 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 83.82 223.52 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 86.36 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c2b-0000-4000-8000-000000001c2b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H11") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 91.44 193.04 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11000c-0000-4000-8000-00000000000c")
		(property "Reference" "U12"
			(at 93.98 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 93.98 198.12 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 91.44 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11040c-0000-4000-8000-00000000040c")
		)
		(pin "2"
			(uuid "ba11040d-0000-4000-8000-00000000040d")
		)
		(pin "3"
			(uuid "ba11040e-0000-4000-8000-00000000040e")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U12") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 86.36 190.5) (xy 81.28 190.5))
		(stroke (width 0) (type default))
		(uuid "ba1113b5-0000-4000-8000-0000000013b5")
	)
	(label "CB_PWR"
		(at 81.28 190.5 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113b6-0000-4000-8000-0000000013b6")
	)
	(wire
		(pts (xy 86.36 195.58) (xy 81.28 195.58))
		(stroke (width 0) (type default))
		(uuid "ba1113b7-0000-4000-8000-0000000013b7")
	)
	(label "S3"
		(at 81.28 195.58 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113b8-0000-4000-8000-0000000013b8")
	)
	(symbol
		(lib_id "power:GND")
		(at 86.36 193.04 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b64-0000-4000-8000-000000001b64")
		(property "Reference" "#PWR_H12"
			(at 83.82 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 83.82 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 86.36 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c2c-0000-4000-8000-000000001c2c")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H12") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 91.44 165.1 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11000d-0000-4000-8000-00000000000d")
		(property "Reference" "U13"
			(at 93.98 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 93.98 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 91.44 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11040f-0000-4000-8000-00000000040f")
		)
		(pin "2"
			(uuid "ba110410-0000-4000-8000-000000000410")
		)
		(pin "3"
			(uuid "ba110411-0000-4000-8000-000000000411")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U13") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 86.36 162.56) (xy 81.28 162.56))
		(stroke (width 0) (type default))
		(uuid "ba1113b9-0000-4000-8000-0000000013b9")
	)
	(label "CB_PWR"
		(at 81.28 162.56 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113ba-0000-4000-8000-0000000013ba")
	)
	(wire
		(pts (xy 86.36 167.64) (xy 81.28 167.64))
		(stroke (width 0) (type default))
		(uuid "ba1113bb-0000-4000-8000-0000000013bb")
	)
	(label "S4"
		(at 81.28 167.64 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113bc-0000-4000-8000-0000000013bc")
	)
	(symbol
		(lib_id "power:GND")
		(at 86.36 165.1 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b65-0000-4000-8000-000000001b65")
		(property "Reference" "#PWR_H13"
			(at 83.82 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 83.82 167.64 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 86.36 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c2d-0000-4000-8000-000000001c2d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H13") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 91.44 137.16 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11000e-0000-4000-8000-00000000000e")
		(property "Reference" "U14"
			(at 93.98 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 93.98 142.24 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 91.44 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110412-0000-4000-8000-000000000412")
		)
		(pin "2"
			(uuid "ba110413-0000-4000-8000-000000000413")
		)
		(pin "3"
			(uuid "ba110414-0000-4000-8000-000000000414")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U14") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 86.36 134.62) (xy 81.28 134.62))
		(stroke (width 0) (type default))
		(uuid "ba1113bd-0000-4000-8000-0000000013bd")
	)
	(label "CB_PWR"
		(at 81.28 134.62 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113be-0000-4000-8000-0000000013be")
	)
	(wire
		(pts (xy 86.36 139.7) (xy 81.28 139.7))
		(stroke (width 0) (type default))
		(uuid "ba1113bf-0000-4000-8000-0000000013bf")
	)
	(label "S5"
		(at 81.28 139.7 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113c0-0000-4000-8000-0000000013c0")
	)
	(symbol
		(lib_id "power:GND")
		(at 86.36 137.16 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b66-0000-4000-8000-000000001b66")
		(property "Reference" "#PWR_H14"
			(at 83.82 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 83.82 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 86.36 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c2e-0000-4000-8000-000000001c2e")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H14") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 91.44 109.22 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11000f-0000-4000-8000-00000000000f")
		(property "Reference" "U15"
			(at 93.98 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 93.98 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 91.44 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110415-0000-4000-8000-000000000415")
		)
		(pin "2"
			(uuid "ba110416-0000-4000-8000-000000000416")
		)
		(pin "3"
			(uuid "ba110417-0000-4000-8000-000000000417")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U15") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 86.36 106.68) (xy 81.28 106.68))
		(stroke (width 0) (type default))
		(uuid "ba1113c1-0000-4000-8000-0000000013c1")
	)
	(label "CB_PWR"
		(at 81.28 106.68 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113c2-0000-4000-8000-0000000013c2")
	)
	(wire
		(pts (xy 86.36 111.76) (xy 81.28 111.76))
		(stroke (width 0) (type default))
		(uuid "ba1113c3-0000-4000-8000-0000000013c3")
	)
	(label "S6"
		(at 81.28 111.76 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113c4-0000-4000-8000-0000000013c4")
	)
	(symbol
		(lib_id "power:GND")
		(at 86.36 109.22 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b67-0000-4000-8000-000000001b67")
		(property "Reference" "#PWR_H15"
			(at 83.82 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 83.82 111.76 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 86.36 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c2f-0000-4000-8000-000000001c2f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H15") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 91.44 81.28 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110010-0000-4000-8000-000000000010")
		(property "Reference" "U16"
			(at 93.98 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 93.98 86.36 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 91.44 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110418-0000-4000-8000-000000000418")
		)
		(pin "2"
			(uuid "ba110419-0000-4000-8000-000000000419")
		)
		(pin "3"
			(uuid "ba11041a-0000-4000-8000-00000000041a")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U16") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 86.36 78.74) (xy 81.28 78.74))
		(stroke (width 0) (type default))
		(uuid "ba1113c5-0000-4000-8000-0000000013c5")
	)
	(label "CB_PWR"
		(at 81.28 78.74 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113c6-0000-4000-8000-0000000013c6")
	)
	(wire
		(pts (xy 86.36 83.82) (xy 81.28 83.82))
		(stroke (width 0) (type default))
		(uuid "ba1113c7-0000-4000-8000-0000000013c7")
	)
	(label "S7"
		(at 81.28 83.82 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113c8-0000-4000-8000-0000000013c8")
	)
	(symbol
		(lib_id "power:GND")
		(at 86.36 81.28 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b68-0000-4000-8000-000000001b68")
		(property "Reference" "#PWR_H16"
			(at 83.82 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 83.82 83.82 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 86.36 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c30-0000-4000-8000-000000001c30")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H16") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 121.92 276.86 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110011-0000-4000-8000-000000000011")
		(property "Reference" "U17"
			(at 124.46 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 124.46 281.94 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 121.92 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11041b-0000-4000-8000-00000000041b")
		)
		(pin "2"
			(uuid "ba11041c-0000-4000-8000-00000000041c")
		)
		(pin "3"
			(uuid "ba11041d-0000-4000-8000-00000000041d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U17") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 116.84 274.32) (xy 111.76 274.32))
		(stroke (width 0) (type default))
		(uuid "ba1113c9-0000-4000-8000-0000000013c9")
	)
	(label "CC_PWR"
		(at 111.76 274.32 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113ca-0000-4000-8000-0000000013ca")
	)
	(wire
		(pts (xy 116.84 279.4) (xy 111.76 279.4))
		(stroke (width 0) (type default))
		(uuid "ba1113cb-0000-4000-8000-0000000013cb")
	)
	(label "S0"
		(at 111.76 279.4 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113cc-0000-4000-8000-0000000013cc")
	)
	(symbol
		(lib_id "power:GND")
		(at 116.84 276.86 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b69-0000-4000-8000-000000001b69")
		(property "Reference" "#PWR_H17"
			(at 114.3 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 114.3 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 116.84 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c31-0000-4000-8000-000000001c31")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H17") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 121.92 248.92 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110012-0000-4000-8000-000000000012")
		(property "Reference" "U18"
			(at 124.46 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 124.46 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 121.92 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11041e-0000-4000-8000-00000000041e")
		)
		(pin "2"
			(uuid "ba11041f-0000-4000-8000-00000000041f")
		)
		(pin "3"
			(uuid "ba110420-0000-4000-8000-000000000420")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U18") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 116.84 246.38) (xy 111.76 246.38))
		(stroke (width 0) (type default))
		(uuid "ba1113cd-0000-4000-8000-0000000013cd")
	)
	(label "CC_PWR"
		(at 111.76 246.38 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113ce-0000-4000-8000-0000000013ce")
	)
	(wire
		(pts (xy 116.84 251.46) (xy 111.76 251.46))
		(stroke (width 0) (type default))
		(uuid "ba1113cf-0000-4000-8000-0000000013cf")
	)
	(label "S1"
		(at 111.76 251.46 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113d0-0000-4000-8000-0000000013d0")
	)
	(symbol
		(lib_id "power:GND")
		(at 116.84 248.92 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b6a-0000-4000-8000-000000001b6a")
		(property "Reference" "#PWR_H18"
			(at 114.3 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 114.3 251.46 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 116.84 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c32-0000-4000-8000-000000001c32")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H18") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 121.92 220.98 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110013-0000-4000-8000-000000000013")
		(property "Reference" "U19"
			(at 124.46 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 124.46 226.06 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 121.92 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110421-0000-4000-8000-000000000421")
		)
		(pin "2"
			(uuid "ba110422-0000-4000-8000-000000000422")
		)
		(pin "3"
			(uuid "ba110423-0000-4000-8000-000000000423")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U19") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 116.84 218.44) (xy 111.76 218.44))
		(stroke (width 0) (type default))
		(uuid "ba1113d1-0000-4000-8000-0000000013d1")
	)
	(label "CC_PWR"
		(at 111.76 218.44 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113d2-0000-4000-8000-0000000013d2")
	)
	(wire
		(pts (xy 116.84 223.52) (xy 111.76 223.52))
		(stroke (width 0) (type default))
		(uuid "ba1113d3-0000-4000-8000-0000000013d3")
	)
	(label "S2"
		(at 111.76 223.52 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113d4-0000-4000-8000-0000000013d4")
	)
	(symbol
		(lib_id "power:GND")
		(at 116.84 220.98 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b6b-0000-4000-8000-000000001b6b")
		(property "Reference" "#PWR_H19"
			(at 114.3 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 114.3 223.52 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 116.84 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c33-0000-4000-8000-000000001c33")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H19") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 121.92 193.04 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110014-0000-4000-8000-000000000014")
		(property "Reference" "U20"
			(at 124.46 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 124.46 198.12 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 121.92 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110424-0000-4000-8000-000000000424")
		)
		(pin "2"
			(uuid "ba110425-0000-4000-8000-000000000425")
		)
		(pin "3"
			(uuid "ba110426-0000-4000-8000-000000000426")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U20") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 116.84 190.5) (xy 111.76 190.5))
		(stroke (width 0) (type default))
		(uuid "ba1113d5-0000-4000-8000-0000000013d5")
	)
	(label "CC_PWR"
		(at 111.76 190.5 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113d6-0000-4000-8000-0000000013d6")
	)
	(wire
		(pts (xy 116.84 195.58) (xy 111.76 195.58))
		(stroke (width 0) (type default))
		(uuid "ba1113d7-0000-4000-8000-0000000013d7")
	)
	(label "S3"
		(at 111.76 195.58 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113d8-0000-4000-8000-0000000013d8")
	)
	(symbol
		(lib_id "power:GND")
		(at 116.84 193.04 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b6c-0000-4000-8000-000000001b6c")
		(property "Reference" "#PWR_H20"
			(at 114.3 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 114.3 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 116.84 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c34-0000-4000-8000-000000001c34")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H20") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 121.92 165.1 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110015-0000-4000-8000-000000000015")
		(property "Reference" "U21"
			(at 124.46 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 124.46 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 121.92 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110427-0000-4000-8000-000000000427")
		)
		(pin "2"
			(uuid "ba110428-0000-4000-8000-000000000428")
		)
		(pin "3"
			(uuid "ba110429-0000-4000-8000-000000000429")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U21") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 116.84 162.56) (xy 111.76 162.56))
		(stroke (width 0) (type default))
		(uuid "ba1113d9-0000-4000-8000-0000000013d9")
	)
	(label "CC_PWR"
		(at 111.76 162.56 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113da-0000-4000-8000-0000000013da")
	)
	(wire
		(pts (xy 116.84 167.64) (xy 111.76 167.64))
		(stroke (width 0) (type default))
		(uuid "ba1113db-0000-4000-8000-0000000013db")
	)
	(label "S4"
		(at 111.76 167.64 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113dc-0000-4000-8000-0000000013dc")
	)
	(symbol
		(lib_id "power:GND")
		(at 116.84 165.1 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b6d-0000-4000-8000-000000001b6d")
		(property "Reference" "#PWR_H21"
			(at 114.3 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 114.3 167.64 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 116.84 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c35-0000-4000-8000-000000001c35")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H21") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 121.92 137.16 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110016-0000-4000-8000-000000000016")
		(property "Reference" "U22"
			(at 124.46 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 124.46 142.24 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 121.92 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11042a-0000-4000-8000-00000000042a")
		)
		(pin "2"
			(uuid "ba11042b-0000-4000-8000-00000000042b")
		)
		(pin "3"
			(uuid "ba11042c-0000-4000-8000-00000000042c")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U22") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 116.84 134.62) (xy 111.76 134.62))
		(stroke (width 0) (type default))
		(uuid "ba1113dd-0000-4000-8000-0000000013dd")
	)
	(label "CC_PWR"
		(at 111.76 134.62 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113de-0000-4000-8000-0000000013de")
	)
	(wire
		(pts (xy 116.84 139.7) (xy 111.76 139.7))
		(stroke (width 0) (type default))
		(uuid "ba1113df-0000-4000-8000-0000000013df")
	)
	(label "S5"
		(at 111.76 139.7 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113e0-0000-4000-8000-0000000013e0")
	)
	(symbol
		(lib_id "power:GND")
		(at 116.84 137.16 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b6e-0000-4000-8000-000000001b6e")
		(property "Reference" "#PWR_H22"
			(at 114.3 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 114.3 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 116.84 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c36-0000-4000-8000-000000001c36")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H22") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 121.92 109.22 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110017-0000-4000-8000-000000000017")
		(property "Reference" "U23"
			(at 124.46 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 124.46 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 121.92 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11042d-0000-4000-8000-00000000042d")
		)
		(pin "2"
			(uuid "ba11042e-0000-4000-8000-00000000042e")
		)
		(pin "3"
			(uuid "ba11042f-0000-4000-8000-00000000042f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U23") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 116.84 106.68) (xy 111.76 106.68))
		(stroke (width 0) (type default))
		(uuid "ba1113e1-0000-4000-8000-0000000013e1")
	)
	(label "CC_PWR"
		(at 111.76 106.68 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113e2-0000-4000-8000-0000000013e2")
	)
	(wire
		(pts (xy 116.84 111.76) (xy 111.76 111.76))
		(stroke (width 0) (type default))
		(uuid "ba1113e3-0000-4000-8000-0000000013e3")
	)
	(label "S6"
		(at 111.76 111.76 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113e4-0000-4000-8000-0000000013e4")
	)
	(symbol
		(lib_id "power:GND")
		(at 116.84 109.22 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b6f-0000-4000-8000-000000001b6f")
		(property "Reference" "#PWR_H23"
			(at 114.3 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 114.3 111.76 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 116.84 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c37-0000-4000-8000-000000001c37")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H23") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 121.92 81.28 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110018-0000-4000-8000-000000000018")
		(property "Reference" "U24"
			(at 124.46 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 124.46 86.36 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 121.92 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110430-0000-4000-8000-000000000430")
		)
		(pin "2"
			(uuid "ba110431-0000-4000-8000-000000000431")
		)
		(pin "3"
			(uuid "ba110432-0000-4000-8000-000000000432")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U24") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 116.84 78.74) (xy 111.76 78.74))
		(stroke (width 0) (type default))
		(uuid "ba1113e5-0000-4000-8000-0000000013e5")
	)
	(label "CC_PWR"
		(at 111.76 78.74 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113e6-0000-4000-8000-0000000013e6")
	)
	(wire
		(pts (xy 116.84 83.82) (xy 111.76 83.82))
		(stroke (width 0) (type default))
		(uuid "ba1113e7-0000-4000-8000-0000000013e7")
	)
	(label "S7"
		(at 111.76 83.82 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113e8-0000-4000-8000-0000000013e8")
	)
	(symbol
		(lib_id "power:GND")
		(at 116.84 81.28 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b70-0000-4000-8000-000000001b70")
		(property "Reference" "#PWR_H24"
			(at 114.3 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 114.3 83.82 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 116.84 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c38-0000-4000-8000-000000001c38")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H24") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 152.4 276.86 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110019-0000-4000-8000-000000000019")
		(property "Reference" "U25"
			(at 154.94 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 154.94 281.94 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 152.4 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110433-0000-4000-8000-000000000433")
		)
		(pin "2"
			(uuid "ba110434-0000-4000-8000-000000000434")
		)
		(pin "3"
			(uuid "ba110435-0000-4000-8000-000000000435")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U25") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 147.32 274.32) (xy 142.24 274.32))
		(stroke (width 0) (type default))
		(uuid "ba1113e9-0000-4000-8000-0000000013e9")
	)
	(label "CD_PWR"
		(at 142.24 274.32 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113ea-0000-4000-8000-0000000013ea")
	)
	(wire
		(pts (xy 147.32 279.4) (xy 142.24 279.4))
		(stroke (width 0) (type default))
		(uuid "ba1113eb-0000-4000-8000-0000000013eb")
	)
	(label "S0"
		(at 142.24 279.4 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113ec-0000-4000-8000-0000000013ec")
	)
	(symbol
		(lib_id "power:GND")
		(at 147.32 276.86 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b71-0000-4000-8000-000000001b71")
		(property "Reference" "#PWR_H25"
			(at 144.78 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 144.78 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 147.32 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c39-0000-4000-8000-000000001c39")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H25") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 152.4 248.92 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11001a-0000-4000-8000-00000000001a")
		(property "Reference" "U26"
			(at 154.94 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 154.94 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 152.4 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110436-0000-4000-8000-000000000436")
		)
		(pin "2"
			(uuid "ba110437-0000-4000-8000-000000000437")
		)
		(pin "3"
			(uuid "ba110438-0000-4000-8000-000000000438")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U26") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 147.32 246.38) (xy 142.24 246.38))
		(stroke (width 0) (type default))
		(uuid "ba1113ed-0000-4000-8000-0000000013ed")
	)
	(label "CD_PWR"
		(at 142.24 246.38 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113ee-0000-4000-8000-0000000013ee")
	)
	(wire
		(pts (xy 147.32 251.46) (xy 142.24 251.46))
		(stroke (width 0) (type default))
		(uuid "ba1113ef-0000-4000-8000-0000000013ef")
	)
	(label "S1"
		(at 142.24 251.46 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113f0-0000-4000-8000-0000000013f0")
	)
	(symbol
		(lib_id "power:GND")
		(at 147.32 248.92 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b72-0000-4000-8000-000000001b72")
		(property "Reference" "#PWR_H26"
			(at 144.78 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 144.78 251.46 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 147.32 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c3a-0000-4000-8000-000000001c3a")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H26") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 152.4 220.98 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11001b-0000-4000-8000-00000000001b")
		(property "Reference" "U27"
			(at 154.94 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 154.94 226.06 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 152.4 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110439-0000-4000-8000-000000000439")
		)
		(pin "2"
			(uuid "ba11043a-0000-4000-8000-00000000043a")
		)
		(pin "3"
			(uuid "ba11043b-0000-4000-8000-00000000043b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U27") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 147.32 218.44) (xy 142.24 218.44))
		(stroke (width 0) (type default))
		(uuid "ba1113f1-0000-4000-8000-0000000013f1")
	)
	(label "CD_PWR"
		(at 142.24 218.44 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113f2-0000-4000-8000-0000000013f2")
	)
	(wire
		(pts (xy 147.32 223.52) (xy 142.24 223.52))
		(stroke (width 0) (type default))
		(uuid "ba1113f3-0000-4000-8000-0000000013f3")
	)
	(label "S2"
		(at 142.24 223.52 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113f4-0000-4000-8000-0000000013f4")
	)
	(symbol
		(lib_id "power:GND")
		(at 147.32 220.98 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b73-0000-4000-8000-000000001b73")
		(property "Reference" "#PWR_H27"
			(at 144.78 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 144.78 223.52 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 147.32 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c3b-0000-4000-8000-000000001c3b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H27") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 152.4 193.04 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11001c-0000-4000-8000-00000000001c")
		(property "Reference" "U28"
			(at 154.94 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 154.94 198.12 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 152.4 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11043c-0000-4000-8000-00000000043c")
		)
		(pin "2"
			(uuid "ba11043d-0000-4000-8000-00000000043d")
		)
		(pin "3"
			(uuid "ba11043e-0000-4000-8000-00000000043e")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U28") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 147.32 190.5) (xy 142.24 190.5))
		(stroke (width 0) (type default))
		(uuid "ba1113f5-0000-4000-8000-0000000013f5")
	)
	(label "CD_PWR"
		(at 142.24 190.5 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113f6-0000-4000-8000-0000000013f6")
	)
	(wire
		(pts (xy 147.32 195.58) (xy 142.24 195.58))
		(stroke (width 0) (type default))
		(uuid "ba1113f7-0000-4000-8000-0000000013f7")
	)
	(label "S3"
		(at 142.24 195.58 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113f8-0000-4000-8000-0000000013f8")
	)
	(symbol
		(lib_id "power:GND")
		(at 147.32 193.04 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b74-0000-4000-8000-000000001b74")
		(property "Reference" "#PWR_H28"
			(at 144.78 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 144.78 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 147.32 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c3c-0000-4000-8000-000000001c3c")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H28") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 152.4 165.1 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11001d-0000-4000-8000-00000000001d")
		(property "Reference" "U29"
			(at 154.94 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 154.94 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 152.4 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11043f-0000-4000-8000-00000000043f")
		)
		(pin "2"
			(uuid "ba110440-0000-4000-8000-000000000440")
		)
		(pin "3"
			(uuid "ba110441-0000-4000-8000-000000000441")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U29") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 147.32 162.56) (xy 142.24 162.56))
		(stroke (width 0) (type default))
		(uuid "ba1113f9-0000-4000-8000-0000000013f9")
	)
	(label "CD_PWR"
		(at 142.24 162.56 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113fa-0000-4000-8000-0000000013fa")
	)
	(wire
		(pts (xy 147.32 167.64) (xy 142.24 167.64))
		(stroke (width 0) (type default))
		(uuid "ba1113fb-0000-4000-8000-0000000013fb")
	)
	(label "S4"
		(at 142.24 167.64 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113fc-0000-4000-8000-0000000013fc")
	)
	(symbol
		(lib_id "power:GND")
		(at 147.32 165.1 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b75-0000-4000-8000-000000001b75")
		(property "Reference" "#PWR_H29"
			(at 144.78 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 144.78 167.64 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 147.32 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c3d-0000-4000-8000-000000001c3d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H29") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 152.4 137.16 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11001e-0000-4000-8000-00000000001e")
		(property "Reference" "U30"
			(at 154.94 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 154.94 142.24 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 152.4 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110442-0000-4000-8000-000000000442")
		)
		(pin "2"
			(uuid "ba110443-0000-4000-8000-000000000443")
		)
		(pin "3"
			(uuid "ba110444-0000-4000-8000-000000000444")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U30") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 147.32 134.62) (xy 142.24 134.62))
		(stroke (width 0) (type default))
		(uuid "ba1113fd-0000-4000-8000-0000000013fd")
	)
	(label "CD_PWR"
		(at 142.24 134.62 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba1113fe-0000-4000-8000-0000000013fe")
	)
	(wire
		(pts (xy 147.32 139.7) (xy 142.24 139.7))
		(stroke (width 0) (type default))
		(uuid "ba1113ff-0000-4000-8000-0000000013ff")
	)
	(label "S5"
		(at 142.24 139.7 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111400-0000-4000-8000-000000001400")
	)
	(symbol
		(lib_id "power:GND")
		(at 147.32 137.16 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b76-0000-4000-8000-000000001b76")
		(property "Reference" "#PWR_H30"
			(at 144.78 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 144.78 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 147.32 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c3e-0000-4000-8000-000000001c3e")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H30") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 152.4 109.22 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11001f-0000-4000-8000-00000000001f")
		(property "Reference" "U31"
			(at 154.94 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 154.94 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 152.4 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110445-0000-4000-8000-000000000445")
		)
		(pin "2"
			(uuid "ba110446-0000-4000-8000-000000000446")
		)
		(pin "3"
			(uuid "ba110447-0000-4000-8000-000000000447")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U31") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 147.32 106.68) (xy 142.24 106.68))
		(stroke (width 0) (type default))
		(uuid "ba111401-0000-4000-8000-000000001401")
	)
	(label "CD_PWR"
		(at 142.24 106.68 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111402-0000-4000-8000-000000001402")
	)
	(wire
		(pts (xy 147.32 111.76) (xy 142.24 111.76))
		(stroke (width 0) (type default))
		(uuid "ba111403-0000-4000-8000-000000001403")
	)
	(label "S6"
		(at 142.24 111.76 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111404-0000-4000-8000-000000001404")
	)
	(symbol
		(lib_id "power:GND")
		(at 147.32 109.22 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b77-0000-4000-8000-000000001b77")
		(property "Reference" "#PWR_H31"
			(at 144.78 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 144.78 111.76 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 147.32 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c3f-0000-4000-8000-000000001c3f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H31") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 152.4 81.28 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110020-0000-4000-8000-000000000020")
		(property "Reference" "U32"
			(at 154.94 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 154.94 86.36 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 152.4 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110448-0000-4000-8000-000000000448")
		)
		(pin "2"
			(uuid "ba110449-0000-4000-8000-000000000449")
		)
		(pin "3"
			(uuid "ba11044a-0000-4000-8000-00000000044a")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U32") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 147.32 78.74) (xy 142.24 78.74))
		(stroke (width 0) (type default))
		(uuid "ba111405-0000-4000-8000-000000001405")
	)
	(label "CD_PWR"
		(at 142.24 78.74 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111406-0000-4000-8000-000000001406")
	)
	(wire
		(pts (xy 147.32 83.82) (xy 142.24 83.82))
		(stroke (width 0) (type default))
		(uuid "ba111407-0000-4000-8000-000000001407")
	)
	(label "S7"
		(at 142.24 83.82 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111408-0000-4000-8000-000000001408")
	)
	(symbol
		(lib_id "power:GND")
		(at 147.32 81.28 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b78-0000-4000-8000-000000001b78")
		(property "Reference" "#PWR_H32"
			(at 144.78 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 144.78 83.82 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 147.32 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c40-0000-4000-8000-000000001c40")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H32") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 182.88 276.86 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110021-0000-4000-8000-000000000021")
		(property "Reference" "U33"
			(at 185.42 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 185.42 281.94 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 182.88 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11044b-0000-4000-8000-00000000044b")
		)
		(pin "2"
			(uuid "ba11044c-0000-4000-8000-00000000044c")
		)
		(pin "3"
			(uuid "ba11044d-0000-4000-8000-00000000044d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U33") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 177.8 274.32) (xy 172.72 274.32))
		(stroke (width 0) (type default))
		(uuid "ba111409-0000-4000-8000-000000001409")
	)
	(label "CE_PWR"
		(at 172.72 274.32 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11140a-0000-4000-8000-00000000140a")
	)
	(wire
		(pts (xy 177.8 279.4) (xy 172.72 279.4))
		(stroke (width 0) (type default))
		(uuid "ba11140b-0000-4000-8000-00000000140b")
	)
	(label "S0"
		(at 172.72 279.4 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11140c-0000-4000-8000-00000000140c")
	)
	(symbol
		(lib_id "power:GND")
		(at 177.8 276.86 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b79-0000-4000-8000-000000001b79")
		(property "Reference" "#PWR_H33"
			(at 175.26 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 175.26 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 177.8 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c41-0000-4000-8000-000000001c41")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H33") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 182.88 248.92 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110022-0000-4000-8000-000000000022")
		(property "Reference" "U34"
			(at 185.42 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 185.42 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 182.88 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11044e-0000-4000-8000-00000000044e")
		)
		(pin "2"
			(uuid "ba11044f-0000-4000-8000-00000000044f")
		)
		(pin "3"
			(uuid "ba110450-0000-4000-8000-000000000450")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U34") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 177.8 246.38) (xy 172.72 246.38))
		(stroke (width 0) (type default))
		(uuid "ba11140d-0000-4000-8000-00000000140d")
	)
	(label "CE_PWR"
		(at 172.72 246.38 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11140e-0000-4000-8000-00000000140e")
	)
	(wire
		(pts (xy 177.8 251.46) (xy 172.72 251.46))
		(stroke (width 0) (type default))
		(uuid "ba11140f-0000-4000-8000-00000000140f")
	)
	(label "S1"
		(at 172.72 251.46 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111410-0000-4000-8000-000000001410")
	)
	(symbol
		(lib_id "power:GND")
		(at 177.8 248.92 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b7a-0000-4000-8000-000000001b7a")
		(property "Reference" "#PWR_H34"
			(at 175.26 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 175.26 251.46 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 177.8 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c42-0000-4000-8000-000000001c42")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H34") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 182.88 220.98 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110023-0000-4000-8000-000000000023")
		(property "Reference" "U35"
			(at 185.42 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 185.42 226.06 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 182.88 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110451-0000-4000-8000-000000000451")
		)
		(pin "2"
			(uuid "ba110452-0000-4000-8000-000000000452")
		)
		(pin "3"
			(uuid "ba110453-0000-4000-8000-000000000453")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U35") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 177.8 218.44) (xy 172.72 218.44))
		(stroke (width 0) (type default))
		(uuid "ba111411-0000-4000-8000-000000001411")
	)
	(label "CE_PWR"
		(at 172.72 218.44 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111412-0000-4000-8000-000000001412")
	)
	(wire
		(pts (xy 177.8 223.52) (xy 172.72 223.52))
		(stroke (width 0) (type default))
		(uuid "ba111413-0000-4000-8000-000000001413")
	)
	(label "S2"
		(at 172.72 223.52 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111414-0000-4000-8000-000000001414")
	)
	(symbol
		(lib_id "power:GND")
		(at 177.8 220.98 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b7b-0000-4000-8000-000000001b7b")
		(property "Reference" "#PWR_H35"
			(at 175.26 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 175.26 223.52 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 177.8 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c43-0000-4000-8000-000000001c43")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H35") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 182.88 193.04 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110024-0000-4000-8000-000000000024")
		(property "Reference" "U36"
			(at 185.42 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 185.42 198.12 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 182.88 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110454-0000-4000-8000-000000000454")
		)
		(pin "2"
			(uuid "ba110455-0000-4000-8000-000000000455")
		)
		(pin "3"
			(uuid "ba110456-0000-4000-8000-000000000456")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U36") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 177.8 190.5) (xy 172.72 190.5))
		(stroke (width 0) (type default))
		(uuid "ba111415-0000-4000-8000-000000001415")
	)
	(label "CE_PWR"
		(at 172.72 190.5 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111416-0000-4000-8000-000000001416")
	)
	(wire
		(pts (xy 177.8 195.58) (xy 172.72 195.58))
		(stroke (width 0) (type default))
		(uuid "ba111417-0000-4000-8000-000000001417")
	)
	(label "S3"
		(at 172.72 195.58 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111418-0000-4000-8000-000000001418")
	)
	(symbol
		(lib_id "power:GND")
		(at 177.8 193.04 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b7c-0000-4000-8000-000000001b7c")
		(property "Reference" "#PWR_H36"
			(at 175.26 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 175.26 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 177.8 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c44-0000-4000-8000-000000001c44")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H36") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 182.88 165.1 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110025-0000-4000-8000-000000000025")
		(property "Reference" "U37"
			(at 185.42 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 185.42 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 182.88 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110457-0000-4000-8000-000000000457")
		)
		(pin "2"
			(uuid "ba110458-0000-4000-8000-000000000458")
		)
		(pin "3"
			(uuid "ba110459-0000-4000-8000-000000000459")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U37") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 177.8 162.56) (xy 172.72 162.56))
		(stroke (width 0) (type default))
		(uuid "ba111419-0000-4000-8000-000000001419")
	)
	(label "CE_PWR"
		(at 172.72 162.56 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11141a-0000-4000-8000-00000000141a")
	)
	(wire
		(pts (xy 177.8 167.64) (xy 172.72 167.64))
		(stroke (width 0) (type default))
		(uuid "ba11141b-0000-4000-8000-00000000141b")
	)
	(label "S4"
		(at 172.72 167.64 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11141c-0000-4000-8000-00000000141c")
	)
	(symbol
		(lib_id "power:GND")
		(at 177.8 165.1 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b7d-0000-4000-8000-000000001b7d")
		(property "Reference" "#PWR_H37"
			(at 175.26 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 175.26 167.64 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 177.8 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c45-0000-4000-8000-000000001c45")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H37") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 182.88 137.16 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110026-0000-4000-8000-000000000026")
		(property "Reference" "U38"
			(at 185.42 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 185.42 142.24 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 182.88 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11045a-0000-4000-8000-00000000045a")
		)
		(pin "2"
			(uuid "ba11045b-0000-4000-8000-00000000045b")
		)
		(pin "3"
			(uuid "ba11045c-0000-4000-8000-00000000045c")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U38") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 177.8 134.62) (xy 172.72 134.62))
		(stroke (width 0) (type default))
		(uuid "ba11141d-0000-4000-8000-00000000141d")
	)
	(label "CE_PWR"
		(at 172.72 134.62 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11141e-0000-4000-8000-00000000141e")
	)
	(wire
		(pts (xy 177.8 139.7) (xy 172.72 139.7))
		(stroke (width 0) (type default))
		(uuid "ba11141f-0000-4000-8000-00000000141f")
	)
	(label "S5"
		(at 172.72 139.7 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111420-0000-4000-8000-000000001420")
	)
	(symbol
		(lib_id "power:GND")
		(at 177.8 137.16 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b7e-0000-4000-8000-000000001b7e")
		(property "Reference" "#PWR_H38"
			(at 175.26 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 175.26 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 177.8 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c46-0000-4000-8000-000000001c46")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H38") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 182.88 109.22 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110027-0000-4000-8000-000000000027")
		(property "Reference" "U39"
			(at 185.42 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 185.42 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 182.88 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11045d-0000-4000-8000-00000000045d")
		)
		(pin "2"
			(uuid "ba11045e-0000-4000-8000-00000000045e")
		)
		(pin "3"
			(uuid "ba11045f-0000-4000-8000-00000000045f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U39") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 177.8 106.68) (xy 172.72 106.68))
		(stroke (width 0) (type default))
		(uuid "ba111421-0000-4000-8000-000000001421")
	)
	(label "CE_PWR"
		(at 172.72 106.68 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111422-0000-4000-8000-000000001422")
	)
	(wire
		(pts (xy 177.8 111.76) (xy 172.72 111.76))
		(stroke (width 0) (type default))
		(uuid "ba111423-0000-4000-8000-000000001423")
	)
	(label "S6"
		(at 172.72 111.76 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111424-0000-4000-8000-000000001424")
	)
	(symbol
		(lib_id "power:GND")
		(at 177.8 109.22 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b7f-0000-4000-8000-000000001b7f")
		(property "Reference" "#PWR_H39"
			(at 175.26 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 175.26 111.76 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 177.8 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c47-0000-4000-8000-000000001c47")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H39") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 182.88 81.28 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110028-0000-4000-8000-000000000028")
		(property "Reference" "U40"
			(at 185.42 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 185.42 86.36 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 182.88 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110460-0000-4000-8000-000000000460")
		)
		(pin "2"
			(uuid "ba110461-0000-4000-8000-000000000461")
		)
		(pin "3"
			(uuid "ba110462-0000-4000-8000-000000000462")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U40") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 177.8 78.74) (xy 172.72 78.74))
		(stroke (width 0) (type default))
		(uuid "ba111425-0000-4000-8000-000000001425")
	)
	(label "CE_PWR"
		(at 172.72 78.74 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111426-0000-4000-8000-000000001426")
	)
	(wire
		(pts (xy 177.8 83.82) (xy 172.72 83.82))
		(stroke (width 0) (type default))
		(uuid "ba111427-0000-4000-8000-000000001427")
	)
	(label "S7"
		(at 172.72 83.82 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111428-0000-4000-8000-000000001428")
	)
	(symbol
		(lib_id "power:GND")
		(at 177.8 81.28 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b80-0000-4000-8000-000000001b80")
		(property "Reference" "#PWR_H40"
			(at 175.26 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 175.26 83.82 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 177.8 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c48-0000-4000-8000-000000001c48")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H40") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 213.36 276.86 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110029-0000-4000-8000-000000000029")
		(property "Reference" "U41"
			(at 215.9 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 215.9 281.94 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 213.36 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110463-0000-4000-8000-000000000463")
		)
		(pin "2"
			(uuid "ba110464-0000-4000-8000-000000000464")
		)
		(pin "3"
			(uuid "ba110465-0000-4000-8000-000000000465")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U41") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 208.28 274.32) (xy 203.2 274.32))
		(stroke (width 0) (type default))
		(uuid "ba111429-0000-4000-8000-000000001429")
	)
	(label "CF_PWR"
		(at 203.2 274.32 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11142a-0000-4000-8000-00000000142a")
	)
	(wire
		(pts (xy 208.28 279.4) (xy 203.2 279.4))
		(stroke (width 0) (type default))
		(uuid "ba11142b-0000-4000-8000-00000000142b")
	)
	(label "S0"
		(at 203.2 279.4 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11142c-0000-4000-8000-00000000142c")
	)
	(symbol
		(lib_id "power:GND")
		(at 208.28 276.86 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b81-0000-4000-8000-000000001b81")
		(property "Reference" "#PWR_H41"
			(at 205.74 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 205.74 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 208.28 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c49-0000-4000-8000-000000001c49")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H41") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 213.36 248.92 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11002a-0000-4000-8000-00000000002a")
		(property "Reference" "U42"
			(at 215.9 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 215.9 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 213.36 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110466-0000-4000-8000-000000000466")
		)
		(pin "2"
			(uuid "ba110467-0000-4000-8000-000000000467")
		)
		(pin "3"
			(uuid "ba110468-0000-4000-8000-000000000468")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U42") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 208.28 246.38) (xy 203.2 246.38))
		(stroke (width 0) (type default))
		(uuid "ba11142d-0000-4000-8000-00000000142d")
	)
	(label "CF_PWR"
		(at 203.2 246.38 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11142e-0000-4000-8000-00000000142e")
	)
	(wire
		(pts (xy 208.28 251.46) (xy 203.2 251.46))
		(stroke (width 0) (type default))
		(uuid "ba11142f-0000-4000-8000-00000000142f")
	)
	(label "S1"
		(at 203.2 251.46 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111430-0000-4000-8000-000000001430")
	)
	(symbol
		(lib_id "power:GND")
		(at 208.28 248.92 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b82-0000-4000-8000-000000001b82")
		(property "Reference" "#PWR_H42"
			(at 205.74 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 205.74 251.46 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 208.28 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c4a-0000-4000-8000-000000001c4a")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H42") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 213.36 220.98 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11002b-0000-4000-8000-00000000002b")
		(property "Reference" "U43"
			(at 215.9 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 215.9 226.06 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 213.36 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110469-0000-4000-8000-000000000469")
		)
		(pin "2"
			(uuid "ba11046a-0000-4000-8000-00000000046a")
		)
		(pin "3"
			(uuid "ba11046b-0000-4000-8000-00000000046b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U43") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 208.28 218.44) (xy 203.2 218.44))
		(stroke (width 0) (type default))
		(uuid "ba111431-0000-4000-8000-000000001431")
	)
	(label "CF_PWR"
		(at 203.2 218.44 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111432-0000-4000-8000-000000001432")
	)
	(wire
		(pts (xy 208.28 223.52) (xy 203.2 223.52))
		(stroke (width 0) (type default))
		(uuid "ba111433-0000-4000-8000-000000001433")
	)
	(label "S2"
		(at 203.2 223.52 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111434-0000-4000-8000-000000001434")
	)
	(symbol
		(lib_id "power:GND")
		(at 208.28 220.98 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b83-0000-4000-8000-000000001b83")
		(property "Reference" "#PWR_H43"
			(at 205.74 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 205.74 223.52 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 208.28 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c4b-0000-4000-8000-000000001c4b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H43") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 213.36 193.04 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11002c-0000-4000-8000-00000000002c")
		(property "Reference" "U44"
			(at 215.9 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 215.9 198.12 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 213.36 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11046c-0000-4000-8000-00000000046c")
		)
		(pin "2"
			(uuid "ba11046d-0000-4000-8000-00000000046d")
		)
		(pin "3"
			(uuid "ba11046e-0000-4000-8000-00000000046e")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U44") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 208.28 190.5) (xy 203.2 190.5))
		(stroke (width 0) (type default))
		(uuid "ba111435-0000-4000-8000-000000001435")
	)
	(label "CF_PWR"
		(at 203.2 190.5 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111436-0000-4000-8000-000000001436")
	)
	(wire
		(pts (xy 208.28 195.58) (xy 203.2 195.58))
		(stroke (width 0) (type default))
		(uuid "ba111437-0000-4000-8000-000000001437")
	)
	(label "S3"
		(at 203.2 195.58 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111438-0000-4000-8000-000000001438")
	)
	(symbol
		(lib_id "power:GND")
		(at 208.28 193.04 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b84-0000-4000-8000-000000001b84")
		(property "Reference" "#PWR_H44"
			(at 205.74 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 205.74 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 208.28 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c4c-0000-4000-8000-000000001c4c")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H44") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 213.36 165.1 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11002d-0000-4000-8000-00000000002d")
		(property "Reference" "U45"
			(at 215.9 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 215.9 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 213.36 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11046f-0000-4000-8000-00000000046f")
		)
		(pin "2"
			(uuid "ba110470-0000-4000-8000-000000000470")
		)
		(pin "3"
			(uuid "ba110471-0000-4000-8000-000000000471")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U45") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 208.28 162.56) (xy 203.2 162.56))
		(stroke (width 0) (type default))
		(uuid "ba111439-0000-4000-8000-000000001439")
	)
	(label "CF_PWR"
		(at 203.2 162.56 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11143a-0000-4000-8000-00000000143a")
	)
	(wire
		(pts (xy 208.28 167.64) (xy 203.2 167.64))
		(stroke (width 0) (type default))
		(uuid "ba11143b-0000-4000-8000-00000000143b")
	)
	(label "S4"
		(at 203.2 167.64 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11143c-0000-4000-8000-00000000143c")
	)
	(symbol
		(lib_id "power:GND")
		(at 208.28 165.1 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b85-0000-4000-8000-000000001b85")
		(property "Reference" "#PWR_H45"
			(at 205.74 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 205.74 167.64 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 208.28 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c4d-0000-4000-8000-000000001c4d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H45") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 213.36 137.16 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11002e-0000-4000-8000-00000000002e")
		(property "Reference" "U46"
			(at 215.9 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 215.9 142.24 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 213.36 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110472-0000-4000-8000-000000000472")
		)
		(pin "2"
			(uuid "ba110473-0000-4000-8000-000000000473")
		)
		(pin "3"
			(uuid "ba110474-0000-4000-8000-000000000474")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U46") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 208.28 134.62) (xy 203.2 134.62))
		(stroke (width 0) (type default))
		(uuid "ba11143d-0000-4000-8000-00000000143d")
	)
	(label "CF_PWR"
		(at 203.2 134.62 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11143e-0000-4000-8000-00000000143e")
	)
	(wire
		(pts (xy 208.28 139.7) (xy 203.2 139.7))
		(stroke (width 0) (type default))
		(uuid "ba11143f-0000-4000-8000-00000000143f")
	)
	(label "S5"
		(at 203.2 139.7 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111440-0000-4000-8000-000000001440")
	)
	(symbol
		(lib_id "power:GND")
		(at 208.28 137.16 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b86-0000-4000-8000-000000001b86")
		(property "Reference" "#PWR_H46"
			(at 205.74 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 205.74 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 208.28 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c4e-0000-4000-8000-000000001c4e")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H46") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 213.36 109.22 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11002f-0000-4000-8000-00000000002f")
		(property "Reference" "U47"
			(at 215.9 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 215.9 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 213.36 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110475-0000-4000-8000-000000000475")
		)
		(pin "2"
			(uuid "ba110476-0000-4000-8000-000000000476")
		)
		(pin "3"
			(uuid "ba110477-0000-4000-8000-000000000477")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U47") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 208.28 106.68) (xy 203.2 106.68))
		(stroke (width 0) (type default))
		(uuid "ba111441-0000-4000-8000-000000001441")
	)
	(label "CF_PWR"
		(at 203.2 106.68 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111442-0000-4000-8000-000000001442")
	)
	(wire
		(pts (xy 208.28 111.76) (xy 203.2 111.76))
		(stroke (width 0) (type default))
		(uuid "ba111443-0000-4000-8000-000000001443")
	)
	(label "S6"
		(at 203.2 111.76 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111444-0000-4000-8000-000000001444")
	)
	(symbol
		(lib_id "power:GND")
		(at 208.28 109.22 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b87-0000-4000-8000-000000001b87")
		(property "Reference" "#PWR_H47"
			(at 205.74 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 205.74 111.76 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 208.28 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c4f-0000-4000-8000-000000001c4f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H47") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 213.36 81.28 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110030-0000-4000-8000-000000000030")
		(property "Reference" "U48"
			(at 215.9 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 215.9 86.36 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 213.36 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110478-0000-4000-8000-000000000478")
		)
		(pin "2"
			(uuid "ba110479-0000-4000-8000-000000000479")
		)
		(pin "3"
			(uuid "ba11047a-0000-4000-8000-00000000047a")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U48") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 208.28 78.74) (xy 203.2 78.74))
		(stroke (width 0) (type default))
		(uuid "ba111445-0000-4000-8000-000000001445")
	)
	(label "CF_PWR"
		(at 203.2 78.74 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111446-0000-4000-8000-000000001446")
	)
	(wire
		(pts (xy 208.28 83.82) (xy 203.2 83.82))
		(stroke (width 0) (type default))
		(uuid "ba111447-0000-4000-8000-000000001447")
	)
	(label "S7"
		(at 203.2 83.82 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111448-0000-4000-8000-000000001448")
	)
	(symbol
		(lib_id "power:GND")
		(at 208.28 81.28 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b88-0000-4000-8000-000000001b88")
		(property "Reference" "#PWR_H48"
			(at 205.74 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 205.74 83.82 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 208.28 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c50-0000-4000-8000-000000001c50")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H48") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 243.84 276.86 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110031-0000-4000-8000-000000000031")
		(property "Reference" "U49"
			(at 246.38 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 246.38 281.94 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 243.84 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11047b-0000-4000-8000-00000000047b")
		)
		(pin "2"
			(uuid "ba11047c-0000-4000-8000-00000000047c")
		)
		(pin "3"
			(uuid "ba11047d-0000-4000-8000-00000000047d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U49") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 238.76 274.32) (xy 233.68 274.32))
		(stroke (width 0) (type default))
		(uuid "ba111449-0000-4000-8000-000000001449")
	)
	(label "CG_PWR"
		(at 233.68 274.32 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11144a-0000-4000-8000-00000000144a")
	)
	(wire
		(pts (xy 238.76 279.4) (xy 233.68 279.4))
		(stroke (width 0) (type default))
		(uuid "ba11144b-0000-4000-8000-00000000144b")
	)
	(label "S0"
		(at 233.68 279.4 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11144c-0000-4000-8000-00000000144c")
	)
	(symbol
		(lib_id "power:GND")
		(at 238.76 276.86 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b89-0000-4000-8000-000000001b89")
		(property "Reference" "#PWR_H49"
			(at 236.22 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 236.22 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 238.76 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c51-0000-4000-8000-000000001c51")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H49") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 243.84 248.92 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110032-0000-4000-8000-000000000032")
		(property "Reference" "U50"
			(at 246.38 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 246.38 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 243.84 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11047e-0000-4000-8000-00000000047e")
		)
		(pin "2"
			(uuid "ba11047f-0000-4000-8000-00000000047f")
		)
		(pin "3"
			(uuid "ba110480-0000-4000-8000-000000000480")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U50") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 238.76 246.38) (xy 233.68 246.38))
		(stroke (width 0) (type default))
		(uuid "ba11144d-0000-4000-8000-00000000144d")
	)
	(label "CG_PWR"
		(at 233.68 246.38 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11144e-0000-4000-8000-00000000144e")
	)
	(wire
		(pts (xy 238.76 251.46) (xy 233.68 251.46))
		(stroke (width 0) (type default))
		(uuid "ba11144f-0000-4000-8000-00000000144f")
	)
	(label "S1"
		(at 233.68 251.46 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111450-0000-4000-8000-000000001450")
	)
	(symbol
		(lib_id "power:GND")
		(at 238.76 248.92 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b8a-0000-4000-8000-000000001b8a")
		(property "Reference" "#PWR_H50"
			(at 236.22 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 236.22 251.46 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 238.76 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c52-0000-4000-8000-000000001c52")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H50") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 243.84 220.98 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110033-0000-4000-8000-000000000033")
		(property "Reference" "U51"
			(at 246.38 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 246.38 226.06 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 243.84 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110481-0000-4000-8000-000000000481")
		)
		(pin "2"
			(uuid "ba110482-0000-4000-8000-000000000482")
		)
		(pin "3"
			(uuid "ba110483-0000-4000-8000-000000000483")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U51") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 238.76 218.44) (xy 233.68 218.44))
		(stroke (width 0) (type default))
		(uuid "ba111451-0000-4000-8000-000000001451")
	)
	(label "CG_PWR"
		(at 233.68 218.44 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111452-0000-4000-8000-000000001452")
	)
	(wire
		(pts (xy 238.76 223.52) (xy 233.68 223.52))
		(stroke (width 0) (type default))
		(uuid "ba111453-0000-4000-8000-000000001453")
	)
	(label "S2"
		(at 233.68 223.52 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111454-0000-4000-8000-000000001454")
	)
	(symbol
		(lib_id "power:GND")
		(at 238.76 220.98 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b8b-0000-4000-8000-000000001b8b")
		(property "Reference" "#PWR_H51"
			(at 236.22 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 236.22 223.52 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 238.76 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c53-0000-4000-8000-000000001c53")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H51") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 243.84 193.04 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110034-0000-4000-8000-000000000034")
		(property "Reference" "U52"
			(at 246.38 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 246.38 198.12 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 243.84 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110484-0000-4000-8000-000000000484")
		)
		(pin "2"
			(uuid "ba110485-0000-4000-8000-000000000485")
		)
		(pin "3"
			(uuid "ba110486-0000-4000-8000-000000000486")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U52") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 238.76 190.5) (xy 233.68 190.5))
		(stroke (width 0) (type default))
		(uuid "ba111455-0000-4000-8000-000000001455")
	)
	(label "CG_PWR"
		(at 233.68 190.5 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111456-0000-4000-8000-000000001456")
	)
	(wire
		(pts (xy 238.76 195.58) (xy 233.68 195.58))
		(stroke (width 0) (type default))
		(uuid "ba111457-0000-4000-8000-000000001457")
	)
	(label "S3"
		(at 233.68 195.58 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111458-0000-4000-8000-000000001458")
	)
	(symbol
		(lib_id "power:GND")
		(at 238.76 193.04 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b8c-0000-4000-8000-000000001b8c")
		(property "Reference" "#PWR_H52"
			(at 236.22 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 236.22 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 238.76 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c54-0000-4000-8000-000000001c54")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H52") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 243.84 165.1 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110035-0000-4000-8000-000000000035")
		(property "Reference" "U53"
			(at 246.38 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 246.38 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 243.84 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110487-0000-4000-8000-000000000487")
		)
		(pin "2"
			(uuid "ba110488-0000-4000-8000-000000000488")
		)
		(pin "3"
			(uuid "ba110489-0000-4000-8000-000000000489")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U53") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 238.76 162.56) (xy 233.68 162.56))
		(stroke (width 0) (type default))
		(uuid "ba111459-0000-4000-8000-000000001459")
	)
	(label "CG_PWR"
		(at 233.68 162.56 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11145a-0000-4000-8000-00000000145a")
	)
	(wire
		(pts (xy 238.76 167.64) (xy 233.68 167.64))
		(stroke (width 0) (type default))
		(uuid "ba11145b-0000-4000-8000-00000000145b")
	)
	(label "S4"
		(at 233.68 167.64 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11145c-0000-4000-8000-00000000145c")
	)
	(symbol
		(lib_id "power:GND")
		(at 238.76 165.1 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b8d-0000-4000-8000-000000001b8d")
		(property "Reference" "#PWR_H53"
			(at 236.22 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 236.22 167.64 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 238.76 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c55-0000-4000-8000-000000001c55")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H53") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 243.84 137.16 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110036-0000-4000-8000-000000000036")
		(property "Reference" "U54"
			(at 246.38 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 246.38 142.24 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 243.84 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11048a-0000-4000-8000-00000000048a")
		)
		(pin "2"
			(uuid "ba11048b-0000-4000-8000-00000000048b")
		)
		(pin "3"
			(uuid "ba11048c-0000-4000-8000-00000000048c")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U54") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 238.76 134.62) (xy 233.68 134.62))
		(stroke (width 0) (type default))
		(uuid "ba11145d-0000-4000-8000-00000000145d")
	)
	(label "CG_PWR"
		(at 233.68 134.62 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11145e-0000-4000-8000-00000000145e")
	)
	(wire
		(pts (xy 238.76 139.7) (xy 233.68 139.7))
		(stroke (width 0) (type default))
		(uuid "ba11145f-0000-4000-8000-00000000145f")
	)
	(label "S5"
		(at 233.68 139.7 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111460-0000-4000-8000-000000001460")
	)
	(symbol
		(lib_id "power:GND")
		(at 238.76 137.16 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b8e-0000-4000-8000-000000001b8e")
		(property "Reference" "#PWR_H54"
			(at 236.22 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 236.22 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 238.76 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c56-0000-4000-8000-000000001c56")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H54") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 243.84 109.22 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110037-0000-4000-8000-000000000037")
		(property "Reference" "U55"
			(at 246.38 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 246.38 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 243.84 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11048d-0000-4000-8000-00000000048d")
		)
		(pin "2"
			(uuid "ba11048e-0000-4000-8000-00000000048e")
		)
		(pin "3"
			(uuid "ba11048f-0000-4000-8000-00000000048f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U55") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 238.76 106.68) (xy 233.68 106.68))
		(stroke (width 0) (type default))
		(uuid "ba111461-0000-4000-8000-000000001461")
	)
	(label "CG_PWR"
		(at 233.68 106.68 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111462-0000-4000-8000-000000001462")
	)
	(wire
		(pts (xy 238.76 111.76) (xy 233.68 111.76))
		(stroke (width 0) (type default))
		(uuid "ba111463-0000-4000-8000-000000001463")
	)
	(label "S6"
		(at 233.68 111.76 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111464-0000-4000-8000-000000001464")
	)
	(symbol
		(lib_id "power:GND")
		(at 238.76 109.22 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b8f-0000-4000-8000-000000001b8f")
		(property "Reference" "#PWR_H55"
			(at 236.22 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 236.22 111.76 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 238.76 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c57-0000-4000-8000-000000001c57")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H55") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 243.84 81.28 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110038-0000-4000-8000-000000000038")
		(property "Reference" "U56"
			(at 246.38 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 246.38 86.36 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 243.84 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110490-0000-4000-8000-000000000490")
		)
		(pin "2"
			(uuid "ba110491-0000-4000-8000-000000000491")
		)
		(pin "3"
			(uuid "ba110492-0000-4000-8000-000000000492")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U56") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 238.76 78.74) (xy 233.68 78.74))
		(stroke (width 0) (type default))
		(uuid "ba111465-0000-4000-8000-000000001465")
	)
	(label "CG_PWR"
		(at 233.68 78.74 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111466-0000-4000-8000-000000001466")
	)
	(wire
		(pts (xy 238.76 83.82) (xy 233.68 83.82))
		(stroke (width 0) (type default))
		(uuid "ba111467-0000-4000-8000-000000001467")
	)
	(label "S7"
		(at 233.68 83.82 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111468-0000-4000-8000-000000001468")
	)
	(symbol
		(lib_id "power:GND")
		(at 238.76 81.28 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b90-0000-4000-8000-000000001b90")
		(property "Reference" "#PWR_H56"
			(at 236.22 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 236.22 83.82 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 238.76 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c58-0000-4000-8000-000000001c58")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H56") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 274.32 276.86 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110039-0000-4000-8000-000000000039")
		(property "Reference" "U57"
			(at 276.86 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 276.86 281.94 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 274.32 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110493-0000-4000-8000-000000000493")
		)
		(pin "2"
			(uuid "ba110494-0000-4000-8000-000000000494")
		)
		(pin "3"
			(uuid "ba110495-0000-4000-8000-000000000495")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U57") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 269.24 274.32) (xy 264.16 274.32))
		(stroke (width 0) (type default))
		(uuid "ba111469-0000-4000-8000-000000001469")
	)
	(label "CH_PWR"
		(at 264.16 274.32 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11146a-0000-4000-8000-00000000146a")
	)
	(wire
		(pts (xy 269.24 279.4) (xy 264.16 279.4))
		(stroke (width 0) (type default))
		(uuid "ba11146b-0000-4000-8000-00000000146b")
	)
	(label "S0"
		(at 264.16 279.4 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11146c-0000-4000-8000-00000000146c")
	)
	(symbol
		(lib_id "power:GND")
		(at 269.24 276.86 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b91-0000-4000-8000-000000001b91")
		(property "Reference" "#PWR_H57"
			(at 266.7 274.32 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 266.7 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 269.24 276.86 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c59-0000-4000-8000-000000001c59")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H57") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 274.32 248.92 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11003a-0000-4000-8000-00000000003a")
		(property "Reference" "U58"
			(at 276.86 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 276.86 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 274.32 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110496-0000-4000-8000-000000000496")
		)
		(pin "2"
			(uuid "ba110497-0000-4000-8000-000000000497")
		)
		(pin "3"
			(uuid "ba110498-0000-4000-8000-000000000498")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U58") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 269.24 246.38) (xy 264.16 246.38))
		(stroke (width 0) (type default))
		(uuid "ba11146d-0000-4000-8000-00000000146d")
	)
	(label "CH_PWR"
		(at 264.16 246.38 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11146e-0000-4000-8000-00000000146e")
	)
	(wire
		(pts (xy 269.24 251.46) (xy 264.16 251.46))
		(stroke (width 0) (type default))
		(uuid "ba11146f-0000-4000-8000-00000000146f")
	)
	(label "S1"
		(at 264.16 251.46 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111470-0000-4000-8000-000000001470")
	)
	(symbol
		(lib_id "power:GND")
		(at 269.24 248.92 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b92-0000-4000-8000-000000001b92")
		(property "Reference" "#PWR_H58"
			(at 266.7 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 266.7 251.46 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 269.24 248.92 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c5a-0000-4000-8000-000000001c5a")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H58") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 274.32 220.98 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11003b-0000-4000-8000-00000000003b")
		(property "Reference" "U59"
			(at 276.86 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 276.86 226.06 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 274.32 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba110499-0000-4000-8000-000000000499")
		)
		(pin "2"
			(uuid "ba11049a-0000-4000-8000-00000000049a")
		)
		(pin "3"
			(uuid "ba11049b-0000-4000-8000-00000000049b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U59") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 269.24 218.44) (xy 264.16 218.44))
		(stroke (width 0) (type default))
		(uuid "ba111471-0000-4000-8000-000000001471")
	)
	(label "CH_PWR"
		(at 264.16 218.44 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111472-0000-4000-8000-000000001472")
	)
	(wire
		(pts (xy 269.24 223.52) (xy 264.16 223.52))
		(stroke (width 0) (type default))
		(uuid "ba111473-0000-4000-8000-000000001473")
	)
	(label "S2"
		(at 264.16 223.52 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111474-0000-4000-8000-000000001474")
	)
	(symbol
		(lib_id "power:GND")
		(at 269.24 220.98 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b93-0000-4000-8000-000000001b93")
		(property "Reference" "#PWR_H59"
			(at 266.7 218.44 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 266.7 223.52 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 269.24 220.98 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c5b-0000-4000-8000-000000001c5b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H59") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 274.32 193.04 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11003c-0000-4000-8000-00000000003c")
		(property "Reference" "U60"
			(at 276.86 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 276.86 198.12 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 274.32 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11049c-0000-4000-8000-00000000049c")
		)
		(pin "2"
			(uuid "ba11049d-0000-4000-8000-00000000049d")
		)
		(pin "3"
			(uuid "ba11049e-0000-4000-8000-00000000049e")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U60") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 269.24 190.5) (xy 264.16 190.5))
		(stroke (width 0) (type default))
		(uuid "ba111475-0000-4000-8000-000000001475")
	)
	(label "CH_PWR"
		(at 264.16 190.5 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111476-0000-4000-8000-000000001476")
	)
	(wire
		(pts (xy 269.24 195.58) (xy 264.16 195.58))
		(stroke (width 0) (type default))
		(uuid "ba111477-0000-4000-8000-000000001477")
	)
	(label "S3"
		(at 264.16 195.58 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111478-0000-4000-8000-000000001478")
	)
	(symbol
		(lib_id "power:GND")
		(at 269.24 193.04 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b94-0000-4000-8000-000000001b94")
		(property "Reference" "#PWR_H60"
			(at 266.7 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 266.7 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 269.24 193.04 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c5c-0000-4000-8000-000000001c5c")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H60") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 274.32 165.1 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11003d-0000-4000-8000-00000000003d")
		(property "Reference" "U61"
			(at 276.86 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 276.86 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 274.32 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba11049f-0000-4000-8000-00000000049f")
		)
		(pin "2"
			(uuid "ba1104a0-0000-4000-8000-0000000004a0")
		)
		(pin "3"
			(uuid "ba1104a1-0000-4000-8000-0000000004a1")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U61") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 269.24 162.56) (xy 264.16 162.56))
		(stroke (width 0) (type default))
		(uuid "ba111479-0000-4000-8000-000000001479")
	)
	(label "CH_PWR"
		(at 264.16 162.56 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11147a-0000-4000-8000-00000000147a")
	)
	(wire
		(pts (xy 269.24 167.64) (xy 264.16 167.64))
		(stroke (width 0) (type default))
		(uuid "ba11147b-0000-4000-8000-00000000147b")
	)
	(label "S4"
		(at 264.16 167.64 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11147c-0000-4000-8000-00000000147c")
	)
	(symbol
		(lib_id "power:GND")
		(at 269.24 165.1 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b95-0000-4000-8000-000000001b95")
		(property "Reference" "#PWR_H61"
			(at 266.7 162.56 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 266.7 167.64 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 269.24 165.1 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c5d-0000-4000-8000-000000001c5d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H61") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 274.32 137.16 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11003e-0000-4000-8000-00000000003e")
		(property "Reference" "U62"
			(at 276.86 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 276.86 142.24 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 274.32 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba1104a2-0000-4000-8000-0000000004a2")
		)
		(pin "2"
			(uuid "ba1104a3-0000-4000-8000-0000000004a3")
		)
		(pin "3"
			(uuid "ba1104a4-0000-4000-8000-0000000004a4")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U62") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 269.24 134.62) (xy 264.16 134.62))
		(stroke (width 0) (type default))
		(uuid "ba11147d-0000-4000-8000-00000000147d")
	)
	(label "CH_PWR"
		(at 264.16 134.62 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba11147e-0000-4000-8000-00000000147e")
	)
	(wire
		(pts (xy 269.24 139.7) (xy 264.16 139.7))
		(stroke (width 0) (type default))
		(uuid "ba11147f-0000-4000-8000-00000000147f")
	)
	(label "S5"
		(at 264.16 139.7 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111480-0000-4000-8000-000000001480")
	)
	(symbol
		(lib_id "power:GND")
		(at 269.24 137.16 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b96-0000-4000-8000-000000001b96")
		(property "Reference" "#PWR_H62"
			(at 266.7 134.62 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 266.7 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 269.24 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c5e-0000-4000-8000-000000001c5e")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H62") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 274.32 109.22 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba11003f-0000-4000-8000-00000000003f")
		(property "Reference" "U63"
			(at 276.86 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 276.86 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 274.32 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba1104a5-0000-4000-8000-0000000004a5")
		)
		(pin "2"
			(uuid "ba1104a6-0000-4000-8000-0000000004a6")
		)
		(pin "3"
			(uuid "ba1104a7-0000-4000-8000-0000000004a7")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U63") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 269.24 106.68) (xy 264.16 106.68))
		(stroke (width 0) (type default))
		(uuid "ba111481-0000-4000-8000-000000001481")
	)
	(label "CH_PWR"
		(at 264.16 106.68 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111482-0000-4000-8000-000000001482")
	)
	(wire
		(pts (xy 269.24 111.76) (xy 264.16 111.76))
		(stroke (width 0) (type default))
		(uuid "ba111483-0000-4000-8000-000000001483")
	)
	(label "S6"
		(at 264.16 111.76 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111484-0000-4000-8000-000000001484")
	)
	(symbol
		(lib_id "power:GND")
		(at 269.24 109.22 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b97-0000-4000-8000-000000001b97")
		(property "Reference" "#PWR_H63"
			(at 266.7 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 266.7 111.76 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 269.24 109.22 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c5f-0000-4000-8000-000000001c5f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H63") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "openchess:A3144")
		(at 274.32 81.28 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "ba110040-0000-4000-8000-000000000040")
		(property "Reference" "U64"
			(at 276.86 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "A3144"
			(at 276.86 86.36 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
			(at 274.32 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba1104a8-0000-4000-8000-0000000004a8")
		)
		(pin "2"
			(uuid "ba1104a9-0000-4000-8000-0000000004a9")
		)
		(pin "3"
			(uuid "ba1104aa-0000-4000-8000-0000000004aa")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "U64") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 269.24 78.74) (xy 264.16 78.74))
		(stroke (width 0) (type default))
		(uuid "ba111485-0000-4000-8000-000000001485")
	)
	(label "CH_PWR"
		(at 264.16 78.74 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111486-0000-4000-8000-000000001486")
	)
	(wire
		(pts (xy 269.24 83.82) (xy 264.16 83.82))
		(stroke (width 0) (type default))
		(uuid "ba111487-0000-4000-8000-000000001487")
	)
	(label "S7"
		(at 264.16 83.82 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "ba111488-0000-4000-8000-000000001488")
	)
	(symbol
		(lib_id "power:GND")
		(at 269.24 81.28 270)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "ba111b98-0000-4000-8000-000000001b98")
		(property "Reference" "#PWR_H64"
			(at 266.7 78.74 0)
			(effects (font (size 1.27 1.27)) (justify left) (hide yes))
		)
		(property "Value" "GND"
			(at 266.7 83.82 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 269.24 81.28 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "ba111c60-0000-4000-8000-000000001c60")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_H64") (unit 1))
			)
		)
	)
