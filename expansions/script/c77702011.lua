local m=77702011
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.dfc_back_side=m-1
function cm.initial_effect(c)
	Senya.DFCBackSideCommonEffect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c)
		return c:IsType(TYPE_RITUAL) and c:IsLevelAbove(7)
	end)
	e2:SetValue(function(e)
		local tp=e:GetHandlerPlayer()
		return Duel.GetMatchingGroupCount(function(c)
			return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
		end,tp,LOCATION_GRAVE,0,nil)*300
	end)
	c:RegisterEffect(e2)
end
