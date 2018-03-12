script_name("LUA for Government by AD") -- FFD700
script_version("1.0") 
script_author("Anthony_Dwight")

local inicfg = require 'inicfg'
local check_time = false
local time = 0
local check_key = false
local tag = '[LUA by AD] {FFFFFF} ' 
local sampev = require 'lib.samp.events'
local report = 'vk.com/anthonydwight'
local key = require 'vkeys'
local id = 0
local dolzh = {"Охранник", "Начальник охраны", "Секретарь", "Старший секретарь", "Адвокат", "Лицензер", "Старший лицензер", "Депутат", "Заместитель мэра", "Мэр"}
local frak = {["301989887"]="Гражданский", ["-39322"]="{ff6666}Министерство Здравоохранения", ["-39424"]="{ff6600}ТВ и Радио (СМИ)", ["-16776961"]="{0000fe}Министерсво Внутренних Дел", ["-6724045"]="{996533}Министерство Обороны", ["-3342592"]="{ccff00}Правительство", ["-4521984"]="{bc0000}Yakuza", ["-16747147"]="{017575}Russian Mafia", ["9474192"]="Не авторизован", ["-3407617"]="{cc00ff}The Ballas", ["-16724737"]="{00ccff}Varios Los Aztecas", ["-6737050"]="{993365}La Cosa Nostra", ["-10027111"]="Человек на гонках", ["2236962"]="Человек в маске", ["-10066177"]="{6665ff}The Rifa", ["-16738048"]="{009900}Grove Street", ["-13056"]="{ffcd00}Los Santos Vagos", ["-65536"]="Человек на казаках-разбойниках", ["-16724992"]="Человек на казаках-разбойниках"}
local gmenu = {"{ffffff}1. Попросить вести себя культурно\n2. Попросить покинуть здание\n3. Вывести человека (при сопротивлении)", "{ffffff}1. Попросить вести себя культурно\n2. Попросить покинуть здание\n3. Вывести человека (при сопротивлении)", "{ffffff}1. Чем могу быть любезен?\n2. Выдать визитку адвокатов\n3. Выдать визитку лицензеров",  "{ffffff}1. Чем могу быть любезен?\n2. Выдать визитку адвокатов\n3. Выдать визитку лицензеров", "{ffffff}1. Спросить нужны ли услуги\n2. Огласить ценовую политику\n3. Выпустить человека", "{ffffff}1. Продать лицензию на базовые права\n2. Продать лицензию на проф. права\n3. Продать лицензию на оружие", "{ffffff}1. Продать лицензию на базовые права\n2. Продать лицензию на проф. права\n3. Продать лицензию на оружие", "{ffffff}1. Изменить форму\n2. Показать бейджик", "{ffffff}1. Принять в организацию\n2. Изменить форму\n3. Повысить ранг\n4. Понизить ранг", "{ffffff}1. Принять в организацию\n2. Изменить форму\n3. Повысить ранг\n4. Понизить ранг"}
local sfrac = {"Мэрии Лос-Сантоса", "Мэрии Сан-Фиерро", "Мэрии Лас-Вентураса", "Администрации Президента"}
local actmenu = {"{ffffff}1. Доклад о заступлении на пост\n2. Доклад о состоянии поста\n3. Доклад о покидании поста", "{ffffff}1. Доклад о заступлении на пост\n2. Доклад о состоянии поста\n3. Доклад о покидании поста\n4. Принять доклад", "{ffffff}1. Здравствуйте. Вы на собеседование?\n2. Попросить пакет документов\n3. Задать вопрос касательно IC\n4. Задать вопрос касательно ООС\n5. Задать термин в IC\n6. Задать термин в ООС\n7. Вы нам подходите\n8. Вы нам не подходите", "{ffffff}1. Здравствуйте. Вы на собеседование?\n2. Попросить пакет документов\n3. Задать вопрос касательно IC\n4. Задать вопрос касательно ООС\n5. Задать термин в IC\n6. Задать термин в ООС\n7. Вы нам подходите\n8. Вы нам не подходите", "{ffffff}1. Предложить услуги адвоката\n2. Огласить ценовую политику", "{ffffff}1. Предложить услуги лицензера\n2. Огласить ценовую политику\n3. Чем проф права отличаются от базовых\n4. Крик лицензера\n5. Одеть/снять бейджик", "{ffffff}1. Предложить услуги лицензера\n2. Огласить ценовую политику\n3. Чем проф права отличаются от базовых\n4. Крик лицензера\n5. Одеть/снять бейджик", "{ffffff}1. Напоминание о рабочем транспорте\n2. Напоминание о поведении с гражданами\n3. Напоминание о азартных играх в рабочее время\n4. Напоминание о законах штата №1\n5. Напоминание о законах штата №2", "{ffffff}1. Напоминание о рабочем транспорте\n2. Напоминание о поведении с гражданами\n3. Напоминание о азартных играх в рабочее время\n4. Напоминание о законах штата №1\n5. Напоминание о законах штата №2", "{ffffff}1. Меню гос. новостей\n2. Напоминание о рабочем транспорте\n3. Напоминание о поведении с гражданами\n4. Напоминание о азартных играх в рабочее время\n5. Напоминание о законах штата №1\n6. Напоминание о законах штата №2"}
local ftag = {"LS", "SF", "LV", "АП"}

if not doesDirectoryExist("moonloader\\government") then 
	createDirectory("moonloader\\government") 
end

if not doesFileExist("moonloader\\government\\config.ini") then 
	local f = io.open('moonloader\\government\\config.ini', 'a') 
	f:write("[settings]\nname=None\nrang=1\nsex=Мужской\nnumber=None\nfraction=Мэрия Лос-Сантоса\nnumfr=1") 
	f:close()
	sampAddChatMessage(tag.. "{ff0000}Внимание! {ffffff}Для корректной работы скрипта настройте его в {ffd700}/settings", 0xffd700)
end

