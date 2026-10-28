"""Compara conceptos calculados por Swift con los valores guardados del Excel."""
import json
import sys
from decimal import Decimal
from zipfile import ZipFile
from xml.etree import ElementTree as ET

ns = {"s": "http://schemas.openxmlformats.org/spreadsheetml/2006/main"}
excel, resultados = sys.argv[1:3]
with open(resultados, encoding="utf-8") as archivo:
    casos = json.load(archivo)
columnas = ["B", "C", "D", "E", "G", "H", "I", "J", "K", "F", "L", "M", "N", "O"]
with ZipFile(excel) as z:
    libro = ET.fromstring(z.read("xl/workbook.xml"))
    nombres = [s.attrib["name"] for s in libro.find("s:sheets", ns)]
    assert nombres == ["Parámetros", "Boleta", "Casos", "Explicación", "Gráficos"], nombres
    hoja = ET.fromstring(z.read("xl/worksheets/sheet3.xml"))
    celdas = {c.attrib["r"]: c for c in hoja.findall(".//s:c", ns)}
    for i, caso in enumerate(casos[:6]):
        for columna, esperado in zip(columnas, caso["valores"]):
            referencia = columna + str(15 + i)
            celda = celdas[referencia]
            assert celda.find("s:f", ns) is not None, referencia + " no tiene fórmula"
            valor = Decimal(celda.find("s:v", ns).text)
            assert abs(valor - Decimal(esperado)) < Decimal("0.00001"), (referencia, valor, esperado)
    boleta = ET.fromstring(z.read("xl/worksheets/sheet2.xml"))
    celdas_boleta = {c.attrib["r"]: c for c in boleta.findall(".//s:c", ns)}
    referencias = ["B23", "B24", "B25", "B26", "B31", "B32", "B33", "B34", "B35", "B27", "B36", "A43", "B40", "B41"]
    for referencia, esperado in zip(referencias, casos[6]["valores"]):
        celda = celdas_boleta[referencia]
        assert celda.find("s:f", ns) is not None, referencia
        valor = Decimal(celda.find("s:v", ns).text)
        assert abs(valor - Decimal(esperado)) < Decimal("0.00001"), (referencia, valor, esperado)
    for nombre in z.namelist():
        if nombre.startswith("xl/worksheets/sheet") and nombre.endswith(".xml"):
            doc = ET.fromstring(z.read(nombre))
            errores = [c.attrib["r"] for c in doc.findall(".//s:c", ns) if c.attrib.get("t") == "e"]
            assert not errores, (nombre, errores)
print("Control cruzado: seis casos y Boleta activa; 98 importes coinciden al centavo.")
