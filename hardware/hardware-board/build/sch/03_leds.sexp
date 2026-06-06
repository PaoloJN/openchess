	(symbol
		(lib_id "LED:WS2812B")
		(at 312.42 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00001-0000-4000-8000-000000000001")
		(property "Reference" "D1"
			(at 312.42 68.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 312.42 88.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 312.42 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed007d4-0000-4000-8000-0000000007d4")
		)
		(pin "2"
			(uuid "1ed007d5-0000-4000-8000-0000000007d5")
		)
		(pin "3"
			(uuid "1ed007d6-0000-4000-8000-0000000007d6")
		)
		(pin "4"
			(uuid "1ed007d7-0000-4000-8000-0000000007d7")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D1") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 325.12 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50001-0000-4000-8000-000000000001")
		(property "Reference" "C10"
			(at 327.66 76.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 327.66 81.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 325.12 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bba-0000-4000-8000-000000000bba")
		)
		(pin "2"
			(uuid "1ed50bbb-0000-4000-8000-000000000bbb")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C10") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 325.12 74.93) (xy 325.12 72.39))
		(stroke (width 0) (type default))
		(uuid "1ed51389-0000-4000-8000-000000001389")
	)
	(label "+5V_LED"
		(at 325.12 72.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed5138a-0000-4000-8000-00000000138a")
	)
	(symbol
		(lib_id "power:GND")
		(at 325.12 82.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b59-0000-4000-8000-000000001b59")
		(property "Reference" "#PWR_L1"
			(at 327.66 85.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 327.66 80.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 325.12 82.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c21-0000-4000-8000-000000001c21")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L1") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 312.42 71.12) (xy 325.12 71.12))
		(stroke (width 0) (type default))
		(uuid "1ed01771-0000-4000-8000-000000001771")
	)
	(wire
		(pts (xy 325.12 71.12) (xy 325.12 74.93))
		(stroke (width 0) (type default))
		(uuid "1ed01772-0000-4000-8000-000000001772")
	)
	(wire
		(pts (xy 312.42 86.36) (xy 325.12 86.36))
		(stroke (width 0) (type default))
		(uuid "1ed01773-0000-4000-8000-000000001773")
	)
	(wire
		(pts (xy 325.12 86.36) (xy 325.12 82.55))
		(stroke (width 0) (type default))
		(uuid "1ed01774-0000-4000-8000-000000001774")
	)
	(label "LED_DATA_5V"
		(at 304.8 78.74 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "1ed01b59-0000-4000-8000-000000001b59")
	)
	(wire
		(pts (xy 320.04 78.74) (xy 332.74 78.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b5a-0000-4000-8000-000000001b5a")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 340.36 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00002-0000-4000-8000-000000000002")
		(property "Reference" "D2"
			(at 340.36 68.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 340.36 88.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 340.36 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed007d8-0000-4000-8000-0000000007d8")
		)
		(pin "2"
			(uuid "1ed007d9-0000-4000-8000-0000000007d9")
		)
		(pin "3"
			(uuid "1ed007da-0000-4000-8000-0000000007da")
		)
		(pin "4"
			(uuid "1ed007db-0000-4000-8000-0000000007db")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D2") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 353.06 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50002-0000-4000-8000-000000000002")
		(property "Reference" "C11"
			(at 355.6 76.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 355.6 81.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 353.06 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bbc-0000-4000-8000-000000000bbc")
		)
		(pin "2"
			(uuid "1ed50bbd-0000-4000-8000-000000000bbd")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C11") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 353.06 74.93) (xy 353.06 72.39))
		(stroke (width 0) (type default))
		(uuid "1ed5138b-0000-4000-8000-00000000138b")
	)
	(label "+5V_LED"
		(at 353.06 72.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed5138c-0000-4000-8000-00000000138c")
	)
	(symbol
		(lib_id "power:GND")
		(at 353.06 82.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b5a-0000-4000-8000-000000001b5a")
		(property "Reference" "#PWR_L2"
			(at 355.6 85.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 355.6 80.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 353.06 82.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c22-0000-4000-8000-000000001c22")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L2") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 340.36 71.12) (xy 353.06 71.12))
		(stroke (width 0) (type default))
		(uuid "1ed01775-0000-4000-8000-000000001775")
	)
	(wire
		(pts (xy 353.06 71.12) (xy 353.06 74.93))
		(stroke (width 0) (type default))
		(uuid "1ed01776-0000-4000-8000-000000001776")
	)
	(wire
		(pts (xy 340.36 86.36) (xy 353.06 86.36))
		(stroke (width 0) (type default))
		(uuid "1ed01777-0000-4000-8000-000000001777")
	)
	(wire
		(pts (xy 353.06 86.36) (xy 353.06 82.55))
		(stroke (width 0) (type default))
		(uuid "1ed01778-0000-4000-8000-000000001778")
	)
	(wire
		(pts (xy 347.98 78.74) (xy 360.68 78.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b5b-0000-4000-8000-000000001b5b")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 368.3 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00003-0000-4000-8000-000000000003")
		(property "Reference" "D3"
			(at 368.3 68.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 368.3 88.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 368.3 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed007dc-0000-4000-8000-0000000007dc")
		)
		(pin "2"
			(uuid "1ed007dd-0000-4000-8000-0000000007dd")
		)
		(pin "3"
			(uuid "1ed007de-0000-4000-8000-0000000007de")
		)
		(pin "4"
			(uuid "1ed007df-0000-4000-8000-0000000007df")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D3") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 381 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50003-0000-4000-8000-000000000003")
		(property "Reference" "C12"
			(at 383.54 76.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 383.54 81.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 381 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bbe-0000-4000-8000-000000000bbe")
		)
		(pin "2"
			(uuid "1ed50bbf-0000-4000-8000-000000000bbf")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C12") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 381 74.93) (xy 381 72.39))
		(stroke (width 0) (type default))
		(uuid "1ed5138d-0000-4000-8000-00000000138d")
	)
	(label "+5V_LED"
		(at 381 72.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed5138e-0000-4000-8000-00000000138e")
	)
	(symbol
		(lib_id "power:GND")
		(at 381 82.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b5b-0000-4000-8000-000000001b5b")
		(property "Reference" "#PWR_L3"
			(at 383.54 85.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 383.54 80.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 381 82.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c23-0000-4000-8000-000000001c23")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L3") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 368.3 71.12) (xy 381 71.12))
		(stroke (width 0) (type default))
		(uuid "1ed01779-0000-4000-8000-000000001779")
	)
	(wire
		(pts (xy 381 71.12) (xy 381 74.93))
		(stroke (width 0) (type default))
		(uuid "1ed0177a-0000-4000-8000-00000000177a")
	)
	(wire
		(pts (xy 368.3 86.36) (xy 381 86.36))
		(stroke (width 0) (type default))
		(uuid "1ed0177b-0000-4000-8000-00000000177b")
	)
	(wire
		(pts (xy 381 86.36) (xy 381 82.55))
		(stroke (width 0) (type default))
		(uuid "1ed0177c-0000-4000-8000-00000000177c")
	)
	(wire
		(pts (xy 375.92 78.74) (xy 388.62 78.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b5c-0000-4000-8000-000000001b5c")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 396.24 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00004-0000-4000-8000-000000000004")
		(property "Reference" "D4"
			(at 396.24 68.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 396.24 88.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 396.24 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed007e0-0000-4000-8000-0000000007e0")
		)
		(pin "2"
			(uuid "1ed007e1-0000-4000-8000-0000000007e1")
		)
		(pin "3"
			(uuid "1ed007e2-0000-4000-8000-0000000007e2")
		)
		(pin "4"
			(uuid "1ed007e3-0000-4000-8000-0000000007e3")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D4") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 408.94 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50004-0000-4000-8000-000000000004")
		(property "Reference" "C13"
			(at 411.48 76.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 411.48 81.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 408.94 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bc0-0000-4000-8000-000000000bc0")
		)
		(pin "2"
			(uuid "1ed50bc1-0000-4000-8000-000000000bc1")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C13") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 408.94 74.93) (xy 408.94 72.39))
		(stroke (width 0) (type default))
		(uuid "1ed5138f-0000-4000-8000-00000000138f")
	)
	(label "+5V_LED"
		(at 408.94 72.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51390-0000-4000-8000-000000001390")
	)
	(symbol
		(lib_id "power:GND")
		(at 408.94 82.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b5c-0000-4000-8000-000000001b5c")
		(property "Reference" "#PWR_L4"
			(at 411.48 85.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 411.48 80.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 408.94 82.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c24-0000-4000-8000-000000001c24")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L4") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 396.24 71.12) (xy 408.94 71.12))
		(stroke (width 0) (type default))
		(uuid "1ed0177d-0000-4000-8000-00000000177d")
	)
	(wire
		(pts (xy 408.94 71.12) (xy 408.94 74.93))
		(stroke (width 0) (type default))
		(uuid "1ed0177e-0000-4000-8000-00000000177e")
	)
	(wire
		(pts (xy 396.24 86.36) (xy 408.94 86.36))
		(stroke (width 0) (type default))
		(uuid "1ed0177f-0000-4000-8000-00000000177f")
	)
	(wire
		(pts (xy 408.94 86.36) (xy 408.94 82.55))
		(stroke (width 0) (type default))
		(uuid "1ed01780-0000-4000-8000-000000001780")
	)
	(wire
		(pts (xy 403.86 78.74) (xy 416.56 78.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b5d-0000-4000-8000-000000001b5d")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 424.18 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00005-0000-4000-8000-000000000005")
		(property "Reference" "D5"
			(at 424.18 68.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 424.18 88.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 424.18 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed007e4-0000-4000-8000-0000000007e4")
		)
		(pin "2"
			(uuid "1ed007e5-0000-4000-8000-0000000007e5")
		)
		(pin "3"
			(uuid "1ed007e6-0000-4000-8000-0000000007e6")
		)
		(pin "4"
			(uuid "1ed007e7-0000-4000-8000-0000000007e7")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D5") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 436.88 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50005-0000-4000-8000-000000000005")
		(property "Reference" "C14"
			(at 439.42 76.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 439.42 81.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 436.88 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bc2-0000-4000-8000-000000000bc2")
		)
		(pin "2"
			(uuid "1ed50bc3-0000-4000-8000-000000000bc3")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C14") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 436.88 74.93) (xy 436.88 72.39))
		(stroke (width 0) (type default))
		(uuid "1ed51391-0000-4000-8000-000000001391")
	)
	(label "+5V_LED"
		(at 436.88 72.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51392-0000-4000-8000-000000001392")
	)
	(symbol
		(lib_id "power:GND")
		(at 436.88 82.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b5d-0000-4000-8000-000000001b5d")
		(property "Reference" "#PWR_L5"
			(at 439.42 85.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 439.42 80.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 436.88 82.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c25-0000-4000-8000-000000001c25")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L5") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 424.18 71.12) (xy 436.88 71.12))
		(stroke (width 0) (type default))
		(uuid "1ed01781-0000-4000-8000-000000001781")
	)
	(wire
		(pts (xy 436.88 71.12) (xy 436.88 74.93))
		(stroke (width 0) (type default))
		(uuid "1ed01782-0000-4000-8000-000000001782")
	)
	(wire
		(pts (xy 424.18 86.36) (xy 436.88 86.36))
		(stroke (width 0) (type default))
		(uuid "1ed01783-0000-4000-8000-000000001783")
	)
	(wire
		(pts (xy 436.88 86.36) (xy 436.88 82.55))
		(stroke (width 0) (type default))
		(uuid "1ed01784-0000-4000-8000-000000001784")
	)
	(wire
		(pts (xy 431.8 78.74) (xy 444.5 78.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b5e-0000-4000-8000-000000001b5e")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 452.12 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00006-0000-4000-8000-000000000006")
		(property "Reference" "D6"
			(at 452.12 68.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 452.12 88.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 452.12 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed007e8-0000-4000-8000-0000000007e8")
		)
		(pin "2"
			(uuid "1ed007e9-0000-4000-8000-0000000007e9")
		)
		(pin "3"
			(uuid "1ed007ea-0000-4000-8000-0000000007ea")
		)
		(pin "4"
			(uuid "1ed007eb-0000-4000-8000-0000000007eb")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D6") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 464.82 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50006-0000-4000-8000-000000000006")
		(property "Reference" "C15"
			(at 467.36 76.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 467.36 81.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 464.82 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bc4-0000-4000-8000-000000000bc4")
		)
		(pin "2"
			(uuid "1ed50bc5-0000-4000-8000-000000000bc5")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C15") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 464.82 74.93) (xy 464.82 72.39))
		(stroke (width 0) (type default))
		(uuid "1ed51393-0000-4000-8000-000000001393")
	)
	(label "+5V_LED"
		(at 464.82 72.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51394-0000-4000-8000-000000001394")
	)
	(symbol
		(lib_id "power:GND")
		(at 464.82 82.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b5e-0000-4000-8000-000000001b5e")
		(property "Reference" "#PWR_L6"
			(at 467.36 85.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 467.36 80.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 464.82 82.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c26-0000-4000-8000-000000001c26")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L6") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 452.12 71.12) (xy 464.82 71.12))
		(stroke (width 0) (type default))
		(uuid "1ed01785-0000-4000-8000-000000001785")
	)
	(wire
		(pts (xy 464.82 71.12) (xy 464.82 74.93))
		(stroke (width 0) (type default))
		(uuid "1ed01786-0000-4000-8000-000000001786")
	)
	(wire
		(pts (xy 452.12 86.36) (xy 464.82 86.36))
		(stroke (width 0) (type default))
		(uuid "1ed01787-0000-4000-8000-000000001787")
	)
	(wire
		(pts (xy 464.82 86.36) (xy 464.82 82.55))
		(stroke (width 0) (type default))
		(uuid "1ed01788-0000-4000-8000-000000001788")
	)
	(wire
		(pts (xy 459.74 78.74) (xy 472.44 78.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b5f-0000-4000-8000-000000001b5f")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 480.06 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00007-0000-4000-8000-000000000007")
		(property "Reference" "D7"
			(at 480.06 68.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 480.06 88.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 480.06 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed007ec-0000-4000-8000-0000000007ec")
		)
		(pin "2"
			(uuid "1ed007ed-0000-4000-8000-0000000007ed")
		)
		(pin "3"
			(uuid "1ed007ee-0000-4000-8000-0000000007ee")
		)
		(pin "4"
			(uuid "1ed007ef-0000-4000-8000-0000000007ef")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D7") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 492.76 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50007-0000-4000-8000-000000000007")
		(property "Reference" "C16"
			(at 495.3 76.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 495.3 81.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 492.76 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bc6-0000-4000-8000-000000000bc6")
		)
		(pin "2"
			(uuid "1ed50bc7-0000-4000-8000-000000000bc7")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C16") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 492.76 74.93) (xy 492.76 72.39))
		(stroke (width 0) (type default))
		(uuid "1ed51395-0000-4000-8000-000000001395")
	)
	(label "+5V_LED"
		(at 492.76 72.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51396-0000-4000-8000-000000001396")
	)
	(symbol
		(lib_id "power:GND")
		(at 492.76 82.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b5f-0000-4000-8000-000000001b5f")
		(property "Reference" "#PWR_L7"
			(at 495.3 85.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 495.3 80.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 492.76 82.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c27-0000-4000-8000-000000001c27")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L7") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 480.06 71.12) (xy 492.76 71.12))
		(stroke (width 0) (type default))
		(uuid "1ed01789-0000-4000-8000-000000001789")
	)
	(wire
		(pts (xy 492.76 71.12) (xy 492.76 74.93))
		(stroke (width 0) (type default))
		(uuid "1ed0178a-0000-4000-8000-00000000178a")
	)
	(wire
		(pts (xy 480.06 86.36) (xy 492.76 86.36))
		(stroke (width 0) (type default))
		(uuid "1ed0178b-0000-4000-8000-00000000178b")
	)
	(wire
		(pts (xy 492.76 86.36) (xy 492.76 82.55))
		(stroke (width 0) (type default))
		(uuid "1ed0178c-0000-4000-8000-00000000178c")
	)
	(wire
		(pts (xy 487.68 78.74) (xy 500.38 78.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b60-0000-4000-8000-000000001b60")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 508 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00008-0000-4000-8000-000000000008")
		(property "Reference" "D8"
			(at 508 68.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 508 88.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 508 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed007f0-0000-4000-8000-0000000007f0")
		)
		(pin "2"
			(uuid "1ed007f1-0000-4000-8000-0000000007f1")
		)
		(pin "3"
			(uuid "1ed007f2-0000-4000-8000-0000000007f2")
		)
		(pin "4"
			(uuid "1ed007f3-0000-4000-8000-0000000007f3")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D8") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 520.7 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50008-0000-4000-8000-000000000008")
		(property "Reference" "C17"
			(at 523.24 76.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 523.24 81.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 520.7 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bc8-0000-4000-8000-000000000bc8")
		)
		(pin "2"
			(uuid "1ed50bc9-0000-4000-8000-000000000bc9")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C17") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 520.7 74.93) (xy 520.7 72.39))
		(stroke (width 0) (type default))
		(uuid "1ed51397-0000-4000-8000-000000001397")
	)
	(label "+5V_LED"
		(at 520.7 72.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51398-0000-4000-8000-000000001398")
	)
	(symbol
		(lib_id "power:GND")
		(at 520.7 82.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b60-0000-4000-8000-000000001b60")
		(property "Reference" "#PWR_L8"
			(at 523.24 85.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 523.24 80.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 520.7 82.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c28-0000-4000-8000-000000001c28")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L8") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 508 71.12) (xy 520.7 71.12))
		(stroke (width 0) (type default))
		(uuid "1ed0178d-0000-4000-8000-00000000178d")
	)
	(wire
		(pts (xy 520.7 71.12) (xy 520.7 74.93))
		(stroke (width 0) (type default))
		(uuid "1ed0178e-0000-4000-8000-00000000178e")
	)
	(wire
		(pts (xy 508 86.36) (xy 520.7 86.36))
		(stroke (width 0) (type default))
		(uuid "1ed0178f-0000-4000-8000-00000000178f")
	)
	(wire
		(pts (xy 520.7 86.36) (xy 520.7 82.55))
		(stroke (width 0) (type default))
		(uuid "1ed01790-0000-4000-8000-000000001790")
	)
	(wire
		(pts (xy 515.62 78.74) (xy 528.32 78.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b61-0000-4000-8000-000000001b61")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 535.94 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00009-0000-4000-8000-000000000009")
		(property "Reference" "D9"
			(at 535.94 68.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 535.94 88.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 535.94 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed007f4-0000-4000-8000-0000000007f4")
		)
		(pin "2"
			(uuid "1ed007f5-0000-4000-8000-0000000007f5")
		)
		(pin "3"
			(uuid "1ed007f6-0000-4000-8000-0000000007f6")
		)
		(pin "4"
			(uuid "1ed007f7-0000-4000-8000-0000000007f7")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D9") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 548.64 78.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50009-0000-4000-8000-000000000009")
		(property "Reference" "C18"
			(at 551.18 76.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 551.18 81.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 548.64 78.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bca-0000-4000-8000-000000000bca")
		)
		(pin "2"
			(uuid "1ed50bcb-0000-4000-8000-000000000bcb")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C18") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 548.64 74.93) (xy 548.64 72.39))
		(stroke (width 0) (type default))
		(uuid "1ed51399-0000-4000-8000-000000001399")
	)
	(label "+5V_LED"
		(at 548.64 72.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed5139a-0000-4000-8000-00000000139a")
	)
	(symbol
		(lib_id "power:GND")
		(at 548.64 82.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b61-0000-4000-8000-000000001b61")
		(property "Reference" "#PWR_L9"
			(at 551.18 85.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 551.18 80.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 548.64 82.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c29-0000-4000-8000-000000001c29")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L9") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 535.94 71.12) (xy 548.64 71.12))
		(stroke (width 0) (type default))
		(uuid "1ed01791-0000-4000-8000-000000001791")
	)
	(wire
		(pts (xy 548.64 71.12) (xy 548.64 74.93))
		(stroke (width 0) (type default))
		(uuid "1ed01792-0000-4000-8000-000000001792")
	)
	(wire
		(pts (xy 535.94 86.36) (xy 548.64 86.36))
		(stroke (width 0) (type default))
		(uuid "1ed01793-0000-4000-8000-000000001793")
	)
	(wire
		(pts (xy 548.64 86.36) (xy 548.64 82.55))
		(stroke (width 0) (type default))
		(uuid "1ed01794-0000-4000-8000-000000001794")
	)
	(label "L9"
		(at 543.56 78.74 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed01b62-0000-4000-8000-000000001b62")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 312.42 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0000a-0000-4000-8000-00000000000a")
		(property "Reference" "D10"
			(at 312.42 93.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 312.42 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 312.42 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed007f8-0000-4000-8000-0000000007f8")
		)
		(pin "2"
			(uuid "1ed007f9-0000-4000-8000-0000000007f9")
		)
		(pin "3"
			(uuid "1ed007fa-0000-4000-8000-0000000007fa")
		)
		(pin "4"
			(uuid "1ed007fb-0000-4000-8000-0000000007fb")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D10") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 325.12 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5000a-0000-4000-8000-00000000000a")
		(property "Reference" "C19"
			(at 327.66 101.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 327.66 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 325.12 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bcc-0000-4000-8000-000000000bcc")
		)
		(pin "2"
			(uuid "1ed50bcd-0000-4000-8000-000000000bcd")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C19") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 325.12 100.33) (xy 325.12 97.79))
		(stroke (width 0) (type default))
		(uuid "1ed5139b-0000-4000-8000-00000000139b")
	)
	(label "+5V_LED"
		(at 325.12 97.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed5139c-0000-4000-8000-00000000139c")
	)
	(symbol
		(lib_id "power:GND")
		(at 325.12 107.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b62-0000-4000-8000-000000001b62")
		(property "Reference" "#PWR_L10"
			(at 327.66 110.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 327.66 105.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 325.12 107.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c2a-0000-4000-8000-000000001c2a")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L10") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 312.42 96.52) (xy 325.12 96.52))
		(stroke (width 0) (type default))
		(uuid "1ed01795-0000-4000-8000-000000001795")
	)
	(wire
		(pts (xy 325.12 96.52) (xy 325.12 100.33))
		(stroke (width 0) (type default))
		(uuid "1ed01796-0000-4000-8000-000000001796")
	)
	(wire
		(pts (xy 312.42 111.76) (xy 325.12 111.76))
		(stroke (width 0) (type default))
		(uuid "1ed01797-0000-4000-8000-000000001797")
	)
	(wire
		(pts (xy 325.12 111.76) (xy 325.12 107.95))
		(stroke (width 0) (type default))
		(uuid "1ed01798-0000-4000-8000-000000001798")
	)
	(label "L9"
		(at 304.8 104.14 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "1ed01b63-0000-4000-8000-000000001b63")
	)
	(wire
		(pts (xy 320.04 104.14) (xy 332.74 104.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b64-0000-4000-8000-000000001b64")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 340.36 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0000b-0000-4000-8000-00000000000b")
		(property "Reference" "D11"
			(at 340.36 93.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 340.36 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 340.36 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed007fc-0000-4000-8000-0000000007fc")
		)
		(pin "2"
			(uuid "1ed007fd-0000-4000-8000-0000000007fd")
		)
		(pin "3"
			(uuid "1ed007fe-0000-4000-8000-0000000007fe")
		)
		(pin "4"
			(uuid "1ed007ff-0000-4000-8000-0000000007ff")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D11") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 353.06 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5000b-0000-4000-8000-00000000000b")
		(property "Reference" "C20"
			(at 355.6 101.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 355.6 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 353.06 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bce-0000-4000-8000-000000000bce")
		)
		(pin "2"
			(uuid "1ed50bcf-0000-4000-8000-000000000bcf")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C20") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 353.06 100.33) (xy 353.06 97.79))
		(stroke (width 0) (type default))
		(uuid "1ed5139d-0000-4000-8000-00000000139d")
	)
	(label "+5V_LED"
		(at 353.06 97.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed5139e-0000-4000-8000-00000000139e")
	)
	(symbol
		(lib_id "power:GND")
		(at 353.06 107.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b63-0000-4000-8000-000000001b63")
		(property "Reference" "#PWR_L11"
			(at 355.6 110.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 355.6 105.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 353.06 107.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c2b-0000-4000-8000-000000001c2b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L11") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 340.36 96.52) (xy 353.06 96.52))
		(stroke (width 0) (type default))
		(uuid "1ed01799-0000-4000-8000-000000001799")
	)
	(wire
		(pts (xy 353.06 96.52) (xy 353.06 100.33))
		(stroke (width 0) (type default))
		(uuid "1ed0179a-0000-4000-8000-00000000179a")
	)
	(wire
		(pts (xy 340.36 111.76) (xy 353.06 111.76))
		(stroke (width 0) (type default))
		(uuid "1ed0179b-0000-4000-8000-00000000179b")
	)
	(wire
		(pts (xy 353.06 111.76) (xy 353.06 107.95))
		(stroke (width 0) (type default))
		(uuid "1ed0179c-0000-4000-8000-00000000179c")
	)
	(wire
		(pts (xy 347.98 104.14) (xy 360.68 104.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b65-0000-4000-8000-000000001b65")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 368.3 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0000c-0000-4000-8000-00000000000c")
		(property "Reference" "D12"
			(at 368.3 93.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 368.3 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 368.3 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00800-0000-4000-8000-000000000800")
		)
		(pin "2"
			(uuid "1ed00801-0000-4000-8000-000000000801")
		)
		(pin "3"
			(uuid "1ed00802-0000-4000-8000-000000000802")
		)
		(pin "4"
			(uuid "1ed00803-0000-4000-8000-000000000803")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D12") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 381 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5000c-0000-4000-8000-00000000000c")
		(property "Reference" "C21"
			(at 383.54 101.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 383.54 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 381 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bd0-0000-4000-8000-000000000bd0")
		)
		(pin "2"
			(uuid "1ed50bd1-0000-4000-8000-000000000bd1")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C21") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 381 100.33) (xy 381 97.79))
		(stroke (width 0) (type default))
		(uuid "1ed5139f-0000-4000-8000-00000000139f")
	)
	(label "+5V_LED"
		(at 381 97.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513a0-0000-4000-8000-0000000013a0")
	)
	(symbol
		(lib_id "power:GND")
		(at 381 107.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b64-0000-4000-8000-000000001b64")
		(property "Reference" "#PWR_L12"
			(at 383.54 110.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 383.54 105.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 381 107.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c2c-0000-4000-8000-000000001c2c")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L12") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 368.3 96.52) (xy 381 96.52))
		(stroke (width 0) (type default))
		(uuid "1ed0179d-0000-4000-8000-00000000179d")
	)
	(wire
		(pts (xy 381 96.52) (xy 381 100.33))
		(stroke (width 0) (type default))
		(uuid "1ed0179e-0000-4000-8000-00000000179e")
	)
	(wire
		(pts (xy 368.3 111.76) (xy 381 111.76))
		(stroke (width 0) (type default))
		(uuid "1ed0179f-0000-4000-8000-00000000179f")
	)
	(wire
		(pts (xy 381 111.76) (xy 381 107.95))
		(stroke (width 0) (type default))
		(uuid "1ed017a0-0000-4000-8000-0000000017a0")
	)
	(wire
		(pts (xy 375.92 104.14) (xy 388.62 104.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b66-0000-4000-8000-000000001b66")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 396.24 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0000d-0000-4000-8000-00000000000d")
		(property "Reference" "D13"
			(at 396.24 93.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 396.24 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 396.24 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00804-0000-4000-8000-000000000804")
		)
		(pin "2"
			(uuid "1ed00805-0000-4000-8000-000000000805")
		)
		(pin "3"
			(uuid "1ed00806-0000-4000-8000-000000000806")
		)
		(pin "4"
			(uuid "1ed00807-0000-4000-8000-000000000807")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D13") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 408.94 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5000d-0000-4000-8000-00000000000d")
		(property "Reference" "C22"
			(at 411.48 101.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 411.48 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 408.94 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bd2-0000-4000-8000-000000000bd2")
		)
		(pin "2"
			(uuid "1ed50bd3-0000-4000-8000-000000000bd3")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C22") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 408.94 100.33) (xy 408.94 97.79))
		(stroke (width 0) (type default))
		(uuid "1ed513a1-0000-4000-8000-0000000013a1")
	)
	(label "+5V_LED"
		(at 408.94 97.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513a2-0000-4000-8000-0000000013a2")
	)
	(symbol
		(lib_id "power:GND")
		(at 408.94 107.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b65-0000-4000-8000-000000001b65")
		(property "Reference" "#PWR_L13"
			(at 411.48 110.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 411.48 105.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 408.94 107.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c2d-0000-4000-8000-000000001c2d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L13") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 396.24 96.52) (xy 408.94 96.52))
		(stroke (width 0) (type default))
		(uuid "1ed017a1-0000-4000-8000-0000000017a1")
	)
	(wire
		(pts (xy 408.94 96.52) (xy 408.94 100.33))
		(stroke (width 0) (type default))
		(uuid "1ed017a2-0000-4000-8000-0000000017a2")
	)
	(wire
		(pts (xy 396.24 111.76) (xy 408.94 111.76))
		(stroke (width 0) (type default))
		(uuid "1ed017a3-0000-4000-8000-0000000017a3")
	)
	(wire
		(pts (xy 408.94 111.76) (xy 408.94 107.95))
		(stroke (width 0) (type default))
		(uuid "1ed017a4-0000-4000-8000-0000000017a4")
	)
	(wire
		(pts (xy 403.86 104.14) (xy 416.56 104.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b67-0000-4000-8000-000000001b67")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 424.18 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0000e-0000-4000-8000-00000000000e")
		(property "Reference" "D14"
			(at 424.18 93.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 424.18 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 424.18 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00808-0000-4000-8000-000000000808")
		)
		(pin "2"
			(uuid "1ed00809-0000-4000-8000-000000000809")
		)
		(pin "3"
			(uuid "1ed0080a-0000-4000-8000-00000000080a")
		)
		(pin "4"
			(uuid "1ed0080b-0000-4000-8000-00000000080b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D14") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 436.88 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5000e-0000-4000-8000-00000000000e")
		(property "Reference" "C23"
			(at 439.42 101.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 439.42 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 436.88 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bd4-0000-4000-8000-000000000bd4")
		)
		(pin "2"
			(uuid "1ed50bd5-0000-4000-8000-000000000bd5")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C23") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 436.88 100.33) (xy 436.88 97.79))
		(stroke (width 0) (type default))
		(uuid "1ed513a3-0000-4000-8000-0000000013a3")
	)
	(label "+5V_LED"
		(at 436.88 97.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513a4-0000-4000-8000-0000000013a4")
	)
	(symbol
		(lib_id "power:GND")
		(at 436.88 107.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b66-0000-4000-8000-000000001b66")
		(property "Reference" "#PWR_L14"
			(at 439.42 110.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 439.42 105.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 436.88 107.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c2e-0000-4000-8000-000000001c2e")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L14") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 424.18 96.52) (xy 436.88 96.52))
		(stroke (width 0) (type default))
		(uuid "1ed017a5-0000-4000-8000-0000000017a5")
	)
	(wire
		(pts (xy 436.88 96.52) (xy 436.88 100.33))
		(stroke (width 0) (type default))
		(uuid "1ed017a6-0000-4000-8000-0000000017a6")
	)
	(wire
		(pts (xy 424.18 111.76) (xy 436.88 111.76))
		(stroke (width 0) (type default))
		(uuid "1ed017a7-0000-4000-8000-0000000017a7")
	)
	(wire
		(pts (xy 436.88 111.76) (xy 436.88 107.95))
		(stroke (width 0) (type default))
		(uuid "1ed017a8-0000-4000-8000-0000000017a8")
	)
	(wire
		(pts (xy 431.8 104.14) (xy 444.5 104.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b68-0000-4000-8000-000000001b68")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 452.12 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0000f-0000-4000-8000-00000000000f")
		(property "Reference" "D15"
			(at 452.12 93.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 452.12 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 452.12 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed0080c-0000-4000-8000-00000000080c")
		)
		(pin "2"
			(uuid "1ed0080d-0000-4000-8000-00000000080d")
		)
		(pin "3"
			(uuid "1ed0080e-0000-4000-8000-00000000080e")
		)
		(pin "4"
			(uuid "1ed0080f-0000-4000-8000-00000000080f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D15") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 464.82 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5000f-0000-4000-8000-00000000000f")
		(property "Reference" "C24"
			(at 467.36 101.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 467.36 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 464.82 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bd6-0000-4000-8000-000000000bd6")
		)
		(pin "2"
			(uuid "1ed50bd7-0000-4000-8000-000000000bd7")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C24") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 464.82 100.33) (xy 464.82 97.79))
		(stroke (width 0) (type default))
		(uuid "1ed513a5-0000-4000-8000-0000000013a5")
	)
	(label "+5V_LED"
		(at 464.82 97.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513a6-0000-4000-8000-0000000013a6")
	)
	(symbol
		(lib_id "power:GND")
		(at 464.82 107.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b67-0000-4000-8000-000000001b67")
		(property "Reference" "#PWR_L15"
			(at 467.36 110.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 467.36 105.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 464.82 107.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c2f-0000-4000-8000-000000001c2f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L15") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 452.12 96.52) (xy 464.82 96.52))
		(stroke (width 0) (type default))
		(uuid "1ed017a9-0000-4000-8000-0000000017a9")
	)
	(wire
		(pts (xy 464.82 96.52) (xy 464.82 100.33))
		(stroke (width 0) (type default))
		(uuid "1ed017aa-0000-4000-8000-0000000017aa")
	)
	(wire
		(pts (xy 452.12 111.76) (xy 464.82 111.76))
		(stroke (width 0) (type default))
		(uuid "1ed017ab-0000-4000-8000-0000000017ab")
	)
	(wire
		(pts (xy 464.82 111.76) (xy 464.82 107.95))
		(stroke (width 0) (type default))
		(uuid "1ed017ac-0000-4000-8000-0000000017ac")
	)
	(wire
		(pts (xy 459.74 104.14) (xy 472.44 104.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b69-0000-4000-8000-000000001b69")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 480.06 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00010-0000-4000-8000-000000000010")
		(property "Reference" "D16"
			(at 480.06 93.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 480.06 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 480.06 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00810-0000-4000-8000-000000000810")
		)
		(pin "2"
			(uuid "1ed00811-0000-4000-8000-000000000811")
		)
		(pin "3"
			(uuid "1ed00812-0000-4000-8000-000000000812")
		)
		(pin "4"
			(uuid "1ed00813-0000-4000-8000-000000000813")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D16") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 492.76 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50010-0000-4000-8000-000000000010")
		(property "Reference" "C25"
			(at 495.3 101.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 495.3 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 492.76 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bd8-0000-4000-8000-000000000bd8")
		)
		(pin "2"
			(uuid "1ed50bd9-0000-4000-8000-000000000bd9")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C25") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 492.76 100.33) (xy 492.76 97.79))
		(stroke (width 0) (type default))
		(uuid "1ed513a7-0000-4000-8000-0000000013a7")
	)
	(label "+5V_LED"
		(at 492.76 97.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513a8-0000-4000-8000-0000000013a8")
	)
	(symbol
		(lib_id "power:GND")
		(at 492.76 107.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b68-0000-4000-8000-000000001b68")
		(property "Reference" "#PWR_L16"
			(at 495.3 110.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 495.3 105.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 492.76 107.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c30-0000-4000-8000-000000001c30")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L16") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 480.06 96.52) (xy 492.76 96.52))
		(stroke (width 0) (type default))
		(uuid "1ed017ad-0000-4000-8000-0000000017ad")
	)
	(wire
		(pts (xy 492.76 96.52) (xy 492.76 100.33))
		(stroke (width 0) (type default))
		(uuid "1ed017ae-0000-4000-8000-0000000017ae")
	)
	(wire
		(pts (xy 480.06 111.76) (xy 492.76 111.76))
		(stroke (width 0) (type default))
		(uuid "1ed017af-0000-4000-8000-0000000017af")
	)
	(wire
		(pts (xy 492.76 111.76) (xy 492.76 107.95))
		(stroke (width 0) (type default))
		(uuid "1ed017b0-0000-4000-8000-0000000017b0")
	)
	(wire
		(pts (xy 487.68 104.14) (xy 500.38 104.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b6a-0000-4000-8000-000000001b6a")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 508 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00011-0000-4000-8000-000000000011")
		(property "Reference" "D17"
			(at 508 93.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 508 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 508 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00814-0000-4000-8000-000000000814")
		)
		(pin "2"
			(uuid "1ed00815-0000-4000-8000-000000000815")
		)
		(pin "3"
			(uuid "1ed00816-0000-4000-8000-000000000816")
		)
		(pin "4"
			(uuid "1ed00817-0000-4000-8000-000000000817")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D17") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 520.7 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50011-0000-4000-8000-000000000011")
		(property "Reference" "C26"
			(at 523.24 101.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 523.24 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 520.7 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bda-0000-4000-8000-000000000bda")
		)
		(pin "2"
			(uuid "1ed50bdb-0000-4000-8000-000000000bdb")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C26") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 520.7 100.33) (xy 520.7 97.79))
		(stroke (width 0) (type default))
		(uuid "1ed513a9-0000-4000-8000-0000000013a9")
	)
	(label "+5V_LED"
		(at 520.7 97.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513aa-0000-4000-8000-0000000013aa")
	)
	(symbol
		(lib_id "power:GND")
		(at 520.7 107.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b69-0000-4000-8000-000000001b69")
		(property "Reference" "#PWR_L17"
			(at 523.24 110.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 523.24 105.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 520.7 107.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c31-0000-4000-8000-000000001c31")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L17") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 508 96.52) (xy 520.7 96.52))
		(stroke (width 0) (type default))
		(uuid "1ed017b1-0000-4000-8000-0000000017b1")
	)
	(wire
		(pts (xy 520.7 96.52) (xy 520.7 100.33))
		(stroke (width 0) (type default))
		(uuid "1ed017b2-0000-4000-8000-0000000017b2")
	)
	(wire
		(pts (xy 508 111.76) (xy 520.7 111.76))
		(stroke (width 0) (type default))
		(uuid "1ed017b3-0000-4000-8000-0000000017b3")
	)
	(wire
		(pts (xy 520.7 111.76) (xy 520.7 107.95))
		(stroke (width 0) (type default))
		(uuid "1ed017b4-0000-4000-8000-0000000017b4")
	)
	(wire
		(pts (xy 515.62 104.14) (xy 528.32 104.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b6b-0000-4000-8000-000000001b6b")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 535.94 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00012-0000-4000-8000-000000000012")
		(property "Reference" "D18"
			(at 535.94 93.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 535.94 114.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 535.94 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00818-0000-4000-8000-000000000818")
		)
		(pin "2"
			(uuid "1ed00819-0000-4000-8000-000000000819")
		)
		(pin "3"
			(uuid "1ed0081a-0000-4000-8000-00000000081a")
		)
		(pin "4"
			(uuid "1ed0081b-0000-4000-8000-00000000081b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D18") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 548.64 104.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50012-0000-4000-8000-000000000012")
		(property "Reference" "C27"
			(at 551.18 101.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 551.18 106.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 548.64 104.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bdc-0000-4000-8000-000000000bdc")
		)
		(pin "2"
			(uuid "1ed50bdd-0000-4000-8000-000000000bdd")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C27") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 548.64 100.33) (xy 548.64 97.79))
		(stroke (width 0) (type default))
		(uuid "1ed513ab-0000-4000-8000-0000000013ab")
	)
	(label "+5V_LED"
		(at 548.64 97.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513ac-0000-4000-8000-0000000013ac")
	)
	(symbol
		(lib_id "power:GND")
		(at 548.64 107.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b6a-0000-4000-8000-000000001b6a")
		(property "Reference" "#PWR_L18"
			(at 551.18 110.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 551.18 105.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 548.64 107.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c32-0000-4000-8000-000000001c32")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L18") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 535.94 96.52) (xy 548.64 96.52))
		(stroke (width 0) (type default))
		(uuid "1ed017b5-0000-4000-8000-0000000017b5")
	)
	(wire
		(pts (xy 548.64 96.52) (xy 548.64 100.33))
		(stroke (width 0) (type default))
		(uuid "1ed017b6-0000-4000-8000-0000000017b6")
	)
	(wire
		(pts (xy 535.94 111.76) (xy 548.64 111.76))
		(stroke (width 0) (type default))
		(uuid "1ed017b7-0000-4000-8000-0000000017b7")
	)
	(wire
		(pts (xy 548.64 111.76) (xy 548.64 107.95))
		(stroke (width 0) (type default))
		(uuid "1ed017b8-0000-4000-8000-0000000017b8")
	)
	(label "L18"
		(at 543.56 104.14 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed01b6c-0000-4000-8000-000000001b6c")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 312.42 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00013-0000-4000-8000-000000000013")
		(property "Reference" "D19"
			(at 312.42 119.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 312.42 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 312.42 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed0081c-0000-4000-8000-00000000081c")
		)
		(pin "2"
			(uuid "1ed0081d-0000-4000-8000-00000000081d")
		)
		(pin "3"
			(uuid "1ed0081e-0000-4000-8000-00000000081e")
		)
		(pin "4"
			(uuid "1ed0081f-0000-4000-8000-00000000081f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D19") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 325.12 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50013-0000-4000-8000-000000000013")
		(property "Reference" "C28"
			(at 327.66 127 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 327.66 132.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 325.12 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bde-0000-4000-8000-000000000bde")
		)
		(pin "2"
			(uuid "1ed50bdf-0000-4000-8000-000000000bdf")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C28") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 325.12 125.73) (xy 325.12 123.19))
		(stroke (width 0) (type default))
		(uuid "1ed513ad-0000-4000-8000-0000000013ad")
	)
	(label "+5V_LED"
		(at 325.12 123.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513ae-0000-4000-8000-0000000013ae")
	)
	(symbol
		(lib_id "power:GND")
		(at 325.12 133.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b6b-0000-4000-8000-000000001b6b")
		(property "Reference" "#PWR_L19"
			(at 327.66 135.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 327.66 130.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 325.12 133.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c33-0000-4000-8000-000000001c33")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L19") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 312.42 121.92) (xy 325.12 121.92))
		(stroke (width 0) (type default))
		(uuid "1ed017b9-0000-4000-8000-0000000017b9")
	)
	(wire
		(pts (xy 325.12 121.92) (xy 325.12 125.73))
		(stroke (width 0) (type default))
		(uuid "1ed017ba-0000-4000-8000-0000000017ba")
	)
	(wire
		(pts (xy 312.42 137.16) (xy 325.12 137.16))
		(stroke (width 0) (type default))
		(uuid "1ed017bb-0000-4000-8000-0000000017bb")
	)
	(wire
		(pts (xy 325.12 137.16) (xy 325.12 133.35))
		(stroke (width 0) (type default))
		(uuid "1ed017bc-0000-4000-8000-0000000017bc")
	)
	(label "L18"
		(at 304.8 129.54 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "1ed01b6d-0000-4000-8000-000000001b6d")
	)
	(wire
		(pts (xy 320.04 129.54) (xy 332.74 129.54))
		(stroke (width 0) (type default))
		(uuid "1ed01b6e-0000-4000-8000-000000001b6e")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 340.36 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00014-0000-4000-8000-000000000014")
		(property "Reference" "D20"
			(at 340.36 119.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 340.36 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 340.36 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00820-0000-4000-8000-000000000820")
		)
		(pin "2"
			(uuid "1ed00821-0000-4000-8000-000000000821")
		)
		(pin "3"
			(uuid "1ed00822-0000-4000-8000-000000000822")
		)
		(pin "4"
			(uuid "1ed00823-0000-4000-8000-000000000823")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D20") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 353.06 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50014-0000-4000-8000-000000000014")
		(property "Reference" "C29"
			(at 355.6 127 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 355.6 132.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 353.06 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50be0-0000-4000-8000-000000000be0")
		)
		(pin "2"
			(uuid "1ed50be1-0000-4000-8000-000000000be1")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C29") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 353.06 125.73) (xy 353.06 123.19))
		(stroke (width 0) (type default))
		(uuid "1ed513af-0000-4000-8000-0000000013af")
	)
	(label "+5V_LED"
		(at 353.06 123.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513b0-0000-4000-8000-0000000013b0")
	)
	(symbol
		(lib_id "power:GND")
		(at 353.06 133.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b6c-0000-4000-8000-000000001b6c")
		(property "Reference" "#PWR_L20"
			(at 355.6 135.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 355.6 130.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 353.06 133.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c34-0000-4000-8000-000000001c34")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L20") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 340.36 121.92) (xy 353.06 121.92))
		(stroke (width 0) (type default))
		(uuid "1ed017bd-0000-4000-8000-0000000017bd")
	)
	(wire
		(pts (xy 353.06 121.92) (xy 353.06 125.73))
		(stroke (width 0) (type default))
		(uuid "1ed017be-0000-4000-8000-0000000017be")
	)
	(wire
		(pts (xy 340.36 137.16) (xy 353.06 137.16))
		(stroke (width 0) (type default))
		(uuid "1ed017bf-0000-4000-8000-0000000017bf")
	)
	(wire
		(pts (xy 353.06 137.16) (xy 353.06 133.35))
		(stroke (width 0) (type default))
		(uuid "1ed017c0-0000-4000-8000-0000000017c0")
	)
	(wire
		(pts (xy 347.98 129.54) (xy 360.68 129.54))
		(stroke (width 0) (type default))
		(uuid "1ed01b6f-0000-4000-8000-000000001b6f")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 368.3 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00015-0000-4000-8000-000000000015")
		(property "Reference" "D21"
			(at 368.3 119.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 368.3 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 368.3 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00824-0000-4000-8000-000000000824")
		)
		(pin "2"
			(uuid "1ed00825-0000-4000-8000-000000000825")
		)
		(pin "3"
			(uuid "1ed00826-0000-4000-8000-000000000826")
		)
		(pin "4"
			(uuid "1ed00827-0000-4000-8000-000000000827")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D21") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 381 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50015-0000-4000-8000-000000000015")
		(property "Reference" "C30"
			(at 383.54 127 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 383.54 132.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 381 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50be2-0000-4000-8000-000000000be2")
		)
		(pin "2"
			(uuid "1ed50be3-0000-4000-8000-000000000be3")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C30") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 381 125.73) (xy 381 123.19))
		(stroke (width 0) (type default))
		(uuid "1ed513b1-0000-4000-8000-0000000013b1")
	)
	(label "+5V_LED"
		(at 381 123.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513b2-0000-4000-8000-0000000013b2")
	)
	(symbol
		(lib_id "power:GND")
		(at 381 133.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b6d-0000-4000-8000-000000001b6d")
		(property "Reference" "#PWR_L21"
			(at 383.54 135.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 383.54 130.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 381 133.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c35-0000-4000-8000-000000001c35")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L21") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 368.3 121.92) (xy 381 121.92))
		(stroke (width 0) (type default))
		(uuid "1ed017c1-0000-4000-8000-0000000017c1")
	)
	(wire
		(pts (xy 381 121.92) (xy 381 125.73))
		(stroke (width 0) (type default))
		(uuid "1ed017c2-0000-4000-8000-0000000017c2")
	)
	(wire
		(pts (xy 368.3 137.16) (xy 381 137.16))
		(stroke (width 0) (type default))
		(uuid "1ed017c3-0000-4000-8000-0000000017c3")
	)
	(wire
		(pts (xy 381 137.16) (xy 381 133.35))
		(stroke (width 0) (type default))
		(uuid "1ed017c4-0000-4000-8000-0000000017c4")
	)
	(wire
		(pts (xy 375.92 129.54) (xy 388.62 129.54))
		(stroke (width 0) (type default))
		(uuid "1ed01b70-0000-4000-8000-000000001b70")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 396.24 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00016-0000-4000-8000-000000000016")
		(property "Reference" "D22"
			(at 396.24 119.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 396.24 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 396.24 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00828-0000-4000-8000-000000000828")
		)
		(pin "2"
			(uuid "1ed00829-0000-4000-8000-000000000829")
		)
		(pin "3"
			(uuid "1ed0082a-0000-4000-8000-00000000082a")
		)
		(pin "4"
			(uuid "1ed0082b-0000-4000-8000-00000000082b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D22") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 408.94 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50016-0000-4000-8000-000000000016")
		(property "Reference" "C31"
			(at 411.48 127 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 411.48 132.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 408.94 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50be4-0000-4000-8000-000000000be4")
		)
		(pin "2"
			(uuid "1ed50be5-0000-4000-8000-000000000be5")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C31") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 408.94 125.73) (xy 408.94 123.19))
		(stroke (width 0) (type default))
		(uuid "1ed513b3-0000-4000-8000-0000000013b3")
	)
	(label "+5V_LED"
		(at 408.94 123.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513b4-0000-4000-8000-0000000013b4")
	)
	(symbol
		(lib_id "power:GND")
		(at 408.94 133.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b6e-0000-4000-8000-000000001b6e")
		(property "Reference" "#PWR_L22"
			(at 411.48 135.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 411.48 130.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 408.94 133.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c36-0000-4000-8000-000000001c36")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L22") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 396.24 121.92) (xy 408.94 121.92))
		(stroke (width 0) (type default))
		(uuid "1ed017c5-0000-4000-8000-0000000017c5")
	)
	(wire
		(pts (xy 408.94 121.92) (xy 408.94 125.73))
		(stroke (width 0) (type default))
		(uuid "1ed017c6-0000-4000-8000-0000000017c6")
	)
	(wire
		(pts (xy 396.24 137.16) (xy 408.94 137.16))
		(stroke (width 0) (type default))
		(uuid "1ed017c7-0000-4000-8000-0000000017c7")
	)
	(wire
		(pts (xy 408.94 137.16) (xy 408.94 133.35))
		(stroke (width 0) (type default))
		(uuid "1ed017c8-0000-4000-8000-0000000017c8")
	)
	(wire
		(pts (xy 403.86 129.54) (xy 416.56 129.54))
		(stroke (width 0) (type default))
		(uuid "1ed01b71-0000-4000-8000-000000001b71")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 424.18 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00017-0000-4000-8000-000000000017")
		(property "Reference" "D23"
			(at 424.18 119.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 424.18 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 424.18 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed0082c-0000-4000-8000-00000000082c")
		)
		(pin "2"
			(uuid "1ed0082d-0000-4000-8000-00000000082d")
		)
		(pin "3"
			(uuid "1ed0082e-0000-4000-8000-00000000082e")
		)
		(pin "4"
			(uuid "1ed0082f-0000-4000-8000-00000000082f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D23") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 436.88 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50017-0000-4000-8000-000000000017")
		(property "Reference" "C32"
			(at 439.42 127 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 439.42 132.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 436.88 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50be6-0000-4000-8000-000000000be6")
		)
		(pin "2"
			(uuid "1ed50be7-0000-4000-8000-000000000be7")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C32") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 436.88 125.73) (xy 436.88 123.19))
		(stroke (width 0) (type default))
		(uuid "1ed513b5-0000-4000-8000-0000000013b5")
	)
	(label "+5V_LED"
		(at 436.88 123.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513b6-0000-4000-8000-0000000013b6")
	)
	(symbol
		(lib_id "power:GND")
		(at 436.88 133.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b6f-0000-4000-8000-000000001b6f")
		(property "Reference" "#PWR_L23"
			(at 439.42 135.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 439.42 130.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 436.88 133.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c37-0000-4000-8000-000000001c37")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L23") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 424.18 121.92) (xy 436.88 121.92))
		(stroke (width 0) (type default))
		(uuid "1ed017c9-0000-4000-8000-0000000017c9")
	)
	(wire
		(pts (xy 436.88 121.92) (xy 436.88 125.73))
		(stroke (width 0) (type default))
		(uuid "1ed017ca-0000-4000-8000-0000000017ca")
	)
	(wire
		(pts (xy 424.18 137.16) (xy 436.88 137.16))
		(stroke (width 0) (type default))
		(uuid "1ed017cb-0000-4000-8000-0000000017cb")
	)
	(wire
		(pts (xy 436.88 137.16) (xy 436.88 133.35))
		(stroke (width 0) (type default))
		(uuid "1ed017cc-0000-4000-8000-0000000017cc")
	)
	(wire
		(pts (xy 431.8 129.54) (xy 444.5 129.54))
		(stroke (width 0) (type default))
		(uuid "1ed01b72-0000-4000-8000-000000001b72")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 452.12 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00018-0000-4000-8000-000000000018")
		(property "Reference" "D24"
			(at 452.12 119.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 452.12 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 452.12 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00830-0000-4000-8000-000000000830")
		)
		(pin "2"
			(uuid "1ed00831-0000-4000-8000-000000000831")
		)
		(pin "3"
			(uuid "1ed00832-0000-4000-8000-000000000832")
		)
		(pin "4"
			(uuid "1ed00833-0000-4000-8000-000000000833")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D24") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 464.82 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50018-0000-4000-8000-000000000018")
		(property "Reference" "C33"
			(at 467.36 127 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 467.36 132.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 464.82 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50be8-0000-4000-8000-000000000be8")
		)
		(pin "2"
			(uuid "1ed50be9-0000-4000-8000-000000000be9")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C33") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 464.82 125.73) (xy 464.82 123.19))
		(stroke (width 0) (type default))
		(uuid "1ed513b7-0000-4000-8000-0000000013b7")
	)
	(label "+5V_LED"
		(at 464.82 123.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513b8-0000-4000-8000-0000000013b8")
	)
	(symbol
		(lib_id "power:GND")
		(at 464.82 133.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b70-0000-4000-8000-000000001b70")
		(property "Reference" "#PWR_L24"
			(at 467.36 135.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 467.36 130.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 464.82 133.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c38-0000-4000-8000-000000001c38")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L24") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 452.12 121.92) (xy 464.82 121.92))
		(stroke (width 0) (type default))
		(uuid "1ed017cd-0000-4000-8000-0000000017cd")
	)
	(wire
		(pts (xy 464.82 121.92) (xy 464.82 125.73))
		(stroke (width 0) (type default))
		(uuid "1ed017ce-0000-4000-8000-0000000017ce")
	)
	(wire
		(pts (xy 452.12 137.16) (xy 464.82 137.16))
		(stroke (width 0) (type default))
		(uuid "1ed017cf-0000-4000-8000-0000000017cf")
	)
	(wire
		(pts (xy 464.82 137.16) (xy 464.82 133.35))
		(stroke (width 0) (type default))
		(uuid "1ed017d0-0000-4000-8000-0000000017d0")
	)
	(wire
		(pts (xy 459.74 129.54) (xy 472.44 129.54))
		(stroke (width 0) (type default))
		(uuid "1ed01b73-0000-4000-8000-000000001b73")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 480.06 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00019-0000-4000-8000-000000000019")
		(property "Reference" "D25"
			(at 480.06 119.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 480.06 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 480.06 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00834-0000-4000-8000-000000000834")
		)
		(pin "2"
			(uuid "1ed00835-0000-4000-8000-000000000835")
		)
		(pin "3"
			(uuid "1ed00836-0000-4000-8000-000000000836")
		)
		(pin "4"
			(uuid "1ed00837-0000-4000-8000-000000000837")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D25") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 492.76 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50019-0000-4000-8000-000000000019")
		(property "Reference" "C34"
			(at 495.3 127 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 495.3 132.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 492.76 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bea-0000-4000-8000-000000000bea")
		)
		(pin "2"
			(uuid "1ed50beb-0000-4000-8000-000000000beb")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C34") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 492.76 125.73) (xy 492.76 123.19))
		(stroke (width 0) (type default))
		(uuid "1ed513b9-0000-4000-8000-0000000013b9")
	)
	(label "+5V_LED"
		(at 492.76 123.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513ba-0000-4000-8000-0000000013ba")
	)
	(symbol
		(lib_id "power:GND")
		(at 492.76 133.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b71-0000-4000-8000-000000001b71")
		(property "Reference" "#PWR_L25"
			(at 495.3 135.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 495.3 130.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 492.76 133.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c39-0000-4000-8000-000000001c39")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L25") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 480.06 121.92) (xy 492.76 121.92))
		(stroke (width 0) (type default))
		(uuid "1ed017d1-0000-4000-8000-0000000017d1")
	)
	(wire
		(pts (xy 492.76 121.92) (xy 492.76 125.73))
		(stroke (width 0) (type default))
		(uuid "1ed017d2-0000-4000-8000-0000000017d2")
	)
	(wire
		(pts (xy 480.06 137.16) (xy 492.76 137.16))
		(stroke (width 0) (type default))
		(uuid "1ed017d3-0000-4000-8000-0000000017d3")
	)
	(wire
		(pts (xy 492.76 137.16) (xy 492.76 133.35))
		(stroke (width 0) (type default))
		(uuid "1ed017d4-0000-4000-8000-0000000017d4")
	)
	(wire
		(pts (xy 487.68 129.54) (xy 500.38 129.54))
		(stroke (width 0) (type default))
		(uuid "1ed01b74-0000-4000-8000-000000001b74")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 508 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0001a-0000-4000-8000-00000000001a")
		(property "Reference" "D26"
			(at 508 119.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 508 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 508 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00838-0000-4000-8000-000000000838")
		)
		(pin "2"
			(uuid "1ed00839-0000-4000-8000-000000000839")
		)
		(pin "3"
			(uuid "1ed0083a-0000-4000-8000-00000000083a")
		)
		(pin "4"
			(uuid "1ed0083b-0000-4000-8000-00000000083b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D26") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 520.7 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5001a-0000-4000-8000-00000000001a")
		(property "Reference" "C35"
			(at 523.24 127 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 523.24 132.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 520.7 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bec-0000-4000-8000-000000000bec")
		)
		(pin "2"
			(uuid "1ed50bed-0000-4000-8000-000000000bed")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C35") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 520.7 125.73) (xy 520.7 123.19))
		(stroke (width 0) (type default))
		(uuid "1ed513bb-0000-4000-8000-0000000013bb")
	)
	(label "+5V_LED"
		(at 520.7 123.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513bc-0000-4000-8000-0000000013bc")
	)
	(symbol
		(lib_id "power:GND")
		(at 520.7 133.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b72-0000-4000-8000-000000001b72")
		(property "Reference" "#PWR_L26"
			(at 523.24 135.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 523.24 130.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 520.7 133.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c3a-0000-4000-8000-000000001c3a")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L26") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 508 121.92) (xy 520.7 121.92))
		(stroke (width 0) (type default))
		(uuid "1ed017d5-0000-4000-8000-0000000017d5")
	)
	(wire
		(pts (xy 520.7 121.92) (xy 520.7 125.73))
		(stroke (width 0) (type default))
		(uuid "1ed017d6-0000-4000-8000-0000000017d6")
	)
	(wire
		(pts (xy 508 137.16) (xy 520.7 137.16))
		(stroke (width 0) (type default))
		(uuid "1ed017d7-0000-4000-8000-0000000017d7")
	)
	(wire
		(pts (xy 520.7 137.16) (xy 520.7 133.35))
		(stroke (width 0) (type default))
		(uuid "1ed017d8-0000-4000-8000-0000000017d8")
	)
	(wire
		(pts (xy 515.62 129.54) (xy 528.32 129.54))
		(stroke (width 0) (type default))
		(uuid "1ed01b75-0000-4000-8000-000000001b75")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 535.94 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0001b-0000-4000-8000-00000000001b")
		(property "Reference" "D27"
			(at 535.94 119.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 535.94 139.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 535.94 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed0083c-0000-4000-8000-00000000083c")
		)
		(pin "2"
			(uuid "1ed0083d-0000-4000-8000-00000000083d")
		)
		(pin "3"
			(uuid "1ed0083e-0000-4000-8000-00000000083e")
		)
		(pin "4"
			(uuid "1ed0083f-0000-4000-8000-00000000083f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D27") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 548.64 129.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5001b-0000-4000-8000-00000000001b")
		(property "Reference" "C36"
			(at 551.18 127 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 551.18 132.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 548.64 129.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bee-0000-4000-8000-000000000bee")
		)
		(pin "2"
			(uuid "1ed50bef-0000-4000-8000-000000000bef")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C36") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 548.64 125.73) (xy 548.64 123.19))
		(stroke (width 0) (type default))
		(uuid "1ed513bd-0000-4000-8000-0000000013bd")
	)
	(label "+5V_LED"
		(at 548.64 123.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513be-0000-4000-8000-0000000013be")
	)
	(symbol
		(lib_id "power:GND")
		(at 548.64 133.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b73-0000-4000-8000-000000001b73")
		(property "Reference" "#PWR_L27"
			(at 551.18 135.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 551.18 130.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 548.64 133.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c3b-0000-4000-8000-000000001c3b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L27") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 535.94 121.92) (xy 548.64 121.92))
		(stroke (width 0) (type default))
		(uuid "1ed017d9-0000-4000-8000-0000000017d9")
	)
	(wire
		(pts (xy 548.64 121.92) (xy 548.64 125.73))
		(stroke (width 0) (type default))
		(uuid "1ed017da-0000-4000-8000-0000000017da")
	)
	(wire
		(pts (xy 535.94 137.16) (xy 548.64 137.16))
		(stroke (width 0) (type default))
		(uuid "1ed017db-0000-4000-8000-0000000017db")
	)
	(wire
		(pts (xy 548.64 137.16) (xy 548.64 133.35))
		(stroke (width 0) (type default))
		(uuid "1ed017dc-0000-4000-8000-0000000017dc")
	)
	(label "L27"
		(at 543.56 129.54 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed01b76-0000-4000-8000-000000001b76")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 312.42 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0001c-0000-4000-8000-00000000001c")
		(property "Reference" "D28"
			(at 312.42 144.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 312.42 165.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 312.42 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00840-0000-4000-8000-000000000840")
		)
		(pin "2"
			(uuid "1ed00841-0000-4000-8000-000000000841")
		)
		(pin "3"
			(uuid "1ed00842-0000-4000-8000-000000000842")
		)
		(pin "4"
			(uuid "1ed00843-0000-4000-8000-000000000843")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D28") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 325.12 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5001c-0000-4000-8000-00000000001c")
		(property "Reference" "C37"
			(at 327.66 152.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 327.66 157.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 325.12 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bf0-0000-4000-8000-000000000bf0")
		)
		(pin "2"
			(uuid "1ed50bf1-0000-4000-8000-000000000bf1")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C37") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 325.12 151.13) (xy 325.12 148.59))
		(stroke (width 0) (type default))
		(uuid "1ed513bf-0000-4000-8000-0000000013bf")
	)
	(label "+5V_LED"
		(at 325.12 148.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513c0-0000-4000-8000-0000000013c0")
	)
	(symbol
		(lib_id "power:GND")
		(at 325.12 158.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b74-0000-4000-8000-000000001b74")
		(property "Reference" "#PWR_L28"
			(at 327.66 161.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 327.66 156.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 325.12 158.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c3c-0000-4000-8000-000000001c3c")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L28") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 312.42 147.32) (xy 325.12 147.32))
		(stroke (width 0) (type default))
		(uuid "1ed017dd-0000-4000-8000-0000000017dd")
	)
	(wire
		(pts (xy 325.12 147.32) (xy 325.12 151.13))
		(stroke (width 0) (type default))
		(uuid "1ed017de-0000-4000-8000-0000000017de")
	)
	(wire
		(pts (xy 312.42 162.56) (xy 325.12 162.56))
		(stroke (width 0) (type default))
		(uuid "1ed017df-0000-4000-8000-0000000017df")
	)
	(wire
		(pts (xy 325.12 162.56) (xy 325.12 158.75))
		(stroke (width 0) (type default))
		(uuid "1ed017e0-0000-4000-8000-0000000017e0")
	)
	(label "L27"
		(at 304.8 154.94 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "1ed01b77-0000-4000-8000-000000001b77")
	)
	(wire
		(pts (xy 320.04 154.94) (xy 332.74 154.94))
		(stroke (width 0) (type default))
		(uuid "1ed01b78-0000-4000-8000-000000001b78")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 340.36 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0001d-0000-4000-8000-00000000001d")
		(property "Reference" "D29"
			(at 340.36 144.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 340.36 165.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 340.36 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00844-0000-4000-8000-000000000844")
		)
		(pin "2"
			(uuid "1ed00845-0000-4000-8000-000000000845")
		)
		(pin "3"
			(uuid "1ed00846-0000-4000-8000-000000000846")
		)
		(pin "4"
			(uuid "1ed00847-0000-4000-8000-000000000847")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D29") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 353.06 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5001d-0000-4000-8000-00000000001d")
		(property "Reference" "C38"
			(at 355.6 152.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 355.6 157.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 353.06 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bf2-0000-4000-8000-000000000bf2")
		)
		(pin "2"
			(uuid "1ed50bf3-0000-4000-8000-000000000bf3")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C38") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 353.06 151.13) (xy 353.06 148.59))
		(stroke (width 0) (type default))
		(uuid "1ed513c1-0000-4000-8000-0000000013c1")
	)
	(label "+5V_LED"
		(at 353.06 148.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513c2-0000-4000-8000-0000000013c2")
	)
	(symbol
		(lib_id "power:GND")
		(at 353.06 158.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b75-0000-4000-8000-000000001b75")
		(property "Reference" "#PWR_L29"
			(at 355.6 161.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 355.6 156.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 353.06 158.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c3d-0000-4000-8000-000000001c3d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L29") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 340.36 147.32) (xy 353.06 147.32))
		(stroke (width 0) (type default))
		(uuid "1ed017e1-0000-4000-8000-0000000017e1")
	)
	(wire
		(pts (xy 353.06 147.32) (xy 353.06 151.13))
		(stroke (width 0) (type default))
		(uuid "1ed017e2-0000-4000-8000-0000000017e2")
	)
	(wire
		(pts (xy 340.36 162.56) (xy 353.06 162.56))
		(stroke (width 0) (type default))
		(uuid "1ed017e3-0000-4000-8000-0000000017e3")
	)
	(wire
		(pts (xy 353.06 162.56) (xy 353.06 158.75))
		(stroke (width 0) (type default))
		(uuid "1ed017e4-0000-4000-8000-0000000017e4")
	)
	(wire
		(pts (xy 347.98 154.94) (xy 360.68 154.94))
		(stroke (width 0) (type default))
		(uuid "1ed01b79-0000-4000-8000-000000001b79")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 368.3 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0001e-0000-4000-8000-00000000001e")
		(property "Reference" "D30"
			(at 368.3 144.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 368.3 165.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 368.3 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00848-0000-4000-8000-000000000848")
		)
		(pin "2"
			(uuid "1ed00849-0000-4000-8000-000000000849")
		)
		(pin "3"
			(uuid "1ed0084a-0000-4000-8000-00000000084a")
		)
		(pin "4"
			(uuid "1ed0084b-0000-4000-8000-00000000084b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D30") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 381 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5001e-0000-4000-8000-00000000001e")
		(property "Reference" "C39"
			(at 383.54 152.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 383.54 157.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 381 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bf4-0000-4000-8000-000000000bf4")
		)
		(pin "2"
			(uuid "1ed50bf5-0000-4000-8000-000000000bf5")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C39") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 381 151.13) (xy 381 148.59))
		(stroke (width 0) (type default))
		(uuid "1ed513c3-0000-4000-8000-0000000013c3")
	)
	(label "+5V_LED"
		(at 381 148.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513c4-0000-4000-8000-0000000013c4")
	)
	(symbol
		(lib_id "power:GND")
		(at 381 158.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b76-0000-4000-8000-000000001b76")
		(property "Reference" "#PWR_L30"
			(at 383.54 161.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 383.54 156.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 381 158.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c3e-0000-4000-8000-000000001c3e")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L30") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 368.3 147.32) (xy 381 147.32))
		(stroke (width 0) (type default))
		(uuid "1ed017e5-0000-4000-8000-0000000017e5")
	)
	(wire
		(pts (xy 381 147.32) (xy 381 151.13))
		(stroke (width 0) (type default))
		(uuid "1ed017e6-0000-4000-8000-0000000017e6")
	)
	(wire
		(pts (xy 368.3 162.56) (xy 381 162.56))
		(stroke (width 0) (type default))
		(uuid "1ed017e7-0000-4000-8000-0000000017e7")
	)
	(wire
		(pts (xy 381 162.56) (xy 381 158.75))
		(stroke (width 0) (type default))
		(uuid "1ed017e8-0000-4000-8000-0000000017e8")
	)
	(wire
		(pts (xy 375.92 154.94) (xy 388.62 154.94))
		(stroke (width 0) (type default))
		(uuid "1ed01b7a-0000-4000-8000-000000001b7a")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 396.24 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0001f-0000-4000-8000-00000000001f")
		(property "Reference" "D31"
			(at 396.24 144.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 396.24 165.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 396.24 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed0084c-0000-4000-8000-00000000084c")
		)
		(pin "2"
			(uuid "1ed0084d-0000-4000-8000-00000000084d")
		)
		(pin "3"
			(uuid "1ed0084e-0000-4000-8000-00000000084e")
		)
		(pin "4"
			(uuid "1ed0084f-0000-4000-8000-00000000084f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D31") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 408.94 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5001f-0000-4000-8000-00000000001f")
		(property "Reference" "C40"
			(at 411.48 152.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 411.48 157.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 408.94 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bf6-0000-4000-8000-000000000bf6")
		)
		(pin "2"
			(uuid "1ed50bf7-0000-4000-8000-000000000bf7")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C40") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 408.94 151.13) (xy 408.94 148.59))
		(stroke (width 0) (type default))
		(uuid "1ed513c5-0000-4000-8000-0000000013c5")
	)
	(label "+5V_LED"
		(at 408.94 148.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513c6-0000-4000-8000-0000000013c6")
	)
	(symbol
		(lib_id "power:GND")
		(at 408.94 158.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b77-0000-4000-8000-000000001b77")
		(property "Reference" "#PWR_L31"
			(at 411.48 161.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 411.48 156.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 408.94 158.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c3f-0000-4000-8000-000000001c3f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L31") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 396.24 147.32) (xy 408.94 147.32))
		(stroke (width 0) (type default))
		(uuid "1ed017e9-0000-4000-8000-0000000017e9")
	)
	(wire
		(pts (xy 408.94 147.32) (xy 408.94 151.13))
		(stroke (width 0) (type default))
		(uuid "1ed017ea-0000-4000-8000-0000000017ea")
	)
	(wire
		(pts (xy 396.24 162.56) (xy 408.94 162.56))
		(stroke (width 0) (type default))
		(uuid "1ed017eb-0000-4000-8000-0000000017eb")
	)
	(wire
		(pts (xy 408.94 162.56) (xy 408.94 158.75))
		(stroke (width 0) (type default))
		(uuid "1ed017ec-0000-4000-8000-0000000017ec")
	)
	(wire
		(pts (xy 403.86 154.94) (xy 416.56 154.94))
		(stroke (width 0) (type default))
		(uuid "1ed01b7b-0000-4000-8000-000000001b7b")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 424.18 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00020-0000-4000-8000-000000000020")
		(property "Reference" "D32"
			(at 424.18 144.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 424.18 165.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 424.18 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00850-0000-4000-8000-000000000850")
		)
		(pin "2"
			(uuid "1ed00851-0000-4000-8000-000000000851")
		)
		(pin "3"
			(uuid "1ed00852-0000-4000-8000-000000000852")
		)
		(pin "4"
			(uuid "1ed00853-0000-4000-8000-000000000853")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D32") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 436.88 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50020-0000-4000-8000-000000000020")
		(property "Reference" "C41"
			(at 439.42 152.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 439.42 157.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 436.88 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bf8-0000-4000-8000-000000000bf8")
		)
		(pin "2"
			(uuid "1ed50bf9-0000-4000-8000-000000000bf9")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C41") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 436.88 151.13) (xy 436.88 148.59))
		(stroke (width 0) (type default))
		(uuid "1ed513c7-0000-4000-8000-0000000013c7")
	)
	(label "+5V_LED"
		(at 436.88 148.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513c8-0000-4000-8000-0000000013c8")
	)
	(symbol
		(lib_id "power:GND")
		(at 436.88 158.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b78-0000-4000-8000-000000001b78")
		(property "Reference" "#PWR_L32"
			(at 439.42 161.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 439.42 156.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 436.88 158.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c40-0000-4000-8000-000000001c40")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L32") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 424.18 147.32) (xy 436.88 147.32))
		(stroke (width 0) (type default))
		(uuid "1ed017ed-0000-4000-8000-0000000017ed")
	)
	(wire
		(pts (xy 436.88 147.32) (xy 436.88 151.13))
		(stroke (width 0) (type default))
		(uuid "1ed017ee-0000-4000-8000-0000000017ee")
	)
	(wire
		(pts (xy 424.18 162.56) (xy 436.88 162.56))
		(stroke (width 0) (type default))
		(uuid "1ed017ef-0000-4000-8000-0000000017ef")
	)
	(wire
		(pts (xy 436.88 162.56) (xy 436.88 158.75))
		(stroke (width 0) (type default))
		(uuid "1ed017f0-0000-4000-8000-0000000017f0")
	)
	(wire
		(pts (xy 431.8 154.94) (xy 444.5 154.94))
		(stroke (width 0) (type default))
		(uuid "1ed01b7c-0000-4000-8000-000000001b7c")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 452.12 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00021-0000-4000-8000-000000000021")
		(property "Reference" "D33"
			(at 452.12 144.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 452.12 165.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 452.12 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00854-0000-4000-8000-000000000854")
		)
		(pin "2"
			(uuid "1ed00855-0000-4000-8000-000000000855")
		)
		(pin "3"
			(uuid "1ed00856-0000-4000-8000-000000000856")
		)
		(pin "4"
			(uuid "1ed00857-0000-4000-8000-000000000857")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D33") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 464.82 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50021-0000-4000-8000-000000000021")
		(property "Reference" "C42"
			(at 467.36 152.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 467.36 157.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 464.82 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bfa-0000-4000-8000-000000000bfa")
		)
		(pin "2"
			(uuid "1ed50bfb-0000-4000-8000-000000000bfb")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C42") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 464.82 151.13) (xy 464.82 148.59))
		(stroke (width 0) (type default))
		(uuid "1ed513c9-0000-4000-8000-0000000013c9")
	)
	(label "+5V_LED"
		(at 464.82 148.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513ca-0000-4000-8000-0000000013ca")
	)
	(symbol
		(lib_id "power:GND")
		(at 464.82 158.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b79-0000-4000-8000-000000001b79")
		(property "Reference" "#PWR_L33"
			(at 467.36 161.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 467.36 156.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 464.82 158.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c41-0000-4000-8000-000000001c41")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L33") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 452.12 147.32) (xy 464.82 147.32))
		(stroke (width 0) (type default))
		(uuid "1ed017f1-0000-4000-8000-0000000017f1")
	)
	(wire
		(pts (xy 464.82 147.32) (xy 464.82 151.13))
		(stroke (width 0) (type default))
		(uuid "1ed017f2-0000-4000-8000-0000000017f2")
	)
	(wire
		(pts (xy 452.12 162.56) (xy 464.82 162.56))
		(stroke (width 0) (type default))
		(uuid "1ed017f3-0000-4000-8000-0000000017f3")
	)
	(wire
		(pts (xy 464.82 162.56) (xy 464.82 158.75))
		(stroke (width 0) (type default))
		(uuid "1ed017f4-0000-4000-8000-0000000017f4")
	)
	(wire
		(pts (xy 459.74 154.94) (xy 472.44 154.94))
		(stroke (width 0) (type default))
		(uuid "1ed01b7d-0000-4000-8000-000000001b7d")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 480.06 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00022-0000-4000-8000-000000000022")
		(property "Reference" "D34"
			(at 480.06 144.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 480.06 165.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 480.06 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00858-0000-4000-8000-000000000858")
		)
		(pin "2"
			(uuid "1ed00859-0000-4000-8000-000000000859")
		)
		(pin "3"
			(uuid "1ed0085a-0000-4000-8000-00000000085a")
		)
		(pin "4"
			(uuid "1ed0085b-0000-4000-8000-00000000085b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D34") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 492.76 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50022-0000-4000-8000-000000000022")
		(property "Reference" "C43"
			(at 495.3 152.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 495.3 157.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 492.76 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bfc-0000-4000-8000-000000000bfc")
		)
		(pin "2"
			(uuid "1ed50bfd-0000-4000-8000-000000000bfd")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C43") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 492.76 151.13) (xy 492.76 148.59))
		(stroke (width 0) (type default))
		(uuid "1ed513cb-0000-4000-8000-0000000013cb")
	)
	(label "+5V_LED"
		(at 492.76 148.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513cc-0000-4000-8000-0000000013cc")
	)
	(symbol
		(lib_id "power:GND")
		(at 492.76 158.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b7a-0000-4000-8000-000000001b7a")
		(property "Reference" "#PWR_L34"
			(at 495.3 161.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 495.3 156.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 492.76 158.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c42-0000-4000-8000-000000001c42")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L34") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 480.06 147.32) (xy 492.76 147.32))
		(stroke (width 0) (type default))
		(uuid "1ed017f5-0000-4000-8000-0000000017f5")
	)
	(wire
		(pts (xy 492.76 147.32) (xy 492.76 151.13))
		(stroke (width 0) (type default))
		(uuid "1ed017f6-0000-4000-8000-0000000017f6")
	)
	(wire
		(pts (xy 480.06 162.56) (xy 492.76 162.56))
		(stroke (width 0) (type default))
		(uuid "1ed017f7-0000-4000-8000-0000000017f7")
	)
	(wire
		(pts (xy 492.76 162.56) (xy 492.76 158.75))
		(stroke (width 0) (type default))
		(uuid "1ed017f8-0000-4000-8000-0000000017f8")
	)
	(wire
		(pts (xy 487.68 154.94) (xy 500.38 154.94))
		(stroke (width 0) (type default))
		(uuid "1ed01b7e-0000-4000-8000-000000001b7e")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 508 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00023-0000-4000-8000-000000000023")
		(property "Reference" "D35"
			(at 508 144.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 508 165.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 508 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed0085c-0000-4000-8000-00000000085c")
		)
		(pin "2"
			(uuid "1ed0085d-0000-4000-8000-00000000085d")
		)
		(pin "3"
			(uuid "1ed0085e-0000-4000-8000-00000000085e")
		)
		(pin "4"
			(uuid "1ed0085f-0000-4000-8000-00000000085f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D35") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 520.7 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50023-0000-4000-8000-000000000023")
		(property "Reference" "C44"
			(at 523.24 152.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 523.24 157.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 520.7 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50bfe-0000-4000-8000-000000000bfe")
		)
		(pin "2"
			(uuid "1ed50bff-0000-4000-8000-000000000bff")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C44") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 520.7 151.13) (xy 520.7 148.59))
		(stroke (width 0) (type default))
		(uuid "1ed513cd-0000-4000-8000-0000000013cd")
	)
	(label "+5V_LED"
		(at 520.7 148.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513ce-0000-4000-8000-0000000013ce")
	)
	(symbol
		(lib_id "power:GND")
		(at 520.7 158.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b7b-0000-4000-8000-000000001b7b")
		(property "Reference" "#PWR_L35"
			(at 523.24 161.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 523.24 156.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 520.7 158.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c43-0000-4000-8000-000000001c43")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L35") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 508 147.32) (xy 520.7 147.32))
		(stroke (width 0) (type default))
		(uuid "1ed017f9-0000-4000-8000-0000000017f9")
	)
	(wire
		(pts (xy 520.7 147.32) (xy 520.7 151.13))
		(stroke (width 0) (type default))
		(uuid "1ed017fa-0000-4000-8000-0000000017fa")
	)
	(wire
		(pts (xy 508 162.56) (xy 520.7 162.56))
		(stroke (width 0) (type default))
		(uuid "1ed017fb-0000-4000-8000-0000000017fb")
	)
	(wire
		(pts (xy 520.7 162.56) (xy 520.7 158.75))
		(stroke (width 0) (type default))
		(uuid "1ed017fc-0000-4000-8000-0000000017fc")
	)
	(wire
		(pts (xy 515.62 154.94) (xy 528.32 154.94))
		(stroke (width 0) (type default))
		(uuid "1ed01b7f-0000-4000-8000-000000001b7f")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 535.94 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00024-0000-4000-8000-000000000024")
		(property "Reference" "D36"
			(at 535.94 144.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 535.94 165.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 535.94 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00860-0000-4000-8000-000000000860")
		)
		(pin "2"
			(uuid "1ed00861-0000-4000-8000-000000000861")
		)
		(pin "3"
			(uuid "1ed00862-0000-4000-8000-000000000862")
		)
		(pin "4"
			(uuid "1ed00863-0000-4000-8000-000000000863")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D36") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 548.64 154.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50024-0000-4000-8000-000000000024")
		(property "Reference" "C45"
			(at 551.18 152.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 551.18 157.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 548.64 154.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c00-0000-4000-8000-000000000c00")
		)
		(pin "2"
			(uuid "1ed50c01-0000-4000-8000-000000000c01")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C45") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 548.64 151.13) (xy 548.64 148.59))
		(stroke (width 0) (type default))
		(uuid "1ed513cf-0000-4000-8000-0000000013cf")
	)
	(label "+5V_LED"
		(at 548.64 148.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513d0-0000-4000-8000-0000000013d0")
	)
	(symbol
		(lib_id "power:GND")
		(at 548.64 158.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b7c-0000-4000-8000-000000001b7c")
		(property "Reference" "#PWR_L36"
			(at 551.18 161.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 551.18 156.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 548.64 158.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c44-0000-4000-8000-000000001c44")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L36") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 535.94 147.32) (xy 548.64 147.32))
		(stroke (width 0) (type default))
		(uuid "1ed017fd-0000-4000-8000-0000000017fd")
	)
	(wire
		(pts (xy 548.64 147.32) (xy 548.64 151.13))
		(stroke (width 0) (type default))
		(uuid "1ed017fe-0000-4000-8000-0000000017fe")
	)
	(wire
		(pts (xy 535.94 162.56) (xy 548.64 162.56))
		(stroke (width 0) (type default))
		(uuid "1ed017ff-0000-4000-8000-0000000017ff")
	)
	(wire
		(pts (xy 548.64 162.56) (xy 548.64 158.75))
		(stroke (width 0) (type default))
		(uuid "1ed01800-0000-4000-8000-000000001800")
	)
	(label "L36"
		(at 543.56 154.94 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed01b80-0000-4000-8000-000000001b80")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 312.42 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00025-0000-4000-8000-000000000025")
		(property "Reference" "D37"
			(at 312.42 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 312.42 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 312.42 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00864-0000-4000-8000-000000000864")
		)
		(pin "2"
			(uuid "1ed00865-0000-4000-8000-000000000865")
		)
		(pin "3"
			(uuid "1ed00866-0000-4000-8000-000000000866")
		)
		(pin "4"
			(uuid "1ed00867-0000-4000-8000-000000000867")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D37") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 325.12 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50025-0000-4000-8000-000000000025")
		(property "Reference" "C46"
			(at 327.66 177.8 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 327.66 182.88 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 325.12 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c02-0000-4000-8000-000000000c02")
		)
		(pin "2"
			(uuid "1ed50c03-0000-4000-8000-000000000c03")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C46") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 325.12 176.53) (xy 325.12 173.99))
		(stroke (width 0) (type default))
		(uuid "1ed513d1-0000-4000-8000-0000000013d1")
	)
	(label "+5V_LED"
		(at 325.12 173.99 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513d2-0000-4000-8000-0000000013d2")
	)
	(symbol
		(lib_id "power:GND")
		(at 325.12 184.15 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b7d-0000-4000-8000-000000001b7d")
		(property "Reference" "#PWR_L37"
			(at 327.66 186.69 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 327.66 181.61 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 325.12 184.15 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c45-0000-4000-8000-000000001c45")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L37") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 312.42 172.72) (xy 325.12 172.72))
		(stroke (width 0) (type default))
		(uuid "1ed01801-0000-4000-8000-000000001801")
	)
	(wire
		(pts (xy 325.12 172.72) (xy 325.12 176.53))
		(stroke (width 0) (type default))
		(uuid "1ed01802-0000-4000-8000-000000001802")
	)
	(wire
		(pts (xy 312.42 187.96) (xy 325.12 187.96))
		(stroke (width 0) (type default))
		(uuid "1ed01803-0000-4000-8000-000000001803")
	)
	(wire
		(pts (xy 325.12 187.96) (xy 325.12 184.15))
		(stroke (width 0) (type default))
		(uuid "1ed01804-0000-4000-8000-000000001804")
	)
	(label "L36"
		(at 304.8 180.34 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "1ed01b81-0000-4000-8000-000000001b81")
	)
	(wire
		(pts (xy 320.04 180.34) (xy 332.74 180.34))
		(stroke (width 0) (type default))
		(uuid "1ed01b82-0000-4000-8000-000000001b82")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 340.36 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00026-0000-4000-8000-000000000026")
		(property "Reference" "D38"
			(at 340.36 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 340.36 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 340.36 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00868-0000-4000-8000-000000000868")
		)
		(pin "2"
			(uuid "1ed00869-0000-4000-8000-000000000869")
		)
		(pin "3"
			(uuid "1ed0086a-0000-4000-8000-00000000086a")
		)
		(pin "4"
			(uuid "1ed0086b-0000-4000-8000-00000000086b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D38") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 353.06 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50026-0000-4000-8000-000000000026")
		(property "Reference" "C47"
			(at 355.6 177.8 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 355.6 182.88 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 353.06 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c04-0000-4000-8000-000000000c04")
		)
		(pin "2"
			(uuid "1ed50c05-0000-4000-8000-000000000c05")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C47") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 353.06 176.53) (xy 353.06 173.99))
		(stroke (width 0) (type default))
		(uuid "1ed513d3-0000-4000-8000-0000000013d3")
	)
	(label "+5V_LED"
		(at 353.06 173.99 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513d4-0000-4000-8000-0000000013d4")
	)
	(symbol
		(lib_id "power:GND")
		(at 353.06 184.15 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b7e-0000-4000-8000-000000001b7e")
		(property "Reference" "#PWR_L38"
			(at 355.6 186.69 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 355.6 181.61 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 353.06 184.15 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c46-0000-4000-8000-000000001c46")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L38") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 340.36 172.72) (xy 353.06 172.72))
		(stroke (width 0) (type default))
		(uuid "1ed01805-0000-4000-8000-000000001805")
	)
	(wire
		(pts (xy 353.06 172.72) (xy 353.06 176.53))
		(stroke (width 0) (type default))
		(uuid "1ed01806-0000-4000-8000-000000001806")
	)
	(wire
		(pts (xy 340.36 187.96) (xy 353.06 187.96))
		(stroke (width 0) (type default))
		(uuid "1ed01807-0000-4000-8000-000000001807")
	)
	(wire
		(pts (xy 353.06 187.96) (xy 353.06 184.15))
		(stroke (width 0) (type default))
		(uuid "1ed01808-0000-4000-8000-000000001808")
	)
	(wire
		(pts (xy 347.98 180.34) (xy 360.68 180.34))
		(stroke (width 0) (type default))
		(uuid "1ed01b83-0000-4000-8000-000000001b83")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 368.3 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00027-0000-4000-8000-000000000027")
		(property "Reference" "D39"
			(at 368.3 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 368.3 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 368.3 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed0086c-0000-4000-8000-00000000086c")
		)
		(pin "2"
			(uuid "1ed0086d-0000-4000-8000-00000000086d")
		)
		(pin "3"
			(uuid "1ed0086e-0000-4000-8000-00000000086e")
		)
		(pin "4"
			(uuid "1ed0086f-0000-4000-8000-00000000086f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D39") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 381 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50027-0000-4000-8000-000000000027")
		(property "Reference" "C48"
			(at 383.54 177.8 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 383.54 182.88 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 381 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c06-0000-4000-8000-000000000c06")
		)
		(pin "2"
			(uuid "1ed50c07-0000-4000-8000-000000000c07")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C48") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 381 176.53) (xy 381 173.99))
		(stroke (width 0) (type default))
		(uuid "1ed513d5-0000-4000-8000-0000000013d5")
	)
	(label "+5V_LED"
		(at 381 173.99 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513d6-0000-4000-8000-0000000013d6")
	)
	(symbol
		(lib_id "power:GND")
		(at 381 184.15 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b7f-0000-4000-8000-000000001b7f")
		(property "Reference" "#PWR_L39"
			(at 383.54 186.69 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 383.54 181.61 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 381 184.15 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c47-0000-4000-8000-000000001c47")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L39") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 368.3 172.72) (xy 381 172.72))
		(stroke (width 0) (type default))
		(uuid "1ed01809-0000-4000-8000-000000001809")
	)
	(wire
		(pts (xy 381 172.72) (xy 381 176.53))
		(stroke (width 0) (type default))
		(uuid "1ed0180a-0000-4000-8000-00000000180a")
	)
	(wire
		(pts (xy 368.3 187.96) (xy 381 187.96))
		(stroke (width 0) (type default))
		(uuid "1ed0180b-0000-4000-8000-00000000180b")
	)
	(wire
		(pts (xy 381 187.96) (xy 381 184.15))
		(stroke (width 0) (type default))
		(uuid "1ed0180c-0000-4000-8000-00000000180c")
	)
	(wire
		(pts (xy 375.92 180.34) (xy 388.62 180.34))
		(stroke (width 0) (type default))
		(uuid "1ed01b84-0000-4000-8000-000000001b84")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 396.24 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00028-0000-4000-8000-000000000028")
		(property "Reference" "D40"
			(at 396.24 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 396.24 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 396.24 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00870-0000-4000-8000-000000000870")
		)
		(pin "2"
			(uuid "1ed00871-0000-4000-8000-000000000871")
		)
		(pin "3"
			(uuid "1ed00872-0000-4000-8000-000000000872")
		)
		(pin "4"
			(uuid "1ed00873-0000-4000-8000-000000000873")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D40") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 408.94 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50028-0000-4000-8000-000000000028")
		(property "Reference" "C49"
			(at 411.48 177.8 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 411.48 182.88 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 408.94 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c08-0000-4000-8000-000000000c08")
		)
		(pin "2"
			(uuid "1ed50c09-0000-4000-8000-000000000c09")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C49") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 408.94 176.53) (xy 408.94 173.99))
		(stroke (width 0) (type default))
		(uuid "1ed513d7-0000-4000-8000-0000000013d7")
	)
	(label "+5V_LED"
		(at 408.94 173.99 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513d8-0000-4000-8000-0000000013d8")
	)
	(symbol
		(lib_id "power:GND")
		(at 408.94 184.15 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b80-0000-4000-8000-000000001b80")
		(property "Reference" "#PWR_L40"
			(at 411.48 186.69 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 411.48 181.61 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 408.94 184.15 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c48-0000-4000-8000-000000001c48")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L40") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 396.24 172.72) (xy 408.94 172.72))
		(stroke (width 0) (type default))
		(uuid "1ed0180d-0000-4000-8000-00000000180d")
	)
	(wire
		(pts (xy 408.94 172.72) (xy 408.94 176.53))
		(stroke (width 0) (type default))
		(uuid "1ed0180e-0000-4000-8000-00000000180e")
	)
	(wire
		(pts (xy 396.24 187.96) (xy 408.94 187.96))
		(stroke (width 0) (type default))
		(uuid "1ed0180f-0000-4000-8000-00000000180f")
	)
	(wire
		(pts (xy 408.94 187.96) (xy 408.94 184.15))
		(stroke (width 0) (type default))
		(uuid "1ed01810-0000-4000-8000-000000001810")
	)
	(wire
		(pts (xy 403.86 180.34) (xy 416.56 180.34))
		(stroke (width 0) (type default))
		(uuid "1ed01b85-0000-4000-8000-000000001b85")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 424.18 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00029-0000-4000-8000-000000000029")
		(property "Reference" "D41"
			(at 424.18 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 424.18 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 424.18 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00874-0000-4000-8000-000000000874")
		)
		(pin "2"
			(uuid "1ed00875-0000-4000-8000-000000000875")
		)
		(pin "3"
			(uuid "1ed00876-0000-4000-8000-000000000876")
		)
		(pin "4"
			(uuid "1ed00877-0000-4000-8000-000000000877")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D41") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 436.88 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50029-0000-4000-8000-000000000029")
		(property "Reference" "C50"
			(at 439.42 177.8 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 439.42 182.88 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 436.88 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c0a-0000-4000-8000-000000000c0a")
		)
		(pin "2"
			(uuid "1ed50c0b-0000-4000-8000-000000000c0b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C50") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 436.88 176.53) (xy 436.88 173.99))
		(stroke (width 0) (type default))
		(uuid "1ed513d9-0000-4000-8000-0000000013d9")
	)
	(label "+5V_LED"
		(at 436.88 173.99 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513da-0000-4000-8000-0000000013da")
	)
	(symbol
		(lib_id "power:GND")
		(at 436.88 184.15 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b81-0000-4000-8000-000000001b81")
		(property "Reference" "#PWR_L41"
			(at 439.42 186.69 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 439.42 181.61 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 436.88 184.15 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c49-0000-4000-8000-000000001c49")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L41") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 424.18 172.72) (xy 436.88 172.72))
		(stroke (width 0) (type default))
		(uuid "1ed01811-0000-4000-8000-000000001811")
	)
	(wire
		(pts (xy 436.88 172.72) (xy 436.88 176.53))
		(stroke (width 0) (type default))
		(uuid "1ed01812-0000-4000-8000-000000001812")
	)
	(wire
		(pts (xy 424.18 187.96) (xy 436.88 187.96))
		(stroke (width 0) (type default))
		(uuid "1ed01813-0000-4000-8000-000000001813")
	)
	(wire
		(pts (xy 436.88 187.96) (xy 436.88 184.15))
		(stroke (width 0) (type default))
		(uuid "1ed01814-0000-4000-8000-000000001814")
	)
	(wire
		(pts (xy 431.8 180.34) (xy 444.5 180.34))
		(stroke (width 0) (type default))
		(uuid "1ed01b86-0000-4000-8000-000000001b86")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 452.12 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0002a-0000-4000-8000-00000000002a")
		(property "Reference" "D42"
			(at 452.12 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 452.12 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 452.12 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00878-0000-4000-8000-000000000878")
		)
		(pin "2"
			(uuid "1ed00879-0000-4000-8000-000000000879")
		)
		(pin "3"
			(uuid "1ed0087a-0000-4000-8000-00000000087a")
		)
		(pin "4"
			(uuid "1ed0087b-0000-4000-8000-00000000087b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D42") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 464.82 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5002a-0000-4000-8000-00000000002a")
		(property "Reference" "C51"
			(at 467.36 177.8 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 467.36 182.88 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 464.82 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c0c-0000-4000-8000-000000000c0c")
		)
		(pin "2"
			(uuid "1ed50c0d-0000-4000-8000-000000000c0d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C51") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 464.82 176.53) (xy 464.82 173.99))
		(stroke (width 0) (type default))
		(uuid "1ed513db-0000-4000-8000-0000000013db")
	)
	(label "+5V_LED"
		(at 464.82 173.99 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513dc-0000-4000-8000-0000000013dc")
	)
	(symbol
		(lib_id "power:GND")
		(at 464.82 184.15 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b82-0000-4000-8000-000000001b82")
		(property "Reference" "#PWR_L42"
			(at 467.36 186.69 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 467.36 181.61 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 464.82 184.15 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c4a-0000-4000-8000-000000001c4a")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L42") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 452.12 172.72) (xy 464.82 172.72))
		(stroke (width 0) (type default))
		(uuid "1ed01815-0000-4000-8000-000000001815")
	)
	(wire
		(pts (xy 464.82 172.72) (xy 464.82 176.53))
		(stroke (width 0) (type default))
		(uuid "1ed01816-0000-4000-8000-000000001816")
	)
	(wire
		(pts (xy 452.12 187.96) (xy 464.82 187.96))
		(stroke (width 0) (type default))
		(uuid "1ed01817-0000-4000-8000-000000001817")
	)
	(wire
		(pts (xy 464.82 187.96) (xy 464.82 184.15))
		(stroke (width 0) (type default))
		(uuid "1ed01818-0000-4000-8000-000000001818")
	)
	(wire
		(pts (xy 459.74 180.34) (xy 472.44 180.34))
		(stroke (width 0) (type default))
		(uuid "1ed01b87-0000-4000-8000-000000001b87")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 480.06 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0002b-0000-4000-8000-00000000002b")
		(property "Reference" "D43"
			(at 480.06 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 480.06 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 480.06 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed0087c-0000-4000-8000-00000000087c")
		)
		(pin "2"
			(uuid "1ed0087d-0000-4000-8000-00000000087d")
		)
		(pin "3"
			(uuid "1ed0087e-0000-4000-8000-00000000087e")
		)
		(pin "4"
			(uuid "1ed0087f-0000-4000-8000-00000000087f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D43") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 492.76 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5002b-0000-4000-8000-00000000002b")
		(property "Reference" "C52"
			(at 495.3 177.8 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 495.3 182.88 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 492.76 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c0e-0000-4000-8000-000000000c0e")
		)
		(pin "2"
			(uuid "1ed50c0f-0000-4000-8000-000000000c0f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C52") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 492.76 176.53) (xy 492.76 173.99))
		(stroke (width 0) (type default))
		(uuid "1ed513dd-0000-4000-8000-0000000013dd")
	)
	(label "+5V_LED"
		(at 492.76 173.99 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513de-0000-4000-8000-0000000013de")
	)
	(symbol
		(lib_id "power:GND")
		(at 492.76 184.15 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b83-0000-4000-8000-000000001b83")
		(property "Reference" "#PWR_L43"
			(at 495.3 186.69 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 495.3 181.61 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 492.76 184.15 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c4b-0000-4000-8000-000000001c4b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L43") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 480.06 172.72) (xy 492.76 172.72))
		(stroke (width 0) (type default))
		(uuid "1ed01819-0000-4000-8000-000000001819")
	)
	(wire
		(pts (xy 492.76 172.72) (xy 492.76 176.53))
		(stroke (width 0) (type default))
		(uuid "1ed0181a-0000-4000-8000-00000000181a")
	)
	(wire
		(pts (xy 480.06 187.96) (xy 492.76 187.96))
		(stroke (width 0) (type default))
		(uuid "1ed0181b-0000-4000-8000-00000000181b")
	)
	(wire
		(pts (xy 492.76 187.96) (xy 492.76 184.15))
		(stroke (width 0) (type default))
		(uuid "1ed0181c-0000-4000-8000-00000000181c")
	)
	(wire
		(pts (xy 487.68 180.34) (xy 500.38 180.34))
		(stroke (width 0) (type default))
		(uuid "1ed01b88-0000-4000-8000-000000001b88")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 508 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0002c-0000-4000-8000-00000000002c")
		(property "Reference" "D44"
			(at 508 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 508 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 508 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00880-0000-4000-8000-000000000880")
		)
		(pin "2"
			(uuid "1ed00881-0000-4000-8000-000000000881")
		)
		(pin "3"
			(uuid "1ed00882-0000-4000-8000-000000000882")
		)
		(pin "4"
			(uuid "1ed00883-0000-4000-8000-000000000883")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D44") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 520.7 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5002c-0000-4000-8000-00000000002c")
		(property "Reference" "C53"
			(at 523.24 177.8 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 523.24 182.88 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 520.7 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c10-0000-4000-8000-000000000c10")
		)
		(pin "2"
			(uuid "1ed50c11-0000-4000-8000-000000000c11")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C53") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 520.7 176.53) (xy 520.7 173.99))
		(stroke (width 0) (type default))
		(uuid "1ed513df-0000-4000-8000-0000000013df")
	)
	(label "+5V_LED"
		(at 520.7 173.99 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513e0-0000-4000-8000-0000000013e0")
	)
	(symbol
		(lib_id "power:GND")
		(at 520.7 184.15 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b84-0000-4000-8000-000000001b84")
		(property "Reference" "#PWR_L44"
			(at 523.24 186.69 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 523.24 181.61 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 520.7 184.15 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c4c-0000-4000-8000-000000001c4c")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L44") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 508 172.72) (xy 520.7 172.72))
		(stroke (width 0) (type default))
		(uuid "1ed0181d-0000-4000-8000-00000000181d")
	)
	(wire
		(pts (xy 520.7 172.72) (xy 520.7 176.53))
		(stroke (width 0) (type default))
		(uuid "1ed0181e-0000-4000-8000-00000000181e")
	)
	(wire
		(pts (xy 508 187.96) (xy 520.7 187.96))
		(stroke (width 0) (type default))
		(uuid "1ed0181f-0000-4000-8000-00000000181f")
	)
	(wire
		(pts (xy 520.7 187.96) (xy 520.7 184.15))
		(stroke (width 0) (type default))
		(uuid "1ed01820-0000-4000-8000-000000001820")
	)
	(wire
		(pts (xy 515.62 180.34) (xy 528.32 180.34))
		(stroke (width 0) (type default))
		(uuid "1ed01b89-0000-4000-8000-000000001b89")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 535.94 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0002d-0000-4000-8000-00000000002d")
		(property "Reference" "D45"
			(at 535.94 170.18 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 535.94 190.5 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 535.94 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00884-0000-4000-8000-000000000884")
		)
		(pin "2"
			(uuid "1ed00885-0000-4000-8000-000000000885")
		)
		(pin "3"
			(uuid "1ed00886-0000-4000-8000-000000000886")
		)
		(pin "4"
			(uuid "1ed00887-0000-4000-8000-000000000887")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D45") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 548.64 180.34 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5002d-0000-4000-8000-00000000002d")
		(property "Reference" "C54"
			(at 551.18 177.8 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 551.18 182.88 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 548.64 180.34 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c12-0000-4000-8000-000000000c12")
		)
		(pin "2"
			(uuid "1ed50c13-0000-4000-8000-000000000c13")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C54") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 548.64 176.53) (xy 548.64 173.99))
		(stroke (width 0) (type default))
		(uuid "1ed513e1-0000-4000-8000-0000000013e1")
	)
	(label "+5V_LED"
		(at 548.64 173.99 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513e2-0000-4000-8000-0000000013e2")
	)
	(symbol
		(lib_id "power:GND")
		(at 548.64 184.15 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b85-0000-4000-8000-000000001b85")
		(property "Reference" "#PWR_L45"
			(at 551.18 186.69 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 551.18 181.61 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 548.64 184.15 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c4d-0000-4000-8000-000000001c4d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L45") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 535.94 172.72) (xy 548.64 172.72))
		(stroke (width 0) (type default))
		(uuid "1ed01821-0000-4000-8000-000000001821")
	)
	(wire
		(pts (xy 548.64 172.72) (xy 548.64 176.53))
		(stroke (width 0) (type default))
		(uuid "1ed01822-0000-4000-8000-000000001822")
	)
	(wire
		(pts (xy 535.94 187.96) (xy 548.64 187.96))
		(stroke (width 0) (type default))
		(uuid "1ed01823-0000-4000-8000-000000001823")
	)
	(wire
		(pts (xy 548.64 187.96) (xy 548.64 184.15))
		(stroke (width 0) (type default))
		(uuid "1ed01824-0000-4000-8000-000000001824")
	)
	(label "L45"
		(at 543.56 180.34 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed01b8a-0000-4000-8000-000000001b8a")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 312.42 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0002e-0000-4000-8000-00000000002e")
		(property "Reference" "D46"
			(at 312.42 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 312.42 215.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 312.42 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00888-0000-4000-8000-000000000888")
		)
		(pin "2"
			(uuid "1ed00889-0000-4000-8000-000000000889")
		)
		(pin "3"
			(uuid "1ed0088a-0000-4000-8000-00000000088a")
		)
		(pin "4"
			(uuid "1ed0088b-0000-4000-8000-00000000088b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D46") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 325.12 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5002e-0000-4000-8000-00000000002e")
		(property "Reference" "C55"
			(at 327.66 203.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 327.66 208.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 325.12 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c14-0000-4000-8000-000000000c14")
		)
		(pin "2"
			(uuid "1ed50c15-0000-4000-8000-000000000c15")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C55") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 325.12 201.93) (xy 325.12 199.39))
		(stroke (width 0) (type default))
		(uuid "1ed513e3-0000-4000-8000-0000000013e3")
	)
	(label "+5V_LED"
		(at 325.12 199.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513e4-0000-4000-8000-0000000013e4")
	)
	(symbol
		(lib_id "power:GND")
		(at 325.12 209.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b86-0000-4000-8000-000000001b86")
		(property "Reference" "#PWR_L46"
			(at 327.66 212.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 327.66 207.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 325.12 209.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c4e-0000-4000-8000-000000001c4e")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L46") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 312.42 198.12) (xy 325.12 198.12))
		(stroke (width 0) (type default))
		(uuid "1ed01825-0000-4000-8000-000000001825")
	)
	(wire
		(pts (xy 325.12 198.12) (xy 325.12 201.93))
		(stroke (width 0) (type default))
		(uuid "1ed01826-0000-4000-8000-000000001826")
	)
	(wire
		(pts (xy 312.42 213.36) (xy 325.12 213.36))
		(stroke (width 0) (type default))
		(uuid "1ed01827-0000-4000-8000-000000001827")
	)
	(wire
		(pts (xy 325.12 213.36) (xy 325.12 209.55))
		(stroke (width 0) (type default))
		(uuid "1ed01828-0000-4000-8000-000000001828")
	)
	(label "L45"
		(at 304.8 205.74 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "1ed01b8b-0000-4000-8000-000000001b8b")
	)
	(wire
		(pts (xy 320.04 205.74) (xy 332.74 205.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b8c-0000-4000-8000-000000001b8c")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 340.36 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0002f-0000-4000-8000-00000000002f")
		(property "Reference" "D47"
			(at 340.36 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 340.36 215.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 340.36 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed0088c-0000-4000-8000-00000000088c")
		)
		(pin "2"
			(uuid "1ed0088d-0000-4000-8000-00000000088d")
		)
		(pin "3"
			(uuid "1ed0088e-0000-4000-8000-00000000088e")
		)
		(pin "4"
			(uuid "1ed0088f-0000-4000-8000-00000000088f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D47") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 353.06 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5002f-0000-4000-8000-00000000002f")
		(property "Reference" "C56"
			(at 355.6 203.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 355.6 208.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 353.06 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c16-0000-4000-8000-000000000c16")
		)
		(pin "2"
			(uuid "1ed50c17-0000-4000-8000-000000000c17")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C56") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 353.06 201.93) (xy 353.06 199.39))
		(stroke (width 0) (type default))
		(uuid "1ed513e5-0000-4000-8000-0000000013e5")
	)
	(label "+5V_LED"
		(at 353.06 199.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513e6-0000-4000-8000-0000000013e6")
	)
	(symbol
		(lib_id "power:GND")
		(at 353.06 209.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b87-0000-4000-8000-000000001b87")
		(property "Reference" "#PWR_L47"
			(at 355.6 212.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 355.6 207.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 353.06 209.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c4f-0000-4000-8000-000000001c4f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L47") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 340.36 198.12) (xy 353.06 198.12))
		(stroke (width 0) (type default))
		(uuid "1ed01829-0000-4000-8000-000000001829")
	)
	(wire
		(pts (xy 353.06 198.12) (xy 353.06 201.93))
		(stroke (width 0) (type default))
		(uuid "1ed0182a-0000-4000-8000-00000000182a")
	)
	(wire
		(pts (xy 340.36 213.36) (xy 353.06 213.36))
		(stroke (width 0) (type default))
		(uuid "1ed0182b-0000-4000-8000-00000000182b")
	)
	(wire
		(pts (xy 353.06 213.36) (xy 353.06 209.55))
		(stroke (width 0) (type default))
		(uuid "1ed0182c-0000-4000-8000-00000000182c")
	)
	(wire
		(pts (xy 347.98 205.74) (xy 360.68 205.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b8d-0000-4000-8000-000000001b8d")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 368.3 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00030-0000-4000-8000-000000000030")
		(property "Reference" "D48"
			(at 368.3 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 368.3 215.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 368.3 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00890-0000-4000-8000-000000000890")
		)
		(pin "2"
			(uuid "1ed00891-0000-4000-8000-000000000891")
		)
		(pin "3"
			(uuid "1ed00892-0000-4000-8000-000000000892")
		)
		(pin "4"
			(uuid "1ed00893-0000-4000-8000-000000000893")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D48") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 381 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50030-0000-4000-8000-000000000030")
		(property "Reference" "C57"
			(at 383.54 203.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 383.54 208.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 381 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c18-0000-4000-8000-000000000c18")
		)
		(pin "2"
			(uuid "1ed50c19-0000-4000-8000-000000000c19")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C57") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 381 201.93) (xy 381 199.39))
		(stroke (width 0) (type default))
		(uuid "1ed513e7-0000-4000-8000-0000000013e7")
	)
	(label "+5V_LED"
		(at 381 199.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513e8-0000-4000-8000-0000000013e8")
	)
	(symbol
		(lib_id "power:GND")
		(at 381 209.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b88-0000-4000-8000-000000001b88")
		(property "Reference" "#PWR_L48"
			(at 383.54 212.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 383.54 207.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 381 209.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c50-0000-4000-8000-000000001c50")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L48") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 368.3 198.12) (xy 381 198.12))
		(stroke (width 0) (type default))
		(uuid "1ed0182d-0000-4000-8000-00000000182d")
	)
	(wire
		(pts (xy 381 198.12) (xy 381 201.93))
		(stroke (width 0) (type default))
		(uuid "1ed0182e-0000-4000-8000-00000000182e")
	)
	(wire
		(pts (xy 368.3 213.36) (xy 381 213.36))
		(stroke (width 0) (type default))
		(uuid "1ed0182f-0000-4000-8000-00000000182f")
	)
	(wire
		(pts (xy 381 213.36) (xy 381 209.55))
		(stroke (width 0) (type default))
		(uuid "1ed01830-0000-4000-8000-000000001830")
	)
	(wire
		(pts (xy 375.92 205.74) (xy 388.62 205.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b8e-0000-4000-8000-000000001b8e")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 396.24 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00031-0000-4000-8000-000000000031")
		(property "Reference" "D49"
			(at 396.24 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 396.24 215.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 396.24 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00894-0000-4000-8000-000000000894")
		)
		(pin "2"
			(uuid "1ed00895-0000-4000-8000-000000000895")
		)
		(pin "3"
			(uuid "1ed00896-0000-4000-8000-000000000896")
		)
		(pin "4"
			(uuid "1ed00897-0000-4000-8000-000000000897")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D49") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 408.94 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50031-0000-4000-8000-000000000031")
		(property "Reference" "C58"
			(at 411.48 203.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 411.48 208.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 408.94 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c1a-0000-4000-8000-000000000c1a")
		)
		(pin "2"
			(uuid "1ed50c1b-0000-4000-8000-000000000c1b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C58") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 408.94 201.93) (xy 408.94 199.39))
		(stroke (width 0) (type default))
		(uuid "1ed513e9-0000-4000-8000-0000000013e9")
	)
	(label "+5V_LED"
		(at 408.94 199.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513ea-0000-4000-8000-0000000013ea")
	)
	(symbol
		(lib_id "power:GND")
		(at 408.94 209.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b89-0000-4000-8000-000000001b89")
		(property "Reference" "#PWR_L49"
			(at 411.48 212.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 411.48 207.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 408.94 209.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c51-0000-4000-8000-000000001c51")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L49") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 396.24 198.12) (xy 408.94 198.12))
		(stroke (width 0) (type default))
		(uuid "1ed01831-0000-4000-8000-000000001831")
	)
	(wire
		(pts (xy 408.94 198.12) (xy 408.94 201.93))
		(stroke (width 0) (type default))
		(uuid "1ed01832-0000-4000-8000-000000001832")
	)
	(wire
		(pts (xy 396.24 213.36) (xy 408.94 213.36))
		(stroke (width 0) (type default))
		(uuid "1ed01833-0000-4000-8000-000000001833")
	)
	(wire
		(pts (xy 408.94 213.36) (xy 408.94 209.55))
		(stroke (width 0) (type default))
		(uuid "1ed01834-0000-4000-8000-000000001834")
	)
	(wire
		(pts (xy 403.86 205.74) (xy 416.56 205.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b8f-0000-4000-8000-000000001b8f")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 424.18 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00032-0000-4000-8000-000000000032")
		(property "Reference" "D50"
			(at 424.18 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 424.18 215.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 424.18 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00898-0000-4000-8000-000000000898")
		)
		(pin "2"
			(uuid "1ed00899-0000-4000-8000-000000000899")
		)
		(pin "3"
			(uuid "1ed0089a-0000-4000-8000-00000000089a")
		)
		(pin "4"
			(uuid "1ed0089b-0000-4000-8000-00000000089b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D50") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 436.88 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50032-0000-4000-8000-000000000032")
		(property "Reference" "C59"
			(at 439.42 203.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 439.42 208.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 436.88 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c1c-0000-4000-8000-000000000c1c")
		)
		(pin "2"
			(uuid "1ed50c1d-0000-4000-8000-000000000c1d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C59") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 436.88 201.93) (xy 436.88 199.39))
		(stroke (width 0) (type default))
		(uuid "1ed513eb-0000-4000-8000-0000000013eb")
	)
	(label "+5V_LED"
		(at 436.88 199.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513ec-0000-4000-8000-0000000013ec")
	)
	(symbol
		(lib_id "power:GND")
		(at 436.88 209.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b8a-0000-4000-8000-000000001b8a")
		(property "Reference" "#PWR_L50"
			(at 439.42 212.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 439.42 207.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 436.88 209.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c52-0000-4000-8000-000000001c52")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L50") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 424.18 198.12) (xy 436.88 198.12))
		(stroke (width 0) (type default))
		(uuid "1ed01835-0000-4000-8000-000000001835")
	)
	(wire
		(pts (xy 436.88 198.12) (xy 436.88 201.93))
		(stroke (width 0) (type default))
		(uuid "1ed01836-0000-4000-8000-000000001836")
	)
	(wire
		(pts (xy 424.18 213.36) (xy 436.88 213.36))
		(stroke (width 0) (type default))
		(uuid "1ed01837-0000-4000-8000-000000001837")
	)
	(wire
		(pts (xy 436.88 213.36) (xy 436.88 209.55))
		(stroke (width 0) (type default))
		(uuid "1ed01838-0000-4000-8000-000000001838")
	)
	(wire
		(pts (xy 431.8 205.74) (xy 444.5 205.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b90-0000-4000-8000-000000001b90")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 452.12 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00033-0000-4000-8000-000000000033")
		(property "Reference" "D51"
			(at 452.12 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 452.12 215.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 452.12 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed0089c-0000-4000-8000-00000000089c")
		)
		(pin "2"
			(uuid "1ed0089d-0000-4000-8000-00000000089d")
		)
		(pin "3"
			(uuid "1ed0089e-0000-4000-8000-00000000089e")
		)
		(pin "4"
			(uuid "1ed0089f-0000-4000-8000-00000000089f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D51") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 464.82 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50033-0000-4000-8000-000000000033")
		(property "Reference" "C60"
			(at 467.36 203.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 467.36 208.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 464.82 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c1e-0000-4000-8000-000000000c1e")
		)
		(pin "2"
			(uuid "1ed50c1f-0000-4000-8000-000000000c1f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C60") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 464.82 201.93) (xy 464.82 199.39))
		(stroke (width 0) (type default))
		(uuid "1ed513ed-0000-4000-8000-0000000013ed")
	)
	(label "+5V_LED"
		(at 464.82 199.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513ee-0000-4000-8000-0000000013ee")
	)
	(symbol
		(lib_id "power:GND")
		(at 464.82 209.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b8b-0000-4000-8000-000000001b8b")
		(property "Reference" "#PWR_L51"
			(at 467.36 212.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 467.36 207.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 464.82 209.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c53-0000-4000-8000-000000001c53")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L51") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 452.12 198.12) (xy 464.82 198.12))
		(stroke (width 0) (type default))
		(uuid "1ed01839-0000-4000-8000-000000001839")
	)
	(wire
		(pts (xy 464.82 198.12) (xy 464.82 201.93))
		(stroke (width 0) (type default))
		(uuid "1ed0183a-0000-4000-8000-00000000183a")
	)
	(wire
		(pts (xy 452.12 213.36) (xy 464.82 213.36))
		(stroke (width 0) (type default))
		(uuid "1ed0183b-0000-4000-8000-00000000183b")
	)
	(wire
		(pts (xy 464.82 213.36) (xy 464.82 209.55))
		(stroke (width 0) (type default))
		(uuid "1ed0183c-0000-4000-8000-00000000183c")
	)
	(wire
		(pts (xy 459.74 205.74) (xy 472.44 205.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b91-0000-4000-8000-000000001b91")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 480.06 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00034-0000-4000-8000-000000000034")
		(property "Reference" "D52"
			(at 480.06 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 480.06 215.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 480.06 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008a0-0000-4000-8000-0000000008a0")
		)
		(pin "2"
			(uuid "1ed008a1-0000-4000-8000-0000000008a1")
		)
		(pin "3"
			(uuid "1ed008a2-0000-4000-8000-0000000008a2")
		)
		(pin "4"
			(uuid "1ed008a3-0000-4000-8000-0000000008a3")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D52") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 492.76 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50034-0000-4000-8000-000000000034")
		(property "Reference" "C61"
			(at 495.3 203.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 495.3 208.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 492.76 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c20-0000-4000-8000-000000000c20")
		)
		(pin "2"
			(uuid "1ed50c21-0000-4000-8000-000000000c21")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C61") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 492.76 201.93) (xy 492.76 199.39))
		(stroke (width 0) (type default))
		(uuid "1ed513ef-0000-4000-8000-0000000013ef")
	)
	(label "+5V_LED"
		(at 492.76 199.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513f0-0000-4000-8000-0000000013f0")
	)
	(symbol
		(lib_id "power:GND")
		(at 492.76 209.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b8c-0000-4000-8000-000000001b8c")
		(property "Reference" "#PWR_L52"
			(at 495.3 212.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 495.3 207.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 492.76 209.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c54-0000-4000-8000-000000001c54")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L52") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 480.06 198.12) (xy 492.76 198.12))
		(stroke (width 0) (type default))
		(uuid "1ed0183d-0000-4000-8000-00000000183d")
	)
	(wire
		(pts (xy 492.76 198.12) (xy 492.76 201.93))
		(stroke (width 0) (type default))
		(uuid "1ed0183e-0000-4000-8000-00000000183e")
	)
	(wire
		(pts (xy 480.06 213.36) (xy 492.76 213.36))
		(stroke (width 0) (type default))
		(uuid "1ed0183f-0000-4000-8000-00000000183f")
	)
	(wire
		(pts (xy 492.76 213.36) (xy 492.76 209.55))
		(stroke (width 0) (type default))
		(uuid "1ed01840-0000-4000-8000-000000001840")
	)
	(wire
		(pts (xy 487.68 205.74) (xy 500.38 205.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b92-0000-4000-8000-000000001b92")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 508 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00035-0000-4000-8000-000000000035")
		(property "Reference" "D53"
			(at 508 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 508 215.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 508 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008a4-0000-4000-8000-0000000008a4")
		)
		(pin "2"
			(uuid "1ed008a5-0000-4000-8000-0000000008a5")
		)
		(pin "3"
			(uuid "1ed008a6-0000-4000-8000-0000000008a6")
		)
		(pin "4"
			(uuid "1ed008a7-0000-4000-8000-0000000008a7")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D53") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 520.7 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50035-0000-4000-8000-000000000035")
		(property "Reference" "C62"
			(at 523.24 203.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 523.24 208.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 520.7 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c22-0000-4000-8000-000000000c22")
		)
		(pin "2"
			(uuid "1ed50c23-0000-4000-8000-000000000c23")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C62") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 520.7 201.93) (xy 520.7 199.39))
		(stroke (width 0) (type default))
		(uuid "1ed513f1-0000-4000-8000-0000000013f1")
	)
	(label "+5V_LED"
		(at 520.7 199.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513f2-0000-4000-8000-0000000013f2")
	)
	(symbol
		(lib_id "power:GND")
		(at 520.7 209.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b8d-0000-4000-8000-000000001b8d")
		(property "Reference" "#PWR_L53"
			(at 523.24 212.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 523.24 207.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 520.7 209.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c55-0000-4000-8000-000000001c55")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L53") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 508 198.12) (xy 520.7 198.12))
		(stroke (width 0) (type default))
		(uuid "1ed01841-0000-4000-8000-000000001841")
	)
	(wire
		(pts (xy 520.7 198.12) (xy 520.7 201.93))
		(stroke (width 0) (type default))
		(uuid "1ed01842-0000-4000-8000-000000001842")
	)
	(wire
		(pts (xy 508 213.36) (xy 520.7 213.36))
		(stroke (width 0) (type default))
		(uuid "1ed01843-0000-4000-8000-000000001843")
	)
	(wire
		(pts (xy 520.7 213.36) (xy 520.7 209.55))
		(stroke (width 0) (type default))
		(uuid "1ed01844-0000-4000-8000-000000001844")
	)
	(wire
		(pts (xy 515.62 205.74) (xy 528.32 205.74))
		(stroke (width 0) (type default))
		(uuid "1ed01b93-0000-4000-8000-000000001b93")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 535.94 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00036-0000-4000-8000-000000000036")
		(property "Reference" "D54"
			(at 535.94 195.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 535.94 215.9 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 535.94 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008a8-0000-4000-8000-0000000008a8")
		)
		(pin "2"
			(uuid "1ed008a9-0000-4000-8000-0000000008a9")
		)
		(pin "3"
			(uuid "1ed008aa-0000-4000-8000-0000000008aa")
		)
		(pin "4"
			(uuid "1ed008ab-0000-4000-8000-0000000008ab")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D54") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 548.64 205.74 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50036-0000-4000-8000-000000000036")
		(property "Reference" "C63"
			(at 551.18 203.2 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 551.18 208.28 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 548.64 205.74 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c24-0000-4000-8000-000000000c24")
		)
		(pin "2"
			(uuid "1ed50c25-0000-4000-8000-000000000c25")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C63") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 548.64 201.93) (xy 548.64 199.39))
		(stroke (width 0) (type default))
		(uuid "1ed513f3-0000-4000-8000-0000000013f3")
	)
	(label "+5V_LED"
		(at 548.64 199.39 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513f4-0000-4000-8000-0000000013f4")
	)
	(symbol
		(lib_id "power:GND")
		(at 548.64 209.55 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b8e-0000-4000-8000-000000001b8e")
		(property "Reference" "#PWR_L54"
			(at 551.18 212.09 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 551.18 207.01 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 548.64 209.55 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c56-0000-4000-8000-000000001c56")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L54") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 535.94 198.12) (xy 548.64 198.12))
		(stroke (width 0) (type default))
		(uuid "1ed01845-0000-4000-8000-000000001845")
	)
	(wire
		(pts (xy 548.64 198.12) (xy 548.64 201.93))
		(stroke (width 0) (type default))
		(uuid "1ed01846-0000-4000-8000-000000001846")
	)
	(wire
		(pts (xy 535.94 213.36) (xy 548.64 213.36))
		(stroke (width 0) (type default))
		(uuid "1ed01847-0000-4000-8000-000000001847")
	)
	(wire
		(pts (xy 548.64 213.36) (xy 548.64 209.55))
		(stroke (width 0) (type default))
		(uuid "1ed01848-0000-4000-8000-000000001848")
	)
	(label "L54"
		(at 543.56 205.74 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed01b94-0000-4000-8000-000000001b94")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 312.42 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00037-0000-4000-8000-000000000037")
		(property "Reference" "D55"
			(at 312.42 220.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 312.42 241.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 312.42 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008ac-0000-4000-8000-0000000008ac")
		)
		(pin "2"
			(uuid "1ed008ad-0000-4000-8000-0000000008ad")
		)
		(pin "3"
			(uuid "1ed008ae-0000-4000-8000-0000000008ae")
		)
		(pin "4"
			(uuid "1ed008af-0000-4000-8000-0000000008af")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D55") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 325.12 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50037-0000-4000-8000-000000000037")
		(property "Reference" "C64"
			(at 327.66 228.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 327.66 233.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 325.12 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c26-0000-4000-8000-000000000c26")
		)
		(pin "2"
			(uuid "1ed50c27-0000-4000-8000-000000000c27")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C64") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 325.12 227.33) (xy 325.12 224.79))
		(stroke (width 0) (type default))
		(uuid "1ed513f5-0000-4000-8000-0000000013f5")
	)
	(label "+5V_LED"
		(at 325.12 224.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513f6-0000-4000-8000-0000000013f6")
	)
	(symbol
		(lib_id "power:GND")
		(at 325.12 234.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b8f-0000-4000-8000-000000001b8f")
		(property "Reference" "#PWR_L55"
			(at 327.66 237.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 327.66 232.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 325.12 234.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c57-0000-4000-8000-000000001c57")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L55") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 312.42 223.52) (xy 325.12 223.52))
		(stroke (width 0) (type default))
		(uuid "1ed01849-0000-4000-8000-000000001849")
	)
	(wire
		(pts (xy 325.12 223.52) (xy 325.12 227.33))
		(stroke (width 0) (type default))
		(uuid "1ed0184a-0000-4000-8000-00000000184a")
	)
	(wire
		(pts (xy 312.42 238.76) (xy 325.12 238.76))
		(stroke (width 0) (type default))
		(uuid "1ed0184b-0000-4000-8000-00000000184b")
	)
	(wire
		(pts (xy 325.12 238.76) (xy 325.12 234.95))
		(stroke (width 0) (type default))
		(uuid "1ed0184c-0000-4000-8000-00000000184c")
	)
	(label "L54"
		(at 304.8 231.14 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "1ed01b95-0000-4000-8000-000000001b95")
	)
	(wire
		(pts (xy 320.04 231.14) (xy 332.74 231.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b96-0000-4000-8000-000000001b96")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 340.36 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00038-0000-4000-8000-000000000038")
		(property "Reference" "D56"
			(at 340.36 220.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 340.36 241.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 340.36 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008b0-0000-4000-8000-0000000008b0")
		)
		(pin "2"
			(uuid "1ed008b1-0000-4000-8000-0000000008b1")
		)
		(pin "3"
			(uuid "1ed008b2-0000-4000-8000-0000000008b2")
		)
		(pin "4"
			(uuid "1ed008b3-0000-4000-8000-0000000008b3")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D56") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 353.06 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50038-0000-4000-8000-000000000038")
		(property "Reference" "C65"
			(at 355.6 228.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 355.6 233.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 353.06 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c28-0000-4000-8000-000000000c28")
		)
		(pin "2"
			(uuid "1ed50c29-0000-4000-8000-000000000c29")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C65") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 353.06 227.33) (xy 353.06 224.79))
		(stroke (width 0) (type default))
		(uuid "1ed513f7-0000-4000-8000-0000000013f7")
	)
	(label "+5V_LED"
		(at 353.06 224.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513f8-0000-4000-8000-0000000013f8")
	)
	(symbol
		(lib_id "power:GND")
		(at 353.06 234.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b90-0000-4000-8000-000000001b90")
		(property "Reference" "#PWR_L56"
			(at 355.6 237.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 355.6 232.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 353.06 234.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c58-0000-4000-8000-000000001c58")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L56") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 340.36 223.52) (xy 353.06 223.52))
		(stroke (width 0) (type default))
		(uuid "1ed0184d-0000-4000-8000-00000000184d")
	)
	(wire
		(pts (xy 353.06 223.52) (xy 353.06 227.33))
		(stroke (width 0) (type default))
		(uuid "1ed0184e-0000-4000-8000-00000000184e")
	)
	(wire
		(pts (xy 340.36 238.76) (xy 353.06 238.76))
		(stroke (width 0) (type default))
		(uuid "1ed0184f-0000-4000-8000-00000000184f")
	)
	(wire
		(pts (xy 353.06 238.76) (xy 353.06 234.95))
		(stroke (width 0) (type default))
		(uuid "1ed01850-0000-4000-8000-000000001850")
	)
	(wire
		(pts (xy 347.98 231.14) (xy 360.68 231.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b97-0000-4000-8000-000000001b97")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 368.3 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00039-0000-4000-8000-000000000039")
		(property "Reference" "D57"
			(at 368.3 220.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 368.3 241.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 368.3 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008b4-0000-4000-8000-0000000008b4")
		)
		(pin "2"
			(uuid "1ed008b5-0000-4000-8000-0000000008b5")
		)
		(pin "3"
			(uuid "1ed008b6-0000-4000-8000-0000000008b6")
		)
		(pin "4"
			(uuid "1ed008b7-0000-4000-8000-0000000008b7")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D57") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 381 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50039-0000-4000-8000-000000000039")
		(property "Reference" "C66"
			(at 383.54 228.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 383.54 233.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 381 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c2a-0000-4000-8000-000000000c2a")
		)
		(pin "2"
			(uuid "1ed50c2b-0000-4000-8000-000000000c2b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C66") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 381 227.33) (xy 381 224.79))
		(stroke (width 0) (type default))
		(uuid "1ed513f9-0000-4000-8000-0000000013f9")
	)
	(label "+5V_LED"
		(at 381 224.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513fa-0000-4000-8000-0000000013fa")
	)
	(symbol
		(lib_id "power:GND")
		(at 381 234.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b91-0000-4000-8000-000000001b91")
		(property "Reference" "#PWR_L57"
			(at 383.54 237.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 383.54 232.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 381 234.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c59-0000-4000-8000-000000001c59")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L57") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 368.3 223.52) (xy 381 223.52))
		(stroke (width 0) (type default))
		(uuid "1ed01851-0000-4000-8000-000000001851")
	)
	(wire
		(pts (xy 381 223.52) (xy 381 227.33))
		(stroke (width 0) (type default))
		(uuid "1ed01852-0000-4000-8000-000000001852")
	)
	(wire
		(pts (xy 368.3 238.76) (xy 381 238.76))
		(stroke (width 0) (type default))
		(uuid "1ed01853-0000-4000-8000-000000001853")
	)
	(wire
		(pts (xy 381 238.76) (xy 381 234.95))
		(stroke (width 0) (type default))
		(uuid "1ed01854-0000-4000-8000-000000001854")
	)
	(wire
		(pts (xy 375.92 231.14) (xy 388.62 231.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b98-0000-4000-8000-000000001b98")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 396.24 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0003a-0000-4000-8000-00000000003a")
		(property "Reference" "D58"
			(at 396.24 220.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 396.24 241.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 396.24 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008b8-0000-4000-8000-0000000008b8")
		)
		(pin "2"
			(uuid "1ed008b9-0000-4000-8000-0000000008b9")
		)
		(pin "3"
			(uuid "1ed008ba-0000-4000-8000-0000000008ba")
		)
		(pin "4"
			(uuid "1ed008bb-0000-4000-8000-0000000008bb")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D58") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 408.94 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5003a-0000-4000-8000-00000000003a")
		(property "Reference" "C67"
			(at 411.48 228.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 411.48 233.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 408.94 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c2c-0000-4000-8000-000000000c2c")
		)
		(pin "2"
			(uuid "1ed50c2d-0000-4000-8000-000000000c2d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C67") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 408.94 227.33) (xy 408.94 224.79))
		(stroke (width 0) (type default))
		(uuid "1ed513fb-0000-4000-8000-0000000013fb")
	)
	(label "+5V_LED"
		(at 408.94 224.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513fc-0000-4000-8000-0000000013fc")
	)
	(symbol
		(lib_id "power:GND")
		(at 408.94 234.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b92-0000-4000-8000-000000001b92")
		(property "Reference" "#PWR_L58"
			(at 411.48 237.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 411.48 232.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 408.94 234.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c5a-0000-4000-8000-000000001c5a")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L58") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 396.24 223.52) (xy 408.94 223.52))
		(stroke (width 0) (type default))
		(uuid "1ed01855-0000-4000-8000-000000001855")
	)
	(wire
		(pts (xy 408.94 223.52) (xy 408.94 227.33))
		(stroke (width 0) (type default))
		(uuid "1ed01856-0000-4000-8000-000000001856")
	)
	(wire
		(pts (xy 396.24 238.76) (xy 408.94 238.76))
		(stroke (width 0) (type default))
		(uuid "1ed01857-0000-4000-8000-000000001857")
	)
	(wire
		(pts (xy 408.94 238.76) (xy 408.94 234.95))
		(stroke (width 0) (type default))
		(uuid "1ed01858-0000-4000-8000-000000001858")
	)
	(wire
		(pts (xy 403.86 231.14) (xy 416.56 231.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b99-0000-4000-8000-000000001b99")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 424.18 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0003b-0000-4000-8000-00000000003b")
		(property "Reference" "D59"
			(at 424.18 220.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 424.18 241.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 424.18 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008bc-0000-4000-8000-0000000008bc")
		)
		(pin "2"
			(uuid "1ed008bd-0000-4000-8000-0000000008bd")
		)
		(pin "3"
			(uuid "1ed008be-0000-4000-8000-0000000008be")
		)
		(pin "4"
			(uuid "1ed008bf-0000-4000-8000-0000000008bf")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D59") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 436.88 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5003b-0000-4000-8000-00000000003b")
		(property "Reference" "C68"
			(at 439.42 228.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 439.42 233.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 436.88 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c2e-0000-4000-8000-000000000c2e")
		)
		(pin "2"
			(uuid "1ed50c2f-0000-4000-8000-000000000c2f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C68") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 436.88 227.33) (xy 436.88 224.79))
		(stroke (width 0) (type default))
		(uuid "1ed513fd-0000-4000-8000-0000000013fd")
	)
	(label "+5V_LED"
		(at 436.88 224.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed513fe-0000-4000-8000-0000000013fe")
	)
	(symbol
		(lib_id "power:GND")
		(at 436.88 234.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b93-0000-4000-8000-000000001b93")
		(property "Reference" "#PWR_L59"
			(at 439.42 237.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 439.42 232.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 436.88 234.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c5b-0000-4000-8000-000000001c5b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L59") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 424.18 223.52) (xy 436.88 223.52))
		(stroke (width 0) (type default))
		(uuid "1ed01859-0000-4000-8000-000000001859")
	)
	(wire
		(pts (xy 436.88 223.52) (xy 436.88 227.33))
		(stroke (width 0) (type default))
		(uuid "1ed0185a-0000-4000-8000-00000000185a")
	)
	(wire
		(pts (xy 424.18 238.76) (xy 436.88 238.76))
		(stroke (width 0) (type default))
		(uuid "1ed0185b-0000-4000-8000-00000000185b")
	)
	(wire
		(pts (xy 436.88 238.76) (xy 436.88 234.95))
		(stroke (width 0) (type default))
		(uuid "1ed0185c-0000-4000-8000-00000000185c")
	)
	(wire
		(pts (xy 431.8 231.14) (xy 444.5 231.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b9a-0000-4000-8000-000000001b9a")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 452.12 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0003c-0000-4000-8000-00000000003c")
		(property "Reference" "D60"
			(at 452.12 220.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 452.12 241.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 452.12 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008c0-0000-4000-8000-0000000008c0")
		)
		(pin "2"
			(uuid "1ed008c1-0000-4000-8000-0000000008c1")
		)
		(pin "3"
			(uuid "1ed008c2-0000-4000-8000-0000000008c2")
		)
		(pin "4"
			(uuid "1ed008c3-0000-4000-8000-0000000008c3")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D60") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 464.82 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5003c-0000-4000-8000-00000000003c")
		(property "Reference" "C69"
			(at 467.36 228.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 467.36 233.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 464.82 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c30-0000-4000-8000-000000000c30")
		)
		(pin "2"
			(uuid "1ed50c31-0000-4000-8000-000000000c31")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C69") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 464.82 227.33) (xy 464.82 224.79))
		(stroke (width 0) (type default))
		(uuid "1ed513ff-0000-4000-8000-0000000013ff")
	)
	(label "+5V_LED"
		(at 464.82 224.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51400-0000-4000-8000-000000001400")
	)
	(symbol
		(lib_id "power:GND")
		(at 464.82 234.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b94-0000-4000-8000-000000001b94")
		(property "Reference" "#PWR_L60"
			(at 467.36 237.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 467.36 232.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 464.82 234.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c5c-0000-4000-8000-000000001c5c")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L60") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 452.12 223.52) (xy 464.82 223.52))
		(stroke (width 0) (type default))
		(uuid "1ed0185d-0000-4000-8000-00000000185d")
	)
	(wire
		(pts (xy 464.82 223.52) (xy 464.82 227.33))
		(stroke (width 0) (type default))
		(uuid "1ed0185e-0000-4000-8000-00000000185e")
	)
	(wire
		(pts (xy 452.12 238.76) (xy 464.82 238.76))
		(stroke (width 0) (type default))
		(uuid "1ed0185f-0000-4000-8000-00000000185f")
	)
	(wire
		(pts (xy 464.82 238.76) (xy 464.82 234.95))
		(stroke (width 0) (type default))
		(uuid "1ed01860-0000-4000-8000-000000001860")
	)
	(wire
		(pts (xy 459.74 231.14) (xy 472.44 231.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b9b-0000-4000-8000-000000001b9b")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 480.06 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0003d-0000-4000-8000-00000000003d")
		(property "Reference" "D61"
			(at 480.06 220.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 480.06 241.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 480.06 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008c4-0000-4000-8000-0000000008c4")
		)
		(pin "2"
			(uuid "1ed008c5-0000-4000-8000-0000000008c5")
		)
		(pin "3"
			(uuid "1ed008c6-0000-4000-8000-0000000008c6")
		)
		(pin "4"
			(uuid "1ed008c7-0000-4000-8000-0000000008c7")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D61") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 492.76 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5003d-0000-4000-8000-00000000003d")
		(property "Reference" "C70"
			(at 495.3 228.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 495.3 233.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 492.76 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c32-0000-4000-8000-000000000c32")
		)
		(pin "2"
			(uuid "1ed50c33-0000-4000-8000-000000000c33")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C70") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 492.76 227.33) (xy 492.76 224.79))
		(stroke (width 0) (type default))
		(uuid "1ed51401-0000-4000-8000-000000001401")
	)
	(label "+5V_LED"
		(at 492.76 224.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51402-0000-4000-8000-000000001402")
	)
	(symbol
		(lib_id "power:GND")
		(at 492.76 234.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b95-0000-4000-8000-000000001b95")
		(property "Reference" "#PWR_L61"
			(at 495.3 237.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 495.3 232.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 492.76 234.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c5d-0000-4000-8000-000000001c5d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L61") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 480.06 223.52) (xy 492.76 223.52))
		(stroke (width 0) (type default))
		(uuid "1ed01861-0000-4000-8000-000000001861")
	)
	(wire
		(pts (xy 492.76 223.52) (xy 492.76 227.33))
		(stroke (width 0) (type default))
		(uuid "1ed01862-0000-4000-8000-000000001862")
	)
	(wire
		(pts (xy 480.06 238.76) (xy 492.76 238.76))
		(stroke (width 0) (type default))
		(uuid "1ed01863-0000-4000-8000-000000001863")
	)
	(wire
		(pts (xy 492.76 238.76) (xy 492.76 234.95))
		(stroke (width 0) (type default))
		(uuid "1ed01864-0000-4000-8000-000000001864")
	)
	(wire
		(pts (xy 487.68 231.14) (xy 500.38 231.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b9c-0000-4000-8000-000000001b9c")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 508 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0003e-0000-4000-8000-00000000003e")
		(property "Reference" "D62"
			(at 508 220.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 508 241.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 508 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008c8-0000-4000-8000-0000000008c8")
		)
		(pin "2"
			(uuid "1ed008c9-0000-4000-8000-0000000008c9")
		)
		(pin "3"
			(uuid "1ed008ca-0000-4000-8000-0000000008ca")
		)
		(pin "4"
			(uuid "1ed008cb-0000-4000-8000-0000000008cb")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D62") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 520.7 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5003e-0000-4000-8000-00000000003e")
		(property "Reference" "C71"
			(at 523.24 228.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 523.24 233.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 520.7 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c34-0000-4000-8000-000000000c34")
		)
		(pin "2"
			(uuid "1ed50c35-0000-4000-8000-000000000c35")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C71") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 520.7 227.33) (xy 520.7 224.79))
		(stroke (width 0) (type default))
		(uuid "1ed51403-0000-4000-8000-000000001403")
	)
	(label "+5V_LED"
		(at 520.7 224.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51404-0000-4000-8000-000000001404")
	)
	(symbol
		(lib_id "power:GND")
		(at 520.7 234.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b96-0000-4000-8000-000000001b96")
		(property "Reference" "#PWR_L62"
			(at 523.24 237.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 523.24 232.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 520.7 234.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c5e-0000-4000-8000-000000001c5e")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L62") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 508 223.52) (xy 520.7 223.52))
		(stroke (width 0) (type default))
		(uuid "1ed01865-0000-4000-8000-000000001865")
	)
	(wire
		(pts (xy 520.7 223.52) (xy 520.7 227.33))
		(stroke (width 0) (type default))
		(uuid "1ed01866-0000-4000-8000-000000001866")
	)
	(wire
		(pts (xy 508 238.76) (xy 520.7 238.76))
		(stroke (width 0) (type default))
		(uuid "1ed01867-0000-4000-8000-000000001867")
	)
	(wire
		(pts (xy 520.7 238.76) (xy 520.7 234.95))
		(stroke (width 0) (type default))
		(uuid "1ed01868-0000-4000-8000-000000001868")
	)
	(wire
		(pts (xy 515.62 231.14) (xy 528.32 231.14))
		(stroke (width 0) (type default))
		(uuid "1ed01b9d-0000-4000-8000-000000001b9d")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 535.94 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0003f-0000-4000-8000-00000000003f")
		(property "Reference" "D63"
			(at 535.94 220.98 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 535.94 241.3 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 535.94 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008cc-0000-4000-8000-0000000008cc")
		)
		(pin "2"
			(uuid "1ed008cd-0000-4000-8000-0000000008cd")
		)
		(pin "3"
			(uuid "1ed008ce-0000-4000-8000-0000000008ce")
		)
		(pin "4"
			(uuid "1ed008cf-0000-4000-8000-0000000008cf")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D63") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 548.64 231.14 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5003f-0000-4000-8000-00000000003f")
		(property "Reference" "C72"
			(at 551.18 228.6 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 551.18 233.68 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 548.64 231.14 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c36-0000-4000-8000-000000000c36")
		)
		(pin "2"
			(uuid "1ed50c37-0000-4000-8000-000000000c37")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C72") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 548.64 227.33) (xy 548.64 224.79))
		(stroke (width 0) (type default))
		(uuid "1ed51405-0000-4000-8000-000000001405")
	)
	(label "+5V_LED"
		(at 548.64 224.79 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51406-0000-4000-8000-000000001406")
	)
	(symbol
		(lib_id "power:GND")
		(at 548.64 234.95 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b97-0000-4000-8000-000000001b97")
		(property "Reference" "#PWR_L63"
			(at 551.18 237.49 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 551.18 232.41 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 548.64 234.95 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c5f-0000-4000-8000-000000001c5f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L63") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 535.94 223.52) (xy 548.64 223.52))
		(stroke (width 0) (type default))
		(uuid "1ed01869-0000-4000-8000-000000001869")
	)
	(wire
		(pts (xy 548.64 223.52) (xy 548.64 227.33))
		(stroke (width 0) (type default))
		(uuid "1ed0186a-0000-4000-8000-00000000186a")
	)
	(wire
		(pts (xy 535.94 238.76) (xy 548.64 238.76))
		(stroke (width 0) (type default))
		(uuid "1ed0186b-0000-4000-8000-00000000186b")
	)
	(wire
		(pts (xy 548.64 238.76) (xy 548.64 234.95))
		(stroke (width 0) (type default))
		(uuid "1ed0186c-0000-4000-8000-00000000186c")
	)
	(label "L63"
		(at 543.56 231.14 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed01b9e-0000-4000-8000-000000001b9e")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 312.42 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00040-0000-4000-8000-000000000040")
		(property "Reference" "D64"
			(at 312.42 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 312.42 266.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 312.42 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008d0-0000-4000-8000-0000000008d0")
		)
		(pin "2"
			(uuid "1ed008d1-0000-4000-8000-0000000008d1")
		)
		(pin "3"
			(uuid "1ed008d2-0000-4000-8000-0000000008d2")
		)
		(pin "4"
			(uuid "1ed008d3-0000-4000-8000-0000000008d3")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D64") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 325.12 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50040-0000-4000-8000-000000000040")
		(property "Reference" "C73"
			(at 327.66 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 327.66 259.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 325.12 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c38-0000-4000-8000-000000000c38")
		)
		(pin "2"
			(uuid "1ed50c39-0000-4000-8000-000000000c39")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C73") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 325.12 252.73) (xy 325.12 250.19))
		(stroke (width 0) (type default))
		(uuid "1ed51407-0000-4000-8000-000000001407")
	)
	(label "+5V_LED"
		(at 325.12 250.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51408-0000-4000-8000-000000001408")
	)
	(symbol
		(lib_id "power:GND")
		(at 325.12 260.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b98-0000-4000-8000-000000001b98")
		(property "Reference" "#PWR_L64"
			(at 327.66 262.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 327.66 257.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 325.12 260.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c60-0000-4000-8000-000000001c60")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L64") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 312.42 248.92) (xy 325.12 248.92))
		(stroke (width 0) (type default))
		(uuid "1ed0186d-0000-4000-8000-00000000186d")
	)
	(wire
		(pts (xy 325.12 248.92) (xy 325.12 252.73))
		(stroke (width 0) (type default))
		(uuid "1ed0186e-0000-4000-8000-00000000186e")
	)
	(wire
		(pts (xy 312.42 264.16) (xy 325.12 264.16))
		(stroke (width 0) (type default))
		(uuid "1ed0186f-0000-4000-8000-00000000186f")
	)
	(wire
		(pts (xy 325.12 264.16) (xy 325.12 260.35))
		(stroke (width 0) (type default))
		(uuid "1ed01870-0000-4000-8000-000000001870")
	)
	(label "L63"
		(at 304.8 256.54 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "1ed01b9f-0000-4000-8000-000000001b9f")
	)
	(wire
		(pts (xy 320.04 256.54) (xy 332.74 256.54))
		(stroke (width 0) (type default))
		(uuid "1ed01ba0-0000-4000-8000-000000001ba0")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 340.36 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00041-0000-4000-8000-000000000041")
		(property "Reference" "D65"
			(at 340.36 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 340.36 266.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 340.36 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008d4-0000-4000-8000-0000000008d4")
		)
		(pin "2"
			(uuid "1ed008d5-0000-4000-8000-0000000008d5")
		)
		(pin "3"
			(uuid "1ed008d6-0000-4000-8000-0000000008d6")
		)
		(pin "4"
			(uuid "1ed008d7-0000-4000-8000-0000000008d7")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D65") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 353.06 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50041-0000-4000-8000-000000000041")
		(property "Reference" "C74"
			(at 355.6 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 355.6 259.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 353.06 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c3a-0000-4000-8000-000000000c3a")
		)
		(pin "2"
			(uuid "1ed50c3b-0000-4000-8000-000000000c3b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C74") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 353.06 252.73) (xy 353.06 250.19))
		(stroke (width 0) (type default))
		(uuid "1ed51409-0000-4000-8000-000000001409")
	)
	(label "+5V_LED"
		(at 353.06 250.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed5140a-0000-4000-8000-00000000140a")
	)
	(symbol
		(lib_id "power:GND")
		(at 353.06 260.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b99-0000-4000-8000-000000001b99")
		(property "Reference" "#PWR_L65"
			(at 355.6 262.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 355.6 257.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 353.06 260.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c61-0000-4000-8000-000000001c61")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L65") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 340.36 248.92) (xy 353.06 248.92))
		(stroke (width 0) (type default))
		(uuid "1ed01871-0000-4000-8000-000000001871")
	)
	(wire
		(pts (xy 353.06 248.92) (xy 353.06 252.73))
		(stroke (width 0) (type default))
		(uuid "1ed01872-0000-4000-8000-000000001872")
	)
	(wire
		(pts (xy 340.36 264.16) (xy 353.06 264.16))
		(stroke (width 0) (type default))
		(uuid "1ed01873-0000-4000-8000-000000001873")
	)
	(wire
		(pts (xy 353.06 264.16) (xy 353.06 260.35))
		(stroke (width 0) (type default))
		(uuid "1ed01874-0000-4000-8000-000000001874")
	)
	(wire
		(pts (xy 347.98 256.54) (xy 360.68 256.54))
		(stroke (width 0) (type default))
		(uuid "1ed01ba1-0000-4000-8000-000000001ba1")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 368.3 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00042-0000-4000-8000-000000000042")
		(property "Reference" "D66"
			(at 368.3 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 368.3 266.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 368.3 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008d8-0000-4000-8000-0000000008d8")
		)
		(pin "2"
			(uuid "1ed008d9-0000-4000-8000-0000000008d9")
		)
		(pin "3"
			(uuid "1ed008da-0000-4000-8000-0000000008da")
		)
		(pin "4"
			(uuid "1ed008db-0000-4000-8000-0000000008db")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D66") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 381 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50042-0000-4000-8000-000000000042")
		(property "Reference" "C75"
			(at 383.54 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 383.54 259.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 381 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c3c-0000-4000-8000-000000000c3c")
		)
		(pin "2"
			(uuid "1ed50c3d-0000-4000-8000-000000000c3d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C75") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 381 252.73) (xy 381 250.19))
		(stroke (width 0) (type default))
		(uuid "1ed5140b-0000-4000-8000-00000000140b")
	)
	(label "+5V_LED"
		(at 381 250.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed5140c-0000-4000-8000-00000000140c")
	)
	(symbol
		(lib_id "power:GND")
		(at 381 260.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b9a-0000-4000-8000-000000001b9a")
		(property "Reference" "#PWR_L66"
			(at 383.54 262.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 383.54 257.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 381 260.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c62-0000-4000-8000-000000001c62")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L66") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 368.3 248.92) (xy 381 248.92))
		(stroke (width 0) (type default))
		(uuid "1ed01875-0000-4000-8000-000000001875")
	)
	(wire
		(pts (xy 381 248.92) (xy 381 252.73))
		(stroke (width 0) (type default))
		(uuid "1ed01876-0000-4000-8000-000000001876")
	)
	(wire
		(pts (xy 368.3 264.16) (xy 381 264.16))
		(stroke (width 0) (type default))
		(uuid "1ed01877-0000-4000-8000-000000001877")
	)
	(wire
		(pts (xy 381 264.16) (xy 381 260.35))
		(stroke (width 0) (type default))
		(uuid "1ed01878-0000-4000-8000-000000001878")
	)
	(wire
		(pts (xy 375.92 256.54) (xy 388.62 256.54))
		(stroke (width 0) (type default))
		(uuid "1ed01ba2-0000-4000-8000-000000001ba2")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 396.24 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00043-0000-4000-8000-000000000043")
		(property "Reference" "D67"
			(at 396.24 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 396.24 266.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 396.24 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008dc-0000-4000-8000-0000000008dc")
		)
		(pin "2"
			(uuid "1ed008dd-0000-4000-8000-0000000008dd")
		)
		(pin "3"
			(uuid "1ed008de-0000-4000-8000-0000000008de")
		)
		(pin "4"
			(uuid "1ed008df-0000-4000-8000-0000000008df")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D67") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 408.94 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50043-0000-4000-8000-000000000043")
		(property "Reference" "C76"
			(at 411.48 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 411.48 259.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 408.94 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c3e-0000-4000-8000-000000000c3e")
		)
		(pin "2"
			(uuid "1ed50c3f-0000-4000-8000-000000000c3f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C76") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 408.94 252.73) (xy 408.94 250.19))
		(stroke (width 0) (type default))
		(uuid "1ed5140d-0000-4000-8000-00000000140d")
	)
	(label "+5V_LED"
		(at 408.94 250.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed5140e-0000-4000-8000-00000000140e")
	)
	(symbol
		(lib_id "power:GND")
		(at 408.94 260.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b9b-0000-4000-8000-000000001b9b")
		(property "Reference" "#PWR_L67"
			(at 411.48 262.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 411.48 257.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 408.94 260.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c63-0000-4000-8000-000000001c63")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L67") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 396.24 248.92) (xy 408.94 248.92))
		(stroke (width 0) (type default))
		(uuid "1ed01879-0000-4000-8000-000000001879")
	)
	(wire
		(pts (xy 408.94 248.92) (xy 408.94 252.73))
		(stroke (width 0) (type default))
		(uuid "1ed0187a-0000-4000-8000-00000000187a")
	)
	(wire
		(pts (xy 396.24 264.16) (xy 408.94 264.16))
		(stroke (width 0) (type default))
		(uuid "1ed0187b-0000-4000-8000-00000000187b")
	)
	(wire
		(pts (xy 408.94 264.16) (xy 408.94 260.35))
		(stroke (width 0) (type default))
		(uuid "1ed0187c-0000-4000-8000-00000000187c")
	)
	(wire
		(pts (xy 403.86 256.54) (xy 416.56 256.54))
		(stroke (width 0) (type default))
		(uuid "1ed01ba3-0000-4000-8000-000000001ba3")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 424.18 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00044-0000-4000-8000-000000000044")
		(property "Reference" "D68"
			(at 424.18 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 424.18 266.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 424.18 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008e0-0000-4000-8000-0000000008e0")
		)
		(pin "2"
			(uuid "1ed008e1-0000-4000-8000-0000000008e1")
		)
		(pin "3"
			(uuid "1ed008e2-0000-4000-8000-0000000008e2")
		)
		(pin "4"
			(uuid "1ed008e3-0000-4000-8000-0000000008e3")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D68") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 436.88 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50044-0000-4000-8000-000000000044")
		(property "Reference" "C77"
			(at 439.42 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 439.42 259.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 436.88 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c40-0000-4000-8000-000000000c40")
		)
		(pin "2"
			(uuid "1ed50c41-0000-4000-8000-000000000c41")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C77") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 436.88 252.73) (xy 436.88 250.19))
		(stroke (width 0) (type default))
		(uuid "1ed5140f-0000-4000-8000-00000000140f")
	)
	(label "+5V_LED"
		(at 436.88 250.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51410-0000-4000-8000-000000001410")
	)
	(symbol
		(lib_id "power:GND")
		(at 436.88 260.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b9c-0000-4000-8000-000000001b9c")
		(property "Reference" "#PWR_L68"
			(at 439.42 262.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 439.42 257.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 436.88 260.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c64-0000-4000-8000-000000001c64")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L68") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 424.18 248.92) (xy 436.88 248.92))
		(stroke (width 0) (type default))
		(uuid "1ed0187d-0000-4000-8000-00000000187d")
	)
	(wire
		(pts (xy 436.88 248.92) (xy 436.88 252.73))
		(stroke (width 0) (type default))
		(uuid "1ed0187e-0000-4000-8000-00000000187e")
	)
	(wire
		(pts (xy 424.18 264.16) (xy 436.88 264.16))
		(stroke (width 0) (type default))
		(uuid "1ed0187f-0000-4000-8000-00000000187f")
	)
	(wire
		(pts (xy 436.88 264.16) (xy 436.88 260.35))
		(stroke (width 0) (type default))
		(uuid "1ed01880-0000-4000-8000-000000001880")
	)
	(wire
		(pts (xy 431.8 256.54) (xy 444.5 256.54))
		(stroke (width 0) (type default))
		(uuid "1ed01ba4-0000-4000-8000-000000001ba4")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 452.12 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00045-0000-4000-8000-000000000045")
		(property "Reference" "D69"
			(at 452.12 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 452.12 266.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 452.12 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008e4-0000-4000-8000-0000000008e4")
		)
		(pin "2"
			(uuid "1ed008e5-0000-4000-8000-0000000008e5")
		)
		(pin "3"
			(uuid "1ed008e6-0000-4000-8000-0000000008e6")
		)
		(pin "4"
			(uuid "1ed008e7-0000-4000-8000-0000000008e7")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D69") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 464.82 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50045-0000-4000-8000-000000000045")
		(property "Reference" "C78"
			(at 467.36 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 467.36 259.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 464.82 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c42-0000-4000-8000-000000000c42")
		)
		(pin "2"
			(uuid "1ed50c43-0000-4000-8000-000000000c43")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C78") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 464.82 252.73) (xy 464.82 250.19))
		(stroke (width 0) (type default))
		(uuid "1ed51411-0000-4000-8000-000000001411")
	)
	(label "+5V_LED"
		(at 464.82 250.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51412-0000-4000-8000-000000001412")
	)
	(symbol
		(lib_id "power:GND")
		(at 464.82 260.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b9d-0000-4000-8000-000000001b9d")
		(property "Reference" "#PWR_L69"
			(at 467.36 262.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 467.36 257.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 464.82 260.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c65-0000-4000-8000-000000001c65")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L69") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 452.12 248.92) (xy 464.82 248.92))
		(stroke (width 0) (type default))
		(uuid "1ed01881-0000-4000-8000-000000001881")
	)
	(wire
		(pts (xy 464.82 248.92) (xy 464.82 252.73))
		(stroke (width 0) (type default))
		(uuid "1ed01882-0000-4000-8000-000000001882")
	)
	(wire
		(pts (xy 452.12 264.16) (xy 464.82 264.16))
		(stroke (width 0) (type default))
		(uuid "1ed01883-0000-4000-8000-000000001883")
	)
	(wire
		(pts (xy 464.82 264.16) (xy 464.82 260.35))
		(stroke (width 0) (type default))
		(uuid "1ed01884-0000-4000-8000-000000001884")
	)
	(wire
		(pts (xy 459.74 256.54) (xy 472.44 256.54))
		(stroke (width 0) (type default))
		(uuid "1ed01ba5-0000-4000-8000-000000001ba5")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 480.06 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00046-0000-4000-8000-000000000046")
		(property "Reference" "D70"
			(at 480.06 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 480.06 266.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 480.06 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008e8-0000-4000-8000-0000000008e8")
		)
		(pin "2"
			(uuid "1ed008e9-0000-4000-8000-0000000008e9")
		)
		(pin "3"
			(uuid "1ed008ea-0000-4000-8000-0000000008ea")
		)
		(pin "4"
			(uuid "1ed008eb-0000-4000-8000-0000000008eb")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D70") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 492.76 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50046-0000-4000-8000-000000000046")
		(property "Reference" "C79"
			(at 495.3 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 495.3 259.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 492.76 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c44-0000-4000-8000-000000000c44")
		)
		(pin "2"
			(uuid "1ed50c45-0000-4000-8000-000000000c45")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C79") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 492.76 252.73) (xy 492.76 250.19))
		(stroke (width 0) (type default))
		(uuid "1ed51413-0000-4000-8000-000000001413")
	)
	(label "+5V_LED"
		(at 492.76 250.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51414-0000-4000-8000-000000001414")
	)
	(symbol
		(lib_id "power:GND")
		(at 492.76 260.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b9e-0000-4000-8000-000000001b9e")
		(property "Reference" "#PWR_L70"
			(at 495.3 262.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 495.3 257.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 492.76 260.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c66-0000-4000-8000-000000001c66")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L70") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 480.06 248.92) (xy 492.76 248.92))
		(stroke (width 0) (type default))
		(uuid "1ed01885-0000-4000-8000-000000001885")
	)
	(wire
		(pts (xy 492.76 248.92) (xy 492.76 252.73))
		(stroke (width 0) (type default))
		(uuid "1ed01886-0000-4000-8000-000000001886")
	)
	(wire
		(pts (xy 480.06 264.16) (xy 492.76 264.16))
		(stroke (width 0) (type default))
		(uuid "1ed01887-0000-4000-8000-000000001887")
	)
	(wire
		(pts (xy 492.76 264.16) (xy 492.76 260.35))
		(stroke (width 0) (type default))
		(uuid "1ed01888-0000-4000-8000-000000001888")
	)
	(wire
		(pts (xy 487.68 256.54) (xy 500.38 256.54))
		(stroke (width 0) (type default))
		(uuid "1ed01ba6-0000-4000-8000-000000001ba6")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 508 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00047-0000-4000-8000-000000000047")
		(property "Reference" "D71"
			(at 508 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 508 266.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 508 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008ec-0000-4000-8000-0000000008ec")
		)
		(pin "2"
			(uuid "1ed008ed-0000-4000-8000-0000000008ed")
		)
		(pin "3"
			(uuid "1ed008ee-0000-4000-8000-0000000008ee")
		)
		(pin "4"
			(uuid "1ed008ef-0000-4000-8000-0000000008ef")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D71") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 520.7 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50047-0000-4000-8000-000000000047")
		(property "Reference" "C80"
			(at 523.24 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 523.24 259.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 520.7 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c46-0000-4000-8000-000000000c46")
		)
		(pin "2"
			(uuid "1ed50c47-0000-4000-8000-000000000c47")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C80") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 520.7 252.73) (xy 520.7 250.19))
		(stroke (width 0) (type default))
		(uuid "1ed51415-0000-4000-8000-000000001415")
	)
	(label "+5V_LED"
		(at 520.7 250.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51416-0000-4000-8000-000000001416")
	)
	(symbol
		(lib_id "power:GND")
		(at 520.7 260.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51b9f-0000-4000-8000-000000001b9f")
		(property "Reference" "#PWR_L71"
			(at 523.24 262.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 523.24 257.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 520.7 260.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c67-0000-4000-8000-000000001c67")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L71") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 508 248.92) (xy 520.7 248.92))
		(stroke (width 0) (type default))
		(uuid "1ed01889-0000-4000-8000-000000001889")
	)
	(wire
		(pts (xy 520.7 248.92) (xy 520.7 252.73))
		(stroke (width 0) (type default))
		(uuid "1ed0188a-0000-4000-8000-00000000188a")
	)
	(wire
		(pts (xy 508 264.16) (xy 520.7 264.16))
		(stroke (width 0) (type default))
		(uuid "1ed0188b-0000-4000-8000-00000000188b")
	)
	(wire
		(pts (xy 520.7 264.16) (xy 520.7 260.35))
		(stroke (width 0) (type default))
		(uuid "1ed0188c-0000-4000-8000-00000000188c")
	)
	(wire
		(pts (xy 515.62 256.54) (xy 528.32 256.54))
		(stroke (width 0) (type default))
		(uuid "1ed01ba7-0000-4000-8000-000000001ba7")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 535.94 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00048-0000-4000-8000-000000000048")
		(property "Reference" "D72"
			(at 535.94 246.38 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 535.94 266.7 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 535.94 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008f0-0000-4000-8000-0000000008f0")
		)
		(pin "2"
			(uuid "1ed008f1-0000-4000-8000-0000000008f1")
		)
		(pin "3"
			(uuid "1ed008f2-0000-4000-8000-0000000008f2")
		)
		(pin "4"
			(uuid "1ed008f3-0000-4000-8000-0000000008f3")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D72") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 548.64 256.54 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50048-0000-4000-8000-000000000048")
		(property "Reference" "C81"
			(at 551.18 254 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 551.18 259.08 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 548.64 256.54 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c48-0000-4000-8000-000000000c48")
		)
		(pin "2"
			(uuid "1ed50c49-0000-4000-8000-000000000c49")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C81") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 548.64 252.73) (xy 548.64 250.19))
		(stroke (width 0) (type default))
		(uuid "1ed51417-0000-4000-8000-000000001417")
	)
	(label "+5V_LED"
		(at 548.64 250.19 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51418-0000-4000-8000-000000001418")
	)
	(symbol
		(lib_id "power:GND")
		(at 548.64 260.35 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51ba0-0000-4000-8000-000000001ba0")
		(property "Reference" "#PWR_L72"
			(at 551.18 262.89 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 551.18 257.81 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 548.64 260.35 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c68-0000-4000-8000-000000001c68")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L72") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 535.94 248.92) (xy 548.64 248.92))
		(stroke (width 0) (type default))
		(uuid "1ed0188d-0000-4000-8000-00000000188d")
	)
	(wire
		(pts (xy 548.64 248.92) (xy 548.64 252.73))
		(stroke (width 0) (type default))
		(uuid "1ed0188e-0000-4000-8000-00000000188e")
	)
	(wire
		(pts (xy 535.94 264.16) (xy 548.64 264.16))
		(stroke (width 0) (type default))
		(uuid "1ed0188f-0000-4000-8000-00000000188f")
	)
	(wire
		(pts (xy 548.64 264.16) (xy 548.64 260.35))
		(stroke (width 0) (type default))
		(uuid "1ed01890-0000-4000-8000-000000001890")
	)
	(label "L72"
		(at 543.56 256.54 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed01ba8-0000-4000-8000-000000001ba8")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 312.42 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00049-0000-4000-8000-000000000049")
		(property "Reference" "D73"
			(at 312.42 271.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 312.42 292.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 312.42 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008f4-0000-4000-8000-0000000008f4")
		)
		(pin "2"
			(uuid "1ed008f5-0000-4000-8000-0000000008f5")
		)
		(pin "3"
			(uuid "1ed008f6-0000-4000-8000-0000000008f6")
		)
		(pin "4"
			(uuid "1ed008f7-0000-4000-8000-0000000008f7")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D73") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 325.12 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50049-0000-4000-8000-000000000049")
		(property "Reference" "C82"
			(at 327.66 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 327.66 284.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 325.12 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c4a-0000-4000-8000-000000000c4a")
		)
		(pin "2"
			(uuid "1ed50c4b-0000-4000-8000-000000000c4b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C82") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 325.12 278.13) (xy 325.12 275.59))
		(stroke (width 0) (type default))
		(uuid "1ed51419-0000-4000-8000-000000001419")
	)
	(label "+5V_LED"
		(at 325.12 275.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed5141a-0000-4000-8000-00000000141a")
	)
	(symbol
		(lib_id "power:GND")
		(at 325.12 285.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51ba1-0000-4000-8000-000000001ba1")
		(property "Reference" "#PWR_L73"
			(at 327.66 288.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 327.66 283.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 325.12 285.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c69-0000-4000-8000-000000001c69")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L73") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 312.42 274.32) (xy 325.12 274.32))
		(stroke (width 0) (type default))
		(uuid "1ed01891-0000-4000-8000-000000001891")
	)
	(wire
		(pts (xy 325.12 274.32) (xy 325.12 278.13))
		(stroke (width 0) (type default))
		(uuid "1ed01892-0000-4000-8000-000000001892")
	)
	(wire
		(pts (xy 312.42 289.56) (xy 325.12 289.56))
		(stroke (width 0) (type default))
		(uuid "1ed01893-0000-4000-8000-000000001893")
	)
	(wire
		(pts (xy 325.12 289.56) (xy 325.12 285.75))
		(stroke (width 0) (type default))
		(uuid "1ed01894-0000-4000-8000-000000001894")
	)
	(label "L72"
		(at 304.8 281.94 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "1ed01ba9-0000-4000-8000-000000001ba9")
	)
	(wire
		(pts (xy 320.04 281.94) (xy 332.74 281.94))
		(stroke (width 0) (type default))
		(uuid "1ed01baa-0000-4000-8000-000000001baa")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 340.36 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0004a-0000-4000-8000-00000000004a")
		(property "Reference" "D74"
			(at 340.36 271.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 340.36 292.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 340.36 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008f8-0000-4000-8000-0000000008f8")
		)
		(pin "2"
			(uuid "1ed008f9-0000-4000-8000-0000000008f9")
		)
		(pin "3"
			(uuid "1ed008fa-0000-4000-8000-0000000008fa")
		)
		(pin "4"
			(uuid "1ed008fb-0000-4000-8000-0000000008fb")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D74") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 353.06 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5004a-0000-4000-8000-00000000004a")
		(property "Reference" "C83"
			(at 355.6 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 355.6 284.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 353.06 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c4c-0000-4000-8000-000000000c4c")
		)
		(pin "2"
			(uuid "1ed50c4d-0000-4000-8000-000000000c4d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C83") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 353.06 278.13) (xy 353.06 275.59))
		(stroke (width 0) (type default))
		(uuid "1ed5141b-0000-4000-8000-00000000141b")
	)
	(label "+5V_LED"
		(at 353.06 275.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed5141c-0000-4000-8000-00000000141c")
	)
	(symbol
		(lib_id "power:GND")
		(at 353.06 285.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51ba2-0000-4000-8000-000000001ba2")
		(property "Reference" "#PWR_L74"
			(at 355.6 288.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 355.6 283.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 353.06 285.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c6a-0000-4000-8000-000000001c6a")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L74") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 340.36 274.32) (xy 353.06 274.32))
		(stroke (width 0) (type default))
		(uuid "1ed01895-0000-4000-8000-000000001895")
	)
	(wire
		(pts (xy 353.06 274.32) (xy 353.06 278.13))
		(stroke (width 0) (type default))
		(uuid "1ed01896-0000-4000-8000-000000001896")
	)
	(wire
		(pts (xy 340.36 289.56) (xy 353.06 289.56))
		(stroke (width 0) (type default))
		(uuid "1ed01897-0000-4000-8000-000000001897")
	)
	(wire
		(pts (xy 353.06 289.56) (xy 353.06 285.75))
		(stroke (width 0) (type default))
		(uuid "1ed01898-0000-4000-8000-000000001898")
	)
	(wire
		(pts (xy 347.98 281.94) (xy 360.68 281.94))
		(stroke (width 0) (type default))
		(uuid "1ed01bab-0000-4000-8000-000000001bab")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 368.3 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0004b-0000-4000-8000-00000000004b")
		(property "Reference" "D75"
			(at 368.3 271.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 368.3 292.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 368.3 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed008fc-0000-4000-8000-0000000008fc")
		)
		(pin "2"
			(uuid "1ed008fd-0000-4000-8000-0000000008fd")
		)
		(pin "3"
			(uuid "1ed008fe-0000-4000-8000-0000000008fe")
		)
		(pin "4"
			(uuid "1ed008ff-0000-4000-8000-0000000008ff")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D75") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 381 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5004b-0000-4000-8000-00000000004b")
		(property "Reference" "C84"
			(at 383.54 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 383.54 284.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 381 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c4e-0000-4000-8000-000000000c4e")
		)
		(pin "2"
			(uuid "1ed50c4f-0000-4000-8000-000000000c4f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C84") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 381 278.13) (xy 381 275.59))
		(stroke (width 0) (type default))
		(uuid "1ed5141d-0000-4000-8000-00000000141d")
	)
	(label "+5V_LED"
		(at 381 275.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed5141e-0000-4000-8000-00000000141e")
	)
	(symbol
		(lib_id "power:GND")
		(at 381 285.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51ba3-0000-4000-8000-000000001ba3")
		(property "Reference" "#PWR_L75"
			(at 383.54 288.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 383.54 283.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 381 285.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c6b-0000-4000-8000-000000001c6b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L75") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 368.3 274.32) (xy 381 274.32))
		(stroke (width 0) (type default))
		(uuid "1ed01899-0000-4000-8000-000000001899")
	)
	(wire
		(pts (xy 381 274.32) (xy 381 278.13))
		(stroke (width 0) (type default))
		(uuid "1ed0189a-0000-4000-8000-00000000189a")
	)
	(wire
		(pts (xy 368.3 289.56) (xy 381 289.56))
		(stroke (width 0) (type default))
		(uuid "1ed0189b-0000-4000-8000-00000000189b")
	)
	(wire
		(pts (xy 381 289.56) (xy 381 285.75))
		(stroke (width 0) (type default))
		(uuid "1ed0189c-0000-4000-8000-00000000189c")
	)
	(wire
		(pts (xy 375.92 281.94) (xy 388.62 281.94))
		(stroke (width 0) (type default))
		(uuid "1ed01bac-0000-4000-8000-000000001bac")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 396.24 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0004c-0000-4000-8000-00000000004c")
		(property "Reference" "D76"
			(at 396.24 271.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 396.24 292.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 396.24 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00900-0000-4000-8000-000000000900")
		)
		(pin "2"
			(uuid "1ed00901-0000-4000-8000-000000000901")
		)
		(pin "3"
			(uuid "1ed00902-0000-4000-8000-000000000902")
		)
		(pin "4"
			(uuid "1ed00903-0000-4000-8000-000000000903")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D76") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 408.94 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5004c-0000-4000-8000-00000000004c")
		(property "Reference" "C85"
			(at 411.48 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 411.48 284.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 408.94 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c50-0000-4000-8000-000000000c50")
		)
		(pin "2"
			(uuid "1ed50c51-0000-4000-8000-000000000c51")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C85") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 408.94 278.13) (xy 408.94 275.59))
		(stroke (width 0) (type default))
		(uuid "1ed5141f-0000-4000-8000-00000000141f")
	)
	(label "+5V_LED"
		(at 408.94 275.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51420-0000-4000-8000-000000001420")
	)
	(symbol
		(lib_id "power:GND")
		(at 408.94 285.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51ba4-0000-4000-8000-000000001ba4")
		(property "Reference" "#PWR_L76"
			(at 411.48 288.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 411.48 283.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 408.94 285.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c6c-0000-4000-8000-000000001c6c")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L76") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 396.24 274.32) (xy 408.94 274.32))
		(stroke (width 0) (type default))
		(uuid "1ed0189d-0000-4000-8000-00000000189d")
	)
	(wire
		(pts (xy 408.94 274.32) (xy 408.94 278.13))
		(stroke (width 0) (type default))
		(uuid "1ed0189e-0000-4000-8000-00000000189e")
	)
	(wire
		(pts (xy 396.24 289.56) (xy 408.94 289.56))
		(stroke (width 0) (type default))
		(uuid "1ed0189f-0000-4000-8000-00000000189f")
	)
	(wire
		(pts (xy 408.94 289.56) (xy 408.94 285.75))
		(stroke (width 0) (type default))
		(uuid "1ed018a0-0000-4000-8000-0000000018a0")
	)
	(wire
		(pts (xy 403.86 281.94) (xy 416.56 281.94))
		(stroke (width 0) (type default))
		(uuid "1ed01bad-0000-4000-8000-000000001bad")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 424.18 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0004d-0000-4000-8000-00000000004d")
		(property "Reference" "D77"
			(at 424.18 271.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 424.18 292.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 424.18 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00904-0000-4000-8000-000000000904")
		)
		(pin "2"
			(uuid "1ed00905-0000-4000-8000-000000000905")
		)
		(pin "3"
			(uuid "1ed00906-0000-4000-8000-000000000906")
		)
		(pin "4"
			(uuid "1ed00907-0000-4000-8000-000000000907")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D77") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 436.88 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5004d-0000-4000-8000-00000000004d")
		(property "Reference" "C86"
			(at 439.42 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 439.42 284.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 436.88 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c52-0000-4000-8000-000000000c52")
		)
		(pin "2"
			(uuid "1ed50c53-0000-4000-8000-000000000c53")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C86") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 436.88 278.13) (xy 436.88 275.59))
		(stroke (width 0) (type default))
		(uuid "1ed51421-0000-4000-8000-000000001421")
	)
	(label "+5V_LED"
		(at 436.88 275.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51422-0000-4000-8000-000000001422")
	)
	(symbol
		(lib_id "power:GND")
		(at 436.88 285.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51ba5-0000-4000-8000-000000001ba5")
		(property "Reference" "#PWR_L77"
			(at 439.42 288.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 439.42 283.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 436.88 285.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c6d-0000-4000-8000-000000001c6d")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L77") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 424.18 274.32) (xy 436.88 274.32))
		(stroke (width 0) (type default))
		(uuid "1ed018a1-0000-4000-8000-0000000018a1")
	)
	(wire
		(pts (xy 436.88 274.32) (xy 436.88 278.13))
		(stroke (width 0) (type default))
		(uuid "1ed018a2-0000-4000-8000-0000000018a2")
	)
	(wire
		(pts (xy 424.18 289.56) (xy 436.88 289.56))
		(stroke (width 0) (type default))
		(uuid "1ed018a3-0000-4000-8000-0000000018a3")
	)
	(wire
		(pts (xy 436.88 289.56) (xy 436.88 285.75))
		(stroke (width 0) (type default))
		(uuid "1ed018a4-0000-4000-8000-0000000018a4")
	)
	(wire
		(pts (xy 431.8 281.94) (xy 444.5 281.94))
		(stroke (width 0) (type default))
		(uuid "1ed01bae-0000-4000-8000-000000001bae")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 452.12 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0004e-0000-4000-8000-00000000004e")
		(property "Reference" "D78"
			(at 452.12 271.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 452.12 292.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 452.12 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00908-0000-4000-8000-000000000908")
		)
		(pin "2"
			(uuid "1ed00909-0000-4000-8000-000000000909")
		)
		(pin "3"
			(uuid "1ed0090a-0000-4000-8000-00000000090a")
		)
		(pin "4"
			(uuid "1ed0090b-0000-4000-8000-00000000090b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D78") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 464.82 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5004e-0000-4000-8000-00000000004e")
		(property "Reference" "C87"
			(at 467.36 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 467.36 284.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 464.82 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c54-0000-4000-8000-000000000c54")
		)
		(pin "2"
			(uuid "1ed50c55-0000-4000-8000-000000000c55")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C87") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 464.82 278.13) (xy 464.82 275.59))
		(stroke (width 0) (type default))
		(uuid "1ed51423-0000-4000-8000-000000001423")
	)
	(label "+5V_LED"
		(at 464.82 275.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51424-0000-4000-8000-000000001424")
	)
	(symbol
		(lib_id "power:GND")
		(at 464.82 285.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51ba6-0000-4000-8000-000000001ba6")
		(property "Reference" "#PWR_L78"
			(at 467.36 288.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 467.36 283.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 464.82 285.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c6e-0000-4000-8000-000000001c6e")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L78") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 452.12 274.32) (xy 464.82 274.32))
		(stroke (width 0) (type default))
		(uuid "1ed018a5-0000-4000-8000-0000000018a5")
	)
	(wire
		(pts (xy 464.82 274.32) (xy 464.82 278.13))
		(stroke (width 0) (type default))
		(uuid "1ed018a6-0000-4000-8000-0000000018a6")
	)
	(wire
		(pts (xy 452.12 289.56) (xy 464.82 289.56))
		(stroke (width 0) (type default))
		(uuid "1ed018a7-0000-4000-8000-0000000018a7")
	)
	(wire
		(pts (xy 464.82 289.56) (xy 464.82 285.75))
		(stroke (width 0) (type default))
		(uuid "1ed018a8-0000-4000-8000-0000000018a8")
	)
	(wire
		(pts (xy 459.74 281.94) (xy 472.44 281.94))
		(stroke (width 0) (type default))
		(uuid "1ed01baf-0000-4000-8000-000000001baf")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 480.06 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed0004f-0000-4000-8000-00000000004f")
		(property "Reference" "D79"
			(at 480.06 271.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 480.06 292.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 480.06 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed0090c-0000-4000-8000-00000000090c")
		)
		(pin "2"
			(uuid "1ed0090d-0000-4000-8000-00000000090d")
		)
		(pin "3"
			(uuid "1ed0090e-0000-4000-8000-00000000090e")
		)
		(pin "4"
			(uuid "1ed0090f-0000-4000-8000-00000000090f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D79") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 492.76 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed5004f-0000-4000-8000-00000000004f")
		(property "Reference" "C88"
			(at 495.3 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 495.3 284.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 492.76 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c56-0000-4000-8000-000000000c56")
		)
		(pin "2"
			(uuid "1ed50c57-0000-4000-8000-000000000c57")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C88") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 492.76 278.13) (xy 492.76 275.59))
		(stroke (width 0) (type default))
		(uuid "1ed51425-0000-4000-8000-000000001425")
	)
	(label "+5V_LED"
		(at 492.76 275.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51426-0000-4000-8000-000000001426")
	)
	(symbol
		(lib_id "power:GND")
		(at 492.76 285.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51ba7-0000-4000-8000-000000001ba7")
		(property "Reference" "#PWR_L79"
			(at 495.3 288.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 495.3 283.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 492.76 285.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c6f-0000-4000-8000-000000001c6f")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L79") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 480.06 274.32) (xy 492.76 274.32))
		(stroke (width 0) (type default))
		(uuid "1ed018a9-0000-4000-8000-0000000018a9")
	)
	(wire
		(pts (xy 492.76 274.32) (xy 492.76 278.13))
		(stroke (width 0) (type default))
		(uuid "1ed018aa-0000-4000-8000-0000000018aa")
	)
	(wire
		(pts (xy 480.06 289.56) (xy 492.76 289.56))
		(stroke (width 0) (type default))
		(uuid "1ed018ab-0000-4000-8000-0000000018ab")
	)
	(wire
		(pts (xy 492.76 289.56) (xy 492.76 285.75))
		(stroke (width 0) (type default))
		(uuid "1ed018ac-0000-4000-8000-0000000018ac")
	)
	(wire
		(pts (xy 487.68 281.94) (xy 500.38 281.94))
		(stroke (width 0) (type default))
		(uuid "1ed01bb0-0000-4000-8000-000000001bb0")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 508 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00050-0000-4000-8000-000000000050")
		(property "Reference" "D80"
			(at 508 271.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 508 292.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 508 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00910-0000-4000-8000-000000000910")
		)
		(pin "2"
			(uuid "1ed00911-0000-4000-8000-000000000911")
		)
		(pin "3"
			(uuid "1ed00912-0000-4000-8000-000000000912")
		)
		(pin "4"
			(uuid "1ed00913-0000-4000-8000-000000000913")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D80") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 520.7 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50050-0000-4000-8000-000000000050")
		(property "Reference" "C89"
			(at 523.24 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 523.24 284.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 520.7 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c58-0000-4000-8000-000000000c58")
		)
		(pin "2"
			(uuid "1ed50c59-0000-4000-8000-000000000c59")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C89") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 520.7 278.13) (xy 520.7 275.59))
		(stroke (width 0) (type default))
		(uuid "1ed51427-0000-4000-8000-000000001427")
	)
	(label "+5V_LED"
		(at 520.7 275.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed51428-0000-4000-8000-000000001428")
	)
	(symbol
		(lib_id "power:GND")
		(at 520.7 285.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51ba8-0000-4000-8000-000000001ba8")
		(property "Reference" "#PWR_L80"
			(at 523.24 288.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 523.24 283.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 520.7 285.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c70-0000-4000-8000-000000001c70")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L80") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 508 274.32) (xy 520.7 274.32))
		(stroke (width 0) (type default))
		(uuid "1ed018ad-0000-4000-8000-0000000018ad")
	)
	(wire
		(pts (xy 520.7 274.32) (xy 520.7 278.13))
		(stroke (width 0) (type default))
		(uuid "1ed018ae-0000-4000-8000-0000000018ae")
	)
	(wire
		(pts (xy 508 289.56) (xy 520.7 289.56))
		(stroke (width 0) (type default))
		(uuid "1ed018af-0000-4000-8000-0000000018af")
	)
	(wire
		(pts (xy 520.7 289.56) (xy 520.7 285.75))
		(stroke (width 0) (type default))
		(uuid "1ed018b0-0000-4000-8000-0000000018b0")
	)
	(wire
		(pts (xy 515.62 281.94) (xy 528.32 281.94))
		(stroke (width 0) (type default))
		(uuid "1ed01bb1-0000-4000-8000-000000001bb1")
	)
	(symbol
		(lib_id "LED:WS2812B")
		(at 535.94 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00051-0000-4000-8000-000000000051")
		(property "Reference" "D81"
			(at 535.94 271.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "WS2812B"
			(at 535.94 292.1 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"
			(at 535.94 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed00914-0000-4000-8000-000000000914")
		)
		(pin "2"
			(uuid "1ed00915-0000-4000-8000-000000000915")
		)
		(pin "3"
			(uuid "1ed00916-0000-4000-8000-000000000916")
		)
		(pin "4"
			(uuid "1ed00917-0000-4000-8000-000000000917")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "D81") (unit 1))
			)
		)
	)
	(symbol
		(lib_id "Device:C")
		(at 548.64 281.94 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed50051-0000-4000-8000-000000000051")
		(property "Reference" "C90"
			(at 551.18 279.4 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "100nF"
			(at 551.18 284.48 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
			(at 548.64 281.94 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed50c5a-0000-4000-8000-000000000c5a")
		)
		(pin "2"
			(uuid "1ed50c5b-0000-4000-8000-000000000c5b")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "C90") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 548.64 278.13) (xy 548.64 275.59))
		(stroke (width 0) (type default))
		(uuid "1ed51429-0000-4000-8000-000000001429")
	)
	(label "+5V_LED"
		(at 548.64 275.59 90)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed5142a-0000-4000-8000-00000000142a")
	)
	(symbol
		(lib_id "power:GND")
		(at 548.64 285.75 180)
		(unit 1)
		(exclude_from_sim no)
		(in_bom no)
		(on_board no)
		(dnp no)
		(uuid "1ed51ba9-0000-4000-8000-000000001ba9")
		(property "Reference" "#PWR_L81"
			(at 551.18 288.29 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "GND"
			(at 551.18 283.21 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" ""
			(at 548.64 285.75 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed51c71-0000-4000-8000-000000001c71")
		)
		(instances
			(project "openchess-board"
				(path "/" (reference "#PWR_L81") (unit 1))
			)
		)
	)
	(wire
		(pts (xy 535.94 274.32) (xy 548.64 274.32))
		(stroke (width 0) (type default))
		(uuid "1ed018b1-0000-4000-8000-0000000018b1")
	)
	(wire
		(pts (xy 548.64 274.32) (xy 548.64 278.13))
		(stroke (width 0) (type default))
		(uuid "1ed018b2-0000-4000-8000-0000000018b2")
	)
	(wire
		(pts (xy 535.94 289.56) (xy 548.64 289.56))
		(stroke (width 0) (type default))
		(uuid "1ed018b3-0000-4000-8000-0000000018b3")
	)
	(wire
		(pts (xy 548.64 289.56) (xy 548.64 285.75))
		(stroke (width 0) (type default))
		(uuid "1ed018b4-0000-4000-8000-0000000018b4")
	)
	(label "LED_DOUT_END"
		(at 543.56 281.94 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed01bb2-0000-4000-8000-000000001bb2")
	)
