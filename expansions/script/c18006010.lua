--龙棋兵团奇袭阵型
if not pcall(function() require("expansions/script/c18006001") end) then require("script/c18006001") end
local m=18006010
local cm=_G["c"..m]
cm.rssetcode="DragonChessCorps"
function cm.initial_effect(c)
	local e1=rsdcc.Activate(c,m,nil,cm.op,cm.tg2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.drcon)
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.thcon)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.thcon(e,tp,eg)
	return eg:IsExists(cm.cfilter,1,nil,e:GetHandler())
end
function cm.cfilter(c,rc)
	local seq=c:GetPreviousSequence()
	if c:GetPreviousControler()~=tp then seq=seq+16 end
	return c:IsPreviousLocation(LOCATION_ONFIELD) and bit.extract(rc:GetColumnZone(LOCATION_ONFIELD),seq)~=0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,nil)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rsdcc.IsSet(c)
end
function cm.thop(e,tp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetColumnGroup():IsContains(e:GetHandler())
end
function cm.drop(e,tp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.tg2(c,e,tp)
	return Duel.IsAbleToEnterBP()
end
function cm.op(e,tp)
	local c,tc=e:GetHandler(),rscf.GetTargetCard()
	if not tc then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end
