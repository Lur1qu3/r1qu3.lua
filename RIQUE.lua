setDefaultTab("riq")


UI.Button("[M] [A] [C] [R] [O] [S]", function(newText)
    UI.MultilineEditorWindow(storage.ingame_hotkeys or "", {title="RIQUEZIN", description="Discord: riquezerah"}, function(text)
      storage.ingame_hotkeys = text
      reload()
    end)
  end)
  
  
  for _, scripts in pairs({storage.ingame_hotkeys}) do
    if type(scripts) == "string" and scripts:len() > 3 then
      local status, result = pcall(function()
        assert(load(scripts, "ingame_editor"))()
      end)
      if not status then 
        error("Ingame edior error:\n" .. result)
      end
    end
  end



if type(storage.manatrainer) ~= "table" then
  storage.manatrainer = {on=false, title="mana%", text="Power Down", min=0, max=90}
end

for _, healingInfos in ipairs({storage.manatrainer}) do
  local healingmacro = macro(20, function()
    local mana = manapercent()
    if healingInfos.max <= mana and mana >= healingInfos.min then
      if TargetBot then 
        TargetBot.saySpell(healingInfos.text)
      else
        say(healingInfos.text)
      end
    end
  end)
  healingmacro.setOn(healingInfos.on)

  UI.DualScrollPanel(healingInfos, function(widget, newParams) 
    healingInfos = newParams
    healingmacro.setOn(healingInfos.on)
  end)
end 



macro(250, "Dance", function()

    turn(math.random(0, 3))

 end, warTab)



staminaRefinarEM = tonumber(storage.hora)
idDaStamina = tonumber(storage.id)

macro(50, 'Stamine', function()
    if stamina() <= staminaRefinarEM * 60 then
        useWith(idDaStamina, player)
        return delay(500)
    end
end)

local checkAol = storage.idDoAol
macro(3000, "Comprar AOL", function()
  if getFinger() and getFinger():getId(checkAol) then return end
  say(storage.buyaol)
end)


macro(100, "Invit PT", function()
for i,v in ipairs (getSpectators(posz())) do
    if v ~= player and v:isPlayer() and v:getShield() == 0 and v:getEmblem() == 1 then
        g_game.partyInvite(v:getId())
    end
end
end)



macro(100, "Accept PT", function()
for i,v in ipairs (getSpectators(posz())) do
    if v ~= player and v:isPlayer() and v:getShield() == 1 and v:getEmblem() == 1 then
        g_game.partyJoin(v:getId())
    end
end
end)


followName = "autofollow"
if not storage[followName] then storage[followName] = { player = 'name'} end
local toFollowPos = {}







local followChange = macro(1000, "FOLLOW",  function()
local followw= storage[followName].player 
    if g_game.isFollowing() then
        return
    end
    for _, followcreature in ipairs(g_map.getSpectators(pos(), false)) do
        if (followcreature:getName() == followw and getDistanceBetween(pos(), followcreature:getPosition()) <= 8) then
            g_game.follow(followcreature)
        end
    end
end) 

local followMacro = macro(20, "SEGUIR", function()
    local target = getCreatureByName(storage[followName].player)
    if target then
        local tpos = target:getPosition()
        toFollowPos[tpos.z] = tpos
    end
    if player:isWalking() then
        return
    end
    local p = toFollowPos[posz()]
    if not p then
        return
    end
    if autoWalk(p, 20, { ignoreNonPathable = true, precision = 1 }) then
        delay(100)
    end
end)
UI.Separator()
onPlayerPositionChange(function(newPos, oldPos)
  if followChange:isOff() then return end
  if (g_game.isFollowing()) then
    tfollow = g_game.getFollowingCreature()

    if tfollow then
      if tfollow:getName() ~= storage[followName].player then
        followTE:setText(tfollow:getName())
        storage[followName].player = tfollow:getName()
      end
    end
  end
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
    if creature:getName() == storage[followName].player and newPos then
        toFollowPos[newPos.z] = newPos
    end
end) 

followTE = UI.TextEdit(storage[followName].player or "name", function(widget, newText)
    storage[followName].player = newText
end)














---

hotkey("T", "senseTarget", function()
if sense then 
say('sense "' .. sense )
end
end)


macro(1, function() if g_game.isAttacking() and g_game.getAttackingCreature():isPlayer() then sense = g_game.getAttackingCreature():getName() end end)