function main() 
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	sampRegisterChatCommand("settime", func_stime) 
	sampRegisterChatCommand("setweather", setweather) 
	sampRegisterChatCommand("weatherhelp", weathhelp)
	sampRegisterChatCommand("setskin", setskin)
	sampRegisterChatCommand("cc", ClearChat) 
	sampRegisterChatCommand("luahelp", luahelp)
	sampRegisterChatCommand("checkid", checkid)
	sampRegisterChatCommand("settings", settings)
	sampRegisterChatCommand("rn", rooc)
	sampRegisterChatCommand("fn", fooc)
	sampRegisterChatCommand("ft", tagf)
	sampRegisterChatCommand("ud", udost)
	sampRegisterChatCommand("sobes", sobeska)
	sampRegisterChatCommand("act", menuact)
	sampRegisterChatCommand("uninv", uninvite)
	sampRegisterChatCommand("sud", specud)
	sampRegisterChatCommand("show", showdocs)
	sampAddChatMessage(tag .. "" .. thisScript().name .. " успешно запущен. Версия: " .. thisScript().version .. ". Разработчик скрипта: {32CD32}Anthony_Dwight", 0xFFD700) 
	sampAddChatMessage(tag .. "Помощь по скрипту: {FFD700}/luahelp{ffffff}. Связь с разработчиком: {32CD32}" ..report, 0xFFD700)
	thread = lua_thread.create_suspended(thread_function)
	ini = inicfg.load(nil, "moonloader\\government\\config.ini")
	downloadUrlToFile("https://github.com/tsurik/silver/raw/master/const1.txt", "moonloader\\government\\const1.txt")
	downloadUrlToFile("https://github.com/tsurik/silver/raw/master/const2.txt", "moonloader\\government\\const2.txt")
	downloadUrlToFile("https://github.com/tsurik/silver/raw/master/epk1.txt", "moonloader\\government\\epk1.txt")
	downloadUrlToFile("https://github.com/tsurik/silver/raw/master/epk2.txt", "moonloader\\government\\epk2.txt")
	downloadUrlToFile("https://github.com/tsurik/silver/raw/master/epk3.txt", "moonloader\\government\\epk3.txt")
	downloadUrlToFile("https://github.com/tsurik/silver/raw/master/ustaw1.txt", "moonloader\\government\\ustaw1.txt")
	downloadUrlToFile("https://github.com/tsurik/silver/raw/master/ustaw2.txt", "moonloader\\government\\ustaw2.txt")
	downloadUrlToFile("https://github.com/tsurik/silver/raw/master/ustaw3.txt", "moonloader\\government\\ustaw3.txt")
	downloadUrlToFile("https://github.com/tsurik/silver/raw/master/version.txt", "moonloader\\government\\version.txt")
	vers = io.open("moonloader\\government\\version.txt", "r+")
	versia = vers:read()
	if versia > thisScript().version then
		local dlstatus = require('moonloader').download_status
		downloadUrlToFile("", thisScript().path, function(id, status)
			if status == dlstatus.STATUSENDDOWNLOADDATA then
				thisScript():reload
			end
		end)
		sampAddChatMessage(tag.. "Скрипт успешно обновлен до версии " ..versia.. "!")
		return
	end
	vers:close()
	while true do
		wait(0)
		if ini.settings.sex == "Мужской" then
			peredal = "передал"
			zalomal = "заломал"
			povel = "повел"
			postavil = "поставил"
			dostal = "достал"
			otkril = "открыл"
			vidal = "выдал"
			zapolnil = "заполнил"
			vzal = "взял"
			zakril = "закрыл"
			spratal = "спрятал"
			zashel = "зашел"
			annul = "аннулировал"
		end
		if ini.settings.sex == "Женский" then
			peredal = "передала"
			zalomal = "заломала"
			povel = "повела"
			postavil = "поставила"
			dostal = "достала"
			otkril = "открыла"
			vidal = "выдала"
			zapolnil = "заполнила"
			vzal = "взяла"
			zakril = "закрыла"
			spratal = "спрятала"
			zashel = "зашла"
			annul = "аннулировала"
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(110)
		if resultMain == true then
			if buttonMain == 1 then
				rang = ini.settings.rang
				if rang == 1 then
					if listMain == 0 then
						postid = "1"
						sampShowDialog(111, "{ffd700}" ..tag.. "Введите название поста", "{ffffff}Введите название поста", "ОК", "Назад", 1)
					end
					if listMain == 1 then
						postid = "2"
						sampShowDialog(111, "{ffd700}" ..tag.. "Введите название поста", "{ffffff}Введите название поста", "ОК", "Назад", 1)
					end
					if listMain == 2 then
						postid = "3"
						sampShowDialog(111, "{ffd700}" ..tag.. "Введите название поста", "{ffffff}Введите название поста", "ОК", "Назад", 1)
					end
				end
				if rang == 2 then
				if listMain == 0 then
						postid = "1"
						sampShowDialog(111, "{ffd700}" ..tag.. "Введите название поста", "{ffffff}Введите название поста", "ОК", "Назад", 1)
					end
					if listMain == 1 then
						postid = "2"
						sampShowDialog(111, "{ffd700}" ..tag.. "Введите название поста", "{ffffff}Введите название поста", "ОК", "Назад", 1)
					end
					if listMain == 2 then
						postid = "3"
						sampShowDialog(111, "{ffd700}" ..tag.. "Введите название поста", "{ffffff}Введите название поста", "ОК", "Назад", 1)
					end
					if listMain == 3 then
						sampSendChat("/r Доклад принят. Продолжайте работу в том же духе!")
					end
				end
				if rang == 3 then
					if listMain == 0 then
					sampSendChat("Здравствуйте, Вы пришли на собеседование?")
					end
					if listMain == 1 then
						thread:run("doki")
					end
					if listMain == 2 then
						number = math.random(1, 5)
						if number == 1 then
							sampSendChat("Часто умираете?")
						end
						if number == 2 then
							sampSendChat("На каком языке мы разговариваем?")
						end
						if number == 3 then
							sampSendChat("В каком городе Вы проживаете?")
						end
						if number == 4 then
							sampSendChat("Сколько Вам лет?")
						end
						if number == 5 then
							sampSendChat("Как Вас зовут?")
						end
					end
					if listMain == 3 then
						number = math.random(1, 3)
						if number == 1 then
							sampSendChat("/n Присядь")
						end
						if number == 2 then 
							sampSendChat("/n Что у меня в правой руке?")
						end
						if number == 3 then
							sampSendChat("/n го на девятку инв дам")
						end
					end
					if listMain == 4 then
						number = math.random(1, 5)
						if number == 1 then
							sampSendChat("Что такое ДМ?")
						end
						if number == 2 then
							sampSendChat("Что такое ТК?")
						end
						if number == 3 then
							sampSendChat("Что такое МГ?")
						end
						if number == 4 then
							sampSendChat("Что такое СК?")
						end
						if number == 5 then
							sampSendChat("Что такое ДБ?")
						end
					end
					if listMain == 5 then
						number = math.random(1, 5)
						if number == 1 then
							sampSendChat("/n ДМ, СК, МГ в СМС на номер " ..ini.settings.number)
						end
						if number == 2 then
							sampSendChat("/n ТК, ПГ, ДБ в СМС на номер " ..ini.settings.number)
						end
						if number == 3 then
							sampSendChat("/n ДБ, МГ, СК в СМС на номер " ..ini.settings.number)
						end
						if number == 4 then
							sampSendChat("/n РП, ПГ, ДМ в СМС на номер " ..ini.settings.number)
						end
						if number == 5 then
							sampSendChat("/n МГ, РП, ТК в СМС на номер " ..ini.settings.number)
						end
					end
					if listMain == 6 then
						sampSendChat("Отлично. Вы нам подходите. Сейчас поищем Вам форму.")
					end
					if listMain == 7 then
						sampShowDialog(101, "{ffd700}" ..tag.. "Введите причину", "{ffffff}Введите причину", "ОК", "Назад", 1)
					end
				end
				if rang == 4 then 
					if listMain == 0 then
					sampSendChat("Здравствуйте, Вы пришли на собеседование?")
					end
					if listMain == 1 then
						thread:run("doki")
					end
					if listMain == 2 then
						number = math.random(1, 5)
						if number == 1 then
							sampSendChat("Часто умираете?")
						end
						if number == 2 then
							sampSendChat("На каком языке мы разговариваем?")
						end
						if number == 3 then
							sampSendChat("В каком городе Вы проживаете?")
						end
						if number == 4 then
							sampSendChat("Сколько Вам лет?")
						end
						if number == 5 then
							sampSendChat("Как Вас зовут?")
						end
					end
					if listMain == 3 then
						number = math.random(1, 3)
						if number == 1 then
							sampSendChat("/n Присядь")
						end
						if number == 2 then 
							sampSendChat("/n Что у меня в правой руке?")
						end
						if number == 3 then
							sampSendChat("/n го на девятку инв дам")
						end
					end
					if listMain == 4 then
						number = math.random(1, 5)
						if number == 1 then
							sampSendChat("Что такое ДМ?")
						end
						if number == 2 then
							sampSendChat("Что такое ТК?")
						end
						if number == 3 then
							sampSendChat("Что такое МГ?")
						end
						if number == 4 then
							sampSendChat("Что такое СК?")
						end
						if number == 5 then
							sampSendChat("Что такое ДБ?")
						end
					end
					if listMain == 5 then
						number = math.random(1, 5)
						if number == 1 then
							sampSendChat("/n ДМ, СК, МГ в СМС на номер " ..ini.settings.number)
						end
						if number == 2 then
							sampSendChat("/n ТК, ПГ, ДБ в СМС на номер " ..ini.settings.number)
						end
						if number == 3 then
							sampSendChat("/n ДБ, МГ, СК в СМС на номер " ..ini.settings.number)
						end
						if number == 4 then
							sampSendChat("/n РП, ПГ, ДМ в СМС на номер " ..ini.settings.number)
						end
						if number == 5 then
							sampSendChat("/n МГ, РП, ТК в СМС на номер " ..ini.settings.number)
						end
					end
					if listMain == 6 then
						sampSendChat("Отлично. Вы нам подходите. Сейчас поищем Вам форму.")
					end
					if listMain == 7 then
						sampShowDialog(101, "{ffd700}" ..tag.. "Введите причину", "{ffffff}Введите причину", "ОК", "Назад", 1)
					end
				end
				if rang == 5 then
					if listMain == 0 then
						thread:run("advask1")
					end
					if listMain == 1 then
						thread:run("advask2")
					end
				end
				if rang == 6 then
					if listMain == 0 then
						thread:run("predlic")
					end
					if listMain == 1 then
						sampSendChat("Лицензия на оружие - 30.000$, проф. уровень прав - 10.000$, базовый уровень прав - 1.000$")
					end
					if listMain == 2 then
						thread:run("profprava")
					end
					if listMain == 3 then
						sampSendChat("/s Работает лицензер! Оформим все быстро и надежно!")
					end
					if listMain == 4 then
						sampSendChat("/badge")
					end
				end
				if rang == 7 then
					if listMain == 0 then
						thread:run("predlic")
					end
					if listMain == 1 then
						sampSendChat("Лицензия на оружие - 30.000$, проф. уровень прав - 10.000$, базовый уровень прав - 1.000$")
					end
					if listMain == 2 then
						thread:run("profprava")
					end
					if listMain == 3 then
						sampSendChat("/s Работает лицензер! Оформим все быстро и надежно!")
					end
					if listMain == 4 then
						sampSendChat("/badge")
					end
				end
				if rang == 8 then
					if listMain == 0 then
						thread:run"napom1"
					end
					if listMain == 1 then
						thread:run"napom2"
					end
					if listMain == 2 then
						thread:run"napom3"
					end
					if listMain == 3 then
						thread:run"napom4"
					end
					if listMain == 4 then
						thread:run"napom5"
					end
				end
				if rang == 9 then
					if listMain == 0 then
						thread:run"napom1"
					end
					if listMain == 1 then
						thread:run"napom2"
					end
					if listMain == 2 then
						thread:run"napom3"
					end
					if listMain == 3 then
						thread:run"napom4"
					end
					if listMain == 4 then
						thread:run"napom5"
					end
				end
				if rang == 10 then
					if listMain == 0 then
						gosmenu()
					end
					if listMain == 1 then
						thread:run"napom1"
					end
					if listMain == 2 then
						thread:run"napom2"
					end
					if listMain == 3 then
						thread:run"napom3"
					end
					if listMain == 4 then
						thread:run"napom4"
					end
					if listMain == 5 then
						thread:run"napom5"
					end
				end
			end
		end
		local resultInput, buttonInput, listInput, post = sampHasDialogRespond(111)
		if resultInput == true then
			if buttonInput == 1 then
				if #post == 0 then
					sampShowDialog(111, "{ffd700}" ..tag.. "Введите название поста", "{ffffff}Введите название поста", "ОК", "Назад", 1)
				else
					if postid == "1" then
						sampSendChat("/r Докладывает " ..dolzh[ini.settings.rang].. " " ..ini.settings.name.. " | Заступил на пост: " ..post.. ".")
					end
					if postid == "2" then
						sampSendChat("/r Докладывает " ..dolzh[ini.settings.rang].. " " ..ini.settings.name.. " | Пост: " ..post.. " | Состояние: стабильное.")
					end
					if postid == "3" then
						sampSendChat("/r Докладывает " ..dolzh[ini.settings.rang].. " " ..ini.settings.name.. " | Покинул пост: " ..post.. ".")
					end
				end
			else menuact()
			end
		end
		if isKeyDown(0x12) and isKeyJustPressed(0x31) then 
			menuact()
		end
		if isKeyDown(0x71) then 
			if check_key == "advokat1" then
				check_key = false
				thread:run("advask4")
			end
			if check_key == "advokat2" then
				check_key = false
				thread:run("advask5")
			end
			if check_key == "licer1" then
				check_key = false
				thread:run("licask01")
			end
			if check_key == "licer2" then
				check_key = false
				thread:run("licask02")
			end
		end
		if isKeyDown(0x72) then
			if check_key ~= false then
				sampAddChatMessage(tag.. "Вы успешно отменили действие", 0xffd700)
				check_key = false
			end
		end
		if isKeyDown(2) and isKeyJustPressed(0x47) then
			local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE) 
			if valid and doesCharExist(ped) then 
				result, id = sampGetPlayerIdByCharHandle(ped) 
				if result then 
					nick = sampGetPlayerNickname(id)
					sampShowDialog(5001, "{ffd700}" ..tag .. "Вы навелись на игрока " .. nick .. "[" ..id.. "]", gmenu[ini.settings.rang], "OK", "Отмена", 2)
				end
			end
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(100)
		if resultMain == true then
			if buttonMain == 1 then
				if listMain == 0 then
					sampSendChat("Здравствуйте, Вы пришли на собеседование?")
				end
				if listMain == 1 then
					thread:run("doki")
				end
				if listMain == 2 then
					number = math.random(1, 5)
					if number == 1 then
						sampSendChat("Часто умираете?")
					end
					if number == 2 then
						sampSendChat("На каком языке мы разговариваем?")
					end
					if number == 3 then
						sampSendChat("В каком городе Вы проживаете?")
					end
					if number == 4 then
						sampSendChat("Сколько Вам лет?")
					end
					if number == 5 then
						sampSendChat("Как Вас зовут?")
					end
				end
				if listMain == 3 then
					number = math.random(1, 3)
					if number == 1 then
						sampSendChat("/n Присядь")
					end
					if number == 2 then 
						sampSendChat("/n Что у меня в правой руке?")
					end
					if number == 3 then
						sampSendChat("/n го на девятку инв дам")
					end
				end
				if listMain == 4 then
					number = math.random(1, 5)
					if number == 1 then
						sampSendChat("Что такое ДМ?")
					end
					if number == 2 then
						sampSendChat("Что такое ТК?")
					end
					if number == 3 then
						sampSendChat("Что такое МГ?")
					end
					if number == 4 then
						sampSendChat("Что такое СК?")
					end
					if number == 5 then
						sampSendChat("Что такое ДБ?")
					end
				end
				if listMain == 5 then
					number = math.random(1, 5)
					if number == 1 then
						sampSendChat("/n ДМ, СК, МГ в СМС на номер " ..ini.settings.number)
					end
					if number == 2 then
						sampSendChat("/n ТК, ПГ, ДБ в СМС на номер " ..ini.settings.number)
					end
					if number == 3 then
						sampSendChat("/n ДБ, МГ, СК в СМС на номер " ..ini.settings.number)
					end
					if number == 4 then
						sampSendChat("/n РП, ПГ, ДМ в СМС на номер " ..ini.settings.number)
					end
					if number == 5 then
						sampSendChat("/n МГ, РП, ТК в СМС на номер " ..ini.settings.number)
					end
				end
				if listMain == 6 then
					sampSendChat("Отлично. Вы нам подходите. Сейчас поищем Вам форму.")
				end
				if listMain == 7 then
					sampShowDialog(101, "{ffd700}" ..tag.. "Введите причину", "{ffffff}Введите причину", "ОК", "Назад", 1)
				end
			end
		end
		local resultInput, buttonInput, listInput, reason = sampHasDialogRespond(101)
		if resultInput == true then
			if buttonInput == 1 then
				if #reason == 0 then
					sampShowDialog(101, "{ffd700}" ..tag.. "Введите причину", "{ffffff}Введите причину", "ОК", "Назад", 1)
				else
					sampSendChat("К сожалению, Вы нам не подходите. Причина: " ..reason.. ".")
				end
			else sobeska()
			end
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(5001)
		if resultMain == true then
			if buttonMain == 1 then
				rang = ini.settings.rang
				if rang == 1 then
					if listMain == 0 then
						thread:run("ohrana1")
					end
					if listMain == 1 then
						thread:run("ohrana2")
					end
					if listMain == 2 then
						thread:run("ohrana3")
					end
				end
				if rang == 2 then
					if listMain == 0 then
						thread:run("ohrana1")
					end
					if listMain == 1 then
						thread:run("ohrana2")
					end
					if listMain == 2 then
						thread:run("ohrana3")
					end
				end
				if rang == 3 then
					if listMain == 0 then
						thread:run("secask1")
					end
					if listMain == 1 then
						thread:run("secask2")
					end
					if listMain == 2 then
						thread:run("secask3")
					end
				end
				if rang == 4 then
					if listMain == 0 then
						thread:run("secask1")
					end
					if listMain == 1 then
						thread:run("secask2")
					end
					if listMain == 2 then
						thread:run("secask3")
					end
				end
				if rang == 5 then
					if listMain == 0 then
						thread:run("advask1")
					end
					if listMain == 1 then
						thread:run("advask2")
					end
					if listMain == 2 then
						thread:run("advask3")
					end
				end
				if rang == 6 then
					if listMain == 0 then
						licid = 1
						thread:run("licask0")
					end
					if listMain == 1 then
						licid = 2
						thread:run("licask0")
					end
					if listMain == 2 then
						licid=3
						thread:run("licask0")
					end
				end
				if rang == 7 then
					if listMain == 0 then
						licid = 1
						thread:run("licask0")
					end
					if listMain == 1 then
						licid = 2
						thread:run("licask0")
					end
					if listMain == 2 then
						licid=3
						thread:run("licask0")
					end
				end
				if rang == 8 then
					if listMain == 0 then
						thread:run("changeskin")
					end
					if listMain == 1 then
						udost()
					end
				end
				if rang == 9 then
					if listMain == 0 then
						thread:run("invite")
					end
					if listMain == 1 then
						thread:run("changeskin")
					end
					if listMain == 2 then
						poviha = "+"
						thread:run("smenarang")
					end
					if listMain == 3 then
						poviha = "-"
						thread:run("smenarang")
					end
				end
				if rang == 10 then
					if listMain == 0 then
						thread:run("invite")
					end
					if listMain == 1 then
						thread:run("changeskin")
					end
					if listMain == 2 then
						poviha = "+"
						thread:run("smenarang")
					end
					if listMain == 3 then
						poviha = "-"
						thread:run("smenarang")
					end
				end
			end
		end
		if isKeyDown(2) and isKeyJustPressed(0x58) then
			local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE) 
			if valid and doesCharExist(ped) then 
				result, id = sampGetPlayerIdByCharHandle(ped) 
				if result then 
					nick = sampGetPlayerNickname(id)
					thread:run("allow")
				end
			end
		end
		if isKeyDown(2) and isKeyJustPressed(0x48) then
			local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE) 
			if valid and doesCharExist(ped) then 
				result, id = sampGetPlayerIdByCharHandle(ped) 
				if result then 
					nick = sampGetPlayerNickname(id)
					sampShowDialog(5000, "{ffd700}" ..tag .. "Вы навелись на игрока " .. nick .. "[" ..id.. "]", "{ffffff}1. Показать паспорт\n2. Показать лицензии\n3. Показать трудовую книгу\n4. Показать выписку из тира", "OK", "Отмена", 2)
				end
			end
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(5000)
		if resultMain == true then
			if buttonMain == 1 then
				if listMain == 0 then
					sampSendChat("/pass " ..id)
				end
				if listMain == 1 then
					sampSendChat("/lic " ..id)
				end
				if listMain == 2 then
					sampSendChat("/wbook " ..id)
				end
				if listMain == 3 then
					sampSendChat("/skill " ..id)
				end
			end
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(0)
		if resultMain == true then
			if buttonMain == 1 then
				if listMain == 0 then
					sampShowDialog(10, "{ffd700}" ..tag.. "Введите никнейм (без _)", "{ffffff}Ваш текущий никнейм: {ffd700}" ..ini.settings.name, "ОК", "Назад", 1)
				end
				if listMain == 1 then
					sampShowDialog(11, "{ffd700}" ..tag.. "Введите свой номер", "{ffffff}Ваш текущий номер: {ffd700}" ..ini.settings.number, "ОК", "Назад", 1)
				end
				if listMain == 2 then
					sampShowDialog(12, "{ffd700}" ..tag.. "Выберите свое подразделение", "{ffffff}Мэрия Лос-Сантоса\nМэрия Сан-Фиерро\nМэрия Лас-Вентураса\nАдминистрация Президента", "ОК", "Назад", 2)
				end
				if listMain == 3 then
					sampShowDialog(13, "{ffd700}" ..tag.. "Введите свой ранг", "{ffffff}Ваш текущий ранг: {ffd700}" ..ini.settings.rang, "OK", "Назад", 1)
				end
				if listMain == 4 then
					sampShowDialog(14, "{ffd700}" ..tag.. "Выберите пол", "{ffffff}Мужской\nЖенский", "OK", "Назад", 4)
				end
			end
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(14)
		if resultMain == true then
			if buttonMain == 1 then
				if listMain == 0 then
					ini.settings.sex = "Мужской"
					inicfg.save(ini, "moonloader\\government\\config.ini")
					settings()
				end
				if listMain == 1 then
					ini.settings.sex = "Женский"
					inicfg.save(ini, "moonloader\\government\\config.ini")
					settings()
				end
			else
				settings()
			end
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(12)
		if resultMain == true then
			if buttonMain == 1 then
				if listMain == 0 then
					ini.settings.fraction = "Мэрия Лос-Сантоса"
					ini.settings.numfr = 1
					inicfg.save(ini, "moonloader\\government\\config.ini")
					settings()
				end
				if listMain == 1 then
					ini.settings.fraction = "Мэрия Сан-Фиерро"
					ini.settings.numfr = 2
					inicfg.save(ini, "moonloader\\government\\config.ini")
					settings()
				end
				if listMain == 2 then
					ini.settings.fraction = "Мэрия Лас-Вентураса"
					ini.settings.numfr = 3
					inicfg.save(ini, "moonloader\\government\\config.ini")
					settings()
				end
				if listMain == 3 then
					ini.settings.fraction = "Администрация Президента"
					ini.settings.numfr = 4
					inicfg.save(ini, "moonloader\\government\\config.ini")
					settings()
				end
			else
				settings()
			end
		end
		local resultInput, buttonInput, listInput, inputrang = sampHasDialogRespond(13)
		if resultInput == true then
			if buttonInput == 1 then
				if #inputrang == 0 then
					sampShowDialog(13, "{ffd700}" ..tag.. "Введите свой ранг", "{ffffff}Ваш текущий ранг: {ffd700}" ..ini.settings.rang, "OK", "Назад", 1)
				else
					inputrang = tonumber(inputrang)
					if type(inputrang) ~= "number" then
						sampShowDialog(13, "{ffd700}" ..tag.. "Введите свой ранг", "{ffffff}Ваш текущий ранг: {ffd700}" ..ini.settings.rang, "OK", "Назад", 1)
					else
						if inputrang < 1 or inputrang > 10 then
							sampShowDialog(13, "{ffd700}" ..tag.. "Введите свой ранг", "{ffffff}Ваш текущий ранг: {ffd700}" ..ini.settings.rang, "OK", "Назад", 1)
						else
							ini.settings.rang = inputrang
							inicfg.save(ini, "moonloader\\government\\config.ini")
							settings()
						end
					end
				end
			else settings()
			end
		end
		local resultInput, buttonInput, listInput, inputname = sampHasDialogRespond(10)
		if resultInput == true then
			if buttonInput == 1 then
				if #inputname == 0 then
					sampShowDialog(10, "{ffd700}" ..tag.. "Введите никнейм (без _)", "{ffffff}Ваш текущий никнейм: {ffd700}" ..ini.settings.name, "ОК", "Назад", 1)
				else
					ini.settings.name = inputname
					inicfg.save(ini, "moonloader\\government\\config.ini")
					settings()
				end
			else settings()
			end
		end
		local resultInput, buttonInput, listInput, inputnumber = sampHasDialogRespond(11)
		if resultInput == true then
			if buttonInput == 1 then
				if #inputnumber == 0 then
					sampShowDialog(11, "{ffd700}" ..tag.. "Введите свой номер", "{ffffff}Ваш текущий номер: {ffd700}" ..ini.settings.number, "ОК", "Назад", 1)
				else
					inputnumber = tonumber(inputnumber)
					if type(inputnumber) ~= "number" then
						sampShowDialog(11, "{ffd700}" ..tag.. "Введите свой номер", "{ffffff}Ваш текущий номер: {ffd700}" ..ini.settings.number, "ОК", "Назад", 1)
					else
						ini.settings.number = inputnumber
						inicfg.save(ini, "moonloader\\government\\config.ini")
						settings()
					end
				end
			else settings()
			end
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(1000)
		if resultMain == true then
			if buttonMain == 1 then
				if listMain == 0 then
					gosfrac = 1
					gosmenu1()
				end
				if listMain == 1 then
					gosfrac = 2
					gosmenu1()
				end
				if listMain == 2 then
					gosfrac = 3
					gosmenu1()
				end
				if listMain == 3 then
					gosfrac = 4
					gosmenu1()
				end
			else
				menuact()
			end
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(1001)
		if resultMain == true then
			if buttonMain == 1 then
				if listMain == 0 then
					if gosfrac == 1 then
						thread:run("gos01")
					end
					if gosfrac == 2 then
						thread:run("gos02")
					end
					if gosfrac == 3 then
						thread:run("gos03")
					end
					if gosfrac == 4 then
						thread:run("gos04")
					end
				end
				if listMain == 1 then
					if gosfrac == 1 then
						sampSendChat("/gnews Собеседование в Мэрию г.Лос-Сантос продолжается. Ждем Вас. GPS 1-2.")
					end
					if gosfrac == 2 then
						sampSendChat("/gnews Собеседование в Мэрию г.Сан-Фиерро продолжается. Ждем Вас. GPS 1-3.")
					end
					if gosfrac == 3 then
						sampSendChat("/gnews Собеседование в Мэрию г.Лас-Вентурас продолжается. Ждем Вас. GPS 1-4.")
					end
					if gosfrac == 4 then
						sampSendChat("/gnews Собеседование в Адм. Президента продолжается. Ждем Вас. GPS 1-5.")
					end
				end
				if listMain == 2 then
					if gosfrac == 1 then
						sampSendChat("/gnews Собеседование в Мэрию г.Лос-Сантос окончено. Всем спасибо.")
					end
					if gosfrac == 2 then
						sampSendChat("/gnews Собеседование в Мэрию г.Сан-Фиерро окончено. Всем спасибо.")
					end
					if gosfrac == 3 then
						sampSendChat("/gnews Собеседование в Мэрию г.Лас-Вентурас окончено. Всем спасибо.")
					end
					if gosfrac == 1 then
						sampSendChat("/gnews Собеседование в Адм. Президента окончено. Всем спасибо.")
					end
				end
			else
				menuact()
			end
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(2000)
		if resultMain == true then
			if buttonMain == 1 then
				if listMain == 0 then
					showustaw()
				end
				if listMain == 1 then
					showconst()
				end
				if listMain == 2 then
					showepk()
				end
			end
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(2001)
		if resultMain == true then
			if buttonMain == 1 then
				if listMain == 0 then
					ustaw1 = io.open("moonloader\\government\\ustaw1.txt", "r+") 
					var = "" 
					for line in ustaw1:lines() do 
						var = var .. "\n" .. line 
					end 
					sampShowDialog(2004, "{ffd700}" ..tag.. "Устав Правительства (1 страница)", var, "Назад", "Закрыть") 
					ustaw1:close()
				end
				if listMain == 1 then
					ustaw2 = io.open("moonloader\\government\\ustaw2.txt", "r+")
					var = "" 
					for line in ustaw2:lines() do 
						var = var .. "\n" .. line 
					end 
					sampShowDialog(2004, "{ffd700}" ..tag.. "Устав Правительства (2 страница)", var, "Назад", "Закрыть")
					ustaw2:close()
				end
				if listMain == 2 then
					ustaw3 = io.open("moonloader\\government\\ustaw3.txt", "r+")
					var = "" 
					for line in ustaw3:lines() do 
						var = var .. "\n" .. line 
					end 
					sampShowDialog(2004, "{ffd700}" ..tag.. "Устав Правительства (3 страница)", var, "Назад", "Закрыть")
					ustaw3:close()
				end
			else
				showdocs()
			end
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(2002)
		if resultMain == true then
			if buttonMain == 1 then
				if listMain == 0 then
					const1 = io.open("moonloader\\government\\const1.txt", "r+") 
					var = "" 
					for line in const1:lines() do 
						var = var .. "\n" .. line 
					end 
					sampShowDialog(2005, "{ffd700}" ..tag.. "Конституция штата (1 страница)", var, "Назад", "Закрыть") 
					const1:close()
				end
				if listMain == 1 then
					const2 = io.open("moonloader\\government\\const2.txt", "r+")
					var = "" 
					for line in const2:lines() do 
						var = var .. "\n" .. line 
					end 
					sampShowDialog(2005, "{ffd700}" ..tag.. "Конституция штата (2 страница)", var, "Назад", "Закрыть")
					const2:close()
				end
			else
				showdocs()
			end
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(2003)
		if resultMain == true then
			if buttonMain == 1 then
				if listMain == 0 then
					epk1 = io.open("moonloader\\government\\epk1.txt", "r+") 
					var = "" 
					for line in epk1:lines() do 
						var = var .. "\n" .. line 
					end 
					sampShowDialog(2006, "{ffd700}" ..tag.. "Единый процессуальный кодекс (1 страница)", var, "Назад", "Закрыть") 
					epk1:close()
				end
				if listMain == 1 then
					epk2 = io.open("moonloader\\government\\epk2.txt", "r+")
					var = "" 
					for line in epk2:lines() do 
						var = var .. "\n" .. line 
					end 
					sampShowDialog(2006, "{ffd700}" ..tag.. "Единый процессуальный кодекс (2 страница)", var, "Назад", "Закрыть")
					epk2:close()
				end
				if listMain == 2 then
					epk3 = io.open("moonloader\\government\\epk3.txt", "r+")
					var = "" 
					for line in epk3:lines() do 
						var = var .. "\n" .. line 
					end 
					sampShowDialog(2006, "{ffd700}" ..tag.. "Единый процессуальный кодекс (3 страница)", var, "Назад", "Закрыть")
					epk3:close()
				end
			else
				showdocs()
			end
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(2004)
		if resultMain == true then
			if buttonMain == 1 then
				showustaw()
			end
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(2005)
		if resultMain == true then
			if buttonMain == 1 then
				showconst()
			end
		end
		local resultMain, buttonMain, listMain = sampHasDialogRespond(2006)
		if resultMain == true then
			if buttonMain == 1 then
				showepk()
			end
		end
		if check_time then
			writeMemory(0xB70153, 1, time, 1) 
		end
	end
