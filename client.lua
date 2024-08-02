function hatarok(From, To, Title)
  local zone = lib.zones.sphere({
    coords = From,
    radius = 5.0,
    debug = Config.Debug,
    onEnter = function()
      lib.showTextUI('[E] Átkelés')
    end,
    inside = function()
      if IsControlJustPressed(0, 38) then
        local item = exports.ox_inventory:Search('slots', Config.Item)
        local count = 0
    
        for _, v in pairs(item) do
          count = count + v.count
        end
    
        if count > 0 then
          lib.showContext('hatar_menu' .. tostring(From))
        else
          lib.notify({
            title = 'Információ',
            description = 'Nincs nálad személyi!',
            type = 'error'
          })
        end
      end
    end,
    onExit = function()
      lib.hideTextUI()
    end
  })
  lib.registerContext({
    id = 'hatar_menu' .. tostring(From),
    title = tostring(Title),
    menu = 'some_menu',
    options = {
      {
        title = 'Átkelés a határon',
        description = 'Ahoz hogy átkelj a határon fizetned kell 1000$-t!',
        onSelect = function()
          local money = exports.ox_inventory:Search('count', 'money')
          local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
          local input = lib.inputDialog('Határ', {
            {type = 'checkbox', label = 'Pénz', disabled = money < Config.Price},
            {type = 'checkbox', label = 'Bank'}
          })
          if input and (input[1] or input[2]) then
            local alert = lib.alertDialog({
              header = 'Információ',
              content = 'Biztosan át szeretnél kelni?',
              centered = true,
              cancel = true
            })
            if alert == 'confirm' then
              if input[1] and money >= Config.Price then
                lib.callback.await('ls:removemoney', Config.Price)
              elseif input[2] then
                lib.callback.await('ls:removemoneybank')
              end
              DoScreenFadeOut(1000)
              Wait(1000)
              SetEntityCoords(vehicle, To)
              lib.notify({
                title = 'Információ',
                description = 'Átkeltél a határon',
                type = 'info'
              })
              DoScreenFadeIn(1000)
            end
          end
        end
      },
      {
        title = 'Rendvédelmi Átkelés',
        description = 'csak a rendvédelmi tagok',
        onSelect = function()
          local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
          if lib.callback.await('ls:checkjob') then
            DoScreenFadeOut(1000)
            Wait(1000)
            SetEntityCoords(vehicle, To)
            lib.notify({
              title = 'Információ',
              description = 'Átkeltél a határon',
              type = 'info'
            })
            DoScreenFadeIn(1000)
          else
            lib.notify({
              title = 'Hiba',
              description = 'Csak rendvédelmi tagok használhatják ezt!',
              type = 'error'
            })
          end
        end,
      },
    }
  })
end

for _, v in ipairs(Config.Hatarok) do
  hatarok(v.From, v.To, v.Title)

  print(v.From)
end