----

macro(1, 'XSense', function()
  if storage.Sense then
      locatePlayer = getPlayerByName(storage.Sense)
      if not (locatePlayer and locatePlayer:getPosition().z == player:getPosition().z and getDistanceBetween(pos(), locatePlayer:getPosition()) <= 6) then
          say('sense "' .. storage.Sense)
          delay(500)
      end
  end
end)


onTalk(function(name, level, mode, text, channelId, pos)
  if player:getName() == name then
      if string.sub(text, 1, 1) == 'x' then
          local checkMsg = string.sub(text, 2):trim()
          if checkMsg == '0' then
              storage.Sense = false
          else
              storage.Sense = checkMsg
          end
      end
  end
end)



--INICIO PAINEL TRAVEL

g_ui.loadUIFromString([[


ViajeWindow < MainWindow
  !text: tr('Travel')
  font: verdana-11px-rounded
  size: 380 310
  padding: 25
  color: green
  @onEscape: self:hide()

  Button
    id: edite
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    text-align: center
    margin-bottom: -5
    margin-right: 115
    font: verdana-11px-rounded
    text: Edite
    color: green
    !tooltip: tr('Editar Travel')

  Label
    id: stoppp
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    text-align: center
    margin-bottom: -20
    margin-right: 110
    font: verdana-11px-rounded
    text: Discord: riquezerah
    color: green


  Label
    id: stopppp
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    text-align: center
    margin-bottom: 20
    margin-right: 80
    font: verdana-11px-rounded
    text: Para abrir aperte-> Shift+V
    color: white 

  Label
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    font: verdana-11px-rounded

    anchors.top: parent.top
    text-align: center
    margin-top: 4
    text: Viajar
    color: green

  Label
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    margin-top: 4
    font: verdana-11px-rounded
    text: Viajar
    color: green


  VerticalScrollBar
    id: contentScroll
    anchors.top: prev.bottom
    margin-top: 3
    anchors.right: parent.right
    anchors.bottom: separator.top
    step: 28
    pixels-scroll: true
    margin-right: -10
    margin-top: 18
    margin-bottom: 16

  ScrollablePanel
    id: content
    anchors.top: prev.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: separator.top
    vertical-scrollbar: contentScroll
    margin-bottom: 15
      
    Panel
      id: left
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.horizontalCenter
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true
    image-source: /imagens/x_x

    Panel
      id: right
      anchors.top: parent.top
      anchors.left: parent.horizontalCenter
      anchors.right: parent.right
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true


  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top   

  Button
    id: closeButton
    !text: tr('X')
    color: red
    font: verdana-11px-rounded
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 49 21
    margin-top: 16
    margin-right: 5
    margin-bottom: 0
    !tooltip: tr('Fechar')




]])



local panelName = "viaje"
local ui = setupUI([[
Panel

  height: 30

  Button
    id: editMusica
    font: verdana-11px-rounded
    color: green
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 30
    text: Travel

  ]], parent)
  ui:setId(PanelName)




if not storage[panelName] then
  storage[panelName] = {
}
end

local settings = storage[panelName]


viajeWindow = UI.createWindow('ViajeWindow', rootWidget)
viajeWindow:hide()

viajeWindow.closeButton.onClick = function(widget)
  viajeWindow:hide()
end

modules.game_interface.addMenuHook("category", "Viaje",
  function()
          viajeWindow:show()
  end,
  function(menuPosition, lookThing, useThing, creatureThing)
    if creatureThing and creatureThing == player then
      return true
    end
    return false
  end
)

modules.game_interface.addMenuHook("category", "Painel de Magias",
  function()
          say(storage.magiaatalho)
  end,
  function(menuPosition, lookThing, useThing, creatureThing)
    if creatureThing and creatureThing == player then
      return true
    end
    return false
  end
)


local rightPanel = viajeWindow.content.right
local leftPanel = viajeWindow.content.left

ui.editMusica.onClick = function(widget)
  viajeWindow:show()
  viajeWindow:raise()
  viajeWindow:focus()
end


onKeyPress(function(keys)
if keys == 'Shift+V' then
  viajeWindow:show()
end
end)

UI.Button(storage.cidade1, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidade1)
end)
schedule(900, function()
NPC.say("yes")
end)
end,leftPanel)

UI.Button(storage.cidade2, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidade2)
end)
schedule(900, function()
NPC.say("yes")
end)
end,leftPanel)

