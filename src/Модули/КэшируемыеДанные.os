Перем ТекстШаблонаПроксиОбъекта;
Перем ТекстШаблонаПроксиМетода;

// Текст шаблона с содержимым сценария прокси-объекта
//
//  Возвращаемое значение:
//   Строка - Текст сценария
//
Функция ТекстШаблонаПроксиОбъекта() Экспорт
	Если ТекстШаблонаПроксиОбъекта = Неопределено Тогда
		ТекстШаблонаПроксиОбъекта = ПрочитатьТекстШаблона("ШаблонПрокси.os");
	КонецЕсли;
	
	Возврат ТекстШаблонаПроксиОбъекта;
КонецФункции

Функция ТекстШаблонаПроксиМетода() Экспорт
	Если ТекстШаблонаПроксиМетода = Неопределено Тогда
		ТекстШаблонаПроксиМетода = ПрочитатьТекстШаблона("ШаблонПроксиМетода.os_template");
	КонецЕсли;
	
	Возврат ТекстШаблонаПроксиМетода;
КонецФункции

Функция ПрочитатьТекстШаблона(ИмяШаблона)
	КаталогТекущегоСценария = ТекущийСценарий().Каталог;
	ПутьКШаблонуПрокси = ОбъединитьПути(
		КаталогТекущегоСценария,
		"../internal",
		"Классы",
		ИмяШаблона
	);
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ПутьКШаблонуПрокси, КодировкаТекста.UTF8NoBom);
	ТекстШаблонаПрокси = ТекстовыйДокумент.ПолучитьТекст();
	ТекстовыйДокумент = Неопределено;

	Возврат ТекстШаблонаПрокси;
КонецФункции