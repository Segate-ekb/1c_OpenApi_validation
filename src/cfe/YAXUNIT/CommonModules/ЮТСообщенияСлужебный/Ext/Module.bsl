﻿//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2024 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область СлужебныйПрограммныйИнтерфейс

// Форматированный текст ошибки утверждения.
// 
// Параметры:
//  ОписаниеПроверки - см. ЮТФабрикаСлужебный.ОписаниеПроверки
//  ТекстОжидания - Строка - Описание ожидания
//  ОбъектПроверки - Строка - Объект проверки
// 
// Возвращаемое значение:
//  Строка - Форматированный текст ошибки утверждения
Функция ФорматированныйТекстОшибкиУтверждения(Знач ОписаниеПроверки, ТекстОжидания, ОбъектПроверки) Экспорт
	
	Если ТипЗнч(ОписаниеПроверки.ОбъектПроверки.ИмяСвойства) = Тип("Число") Тогда
		
		ВставкаСвойствоИндекс = СтрШаблон(" содержит значение по индексу `%1`, которое", ОписаниеПроверки.ОбъектПроверки.ИмяСвойства);
	
	ИначеЕсли ЗначениеЗаполнено(ОписаниеПроверки.ОбъектПроверки.ИмяСвойства) Тогда
	
		ВставкаСвойствоИндекс = СтрШаблон(" содержит свойство `%1`, которое", ОписаниеПроверки.ОбъектПроверки.ИмяСвойства);
	
	Иначе
		ВставкаСвойствоИндекс = "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеПроверки.ОбъектПроверки.Представление) Тогда
		ПредставлениеЗначения = ОписаниеПроверки.ОбъектПроверки.Представление;
	Иначе
		ПредставлениеЗначения = ПредставлениеЗначения(ОписаниеПроверки.ОбъектПроверки.Значение);
	КонецЕсли;
	
	// Заголовок сообщения
	ТекстСообщения = "";
	
	// Тело сообщения
	ТекстСообщения = СтрШаблон("ожидали, что %1 %2%3 %4, но это не так.",
	                           ОбъектПроверки,
	                           ПредставлениеЗначения,
	                           ВставкаСвойствоИндекс,
	                           ТекстОжидания);
	
	Возврат ТекстСообщения;
	
КонецФункции

// Сообщение об ошибке события.
// 
// Параметры:
//  ИмяСобытия - Строка
//  Ошибка - Строка - Текст ошибки
//         - ИнформацияОбОшибке - ошибка выполнения
// 
// Возвращаемое значение:
//  Строка -  Сообщение об ошибке события
Функция СообщениеОбОшибкеСобытия(ИмяСобытия, Ошибка) Экспорт
	
	ТипОшибки = ЮТФабрикаСлужебный.ТипыОшибок().ОшибкаОбработкиСобытия;
	Возврат СтрШаблон("%1 '%2': %3", ТипОшибки, ИмяСобытия, КраткоеСообщениеОшибки(Ошибка));
	
КонецФункции

Функция КраткоеСообщениеОшибки(Ошибка) Экспорт
	
	Если ЭтоИнформацияОбОшибке(Ошибка) Тогда
		Возврат КраткоеПредставлениеОшибки(Ошибка);
	Иначе
		Возврат Ошибка;
	КонецЕсли;
	
КонецФункции

// Формирует строковое представление значения. Для значений, преобразуемых в пустые строки, добавляет описание типа.
// 
// Параметры:
//  Значение - Произвольный -  Значение
// 
// Возвращаемое значение:
//  Строка -  Представление значения
Функция ПредставлениеЗначения(Значение) Экспорт
	
	ЗначениеСтрокой = Строка(Значение);
	ТипЗначения = ТипЗнч(Значение);
	
	Если ПустаяСтрока(ЗначениеСтрокой) Тогда
		Тип = Строка(ТипЗначения);
		Возврат СтрШаблон("`<Пустое значение, Тип: %1>`", Тип);
	Иначе
		Возврат СтрШаблон("`%1`", ЗначениеСтрокой);
	КонецЕсли;
	
КонецФункции

// Производит замену в переданном шаблоне параметра на переданное значение. 
// 
// Параметры:
//  ШаблонСтроки - Строка - Шаблон строки, в которую должен быть подставлен параметр.
//  ЗначениеПараметра - Произвольный - Значение параметра, подставляемое в шаблон.
// 
// Возвращаемое значение:
//	Строка - Если шаблон строки содержит в тексте параметр `%1`, он будет заменен переданным значением,
//		в противном случае, будет возвращен текст шаблона без изменений. 
//  
Функция ПодставитьПредставлениеЗначенияВШаблон(ШаблонСтроки, ЗначениеПараметра) Экспорт
	
	Возврат СтрЗаменить(ШаблонСтроки, "%1", ПредставлениеЗначения(ЗначениеПараметра));
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоИнформацияОбОшибке(Ошибка) Экспорт
	
	Возврат ТипЗнч(Ошибка) = Тип("ИнформацияОбОшибке");
	
КонецФункции

#КонецОбласти
