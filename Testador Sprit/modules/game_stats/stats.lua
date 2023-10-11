ui = nil
updateEvent = nil

function init()
  ui = g_ui.loadUI('stats', modules.game_interface.getMapPanel())
  
  if not modules.client_options.getOption("showPing") then
    ui.fps:hide()
  end
  if not modules.client_options.getOption("showFps") then
    ui.ping:hide()
  end
  
  updateEvent = scheduleEvent(update, 200)
end

function terminate()
  removeEvent(updateEvent)
end

local lastPingUpdateTime = 0

function update()
  updateEvent = scheduleEvent(update, 500)
  if ui:isHidden() then return end

  -- Verificar se passou um minuto desde a última atualização do ping
  local currentTime = os.time()
  if currentTime - lastPingUpdateTime >= 60 then
    -- Simular a latência da rede com um atraso aleatório entre 30 e 100 ms
    local latency = math.random(30, 100)
    local totalLatency = latency + math.random(0, 20)  -- Introduzir alguma variabilidade adicional

    lastPingUpdateTime = currentTime  -- Atualizar o tempo da última atualização do ping

    local text = 'Ping: '
    local color
    if totalLatency >= 500 then
      text = text .. "??"
      color = 'red'
    else
      text = text .. totalLatency .. ' ms'
      if totalLatency >= 250 then
        color = 'yellow'
      else
        color = 'green'
      end
    end
    ui.ping:setText(text)
    ui.ping:setColor(color)
  end

  text = 'FPS: ' .. g_app.getFps()
  ui.fps:setText(text)
end


function show()
  ui:setVisible(true)
end

function hide()
  ui:setVisible(false)
end