UI.Button(storage.cidade3, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidade3)
end)
schedule(900, function()
NPC.say("yes")
end)
end,leftPanel)

UI.Button(storage.cidade4, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidade4)
end)
schedule(900, function()
NPC.say("yes")
end)
end,leftPanel)

UI.Button(storage.cidade5, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidade5)
end)
schedule(900, function()
NPC.say("yes")
end)
end,leftPanel)

UI.Button(storage.cidade6, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidade6)
end)
schedule(900, function()
NPC.say("yes")
end)
end,leftPanel)


UI.Button(storage.cidade7, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidade7)
end)
schedule(900, function()
NPC.say("yes")
end)
end,leftPanel)

UI.Button(storage.cidade8, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidade8)
end)
schedule(900, function()
NPC.say("yes")
end)
end,leftPanel)

UI.Button(storage.cidade9, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidade9)
end)
schedule(900, function()
NPC.say("yes")
end)
end,leftPanel)



UI.Button(storage.cidades1, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidades1)
end)
schedule(900, function()
NPC.say("yes")
end)
end,rightPanel)

UI.Button(storage.cidades2, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidades2)
end)
schedule(900, function()
NPC.say("yes")
end)
end,rightPanel)

UI.Button(storage.cidades3, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidades3)
end)
schedule(900, function()
NPC.say("yes")
end)
end,rightPanel)

UI.Button(storage.cidades4, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidades4)
end)
schedule(900, function()
NPC.say("yes")
end)
end,rightPanel)

UI.Button(storage.cidades5, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidades5)
end)
schedule(900, function()
NPC.say("yes")
end)
end,rightPanel)

UI.Button(storage.cidades6, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidades6)
end)
schedule(900, function()
NPC.say("yes")
end)
end,rightPanel)


UI.Button(storage.cidades7, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidades7)
end)
schedule(900, function()
NPC.say("yes")
end)
end,rightPanel)

UI.Button(storage.cidades8, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidades8)
end)
schedule(900, function()
NPC.say("yes")
end)
end,rightPanel)

UI.Button(storage.cidades9, function()
NPC.say("hi")
schedule(500, function()
NPC.say(storage.cidades9)
end)
schedule(900, function()
NPC.say("yes")
end)
end,rightPanel)










g_ui.loadUIFromString([[

CidadesWindow < MainWindow
  !text: tr('Edits Citys')
  font: verdana-11px-rounded
  size: 300 310
  padding: 25
  color: green
  @onEscape: self:hide()


  Label
    id: stoppp
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    text-align: center
    margin-bottom: 0
    margin-right: 115
    font: verdana-11px-rounded
    text: riquezerah
    color: green

  Label
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    font: verdana-11px-rounded

    anchors.top: parent.top
    text-align: center
    margin-top: 4
    text: Viajar
    color: green

  Label
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    margin-top: 4
    font: verdana-11px-rounded
    text: Viajar
    color: green


  VerticalScrollBar
    id: contentScroll
    anchors.top: prev.bottom
    margin-top: 3
    anchors.right: parent.right
    anchors.bottom: separator.top
    step: 28
    pixels-scroll: true
    margin-right: -10
    margin-top: 13
    margin-bottom: 16

  ScrollablePanel
    id: content
    anchors.top: prev.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: separator.top
    vertical-scrollbar: contentScroll
    margin-bottom: 15
      
    Panel
      id: left
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.horizontalCenter
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true
    image-source: /imagens/x_x3

    Panel
      id: right
      anchors.top: parent.top
      anchors.left: parent.horizontalCenter
      anchors.right: parent.right
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true


  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top   

  Button
    id: closeButton
    !text: tr('X')
    color: red
    font: verdana-11px-rounded
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 49 21
    margin-top: 16
    margin-right: 5
    margin-bottom: 0 
    !tooltip: tr('Fechar')


  ]])



  local panelName = "cidade"
local ui = setupUI([[
Panel



  ]], parent)
  ui:setId(PanelName)

if not storage[panelName] then
  storage[panelName] = {
}
end

local settings = storage[panelName]


cidadesWindow = UI.createWindow('CidadesWindow', rootWidget)
cidadesWindow:hide()

cidadesWindow.closeButton.onClick = function(widget)
  cidadesWindow:hide()
end




-- available options for dest param
local rightPanel = cidadesWindow.content.right
local leftPanel = cidadesWindow.content.left

