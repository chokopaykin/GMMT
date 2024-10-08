-- ��������������
script_name("Foxi Tools")
script_version("1.0.0")
tag = '{7172EE}[Foxi Tools]{FFFFFF} '

local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('��������� %d �� %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('�������� ���������� ���������.')sampAddChatMessage(b..'���������� ���������!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'���������� ������ ��������. �������� ���������� ������..',m)update=false end end end)end,b)else update=false;print(b ..'���������� �� ���������.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, ������� �� �������� �������� ����������. ��������� ��� ��������� �������������� �� '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/chokopaykin/GMMT/refs/heads/main/autoupdate.json?" .. tostring(os.clock())
            Update.prefix = tag
            Update.url = ""
        end
    end
end

-- ��������������
local ffi = require 'ffi'
local imgui = require 'mimgui'
local pie = require('imgui_piemenu')
local memory = require('memory')
require "lib.moonloader"
local fa = require 'fAwesome6_solid'
local encoding = require('encoding')
encoding.default = 'CP1251'
u8 = encoding.UTF8
local new = imgui.new
local vkeys = require 'vkeys'
local ffi = require 'ffi'
local d3dx9_43 = ffi.load("d3dx9_43.dll")
local faicons = require('fAwesome6')
local sampev = require 'lib.samp.events'
local sf = require('sampfuncs')
require "strings"


-- inicfg
local inicfg = require 'inicfg'
local ini = inicfg.load({
    mainIni = {
        name = '',
        org = '',
        rank = '',
        checkinfo = false
    },
    Themes = {
        number = 0,
        alpha = 1,
        alpha_2 = 1
    },
    SmartSu = {
        zap = false,
        zapd = false
    },
},'FTools/Fox.ini')
inicfg.save(ini, 'FTools/Fox.ini')

local name = new.char[256](u8(ini.mainIni.name))
local org = new.char[256](u8(ini.mainIni.org))
local rank = new.char[256](u8(ini.mainIni.rank))
local checkinfo = new.bool(ini.mainIni.checkinfo)
local alpha = new.float(ini.Themes.alpha)
local alpha_2 = new.float(ini.Themes.alpha_2)
local text_check = new.bool()

-- ����
local decorList = {u8'Black Theme', u8'White Theme', u8'Blue Theme', u8'Orange Theme', u8'Gray Theme', u8'Green Theme', 'New Style', 'You Style'}
local decorListBuffer = imgui.new['const char*'][#decorList](decorList)
local decorListNumber = new.int(ini.Themes.number)
local styler = imgui.GetStyle()

-- ������ ��������
local WinState = new.bool()
local info_set = new.bool()
local tab = 1
local window_two = new.bool()
local flags = imgui.WindowFlags.NoMove + imgui.WindowFlags.NoDecoration
local json = require 'cjson'
local searchQuery_1 = new.char[256]()
local dnum = new.char[256]()
local ist = new.char[1024]()
local prot = new.char[1024]()
local tip = new.char[1024]()

--��� �������������� ���������
local set = inicfg.load({
    Settings = {
        name = false,
        teg = false,
        rank = false,
        city = false,
        pos = false,
        actient = false,
        act = '',
        not_flood = false
    },
},'FTools/Settings_Fox.ini')
inicfg.save(set, 'FTools/Settings_Fox.ini')

local info_name = new.bool(set.Settings.name)
local info_teg = new.bool(set.Settings.teg)
local info_rank = new.bool(set.Settings.rank)
local info_city = new.bool(set.Settings.city)
local info_pos = new.bool(set.Settings.pos)
local actient = new.bool(set.Settings.actient)
local act = new.char[500](u8(set.Settings.act))
local not_flood = new.bool(set.Settings.not_flood)
local startdelo = new.char[10000]()

-- ������������� �������� ��� �������� �������
local binders = {}
local new_binder = {text = '', command = '', delay = 1000, title = '', power = false} 
local blocks = {}
local new_block = {text = '', title = ''}
local window_edit_binder = new.bool(false) 
local texter = new.char[10000]()
local commander = new.char[256]()
local delay = new.int(1000)
local title = new.char[256]()

-- ����� ������
local ssu = new.bool()
local stik = new.bool()
local zap = new.bool(ini.SmartSu.zap)
local zapd = new.bool(ini.SmartSu.zapd)
local powerBool = new.bool(false)
local selectedBinderIndex = 1
local selectedBlockIndex = nil
local blocknote = new.char[10000]()
local blocktitle = new.char[256]()

-- initialization table
function get_first_last_name(nickname)
    local parts = {}
    for part in string.gmatch(nickname, "([^_]+)") do
        table.insert(parts, part)
    end
    return parts[1], parts[2] 
end

function countLinesInBinder(binder)
    if binder and binder.text then  
        local count = 1
        for _ in binder.text:gmatch("[\n]+") do
            count = count + 1
        end
        return count
    else
        return 0 
    end
end

local function saveSettings()
    ini.mainIni.name = u8:decode(ffi.string(name))
    ini.mainIni.org = u8:decode(ffi.string(org))
    ini.mainIni.rank = u8:decode(ffi.string(rank))
    ini.mainIni.checkinfo = checkinfo[0]
    inicfg.save(ini, 'FTools/Fox.ini')
    sampAddChatMessage(tag .. "��������� {7172EE}���������{FFFFFF}!", -1)
end

function saveBinders()
    local json_data = json.encode(binders)
    local file, err = io.open('moonloader/config/FTools/binders.json', 'w')
    if not file then
        sampAddChatMessage(tag .. "������ ��� ���������� ��������: " .. err, -1)
        return
    end
    file:write(json_data)
    file:close() 
end

function loadBinders()
    local file, err = io.open('moonloader/config/FTools/binders.json', 'r')
    if not file then
        sampAddChatMessage(tag .. "���� 'binders.json' �� ������. ������� �����.", -1)
        saveBinders()
        return
    end

    local json_data = file:read('*a')
    if json_data then
        binderData = json.decode(json_data)
        if binderData then
            binders = binderData
        else
            binders = {}
        end
    end
    file:close()
end

function saveNotes()
    local json_data = json.encode(blocks)
    local file, err = io.open('moonloader/config/FTools/notebook.json', 'w')
    if not file then
        sampAddChatMessage(tag .. "������ ��� ���������� ��������: " .. err, -1)
        return
    end
    file:write(json_data)
    file:close() 
end

function loadNotes()
    local file, err = io.open('moonloader/config/FTools/notebook.json', 'r')
    if not file then
        sampAddChatMessage(tag .. "���� 'notebook.json' �� ������. ������� �����.", -1)
        saveNotes()
        return
    end

    local json_data = file:read('*a')
    if json_data then
        notesData = json.decode(json_data)
        if notesData then
            blocks = notesData
        else
            blocks = {}
        end
    end
    file:close()
end

local function copyBinder(selectedIndex)
    local binderToCopy = binders[selectedIndex]  
    
    if binderToCopy then
        for i = 1, #binders do 

            newBinder = {
                title = ffi.string("����� " .. binderToCopy.title .. " " .. tostring(i)),
                text = ffi.string(binderToCopy.text),
                command = ffi.string(binderToCopy.command),
                delay = binderToCopy.delay,
                power = false
            }
        end
        
        print("����������� �������: " .. newBinder.title)

        table.insert(binders, newBinder)  
        
        if #binders > 0 then
            print("����� �������� ����� �����������: " .. #binders)
        else
            print("������: ������� �� ���������.")
        end
        
        saveBinders()
        
        sampAddChatMessage("���� " .. newBinder.title .. " ������� ����������!", -1)
    else
        sampAddChatMessage("�� ������� ����������� ��������� ����!", -1)
    end
end

function sampev.onSendChat(message)
    if actient[0] then
		if message == ')' or message == '(' or message ==  '))' or message == '((' or message == 'xD' or message == ':D' or message == ':d' or message == 'XD' then return{message} end
    return{'['..u8:decode(ffi.string(act))..' ������]: '..message}
    end
end

local cfg = inicfg.load({
    color_bg = {
        color_1 = 10,
        color_2 = 10,
        color_3 = 10,
    },
    child_bg = {
        color_1 = 12,
        color_2 = 12,
        color_3 = 12,
    },
    text_clr = {
        color_1 = 80,
        color_2 = 90,
        color_3 = 90,
    },
    button_clr = {
        color_1 = 30,
        color_2 = 30,
        color_3 = 30,
    },
    slide_clr = {
        color_1 = 10,
        color_2 = 10,
        color_3 = 10,
    },
    frame_clr = {
        color_1 = 20,
        color_2 = 20,
        color_3 = 20,
    },
    frame_clr2 = {
        color_1 = 30,
        color_2 = 30,
        color_3 = 30,
    },
    button_clr2 = {
        color_1 = 40,
        color_2 = 40,
        color_3 = 40,
    },
    title_bg = {
        color_1 = 20,
        color_2 = 20,
        color_3 = 20,
    },
    table_bg = {
        color_1 = 20,
        color_2 = 20,
        color_3 = 20,
    },
    checks = {
        obv = false,
        bord = 0.00,
        road = 8
    }
}, "linecolor")

local new_bord = new.float(cfg.checks.bord)
local obvod = new.bool(cfg.checks.obv)
local roading = new.int(cfg.checks.road)

function join_argb(a, b, g, r)
    local argb = b  -- b
    argb = bit.bor(argb, bit.lshift(g, 8))  -- g
    argb = bit.bor(argb, bit.lshift(r, 16)) -- r
    argb = bit.bor(argb, bit.lshift(a, 24)) -- a
    return argb
end


function imgui.VerticalSeparator()
    local draw_list = imgui.GetWindowDrawList()
    local pos = imgui.GetCursorScreenPos()
    local window_height = imgui.GetWindowHeight()
    local separator_x = pos.x
    local separator_color = imgui.GetColorU32(imgui.Col.Border)
   
    draw_list:AddLine(
        {separator_x, pos.y},
        {separator_x, pos.y + window_height},
        separator_color,
        1.0
    )
    imgui.Dummy({0, window_height})
end
function imgui.CText(text)
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX((imgui.GetWindowWidth() - calc.x) / 2)
    imgui.Text(text)
   end

function imgui.ACText(text)
    local width = imgui.GetWindowWidth()
    local height = imgui.GetWindowHeight()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.SetCursorPosY( height / 2 - calc.y / 2 )
    imgui.Text(text)
end




-- main()
function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do wait(100) end
    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    save_command()
    loadBinders()
    saveBinders()
    loadNotes()
    saveNotes()
    sampAddChatMessage(tag .. "������ {7172EE}�������", -1)
    sampAddChatMessage(tag .. "������� �������� ���� - {7172EE}/fox.", -1)
    sampRegisterChatCommand('fox', function() WinState[0] = not WinState[0] end)
    sampRegisterChatCommand('ssu', cmd_ssu)
    sampRegisterChatCommand('sticket', cmd_stik)
    sampRegisterChatCommand('mimgui', function()
        renderWindow[0] = not renderWindow[0]
    end)
    thread = lua_thread.create_suspended(thread_function)


    local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)

    if checkinfo[0] == true then
        window_two[0] = not window_two[0]
        imgui.showCursor = false
    end

    colors_bg = new.float[3](cfg.color_bg.color_3/255, cfg.color_bg.color_2/255, cfg.color_bg.color_1/255)
    childs_bg = new.float[3](cfg.child_bg.color_3/255, cfg.child_bg.color_2/255, cfg.child_bg.color_1/255)
    text_color = new.float[3](cfg.text_clr.color_3/255, cfg.text_clr.color_2/255, cfg.text_clr.color_1/255)
    but_color = new.float[3](cfg.button_clr.color_3/255, cfg.button_clr.color_2/255, cfg.button_clr.color_1/255)
    but_color2 = new.float[3](cfg.button_clr2.color_3/255, cfg.button_clr2.color_2/255, cfg.button_clr2.color_1/255)
    slide_color = new.float[3](cfg.slide_clr.color_3/255, cfg.slide_clr.color_2/255, cfg.slide_clr.color_1/255)
    frame_color = new.float[3](cfg.frame_clr.color_3/255, cfg.frame_clr.color_2/255, cfg.frame_clr.color_1/255)
    frame_color2 = new.float[3](cfg.frame_clr2.color_3/255, cfg.frame_clr2.color_2/255, cfg.frame_clr2.color_1/255)
    title_bg = new.float[3](cfg.title_bg.color_3/255, cfg.title_bg.color_2/255, cfg.title_bg.color_1/255)
    table_bg = new.float[3](cfg.table_bg.color_3/255, cfg.table_bg.color_2/255, cfg.table_bg.color_1/255)

    while true do
		wait(0)
		x,y,z = getCharCoordinates(PLAYER_PED)
        hp = getCharHealth(PLAYER_PED)
	end
end

function set_bg(argument_bg)
    imgui.SetNextWindowBgAlpha(argument_bg)
end

-- ���� ����������
imgui.OnFrame(function() return window_two[0] end, function(player)
    if bit.band(flags, imgui.WindowFlags.NoMove) == 0 then
        local x, y = getCursorPos()
        imgui.SetNextWindowPos(imgui.ImVec2(x, y), nil, imgui.ImVec2(0.5, 0.5))
        if imgui.IsMouseClicked(0) then
            flags = flags + imgui.WindowFlags.NoMove
            sampAddChatMessage(tag .. ' ��������� ���� ��������!', -1)
        end
    end
    set_bg(alpha_2[0])

    imgui.Begin("##yourinfo", window_two, flags + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
    local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local nickname = sampGetPlayerNickname(id)
    local fps = math.floor(memory.getfloat(12045136, true))
    local ping = sampGetPlayerPing(id)
    imgui.CText("FPS: " .. fps .. " | ".. ffi.string(nickname) .. '[' .. id .. '] | Ping: ' .. ping)
    imgui.Separator()
    if info_name[0] == true then
        imgui.TextWrapped(u8"���: " .. ffi.string(name))
    end
    if info_rank[0] == true then
        imgui.TextWrapped(u8"���: " .. ffi.string(org))
    end
    if info_teg[0] == true then
        imgui.TextWrapped(u8"���������: " .. ffi.string(rank))
    end
    if info_city[0] == true then
        imgui.TextWrapped(u8"�����: " .. calccity(x, y, z))
    end
    if info_pos[0] == true then
        imgui.TextWrapped(u8"�����: " .. calculateZone(x, y, z))
    end
    imgui.Separator()
    imgui.CText(os.date("%d.%m.%Y", os.time()) .. " " .. os.date('%H:%M:%S'))
    imgui.End()
end).HideCursor = true

local searchQuery = new.char[256]()

-- ����� ������
imgui.OnFrame(function() return ssu[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(500,500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(830,630), imgui.Cond.Always)
    imgui.Begin(fa.GAVEL .. u8" ����� ������", ssu, imgui.AlwaysAutoResize)
    imgui.InputText(u8"�����", searchQuery, 256)
    imgui.SameLine()
    if imgui.Checkbox(u8'������', zap) then
        if zap[0] == true then
            ini.SmartSu.zap = true
            inicfg.save(ini, 'FTools/Fox.ini')
        elseif zap[0] == false then
            ini.SmartSu.zap = false
            inicfg.save(ini, 'FTools/Fox.ini')
        end
    end
    imgui.SameLine()
    if imgui.Checkbox(u8'������ /d', zapd) then
        if zapd[0] == true then
            ini.SmartSu.zapd = true
            inicfg.save(ini, 'FTools/Fox.ini')
        elseif zapd[0] == false then
            ini.SmartSu.zapd = false
            inicfg.save(ini, 'FTools/Fox.ini')
        end
    end

    local filteredData = {}

    -- ���������� ������ ��� ������
    for article, offenses in apairs(lawsData) do
        if string.find(article:lower(), u8:decode(ffi.string(searchQuery)):lower()) or u8:decode(ffi.string(searchQuery)) == "" then
            filteredData[article] = offenses
        else
            for _, offense in ipairs(offenses) do
                -- ���������, ��������� �� ����� �� ��������� �������������� � ��������� ��������
                local code, description = offense[1], offense[2]
                if string.find(code:lower(), u8:decode(ffi.string(searchQuery)):lower()) or string.find(description:lower(), u8:decode(ffi.string(searchQuery)):lower()) then
                    if not filteredData[article] then
                        filteredData[article] = {}
                    end
                    table.insert(filteredData[article], offense)
                end
            end
        end
    end

    local sortedKeys = {
        "������ 1. ������������ ������ ����� � ��������",
        "������ 2. ������������ ������ �������, ����� � ����������� ��������",
        "������ 3. ������������ ������ �������������",
        "������ 4. ������������ ������ ��������",
        "������ 5. ����������� ������������",
        "������ 6. ������������ ������ ��������������� ������",
        "������ 7. ������������� ������������"
    }
    
    for _, article in ipairs(sortedKeys) do
        local offenses = filteredData[article]
        if offenses then  -- ���� ���� ����������
            if imgui.CollapsingHeader(u8(article)) then  -- ������� �������������� ���������
                for _, offense in ipairs(offenses) do
                    local code = offense[1]
                    local description = offense[2]
                    local penalty = offense[3]
                    imgui.Text(u8(string.format("%s | %s | %d*", code, description, penalty)))  -- ����������� �����
                    local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                    local nickname = sampGetPlayerNickname(id)
                    if imgui.IsItemClicked() then
                        lua_thread.create(function()
                            if zap[0] == true then
                                sampSendChat('/b ' .. nickname .. ' �� CONTROL. ���������� ���������� � ������ ���� ' .. suspect_id)
                                wait(2100)
                                sampSendChat('/b �������: ' .. code .. ' ' .. description)
                            elseif zapd[0] == true then
                                sampSendChat('/b [to MJ] ���������� ���������� � ������ ���� ' .. suspect_id)
                                wait(2100)
                                sampSendChat('/b [to MJ] �������: ' .. code .. ' ' .. description)
                            else
                                sampSendChat('/todo �������� � ������ ���� ' .. suspect_id .. '*������������ � �����������')
                                wait(1700)
                                sampAddChatMessage('/su ' .. suspect_id .. ' ' .. penalty .. ' ' .. code, -1)
                            end
                        end)
                    end
                end
            end
        end
    end
    imgui.End()
end)

imgui.OnFrame(function() return stik[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(500,500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(830,630), imgui.Cond.Always)
    imgui.Begin(fa.GAVEL .. u8" ����� �����", stik, imgui.AlwaysAutoResize)
    imgui.InputText(u8"�����", searchQuery_1, 256)

    local filteredData = {}

    -- ���������� ������ ��� ������
    for article, offenses in pairs(pddData) do
        if string.find(article:lower(), u8:decode(ffi.string(searchQuery_1)):lower()) or u8:decode(ffi.string(searchQuery_1)) == "" then
            filteredData[article] = offenses
        else
            for _, offense in ipairs(offenses) do
                -- ���������, ��������� �� ����� �� ��������� �������������� � ��������� ��������
                local code, description = offense[1], offense[2]
                if string.find(code:lower(), u8:decode(ffi.string(searchQuery_1)):lower()) or string.find(description:lower(), u8:decode(ffi.string(searchQuery_1)):lower()) then
                    if not filteredData[article] then
                        filteredData[article] = {}
                    end
                    table.insert(filteredData[article], offense)
                end
            end
        end
    end

    local sortedKeys_2 = {
        "������ 2.1. ���������� �����",
        "������ 2.2. ���� � ��������� ����",
        "������ 2.3. �������� � ������������ �����",
        "������ 2.4. ���� �� ��������� ������ ��� � ������������ �����",
        "������ 2.5. �������-������������ ������������",
        "������ 2.6. ���� ���������-���������� ��� � ����� ��� ������������",
        "������ 2.7. ������������� ����. ��������",
        "������ 2.8. ��������� ��������� ������ ��������� ��������"
    }
    
    for _, article in ipairs(sortedKeys_2) do
        local offenses = filteredData[article]
        if offenses then  -- ���� ���� ����������
            if imgui.CollapsingHeader(u8(article)) then  -- ������� �������������� ���������
                for _, offense in ipairs(offenses) do
                    local code_1 = offense[1]
                    local description_2 = offense[2]
                    local penalty_3 = offense[3]
                    imgui.Text(u8(string.format("%s | %s | %d$", code_1, description_2, penalty_3)))  -- ����������� �����
                    local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                    if imgui.IsItemClicked() then
                        lua_thread.create(function()
                            sampSendChat('��������, �� � �������� �������� ��� ����� � ������� ' .. penalty_3 .. '$')
                            wait(1700)
                            sampSendChat('/me ������ �� �������� ����� � �����, ����� ��������� �����')
                            wait(1700)
                            sampSendChat('/me �������� ��������� �����, ������� ����� � ����� ��������')
                            wait(1700)
                            sampSendChat('/todo ��������� ��� �����*�������� ������� �� ������ �������')
                            wait(1700)
                            sampAddChatMessage('/ticket ' .. ticket_id .. " " .. penalty_3 .. " " .. code_1, -1)
                        end)
                    end
                end
            end
        end
    end
    imgui.End()
end)


-- ���������� ����
function save_themes()
    ini.Themes.number = decorListNumber[0]
    inicfg.save(ini, 'FTools/Fox.ini')
    imgui.SetNextWindowBgAlpha(alpha[0])
end

-- ����� ������ ���. �������
function cmd_ssu(arg)
    suspect_id = arg
    if arg == '' then
        sampAddChatMessage(tag .. '�� �� ������� id ����e���!', -1)
    else
        ssu[0] = not ssu[0]
    end
    ini.mainIni.purID = arg
    inicfg.save(ini, 'FTools/Fox.ini')
end

function cmd_stik(arg)
    ticket_id = arg
    if arg == '' then
        sampAddChatMessage(tag .. '�� �� ������� id ����e���!', -1)
    else
        stik[0] = not stik[0]
    end
end



local binder = {}

function sampev.onSendCommand(arguments)
    local command, par, par_2, par_3, par_4, par_5 = arguments:match("/(%S+)%s*(%S*)%s*(%S*)%s*(%S*)%s*(%S*)%s*(%S*)")
    if binder[command] then
        lua_thread.create(function()
            for i, v in ipairs(binder[command]) do
                local input_all = v

                -- �������� ��� � ID ������
                local playerId = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
                local playerNick = sampGetPlayerNickname(playerId)
                local first_name, last_name = get_first_last_name(playerNick)
                local hp = getCharHealth(PLAYER_PED)
                local arm = sampGetPlayerArmor(playerId)
                
                -- �������� ���� �� ��������������� ��������, ���� ��� ���� � ������
                input_all = input_all:gsub('{my_nick}', playerNick)
                input_all = input_all:gsub('{my_id}', playerId)
                input_all = input_all:gsub('{my_name}', first_name)
                input_all = input_all:gsub('{my_surname}', last_name)
                input_all = input_all:gsub('{my_rpnick}', first_name .. " " .. last_name)
                input_all = input_all:gsub('{my_hp}', hp)
                input_all = input_all:gsub('{my_armour}', arm)
                input_all = input_all:gsub('{arg_1}', par)
                input_all = input_all:gsub('{arg_2}', par_2)
                input_all = input_all:gsub('{arg_3}', par_3)
                input_all = input_all:gsub('{arg_4}', par_4)
                input_all = input_all:gsub('{arg_5}', par_5)

                -- ���������� ��������� � ���
                sampSendChat(input_all)
                wait(delay[0])
            end
        end)
        return false
    end
end

function save_command() -- ������� � �������������� �������
    if powerBool[0] == false then
        binder = {}
        for i, v in ipairs(binders) do
            binder[v.command] = {}
            for line in v.text:gmatch("[^\n]+") do
                table.insert(binder[v.command], line)
            end
        end
    elseif powerBool[0] == true then
        sampAddChatMessage(tag .. ' ���� ��������! ������ �������� ��� � ����.')
    end
end



local window_new_binder = new.bool(false)
imgui.OnFrame(function() return window_new_binder[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(600, 600), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(600, 350), imgui.Cond.Always)
    imgui.Begin(fa.PEN .. u8" ������� ����", window_new_binder, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoFocusOnAppearing)
    imgui.InputTextWithHint(u8'##�������� �������', u8'������� �������� �����', title, 256)
    imgui.InputTextMultiline(u8'##�����', texter, 10000)
    imgui.SameLine()
    imgui.SetCursorPos(imgui.ImVec2(413, 42))
    if imgui.Button(u8'���������', imgui.ImVec2(177, 30)) then
        table.insert(binders, {
            text = u8:decode(ffi.string(texter)),
            command = ffi.string(commander),
            delay = delay[0],
            title = u8:decode(ffi.string(title)),
            power = false
        })
        save_command()
        saveBinders()
        window_new_binder[0] = false
        WinState[0] = true
    end
    imgui.SameLine()
    imgui.SetCursorPos(imgui.ImVec2(413, 80))
    if imgui.Button(u8'������', imgui.ImVec2(177, 30)) then
        window_new_binder[0] = false
        WinState[0] = true
    end
    imgui.SameLine()
    imgui.SetCursorPos(imgui.ImVec2(413, 141))
    imgui.PushItemWidth(177)
    imgui.SliderInt(u8'�������� (��)', delay, 1000, 5000)
    imgui.PopItemWidth()
    imgui.SameLine()
    imgui.SetCursorPos(imgui.ImVec2(413, 111))
    imgui.Text(u8'�������� (��):')
    imgui.SetCursorPos(imgui.ImVec2(15, 211))
    imgui.InputTextWithHint(u8'##������� ������� (��� /)', u8'������� ������� (��� /)', commander, 256)
    imgui.SameLine()
    imgui.SetCursorPos(imgui.ImVec2(413, 170))
    imgui.Text(fa.CIRCLE_INFO .. u8' ����')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.Text(u8'����:\n{my_nick} - ������� ��� ��� � ������� Nick_Name\n{my_id} - ������� ��� ID\n{my_name} - ������� ���\n{my_surname} - ������� �������\n{my_rpnick} - ������� ��� � �� ������� (��� "_")\n{my_hp} - ������� ���� �������� (HP)\n{my_armour} - ������� ���� �����\n{arg_1} - ������ �������� � �������\n{arg_2} - ������ �������� � �������\n{arg_3} - ������ �������� � �������\n{arg_4} - ��������� �������� � �������\n{arg_5} - ������ �������� � �������\n')
        imgui.EndTooltip()
    end
    imgui.End()
    imgui.End()
end)


local window_edit_binder = new.bool(false)
imgui.OnFrame(function() return window_edit_binder[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(600, 600), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(600, 350), imgui.Cond.Always)
    imgui.Begin(fa.PEN .. u8" ������������� ����", window_edit_binder, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoFocusOnAppearing)
    imgui.InputTextWithHint(u8'##�������� �������', u8'������� �������� �����', title, 256)
    imgui.InputTextMultiline(u8'##�����', texter, 10000)
    imgui.SameLine()
    imgui.SetCursorPos(imgui.ImVec2(413, 42))
    if imgui.Button(u8'���������', imgui.ImVec2(177, 30)) then
        if selectedBinderIndex then
            binders[selectedBinderIndex] = {
                text = u8:decode(ffi.string(texter)),
                command = ffi.string(commander),
                delay = delay[0],
                title = u8:decode(ffi.string(title)),
                power = false
            }
            save_command()
            saveBinders()
        end
        window_edit_binder[0] = false
        WinState[0] = true
    end
    imgui.SameLine()
    imgui.SetCursorPos(imgui.ImVec2(413, 80))
    if imgui.Button(u8'������', imgui.ImVec2(177, 30)) then
        WinState[0] = true
        window_edit_binder[0] = false
    end
    imgui.SameLine()
    imgui.SetCursorPos(imgui.ImVec2(413, 141))
    imgui.PushItemWidth(177)
    imgui.SliderInt(u8'�������� (��)', delay, 1000, 5000)
    imgui.PopItemWidth()
    imgui.SameLine()
    imgui.SetCursorPos(imgui.ImVec2(413, 111))
    imgui.Text(u8'�������� (��):')
    imgui.SetCursorPos(imgui.ImVec2(15, 211))
    imgui.InputTextWithHint(u8'##������� ������� (��� /)', u8'������� ������� (��� /)', commander, 256)
    imgui.SameLine()
    imgui.SetCursorPos(imgui.ImVec2(413, 170))
    imgui.Text(fa.CIRCLE_INFO .. u8' ����')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.Text(u8'����:\n{my_nick} - ������� ��� ��� � ������� Nick_Name\n{my_id} - ������� ��� ID\n{my_name} - ������� ���\n{my_surname} - ������� �������\n{my_rpnick} - ������� ��� � �� ������� (��� "_")\n{my_hp} - ������� ���� �������� (HP)\n{my_armour} - ������� ���� �����\n{arg_1} - ������ �������� � �������\n{arg_2} - ������ �������� � �������\n{arg_3} - ������ �������� � �������\n{arg_4} - ��������� �������� � �������\n{arg_5} - ������ �������� � �������\n')        imgui.EndTooltip()
    end
    imgui.End()
    imgui.End()
end)

local about_us = new.bool(false)
imgui.OnFrame(function() return about_us[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(600, 600), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(180, 160), imgui.Cond.Always)
    imgui.Begin(fa.CIRCLE_INFO .. u8" ����������", about_us, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoFocusOnAppearing)
    imgui.Text(u8'��� �������: Foxi Tools')
    imgui.Text(u8'������: v1.0.0r')
    imgui.Text(u8'�����: Joa')
    if imgui.Button(u8'�������', imgui.ImVec2(150, 30)) then
        about_us[0] = false
    end
end)

imgui.OnInitialize(function()
    if doesFileExist(getWorkingDirectory()..'\\resource\\example.png') then -- ������� ����������� �������� � ��������� example.png � ����� moonloader/resource/
        imhandle = imgui.CreateTextureFromFile(getWorkingDirectory() .. '\\resource\\example.png') -- ���� �������, �� ���������� � ���������� ����� ��������
    end
end)

local info_set = new.bool(false)
imgui.OnFrame(function() return info_set[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(600, 600), imgui.Cond.FirstUseEver)
    imgui.Begin(fa.GEARS .. u8" �������������� ����������", info_set, imgui.WindowFlags.AlwaysAutoResize)
    if imgui.Checkbox(u8'���', info_name) then
        if info_name[0] == true then
            set.Settings.name = info_name[0]
            inicfg.save(set, 'FTools/Settings_Fox.ini')
        else
            set.Settings.name = info_name[0]
            inicfg.save(set, 'FTools/Settings_Fox.ini')
        end
    end
    if imgui.Checkbox(u8'���������', info_teg) then
        if info_teg[0] == true then
            set.Settings.rank = info_teg[0]
            inicfg.save(set, 'FTools/Settings_Fox.ini')
        else
            set.Settings.rank = info_teg[0]
            inicfg.save(set, 'FTools/Settings_Fox.ini')
        end
    end
    if imgui.Checkbox(u8'���', info_rank) then
        if info_rank[0] == true then
            set.Settings.teg = info_rank[0]
            inicfg.save(set, 'FTools/Settings_Fox.ini')
        else
            set.Settings.teg = info_rank[0]
            inicfg.save(set, 'FTools/Settings_Fox.ini')
        end
    end
    if imgui.Checkbox(u8'�����', info_city) then
        if info_city[0] == true then
            set.Settings.city = info_city[0]
            inicfg.save(set, 'FTools/Settings_Fox.ini')
        else
            set.Settings.city = info_city[0]
            inicfg.save(set, 'FTools/Settings_Fox.ini')
        end
    end
    if imgui.Checkbox(u8'�����', info_pos) then
        if info_city[0] == true then
            set.Settings.pos = info_pos[0]
            inicfg.save(set, 'FTools/Settings_Fox.ini')
        else
            set.Settings.pos = info_pos[0]
            inicfg.save(set, 'FTools/Settings_Fox.ini')
        end
    end
    if imgui.SliderFloat(u8'##������������_2', alpha_2, 0, 1) then
        ini.Themes.alpha_2 = alpha_2[0]
        inicfg.save(ini, 'FTools/Fox.ini')
        
    end
    if imgui.Button(fa.UP_DOWN_LEFT_RIGHT .. u8' ��������������') then
        flags = (bit.band(flags, imgui.WindowFlags.NoMove) == 1) and (flags - imgui.WindowFlags.NoMove) or (flags + imgui.WindowFlags.NoMove)
    end
    imgui.End()
end)

-- ������� ����
imgui.OnFrame(function() return WinState[0] and not isGamePaused() end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(500,500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(1000,530), imgui.Cond.Always)
    imgui.Begin(fa.USER_SECRET .. ' Foxi Tools', WinState, imgui.WindowFlags.AlwaysAutoResize)
    if imgui.BeginChild('Main', imgui.ImVec2(170, 470), true) then
        local style = imgui.GetStyle()
        style.FramePadding = imgui.ImVec2(8, 7)
        ---imgui.SetCursorPos(imgui.ImVec2(35, 5))
        --imgui.Image(imhandle, imgui.ImVec2(100, 100)) 
        if imgui.Button(fa.GEAR .. u8' ��������', imgui.ImVec2(140, 40)) then tab = 1 end
        if imgui.Button(fa.GAVEL .. u8' ����������������', imgui.ImVec2(140, 40)) then tab = 2 end
        if imgui.Button(fa.TABLE_LIST .. u8' ������', imgui.ImVec2(140, 40)) then tab = 4 end
        if imgui.Button(fa.NOTE_STICKY .. u8' �������', imgui.ImVec2(140, 40)) then tab = 5 end
        if imgui.Button(fa.BUILDING_COLUMNS .. u8' Court Room', imgui.ImVec2(140, 40)) then tab = 7 end
        if ini.Themes.number == 7 then
            if imgui.Button(fa.PALETTE .. u8' ��������� ����', imgui.ImVec2(140, 40)) then tab = 8 end
        end
        imgui.SetCursorPos(imgui.ImVec2(14, 388))
        if imgui.Button(faicons.CIRCLE_INFO) then
            about_us[0] = not about_us[0]
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
            imgui.Text(u8'���������� � �������')
            imgui.EndTooltip()
        end
        imgui.SameLine()
        if imgui.Button(fa.HEADSET) then 
            os.execute("start https://vk.com/imclownreal")
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
            imgui.Text(u8'����������� ���������')
            imgui.EndTooltip()
        end
        imgui.SameLine()
        if imgui.Button(fa.FLOPPY_DISK) then
            saveSettings()
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
            imgui.Text(u8'��������� ���������')
            imgui.EndTooltip()
        end
        imgui.SameLine()
        if imgui.Button(fa.ROTATE) then
            sampAddChatMessage(tag .. "������ ���������������.", -1)
            thisScript():reload()
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
            imgui.Text(u8'������������� ������')
            imgui.EndTooltip()
        end
        if imgui.Button(fa.POWER_OFF .. u8" ���������", imgui.ImVec2(143, 30)) then
            sampAddChatMessage(tag .. "���������� {7172EE}����������{FFFFFF} �������!", -1)
            sampAddChatMessage(tag .. "������ {7172EE}��������{FFFFFF}!", -1)
            exit()
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
           imgui.Text(u8'��������� ������')
            imgui.EndTooltip()
        end
        imgui.EndChild()
    end

    if tab == 8 then
        imgui.SetCursorPos(imgui.ImVec2(190, 43))
        if imgui.BeginChild('Tema', imgui.ImVec2(795, 470), true) then
            imgui.Button(u8'��������� ����', imgui.ImVec2(765, 30))
            if imgui.BeginChild('VnTheme', imgui.ImVec2(765, 400), true) then
                if imgui.ColorEdit3("##!1", colors_bg) then -- ���� �� ���� ��� ����� �� ������ - imgui.ColorEditFlags.NoInputs
                    local clr = join_argb(0, colors_bg[2] * 255, colors_bg[1] * 255, colors_bg[0] * 255)
                    r,g,b = colors_bg[2] * 255, colors_bg[1] * 255, colors_bg[0] * 255
                
                    cfg.color_bg.color = ("0xFF%06X"):format(clr)
                    cfg.color_bg.color_1 = r
                    cfg.color_bg.color_2 = g
                    cfg.color_bg.color_3 = b
                    inicfg.save(cfg, 'linecolor.ini')
                    imgui.SwitchContext()
                    imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(b / 255, g /255, r /255, 1.00)
                    
                end
                imgui.SameLine()
                imgui.Text(u8'���� ����')
                if imgui.ColorEdit3("##2", childs_bg) then -- ���� �� ���� ��� ����� �� ������ - imgui.ColorEditFlags.NoInputs
                    local clr3 = join_argb(0, childs_bg[2] * 255, childs_bg[1] * 255, childs_bg[0] * 255)
                    r2,g2,b2 = childs_bg[2] * 255, childs_bg[1] * 255, childs_bg[0] * 255
                
                    cfg.child_bg.color = ("0xFF%06X"):format(clr3)
                    cfg.child_bg.color_1 = r2
                    cfg.child_bg.color_2 = g2
                    cfg.child_bg.color_3 = b2
                    inicfg.save(cfg, 'linecolor.ini')
                    imgui.SwitchContext()
                    imgui.GetStyle().Colors[imgui.Col.ChildBg] = imgui.ImVec4(b2 / 255, g2 /255, r2 /255, 1.00)
                end
                imgui.SameLine()
                imgui.Text(u8'���� ������')
                if imgui.ColorEdit3("##3", text_color) then -- ���� �� ���� ��� ����� �� ������ - imgui.ColorEditFlags.NoInputs
                    local clr2 = join_argb(0, text_color[2] * 255, text_color[1] * 255, text_color[0] * 255)
                    r3,g3,b3 = text_color[2] * 255, text_color[1] * 255, text_color[0] * 255
                
                    cfg.text_clr.color = ("0xFF%06X"):format(clr2)
                    cfg.text_clr.color_1 = r3
                    cfg.text_clr.color_2 = g3
                    cfg.text_clr.color_3 = b3
                    inicfg.save(cfg, 'linecolor.ini')
                    imgui.SwitchContext()
                    imgui.GetStyle().Colors[imgui.Col.Text] = imgui.ImVec4(b3 / 255, g3 /255, r3 /255, 1.00)
                end
                imgui.SameLine()
                imgui.Text(u8'���� ������')
                if imgui.ColorEdit3("##4", but_color) then -- ���� �� ���� ��� ����� �� ������ - imgui.ColorEditFlags.NoInputs
                    local clr4 = join_argb(0, but_color[2] * 255, but_color[1] * 255, but_color[0] * 255)
                    r4,g4,b4 = but_color[2] * 255, but_color[1] * 255, but_color[0] * 255
                
                    cfg.button_clr.color = ("0xFF%06X"):format(clr4)
                    cfg.button_clr.color_1 = r4
                    cfg.button_clr.color_2 = g4
                    cfg.button_clr.color_3 = b4
                    inicfg.save(cfg, 'linecolor.ini')
                    imgui.SwitchContext()
                    imgui.GetStyle().Colors[imgui.Col.Button] = imgui.ImVec4(b4 / 255, g4 /255, r4 /255, 1.00)
                end
                imgui.SameLine()
                imgui.Text(u8'���� ������')
                if imgui.ColorEdit3("##8", but_color2) then -- ���� �� ���� ��� ����� �� ������ - imgui.ColorEditFlags.NoInputs
                    local clr8 = join_argb(0, but_color2[2] * 255, but_color2[1] * 255, but_color2[0] * 255)
                    r8,g8,b8 = but_color2[2] * 255, but_color2[1] * 255, but_color2[0] * 255
                
                    cfg.button_clr2.color = ("0xFF%06X"):format(clr8)
                    cfg.button_clr2.color_1 = r8
                    cfg.button_clr2.color_2 = g8
                    cfg.button_clr2.color_3 = b8
                    inicfg.save(cfg, 'linecolor.ini')
                    imgui.SwitchContext()
                    imgui.GetStyle().Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(b8 / 255, g8 /255, r8 /255, 1.00)
                end
                imgui.SameLine()
                imgui.Text(u8'���� ������ (��� ���������)')
                if imgui.ColorEdit3("##5", slide_color) then -- ���� �� ���� ��� ����� �� ������ - imgui.ColorEditFlags.NoInputs
                    local clr5 = join_argb(0, slide_color[2] * 255, slide_color[1] * 255, slide_color[0] * 255)
                    r5,g5,b5 = slide_color[2] * 255, slide_color[1] * 255, slide_color[0] * 255
                
                    cfg.slide_clr.color = ("0xFF%06X"):format(clr5)
                    cfg.slide_clr.color_1 = r5
                    cfg.slide_clr.color_2 = g5
                    cfg.slide_clr.color_3 = b5
                    inicfg.save(cfg, 'linecolor.ini')
                    imgui.SwitchContext()
                    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(b5 / 255, g5 /255, r5 /255, 1.00)
                end
                imgui.SameLine()
                imgui.Text(u8'���� ��������')
                if imgui.ColorEdit3("##6", frame_color) then -- ���� �� ���� ��� ����� �� ������ - imgui.ColorEditFlags.NoInputs
                    local clr6 = join_argb(0, frame_color[2] * 255, frame_color[1] * 255, frame_color[0] * 255)
                    r6,g6,b6 = frame_color[2] * 255, frame_color[1] * 255, frame_color[0] * 255
                
                    cfg.frame_clr.color = ("0xFF%06X"):format(clr6)
                    cfg.frame_clr.color_1 = r6
                    cfg.frame_clr.color_2 = g6
                    cfg.frame_clr.color_3 = b6
                    inicfg.save(cfg, 'linecolor.ini')
                    imgui.SwitchContext()
                    imgui.GetStyle().Colors[imgui.Col.FrameBg] = imgui.ImVec4(b6 / 255, g6 /255, r6 /255, 1.00)
                end
                imgui.SameLine()
                imgui.Text(u8'���� ��������')
                if imgui.ColorEdit3("##7", frame_color2) then -- ���� �� ���� ��� ����� �� ������ - imgui.ColorEditFlags.NoInputs
                    local clr7 = join_argb(0, frame_color2[2] * 255, frame_color2[1] * 255, frame_color2[0] * 255)
                    r7,g7,b7 = frame_color2[2] * 255, frame_color2[1] * 255, frame_color2[0] * 255
                
                    cfg.frame_clr2.color = ("0xFF%06X"):format(clr7)
                    cfg.frame_clr2.color_1 = r7
                    cfg.frame_clr2.color_2 = g7
                    cfg.frame_clr2.color_3 = b7
                    inicfg.save(cfg, 'linecolor.ini')
                    imgui.SwitchContext()
                    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(b7 / 255, g7 /255, r7 /255, 1.00)
                end
                imgui.SameLine()
                imgui.Text(u8'���� �������� (��� ���������)')
                if imgui.ColorEdit3("##9", title_bg) then -- ���� �� ���� ��� ����� �� ������ - imgui.ColorEditFlags.NoInputs
                    local clr9 = join_argb(0, title_bg[2] * 255, title_bg[1] * 255, title_bg[0] * 255)
                    r9,g9,b9 = title_bg[2] * 255, title_bg[1] * 255, title_bg[0] * 255
                
                    cfg.title_bg.color = ("0xFF%06X"):format(clr9)
                    cfg.title_bg.color_1 = r9
                    cfg.title_bg.color_2 = g9
                    cfg.title_bg.color_3 = b9
                    inicfg.save(cfg, 'linecolor.ini')
                    imgui.SwitchContext()
                    imgui.GetStyle().Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(b9 / 255, g9 /255, r9 /255, 1.00)
                end
                imgui.SameLine()
                imgui.Text(u8'���� ���������')
                if imgui.ColorEdit3("##10", table_bg) then -- ���� �� ���� ��� ����� �� ������ - imgui.ColorEditFlags.NoInputs
                    local clr10 = join_argb(0, table_bg[2] * 255, table_bg[1] * 255, table_bg[0] * 255)
                    r10,g10,b10 = table_bg[2] * 255, table_bg[1] * 255, table_bg[0] * 255
                
                    cfg.table_bg.color = ("0xFF%06X"):format(clr10)
                    cfg.table_bg.color_1 = r10
                    cfg.table_bg.color_2 = g10
                    cfg.table_bg.color_3 = b10
                    inicfg.save(cfg, 'linecolor.ini')
                    imgui.SwitchContext()
                    imgui.GetStyle().Colors[imgui.Col.Header] = imgui.ImVec4(b10 / 255, g10 /255, r10 /255, 1.00)
                end
                imgui.SameLine()
                imgui.Text(u8'���� � �������')
                if imgui.SliderInt(u8'�����������', roading, 0, 12) then
                    cfg.checks.road = roading[0]
                    inicfg.save(cfg, 'linecolor.ini')
                    imgui.SwitchContext()
                    imgui.GetStyle().FrameRounding = roading[0]
                end    
                imgui.Checkbox(u8'������� ���������', obvod)
                if obvod[0] == true then
                    cfg.checks.bord = 1.00
                    cfg.checks.obv = true
                    inicfg.save(cfg, 'linecolor.ini')
                    imgui.SwitchContext()
                    imgui.GetStyle().FrameBorderSize = 1.00
                else
                    cfg.checks.bord = 0.00
                    cfg.checks.obv = false
                    inicfg.save(cfg, 'linecolor.ini')
                    imgui.SwitchContext()
                    imgui.GetStyle().FrameBorderSize = 0.00
                end
            end
            imgui.EndChild()
        end
        imgui.EndChild()
    end

    if tab == 5 then
        imgui.SetCursorPos(imgui.ImVec2(190, 43))
        
        if imgui.BeginChild('Shpora', imgui.ImVec2(795, 470), true) then
            imgui.Button(u8'�������', imgui.ImVec2(765, 30))
    
            -- ������ ������
            if imgui.BeginChild('Block List', imgui.ImVec2(150, 400), true) then
                imgui.Columns(1)
                imgui.CText(fa.SIGNATURE .. u8' �������')
                imgui.Columns(1)
                imgui.Separator()
                imgui.Columns(1)
    
                for i = 1, #blocks do 
                    local block = blocks[i]
                    if imgui.Selectable(u8(block.title), selectedBlockIndex == i) then
                        selectedBlockIndex = i
                        selectedBlockIndex = i
                        -- ��������� ���� ��� ������ �����
                        blocknote = new.char[10000](u8(block.text)) -- �������� ������ ���������� �����
                        blocktitle = new.char[256](u8(block.title)) -- �������� �������� ���������� �����
                    end
                    imgui.Columns(1)
                    imgui.Separator()
                end
                
                imgui.EndChild()
            end
    
            imgui.SameLine()
    
            -- �������� ���������� �����
            if imgui.BeginChild('Block Edit', imgui.ImVec2(607, 400), true) then
                imgui.CText(fa.PEN .. u8' �������� �������')
                imgui.Separator()
    
                -- ���� ��� �������������� ��������
                imgui.PushItemWidth(463)
                imgui.InputText('##titleofnotes', blocktitle, 256)
    
                -- ������ ��� �������� ������ �����
                imgui.SameLine()
                if imgui.Button(faicons.PLUS) then
                    selectedBlockIndex = nil
                    blocktitle = new.char[256]()
                    blocknote = new.char[10000]()
                end
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    imgui.Text(u8'����� �������')
                    imgui.EndTooltip()
                end
    
                -- ������ ��� ���������� �����
                imgui.SameLine()
                if imgui.Button(fa.FLOPPY_DISK) then
                    if selectedBlockIndex then
                        blocks[selectedBlockIndex].text = u8:decode(ffi.string(blocknote))
                        blocks[selectedBlockIndex].title = u8:decode(ffi.string(blocktitle))
                    end
                    table.insert(blocks, {
                        text = u8:decode(ffi.string(blocknote)),
                        title = u8:decode(ffi.string(blocktitle))
                    })
                    saveNotes()
                end
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    imgui.Text(u8'��������� �������')
                    imgui.EndTooltip()
                end
    
                -- ������ ��� �������� �����
                imgui.SameLine()
                if imgui.Button(fa.TRASH) and selectedBlockIndex then
                    table.remove(blocks, selectedBlockIndex)
                    selectedBlockIndex = nil
                    blocknote = new.char[10000]()
                    blocktitle = new.char[256]()
                    saveNotes()
                end
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    imgui.Text(u8'������� �������')
                    imgui.EndTooltip()
                end
                
                imgui.PopItemWidth()
    
                -- ���� ��� �������������� ������ �����
                imgui.PushItemWidth(575)
                imgui.InputTextMultiline('##textmultiline', blocknote, 10000, imgui.ImVec2(575, 300))
                imgui.PopItemWidth()
    
                -- ���������� ����� ��� ������ ����� ���������� � ����� ���� (��� ������ � ������)
                
                imgui.EndChild()
            end
        end
    end

    if tab == 7 then
        imgui.SetCursorPos(imgui.ImVec2(190, 43))
        if imgui.BeginChild('Sobes', imgui.ImVec2(795, 470), true) then
            imgui.Button(u8'Court Room', imgui.ImVec2(765, 30))
            if imgui.BeginChild('Start', imgui.ImVec2(765, 196), true) then
                --imgui.Text(u8'�����: ')
                --imgui.SameLine()
                imgui.PushItemWidth(100)
                imgui.InputTextWithHint(u8'##����� ��������', u8"���� �", dnum, 256)
                imgui.PopItemWidth()
                imgui.SameLine()
                imgui.PushItemWidth(202)
                imgui.InputTextWithHint(u8'##���', u8"���������/����������� � �.�", tip, 1024)
                imgui.PopItemWidth()
                --imgui.Text(u8'��: ')

                imgui.SameLine()
                imgui.PushItemWidth(204)
                imgui.InputTextWithHint(u8'##�����', u8"�����/���. ����������", ist, 1024)
                imgui.PopItemWidth()
                --imgui.Text(u8'������: ')
                imgui.SameLine()
                imgui.PushItemWidth(204)
                imgui.InputTextWithHint(u8'##�����', u8"��������/����������", prot, 1024)
                imgui.PopItemWidth()
                imgui.PushItemWidth(733)
                imgui.InputTextMultiline('##startdelo', startdelo, 10000)
                imgui.PopItemWidth()
 
            end
            imgui.EndChild()
            if imgui.BeginChild('End', imgui.ImVec2(765, 196), true) then
                imgui.Button(u8'�������� ��������� ��������')
                imgui.Button(u8'�������� ��������� ��������')
                imgui.SetCursorPos(imgui.ImVec2(220,15))
                imgui.SetCursorPos(imgui.ImVec2(225,15))
                imgui.Button(u8'�������� ����� �����/���������')
                imgui.SetCursorPos(imgui.ImVec2(225,50))
                imgui.Button(u8'�������� ����� ��������/������')
            end
            imgui.EndChild()
        end
    end

    if tab == 2 then
        imgui.SetCursorPos(imgui.ImVec2(190, 43))
        if imgui.BeginChild('Law', imgui.ImVec2(795, 470), true) then
            imgui.Button(u8'����������������', imgui.ImVec2(765, 30))
            if imgui.BeginChild('Law List', imgui.ImVec2(150, 400), true) then
                imgui.Columns(1)
                imgui.CText(fa.GAVEL .. u8' ������')
                imgui.Columns(1)
                imgui.Separator()

                imgui.Columns(1)
                imgui.CText(fa.TRIANGLE_EXCLAMATION .. u8' Error 404')
                imgui.Columns(1)
                imgui.Separator()
            end
            imgui.EndChild()
            imgui.SameLine()
            if imgui.BeginChild('Law Edit', imgui.ImVec2(607, 400), true) then
                imgui.ACText(fa.TRIANGLE_EXCLAMATION .. u8' Error 404. Not Found')
            end
            imgui.EndChild()
        end


    elseif tab == 4 then
        imgui.SetCursorPos(imgui.ImVec2(190, 43))
        if imgui.BeginChild('Binder', imgui.ImVec2(795, 470), true) then
            imgui.Button(u8'������', imgui.ImVec2(765, 30))
            if imgui.BeginChild('Binder List', imgui.ImVec2(765, 365), true) then
                imgui.Columns(5)
                imgui.Text(fa.LIST_OL) imgui.SetColumnWidth(-1, 35)
                imgui.NextColumn()
                
                imgui.Text(fa.SIGNATURE .. u8' �������� �����:') imgui.SetColumnWidth(-1, 370) -- ������ �������
                imgui.NextColumn()
                
                imgui.Text(fa.TERMINAL .. u8' �������:') imgui.SetColumnWidth(-1, 170) -- ������ �������
                imgui.NextColumn()
                imgui.Text(fa.BARS .. u8' ������:') imgui.SetColumnWidth(-1, 75) -- ������ �������
                imgui.NextColumn()
                imgui.Text(fa.CLOCK .. u8' ��������:') imgui.SetColumnWidth(-1, 100) -- ������ �������
                imgui.Columns(1)
                imgui.Separator()
                
                for i = 1, #binders do 
                    local binder = binders[i]
                    imgui.Columns(5)
                    
                    
                    imgui.Text(tostring(i)) imgui.SetColumnWidth(-1, 35)
                    imgui.NextColumn()
        
                    
                    if imgui.Selectable(u8(binder.title), selectedBinderIndex == i) then
                        selectedBinderIndex = i
                    end

                    imgui.SetColumnWidth(-1, 370)
                    imgui.NextColumn()
        
                    imgui.Text('/' .. u8(binder.command)) imgui.SetColumnWidth(-1, 170) -- ������� �������
                    imgui.NextColumn()
                    local lineCount = countLinesInBinder(binder)
                    imgui.Text(tostring(lineCount)) imgui.SetColumnWidth(-1, 75)
                    imgui.NextColumn()
                    imgui.Text(u8(tostring(binder.delay / 1000) .. " ���." )) imgui.SetColumnWidth(-1, 100) -- ������ �������
                    imgui.Columns(1)
                    imgui.Separator()
                end
            end
            imgui.EndChild()
        end
        imgui.SetCursorPos(imgui.ImVec2(15, 425))
        if imgui.Button(faicons('PLUS'), imgui.ImVec2(120, 28)) then
            new_binder.text = ''
            new_binder.command = ''
            new_binder.delay = 1000
            new_binder.title = ''
            new_binder.power = false  -- ��������� �������� power
            window_new_binder[0] = true
            texter = new.char[10000](new_binder.text)
            commander = new.char[256](new_binder.command)
            delay = new.int(new_binder.delay)
            title = new.char[256](new_binder.title)
            power = false
            WinState[0] = false
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
            imgui.Text(u8'�������� ����')
            imgui.EndTooltip()
        end

        imgui.SameLine()
        imgui.SetCursorPos(imgui.ImVec2(144, 425))
        if imgui.Button(fa.PEN_TO_SQUARE, imgui.ImVec2(120, 28)) then
            if selectedBinderIndex then  -- ���������, ������� �� ������
                -- ������������� �������������� ���������� �������
                local selectedBinder = binders[selectedBinderIndex]
                
                -- ����������� ����������� ffi.string(), ����� �������� nil �������� � ������������� ���������� ����������
                texter = new.char[10000](u8(selectedBinder.text))
                commander = new.char[256](u8(selectedBinder.command))
                delay = new.int(selectedBinder.delay)  -- ����������� �������� �� ��������� ��� delay
                title = new.char[256](u8(selectedBinder.title))
                power = false
                  -- ��������� ������ �������������� �������
                window_edit_binder[0] = true  -- ��������� ���� ��������������
                WinState[0] = false  -- ��������� ��������� ����
            else
                sampAddChatMessage(tag .. "�������� ���� ��� ��������������", -1)  -- �����������, ���� �� �������
            end
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
            imgui.Text(u8'������������� ����')
            imgui.EndTooltip()
        end

        imgui.SameLine()
        imgui.SetCursorPos(imgui.ImVec2(273, 425))
        if imgui.Button(fa.CLONE, imgui.ImVec2(120, 28)) then
            if selectedBinderIndex then
                copyBinder(selectedBinderIndex)  -- �������� ������
            else
                sampAddChatMessage(tag .. "�������� ���� ��� �����������", -1)  -- �����������, ���� �� �������
            end
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
            imgui.Text(u8'���������� ����')
            imgui.EndTooltip()
        end

        imgui.SameLine()
        imgui.SetCursorPos(imgui.ImVec2(402, 425))
        if imgui.Button(fa.TRASH, imgui.ImVec2(120, 28)) then
            if selectedBinderIndex then
                local binderToDelete = binders[selectedBinderIndex]
                table.remove(binders, selectedBinderIndex)  -- ������� ���������� ������� �� �������
                saveBinders()  -- ��������� ����������� ������ ��������
                sampAddChatMessage(tag .. "���� " .. ffi.string(binderToDelete.title) .. " ������� �����!", -1)  -- ����������� �� ��������
                selectedBinderIndex = nil  -- ����� ���������� ������� ����� ��������
            else
                sampAddChatMessage(tag .. "�������� ���� ��� ��������", -1)  -- �����������, ���� �� �������
            end
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
            imgui.Text(u8'������� ����')
            imgui.EndTooltip()
        end

        imgui.SameLine()
        imgui.SetCursorPos(imgui.ImVec2(531, 425))
        if imgui.Button(fa.CIRCLE_UP, imgui.ImVec2(120, 28)) then
            if selectedBinderIndex and selectedBinderIndex > 1 then
                selectedBinderIndex = selectedBinderIndex - 1  -- ������� � ����������� �������
            end
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
            imgui.Text(u8'�����')
            imgui.EndTooltip()
        end

        imgui.SameLine()
        imgui.SetCursorPos(imgui.ImVec2(660, 425))
        if imgui.Button(fa.CIRCLE_DOWN, imgui.ImVec2(120, 28)) then
            if selectedBinderIndex and selectedBinderIndex < #binders then
                selectedBinderIndex = selectedBinderIndex + 1  -- ������� � ���������� �������
            end
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
            imgui.Text(u8'����')
            imgui.EndTooltip()
        end
        
        imgui.EndChild()



    elseif tab == 1 then
        imgui.SetCursorPos(imgui.ImVec2(190, 43))
        if imgui.BeginChild('Settings', imgui.ImVec2(795, 470), true) then
            imgui.Button(u8'��������', imgui.ImVec2(765, 30))
            if imgui.BeginChild('Main List', imgui.ImVec2(765, 130), true) then
                imgui.PushItemWidth(200)
                imgui.InputTextWithHint(u8'�������', u8'�������', name, 256)
                imgui.PopItemWidth()
                imgui.SameLine()
                imgui.PushItemWidth(200)
                imgui.PushItemWidth(200)
                imgui.SetCursorPosX(300)
                if imgui.Combo(u8'##�������� ����', decorListNumber, decorListBuffer, #decorList) then
                    save_themes()
                    theme[decorListNumber[0]+1].change()
                end
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    imgui.Text(u8'�������� ����')
                    imgui.EndTooltip()
                end
                imgui.PopItemWidth()
                imgui.PopItemWidth()
                imgui.PushItemWidth(200)
                imgui.InputTextWithHint(u8'���', u8'��� �����������', org, 256)
                imgui.PopItemWidth()
                imgui.SameLine()
                imgui.PushItemWidth(200)
                imgui.SetCursorPosX(300)
                if imgui.SliderFloat(u8'##������������', alpha, 0, 1) then
                    ini.Themes.alpha = alpha[0]
                    inicfg.save(ini, 'FTools/Fox.ini')
                    theme[decorListNumber[0]+1].change()
                end
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    imgui.Text(u8'������������ ����')
                    imgui.EndTooltip()
                end
                imgui.PopItemWidth()
                imgui.PushItemWidth(200)
                imgui.InputTextWithHint(u8'���������', u8'���������', rank, 256)
                imgui.PopItemWidth()
            end
            imgui.EndChild()
            if imgui.BeginChild('Main Box', imgui.ImVec2(765, 262), true) then
                if imgui.Checkbox(u8'���� ����������', checkinfo) then
                    if checkinfo[0] == true then
                        window_two[0] = true
                        ini.mainIni.checkinfo = checkinfo[0]
                        inicfg.save(ini, 'FTools/Fox.ini')
                    else
                        window_two[0] = false
                        ini.mainIni.checkinfo = checkinfo[0]
                        inicfg.save(ini, 'FTools/Fox.ini')
                    end
                end
                if ini.mainIni.checkinfo == true then
                    imgui.SameLine()
                    if imgui.Button(fa.GEAR) then
                        --flags = (bit.band(flags, imgui.WindowFlags.NoMove) == 1) and (flags - imgui.WindowFlags.NoMove) or (flags + imgui.WindowFlags.NoMove)
                        info_set[0] = not info_set[0]
                    end
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        imgui.Text(u8'�������������')
                        imgui.EndTooltip()
                    end
                end
                if imgui.Checkbox(u8'������', actient) then
                    set.Settings.actient = actient[0]
                    inicfg.save(set, 'FTools/Settings_Fox.ini')
                end
                if actient[0] == true then
                    imgui.PushItemWidth(150)
                    imgui.SameLine()
                    if imgui.InputTextWithHint('##actint', u8'������', act, 500) then
                        set.Settings.act = u8:decode(ffi.string(act))
                        inicfg.save(set, 'FTools/Settings_Fox.ini')
                    end
                    imgui.PopItemWidth()
                end
                if imgui.Checkbox(u8'������ "�� �����"', not_flood) then
                    set.Settings.not_flood = not_flood[0]
                    inicfg.save(set, 'FTools/Settings_Fox.ini')
                end
                if not_flood[0] == true then
                    function sampev.onServerMessage(color, text)
                        if text:find('�� �����') then
                            return false
                        end
                    end
                end

            end
            imgui.EndChild()
        end
    end
end)




-- �������� �������� ��� ������
loadBinders()

-- ������ ���

theme = {
    {
        change = function()
            imgui.SwitchContext()
            local style = imgui.GetStyle()
        
            style.WindowPadding = imgui.ImVec2(15, 15)
            style.WindowRounding = 10.0
            style.ChildRounding = 6.0
            style.FramePadding = imgui.ImVec2(8, 7)
            style.FrameRounding = 8.0
            style.ItemSpacing = imgui.ImVec2(8, 8)
            style.ItemInnerSpacing = imgui.ImVec2(10, 6)
            style.IndentSpacing = 25.0
            style.ScrollbarSize = 13.0
            style.ScrollbarRounding = 12.0
            style.GrabMinSize = 10.0
            style.GrabRounding = 6.0
            style.PopupRounding = 8
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
            style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

            style.Colors[imgui.Col.Text]                   = imgui.ImVec4(0.90, 0.90, 0.80, 1.00)
            style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.60, 0.50, 0.50, 1.00)
            style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.10, 0.10, 0.10, alpha[0])
            style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.12, 0.12, 0.12, alpha[0])
            style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
            style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
            style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.25, 1.00)
            style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.15, 0.15, 0.15, 1.00)
            style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.10, 0.10, 0.10, 1.00)
            style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
            style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.15, 0.15, 0.15, 1.00)
            style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.10, 0.10, 0.10, 1.00)
            style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.40, 0.40, 0.40, 1.00)
            style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
            style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.66, 0.66, 0.66, 1.00)
            style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.66, 0.66, 0.66, 1.00)
            style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
            style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.40, 0.40, 0.40, 1.00)
            style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
            style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
            style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.25, 0.25, 0.25, 1.00)
            style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.40, 0.40, 0.40, 1.00)
            style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
            style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.40, 0.40, 0.40, 1.00)
            style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
            style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
            style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.95, 0.95, 0.70, 1.00)
            style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
            style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.95, 0.95, 0.70, 1.00)
            style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.25, 0.25, 0.15, 1.00)
            style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.10, 0.10, 0.10, 0.80)
            style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
            style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.25, 0.25, 0.25, 1.00)
        end
    },
    {
        change = function()
            imgui.SwitchContext()
            local style = imgui.GetStyle()
        
            style.WindowPadding = imgui.ImVec2(15, 15)
            style.WindowRounding = 10.0
            style.ChildRounding = 6.0
            style.FramePadding = imgui.ImVec2(8, 7)
            style.FrameRounding = 8.0
            style.ItemSpacing = imgui.ImVec2(8, 8)
            style.ItemInnerSpacing = imgui.ImVec2(10, 6)
            style.IndentSpacing = 25.0
            style.ScrollbarSize = 13.0
            style.ScrollbarRounding = 12.0
            style.GrabMinSize = 10.0
            style.GrabRounding = 6.0
            style.PopupRounding = 8
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
            style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
        
            style.Colors[imgui.Col.Text]                   = imgui.ImVec4(0.10, 0.10, 0.10, 1.00)
            style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.60, 0.60, 0.60, 1.00)
            style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.95, 0.95, 0.95, alpha[0])
            style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.90, 0.90, 0.90, alpha[0])
            style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.95, 0.95, 0.95, 1.00)
            style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.80, 0.80, 0.80, 1.00)
            style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
            style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.85, 0.85, 0.85, 1.00)
            style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.75, 0.75, 0.75, 1.00)
            style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.65, 0.65, 0.65, 1.00)
            style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.80, 0.80, 0.80, 1.00)
            style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.70, 0.70, 0.70, 1.00)
            style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.75, 0.75, 0.75, 1.00)
            style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.85, 0.85, 0.85, 1.00)
            style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.90, 0.90, 0.90, 1.00)
            style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.75, 0.75, 0.75, 1.00)
            style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.65, 0.65, 0.65, 1.00)
            style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.55, 0.55, 0.55, 1.00)
            style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.35, 0.35, 0.35, 1.00)
            style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.45, 0.45, 0.45, 1.00)
            style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.55, 0.55, 0.55, 1.00)
            style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.80, 0.80, 0.80, 1.00)
            style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.70, 0.70, 0.70, 1.00)
            style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.60, 0.60, 0.60, 1.00)
            style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.85, 0.85, 0.85, 1.00)
            style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.75, 0.75, 0.75, 1.00)
            style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.65, 0.65, 0.65, 1.00)
            style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.80, 0.80, 0.80, 1.00)
            style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.70, 0.70, 0.70, 1.00)
            style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.60, 0.60, 0.60, 1.00)
            style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.85, 0.85, 0.85, 1.00)
            style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.75, 0.75, 0.75, 1.00)
            style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.65, 0.65, 0.65, 1.00)
            style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.40, 0.40, 0.40, 1.00)
            style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.40, 0.40, 0.40, 1.00)
            style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.75, 0.75, 0.75, 1.00)
            style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.85, 0.85, 0.85, 0.80)
            style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.85, 0.85, 0.85, 1.00)
            style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.75, 0.75, 0.75, 1.00)
            style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.65, 0.65, 0.65, 1.00)
        end
    },
    {
        change = function()
            imgui.SwitchContext()
            local style = imgui.GetStyle()
          
            style.WindowPadding = imgui.ImVec2(15, 15)
            style.WindowRounding = 10.0
            style.ChildRounding = 6.0
            style.FramePadding = imgui.ImVec2(8, 7)
            style.FrameRounding = 8.0
            style.ItemSpacing = imgui.ImVec2(8, 8)
            style.ItemInnerSpacing = imgui.ImVec2(10, 6)
            style.IndentSpacing = 25.0
            style.ScrollbarSize = 13.0
            style.ScrollbarRounding = 12.0
            style.GrabMinSize = 10.0
            style.GrabRounding = 6.0
            style.PopupRounding = 8
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
            style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
        
            style.Colors[imgui.Col.Text]                   = imgui.ImVec4(0.90, 0.90, 0.93, 1.00)
            style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.40, 0.40, 0.45, 1.00)
            style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.12, 0.12, 0.14, alpha[0])
            style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.18, 0.20, 0.22, alpha[0])
            style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.13, 0.13, 0.15, 1.00)
            style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.30, 0.30, 0.35, 1.00)
            style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
            style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.18, 0.18, 0.20, 1.00)
            style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
            style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
            style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.15, 0.15, 0.17, 1.00)
            style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.10, 0.10, 0.12, 1.00)
            style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.15, 0.15, 0.17, 1.00)
            style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.14, 1.00)
            style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.14, 1.00)
            style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.30, 0.30, 0.35, 1.00)
            style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.40, 0.40, 0.45, 1.00)
            style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.50, 0.50, 0.55, 1.00)
            style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.70, 0.70, 0.90, 1.00)
            style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.70, 0.70, 0.90, 1.00)
            style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.80, 0.80, 0.90, 1.00)
            style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.18, 0.18, 0.20, 1.00)
            style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.60, 0.60, 0.90, 1.00)
            style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.28, 0.56, 0.96, 1.00)
            style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.20, 0.20, 0.23, 1.00)
            style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
            style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
            style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.40, 0.40, 0.45, 1.00)
            style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.50, 0.50, 0.55, 1.00)
            style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.60, 0.60, 0.65, 1.00)
            style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.20, 0.20, 0.23, 1.00)
            style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
            style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
            style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.64, 1.00)
            style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.70, 0.70, 0.75, 1.00)
            style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.61, 0.61, 0.64, 1.00)
            style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.70, 0.70, 0.75, 1.00)
            style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
            style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.10, 0.10, 0.12, 0.80)
            style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.18, 0.20, 0.22, 1.00)
            style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.60, 0.60, 0.90, 1.00)
            style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.28, 0.56, 0.96, 1.00)
        end
    },
    {
        change = function()
            imgui.SwitchContext()
            local style = imgui.GetStyle()

            style.WindowPadding = imgui.ImVec2(15, 15)
            style.WindowRounding = 10.0
            style.ChildRounding = 6.0
            style.FramePadding = imgui.ImVec2(8, 7)
            style.FrameRounding = 8.0
            style.ItemSpacing = imgui.ImVec2(8, 8)
            style.ItemInnerSpacing = imgui.ImVec2(10, 6)
            style.IndentSpacing = 25.0
            style.ScrollbarSize = 13.0
            style.ScrollbarRounding = 12.0
            style.GrabMinSize = 10.0
            style.GrabRounding = 6.0
            style.PopupRounding = 8
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
            style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

            style.Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 0.90, 0.85, 1.00)
            style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.75, 0.60, 0.55, alpha[0])
            style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.25, 0.15, 0.10, alpha[0])
            style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.30, 0.20, 0.15, 0.30)
            style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.30, 0.20, 0.15, 1.00)
            style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.80, 0.35, 0.20, 1.00)
            style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
            style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.30, 0.20, 0.15, 1.00)
            style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.45, 0.25, 0.20, 1.00)
            style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.55, 0.35, 0.25, 1.00)
            style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.25, 0.15, 0.10, 1.00)
            style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.20, 0.10, 0.05, 1.00)
            style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.30, 0.20, 0.15, 1.00)
            style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.25, 0.15, 0.10, 1.00)
            style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.25, 0.15, 0.10, 1.00)
            style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.80, 0.35, 0.20, 1.00)
            style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
            style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(1.00, 0.65, 0.50, 1.00)
            style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 0.65, 0.50, 1.00)
            style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(1.00, 0.65, 0.50, 1.00)
            style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(1.00, 0.70, 0.55, 1.00)
            style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.30, 0.20, 0.15, 1.00)
            style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
            style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(1.00, 0.55, 0.40, 1.00)
            style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.45, 0.25, 0.20, 1.00)
            style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.55, 0.30, 0.25, 1.00)
            style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.65, 0.40, 0.30, 1.00)
            style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.80, 0.35, 0.20, 1.00)
            style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
            style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(1.00, 0.65, 0.50, 1.00)
            style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.45, 0.25, 0.20, 1.00)
            style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.55, 0.30, 0.25, 1.00)
            style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.65, 0.40, 0.30, 1.00)
            style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
            style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.55, 0.40, 1.00)
            style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
            style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.55, 0.40, 1.00)
            style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.55, 0.30, 0.25, 1.00)
            style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.25, 0.15, 0.10, 0.80)
            style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.30, 0.20, 0.15, 1.00)
            style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
            style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(1.00, 0.55, 0.40, 1.00)
        end
    },
    {
        change = function()
            imgui.SwitchContext()
            local style = imgui.GetStyle()
        
            style.WindowPadding = imgui.ImVec2(15, 15)
            style.WindowRounding = 10.0
            style.ChildRounding = 6.0
            style.FramePadding = imgui.ImVec2(8, 7)
            style.FrameRounding = 8.0
            style.ItemSpacing = imgui.ImVec2(8, 8)
            style.ItemInnerSpacing = imgui.ImVec2(10, 6)
            style.IndentSpacing = 25.0
            style.ScrollbarSize = 13.0
            style.ScrollbarRounding = 12.0
            style.GrabMinSize = 10.0
            style.GrabRounding = 6.0
            style.PopupRounding = 8
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
            style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
        
            style.Colors[imgui.Col.Text]                   = imgui.ImVec4(0.80, 0.80, 0.83, 1.00)
            style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.55, 1.00)
            style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.16, 0.16, 0.17, alpha[0])
            style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.20, 0.20, 0.22, alpha[0])
            style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.18, 0.18, 0.19, 1.00)
            style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.31, 0.31, 0.35, 1.00)
            style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
            style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
            style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.35, 0.35, 0.37, 1.00)
            style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.45, 0.45, 0.47, 1.00)
            style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
            style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
            style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
            style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
            style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
            style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.30, 0.30, 0.33, 1.00)
            style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
            style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
            style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
            style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.60, 0.60, 0.63, 1.00)
            style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
            style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
            style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
            style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.45, 0.45, 0.47, 1.00)
            style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
            style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
            style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.45, 0.45, 0.48, 1.00)
            style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.30, 0.30, 0.33, 1.00)
            style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
            style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
            style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
            style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.30, 0.30, 0.33, 1.00)
            style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
            style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.65, 0.65, 0.68, 1.00)
            style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.75, 0.75, 0.78, 1.00)
            style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.65, 0.65, 0.68, 1.00)
            style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.75, 0.75, 0.78, 1.00)
            style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
            style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.20, 0.20, 0.22, 0.80)
            style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
            style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
            style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
        end  
    },
    {
        change = function()
            imgui.SwitchContext()
            local style = imgui.GetStyle()
        
            style.WindowPadding = imgui.ImVec2(15, 15)
            style.WindowRounding = 10.0
            style.ChildRounding = 6.0
            style.FramePadding = imgui.ImVec2(8, 7)
            style.FrameRounding = 8.0
            style.ItemSpacing = imgui.ImVec2(8, 8)
            style.ItemInnerSpacing = imgui.ImVec2(10, 6)
            style.IndentSpacing = 25.0
            style.ScrollbarSize = 13.0
            style.ScrollbarRounding = 12.0
            style.GrabMinSize = 10.0
            style.GrabRounding = 6.0
            style.PopupRounding = 8
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
            style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

            style.Colors[imgui.Col.Text]                   = imgui.ImVec4(0.85, 0.93, 0.85, 1.00)
            style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.55, 0.65, 0.55, 1.00)
            style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.13, 0.22, 0.13, alpha[0])
            style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.17, 0.27, 0.17, alpha[0])
            style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.15, 0.24, 0.15, 1.00)
            style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
            style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
            style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
            style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
            style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
            style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
            style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
            style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.18, 0.28, 0.18, 1.00)
            style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
            style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
            style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
            style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.30, 0.40, 0.30, 1.00)
            style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.35, 0.45, 0.35, 1.00)
            style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.50, 0.70, 0.50, 1.00)
            style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.50, 0.70, 0.50, 1.00)
            style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.55, 0.75, 0.55, 1.00)
            style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
            style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
            style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
            style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
            style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.28, 0.38, 0.28, 1.00)
            style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.30, 0.40, 0.30, 1.00)
            style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
            style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.30, 0.40, 0.30, 1.00)
            style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.35, 0.45, 0.35, 1.00)
            style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
            style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
            style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
            style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.60, 0.70, 0.60, 1.00)
            style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.65, 0.75, 0.65, 1.00)
            style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.60, 0.70, 0.60, 1.00)
            style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.65, 0.75, 0.65, 1.00)
            style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
            style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.15, 0.25, 0.15, 0.80)
            style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
            style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
            style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
        end  
    },
    {
        change = function()
            imgui.SwitchContext()
            local style = imgui.GetStyle();
            local colors = style.Colors;
            style.WindowPadding = imgui.ImVec2(15, 15)
            style.WindowRounding = 10.0
            style.ChildRounding = 6.0
            style.FramePadding = imgui.ImVec2(8, 7)
            style.FrameRounding = 8.0
            style.ItemSpacing = imgui.ImVec2(8, 8)
            style.ItemInnerSpacing = imgui.ImVec2(10, 6)
            style.IndentSpacing = 25.0
            style.ScrollbarSize = 13.0
            style.ScrollbarRounding = 12.0
            style.GrabMinSize = 10.0
            style.GrabRounding = 6.0
            style.PopupRounding = 8
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
            style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
            colors[imgui.Col.Text] = imgui.ImVec4(1.00, 1.00, 1.00, 1.00);
            colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.44, 0.41, 0.41, 1.00);
            colors[imgui.Col.WindowBg] = imgui.ImVec4(0.29, 0.26, 0.34, 0.70);
            colors[imgui.Col.ChildBg] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00);
            colors[imgui.Col.PopupBg] = imgui.ImVec4(0.11, 0.11, 0.14, 0.92);
            colors[imgui.Col.Border] = imgui.ImVec4(0.50, 0.50, 0.50, 0.50);
            colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00);
            colors[imgui.Col.FrameBg] = imgui.ImVec4(0.43, 0.43, 0.43, 0.39);
            colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.47, 0.47, 0.69, 0.40);
            colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.42, 0.41, 0.64, 0.69);
            colors[imgui.Col.TitleBg] = imgui.ImVec4(0.34, 0.34, 0.41, 0.83);
            colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.32, 0.32, 0.63, 0.87);
            colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0.40, 0.40, 0.80, 0.20);
            colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.40, 0.40, 0.55, 0.80);
            colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.20, 0.25, 0.30, 0.60);
            colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.40, 0.40, 0.80, 0.30);
            colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.40, 0.40, 0.80, 0.40);
            colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.41, 0.39, 0.80, 0.60);
            colors[imgui.Col.CheckMark] = imgui.ImVec4(0.90, 0.90, 0.90, 0.50);
            colors[imgui.Col.SliderGrab] = imgui.ImVec4(1.00, 1.00, 1.00, 0.30);
            colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.41, 0.39, 0.80, 0.60);
            colors[imgui.Col.Button] = imgui.ImVec4(0.31, 0.32, 0.38, 0.62);
            colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.40, 0.48, 0.71, 0.79);
            colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.46, 0.54, 0.80, 1.00);
            colors[imgui.Col.Header] = imgui.ImVec4(0.40, 0.40, 0.90, 0.45);
            colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.45, 0.45, 0.90, 0.80);
            colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.53, 0.53, 0.87, 0.80);
            colors[imgui.Col.Separator] = imgui.ImVec4(0.50, 0.50, 0.50, 0.60);
            colors[imgui.Col.SeparatorHovered] = imgui.ImVec4(0.60, 0.60, 0.70, 1.00);
            colors[imgui.Col.SeparatorActive] = imgui.ImVec4(0.70, 0.70, 0.90, 1.00);
            colors[imgui.Col.ResizeGrip] = imgui.ImVec4(1.00, 1.00, 1.00, 0.16);
            colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.78, 0.82, 1.00, 0.60);
            colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.78, 0.82, 1.00, 0.90);
            colors[imgui.Col.Tab] = imgui.ImVec4(0.34, 0.34, 0.68, 0.79);
            colors[imgui.Col.TabHovered] = imgui.ImVec4(0.45, 0.45, 0.90, 0.80);
            colors[imgui.Col.TabActive] = imgui.ImVec4(0.40, 0.40, 0.73, 0.84);
            colors[imgui.Col.TabUnfocused] = imgui.ImVec4(0.28, 0.28, 0.57, 0.82);
            colors[imgui.Col.TabUnfocusedActive] = imgui.ImVec4(0.35, 0.35, 0.65, 0.84);
            colors[imgui.Col.PlotLines] = imgui.ImVec4(1.00, 1.00, 1.00, 1.00);
            colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(0.90, 0.70, 0.00, 1.00);
            colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.90, 0.70, 0.00, 1.00);
            colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(1.00, 0.60, 0.00, 1.00);
            colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.00, 0.00, 1.00, 0.35);
            colors[imgui.Col.DragDropTarget] = imgui.ImVec4(1.00, 1.00, 0.00, 0.90);
            colors[imgui.Col.NavHighlight] = imgui.ImVec4(0.45, 0.45, 0.90, 0.80);
            colors[imgui.Col.NavWindowingHighlight] = imgui.ImVec4(1.00, 1.00, 1.00, 0.70);
            colors[imgui.Col.NavWindowingDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.20);
            colors[imgui.Col.ModalWindowDimBg] = imgui.ImVec4(0.20, 0.20, 0.20, 0.35);
        end
    },
    {
        change = function()
            imgui.SwitchContext()
            local style = imgui.GetStyle()
        
            style.WindowPadding = imgui.ImVec2(15, 15)
            style.WindowRounding = 10.0
            style.ChildRounding = 6.0
            style.FramePadding = imgui.ImVec2(8, 7)
            style.FrameRounding = roading[0]
            style.FrameBorderSize = new_bord[0]
            style.ItemSpacing = imgui.ImVec2(8, 8)
            style.ItemInnerSpacing = imgui.ImVec2(10, 6)
            style.IndentSpacing = 25.0
            style.ScrollbarSize = 13.0
            style.ScrollbarRounding = 12.0
            style.GrabMinSize = 10.0
            style.GrabRounding = roading[0]
            style.PopupRounding = 8
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
            style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

            style.Colors[imgui.Col.Text]                   = imgui.ImVec4(text_color[0], text_color[1], text_color[2], 1.00)
            style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.60, 0.50, 0.50, 1.00)
            style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(colors_bg[0], colors_bg[1], colors_bg[2], alpha[0])
            style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(childs_bg[0], childs_bg[1], childs_bg[2], alpha[0])
            style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
            style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(frame_color[0], frame_color[1], frame_color[2], 1.00)
            style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(frame_color2[0], frame_color2[1], frame_color2[2], 1.00)
            style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.25, 1.00)
            style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.15, 0.15, 0.15, 1.00)
            style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.10, 0.10, 0.10, 1.00)
            style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(title_bg[0], title_bg[1], title_bg[2], 1.00)
            style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.15, 0.15, 0.15, 1.00)
            style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0,0,0, 0)
            style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(slide_color[0], slide_color[1], slide_color[2], 1.00)
            style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.40, 0.40, 0.40, 1.00)
            style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
            style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.66, 0.66, 0.66, 1.00)
            style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.66, 0.66, 0.66, 1.00)
            style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
            style.Colors[imgui.Col.Button]                 = imgui.ImVec4(but_color[0], but_color[1], but_color[2], 1.00)
            style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(but_color2[0], but_color2[1], but_color2[2], 1.00)
            style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(but_color2[0] + 0.10, but_color2[1] + 0.10, but_color2[2] + 0.10, 1.00)
            style.Colors[imgui.Col.Header]                 = imgui.ImVec4(table_bg[0], table_bg[1], table_bg[2], 1.00)
            style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(table_bg[0]+0.10, table_bg[1]+0.10, table_bg[2]+0.10, 1.00)
            style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(table_bg[0]+0.05, table_bg[1]+0.05, table_bg[2]+0.05, 1.00)
            style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.40, 0.40, 0.40, 1.00)
            style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
            style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.40, 0.40, 0.40, 1.00)
            style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
            style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
            style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.95, 0.95, 0.70, 1.00)
            style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
            style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.95, 0.95, 0.70, 1.00)
            style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.25, 0.25, 0.15, 1.00)
            style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.10, 0.10, 0.10, 0.80)
            style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(but_color2[0], but_color2[1], but_color2[2], 1.00)
            style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(but_color2[0], but_color2[1], but_color2[2], 1.00)
            style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(but_color2[0], but_color2[1], but_color2[2], 1.00)
        end
    },
}


