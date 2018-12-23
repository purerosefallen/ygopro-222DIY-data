local m=77707026
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(function(e,c)
		return cm[e:GetHandlerPlayer()][c:GetCode()] and (cm[e:GetHandlerPlayer()][c:GetCode()]+1)*400 or 400
	end)
	c:RegisterEffect(e2)
	if not cm.gchk then
		cm.gchk=true
		cm[0]={}
		cm[1]={}
		local ex=Effect.GlobalEffect()
		ex:SetType(EFFECT_TYPE_FIELD)
		ex:SetCode(EVENT_SPSUMMON_SUCCESS)
		ex:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local done_={[0]={},[1]={}}
			for tc in aux.Next(eg) do
				if not done_[tc:GetSummonPlayer()][tc:GetCode()] then
					if cm[tc:GetSummonPlayer()][tc:GetCode()] then
						cm[tc:GetSummonPlayer()][tc:GetCode()]=cm[tc:GetSummonPlayer()][tc:GetCode()]+1
					else
						cm[tc:GetSummonPlayer()][tc:GetCode()]=1
					end
					done_[tc:GetSummonPlayer()][tc:GetCode()]=true
				end
			end
		end)
		Duel.RegisterEffect(ex,0)
		local ex=Effect.GlobalEffect()
		ex:SetType(EFFECT_TYPE_FIELD)
		ex:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ex:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			cm[0]={}
			cm[1]={}
		end)
		Duel.RegisterEffect(ex,0)
	end
end