viajeWindow.edite.onClick = function(widget)
  cidadesWindow:show()
  cidadesWindow:raise()
  cidadesWindow:focus()
end





UI.TextEdit(storage.cidade1 or "Cidade 1", function(widget, text)    
  storage.cidade1 = text
end,leftPanel)

UI.TextEdit(storage.cidade2 or "Cidade 2", function(widget, text)    
  storage.cidade2 = text
end,leftPanel)

UI.TextEdit(storage.cidade3 or "Cidade 3", function(widget, text)    
  storage.cidade3 = text
end,leftPanel)

UI.TextEdit(storage.cidade4 or "Cidade 4", function(widget, text)    
  storage.cidade4 = text
end,leftPanel)

UI.TextEdit(storage.cidade5 or "Cidade 5", function(widget, text)    
  storage.cidade5 = text
end,leftPanel)

UI.TextEdit(storage.cidade6 or "Cidade 6", function(widget, text)    
  storage.cidade6 = text
end,leftPanel)

UI.TextEdit(storage.cidade7 or "Cidade 7", function(widget, text)    
  storage.cidade7 = text
end,leftPanel)

UI.TextEdit(storage.cidade8 or "Cidade 8", function(widget, text)    
  storage.cidade8 = text
end,leftPanel)

UI.TextEdit(storage.cidade9 or "Cidade 9", function(widget, text)    
  storage.cidade9 = text
end,leftPanel)



UI.TextEdit(storage.cidades1 or "Cidade 1", function(widget, text)    
  storage.cidades1 = text
end,rightPanel)

UI.TextEdit(storage.cidades2 or "Cidade 2", function(widget, text)    
  storage.cidades2 = text
end,rightPanel)

UI.TextEdit(storage.cidades3 or "Cidade 3", function(widget, text)    
  storage.cidades3 = text
end,rightPanel)

UI.TextEdit(storage.cidades4 or "Cidade 4", function(widget, text)    
  storage.cidades4 = text
end,rightPanel)

UI.TextEdit(storage.cidades5 or "Cidade 5", function(widget, text)    
  storage.cidades5 = text
end,rightPanel)

UI.TextEdit(storage.cidades6 or "Cidade 6", function(widget, text)    
  storage.cidades6 = text
end,rightPanel)

UI.TextEdit(storage.cidades7 or "Cidade 7", function(widget, text)    
  storage.cidades7 = text
end,rightPanel)

UI.TextEdit(storage.cidades8 or "Cidade 8", function(widget, text)    
  storage.cidades8 = text
end,rightPanel)

UI.TextEdit(storage.cidades9 or "Cidade 9", function(widget, text)    
  storage.cidades9 = text
end,rightPanel)


--INICIO PAINEL MACROS



local PainelPanelName = "listt"
  local ui = setupUI([[
Panel

  height: 25

  Button
    id: editPainel
    font: verdana-11px-rounded
    color: green
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 25
    text: Macros
    !tooltip: tr('Abrir Macros')

  ]], parent)
  ui:setId(PaineltroPanelName)

  if not storage[PainelPanelName] then
    storage[PainelPanelName] = { 

    }
  end

rootWidget = g_ui.getRootWidget()
if rootWidget then
    PainelsWindow = UI.createWidget('PainelWindow', rootWidget)
    PainelsWindow:hide()
    TabBar = PainelsWindow.paTabBar
    TabBar:setContentWidget(PainelsWindow.paImagem)
   for v = 1, 1 do





hpPanel = g_ui.createWidget("hpPanel") -- Creates Panel
hpPanel:setId("panelButtons") -- sets ID

hpPanel2 = g_ui.createWidget("hpPanel") -- Creates Panel
hpPanel2:setId("2") -- sets ID

hpPanel3 = g_ui.createWidget("hpPanel") -- Creates Panel
hpPanel:setId("panelButtons") -- sets ID

hpPanel4 = g_ui.createWidget("hpPanel") -- Creates Panel
hpPanel:setId("panelButtons") -- sets ID

hpPanel5 = g_ui.createWidget("hpPanel") -- Creates Panel
hpPanel:setId("panelButtons") -- sets ID

hpPanel6 = g_ui.createWidget("hpPanel") -- Creates Panel
hpPanel:setId("panelButtons") -- sets ID