end

function gosmenu1()
	sampShowDialog(1001, "{ffd700}" ..tag.. "Меню гос. новостей", "{ffffff}1. Отправить 3 строки\n2. Отправить гос. новость о продолжении\n3. Отправить гос. новость об окончании", "ОК", "Назад", 2)
end

function gosmenu()
	sampShowDialog(1000, "{ffd700}" ..tag.. "Меню гос. новостей", "{ffffff}1. Мэрия Лос-Сантоса\n2. Мэрия Сан-Фиерро\n3. Мэрия Лас-Вентураса\n4. Администрация Президента", "ОК", "Назад", 2)
end	

function menuact()
	sampShowDialog(110, "{ffd700}" ..tag.. "Основное меню", actmenu[ini.settings.rang], "OK", "Отмена", 2)
end

function func_stime(arg) 
	if #arg == 0 then 
	sampAddChatMessage(tag .. "Введите /settime [0-23]", 0xFFD700) 
	else 
		arg = tonumber(arg) 
		if type(arg) ~= "number" then
		sampAddChatMessage(tag .. "Введите /settime [0-23]", 0xFFD700) 
		else 
			if arg < 0 or arg > 23 then 
			sampAddChatMessage(tag .. "Введите /settime [0-23]", 0xFFD700) 
			else 
				sampAddChatMessage(tag .. "Время успешно изменилось (" .. arg .. ":00)", 0xFFD700) 
				check_time = true
				time = arg 
			end 
		end
	end
