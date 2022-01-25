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

	lsglil2.NewObject("ButtonTypeTriangle", "button")
	lsglil2.SetObjectPosition("ButtonTypeTriangle", 4, ButtonPosY)
	lsglil2.SetObjectScale("ButtonTypeTriangle", 118, 32)
	lsglil2.SetObjectData("ButtonTypeTriangle", "text", "Triangle")
	lsglil2.SetObjectData("ButtonTypeTriangle", "col", {0.2, 0.4, 0.2})
	lsglil2.SetObjectData("ButtonTypeTriangle", "onPress", function(GUITime)
		EGPD2.CurrObjectType = "triangle"
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
		EGPD2.Exporters.Text.Export(lsglil2.GetObjectData("TextEntryName")["text"])
	end)
	

	lsglil2.NewObject("ButtonLoadEGD", "button")
	lsglil2.SetObjectPosition("ButtonLoadEGD", 4, 576 + 4)
	lsglil2.SetObjectScale("ButtonLoadEGD", 118, 56)
	lsglil2.SetObjectData("ButtonLoadEGD", "text", "Load from .egd")
	lsglil2.SetObjectData("ButtonLoadEGD", "col", {0.0, 0.0, 0.4})
	lsglil2.SetObjectData("ButtonLoadEGD", "onPress", function(GUITime)
		EGPD2.Importer.Import(lsglil2.GetObjectData("TextEntryName")["text"])
	end)

	lsglil2.NewObject("ButtonExportAsEGP", "button")
	lsglil2.SetObjectPosition("ButtonExportAsEGP", 128, 512 + 28)
	lsglil2.SetObjectScale("ButtonExportAsEGP", 118, 32)
	lsglil2.SetObjectData("ButtonExportAsEGP", "text", "Export to EGP")
	lsglil2.SetObjectData("ButtonExportAsEGP", "col", {0.1, 0.2, 0.3})
	lsglil2.SetObjectData("ButtonExportAsEGP", "onPress", function(GUITime)
		EGPD2.Exporters.EGP.Export(lsglil2.GetObjectData("TextEntryName")["text"])
	end)

	lsglil2.NewObject("ButtonExportAsGPU", "button")
	lsglil2.SetObjectPosition("ButtonExportAsGPU", 128, 512 + 68)
	lsglil2.SetObjectScale("ButtonExportAsGPU", 118, 32)
	lsglil2.SetObjectData("ButtonExportAsGPU", "text", "Export to wireGPU")
	lsglil2.SetObjectData("ButtonExportAsGPU", "col", {0.1, 0.3, 0.2})
	lsglil2.SetObjectData("ButtonExportAsGPU", "onPress", function(GUITime)
		EGPD2.Exporters.GPU.Export(lsglil2.GetObjectData("TextEntryName")["text"])
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
end