hpPanel7 = g_ui.createWidget("hpPanel") -- Creates Panel
hpPanel:setId("panelButtons") -- sets ID

hpPanel8 = g_ui.createWidget("hpPanel") -- Creates Panel
hpPanel:setId("panelButtons") -- sets ID

TabBar:addTab("HP", hpPanel)
        color= UI.Label()
color:setColor("green")
color= UI.Label("Cura",hpPanel)
color:setColor("green")

if type(storage.heal) ~= "table" then
  storage.heal = {on=false, title="HP%", text="big regeneration", min=0, max=99}
end
if type(storage.heal2) ~= "table" then
  storage.heal2 = {on=false, title="HP%", text="regeneration", min=0, max=99}
end

-- create 2 healing widgets
for _, healingInfo in ipairs({storage.heal, storage.heal2}) do
  local healingmacro = macro(200, function()
    local hp = player:getHealthPercent()
    if healingInfo.max >= hp and hp >= healingInfo.min then
      if TargetBot then 
        TargetBot.saySpell(healingInfo.text) -- sync spell with targetbot if available
      else
        say(healingInfo.text)
      end
    end
  end,hpPanel)
  healingmacro.setOn(healingInfo.on)

  UI.DualScrollPanel(healingInfo, function(widget, newParams) 
    healingInfo = newParams
    healingmacro.setOn(healingInfo.on)
  end,hpPanel)
end

TabBar:addTab("Use", hpPanel2)
        color= UI.Label()
color:setColor("green")
        color= UI.Label("Use Items",hpPanel2)
color:setColor("green")
        UI.Separator(hpPanel2)
Panels.HealthItem(hpPanel2)
        UI.Separator(hpPanel2)
Panels.ManaItem(hpPanel2)

TabBar:addTab("Sup1", hpPanel3)
        color= UI.Label()
color:setColor("green")

UI.Label('Mode Barry Allen',hpPanel3):setColor('green')

addTextEdit("hasteSpell", storage.hasteSpell or "Super speed", function(widget, text)
    storage.hasteSpell = text
end,hpPanel3)


macro(1, function()
    local isSealed = storage.sealedTypes and storage.sealedTypes.speed and storage.sealedTypes.speed >= os.time();
    if (not isSealed and not hasHaste() and (hppercent() >= 50)) then
        say(storage.hasteSpell);
    end
end,hpPanel3)


UI.Label('Magia Buff/Msg Laranja/Coldown',hpPanel3)

UI.TextEdit(storage.buffzmagia or "Buffs", function(widget, newText)
  storage.buffzmagia = newText
end,hpPanel3)



UI.TextEdit(storage.buffzmsg or "Buffsmsg", function(widget, newText)
  storage.buffzmsg = newText
end,hpPanel3)



UI.TextEdit(storage.buffzcd or "Buffs", function(widget, newText)
  storage.buffzcd = newText
end,hpPanel3)


TabBar:addTab("Combo", hpPanel4)
        color= UI.Label()
color:setColor("green")
        color= UI.Label("Combos",hpPanel4)
color:setColor("green")

addTextEdit("30%", storage.Magia1 or "30%", function(widget, text) storage.Magia1 = text
end,hpPanel4)

addTextEdit("Magia1", storage.Magia2 or "Magia1", function(widget, text) storage.Magia2 = text
end,hpPanel4)


addTextEdit("Magia2", storage.Magia3 or "Magia2", function(widget, text) storage.Magia3 = text
end,hpPanel4)


addTextEdit("Magia3", storage.Magia4 or "Magia3", function(widget, text) storage.Magia4 = text
end,hpPanel4)


addTextEdit("Magia4", storage.Magia5 or "Magia4", function(widget, text) storage.Magia5 = text
end,hpPanel4)

addTextEdit("canudo", storage.rique or "canudo", function(widget, text) storage.rique = text
end,hpPanel4)


addIcon("COMBO", {item=671, movable=true, text = "COMBO"}, percent)
end
end




TabBar:addTab("Sup2", hpPanel5)
        color= UI.Label()
color:setColor("green")
        color= UI.Label("Suportes",hpPanel5)
color:setColor("green")



local lastManaShield = 0
mysticfull = macro(20, "Mystic Full", function() 
  if hasManaShield() or lastManaShield + 90000 > now then return end
  if TargetBot then 
    TargetBot.saySpell(storage.manaShield) -- sync spell with targetbot if available
  else
    say(storage.manaShield)
  end
end,hpPanel5)
UI.TextEdit(storage.manaShield or "utamo vita", function(widget, newText)
  storage.manaShield = newText
end,hpPanel5)

