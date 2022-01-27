EGPD2 = EGPD2 or {}


function EGPD2.Initlsgil2Buttons()
	local ButtonPosY = 32
	lsglil2.NewObject("ButtonTypeBox", "button")
	lsglil2.SetObjectPosition("ButtonTypeBox", 4, ButtonPosY)
	lsglil2.SetObjectScale("ButtonTypeBox", 118, 32)
	lsglil2.SetObjectData("ButtonTypeBox", "text", "Box")
	lsglil2.SetObjectData("ButtonTypeBox", "col", {0.2, 0.4, 0.2})
	lsglil2.SetObjectData("ButtonTypeBox", "onPress", function(GUITime)
		EGPD2.CurrObjectType = "box"
	end)
	ButtonPosY = ButtonPosY + 40


	lsglil2.NewObject("ButtonTypeCircle", "button")
	lsglil2.SetObjectPosition("ButtonTypeCircle", 4, ButtonPosY)
	lsglil2.SetObjectScale("ButtonTypeCircle", 118, 32)
	lsglil2.SetObjectData("ButtonTypeCircle", "text", "Circle")
	lsglil2.SetObjectData("ButtonTypeCircle", "col", {0.2, 0.4, 0.2})
	lsglil2.SetObjectData("ButtonTypeCircle", "onPress", function(GUITime)
		EGPD2.CurrObjectType = "circle"
	end)
	ButtonPosY = ButtonPosY + 40


	lsglil2.NewObject("ButtonTypeAutoPoly", "button")
	lsglil2.SetObjectPosition("ButtonTypeAutoPoly", 4, ButtonPosY)
	lsglil2.SetObjectScale("ButtonTypeAutoPoly", 118, 32)
	lsglil2.SetObjectData("ButtonTypeAutoPoly", "text", "Polygon (Auto)")
	lsglil2.SetObjectData("ButtonTypeAutoPoly", "col", {0.2, 0.2, 0.4})
	lsglil2.SetObjectData("ButtonTypeAutoPoly", "onPress", function(GUITime)
		EGPD2.CurrObjectType = "poly"
	end)
	ButtonPosY = ButtonPosY + 40


	lsglil2.NewObject("ButtonTypeLine", "button")
	lsglil2.SetObjectPosition("ButtonTypeLine", 4, ButtonPosY)
	lsglil2.SetObjectScale("ButtonTypeLine", 118, 32)
	lsglil2.SetObjectData("ButtonTypeLine", "text", "Line")
	lsglil2.SetObjectData("ButtonTypeLine", "col", {0.4, 0.2, 0.2})
	lsglil2.SetObjectData("ButtonTypeLine", "onPress", function(GUITime)
		EGPD2.CurrObjectType = "line"
	end)
	ButtonPosY = ButtonPosY + 40


	lsglil2.NewObject("ButtonTypeText", "button")
	lsglil2.SetObjectPosition("ButtonTypeText", 4, ButtonPosY)
	lsglil2.SetObjectScale("ButtonTypeText", 118, 32)
	lsglil2.SetObjectData("ButtonTypeText", "text", "Text")
	lsglil2.SetObjectData("ButtonTypeText", "col", {0.4, 0.4, 0.2})
	lsglil2.SetObjectData("ButtonTypeText", "onPress", function(GUITime)
		EGPD2.CurrObjectType = "text"
	end)
	ButtonPosY = ButtonPosY + 40

	lsglil2.NewObject("ButtonSaveAsEGD", "button")
	lsglil2.SetObjectPosition("ButtonSaveAsEGD", 4, 516)
	lsglil2.SetObjectScale("ButtonSaveAsEGD", 118, 56)
	lsglil2.SetObjectData("ButtonSaveAsEGD", "text", "Save as .egd")
	lsglil2.SetObjectData("ButtonSaveAsEGD", "col", {0.0, 0.4, 0.0})
	lsglil2.SetObjectData("ButtonSaveAsEGD", "onPress", function(GUITime)
		local fine, err = pcall(EGPD2.Exporters.Text.Export, lsglil2.GetObjectData("TextEntryName")["text"])
		if not fine then
			print("error exporting EGD!; " .. err)
		end
	end)


	lsglil2.NewObject("ButtonLoadEGD", "button")
	lsglil2.SetObjectPosition("ButtonLoadEGD", 4, 576 + 4)
	lsglil2.SetObjectScale("ButtonLoadEGD", 118, 56)
	lsglil2.SetObjectData("ButtonLoadEGD", "text", "Load from .egd")
	lsglil2.SetObjectData("ButtonLoadEGD", "col", {0.0, 0.0, 0.4})
	lsglil2.SetObjectData("ButtonLoadEGD", "onPress", function(GUITime)
		EGPD2.Importer.Import(lsglil2.GetObjectData("TextEntryName")["text"])
		local fine, err = pcall(EGPD2.Importer.Import, lsglil2.GetObjectData("TextEntryName")["text"])
		if not fine then
			print("error loading EGD!; " .. err)
		end
	end)

	lsglil2.NewObject("ButtonExportAsEGP", "button")
	lsglil2.SetObjectPosition("ButtonExportAsEGP", 128, 512 + 28)
	lsglil2.SetObjectScale("ButtonExportAsEGP", 118, 32)
	lsglil2.SetObjectData("ButtonExportAsEGP", "text", "Export to EGP")
	lsglil2.SetObjectData("ButtonExportAsEGP", "col", {0.1, 0.2, 0.3})
	lsglil2.SetObjectData("ButtonExportAsEGP", "onPress", function(GUITime)
		local fine, err = pcall(EGPD2.Exporters.EGP.Export, lsglil2.GetObjectData("TextEntryName")["text"])
		if not fine then
			print("error exporting EGP!; " .. err)
		end
	end)

	lsglil2.NewObject("ButtonExportAsGPU", "button")
	lsglil2.SetObjectPosition("ButtonExportAsGPU", 128, 512 + 68)
	lsglil2.SetObjectScale("ButtonExportAsGPU", 118, 32)
	lsglil2.SetObjectData("ButtonExportAsGPU", "text", "Export to wireGPU")
	lsglil2.SetObjectData("ButtonExportAsGPU", "col", {0.1, 0.3, 0.2})
	lsglil2.SetObjectData("ButtonExportAsGPU", "onPress", function(GUITime)
		local fine, err = pcall(EGPD2.Exporters.GPU.Export, lsglil2.GetObjectData("TextEntryName")["text"])
		if not fine then
			print("error exporting GPU!; " .. err)
		end
	end)

	lsglil2.NewObject("TextEntryName", "textentry")
	lsglil2.SetObjectPosition("TextEntryName", 128, 512 + 2)
	lsglil2.SetObjectScale("TextEntryName", 512, 16)
	lsglil2.SetObjectData("TextEntryName", "col", {0.4, 0.4, 0.4})
	lsglil2.SetObjectData("TextEntryName", "backgroundtext", "Enter name here...")
	lsglil2.SetObjectData("TextEntryName", "releasecall", function(edata)
		local str = string.lower(edata["text"])
		local fstring = string.gsub(str, "[%p%s%c]", "")
		edata["text"] = fstring
		EGPD2.ExportName = fstring
	end)

	lsglil2.NewObject("TextEntryTransparencyLabel", "label")
	lsglil2.SetObjectPosition("TextEntryTransparencyLabel", 512 + 128 + 16, 514)
	lsglil2.SetObjectScale("TextEntryTransparencyLabel", 92, 16)
	lsglil2.SetObjectData("TextEntryTransparencyLabel", "text", "Render Transparency")

	lsglil2.NewObject("TextEntryTransparency", "textentry")
	lsglil2.SetObjectPosition("TextEntryTransparency", 512 + 128 + 47, 546)
	lsglil2.SetObjectScale("TextEntryTransparency", 32, 16)
	lsglil2.SetObjectData("TextEntryTransparency", "col", {0.4, 0.4, 0.4})
	lsglil2.SetObjectData("TextEntryTransparency", "backgroundtext", "int")
	lsglil2.SetObjectData("TextEntryTransparency", "text", EGPD2.RenderTransparency)
	lsglil2.SetObjectData("TextEntryTransparency", "releasecall", function(edata)
		local str = string.lower(edata["text"])
		local fnum = EGPD2.FormatStringToNum(str)
		edata["text"] = fnum
		EGPD2.RenderTransparency = fnum
	end)

end