end

function specud()
	thread:run("secask1")
end

function setweather(id) 
	if #id == 0 then
	sampAddChatMessage(tag.. "Введите /setweather [0-45]", 0xFFD700) 
	else 
		id = tonumber(id) 
		if type(id) ~= "number" then
		sampAddChatMessage(tag.. "Введите /setweather [0-45]", 0xFFD700) 
		else 
			if id < 0 or id > 45 then
			sampAddChatMessage(tag .. "Введите /setweather [0-45]", 0xFFD700) 
			else 
				sampAddChatMessage(tag.. "Погода успешно изменилась (id " .. id .. ")", 0xFFD700) 
				writeMemory(0xC81320, 1, id, 1) 
			end 
		end 
	end
end

function ClearChat() 
	local memory = require "memory" 
	memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200, false) 
	setStructElement(sampGetChatInfoPtr() + 306, 25562, 4, true, false) 
	memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1, false) 
	sampAddChatMessage(tag.. "Чат был успешно очищен", 0xffd700) 
end

function setskin(skinId)
	local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if #skinId == 0 then
	sampAddChatMessage(tag .. "Введите /setskin [id скина]", 0xFFD700)
	else
		skinId = tonumber(skinId) 
		if type(skinId) ~= "number" then
		sampAddChatMessage(tag .. "Введите /setskin [id скина]", 0xFFD700)
		else
			if skinId < 1 or skinId > 311 or skinId == 74 then
			sampAddChatMessage(tag .. "{ff0000}Ошибка. {ffffff}ID скина должен быть от 1 до 311 и не быть равен 74", 0xFFD700)
			else
				sampAddChatMessage(tag .. "Скин успешно изменен (id " .. skinId .. ")", 0xFFD700)
				changeSkin(id, skinId)
			end
		end
	end
