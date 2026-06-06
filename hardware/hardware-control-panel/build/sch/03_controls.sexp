	(symbol
		(lib_id "Device:R")
		(at 170.18 76.2 90)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00064-0000-4000-8000-000000000064")
		(property "Reference" "R1"
			(at 167.64 68.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "1k"
			(at 167.64 83.82 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Resistor_SMD:R_0805_2012Metric"
			(at 170.18 76.2 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed000c8-0000-4000-8000-0000000000c8")
		)
		(pin "2"
			(uuid "1ed000c9-0000-4000-8000-0000000000c9")
		)
		(instances
			(project "openchess-control-panel"
				(path "/" (reference "R1") (unit 1))
			)
		)
	)
	(label "+3V3"
		(at 166.37 76.2 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "1ed0012c-0000-4000-8000-00000000012c")
	)
	(label "LED_PWR_A"
		(at 173.99 76.2 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed0012d-0000-4000-8000-00000000012d")
	)
	(symbol
		(lib_id "Device:LED")
		(at 195.58 76.2 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00190-0000-4000-8000-000000000190")
		(property "Reference" "D1"
			(at 193.04 68.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "PWR"
			(at 193.04 83.82 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_0805_2012Metric"
			(at 195.58 76.2 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed001f4-0000-4000-8000-0000000001f4")
		)
		(pin "2"
			(uuid "1ed001f5-0000-4000-8000-0000000001f5")
		)
		(instances
			(project "openchess-control-panel"
				(path "/" (reference "D1") (unit 1))
			)
		)
	)
	(label "LED_PWR_N"
		(at 191.77 76.2 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "1ed0012e-0000-4000-8000-00000000012e")
	)
	(label "LED_PWR_A"
		(at 199.39 76.2 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed0012f-0000-4000-8000-00000000012f")
	)
	(symbol
		(lib_id "Device:R")
		(at 215.9 76.2 90)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00065-0000-4000-8000-000000000065")
		(property "Reference" "R2"
			(at 213.36 68.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "1k"
			(at 213.36 83.82 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Resistor_SMD:R_0805_2012Metric"
			(at 215.9 76.2 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed000ca-0000-4000-8000-0000000000ca")
		)
		(pin "2"
			(uuid "1ed000cb-0000-4000-8000-0000000000cb")
		)
		(instances
			(project "openchess-control-panel"
				(path "/" (reference "R2") (unit 1))
			)
		)
	)
	(label "+3V3"
		(at 212.09 76.2 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "1ed00130-0000-4000-8000-000000000130")
	)
	(label "LED_CONN_A"
		(at 219.71 76.2 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed00131-0000-4000-8000-000000000131")
	)
	(symbol
		(lib_id "Device:LED")
		(at 241.3 76.2 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00191-0000-4000-8000-000000000191")
		(property "Reference" "D2"
			(at 238.76 68.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "CONN"
			(at 238.76 83.82 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_0805_2012Metric"
			(at 241.3 76.2 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed001f6-0000-4000-8000-0000000001f6")
		)
		(pin "2"
			(uuid "1ed001f7-0000-4000-8000-0000000001f7")
		)
		(instances
			(project "openchess-control-panel"
				(path "/" (reference "D2") (unit 1))
			)
		)
	)
	(label "LED_CONN_N"
		(at 237.49 76.2 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "1ed00132-0000-4000-8000-000000000132")
	)
	(label "LED_CONN_A"
		(at 245.11 76.2 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed00133-0000-4000-8000-000000000133")
	)
	(symbol
		(lib_id "Device:R")
		(at 261.62 76.2 90)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00066-0000-4000-8000-000000000066")
		(property "Reference" "R3"
			(at 259.08 68.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "1k"
			(at 259.08 83.82 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Resistor_SMD:R_0805_2012Metric"
			(at 261.62 76.2 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed000cc-0000-4000-8000-0000000000cc")
		)
		(pin "2"
			(uuid "1ed000cd-0000-4000-8000-0000000000cd")
		)
		(instances
			(project "openchess-control-panel"
				(path "/" (reference "R3") (unit 1))
			)
		)
	)
	(label "+3V3"
		(at 257.81 76.2 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "1ed00134-0000-4000-8000-000000000134")
	)
	(label "LED_BATT_A"
		(at 265.43 76.2 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed00135-0000-4000-8000-000000000135")
	)
	(symbol
		(lib_id "Device:LED")
		(at 287.02 76.2 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "1ed00192-0000-4000-8000-000000000192")
		(property "Reference" "D3"
			(at 284.48 68.58 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "BATT"
			(at 284.48 83.82 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "LED_SMD:LED_0805_2012Metric"
			(at 287.02 76.2 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "1ed001f8-0000-4000-8000-0000000001f8")
		)
		(pin "2"
			(uuid "1ed001f9-0000-4000-8000-0000000001f9")
		)
		(instances
			(project "openchess-control-panel"
				(path "/" (reference "D3") (unit 1))
			)
		)
	)
	(label "LED_BATT_N"
		(at 283.21 76.2 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "1ed00136-0000-4000-8000-000000000136")
	)
	(label "LED_BATT_A"
		(at 290.83 76.2 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "1ed00137-0000-4000-8000-000000000137")
	)
	(symbol
		(lib_id "Switch:SW_Push")
		(at 182.88 137.16 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "b00702bc-0000-4000-8000-0000000002bc")
		(property "Reference" "SW1"
			(at 180.34 129.54 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "POWER"
			(at 180.34 144.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Button_Switch_SMD:SW_SPST_TL3342"
			(at 182.88 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "b0070320-0000-4000-8000-000000000320")
		)
		(pin "2"
			(uuid "b0070321-0000-4000-8000-000000000321")
		)
		(instances
			(project "openchess-control-panel"
				(path "/" (reference "SW1") (unit 1))
			)
		)
	)
	(label "BTN_POWER"
		(at 177.8 137.16 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "b0070384-0000-4000-8000-000000000384")
	)
	(label "GND"
		(at 187.96 137.16 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "b0070385-0000-4000-8000-000000000385")
	)
	(symbol
		(lib_id "Switch:SW_Push")
		(at 228.6 137.16 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "b00702bd-0000-4000-8000-0000000002bd")
		(property "Reference" "SW2"
			(at 226.06 129.54 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "MODE"
			(at 226.06 144.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Button_Switch_SMD:SW_SPST_TL3342"
			(at 228.6 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "b0070322-0000-4000-8000-000000000322")
		)
		(pin "2"
			(uuid "b0070323-0000-4000-8000-000000000323")
		)
		(instances
			(project "openchess-control-panel"
				(path "/" (reference "SW2") (unit 1))
			)
		)
	)
	(label "BTN_MODE"
		(at 223.52 137.16 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "b0070386-0000-4000-8000-000000000386")
	)
	(label "GND"
		(at 233.68 137.16 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "b0070387-0000-4000-8000-000000000387")
	)
	(symbol
		(lib_id "Switch:SW_Push")
		(at 274.32 137.16 0)
		(unit 1)
		(exclude_from_sim no)
		(in_bom yes)
		(on_board yes)
		(dnp no)
		(uuid "b00702be-0000-4000-8000-0000000002be")
		(property "Reference" "SW3"
			(at 271.78 129.54 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Value" "RESET"
			(at 271.78 144.78 0)
			(effects (font (size 1.27 1.27)) (justify left))
		)
		(property "Footprint" "Button_Switch_SMD:SW_SPST_TL3342"
			(at 274.32 137.16 0)
			(effects (font (size 1.27 1.27)) (hide yes))
		)
		(pin "1"
			(uuid "b0070324-0000-4000-8000-000000000324")
		)
		(pin "2"
			(uuid "b0070325-0000-4000-8000-000000000325")
		)
		(instances
			(project "openchess-control-panel"
				(path "/" (reference "SW3") (unit 1))
			)
		)
	)
	(label "BTN_RESET"
		(at 269.24 137.16 180)
		(effects (font (size 1.27 1.27)) (justify right bottom))
		(uuid "b0070388-0000-4000-8000-000000000388")
	)
	(label "GND"
		(at 279.4 137.16 0)
		(effects (font (size 1.27 1.27)) (justify left bottom))
		(uuid "b0070389-0000-4000-8000-000000000389")
	)
