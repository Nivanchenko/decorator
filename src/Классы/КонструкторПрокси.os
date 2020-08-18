#Использовать logos

// Инстанс логгера
Перем Лог;

// Ссылка на исходный объект
Перем ИсходныйОбъект;

// Ссылка на конструируемый прокси-объект
Перем ПроксиОбъект;

// Таблица добавленных пользователем методов
Перем ПользовательскиеМетоды;

// Флаг поддержки аннотаций в рефлекторе
Перем АннотацииПоддерживаются;

#Область ПрограммныйИнтерфейс

Функция ДобавитьМетод(ИмяМетода, ТекстМетода) Экспорт

	НовыйМетод = ПользовательскиеМетоды.Добавить();
	НовыйМетод.ИмяМетода = ИмяМетода;
	НовыйМетод.ПараметрыМетода = Новый Массив;
	НовыйМетод.ТекстМетода = ТекстМетода;

	Возврат ЭтотОбъект;
КонецФункции

Функция Построить() Экспорт
	ТекстСценария = ПодготовитьТекстСценария();
	ПроксиОбъект = СоздатьПроксиОбъект(ТекстСценария);
	Возврат ПроксиОбъект;
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПриСозданииОбъекта(Объект)
	ИсходныйОбъект = Объект;
	Лог = Логирование.ПолучитьЛог("oscript.lib.proxy");
	
	ПользовательскиеМетоды = Новый ТаблицаЗначений();
	ПользовательскиеМетоды.Колонки.Добавить("ИмяМетода");
	ПользовательскиеМетоды.Колонки.Добавить("ПараметрыМетода");
	ПользовательскиеМетоды.Колонки.Добавить("ТекстМетода");

	Рефлектор = Новый Рефлектор;
	Методы = Рефлектор.ПолучитьТаблицуМетодов(ИсходныйОбъект);

	АннотацииПоддерживаются = Истина;
	Если Методы.Колонки.Найти("Аннотации") = Неопределено Тогда
		АннотацииПоддерживаются = Ложь;
	КонецЕсли;
КонецПроцедуры

Функция ПодготовитьТекстСценария()
	
	Лог.Отладка("Тип исходного объекта: %1", ТипЗнч(ИсходныйОбъект));
	Лог.Отладка("Представление исходного объекта: %1", ИсходныйОбъект);
	
	ТекстСценарияПроксиОбъекта = КэшируемыеДанные.ТекстШаблонаПроксиОбъекта();
	
	ТекстСценарияПроксиОбъекта = СтрЗаменить(ТекстСценарияПроксиОбъекта, "// {Область импортов}", ОбластьИмпортов());
	ТекстСценарияПроксиОбъекта = СтрЗаменить(ТекстСценарияПроксиОбъекта, "// {Область переменных}", ОбластьПеременных());
	ТекстСценарияПроксиОбъекта = СтрЗаменить(ТекстСценарияПроксиОбъекта, "// {Область методов}", ОбластьМетодов());
	ТекстСценарияПроксиОбъекта = СтрЗаменить(ТекстСценарияПроксиОбъекта, "// {Инициализация}", ОбластьИнициализации());
	
	Возврат ТекстСценарияПроксиОбъекта;
	
КонецФункции

Функция ОбластьИмпортов()

	ОбластьИмпортов = "";

	Возврат ОбластьИмпортов;

КонецФункции

Функция ОбластьПеременных()
	
	Рефлектор = Новый Рефлектор;
	Свойства = Рефлектор.ПолучитьТаблицуСвойств(ИсходныйОбъект);
	Лог.Отладка("Количество свойств: %1", Свойства.Количество());
	
	ОбластьПеременных = "";
	ШаблонПеременной = "Перем %1 Экспорт;" + Символы.ПС;
	Для Каждого Свойство Из Свойства Цикл
		ОбластьПеременных = ОбластьПеременных + СтрШаблон(ШаблонПеременной, Свойство.Имя);
	КонецЦикла;
	
	Возврат ОбластьПеременных;
	
КонецФункции

Функция ОбластьМетодов()
	
	ОбластьМетодов = "";

	ДобавитьПроксиМетоды(ОбластьМетодов);
	ДобавитьПользовательскиеМетоды(ОбластьМетодов);

	Возврат ОбластьМетодов;

КонецФункции

Функция ОбластьИнициализации()
	
	ОбластьИнициализации = "";
	
	Возврат ОбластьИнициализации;
	
КонецФункции