end

function changeSkin(id, skinId) 
	bs = raknetNewBitStream() 
	if id == -1 then _, id = sampGetPlayerIdByCharHandle(PLAYER_PED) end
	raknetBitStreamWriteInt32(bs, id) 
	raknetBitStreamWriteInt32(bs, skinId) 
	raknetEmulRpcReceiveBitStream(153, bs) 
	raknetDeleteBitStream(bs) 
end

function rooc(arg)
	if #arg == 0 then
		sampAddChatMessage(tag.. "Введите /rn [текст]", 0xffd700)
	else
		sampSendChat("/r (( " ..arg.. " ))")
	end
end

function udost()
	thread:run("udost")
end

function fooc(arg)
	if #arg == 0 then
		sampAddChatMessage(tag.. "Введите /fn [текст]", 0xffd700)
	else
		sampSendChat("/f (( " ..arg.. " ))")
	end
end

function checkid(arg)
	if #arg == 0 then
		sampAddChatMessage(tag.. "Введите /checkid [id]", 0xffd700)
	else
		arg = tonumber(arg)
		if type(arg) ~= "number" then
			sampAddChatMessage(tag.. "Введите /checkid [id]", 0xffd700)
		else
			if arg < 0 or arg > 999 then
				sampAddChatMessage(tag.. "Введите /checkid [id]", 0xffd700)
			else
				if sampIsPlayerConnected(arg) then
					clr = sampGetPlayerColor(arg)
					clr = tostring(clr)
					sampAddChatMessage(tag.. "ID: " .. arg .. " | Ник: " .. sampGetPlayerNickname(arg) .. " | Уровень: " .. sampGetPlayerScore(arg) .. " | Ping: " .. sampGetPlayerPing(arg) .. " | Организация: " ..clr, 0xffd700)
				else
					sampAddChatMessage(tag.. "{ff0000}Ошибка. {ffffff}Игрока с таким ID нет на сервере", 0xffd700)
				end
			end
		end
	end
