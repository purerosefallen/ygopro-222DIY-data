Sekka=Sekka or {}
local cm=Sekka

function cm.IsLap(c)
	local codet={c:GetCode()}
	for i,code in pairs(codet) do
		local mt=_G["c"..code]
		if not mt then
			_G["c"..code]={}
			if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
				mt=_G["c"..code]
				_G["c"..code]=nil
			else
				_G["c"..code]=nil
			end
		end
		if mt and mt.Sekka_name_with_lap then return true end
	end
	return false
end
function cm.LapGlobalCheck()
	if cm.lap_check_list then return end
	cm.lap_check_list={}
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DISCARD)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return #eg>0
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local turn=Duel.GetTurnCount()
		if not cm.lap_check_list[turn] then
			cm.lap_check_list[turn]={[0]=0,[1]=0}
		end
		for tc in aux.Next(eg) do
			local p=tc:GetControler()
			cm.lap_check_list[turn][p]=cm.lap_check_list[turn][p]+1
		end
	end)
	Duel.RegisterEffect(e1,0)
end