Процедура ДобавитьПроксиМетоды(ОбластьМетодов)

	Рефлектор = Новый Рефлектор;
	Методы = Рефлектор.ПолучитьТаблицуМетодов(ИсходныйОбъект);
	Лог.Отладка("Количество методов: %1", Методы.Количество());

	ШаблонМетода = КэшируемыеДанные.ТекстШаблонаПроксиМетода();

	ШаблонИмениПараметра = "Парам%1";
	ШаблонОписанияПараметра = "%1 %2 = Неопределено";
	ШаблонВыполняемаяСтрока = "Прокси_ВыполняемаяСтрока = ""Прокси_ИсходныйОбъект.%1(%2)"";";

	Для Каждого Метод Из Методы Цикл
		
		Если Не Метод.Экспорт Тогда
			Продолжить;
		КонецЕсли;
		
		МассивИменаПараметров = Новый Массив;
		МассивСтрокаПараметров = Новый Массив;
		сч = 1;
		Для Каждого ПараметрМетода Из Метод.Параметры Цикл
			сч = сч + 1;
			
			ИмяПараметра = СтрШаблон(ШаблонИмениПараметра, сч);
			МассивИменаПараметров.Добавить(ИмяПараметра);
			
			СтрокаАннотацийПараметров = ПолучитьСтрокуАннотаций(ПараметрМетода);
			МассивСтрокаПараметров.Добавить(СтрШаблон(ШаблонОписанияПараметра, СтрокаАннотацийПараметров, ИмяПараметра));
		КонецЦикла;
		
		ИмяМетода = ПолучитьИмяМетода(Метод.Имя);
		ОписаниеПараметровМетода = СтрСоединить(МассивСтрокаПараметров, ", ");
		ПараметрыВызоваМетода = СтрСоединить(МассивИменаПараметров, ", ");

		ВыполняемаяСтрока = СтрШаблон(ШаблонВыполняемаяСтрока, ИмяМетода, ПараметрыВызоваМетода);
		
		СтрокаАннотацийМетода = ПолучитьСтрокуАннотаций(Метод);
		
		ТипМетода = "Прокси_ТипМетода = " + Формат(Метод.ЭтоФункция, "БЛ=Ложь; БИ=Истина") + ";";
		ВозвращаемоеЗначение = "Возврат Прокси_ВозвращаемоеИзМетодаЗначение;";
		
		НовыйМетод = ШаблонМетода;
		НовыйМетод = СтрЗаменить(НовыйМетод, "// {АннотацияМетода}", СтрокаАннотацийМетода);
		НовыйМетод = СтрЗаменить(НовыйМетод, "Прокси_ИмяМетода", ИмяМетода);
		НовыйМетод = СтрЗаменить(НовыйМетод, "Прокси_ОписаниеПараметровМетода", ОписаниеПараметровМетода);
		НовыйМетод = СтрЗаменить(НовыйМетод, "// {Прокси_ВыполняемаяСтрока}", ВыполняемаяСтрока);
		НовыйМетод = СтрЗаменить(НовыйМетод, "// {Прокси_ТипМетода}", ТипМетода);
		НовыйМетод = СтрЗаменить(НовыйМетод, "// {Прокси_ВозвращаемоеЗначение}", ВозвращаемоеЗначение);
		НовыйМетод = НовыйМетод + Символы.ПС;
		
		ОбластьМетодов = ОбластьМетодов + НовыйМетод;
	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьПользовательскиеМетоды(ОбластьМетодов)

	ШаблонМетода = КэшируемыеДанные.ТекстШаблонаПользовательскогоМетода();

	Для Каждого Метод Из ПользовательскиеМетоды Цикл

		СтрокаАннотацийМетода = "";
		ОписаниеПараметровМетода = "";

		НовыйМетод = ШаблонМетода;
		НовыйМетод = СтрЗаменить(НовыйМетод, "// {АннотацияМетода}", СтрокаАннотацийМетода);
		НовыйМетод = СтрЗаменить(НовыйМетод, "Прокси_ИмяМетода", Метод.ИмяМетода);
		НовыйМетод = СтрЗаменить(НовыйМетод, "Прокси_ОписаниеПараметровМетода", ОписаниеПараметровМетода);
		НовыйМетод = СтрЗаменить(НовыйМетод, "// {Прокси_ТекстМетода}", Метод.ТекстМетода);

		ОбластьМетодов = ОбластьМетодов + НовыйМетод;
	КонецЦикла;

КонецПроцедуры

Функция ПолучитьСтрокуАннотаций(ВладелецАннотации)

	Если НЕ АннотацииПоддерживаются Тогда
		Возврат "";
	КонецЕсли;

	ШаблонАннотации = "&%1%2";
	СтрокаАннотаций = "";

	Если ВладелецАннотации.Аннотации = Неопределено Тогда
		Возврат СтрокаАннотаций;
	КонецЕсли;	

	КоллекцияАннотаций = Новый Соответствие;
	АннотацииСАмперсандом = Новый Массив;
	Для Каждого Аннотация Из ВладелецАннотации.Аннотации Цикл
		СтрокаПараметры = ПолучитьСтрокуПараметровАннотаций(Аннотация);
		АннотацииСАмперсандом.Добавить(СтрШаблон(ШаблонАннотации, Аннотация.Имя, СтрокаПараметры));
	КонецЦикла;	

	СтрокаАннотаций = СтрСоединить(АннотацииСАмперсандом, Символы.ПС);

	Возврат СтрокаАннотаций;