end

function uninvite(arg)
	rang = ini.settings.rang
	if rang < 8 then
		sampAddChatMessage(tag.. "{ff0000}Ошибка. {ffffff}Данная команда доступна с 8 ранга", 0xffd700)
	else
		if #arg == 0 then
			sampAddChatMessage(tag.. "Введите /uninv [id] [причина]", 0xffd700)
		else
			id, reason = string.match(arg, "(.+) (.+)")
			id = tonumber(id)
			if type(id) ~= "number" then
				sampAddChatMessage(tag.. "Введите /uninv [id] [причина]", 0xffd700)
			else
				if #reason == 0 then
					sampAddChatMessage(tag.. "Введите /uninv [id] [причина]", 0xffd700)
				else
					if sampIsPlayerConnected(id) then
						thread:run("uval")
					else
						sampAddChatMessage(tag.. "{ff0000}Ошибка. {ffffff}Игрока с таким ID нет на сервере", 0xffd700)
					end
				end
			end
		end
	end
end

function tagf(arg)
	if #arg == 0 then
		sampAddChatMessage(tag.. "Введите /ft [текст]", 0xffd700)
	else
		sampSendChat("/f " ..ftag[ini.settings.numfr].. " | " ..arg)
	end
end

function luahelp()
	sampShowDialog(10000, "{ffd700}" ..tag.. "Помощь по скрипту", "{ffd700}/settings - {ffffff}настройки скрипта\n{ffd700}/act {ffffff}| {ffd700}Alt + 1 - {ffffff}основное меню\n{ffd700}ПКМ + G - {ffffff}основное меню взаимодействия с персонажем\n{ffd700}/show - {ffffff}полезная информация (устав и т.д.)\n{ffd700}/sobes - {ffffff}проверка на собеседовании\n{ffd700}/ud - {ffffff}показать удостоверение\n{ffd700}/sud - {ffffff}приветствие посетителей мэрии\n{ffd700}/uninv - {ffffff}уволить сотрудника с РП отыгровкой\n{ffd700}/rn {ffffff}| {ffd700}/fn - {ffffff}сообщение в нонРП рацию\n{ffd700}/ft - {ffffff}сообщение в /f с тэгом\n{ffd700}ПКМ + H - {ffffff}меню быстрого взаимодействия\n{ffd700}ПКМ + X - {ffffff}передать ключи от автомобиля\n{ffd700}/settime - {ffffff}изменить время в игре\n{ffd700}/setweather - {ffffff}изменить погоду в игре\n{ffd700}/weatherhelp - {ffffff}id погод и их описание\n{ffd700}/setskin - {ffffff}визуально изменяет скин (видите только вы)\n{ffd700}/checkid - {ffffff}узнать информацию о игроке\n{ffd700}/cc - {ffffff}очистить чат", "OK")
end

