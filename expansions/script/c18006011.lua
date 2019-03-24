--龙棋兵团突进阵型
if not pcall(function() require("expansions/script/c18006001") end) then require("script/c18006001") end
local m=18006011
local cm=_G["c"..m]
cm.rssetcode="DragonChessCorps"
function cm.initial_effect(c)
	local e1=rsdcc.Activate(c,m,nil,cm.op,cm.tg2)
	local e4=rsef.FV_REDIRECT(c,"leave",LOCATION_REMOVED,rsdcc.tg2,{LOCATION_ONFIELD ,LOCATION_ONFIELD })
	e4:SetLabel(0)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(cm.actcon)
	e3:SetValue(cm.aclimit)
	c:RegisterEffect(e3)  
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(rsdcc.tg)
	c:RegisterEffect(e2)  
end
function cm.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and rsdcc.tg(e,a)) or (d and rsdcc.tg(e,d))
end
function cm.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function cm.tg2(c,e,tp)
	return Duel.IsAbleToEnterBP()
end
function cm.op(e,tp)
	local c,tc=e:GetHandler(),rscf.GetTargetCard()
	if not tc then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end
