Функция ОписаниеЗначения(Значение) Экспорт

	Если Значение = Неопределено Тогда
		Возврат "Неопределено";
	ИначеЕсли ТипЗнч(Значение) = Тип("Строка") Тогда
		Возврат СтрШаблон("""%1""", Значение);
	ИначеЕсли ТипЗнч(Значение) = Тип("Булево") Тогда
		Возврат Формат(Значение, "БЛ=Ложь; БИ=Истина");
	ИначеЕсли ТипЗнч(Значение) = Тип("Дата") Тогда
		Возврат Формат(Значение, "ДФ=yyyyMMdd");	
	Иначе
		Возврат Строка(Значение);
	КонецЕсли;

КонецФункции