function weathhelp()
	sampShowDialog(10002, "{FFD700}" ..tag.. "ID погод и их описание", "{32CD32}Эти ID нужно использовать в функции SetWeather\n{FFD700}0 - 7 = {FFFAFA}разные версии синих небес/облаков\n{FFD700}08 = {FFFAFA}гроза\n{FFD700}09 = {FFFAFA}пасмурно и туман\n{FFD700}10 = {FFFAFA}ясное синее небо (входит в категории 0-7)\n{FFD700}11 = {FFFAFA}обжигающая жаркая\n{FFD700}12 - 15 = {FFFAFA}очень тусклый, бесцветный, смутные\n{FFD700}16 = {FFFAFA}тусклый, неясный, дождливые\n{FFD700}17 - 18 = {FFFAFA}опаливая горячие\n{FFD700}19 = {FFFAFA}песчаная буря\n{FFD700}20 = {FFFAFA}туманный/зеленоватые\n{FFD700}21 = {FFFAFA}очень темное, gradiented очертание, пурпурные\n{FFD700}22 = {FFFAFA}очень темное, gradiented очертание, зеленые\n{FFD700}23 в 26 = {FFFAFA}изменения бледного апельсина\n{FFD700}27 в 29 = {FFFAFA}изменения свежий синие\n{FFD700}30 в 32 = {FFFAFA}изменения темного, неясного, чирка\n{FFD700}33 = {FFFAFA}темный, неясный, коричневый\n{FFD700}34 = {FFFAFA}синий/пурпурный, регулярный\n{FFD700}35 = {FFFAFA}тусклые коричневые\n{FFD700}36 в 38 = {FFFAFA}яркий, туманный, апельсин\n{FFD700}39 = {FFFAFA}чрезвычайно яркие\n{FFD700}40 в 42 = {FFFAFA}синий/пурпурные неясные\n{FFD700}43 = {FFFAFA}темные токсичные облака\n{FFD700}44 = {FFFAFA}черное/белое небо\n{FFD700}45 = {FFFAFA}черное/пурпурное небо", "OK")
end

function settings()
	sampShowDialog(0, "{ffd700}" ..tag.. "Настройки скрипта", "{ffffff}Параметр\t{ffd700}Значение\n{ffffff}1. Никнейм:\t{ffd700}" ..ini.settings.name.. "\n{ffffff}2. Номер телефона:\t{ffd700}" ..ini.settings.number.. "\n{ffffff}3. Организация:\t{ffd700}" ..ini.settings.fraction.. "\n{ffffff}4. Ранг:\t{ffd700}" ..ini.settings.rang.. "\n{ffffff}5. Пол:\t{ffd700}" ..ini.settings.sex.. "", "Выбрать", "Отмена", 5)
end

function sobeska()
	sampShowDialog(100, "{ffd700}" ..tag.. "Меню собеседования", "{ffffff}1. Здравствуйте. Вы на собеседование?\n2. Попросить пакет документов\n3. Задать вопрос касательно IC\n4. Задать вопрос касательно ООС\n5. Задать термин в IC\n6. Задать термин в ООС\n7. Вы нам подходите\n8. Вы нам не подходите", "Выбрать", "Отмена", 2)
end

function showdocs()
	sampShowDialog(2000, "{ffd700}" ..tag.. "Важные документы", "{ffffff}1. Устав Правительства\n2. Конституция штата\n3. Единый процессуальный кодекс", "ОК", "Отмена", 2)
end

function showustaw()
	sampShowDialog(2001, "{ffd700}" ..tag.. "Устав Правительства", "{ffffff}1 страница (1-4 разделы)\n2 страница (5-8 разделы)\n3 страница (9-12 разделы)", "ОК", "Назад", 2)
end

function showconst()
	sampShowDialog(2002, "{ffd700}" ..tag.. "Конституция штата", "{ffffff}1 страница (1-3 главы)\n2 страница (4-7 главы)", "ОК", "Назад", 2)
end

function showepk()
	sampShowDialog(2003, "{ffd700}" ..tag.. "ЕПК", "{ffffff}1 страница (1-3 главы)\n2 страница (4-6 главы)\n3 страница (7-8 главы)", "ОК", "Назад", 2)
end