addIcon("Mystic Full", {item=12685, movable=true, text = "Mystic Full"}, mysticfull)

UI.Label('TargetSay//Reflect',hpPanel5)
UI.TextEdit(storage.saytarget or "Buffs", function(widget, newText)
  storage.saytarget = newText
end,hpPanel5)


UI.TextEdit(storage.reflect or "Buffs", function(widget, newText)
  storage.reflect = newText
end,hpPanel5)


TabBar:addTab("Fuga", hpPanel6)
        color= UI.Label()
color:setColor("green")
color= UI.Label("Macros Fugitivas:",hpPanel6)
color:setColor("green")

local spellName = storage.fuga
local hpPercent = tonumber(storage.percent)
macro(100, "Primeira Fuga", function()
  if (hppercent() <= hpPercent) then
    say(spellName)
   end
end,hpPanel6)


local spellName = storage.fuga2
local hpPercent = tonumber(storage.percent2)
macro(100, "Segunda Fuga", function()
  if (hppercent() <= hpPercent) then
    say(spellName)
   end
end,hpPanel6)


local spellName = storage.fuga3
local hpPercent = tonumber(storage.percent3)
macro(100, "Terceira Fuga", function()
  if (hppercent() <= hpPercent) then
    say(spellName)
   end
end,hpPanel6)
 

TabBar:addTab("Storag", hpPanel7)
        color= UI.Label()
color:setColor("green")
        color= UI.Label("Spell e Percent",hpPanel7)
color:setColor("green")



addTextEdit("fuga", storage.fuga or "fuga", function(widget, text) storage.fuga = text
end,hpPanel7)

addTextEdit("fuga", storage.percent or "50", function(widget, text) storage.percent = text
end,hpPanel7)


addTextEdit("fuga", storage.fuga2 or "fuga", function(widget, text) storage.fuga2 = text
end,hpPanel7)

addTextEdit("fuga", storage.percent2 or "50", function(widget, text) storage.percent2 = text
end,hpPanel7)


addTextEdit("fuga", storage.fuga3 or "fuga", function(widget, text) storage.fuga3 = text
end,hpPanel7)

addTextEdit("fuga", storage.percent3 or "50", function(widget, text) storage.percent3 = text
end,hpPanel7)


  PainelsWindow.closeButton.onClick = function(widget)
    PainelsWindow:hide()
  end



  
ui.editPainel.onClick = function(widget)
    PainelsWindow:show()
    PainelsWindow:raise()
    PainelsWindow:focus()
  end
--FIM DO PAINEL

checkFrag = macro(100, function()
    say("!frags")
    checkFrag.setOff()
end)
addIcon("Frags", {item =685, text = "Frags"}, checkFrag)

StopOn = macro(500, function()
if CaveBot.isOn() or TargetBot.isOn() then
CaveBot.setOff()
TargetBot.setOff()
StopOn.setOff()
elseif CaveBot.isOff() or TargetBot.isOff() then
CaveBot.setOn()
TargetBot.setOn()
StopOn.setOff()
end
end)

addIcon("On/Off", {item =664, text = "On/Off"}, StopOn)




local cIcon = addIcon("cI",{text="Cave\nBot",switchable=false,moveable=true}, function()
  if CaveBot.isOff() then 
    CaveBot.setOn()
  else 
    CaveBot.setOff()
  end
end)
cIcon:setSize({height=30,width=50})
cIcon.text:setFont('verdana-11px-rounded')

local tIcon = addIcon("tI",{text="Target\nBot",switchable=false,moveable=true}, function()
  if TargetBot.isOff() then 
    TargetBot.setOn()
  else 
    TargetBot.setOff()
  end
end)
tIcon:setSize({height=30,width=50})
tIcon.text:setFont('verdana-11px-rounded')

macro(50,function()
  if CaveBot.isOn() then
    cIcon.text:setColoredText({"Cave\n","white","ON","green"})
  else
    cIcon.text:setColoredText({"Cave\n","white","OFF","red"})
  end
  if TargetBot.isOn() then
    tIcon.text:setColoredText({"Target\n","white","ON","green"})
  else
    tIcon.text:setColoredText({"Target\n","white","OFF","red"})
  end
end)