-- �������� �������

function calculateZone(x, y, z)
    local streets = {{"Avispa Country Club", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169},
    {"Easter Bay Airport", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406},
    {"Avispa Country Club", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700},
    {"Easter Bay Airport", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406},
    {"Garcia", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000},
    {"Shady Cabin", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000},
    {"East Los Santos", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916},
    {"LVA Freight Depot", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916},
    {"Blackfield Intersection", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916},
    {"Avispa Country Club", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100},
    {"Temple", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916},
    {"Unity Station", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508},
    {"LVA Freight Depot", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916},
    {"Los Flores", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916},
    {"Starfish Casino", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916},
    {"Easter Bay Chemicals", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000},
    {"Downtown Los Santos", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916},
    {"Esplanade East", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000},
    {"Market Station", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874},
    {"Linden Station", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406},
    {"Montgomery Intersection", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000},
    {"Frederick Bridge", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000},
    {"Yellow Bell Station", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074},
    {"Downtown Los Santos", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916},
    {"Jefferson", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916},
    {"Mulholland", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916},
    {"Avispa Country Club", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000},
    {"Jefferson", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916},
    {"Julius Thruway West", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916},
    {"Jefferson", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916},
    {"Julius Thruway North", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916},
    {"Rodeo", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916},
    {"Cranberry Station", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000},
    {"Downtown Los Santos", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916},
    {"Redsands West", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916},
    {"Little Mexico", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916},
    {"Blackfield Intersection", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916},
    {"Los Santos International", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916},
    {"Beacon Hill", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511},
    {"Rodeo", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916},
    {"Richman", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916},
    {"Downtown Los Santos", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916},
    {"The Strip", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916},
    {"Downtown Los Santos", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916},
    {"Blackfield Intersection", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916},
    {"Conference Center", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916},
    {"Montgomery", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000},
    {"Foster Valley", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000},
    {"Blackfield Chapel", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916},
    {"Los Santos International", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916},
    {"Mulholland", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916},
    {"Yellow Bell Gol Course", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916},
    {"The Strip", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916},
    {"Jefferson", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916},
    {"Mulholland", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916},
    {"Aldea Malvada", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000},
    {"Las Colinas", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916},
    {"Las Colinas", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916},
    {"Richman", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
    {"LVA Freight Depot", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916},
    {"Julius Thruway North", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916},
    {"Willowfield", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916},
    {"Julius Thruway North", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916},
    {"Temple", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916},
    {"Little Mexico", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916},
    {"Queens", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000},
    {"Las Venturas Airport", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500},
    {"Richman", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916},
    {"Temple", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916},
    {"East Los Santos", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916},
    {"Julius Thruway East", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916},
    {"Willowfield", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916},
    {"Las Colinas", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916},
    {"Julius Thruway East", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916},
    {"Rodeo", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916},
    {"Las Brujas", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000},
    {"Julius Thruway East", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916},
    {"Rodeo", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916},
    {"Vinewood", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916},
    {"Rodeo", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916},
    {"Julius Thruway North", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916},
    {"Downtown Los Santos", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916},
    {"Rodeo", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916},
    {"Jefferson", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916},
    {"Hampton Barns", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000},
    {"Temple", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916},
    {"Kincaid Bridge", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916},
    {"Verona Beach", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916},
    {"Commerce", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916},
    {"Mulholland", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916},
    {"Rodeo", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916},
    {"Mulholland", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916},
    {"Mulholland", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
    {"Julius Thruway South", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916},
    {"Idlewood", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916},
    {"Ocean Docks", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916},
    {"Commerce", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916},
    {"Julius Thruway North", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916},
    {"Temple", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916},
    {"Glen Park", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916},
    {"Easter Bay Airport", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000},
    {"Martin Bridge", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000},
    {"The Strip", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916},
    {"Willowfield", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916},
    {"Marina", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916},
    {"Las Venturas Airport", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916},
    {"Idlewood", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916},
    {"Esplanade East", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000},
    {"Downtown Los Santos", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916},
    {"The Mako Span", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000},
    {"Rodeo", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916},
    {"Pershing Square", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916},
    {"Mulholland", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
    {"Gant Bridge", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000},
    {"Las Colinas", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916},
    {"Mulholland", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916},
    {"Julius Thruway North", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916},
    {"Commerce", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916},
    {"Rodeo", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916},
    {"Roca Escalante", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916},
    {"Rodeo", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916},
    {"Market", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916},
    {"Las Colinas", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916},
    {"Mulholland", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916},
    {"King's", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000},
    {"Redsands East", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916},
    {"Downtown", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000},
    {"Conference Center", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916},
    {"Richman", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916},
    {"Ocean Flats", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000},
    {"Greenglass College", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916},
    {"Glen Park", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916},
    {"LVA Freight Depot", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916},
    {"Regular Tom", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000},
    {"Verona Beach", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916},
    {"East Los Santos", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916},
    {"Caligula's Palace", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916},
    {"Idlewood", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916},
    {"Pilgrim", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916},
    {"Idlewood", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916},
    {"Queens", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000},
    {"Downtown", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000},
    {"Commerce", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916},
    {"East Los Santos", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916},
    {"Marina", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916},
    {"Richman", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916},
    {"Vinewood", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916},
    {"East Los Santos", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916},
    {"Rodeo", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916},
    {"Easter Tunnel", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000},
    {"Rodeo", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916},
    {"Redsands East", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916},
    {"The Clown's Pocket", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916},
    {"Idlewood", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916},
    {"Montgomery Intersection", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000},
    {"Willowfield", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916},
    {"Temple", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916},
    {"Prickle Pine", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916},
    {"Los Santos International", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916},
    {"Garver Bridge", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916},
    {"Garver Bridge", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916},
    {"Kincaid Bridge", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916},
    {"Kincaid Bridge", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916},
    {"Verona Beach", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916},
    {"Verdant Bluffs", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916},
    {"Vinewood", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916},
    {"Vinewood", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916},
    {"Commerce", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916},
    {"Market", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916},
    {"Rockshore West", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916},
    {"Julius Thruway North", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916},
    {"East Beach", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916},
    {"Fallow Bridge", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000},
    {"Willowfield", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916},
    {"Chinatown", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000},
    {"El Castillo del Diablo", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000},
    {"Ocean Docks", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916},
    {"Easter Bay Chemicals", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000},
    {"The Visage", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916},
    {"Ocean Flats", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000},
    {"Richman", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
    {"Green Palms", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000},
    {"Richman", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
    {"Starfish Casino", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916},
    {"East Beach", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916},
    {"Jefferson", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916},
    {"Downtown Los Santos", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916},
    {"Downtown Los Santos", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916},
    {"Garver Bridge", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385},
    {"Julius Thruway South", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916},
    {"East Los Santos", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916},
    {"Greenglass College", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916},
    {"Las Colinas", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916},
    {"Mulholland", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916},
    {"Ocean Docks", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916},
    {"East Los Santos", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916},
    {"Ganton", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916},
    {"Avispa Country Club", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000},
    {"Willowfield", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916},
    {"Esplanade North", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000},
    {"The High Roller", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916},
    {"Ocean Docks", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916},
    {"Last Dime Motel", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916},
    {"Bayside Marina", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000},
    {"King's", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000},
    {"El Corona", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916},
    {"Blackfield Chapel", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916},
    {"The Pink Swan", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916},
    {"Julius Thruway West", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916},
    {"Los Flores", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916},
    {"The Visage", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916},
    {"Prickle Pine", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916},
    {"Verona Beach", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916},
    {"Robada Intersection", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916},
    {"Linden Side", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916},
    {"Ocean Docks", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916},
    {"Willowfield", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916},
    {"King's", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000},
    {"Commerce", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916},
    {"Mulholland", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916},
    {"Marina", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916},
    {"Battery Point", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000},
    {"The Four Dragons Casino", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916},
    {"Blackfield", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916},
    {"Julius Thruway North", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916},
    {"Yellow Bell Gol Course", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916},
    {"Idlewood", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916},
    {"Redsands West", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916},
    {"Doherty", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000},
    {"Hilltop Farm", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000},
    {"Las Barrancas", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000},
    {"Pirates in Men's Pants", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916},
    {"City Hall", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000},
    {"Avispa Country Club", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000},
    {"The Strip", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916},
    {"Hashbury", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000},
    {"Los Santos International", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916},
    {"Whitewood Estates", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916},
    {"Sherman Reservoir", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916},
    {"El Corona", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916},
    {"Downtown", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000},
    {"Foster Valley", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000},
    {"Las Payasadas", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000},
    {"Valle Ocultado", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000},
    {"Blackfield Intersection", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916},
    {"Ganton", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916},
    {"Easter Bay Airport", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000},
    {"Redsands East", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916},
    {"Esplanade East", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385},
    {"Caligula's Palace", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916},
    {"Royal Casino", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916},
    {"Richman", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916},
    {"Starfish Casino", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916},
    {"Mulholland", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916},
    {"Downtown", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000},
    {"Hankypanky Point", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000},
    {"K.A.C.C. Military Fuels", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916},
    {"Harry Gold Parkway", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916},
    {"Bayside Tunnel", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916},
    {"Ocean Docks", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916},
    {"Richman", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916},
    {"Randolph Industrial Estate", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916},
    {"East Beach", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916},
    {"Flint Water", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
    {"Blueberry", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000},
    {"Linden Station", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916},
    {"Glen Park", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916},
    {"Downtown", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000},
    {"Redsands West", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916},
    {"Richman", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916},
    {"Gant Bridge", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000},
    {"Lil' Probe Inn", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000},
    {"Flint Intersection", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916},
    {"Las Colinas", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916},
    {"Sobell Rail Yards", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916},
    {"The Emerald Isle", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916},
    {"El Castillo del Diablo", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000},
    {"Santa Flora", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000},
    {"Playa del Seville", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916},
    {"Market", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916},
    {"Queens", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000},
    {"Pilson Intersection", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916},
    {"Spinybed", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916},
    {"Pilgrim", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916},
    {"Blackfield", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916},
    {"'The Big Ear'", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000},
    {"Dillimore", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000},
    {"El Quebrados", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000},
    {"Esplanade North", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000},
    {"Easter Bay Airport", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000},
    {"Fisher's Lagoon", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000},
    {"Mulholland", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916},
    {"East Beach", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916},
    {"San Andreas Sound", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000},
    {"Shady Creeks", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000},
    {"Market", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916},
    {"Rockshore West", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916},
    {"Prickle Pine", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916},
    {"Easter Basin", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000},
    {"Leafy Hollow", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000},
    {"LVA Freight Depot", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916},
    {"Prickle Pine", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916},
    {"Blueberry", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000},
    {"El Castillo del Diablo", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000},
    {"Downtown", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000},
    {"Rockshore East", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916},
    {"San Fierro Bay", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000},
    {"Paradiso", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000},
    {"The Camel's Toe", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916},
    {"Old Venturas Strip", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916},
    {"Juniper Hill", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000},
    {"Juniper Hollow", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000},
    {"Roca Escalante", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916},
    {"Julius Thruway East", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916},
    {"Verona Beach", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916},
    {"Foster Valley", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000},
    {"Arco del Oeste", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000},
    {"Fallen Tree", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000},
    {"The Farm", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981},
    {"The Sherman Dam", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000},
    {"Esplanade North", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000},
    {"Financial", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000},
    {"Garcia", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000},
    {"Montgomery", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000},
    {"Creek", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916},
    {"Los Santos International", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916},
    {"Santa Maria Beach", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916},
    {"Mulholland Intersection", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916},
    {"Angel Pine", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000},
    {"Verdant Meadows", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000},
    {"Octane Springs", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000},
    {"Come-A-Lot", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916},
    {"Redsands West", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916},
    {"Santa Maria Beach", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916},
    {"Verdant Bluffs", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916},
    {"Las Venturas Airport", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916},
    {"Flint Range", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000},
    {"Verdant Bluffs", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916},
    {"Palomino Creek", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000},
    {"Ocean Docks", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916},
    {"Easter Bay Airport", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000},
    {"Whitewood Estates", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916},
    {"Calton Heights", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000},
    {"Easter Basin", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000},
    {"Los Santos Inlet", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916},
    {"Doherty", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000},
    {"Mount Chiliad", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083},
    {"Fort Carson", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000},
    {"Foster Valley", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000},
    {"Ocean Flats", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000},
    {"Fern Ridge", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000},
    {"Bayside", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000},
    {"Las Venturas Airport", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916},
    {"Blueberry Acres", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000},
    {"Palisades", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000},
    {"North Rock", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000},
    {"Hunter Quarry", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761},
    {"Los Santos International", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916},
    {"Missionary Hill", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000},
    {"San Fierro Bay", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000},
    {"Restricted Area", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000},
    {"Mount Chiliad", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083},
    {"Mount Chiliad", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083},
    {"Easter Bay Airport", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000},
    {"The Panopticon", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000},
    {"Shady Creeks", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000},
    {"Back o Beyond", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000},
    {"Mount Chiliad", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083}}
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return "Unknown"
end

-- �������� �������


function calccity(x, y, z)
    local city =  {{"Tierra Robada", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000},
    {"Flint County", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000},
    {"Whetstone", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000},
    {"Bone County", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000},
    {"Tierra Robada", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000},
    {"San Fierro", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000},
    {"Las Venturas", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000},
    {"Red County", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000},
    {"Los Santos", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000}}
    for i, v in ipairs(city) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return "Unknown"
end

-- ������ ������ �������


-- ������������� ����

imgui.OnInitialize(function()
    fa.Init()
    theme[decorListNumber[0]+1].change()
end)