function thread_function(option)
	if option == "ohrana1" then
		sampSendChat("Cэр, ведите себя более сдержано, иначе мне придется применить силу!'")
	end
	if option == "ohrana2" then
		sampSendChat("Сэр, немедленно покиньте здание!")
		wait(1000)
		sampSendChat("В случае отказа мне придется применить силу.")
	end
	if option == "ohrana3" then
		nick = nick:gsub("_", " ")
		sampSendChat("/me " ..zalomal.. " руку " ..nick)
		wait(1000)
		sampSendChat("/me " ..povel.. " нарушителя к выходу")
	end
	if option == "secask1" then
		sampSendChat("Здравствуйте, я " ..dolzh[ini.settings.rang].. " " ..sfrac[ini.settings.numfr].. " " ..ini.settings.name.. ".")
		wait(1000)
		sampSendChat("Нуждаетесь ли Вы в моей помощи?")
	end
	if option == "secask2" then
		nick = nick:gsub("_", " ")
		sampSendChat("/me " ..peredal.. " визитку адвокатов " ..nick)
		wait(1000)
		sampSendChat("/n /adlist")
	end
	if option == "secask3" then
		nick = nick:gsub("_", " ")
		sampSendChat("/me " ..peredal.. " визитку лицензеров " ..nick)
		wait(1000)
		sampSendChat("/n /liclist")
	end
	if option == "advask1" then
		sampSendChat("Здравствуйте, я " ..dolzh[ini.settings.rang].. " " ..sfrac[ini.settings.numfr].. " " ..ini.settings.name.. ".")
		wait(1000)
		sampSendChat("Я занимаюсь освобождением гражданов из КПЗ. Нуждаетесь ли Вы в моих услугах?")
	end
	if option == "advask2" then
		sampSendChat("Цена моих услуг составляет 9.000$.")
	end
	if option == "advask3" then
		sampSendChat("/me " ..otkril.. " портфель")
		wait(1000)
		sampSendChat("/me " ..dostal.. " бланк ''Освобождение заключённого''")
		wait(1000)
		sampSendChat("Можно Ваше Имя и Фамилию?")
		sampAddChatMessage(tag.. "Для продолжения отыгровки нажмите {ffd700}F2 {ffffff}или {ffd700}F3 {ffffff}для отмены", 0xffd700)
		check_key = "advokat1"
	end
	if option == "advask4" then
		sampSendChat("/me записывает в бланк")
		wait(1000)
		sampSendChat("Распишитесь пожалуйста внизу бланка.")
		wait(1000)
		sampSendChat("/n /me расписался(-ась)")
		sampAddChatMessage(tag.. "Для продолжения отыгровки нажмите {ffd700}F2 {ffffff}или {ffd700}F3 {ffffff}для отмены", 0xffd700)
		check_key = "advokat2"
	end
	if option == "advask5" then
		sampSendChat("/me " ..postavil.. " печать")
		wait(1000)
		sampSendChat("/free " ..id.. " 9000")
	end
	if option == "licask0" then
		sampSendChat("/me " ..dostal.. " папку")
		wait(1000)
		sampSendChat("/me " ..vzal.. " ручку и бланк")
		wait(1000)
		sampSendChat("/me заполняет бланк лицензии")
		wait(1000)
		sampSendChat("Будьте добры ваше имя и фамилию.")
		sampAddChatMessage(tag.. "Для продолжения отыгровки нажмите {ffd700}F2 {ffffff}или {ffd700}F3 {ffffff}для отмены", 0xffd700)
		check_key = "licer1"
	end
	if option == "licask01" then
		sampSendChat("/me " ..zapolnil.. " бланк лицензии")
		wait(1000)
		sampSendChat("/do Бланк заполнен.")
		wait(1000)
		sampSendChat("Возьмите ручку, подпишите вот здесь.")
		wait(1000)
		sampSendChat("/me " ..peredal.. " ручку")
		wait(1000)
		sampSendChat("/n /me расписался(-ась)")
		sampAddChatMessage(tag.. "Для продолжения отыгровки нажмите {ffd700}F2 {ffffff}или {ffd700}F3 {ffffff}для отмены", 0xffd700)
		check_key = "licer2"
	end
	if option == "licask02" then
		sampSendChat("/me " ..vidal.. " лицензию")
		wait(1000)
		if licid == 1 then
			sampSendChat("/givelic " ..id.. " 1 1000")
		end
		if licid == 2 then
			sampSendChat("/givelic " ..id.. "1 10000")
		end
		if licid == 3 then
			sampSendChat("/givelic " ..id.. " 2 30000")
		end
	end
	if option == "changeskin" then
		nick = nick:gsub("_", " ")
		sampSendChat("/me " ..otkril.. " чемодан, после чего " ..dostal.. " форму")
		wait(1000)
		sampSendChat("/me " ..peredal.. " форму " ..nick)
		wait(1000)
		sampSendChat("/changeskin " ..id)
	end
	if option == "invite" then
		nick = nick:gsub("_", " ")
		sampSendChat("/do Чемодан в левой руке")
		wait(1000)
		sampSendChat("/me " ..otkril.. " чемодан")
		wait(1000)
		sampSendChat("/me " ..dostal.. " форму и бейджик")
		wait(1000)
		sampSendChat("/me " ..peredal.. " " ..nick.. " форму и бейджик")
		wait(1000)
		sampSendChat("/me закрыл чемодан")
		wait(1000)
		sampSendChat("/invite " ..id)
	end
	if option == "smenarang" then
		nick = nick:gsub("_", " ")
		sampSendChat("/do Новый бейджик сотрудника в правом кармане.")
		wait(1000)
		sampSendCHat("/me " ..dostal.. " новый бейджик из кармана")
		wait(1000)
		sampSendChat("/me " ..peredal.. " новый бейджик " ..nick)
		wait(1000)
		sampSendChat("/rang " ..id.. " " ..poviha)
	end
	if option == "udost" then
		sampSendChat("/do Удостоверение лежит в кармане.")
		wait(1000)
		sampSendChat("/me " ..dostal.. " удостоверение с кармана, после чего " ..peredal.. " его")
		wait(1000)
		sampSendChat("/do В удостоверении написано: " ..ini.settings.name.. " | " ..ini.settings.number)
		wait(1000)
		sampSendChat("/do " ..ini.settings.fraction.. " | " ..dolzh[ini.settings.rang])
		wait(1000)
		sampSendChat("/me " ..spratal.. " удостоверение в карман")
	end
	if option == "doki" then
		hhh, mid = sampGetPlayerIdByCharHandle(PLAYER_PED)
		sampSendChat("Предъявите пожалуста свои документы. А именно:")
		wait(1000)
		sampSendChat("Паспорт, лицензии, трудовую книгу и выписку из тира.")
		wait(1000)
		sampSendChat("/n /pass " ..mid.. " | /lic " ..mid.. " | /wbook " ..mid.. " | /skill " ..mid)
	end
	if option == "predlic" then
		sampSendChat("Здравствуйте, я " ..dolzh[ini.settings.rang].. " " ..sfrac[ini.settings.numfr].. " " ..ini.settings.name.. ".")
		wait(1000)
		sampSendChat("Нуждаетесь ли Вы в моих услугах?")
	end
	if option == "profprava" then
		sampSendChat("Проф. права нужны Вам для управления водным и летным видами транспорта.")
		wait(1000)
		sampSendChat("Базовые права же дают право управления только на автомобили и мотоциклы.")
		wait(1000)
		sampSendChat("Для покупки проф. прав у Вас уже должны быть базовые.")
	end
	if option == "napom1" then
		sampSendChat("/r Уважаемые сотрудники, напоминаю Вам.")
		wait(1000)
		sampSendChat("/r Рабочий транспорт можно брать только с разрешения старших.")
		wait(1000)
		sampSendChat("/r Кто возьмёт без разрешения - будет уволен.")
	end
	if option == "napom2" then
		sampSendChat("/r Уважаемые сотрудники,минуточку внимания.")
		wait(1000)
		sampSendChat("/r Напоминаю, если вы оскорбите сотрудника или жителя штата...")
		wait(1000)
		sampSendChat("/r Вы будете уволены и занесены в ЧС.")
	end
	if option == "napom3" then
		sampSendChat("/r Уважаемые сотрудники, хочу напомнить Вам:")
		wait(1000)
		sampSendChat("/r Играть в азартные игры разрешено исключительно вне рабочее время")
		wait(1000)
		sampSendChat("/r Замеченные сотрудники в казино в рабочее время - будут уволены!")
	end
	if option == "napom4" then
		sampSendChat("/r Вы обязаны знать законы Штата. Чтить и уважать устав Мэрии.")
		wait(1000)
		sampSendChat("/r Выполнять свои должностные обязанности, при этом помогать коллегам и...")
		wait(1000)
		sampSendChat("/r соблюдать субординацию. Быть максимально вежливым с гражданами.")
		wait(1000)
		sampSendChat("/r Выполнять указания старших по должности.")
		wait(1000)
		sampSendChat("/r Выслушивать все жалобы и предложения граждан и оказывать им помощь.")
	end
	if option == "napom5" then
		sampSendChat("/r Вам запрещено нарушать законы штата.")
		wait(1000)
		sampSendChat("/r Использовать власть в личных целях, превышать полномочия.")
		wait(1000)
		sampSendChat("/r Использовать служебный транспорт в личных целях без разрешения старших по должности.")
		wait(1000)
		sampSendChat("/r Работать на шахте либо заводе. Хранить, распространять либо употреблять наркотические вещества.")
	end
	if option == "gos01" then
		sampSendChat("/gnews Уважаемые жители штата, сейчас проходит собеседование в Мэрию ЛС.")
		wait(700)
		sampSendChat("/gnews Требования: проживать 3 года в штате, быть законопослушным.")
		wait(700)
		sampSendChat("/gnews Собеседование пройдет в холле Мэрии ЛС. GPS 1-2.")
	end
	if option == "gos02" then
		sampSendChat("/gnews Уважаемые жители штата, сейчас проходит собеседование в Мэрию СФ.")
		wait(700)
		sampSendChat("/gnews Требования: проживать 3 года в штате, быть законопослушным.")
		wait(700)
		sampSendChat("/gnews Собеседование пройдет в холле Мэрии СФ. GPS 1-3.")
	end
	if option == "gos03" then
		sampSendChat("/gnews Уважаемые жители штата, сейчас проходит собеседование в Мэрию ЛВ.")
		wait(700)
		sampSendChat("/gnews Требования: проживать 3 года в штате, быть законопослушным.")
		wait(700)
		sampSendChat("/gnews Собеседование пройдет в холле Мэрии ЛВ. GPS 1-4.")
	end
	if option == "gos04" then
		sampSendChat("/gnews Уважаемые жители штата, сейчас проходит собеседование в Адм. Президента.")
		wait(700)
		sampSendChat("/gnews Требования: проживать 3 года в штате, быть законопослушным.")
		wait(700)
		sampSendChat("/gnews Собеседование пройдет в холле Адм. Президента. GPS 1-5.")
	end
	if option == "allow" then
		nick = nick:gsub("_", " ")
		sampSendChat("/me " ..peredal.. " ключи от автомобиля " ..nick)
		wait(700)
		sampSendChat("/allow " ..id)
	end
	if option == "uval" then
		sampSendChat("/do В кармане лежит КПК.")
		wait(1000)
		sampSendChat("/me " ..dostal.. " КПК из кармана")
		wait(1000)
		sampSendChat("/me " ..zashel.. " на портал штата")
		wait(1000)
		sampSendChat("/me " ..annul.. " контракт сотрудника")
		wait(1000)
		sampSendChat("/uninvite " ..id.. " " ..reason)
		wait(1000)
		sampSendChat("/me " ..spratal.. " КПК в карман")
	end
end