КонецФункции

Функция ПолучитьСтрокуПараметровАннотаций(Аннотация)
	СтрокаМетодов = "";
	Если Аннотация.Параметры = Неопределено Тогда
		Возврат СтрокаМетодов;
	КонецЕсли;	

	ШаблонПараметров = "%1 %2 %3";
	ПараметрыДляСтроки = Новый Массив;

	Для Каждого Параметр Из Аннотация.Параметры Цикл
		СтрокаРавно = "";
	
		Если ЗначениеЗаполнено(Параметр.Имя) И ЗначениеЗаполнено(Параметр.Значение) Тогда
			СтрокаРавно = "=";
		КонецЕсли;	
	
		ЗначенияПараметраСтрокой = ПолучитьЗначениеПараметраВСтроку(Параметр.Значение);			
		СтрокаПараметров = СтрШаблон(ШаблонПараметров, Параметр.Имя, СтрокаРавно, ЗначенияПараметраСтрокой);
		ПараметрыДляСтроки.Добавить(СтрокаПараметров);
	КонецЦикла;

	ШаблонСтроки = "(%1)";
	СтрокаМетодов = СтрСоединить(ПараметрыДляСтроки, ",");

	Возврат СтрШаблон(ШаблонСтроки, СтрокаМетодов);
КонецФункции

Функция ПолучитьЗначениеПараметраВСтроку(Знач ЗначениеПараметра)
	
	ВозвращаемоеЗначение = Неопределено;

	Если ТипЗнч(ЗначениеПараметра) = Тип("Строка") Тогда
		ВозвращаемоеЗначение = Символ(34) + ЗначениеПараметра + Символ(34) ;
	ИначеЕсли ТипЗнч(ЗначениеПараметра) = Тип("Число")	Тогда
		ВозвращаемоеЗначение = ЗначениеПараметра;
	ИначеЕсли ТипЗнч(ЗначениеПараметра) = Тип("Булево") Тогда
		ВозвращаемоеЗначение = Формат(ЗначениеПараметра, "БЛ=Ложь; БИ=Истина");
	Иначе
		ВозвращаемоеЗначение = "";
	КонецЕсли;	

	Возврат ВозвращаемоеЗначение;
КонецФункции

Функция ПолучитьИмяМетода(Знач ИмяМетода)
	ВозвращаемоеЗначение = ИмяМетода;
	ШаблонНовогоИмени = "_%1";	

	НедопустимыеИмена = Новый Массив;
	НедопустимыеИмена.Добавить("найти");

	Если НЕ НедопустимыеИмена.Найти(Нрег(ИмяМетода)) = Неопределено Тогда
		ВозвращаемоеЗначение = СтрШаблон(ШаблонНовогоИмени, ИмяМетода);
	КонецЕсли;

	Возврат ВозвращаемоеЗначение;
КонецФункции

Функция СоздатьПроксиОбъект(ТекстСценария)
	
	ИменаМетодов = Новый Соответствие;
	
	РежимСозданияИзТипа = ТипЗнч(ИсходныйОбъект) = Тип("Тип");
	
	Лог.Отладка(ТекстСценария);
	
	ПроксиОбъект = ЗагрузитьСценарийИзСтроки(ТекстСценария);
	
	ИнстансИсходногоОбъекта = Неопределено;
	Если РежимСозданияИзТипа Тогда
		Попытка
			// TODO: Параметры конструктора
			ИнстансИсходногоОбъекта = Новый(ИсходныйОбъект);
		Исключение
			ВызватьИсключение СтрШаблон("Невозможно создать объект из данного типа объекта <%1>", ИсходныйОбъект);
		КонецПопытки;
	Иначе
		ИнстансИсходногоОбъекта = ИсходныйОбъект;
	КонецЕсли;
	
	Рефлектор = Новый Рефлектор();
	Рефлектор.УстановитьСвойство(ПроксиОбъект, Константы_Прокси.Поле_ИнстансОбъекта, ИнстансИсходногоОбъекта);

	Если ИнстансИсходногоОбъекта <> Неопределено Тогда
		ОбработкаПроксиОбъекта.СинхронизироватьПоля(ИнстансИсходногоОбъекта, ПроксиОбъект);
	КонецЕсли;
	
	Возврат ПроксиОбъект;
	
КонецФункции

#КонецОбласти
